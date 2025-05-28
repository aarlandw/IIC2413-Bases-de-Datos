-- \set ON_ERROR_STOP on
-- \echo 'Raw tables:'

-- Create temp table with the columns from the CSV


DROP TABLE IF EXISTS 
persona_raw,
valid_person,
agenda_reserva_raw,
reserva_valid,
correo_por_reserva,
review_seguro_raw,
review_persona_raw,
agenda_valid;


CREATE TEMP TABLE persona_raw (
    nombre             TEXT,
    correo             TEXT,
    contrasena         TEXT,
    username           TEXT,
    telefono_contacto  TEXT,
    run                TEXT,
    puntos             INTEGER,
    jornada            TEXT,
    isapre             TEXT,
    contrato           TEXT,
    dv                 CHAR(1)
);

-- Specify the columns to import from the CSV
\copy persona_raw FROM '../csv/personas.csv' CSV HEADER;

-- ✂︎ 1.1  PERSONAS DESCARTADAS
COPY (
  SELECT * FROM persona_raw
  WHERE correo IS NULL 
  OR nombre IS NULL
  OR contrasena IS NULL
  OR username IS NULL
  OR run IS NULL 
  OR length(run) != 8 
  OR run::INTEGER < 0
  OR dv IS NULL 
  OR length(dv) != 1
) TO STDOUT with CSV HEADER
\g '../descartados/personas_descartados.csv' CSV HEADER;


CREATE TEMP TABLE valid_person AS (
  SELECT *
  FROM persona_raw
  WHERE correo IS NOT NULL
    AND nombre IS NOT NULL
    AND contrasena IS NOT NULL
    AND username IS NOT NULL
    AND run IS NOT NULL 
    AND LENGTH(run) = 8 
    AND run::INTEGER >= 0
    AND dv IS NOT NULL AND length(dv) = 1 AND dv ~ '^[0-9Kk]$'
);

INSERT INTO persona (correo, nombre, contrasena, username, telefono_contacto, run, dv)
SELECT correo, nombre, contrasena, username, telefono_contacto, run, dv
FROM valid_person
ON CONFLICT DO NOTHING;


-- Usuario -- 
COPY (
  SELECT * FROM valid_person
  WHERE puntos IS NULL 
  OR puntos < 0
) TO STDOUT with CSV HEADER
\g '../descartados/usuarios_descartados.csv' CSV HEADER;

INSERT INTO usuario (correo, puntos)
SELECT correo, puntos
FROM valid_person
WHERE puntos IS NOT NULL 
  AND puntos >= 0
ON CONFLICT DO NOTHING;

-- Empleados --
COPY (
    SELECT * FROM valid_person 
    WHERE jornada IS NULL 
    OR isapre IS NULL 
    OR contrato IS NULL
    OR jornada NOT IN ('Diurno', 'Nocturno')
    OR isapre NOT IN (
        'Más vida',
        'Colmena',
        'Consalud',
        'Banmédica',
        'Banmedica',
        'Fonasa'
    )
    OR contrato NOT IN (
        'full-time',
        'part-time',
        'Full time',
        'Part time',
        'Full Time',
        'Part Time'
    )
) TO STDOUT with CSV HEADER
\g '../descartados/empleados_descartados.csv' CSV HEADER;


INSERT INTO empleado (correo, jornada, isapre, contrato)
SELECT correo, jornada, isapre, contrato
FROM valid_person
WHERE jornada IN ('Diurno', 'Nocturno')
  AND isapre IN (
      'Más vida',
      'Colmena',
      'Consalud',
      'Banmédica',
      'Banmedica',
      'Fonasa'
  )
  AND contrato IN (
      'full-time',
      'part-time',
      'Full time',
      'Part time',
      'Full Time',
      'Part Time'
  )
ON CONFLICT DO NOTHING;





--------------------------------
-- Agenda - Reserva --
--------------------------------
DROP TABLE IF EXISTS agenda_reserva_raw;
CREATE TEMP TABLE agenda_reserva_raw (
    agenda_id INTEGER,
    etiqueta TEXT,
    reserva_id INTEGER,
    fecha DATE,
    monto INTEGER,
    cantidad_personas INTEGER,
    estado_disponibilidad TEXT,
    puntos_booked INTEGER,
    --- Transporte ---
    correo_empleado TEXT,
    lugar_origen TEXT,
    lugar_llegada TEXT,
    capacidad INTEGER,
    tiempo_estimado INTEGER,
    precio_asiento INTEGER,
    empresa TEXT,
    fecha_salida DATE,
    fecha_llegada DATE,
    tipo_bus TEXT,
    comodidades TEXT[],
    escalas TEXT[],
    clase TEXT,
    paradas TEXT[],
    --- Hospedaje ---
    nombre_hospedaje TEXT,
    ubicacion TEXT,
    precio_noche INTEGER,
    estrellas INTEGER,
    fecha_checkin DATE,
    fecha_checkout DATE,
    politicas TEXT[],
    nombre_anfitrion TEXT,
    contacto_anfitrion TEXT,
    descripcion_airbnb TEXT,
    piezas INTEGER,
    camas INTEGER,
    banos INTEGER,
    --- Panorama ---
    nombre_panorama TEXT,
    duracion INTEGER,
    precio_persona INTEGER,
    restricciones TEXT[],
    fecha_panorama DATE
);
\copy agenda_reserva_raw FROM '../csv/agenda_reserva.csv' CSV HEADER;

CREATE TEMP TABLE review_seguro_raw (
  correo_usuario TEXT,
  puntos INTEGER,
  reserva_id INTEGER,
  tipo_seguro TEXT,
  valor_seguro INTEGER,
  clausula TEXT,
  empresa_seguro TEXT,
  estrellas INTEGER,
  descripcion TEXT
);
\copy review_seguro_raw FROM '../csv/review_seguro.csv' CSV HEADER;

--- Merging the data since agenda_reserva_raw does not contain the correo_usuario
CREATE TEMP TABLE correo_por_reserva AS (
  SELECT DISTINCT reserva_id, correo_usuario
  FROM review_seguro_raw
  WHERE correo_usuario IS NOT NULL
  AND reserva_id IS NOT NULL
);

ALTER TABLE agenda_reserva_raw ADD COLUMN correo_usuario TEXT;
UPDATE agenda_reserva_raw ar
SET correo_usuario = c.correo_usuario
FROM correo_por_reserva c
WHERE ar.reserva_id = c.reserva_id;


--  -- Agenda
COPY (
  SELECT * FROM agenda_reserva_raw
  WHERE agenda_id IS NULL
    OR correo_usuario IS NULL
) TO STDOUT with CSV HEADER 
\g '../descartados/agendas_descartados.csv' CSV HEADER;

CREATE TEMP TABLE agenda_valid AS (
  SELECT * FROM agenda_reserva_raw
  WHERE agenda_id IS NOT NULL
    AND correo_usuario IS NOT NULL
    AND correo_usuario IN (
        SELECT correo FROM usuario -- Only validating the agenda iff there exists a user with corresponding correo.
    )
    AND etiqueta IS NOT NULL
);

INSERT INTO agenda (id, correo_usuario, etiqueta)
SELECT agenda_id, correo_usuario, etiqueta
FROM agenda_valid
ON CONFLICT DO NOTHING;


--  -- Reservas 
COPY (
  SELECT * FROM agenda_reserva_raw
  WHERE reserva_id IS NULL 
  OR fecha IS NULL 
  OR monto IS NULL
  OR monto < 0
  OR cantidad_personas IS NULL
  OR cantidad_personas < 0
  OR estado_disponibilidad IS NULL 
  OR estado_disponibilidad NOT IN ('Disponible', 'No disponible')
  OR puntos_booked IS NULL 
  OR puntos_booked < 0
  OR correo_usuario NOT IN (SELECT correo FROM usuario)
) TO STDOUT with CSV HEADER
\g '../descartados/reservas_descartados.csv' CSV HEADER;


DROP TABLE IF EXISTS reserva_valid;
CREATE TEMP TABLE reserva_valid AS (
  SELECT * from agenda_reserva_raw
  WHERE reserva_id IS NOT NULL
    AND fecha IS NOT NULL
    AND monto IS NOT NULL
    AND monto >= 0
    AND cantidad_personas IS NOT NULL
    AND cantidad_personas >= 0
    AND estado_disponibilidad IS NOT NULL
    AND estado_disponibilidad IN ('Disponible', 'No disponible')
    AND puntos_booked IS NOT NULL
    AND puntos_booked >= 0
    AND (
      agenda_id IN (SELECT id FROM agenda)
      OR agenda_id IS NULL
    )
    -- Only allow 'No disponible' if agenda_id is NOT NULL and vice versa.
    AND (
      (estado_disponibilidad = 'No disponible' AND agenda_id IS NOT NULL)
      OR
      (estado_disponibilidad = 'Disponible' AND agenda_id IS NULL)
    ) 
);

INSERT INTO reserva (id, agenda_id, fecha, monto, cantidad_personas, estado_disponibilidad, puntos_booked)
SELECT reserva_id, agenda_id, fecha, monto, cantidad_personas, estado_disponibilidad, puntos_booked
FROM reserva_valid
ON CONFLICT DO NOTHING;


-- -- Seguro
COPY (
  SELECT * FROM review_seguro_raw
  WHERE reserva_id IS NULL
  OR correo_usuario NOT IN (SELECT correo FROM usuario)
  OR tipo_seguro IS NULL
  OR valor_seguro IS NULL
  OR valor_seguro < 0
  OR clausula IS NULL
  OR empresa_seguro IS NULL
) TO STDOUT with CSV HEADER
\g '../descartados/seguros_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS seguro_valid;
CREATE TEMP TABLE seguro_valid AS (
  SELECT * FROM review_seguro_raw
  WHERE reserva_id IS NOT NULL
    AND reserva_id IN (SELECT id FROM reserva)
    AND (
      correo_usuario IN (SELECT correo FROM usuario) 
      OR correo_usuario IS NULL
    )
    AND tipo_seguro IS NOT NULL
    AND valor_seguro IS NOT NULL
    AND valor_seguro >= 0
    AND clausula IS NOT NULL
    AND empresa_seguro IS NOT NULL
);

INSERT INTO seguro (reserva_id, correo_usuario, tipo, valor, clausula, empresa)
SELECT reserva_id, correo_usuario, tipo_seguro, valor_seguro, clausula, empresa_seguro
FROM seguro_valid
ON CONFLICT (reserva_id) DO NOTHING;


-- -- Review
COPY (
  SELECT * FROM review_seguro_raw
  WHERE reserva_id IS NULL
  OR reserva_id NOT IN (SELECT id FROM reserva)
  OR correo_usuario NOT IN (SELECT correo FROM usuario)
  OR estrellas IS NULL
  OR estrellas < 0
  OR estrellas > 5
) TO STDOUT with CSV HEADER
\g '../descartados/reviews_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS review_valid;
CREATE TEMP TABLE review_valid AS (
  SELECT * FROM review_seguro_raw
  WHERE reserva_id IS NOT NULL
    AND reserva_id IN (SELECT id FROM reserva)
    AND correo_usuario IS NOT NULL
    AND correo_usuario IN (SELECT correo FROM usuario)
    AND estrellas IS NOT NULL
    AND estrellas BETWEEN 0 AND 5
);

INSERT INTO review (correo_usuario, reserva_id, estrellas, descripcion)
SELECT correo_usuario, reserva_id, estrellas, descripcion
FROM review_valid
ON CONFLICT (reserva_id) DO NOTHING;


-- -- Transporte
-- --
COPY (
  SELECT * FROM reserva_valid
  WHERE correo_empleado IS NULL 
  OR lugar_origen IS NULL 
  OR lugar_llegada IS NULL 
  OR capacidad IS NULL 
  OR capacidad < 0
  OR tiempo_estimado IS NULL 
  OR tiempo_estimado < 0
  OR precio_asiento IS NULL 
  OR precio_asiento < 0
  OR empresa IS NULL 
  OR fecha_salida IS NULL 
  OR fecha_llegada IS NULL
  OR reserva_id NOT IN (SELECT id FROM reserva)
) TO STDOUT with CSV HEADER
\g '../descartados/transportes_descartados.csv' CSV HEADER;


DROP TABLE IF EXISTS transporte_valid;
CREATE TEMP TABLE transporte_valid AS (
  SELECT * FROM reserva_valid -- Inherits the properties of a valid reserva.
  WHERE correo_empleado IS NOT NULL 
    AND lugar_origen IS NOT NULL 
    AND lugar_llegada IS NOT NULL 
    AND capacidad IS NOT NULL 
    AND capacidad >= 0
    AND tiempo_estimado IS NOT NULL 
    AND tiempo_estimado >= 0
    AND precio_asiento IS NOT NULL 
    AND precio_asiento >= 0
    AND empresa IS NOT NULL 
    AND fecha_salida IS NOT NULL 
    AND fecha_llegada IS NOT NULL
    AND (
      reserva_id IN (SELECT id FROM reserva) 
      OR reserva_id IS NULL
    )
    AND correo_empleado IN (SELECT correo FROM empleado)
);

INSERT INTO transporte (id, correo_empleado, lugar_origen, lugar_llegada, capacidad, tiempo_estimado, precio_asiento, empresa, fecha_salida, fecha_llegada)
SELECT reserva_id, correo_empleado, lugar_origen, lugar_llegada, capacidad, tiempo_estimado, precio_asiento, empresa, fecha_salida, fecha_llegada
FROM transporte_valid
ON CONFLICT DO NOTHING;


-- -- Bus
COPY (
  SELECT * FROM transporte_valid
  WHERE tipo_bus IS NULL 
  OR comodidades IS NULL 
  OR reserva_id NOT IN (SELECT id FROM reserva)
) TO STDOUT with CSV HEADER
\g '../descartados/bus_descartados.csv' CSV HEADER;

INSERT INTO bus (id, tipo_bus, comodidades)
SELECT reserva_id, tipo_bus, comodidades
FROM transporte_valid
WHERE tipo_bus IS NOT NULL 
  AND tipo_bus IN ('Cama', 'Normal', 'Semi-cama')
  AND reserva_id IN (SELECT id FROM reserva)
ON CONFLICT DO NOTHING;


-- -- Tren
COPY (
  SELECT * FROM transporte_valid
  WHERE comodidades IS NULL 
  OR paradas IS NULL 
  OR reserva_id NOT IN (SELECT id FROM reserva)
) TO STDOUT with CSV HEADER
\g '../descartados/tren_descartados.csv' CSV HEADER;

INSERT INTO tren (id, comodidades, paradas)
SELECT reserva_id, comodidades, paradas
FROM transporte_valid
WHERE reserva_id IN (SELECT id FROM reserva)
ON CONFLICT DO NOTHING;


-- -- Avion
COPY (
  SELECT * FROM transporte_valid
  WHERE clase IS NULL 
  OR escalas IS NULL 
  OR reserva_id NOT IN (SELECT id FROM reserva)
) TO STDOUT with CSV HEADER
\g '../descartados/avion_descartados.csv' CSV HEADER;

INSERT INTO avion (id, clase, escalas)
SELECT reserva_id, clase, escalas
FROM transporte_valid
WHERE reserva_id IN (SELECT id FROM reserva)
    AND clase IS NOT NULL
    AND clase IN ('Clase ejecutiva', 'Primera clase', 'Clase económica')
ON CONFLICT DO NOTHING;


-- -- Hospedaje
COPY (
  SELECT * FROM reserva_valid
  WHERE nombre_hospedaje IS NULL
  OR ubicacion IS NULL
  OR precio_noche IS NULL
  OR precio_noche < 0
  OR estrellas IS NULL
  OR estrellas < 0
  OR estrellas > 5
  OR fecha_checkin IS NULL
  OR fecha_checkout IS NULL
) TO STDOUT with CSV HEADER
\g '../descartados/hospedajes_descartados.csv' CSV HEADER;


DROP TABLE IF EXISTS hospedaje_valid;
CREATE TEMP TABLE hospedaje_valid AS (
  SELECT * FROM reserva_valid
  WHERE nombre_hospedaje IS NOT NULL
    AND ubicacion IS NOT NULL
    AND precio_noche IS NOT NULL
    AND precio_noche >= 0
    AND estrellas IS NOT NULL
    AND estrellas BETWEEN 0 AND 5
    AND fecha_checkin IS NOT NULL
    AND fecha_checkout IS NOT NULL
    AND reserva_id IN (SELECT id FROM reserva)
);
INSERT INTO hospedaje (id, nombre, ubicacion, precio_noche, estrellas, fecha_checkin, fecha_checkout)
SELECT reserva_id, nombre_hospedaje, ubicacion, precio_noche, estrellas, fecha_checkin, fecha_checkout
FROM hospedaje_valid
ON CONFLICT DO NOTHING;


-- -- Airbnb
COPY (
  SELECT * FROM hospedaje_valid
  WHERE nombre_anfitrion IS NULL
  OR contacto_anfitrion IS NULL
) TO STDOUT with CSV HEADER
\g '../descartados/airbnb_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS airbnb_valid;
CREATE TEMP TABLE airbnb_valid AS (
  SELECT * FROM hospedaje_valid
  WHERE nombre_anfitrion IS NOT NULL
    AND contacto_anfitrion IS NOT NULL
    AND (piezas >= 0 OR piezas IS NULL)
    AND (camas >= 0 OR camas IS NULL)
    AND (banos >= 0 OR banos IS NULL)
    -- AND reserva_id IN (SELECT reserva_id FROM hospedaje_valid)
);

INSERT INTO airbnb (id, nombre_anfitrion, contacto_anfitrion, descripcion, piezas, camas, banos)
SELECT reserva_id, nombre_anfitrion, contacto_anfitrion, descripcion_airbnb, piezas, camas, banos
FROM airbnb_valid
ON CONFLICT DO NOTHING;


-- -- Hotel
COPY (
  SELECT * FROM hospedaje_valid
  WHERE reserva_id IN (SELECT reserva_id FROM airbnb_valid)
  )
TO STDOUT with CSV HEADER
\g '../descartados/hotel_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS hotel_valid;
CREATE TEMP TABLE hotel_valid AS (
  SELECT * FROM hospedaje_valid
  WHERE reserva_id NOT IN (SELECT reserva_id FROM airbnb_valid)
);

INSERT INTO hotel (id, politicas)
SELECT reserva_id, politicas
FROM hotel_valid
ON CONFLICT DO NOTHING;

-- Habitacion (weak entity, 1-N hotel)
DROP TABLE IF EXISTS habitacion_raw;
CREATE TEMP TABLE habitacion_raw (
    hotel_id INTEGER,
    numero_habitacion INTEGER,
    tipo TEXT
);
\copy habitacion_raw FROM '../csv/habitaciones.csv' CSV HEADER;


COPY (
  SELECT * FROM habitacion_raw
  WHERE hotel_id IS NULL 
  OR numero_habitacion IS NULL 
  OR numero_habitacion < 0
  OR tipo IS NULL 
  OR tipo NOT IN ('Single', 'Double', 'Triple', 'Cuadruple')
) TO STDOUT with CSV HEADER
\ '../descartados/habitaciones_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS habitacion_valid;
CREATE TEMP TABLE habitacion_valid AS (
  SELECT * FROM habitacion_raw
  WHERE hotel_id IS NOT NULL
    AND hotel_id IN (SELECT id FROM hotel)
    AND numero_habitacion IS NOT NULL 
    AND numero_habitacion > 0
    AND tipo IS NOT NULL 
    AND tipo IN ('Single', 'Double', 'Triple', 'Cuadruple')
);

INSERT INTO habitacion (id_hotel, numero_habitacion, tipo)
SELECT hotel_id, numero_habitacion, tipo
FROM habitacion_valid
ON CONFLICT DO NOTHING;



-- -- Panorama
COPY (
  SELECT * FROM reserva_valid
  WHERE empresa IS NULL
  OR nombre_panorama IS NULL
  OR ubicacion IS NULL
  OR duracion IS NULL
  OR duracion < 0
  OR precio_persona IS NULL
  OR precio_persona < 0
  OR capacidad IS NULL
  OR capacidad < 0
  OR fecha_panorama IS NULL
) TO STDOUT with CSV HEADER
\g '../descartados/panorama_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS panorama_valid;
CREATE TEMP TABLE panorama_valid AS (
  SELECT * FROM reserva_valid
  WHERE empresa IS NOT NULL
    AND nombre_panorama IS NOT NULL
    AND ubicacion IS NOT NULL
    AND duracion IS NOT NULL
    AND duracion >= 0
    AND precio_persona IS NOT NULL
    AND precio_persona >= 0
    AND capacidad IS NOT NULL
    AND capacidad >= 0
    AND fecha_panorama IS NOT NULL
    AND reserva_id IN (SELECT id FROM reserva)
);

INSERT INTO panorama (id, empresa, nombre, ubicacion, duracion, precio_persona, capacidad, restricciones, fecha_panorama)
SELECT reserva_id, empresa, nombre_panorama, ubicacion, duracion, precio_persona, capacidad, restricciones, fecha_panorama
FROM panorama_valid
ON CONFLICT DO NOTHING;


-- -- Participante
DROP TABLE IF EXISTS participante_raw;
CREATE TEMP TABLE participante_raw (
    panorama_id INTEGER,
    nombre TEXT,
    edad INTEGER
);

\copy participante_raw FROM '../csv/participantes.csv' CSV HEADER;
COPY (
  SELECT * FROM participante_raw
  WHERE panorama_id IS NULL 
  OR nombre IS NULL 
  OR edad <= 0
) TO STDOUT with CSV HEADER
\g '../descartados/participantes_descartados.csv' CSV HEADER;

DROP TABLE IF EXISTS participante_valid;
CREATE TEMP TABLE participante_valid AS (
  SELECT * FROM participante_raw
  WHERE panorama_id IS NOT NULL
    AND panorama_id IN (SELECT id FROM panorama)
    AND nombre IS NOT NULL
    AND edad > 0
);
INSERT INTO participantes (id_panorama, nombre, edad)
SELECT panorama_id, nombre, edad
FROM participante_valid
ON CONFLICT DO NOTHING;





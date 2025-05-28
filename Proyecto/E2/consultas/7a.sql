-- Consulta 7a
-- Descripción: Insertar datos de mano, a partir de la enunciado de 2.2.7
BEGIN;

----------------------------------------------------------------------
-- 1. PERSONAS (organizadores, empleados, host, participantes)
----------------------------------------------------------------------
INSERT INTO
    persona (
        correo,
        nombre,
        contrasena,
        username,
        telefono_contacto,
        run,
        dv
    )
VALUES
    (
        'cata@bienestar.cl',
        'Cata Bienestar',
        '***',
        'cataB',
        NULL,
        '90000001',
        'K'
    ),
    (
        'jorge@bienestar.cl',
        'Jorge Bienestar',
        '***',
        'jorgeB',
        NULL,
        '90000002',
        'K'
    ),
    (
        'lucas@viajero.cl',
        'Lucas Viajero',
        '***',
        'lucasV',
        NULL,
        '90000003',
        'K'
    ),
    (
        'connie@lafamilia.it',
        'Connie Corleone',
        '***',
        'connieC',
        NULL,
        '90000004',
        'K'
    ),
    (
        'paulie@gatto.com',
        'Paulie Gatto',
        '***',
        'paulieG',
        NULL,
        '90000005',
        'K'
    ),
    (
        'luca@brasi.com',
        'Luca Brasi',
        '***',
        'lucaB',
        NULL,
        '90000006',
        'K'
    ),
    (
        'martina@tattaglia.it',
        'Martina Tattaglia',
        '***',
        'martinaT',
        NULL,
        '90000007',
        'K'
    ),
    (
        'tomas@barzini.it',
        'Tomás Barzini',
        '***',
        'tomasB',
        NULL,
        '90000008',
        'K'
    ),
    (
        'vincenzo@martino.it',
        'Vincenzo Martino',
        '***',
        'vincenzoM',
        NULL,
        '90000009',
        'K'
    ),
    (
        'agustino@beckerini.it',
        'Agustino Beckerini',
        '***',
        'agustinoB',
        NULL,
        '90000010',
        'K'
    ),
    (
        'consuelo@inostrozini.it',
        'Consuelo Inostrozini',
        '***',
        'consueloI',
        NULL,
        '90000011',
        'K'
    ),
    (
        'ignacio@garridelli.it',
        'Ignacio Garridelli',
        '***',
        'ignacioG',
        NULL,
        '90000012',
        'K'
    ),
    (
        'olivia@llanini.it',
        'Olivia Llanini',
        '***',
        'oliviaL',
        NULL,
        '90000013',
        'K'
    ),
    (
        'paula@contessa.it',
        'Paula Contessa',
        '***',
        'paulaC',
        NULL,
        '90000014',
        'K'
    ),
    (
        'sofia@retamalini.it',
        'Sofia Retamalini',
        '***',
        'sofiaR',
        NULL,
        '90000015',
        'K'
    );

-- empleados (piloto & conductor)
INSERT INTO
    empleado (correo, jornada, isapre, contrato)
VALUES
    (
        'paulie@gatto.com',
        'Diurno',
        'Fonasa',
        'Full time'
    ),
    ('luca@brasi.com', 'Diurno', 'Fonasa', 'Full time');

-- usuarios (todos los participantes + organizadores)
INSERT INTO
    usuario (correo, puntos)
VALUES
    ('cata@bienestar.cl', 0),
    ('jorge@bienestar.cl', 0),
    ('lucas@viajero.cl', 0),
    ('connie@lafamilia.it', 0),
    ('martina@tattaglia.it', 0),
    ('tomas@barzini.it', 0),
    ('vincenzo@martino.it', 0),
    ('agustino@beckerini.it', 0),
    ('consuelo@inostrozini.it', 0),
    ('ignacio@garridelli.it', 0),
    ('olivia@llanini.it', 0),
    ('paula@contessa.it', 0),
    ('sofia@retamalini.it', 0);

----------------------------------------------------------------------
-- 2. AGENDA del viaje
----------------------------------------------------------------------
INSERT INTO
    agenda (id, correo_usuario, etiqueta)
VALUES
    (800, 'lucas@viajero.cl', 'Viaje Fin de Semestre');

----------------------------------------------------------------------
-- 3. RESERVAS  (1 vuelo, 1 bus interno, 1 hospedaje-Airbnb, 4 panoramas)
----------------------------------------------------------------------
-- 3.1 Charter flight  (id=9001)
INSERT INTO
    reserva (
        id,
        agenda_id,
        fecha,
        monto,
        cantidad_personas,
        estado_disponibilidad,
        puntos_booked
    )
VALUES
    (
        9001,
        800,
        '2025-05-12',
        3000000,
        14,
        'No disponible',
        30000
    );

-- 3.2 Bus interno Palermo-Corleone  (id=9002)
INSERT INTO
    reserva
VALUES
    (
        9002,
        800,
        '2025-05-12',
        200000,
        14,
        'No disponible',
        2000
    );

-- 3.3 Airbnb “La familia”  (id=9003)
INSERT INTO
    reserva
VALUES
    (
        9003,
        800,
        '2025-05-12',
        1800000,
        14,
        'No disponible',
        18000
    );

-- 3.4-3.7 panoramas (cata, cena, God Father House, CIDMA)  ids 9004-9007
INSERT INTO
    reserva
VALUES
    (
        9004,
        800,
        '2025-05-12',
        420000,
        14,
        'No disponible',
        4200
    ),
    (
        9005,
        800,
        '2025-05-12',
        560000,
        14,
        'No disponible',
        5600
    ),
    (
        9006,
        800,
        '2025-05-12',
        280000,
        14,
        'No disponible',
        2800
    ),
    (
        9007,
        800,
        '2025-05-12',
        210000,
        14,
        'No disponible',
        2100
    );

----------------------------------------------------------------------
-- 4. TRANSPORTE
----------------------------------------------------------------------
-- 4.1 Avión charter (id=9001)
INSERT INTO
    transporte (
        id,
        correo_empleado,
        lugar_origen,
        lugar_llegada,
        capacidad,
        tiempo_estimado,
        precio_asiento,
        empresa,
        fecha_salida,
        fecha_llegada
    )
VALUES
    (
        9001,
        'paulie@gatto.com',
        'Santiago (SCL)',
        'Palermo (PMO)',
        150,
        20,
        250000,
        'AeroPeor',
        '2025-08-01 03:00:00',
        '2025-08-01 23:00:00'
    );

INSERT INTO
    avion (id, clase, escalas)
VALUES
    (
        9001,
        'Clase económica',
        '{Rio de Janeiro,Casablanca}'
    );

-- 4.2 Bus interno (id=9002)
INSERT INTO
    transporte (
        id,
        correo_empleado,
        lugar_origen,
        lugar_llegada,
        capacidad,
        tiempo_estimado,
        precio_asiento,
        empresa,
        fecha_salida,
        fecha_llegada
    )
VALUES
    (
        9002,
        'luca@brasi.com',
        'Palermo',
        'Corleone',
        30,
        2,
        10000,
        'Viaja con respeto',
        '2025-08-01 09:00:00',
        '2025-08-01 11:00:00'
    );

INSERT INTO
    bus (id, comodidades, tipo_bus)
VALUES
    (9002, '{A/C,WiFi}', 'Semi-cama');

----------------------------------------------------------------------
-- 5. HOSPEDAJE  (Airbnb reserva_id=9003)
----------------------------------------------------------------------
INSERT INTO
    hospedaje (
        id,
        nombre,
        ubicacion,
        precio_noche,
        estrellas,
        comodidades,
        fecha_checkin,
        fecha_checkout
    )
VALUES
    (
        9003,
        'La familia',
        'Corleone, Sici:lia',
        300000,
        5,
        '{Cocina,WiFi,Jardín}',
        '2025-08-01',
        '2025-08-06'
    );

INSERT INTO
    airbnb (
        id,
        nombre_anfitrion,
        contacto_anfitrion,
        descripcion,
        piezas,
        camas,
        banos
    )
VALUES
    (
        9003,
        'Connie Corleone',
        '+39 091-123456',
        'Casa familiar con patio',
        7,
        10,
        4
    );

----------------------------------------------------------------------
-- 6. PANORAMAS  (reserva_ids 9004-9007)
----------------------------------------------------------------------
INSERT INTO
    panorama (
        id,
        empresa,
        nombre,
        descripcion,
        ubicacion,
        duracion,
        precio_persona,
        capacidad,
        restricciones,
        fecha_panorama
    )
VALUES
    (
        9004,
        'Vino de Mesa Italiano',
        'Cata de vinos',
        'Tour de 6 vinos locales',
        'Corleone',
        3,
        30000,
        20,
        '{Mayores de 18}',
        '2025-08-02'
    ),
    (
        9005,
        'El príncipe di Corleone',
        'Cena tradicional',
        'Menú siciliano 5 platos',
        'Corleone',
        2,
        40000,
        30,
        NULL,
        '2025-08-03'
    ),
    (
        9006,
        'Visitas God Father',
        'The God Father’s House',
        'Recorrido por la locación de filmación',
        'Via Candelora 25, Corleone',
        1,
        20000,
        25,
        NULL,
        '2025-08-04'
    ),
    (
        9007,
        'CIDMA',
        'Museo Antimafia',
        'Entrada y visita guiada',
        'Corleone',
        2,
        15000,
        40,
        NULL,
        '2025-08-05'
    );

-- Añadir participantes a los panoramas
INSERT INTO
    participantes (id_panorama, nombre)
VALUES
    (9004, 'Cata Bienestar'),
    (9004, 'Jorge Bienestar'),
    (9004, 'Lucas Viajero'),
    (9004, 'Martina Tattaglia'),
    (9004, 'Tomás Barzini'),
    (9004, 'Vincenzo Martino'),
    (9004, 'Agustino Beckerini'),
    (9004, 'Consuelo Inostrozini'),
    (9004, 'Ignacio Garridelli'),
    (9004, 'Olivia Llanini'),
    (9004, 'Paula Contessa'),
    (9004, 'Sofia Retamalini');

INSERT INTO
    participantes (id_panorama, nombre)
VALUES
    (9005, 'Cata Bienestar'),
    (9005, 'Jorge Bienestar'),
    (9005, 'Lucas Viajero'),
    (9005, 'Martina Tattaglia'),
    (9005, 'Tomás Barzini'),
    (9005, 'Vincenzo Martino'),
    (9005, 'Agustino Beckerini'),
    (9005, 'Consuelo Inostrozini'),
    (9005, 'Ignacio Garridelli'),
    (9005, 'Olivia Llanini'),
    (9005, 'Paula Contessa'),
    (9005, 'Sofia Retamalini');

INSERT INTO
    participantes (id_panorama, nombre)
VALUES
    (9006, 'Cata Bienestar'),
    (9006, 'Jorge Bienestar'),
    (9006, 'Lucas Viajero'),
    (9006, 'Martina Tattaglia'),
    (9006, 'Tomás Barzini'),
    (9006, 'Vincenzo Martino'),
    (9006, 'Agustino Beckerini'),
    (9006, 'Consuelo Inostrozini'),
    (9006, 'Ignacio Garridelli'),
    (9006, 'Olivia Llanini'),
    (9006, 'Paula Contessa'),
    (9006, 'Sofia Retamalini');

INSERT INTO
    participantes (id_panorama, nombre)
VALUES
    (9007, 'Cata Bienestar'),
    (9007, 'Jorge Bienestar'),
    (9007, 'Lucas Viajero'),
    (9007, 'Martina Tattaglia'),
    (9007, 'Tomás Barzini'),
    (9007, 'Vincenzo Martino'),
    (9007, 'Agustino Beckerini'),
    (9007, 'Consuelo Inostrozini'),
    (9007, 'Ignacio Garridelli'),
    (9007, 'Olivia Llanini'),
    (9007, 'Paula Contessa'),
    (9007, 'Sofia Retamalini');

COMMIT;
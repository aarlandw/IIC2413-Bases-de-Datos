\set ON_ERROR_STOP on
BEGIN;
\echo 'Delete tables if exists'

DROP TABLE IF EXISTS
    habitacion        ,
    hotel             ,
    airbnb            ,
    hospedaje         ,
    participantes      ,
    panorama          ,
    avion             ,
    bus               ,
    tren              ,
    transporte        ,
    seguro            ,
    review            ,
    reserva           ,
    agenda            ,
    usuario           ,
    empleado          ,
    persona 
    CASCADE;

\echo 'Creating tables'

CREATE TABLE
    persona (
        correo TEXT PRIMARY KEY ,
        nombre TEXT NOT NULL,
        contrasena TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        telefono_contacto TEXT,
        run CHAR(8) UNIQUE NOT NULL, -- Under the assumption that the RUN is unique and consists of 8 characters
        dv CHAR(1) NOT NULL
    );

CREATE TABLE
    empleado (
        correo TEXT PRIMARY KEY REFERENCES persona (correo) ON DELETE CASCADE, -- Foreign key to persona(correo)
        jornada TEXT NOT NULL CHECK(jornada IN (
            'Diurna',
            'Nocturna',
            'Diurno',
            'Nocturno'
            )
        ),
        isapre TEXT NOT NULL CHECK (isapre IN (
                'Más vida',
                'Colmena',
                'Consalud',
                'Banmédica',
                'Banmedica',
                'Fonasa'
            )
        ),
        contrato TEXT NOT NULL CHECK (
            contrato IN (
                'full-time',
                'part-time',
                'Full time',
                'Part time',
                'Full Time',
                'Part Time'
            )
        )
    );

CREATE TABLE
    usuario (
        correo TEXT PRIMARY KEY REFERENCES persona (correo) ON DELETE CASCADE,
        puntos INTEGER NOT NULL DEFAULT 0 CHECK (puntos >= 0)
    );


CREATE TABLE
    agenda (
        id SERIAL PRIMARY KEY,
        correo_usuario TEXT NOT NULL REFERENCES usuario (correo) ON DELETE CASCADE, -- Weak entity: Hence NOT NULL, and enforced by the foreign key.
        etiqueta TEXT NOT NULL
        -- PRIMARY KEY (id, correo_usuario) -- Weak entity: depends on usuario 
    );


CREATE TABLE
    reserva (
        id SERIAL PRIMARY KEY,
        agenda_id INTEGER REFERENCES agenda(id) ON DELETE SET NULL, -- Foreign key, NULL allowed.
        -- correo_usuario TEXT,
        fecha DATE NOT NULL,
        monto INTEGER NOT NULL CHECK (monto > 0), -- Or should I use numeric(p,s)? Default value?
        cantidad_personas INTEGER NOT NULL CHECK (cantidad_personas > 0),
        estado_disponibilidad TEXT NOT NULL CHECK (
            estado_disponibilidad IN ('Disponible', 'No disponible')
        ),
        puntos_booked INTEGER NOT NULL CHECK (puntos_booked > 0)
    );


CREATE TABLE
    review (
        id SERIAL PRIMARY KEY,
        correo_usuario TEXT NOT NULL REFERENCES usuario (correo) ON DELETE CASCADE,
        reserva_id INTEGER UNIQUE NOT NULL REFERENCES reserva (id) ON DELETE CASCADE,
        estrellas INTEGER NOT NULL CHECK (estrellas BETWEEN 0 AND 5),
        descripcion TEXT
        -- PRIMARY KEY (correo_usuario, reserva_id)
    );


CREATE TABLE
    seguro (
        id SERIAL PRIMARY KEY,
        reserva_id INTEGER UNIQUE NOT NULL REFERENCES reserva (id) ON DELETE CASCADE,
        correo_usuario TEXT REFERENCES usuario (correo),
        tipo TEXT NOT NULL,
        valor INTEGER CHECK (valor >= 0) NOT NULL,
        clausula TEXT NOT NULL,
        empresa TEXT NOT NULL
    );

------ Hospedaje + subtypes

CREATE TABLE
    hospedaje (
        -- id SERIAL PRIMARY KEY,
        id INTEGER UNIQUE REFERENCES reserva (id) ON DELETE CASCADE,
        nombre TEXT NOT NULL,
        ubicacion TEXT NOT NULL,
        precio_noche INTEGER CHECK (precio_noche > 0) NOT NULL,
        estrellas INTEGER CHECK (estrellas BETWEEN 0 AND 5) NOT NULL,
        comodidades TEXT[],
        fecha_checkin DATE NOT NULL,
        fecha_checkout DATE NOT NULL
        -- tipo TEXT NOT NULL -- 'hotel'|'airbnb'
        -- Used for table-per-hierarchy discrimination
        -- Is this necessary?
    );


CREATE TABLE
    hotel (
        id INTEGER PRIMARY KEY REFERENCES hospedaje (id) ON DELETE CASCADE,
        politicas    TEXT[]
    );


CREATE TABLE
    airbnb (
        id INTEGER PRIMARY KEY REFERENCES hospedaje (id) ON DELETE CASCADE,
        nombre_anfitrion TEXT NOT NULL,
        contacto_anfitrion TEXT NOT NULL,
        descripcion TEXT,
        piezas INTEGER CHECK (piezas >= 0),
        camas INTEGER CHECK (camas >= 0),
        banos INTEGER CHECK (banos >= 0)
    );

/* ── Habitacion (weak, 1-N hotel) */

CREATE TABLE
    habitacion (
        id_hotel INTEGER REFERENCES hotel (id) ON DELETE CASCADE,
        numero_habitacion INTEGER NOT NULL CHECK (numero_habitacion > 0), -- Does not make sense with room 0 
        tipo TEXT CHECK (
            tipo IN (
                'Sencilla',
                'Doble',
                'Matrimonial',
                'Triple',
                'Cuadruple',
                'Suite'
            )
        ) NOT NULL,
        PRIMARY KEY (id_hotel, numero_habitacion)
    );

------ Panorama + subtypes 

CREATE TABLE
    panorama (
        -- id SERIAL PRIMARY KEY,
        id INTEGER UNIQUE REFERENCES reserva (id) ON DELETE CASCADE,
        empresa TEXT NOT NULL,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        ubicacion TEXT NOT NULL,
        duracion INTEGER NOT NULL, -- hours. Should i use INTERVAL or INTEGER?
        precio_persona INTEGER NOT NULL CHECK (precio_persona > 0),
        capacidad INTEGER CHECK (capacidad > 0) NOT NULL,
        restricciones TEXT[],
        fecha_panorama DATE NOT NULL
    );


CREATE TABLE
    participantes (
        id_panorama INTEGER REFERENCES panorama (id) ON DELETE CASCADE,
        -- id SERIAL, -- Redundant?
        nombre TEXT NOT NULL,
        edad INTEGER CHECK (edad > 0),
        PRIMARY KEY (id_panorama, nombre) -- weak entity
    );

------ Transporte + subtypes

CREATE TABLE
    transporte (
        -- id SERIAL PRIMARY KEY, -- Redundant?
        id INTEGER UNIQUE REFERENCES reserva (id) ON DELETE CASCADE,
        correo_empleado TEXT NOT NULL REFERENCES empleado (correo), -- A transporte needs a employee, hence NOT NULL.
        lugar_origen TEXT NOT NULL,
        lugar_llegada TEXT NOT NULL,
        capacidad INTEGER NOT NULL CHECK (capacidad >= 0),
        tiempo_estimado INTEGER NOT NULL,
        precio_asiento INTEGER NOT NULL CHECK (precio_asiento >= 0),
        empresa TEXT NOT NULL,
        fecha_salida TIMESTAMP NOT NULL,
        fecha_llegada TIMESTAMP NOT NULL
        -- tipo TEXT NOT NULL -- 'bus'|'tren'|'avion'
    );


CREATE TABLE
    tren (
        id INTEGER PRIMARY KEY REFERENCES transporte (id) ON DELETE CASCADE,
        comodidades     TEXT[],
        paradas         TEXT[]
    );


CREATE TABLE
    bus (
        id INTEGER PRIMARY KEY REFERENCES transporte (id) ON DELETE CASCADE,
        comodidades TEXT[],
        tipo_bus TEXT CHECK (tipo_bus IN ('Cama', 'Normal', 'Semi-cama')) NOT NULL
    );


CREATE TABLE
    avion (
        id INTEGER PRIMARY KEY REFERENCES transporte (id) ON DELETE CASCADE,
        clase TEXT NOT NULL CHECK (clase IN (
            'Clase ejecutiva', 
            'Primera clase', 
            'Clase económica'
            )
        ),
        escalas TEXT[]
    );

COMMIT;
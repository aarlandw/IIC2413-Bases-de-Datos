CREATE TABLE persona (
    id SERIAL,
    nombre VARCHAR(50) NOT NULL,
    edad INT CHECK (edad >= 0)
);

\COPY persona (nombre, edad) FROM 'persona.csv' DELIMITER ',' CSV HEADER;

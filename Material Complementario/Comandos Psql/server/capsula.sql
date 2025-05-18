CREATE TABLE ciudad (
    id SERIAL,
    nombre VARCHAR(50),
    poblacion INT CHECK (poblacion >= 0)
);

\COPY ciudad (nombre, poblacion) FROM 'ciudad.csv' DELIMITER ',' CSV HEADER;

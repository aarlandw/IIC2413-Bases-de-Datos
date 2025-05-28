-- Consulta 7c
-- Descripción: Cambiar el piloto del vuelo charter y eliminar al piloto Paulie.
BEGIN;

UPDATE transporte
SET
    correo_empleado = 'luca@brasi.com'
WHERE
    id = 9001
    AND correo_empleado = 'paulie@gatto.com';

DELETE FROM empleado
WHERE
    correo = 'paulie@gatto.com';

COMMIT;
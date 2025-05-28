-- Consulta 7b
-- Descripción: Calcular el costo total de los viajes realizados por los ayudantes de Base de Datos.
SELECT SUM(monto) AS costo_total_viaje
FROM   reserva
WHERE  id BETWEEN 9001 AND 9007;
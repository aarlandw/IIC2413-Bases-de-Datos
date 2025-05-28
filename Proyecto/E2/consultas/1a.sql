-- Consulta 1a
-- Descripción: Cantidad de reservas y monto total por mes grupado y ordenado por mes.
SELECT
    to_char (fecha, 'MM-YYYY') AS mes,
    COUNT(*) AS cantidad_reservas,
    SUM(monto) AS monto_total
FROM
    reserva
GROUP BY
    mes
ORDER BY
    mes;
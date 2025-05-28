-- Consulta 3a
-- Descripción: Listar los panoramas con su promedio de estrellas y cantidad de reviews.
SELECT
    p.nombre AS nombre_panorama,
    ROUND(AVG(estrellas), 2) AS prom_estrellas,
    COUNT(r.reserva_id) AS cant_reviews
FROM
    panorama p
    JOIN review r ON r.reserva_id = p.id
WHERE
    r.reserva_id = p.id
GROUP BY
    p.nombre
ORDER BY
    prom_estrellas DESC;
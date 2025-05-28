-- Consulta 3b
-- Descripción: Listar los panoramas con su promedio de estrellas, cantidad de reviews y último comentario.
SELECT
    p.nombre AS nombre_panorama,
    ROUND(AVG(rv.estrellas), 2) AS promedia_estrellas,
    COUNT(rv.id) AS cantidad_reviews,
    (
        SELECT
            rv2.descripcion
        FROM
            review rv2
            JOIN reserva r2 ON r2.id = rv2.reserva_id
            JOIN panorama p2 ON p2.id = r2.id
        WHERE
            r2.id = p2.id
        ORDER BY
            r2.fecha DESC
        LIMIT
            1
    ) AS ultimo_comentario
    -- MAX(rv.descripcion) AS ultimo_comentario
FROM
    panorama p
    JOIN reserva r ON r.id = p.id
    JOIN review rv ON rv.reserva_id = r.id
GROUP BY
    nombre_panorama
ORDER BY
    promedia_estrellas DESC;
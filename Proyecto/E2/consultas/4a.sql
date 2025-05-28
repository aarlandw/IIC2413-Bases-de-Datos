-- Consulta 4a
-- Descripción: Los tres mayores cantidades de panoramas y monto total por mes grupado y ordenado por cantidad de panoramas.

SELECT
    to_char (pan.fecha_panorama, 'MM-YYYY') AS mes,
    COUNT(*) AS cantidad_panoramas,
    SUM(
        (
            SELECT
                COUNT(*)
            FROM
                participantes part
            WHERE
                part.id_panorama = pan.id
        )
    ) AS cantidad_participantes,
    SUM(r.monto) AS monto_ganado
FROM
    panorama pan
    JOIN reserva r ON r.id = pan.id
GROUP BY
    mes
ORDER BY
    cantidad_panoramas DESC
LIMIT
    3;
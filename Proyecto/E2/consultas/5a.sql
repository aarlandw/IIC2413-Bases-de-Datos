-- Consulta 5a
-- Descripción: Listar los 5 usuarios con más puntos y la cantidad de reservas realizadas desde el 27 de mayo de 2025.
SELECT
    pers.nombre AS nombre_usuario,
    u.puntos as puntos,
    COUNT(r.*) AS cantidad_reservas
FROM
    usuario u
    LEFT JOIN agenda a ON a.correo_usuario = u.correo
    LEFT JOIN reserva r ON (
        r.agenda_id = a.id
        AND r.fecha >= DATE '2025-05-27'
    )
    JOIN persona pers ON pers.correo = u.correo
GROUP BY
    pers.nombre,
    puntos
ORDER BY
    puntos DESC,
    cantidad_reservas DESC
LIMIT
    5;
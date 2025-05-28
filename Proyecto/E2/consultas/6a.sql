-- Consulta 6a
-- Descripción: Listar los usuarios con más de 70 reservas o más de 1000 puntos.
SELECT
    pers.nombre AS nombre_usuario,
    COUNT(r.*) AS cantidad_reservas,
    u.puntos AS puntos
FROM
    usuario u
    JOIN persona pers ON pers.correo = u.correo
    LEFT JOIN agenda a ON a.correo_usuario = u.correo
    LEFT JOIN reserva r ON r.agenda_id = a.id
GROUP BY
    nombre_usuario,
    puntos
HAVING
    COUNT(r.*) > 70
    OR puntos > 1000
ORDER BY
    cantidad_reservas DESC,
    puntos DESC;
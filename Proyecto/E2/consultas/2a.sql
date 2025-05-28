-- Consulta 2a
-- Descripción: Listar los hospedajes disponibles ordenados por estrellas.
SELECT
    h.nombre,
    h.ubicacion,
    h.estrellas,
    h.precio_noche
FROM
    hospedaje h
    JOIN reserva r ON r.id = h.id
WHERE
    r.estado_disponibilidad = 'Disponible'
ORDER BY
    h.estrellas DESC;
-- Consulta 2b
--  Hoteles disponibles con >1 política
SELECT
  h.nombre,
  h.ubicacion,
  h.estrellas,
  h.precio_noche
FROM
  hospedaje h
  JOIN hotel ho ON ho.id = h.id
  JOIN reserva r ON r.id = h.id
WHERE
  r.estado_disponibilidad = 'Disponible'
  AND array_length (ho.politicas, 1) > 1
ORDER BY
  h.estrellas DESC,
  h.precio_noche ASC;
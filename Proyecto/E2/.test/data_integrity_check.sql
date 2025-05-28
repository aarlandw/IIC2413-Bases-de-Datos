
-- 🔍 Test Script for Data Integrity Checks
-- ----------------------------------------

-- 1. Check for NULL primary keys in 'persona'
SELECT * FROM persona WHERE correo IS NULL;

-- 2. Check for invalid foreign keys in 'review'
SELECT * FROM review WHERE correo_usuario NOT IN (SELECT correo FROM usuario);
SELECT * FROM review WHERE reserva_id NOT IN (SELECT id FROM reserva);

-- 3. Check for duplicate reserva_id in 'review' (should be unique)
SELECT reserva_id, COUNT(*) FROM review GROUP BY reserva_id HAVING COUNT(*) > 1;

-- 4. Check for invalid estrellas values
SELECT * FROM review WHERE estrellas NOT BETWEEN 1 AND 5;

-- 5. Check for invalid foreign keys in 'seguro'
SELECT * FROM seguro WHERE reserva_id NOT IN (SELECT id FROM reserva);
SELECT * FROM seguro WHERE correo_usuario IS NOT NULL AND correo_usuario NOT IN (SELECT correo FROM usuario);

-- 6. Check for duplicate reserva_id in 'seguro' (if reserva_id should be unique)
SELECT reserva_id, COUNT(*) FROM seguro GROUP BY reserva_id HAVING COUNT(*) > 1;

-- 7. Check for invalid puntos in 'usuario'
SELECT * FROM usuario WHERE puntos < 0;

-- 8. Check for NULL or invalid values in 'habitacion'
SELECT * FROM habitacion WHERE numero_habitacion IS NULL OR numero_habitacion <= 0;
SELECT * FROM habitacion WHERE tipo IS NULL;

-- 9. Check for invalid edades in 'participantes'
SELECT * FROM participantes WHERE edad < 0;

-- 10. Check for NULL estrellas, descripcion can be NULL
SELECT * FROM review WHERE estrellas IS NULL;

-- ✅ Optional: Wrap in transaction to run safely
-- BEGIN;
-- -- run test queries here
-- ROLLBACK;

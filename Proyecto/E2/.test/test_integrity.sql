-- =============================================================
--  IIC2413 – Proyecto semestral (Etapa 2)
--  archivo : test_integridad.sql
--  propósito: Ejecutar un conjunto de ASSERTs lógicos
--             para verificar que la base ya cargada cumple
--             con todas las reglas de integridad del enunciado.
--             Se detiene con RAISE EXCEPTION si encuentra
--             algún problema.
-- =============================================================
\set ON_ERROR_STOP on
\echo '⮕ Corriendo pruebas de integridad…'

DO $$
DECLARE
    v_cnt INTEGER;
BEGIN
    /* 1. Usuario/Persona coherentes -------------------------------- */
    SELECT COUNT(*) INTO v_cnt
    FROM   usuario u LEFT JOIN persona p USING (correo)
    WHERE  p.correo IS NULL;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % usuario(s) sin persona asociada', v_cnt;
    END IF;

    /* 2. Empleado/Persona coherentes ------------------------------- */
    SELECT COUNT(*) INTO v_cnt
    FROM   empleado e LEFT JOIN persona p USING (correo)
    WHERE  p.correo IS NULL;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % empleado(s) sin persona asociada', v_cnt;
    END IF;

    /* 3. Agenda debe apuntar a usuario existente ------------------ */
    SELECT COUNT(*) INTO v_cnt
    FROM   agenda a LEFT JOIN usuario u ON a.correo_usuario = u.correo
    WHERE  u.correo IS NULL;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % agenda(s) con usuario inexistente', v_cnt;
    END IF;

    /* 4. Reserva con agenda_id ≠ NULL debe ser No disponible ------ */
    SELECT COUNT(*) INTO v_cnt
    FROM   reserva
    WHERE  agenda_id IS NOT NULL AND estado_disponibilidad <> 'No disponible';
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % reserva(s) reservadas marcadas disponibles', v_cnt;
    END IF;

    /* 5. Reserva marcada No disponible debe tener agenda_id ------- */
    SELECT COUNT(*) INTO v_cnt
    FROM   reserva
    WHERE  estado_disponibilidad = 'No disponible' AND agenda_id IS NULL;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % reserva(s) No disponible sin agenda', v_cnt;
    END IF;

    /* 6. Puntos y montos positivos -------------------------------- */
    SELECT COUNT(*) INTO v_cnt FROM reserva WHERE monto <= 0 OR puntos_booked <= 0;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % reserva(s) con monto/puntos no positivos', v_cnt;
    END IF;

    /* 7. Stars dentro de 1-5 -------------------------------------- */
    SELECT COUNT(*) INTO v_cnt FROM review WHERE estrellas NOT BETWEEN 1 AND 5;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % review(s) fuera de rango 1-5', v_cnt;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM hospedaje WHERE estrellas NOT BETWEEN 1 AND 5;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % hospedaje(s) con estrellas fuera de rango', v_cnt;
    END IF;

    /* 8. Transporte / Hospedaje / Panorama cada uno vincula 1-a-1 reserva */
    SELECT COUNT(*) INTO v_cnt FROM (
        SELECT id FROM transporte
        UNION ALL
        SELECT id FROM hospedaje
        UNION ALL
        SELECT id FROM panorama
    ) t
    GROUP  BY id
    HAVING COUNT(*) > 1;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % reserva(s) asociadas a más de un tipo de servicio', v_cnt;
    END IF;

    /* 9. Habitaciones numeradas únicas por hotel ------------------ */
    SELECT COUNT(*) INTO v_cnt
    FROM   (
        SELECT id_hotel, numero_habitacion, COUNT(*)
        FROM   habitacion
        GROUP  BY id_hotel, numero_habitacion
        HAVING COUNT(*) > 1
    ) dup;
    IF v_cnt > 0 THEN
        RAISE EXCEPTION 'FAIL: % habitaciones duplicadas dentro de hotel', v_cnt;
    END IF;

    RAISE NOTICE '✔ Todas las pruebas de integridad pasaron.';
END$$;

\echo '⮕ Verificación completada.'

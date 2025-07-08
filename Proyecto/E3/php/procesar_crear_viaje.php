<?php
/* ======================================================================
 * procesar_crear_viaje.php   – 2.2 “Creación de un viaje”
 * Ajustado al esquema actual:
 *   CREATE TABLE agenda (id INT PK, correo_usuario TEXT, etiqueta TEXT);
 * ------------------------------------------------------------------- */

session_start();
require_once 'utils.php';

const DEBUG_MODE = true;
if (DEBUG_MODE) { ini_set('display_errors',1); error_reporting(E_ALL); }

/* ---------- 1.   Seguridad ------------------------------------------------ */
if (!isset($_SESSION['usuario'])) {
    header('Location: index.php?error=Debes iniciar sesión');
    exit();
}

/* ---------- 2.   Leer el formulario -------------------------------------- */
$nombre       = trim($_POST['nombre']       ?? '');
$descripcion  = trim($_POST['descripcion']  ?? '');   // NO se guarda (tabla no lo tiene)
$fecha_inicio = trim($_POST['fecha_inicio'] ?? '');   //   "
$fecha_fin    = trim($_POST['fecha_fin']    ?? '');   //   "
$ciudad       = trim($_POST['ciudad']       ?? '');   //   "
$organizador  = trim($_POST['organizador']  ?? '');   // username

if (!$nombre || !$organizador) {
    die('<h2 style="color:red">Nombre y organizador son obligatorios</h2>
         <a href="crear_viaje.php">← volver</a>');
}

/* ---------- 3.   Conexión y transacción ---------------------------------- */
try {
    $db = conectarBD();                         // utils.php :contentReference[oaicite:0]{index=0}
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $db->beginTransaction();

    /* 3-A) username → correo */
    $getMail = $db->prepare(
        "SELECT correo FROM persona WHERE username = :u LIMIT 1"
    );
    $getMail->execute([':u' => $organizador]);
    $row = $getMail->fetch(PDO::FETCH_ASSOC);
    if (!$row) {
        throw new Exception("Organizador no existe en persona");
    }
    $correoOrg = $row['correo'];

    /* 3-B) INSERT agenda  (id is an identity/serial on the server) */
    $insAgenda = $db->prepare("
        INSERT INTO agenda (correo_usuario, etiqueta)
        VALUES (:c, :e)
        RETURNING id
    ");
    $insAgenda->execute([
        ':c' => $correoOrg,
        ':e' => $nombre       // usamos “nombre del viaje” como etiqueta
    ]);
    $idAgenda = $insAgenda->fetchColumn();

    /* 3-C) Cargar participantes y reservas desde viajeros.csv ------------- */
    // $csvPath = __DIR__.'/viajeros.xlsx';
    // if (!is_readable($csvPath)) {
    //     throw new Exception('No puedo leer el archivo viajeros.xlsx');
    // }
    // $csv   = fopen($csvPath, 'r');
    // $first = true;

    // $insPart = $db->prepare(
    //     "INSERT INTO participante (correo, id_agenda, nombre)
    //      VALUES (:c, :a, :n)"
    // );
    // $insRes  = $db->prepare(
    //     "INSERT INTO reserva
    //            (id_agenda, correo_participante, monto,
    //             id_transporte, id_panorama, id_hospedaje)
    //      VALUES (:a, :c, :m, :t, :p, :h)"
    // );

    // while (($row = fgetcsv($csv, 0, ';')) !== false) {
    //     if ($first && preg_match('/correo/i', $row[0])) { $first = false; continue; }

    //     [$correo,$nombreP,$monto,$idT,$idP,$idH] = $row;

    //     $insPart->execute([
    //         ':c' => $correo,
    //         ':a' => $idAgenda,
    //         ':n' => $nombreP
    //     ]);
    //     $insRes->execute([
    //         ':a' => $idAgenda,
    //         ':c' => $correo,
    //         ':m' => $monto ?: 0,
    //         ':t' => $idT ?: null,
    //         ':p' => $idP ?: null,
    //         ':h' => $idH ?: null
    //     ]);
    // }
    // fclose($csv);

    /* 3-D) COMMIT  (el trigger trg_agenda_puntos se dispara solo) */
    $db->commit();
    header('Location: crear_viaje.php?mensaje=Agenda creada correctamente');
    exit();

} catch (Exception $e) {
    if (isset($db) && $db->inTransaction()) { $db->rollBack(); }
    error_log('[PCV] '.$e->getMessage());

    $msg = htmlspecialchars($e->getMessage());
    echo "<script>alert('Error al crear el viaje: {$msg}');</script>
          <p style='color:red'>Error al crear el viaje: {$msg}</p>
          <a href='crear_viaje.php'>← volver</a>";
}
?>


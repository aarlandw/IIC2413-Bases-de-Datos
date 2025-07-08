<?php
session_start();
require_once 'utils.php';

try {
    $usuario = $_POST['usuario'] ?? '';
    $contrasena = $_POST['contrasena'] ?? '';

    if (empty($usuario) || empty($contrasena)) {
        throw new Exception('Usuario o contraseña no pueden estar vacíos');
    }

    $db = conectarBD();

    // 1. Check if the user exists in persona and usuario
    $query = "SELECT P.username, P.contrasena
                FROM persona P
                JOIN usuario U ON P.correo = U.correo
                WHERE P.username = :usuario
            ";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':usuario', $usuario);
    $stmt->execute();
    $persona = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$persona) {
        // Check if the user exists in persona but is not a usuario (Empleado or Participante)
        $query2 = "SELECT * FROM persona WHERE username = :usuario";
        $stmt2 = $db->prepare($query2);
        $stmt2->bindParam(':usuario', $usuario);
        $stmt2->execute();
        $persona2 = $stmt2->fetch(PDO::FETCH_ASSOC);

        if ($persona2) {
            echo "<div style='color:red;'>Este usuario no tiene permisos para iniciar sesión.</div>";
        } else {
            echo "<div style='color:red;'>Usuario no existe</div>";
        }
        exit();
    }

    // 2. Check password
    if ($persona['contrasena'] !== $contrasena) {
        echo "<div style='color:red;'>Clave errónea</div>";
        exit();
    }

    // 3. Login successful
    // echo "<div style='color:green;'>Bienvenido, " . htmlspecialchars($persona['nombre']) . "!</div>";
    $_SESSION['usuario'] = $usuario;
    header('Location: main.php');
    exit();

} catch (PDOException $e) {
    echo "<div style='color:red;'>SQL Error: " . htmlspecialchars($e->getMessage()) . "</div>";
} catch (Exception $e) {
    echo "<div style='color:red;'>Error: " . htmlspecialchars($e->getMessage()) . "</div>";
}
?>

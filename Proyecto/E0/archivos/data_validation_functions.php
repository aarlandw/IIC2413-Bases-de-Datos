<?php


function isValidInteger($value)
{
    return filter_var($value, FILTER_VALIDATE_INT) !== false;
}

function isValidFloat($value)
{
    return filter_var($value, FILTER_VALIDATE_FLOAT) !== false;
}



function isValidRun($run)
{
    if (!is_string($run)) return false;
    if (empty($run)) return false;

    $standardizedRun = preg_replace('/\D/', '', $run);

    // Check if the standardized run is a valid natural number (non-zero)
    return (preg_match('/^[1-9]\d{0,7}$/', $standardizedRun));
}

function getStandardizedRUN($run)
{
    try {
        $standardizedRun = preg_replace('/\D/', '', $run);
        return $standardizedRun;
    } catch (Exception $e) {
        echo "Error: " . $e->getMessage();
    }
}

function isValidDV($dv)
{
    if (empty($dv)) return false;
    return preg_match('/^[0-9kK]$/', $dv);
}

function isValidEmail($email)
{
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) return false;

    $allowedDomains = [
        'viajes.cl',
        'tourket.com',
        'wass.com',
        'marmol.com',
        'outluc.com',
        'edubus.cal',
        'viajesanma.com'
    ];

    $domain = substr(strrchr($email, '@'), 1);
    return in_array($domain, $allowedDomains);
}

function isValidDate($date)
{
    // if (empty($date)) return false;
    return preg_match('/^\d{4}-\d{2}-\d{2}$/', $date);
}

function isValidPhone($phone)
{
    if (empty($phone)) return false;
    $phone = preg_replace('/[^\d+]/', '', $phone);
    return preg_match("/^\+56\d{9}$/", $phone);
}

function isValidCodigoReserva($codigo_reserva)
{
    if (empty($codigo_reserva)) return false;
    return isValidInteger($codigo_reserva);
}

function isValidMonto($monto)
{
    if (empty($monto)) return false;
    return isValidFloat($monto);
}

function isValidCodigoAgenda($codigo_agenda)
{
    if (empty($codigo_agenda)) return false;
    return isValidInteger($codigo_agenda);
}

// function isValidContrasena($contrasena)
// {
//     return empty($contrasena);
// }

// function isValidNumeroViaje($numViaje)
// {
//     return isValidInteger($numViaje);
// }

// function isValidPrecioAsientos($precioAsientos)
// {
//     return isValidInteger($precioAsientos);
// }

function isValidString(string $string): bool
{
    if (empty($string)) return false;

    // Check if the string contains only letters (including accented characters) and spaces
    return preg_match('/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/u', $string);
}

function isValidEstadoDisponibilidad($estado)
{
    $validStates = [
        'disponible',
        'no disponible'
    ];
    $estado = strtolower($estado);
    return in_array($estado, $validStates);
}

function isValidBusType($tipo_de_bus)
{
    $validBusTypes = [
        'normal',
        'semi-cama',
        'cama',
    ];
    $tipo_de_bus = strtolower($tipo_de_bus);
    return in_array($tipo_de_bus, $validBusTypes);
}

function isValidComodidades($comodidades)
{
    $validComodidades = [
        'wifi',
        'tv',
        'climatizacion',
        'baño'
    ];
    $comodidades = strtolower($comodidades);
    return in_array($comodidades, $validComodidades);
}


function isValidClaseDeAvion($clase)
{
    $validClasses = [
        'primera clase', 
        'clase ejecutiva',
        'clase económica'
    ];
    $clase = strtolower($clase);
    return in_array($clase, $validClasses);
}

function normalizeListField(string $raw): array {
    $raw = strtolower($raw);
    $cleaned = str_replace(['[', ']', '{', '}', '"', "'"], '', $raw);

    $cleaned = str_replace(',', ';', $cleaned);

    $items = explode(';', $cleaned);
    $items = array_map('trim', $items);
    $items = array_filter($items);

    return array_values($items);
}



function validateListValues(array $items, array $allowed): bool {
    foreach ($items as $item) {
        if (!in_array($item, $allowed, true)) {
            return false;
        }
    }
    return true;
}

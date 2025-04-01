<?php

// Enums for CSV column names

enum EmpleadosColumns: int
{
    case nombre = 0;
    case run = 1;
    case dv = 2;
    case correo = 3;
    case nombre_usuario = 4;
    case contrasena = 5;
    case telefono_contacto = 6;
    case jornada = 7;
    case isapre = 8;
    case contrato = 9;
    case codigo_reserva = 10;
    case codigo_agenda = 11;
    case fecha = 12;
    case monto = 13;
    case cantidad_personas = 14;
    case estado_disponibilidad = 15;
    case numero_viaje = 16;
    case lugar_origen = 17;
    case lugar_llegada = 18;
    case fecha_salida = 19;
    case fecha_llegada = 20;
    case capacidad = 21;
    case tiempo_estimado = 22;
    case precio_asiento = 23;
    case empresa = 24;
    case tipo_de_bus = 25;
    case comodidades = 26;
    case escalas = 27;
    case clase = 28;
    case paradas = 29;
}


enum UsuariosColumns: int
{
    case nombre = 0;
    case run = 1;
    case dv = 2;
    case correo = 3;
    case nombre_usuario = 4;
    case contrasena = 5;
    case telefono_contacto = 6;
    case puntos = 7;
    case codigo_agenda = 8;
    case etiqueta = 9;
    case codigo_reserva = 10;
    case fecha = 11;
    case monto = 12;
    case cantidad_personas = 13;
}

function getEnumNames(array $enum): array
{
    return array_map(fn($case) => $case->name, $enum);
}

// ------------------------------------------------------------------------

// DATA VALIDATION FUNCTIONS

// ------------------------------------------------------------------------


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


// ------------------------------------------------------------------------
// DATA VALIDATION MAPS
// ------------------------------------------------------------------------


function getUsuariosValidationMap(): array
{
    return [
        UsuariosColumns::nombre->name => ['nullable' => true, 'validatorFunction' => null],
        UsuariosColumns::run->name => ['nullable' => false, 'validatorFunction' => 'isValidRun'],
        UsuariosColumns::dv->name => ['nullable' => false, 'validatorFunction' => 'isValidDV'],
        UsuariosColumns::correo->name => ['nullable' => false, 'validatorFunction' => 'isValidEmail'],
        UsuariosColumns::nombre_usuario->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        UsuariosColumns::contrasena->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        UsuariosColumns::telefono_contacto->name => ['nullable' => false, 'validatorFunction' => 'isValidPhone'],
        UsuariosColumns::puntos->name => ['nullable' => true, 'validatorFunction' => 'isValidInteger'],
        UsuariosColumns::codigo_agenda->name => ['nullable' => false, 'validatorFunction' => 'isValidInteger'],
        UsuariosColumns::etiqueta->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        UsuariosColumns::codigo_reserva->name => ['nullable' => false, 'validatorFunction' => 'isValidCodigoReserva'],
        UsuariosColumns::fecha->name => ['nullable' => true, 'validatorFunction' => 'isValidDate'],
        UsuariosColumns::monto->name => ['nullable' => false, 'validatorFunction' => 'isValidMonto'],
        UsuariosColumns::cantidad_personas->name => ['nullable' => true, 'validatorFunction' => 'isValidInteger'],
    ];
}

function getEmpleadosValidationMap(): array
{
    return [
        EmpleadosColumns::nombre->name => ['nullable' => true, 'validatorFunction' => null],
        EmpleadosColumns::run->name => ['nullable' => false, 'validatorFunction' => 'isValidRun'],
        EmpleadosColumns::dv->name => ['nullable' => false, 'validatorFunction' => 'isValidDV'],
        EmpleadosColumns::correo->name => ['nullable' => false, 'validatorFunction' => 'isValidEmail'],
        EmpleadosColumns::nombre_usuario->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::contrasena->name => ['nullable' => false, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::telefono_contacto->name => ['nullable' => false, 'validatorFunction' => 'isValidPhone'],
        EmpleadosColumns::jornada->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::isapre->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::contrato->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::codigo_reserva->name => ['nullable' => false, 'validatorFunction' => 'isValidCodigoReserva'],
        EmpleadosColumns::codigo_agenda->name => ['nullable' => false, 'validatorFunction' => 'isValidInteger'],
        EmpleadosColumns::fecha->name => ['nullable' => true, 'validatorFunction' => 'isValidDate'],
        EmpleadosColumns::monto->name => ['nullable' => false, 'validatorFunction' => 'isValidMonto'],
        EmpleadosColumns::cantidad_personas->name => ['nullable' => true, 'validatorFunction' => 'isValidInteger'],
        EmpleadosColumns::estado_disponibilidad->name => ['nullable' => true, 'validatorFunction' => 'isValidEstadoDisponibilidad'],
        EmpleadosColumns::numero_viaje->name => ['nullable' => false, 'validatorFunction' => 'isValidInteger'],
        EmpleadosColumns::lugar_origen->name => ['nullable' => true, 'validatorFunction' => 'isValidString'],
        EmpleadosColumns::lugar_llegada->name => ['nullable' => true, 'validatorFunction' => 'isValidString'],
        EmpleadosColumns::fecha_salida->name => ['nullable' => true, 'validatorFunction' => 'isValidDate'],
        EmpleadosColumns::fecha_llegada->name => ['nullable' => false, 'validatorFunction' => 'isValidDate'],
        EmpleadosColumns::capacidad->name => ['nullable' => true, 'validatorFunction' => 'isValidInteger'],
        EmpleadosColumns::tiempo_estimado->name => ['nullable' => true, 'validatorFunction' => 'isValidInteger'],
        EmpleadosColumns::precio_asiento->name => ['nullable' => false, 'validatorFunction' => 'isValidInteger'],
        EmpleadosColumns::empresa->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::tipo_de_bus->name => ['nullable' => true, 'validatorFunction' => 'isValidBusType'],
        EmpleadosColumns::comodidades->name => ['nullable' => true, 'validatorFunction' => 'isValidComodidades'],
        EmpleadosColumns::escalas->name => ['nullable' => true, 'validatorFunction' => 'is_string'],
        EmpleadosColumns::clase->name => ['nullable' => true, 'validatorFunction' => 'isValidClaseDeAvion'],
        EmpleadosColumns::paradas->name => ['nullable' => true, 'validatorFunction' => 'isValidStringArray'],
    ];
}


function getPersonUsuario(): array
{
    return [
        UsuariosColumns::nombre,
        UsuariosColumns::run,
        UsuariosColumns::dv,
        UsuariosColumns::correo,
        UsuariosColumns::contrasena,
        UsuariosColumns::nombre_usuario,
        UsuariosColumns::telefono_contacto,
    ];
}

function getPersonEmpleados(): array
{
    return [
        EmpleadosColumns::nombre,
        EmpleadosColumns::run,
        EmpleadosColumns::dv,
        EmpleadosColumns::correo,
        EmpleadosColumns::contrasena,
        EmpleadosColumns::nombre_usuario,
        EmpleadosColumns::telefono_contacto,
    ];
}

function getDatosUsuarios(): array
{
    return [
        UsuariosColumns::nombre,
        UsuariosColumns::run,
        UsuariosColumns::dv,
        UsuariosColumns::correo,
        UsuariosColumns::contrasena,
        UsuariosColumns::nombre_usuario,
        UsuariosColumns::telefono_contacto,
        UsuariosColumns::puntos,
    ];
}

function getDatosEmpleados(): array
{
    return [
        EmpleadosColumns::nombre,
        EmpleadosColumns::run,
        EmpleadosColumns::dv,
        EmpleadosColumns::correo,
        EmpleadosColumns::contrasena,
        EmpleadosColumns::nombre_usuario,
        EmpleadosColumns::telefono_contacto,
        EmpleadosColumns::jornada,
        EmpleadosColumns::isapre,
        EmpleadosColumns::contrato,
    ];
}

function getAgendaUsuarios(): array
{
    return [
        UsuariosColumns::correo,
        UsuariosColumns::codigo_agenda,
        UsuariosColumns::etiqueta,
    ];
}

function getReservasEmpleados(): array
{
    return [
        EmpleadosColumns::codigo_agenda,
        EmpleadosColumns::codigo_reserva,
        EmpleadosColumns::fecha,
        EmpleadosColumns::monto,
        EmpleadosColumns::cantidad_personas,
        EmpleadosColumns::estado_disponibilidad,
    ];
}

function getTransportesEmpleados(): array
{
    return [
        EmpleadosColumns::correo,
        EmpleadosColumns::codigo_reserva,
        EmpleadosColumns::numero_viaje,
        EmpleadosColumns::lugar_origen,
        EmpleadosColumns::lugar_llegada,
        EmpleadosColumns::capacidad,
        EmpleadosColumns::tiempo_estimado,
        EmpleadosColumns::precio_asiento,
        EmpleadosColumns::empresa,
        EmpleadosColumns::fecha_salida,
        EmpleadosColumns::fecha_llegada,
    ];
}

function getBusesEmpleados(): array
{
    return [
        EmpleadosColumns::correo,
        EmpleadosColumns::codigo_reserva,
        EmpleadosColumns::numero_viaje,
        EmpleadosColumns::lugar_origen,
        EmpleadosColumns::lugar_llegada,
        EmpleadosColumns::capacidad,
        EmpleadosColumns::tiempo_estimado,
        EmpleadosColumns::precio_asiento,
        EmpleadosColumns::empresa,
        EmpleadosColumns::tipo_de_bus,
        EmpleadosColumns::comodidades,
        EmpleadosColumns::fecha_salida,
        EmpleadosColumns::fecha_llegada,
    ];
}

function getTrenesEmpleados(): array
{
    return [
        EmpleadosColumns::correo,
        EmpleadosColumns::codigo_reserva,
        EmpleadosColumns::numero_viaje,
        EmpleadosColumns::lugar_origen,
        EmpleadosColumns::lugar_llegada,
        EmpleadosColumns::capacidad,
        EmpleadosColumns::tiempo_estimado,
        EmpleadosColumns::precio_asiento,
        EmpleadosColumns::empresa,
        EmpleadosColumns::comodidades,
        EmpleadosColumns::paradas,
        EmpleadosColumns::fecha_salida,
        EmpleadosColumns::fecha_llegada,
    ];
}

function getAvionesEmpleados(): array
{
    return [
        EmpleadosColumns::correo,
        EmpleadosColumns::codigo_reserva,
        EmpleadosColumns::numero_viaje,
        EmpleadosColumns::lugar_origen,
        EmpleadosColumns::lugar_llegada,
        EmpleadosColumns::capacidad,
        EmpleadosColumns::tiempo_estimado,
        EmpleadosColumns::precio_asiento,
        EmpleadosColumns::empresa,
        EmpleadosColumns::escalas,
        EmpleadosColumns::fecha_salida,
        EmpleadosColumns::fecha_llegada,
    ];
}



// ----------------------------------------------------------------
// CSV HANDLING FUNCTIONS
// ----------------------------------------------------------------
function readCSV($filePath)
{
    // Check if file exists
    if (!file_exists($filePath) || !is_readable($filePath)) {
        echo "File not found or is not readable: $filePath\n";
        return false;
    }

    $data = [];
    $header = null;
    // Open the CSV file for reading
    if (($handle = fopen($filePath, 'r')) !== false) {
        // Read CSV data row by row
        while (($row = fgetcsv($handle, 999, ',')) !== false) {
            if (!$header) {
                // Store the first row as header
                $header = $row;
                continue;
            }
            $data[] = array_combine($header, $row);
        }
        fclose($handle);
    }

    return $data;
}

function writeCSV(array $data, string $filePath, array $header): void
{
    assert($filePath !== '', 'File path cannot be empty');
    assert($header !== [], 'Header cannot be empty');

    // Check if data is empty
    if (empty($data)) {
        echo "No data to write to the file: $filePath\n";
        return;
    }
   
    // Open the file for writing (or create it if it doesn't exist)
    if (($handle = fopen($filePath, 'w')) !== false) {
        // Write the header row
        fputcsv($handle, $header);

        // Write each row of data into the file
        foreach ($data as $row) {
            fputcsv($handle, $row);
        }
        fclose($handle);
    } else {
        echo "Error opening the file for writing: $filePath\n";
    }
}





// ----------------------------------------------------------------
// DATA FILTERING FUNCTIONS
// ----------------------------------------------------------------
function filterValidationMap(array $columnMap, array $fullValidationMap): array
{
    $filtered = [];

    foreach ($columnMap as $enum) {
        $key = $enum->name; // Use the string name of the enum as the key
        if (isset($fullValidationMap[$key])) {
            $filtered[$key] = $fullValidationMap[$key];
        }
    }

    return $filtered;
}


function validateRow(array $row, array $validationMap): bool
{
    foreach ($validationMap as $key => $rule) {
        $value = $row[$key] ?? null;

        // Check if the field is nullable and the value is null or empty
        if ($rule['nullable'] && (is_null($value) || $value === '')) {
            continue; // Skip validation for nullable fields
        }

        // Skip validation if no validator function is defined
        if (empty($rule['validatorFunction'])) {
            continue; // No validation needed for this field
        }

        // Call the validator function dynamically
        $validator = $rule['validatorFunction'];
        if (!function_exists($validator) || !$validator($value)) {
            return false; // Validation failed
        }
    }
    return true; // All fields are valid
}


function extractPartialRow(array $row, array $validationMap): array
{
    $partialRow = [];

    foreach ($validationMap as $key => $rule) {
        if (isset($row[$key])) {
            $partialRow[$key] = $row[$key];
        }
    }

    return $partialRow;
}

function filterData(array $data, array $validationMap): array
{
    $filteredData = [];
    foreach ($data as $row) {
        if (validateRow($row, $validationMap)) {
            $filteredData[] = extractPartialRow($row, $validationMap);
        }
    }
    return $filteredData;
}

function filterAndWriteData(array $unfilteredData, array $validationMap, string $outputFilePath): void
{
    $filteredData = filterData($unfilteredData, $validationMap);
    writeCSV($filteredData, $outputFilePath, array_keys($validationMap));
}


function separateAndWriteInvalidData(array $data, array $validationMap, string $invalidOutputFilePath): array
{
    $cleanData = [];
    $invalidData = [];

    foreach ($data as $row) {
        if (validateRow($row, $validationMap)) {
            $cleanData[] = $row; 
        } else {
            $invalidData[] = $row; 
        }
    }

    
    if (!empty($invalidData)) {
        writeCSV($invalidData, $invalidOutputFilePath, array_keys($validationMap));
    }

    return $cleanData; 
}

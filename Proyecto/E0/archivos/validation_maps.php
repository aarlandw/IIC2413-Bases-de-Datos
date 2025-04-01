<?php

include 'enums.php';
include 'data_validation_functions.php';

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

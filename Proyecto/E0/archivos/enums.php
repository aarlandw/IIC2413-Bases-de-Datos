<?php

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
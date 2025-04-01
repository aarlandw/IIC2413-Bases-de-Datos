<?php
    include 'functions.php';


    $filePath_empleados_sucios = '../CSV_sucios/empleados_rescatados.csv';
    $filePath_usuarios_sucios = '../CSV_sucios/usuarios_rescatados.csv';

    $filePath_personas = '../CSV_limpios/personasOK.csv';
    $filePath_usuarios = '../CSV_limpios/usuariosOK.csv';
    $filePath_empleados = '../CSV_limpios/empleadosOK.csv';
    $filePath_agenda = '../CSV_limpios/agendaOK.csv';
    $filePath_reservas = '../CSV_limpios/reservasOK.csv';
    $filePath_transportes = '../CSV_limpios/transportesOK.csv';
    $filePath_buses = '../CSV_limpios/busesOK.csv';
    $filePath_trenes = '../CSV_limpios/trenesOK.csv';
    $filePath_aviones = '../CSV_limpios/avionesOK.csv';
    $filePath_descartados_usuarios = '../CSV_limpios/datos_descartados_usuarios.csv';
    $filePath_descartados_empleados = '../CSV_limpios/datos_descartados_empleados.csv';

    $empleados_data = readCSV($filePath_empleados_sucios);
    $usuarios_data = readCSV($filePath_usuarios_sucios);

    $usuariosValidationMap = getUsuariosValidationMap();
    $empleadosValidationMap = getEmpleadosValidationMap();


    $personUsuarioValidationMap = filterValidationMap(getPersonUsuario(), getUsuariosValidationMap());
    $personEmpleadosValidationMap = filterValidationMap(getPersonEmpleados(), getEmpleadosValidationMap());
    $datosUsuariosValMap = filterValidationMap(getDatosUsuarios(), getUsuariosValidationMap());
    $datosEmpleadosValMap = filterValidationMap(getDatosEmpleados(), getEmpleadosValidationMap());
    $agendaUsuariosValMap = filterValidationMap(getAgendaUsuarios(), getUsuariosValidationMap());
    $reservasEmpleadosValMap = filterValidationMap(getReservasEmpleados(), getEmpleadosValidationMap());
    $transportesValMap = filterValidationMap(getTransportesEmpleados(), getEmpleadosValidationMap());
    $busesValMap = filterValidationMap(getBusesEmpleados(), getEmpleadosValidationMap());
    $trenesValMap = filterValidationMap(getTrenesEmpleados(), getEmpleadosValidationMap());
    $avionesValMap = filterValidationMap(getAvionesEmpleados(), getEmpleadosValidationMap());

    //! Todo: Repeated code, fix for scalability, and readability
    $filteredPersonas = filterData($empleados_data, $personEmpleadosValidationMap);
    writeCSV($filteredPersonas, $filePath_personas, getEnumNames(getPersonUsuario()));

    $filteredPersonas = filterData($usuarios_data, $personUsuarioValidationMap);
    writeCSV($filteredPersonas, $filePath_personas, getEnumNames(getPersonUsuario()));

    $datosUsuarios = filterData($usuarios_data, $datosUsuariosValMap);
    writeCSV($datosUsuarios, $filePath_usuarios, getEnumNames(getDatosUsuarios()));

    $datosEmpleados  = filterData($empleados_data, $datosEmpleadosValMap);
    writeCSV($datosEmpleados, $filePath_empleados, getEnumNames(getDatosEmpleados()));

    $agendaUsuarios = filterData($usuarios_data, $agendaUsuariosValMap);
    writeCSV($agendaUsuarios, $filePath_agenda, getEnumNames(getAgendaUsuarios()));

    $reservasEmpleados = filterData($empleados_data, $reservasEmpleadosValMap);
    writeCSV($reservasEmpleados, $filePath_reservas, getEnumNames(getReservasEmpleados()));

    $transportes = filterData($empleados_data, $transportesValMap);
    writeCSV($transportes, $filePath_transportes, getEnumNames(getTransportesEmpleados()));

    $buses = filterData($empleados_data, $busesValMap);
    writeCSV($buses, $filePath_buses, getEnumNames(getBusesEmpleados()));

    $trenes = filterData($empleados_data, $trenesValMap);
    writeCSV($trenes, $filePath_trenes, getEnumNames(getTrenesEmpleados()));
    
    $aviones = filterData($empleados_data, $avionesValMap);
    writeCSV($aviones, $filePath_aviones, getEnumNames(getAvionesEmpleados()));

?>
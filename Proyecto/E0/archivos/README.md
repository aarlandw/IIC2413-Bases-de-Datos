# Entrega 0 - Bases de Datos IIC2413

- [Entrega 0 - Bases de Datos IIC2413](#entrega-0---bases-de-datos-iic2413)
  - [Credenciales del Estudiante](#credenciales-del-estudiante)
  - [Credenciales de Acceso al Servidor](#credenciales-de-acceso-al-servidor)
  - [Contenido del Informe](#contenido-del-informe)
    - [Estructura del Proyecto](#estructura-del-proyecto)
      - [Descripción de los Archivos](#descripción-de-los-archivos)
    - [Análisis de los Datos Proporcionados](#análisis-de-los-datos-proporcionados)
    - [Tipos de Errores de Datos Detectados y Soluciones Utilizadas](#tipos-de-errores-de-datos-detectados-y-soluciones-utilizadas)
    - [Nombres de los Archivos de Salida y Explicación de su Contenido](#nombres-de-los-archivos-de-salida-y-explicación-de-su-contenido)
    - [Instrucciones para Ejecutar el Programa](#instrucciones-para-ejecutar-el-programa)
    - [Mejoras Futuras](#mejoras-futuras)
      - [Características Faltantes](#características-faltantes)
      - [Calidad del Código](#calidad-del-código)


## Credenciales del Estudiante

**Nombre:** William Aarland  
**Número de Alumno:** 24410853  

## Credenciales de Acceso al Servidor

**Usuario UC:** waarland0@bdd1.ing.puc.cl  
**Contraseña:** 24410853  

---

## Contenido del Informe

En esta tarea se nos solicitó crear un programa que limpia datos provenientes de dos archivos CSV, en los cuales la integridad de los datos está comprometida. Dichos datos deben ser limpiados y filtrados según las especificaciones del [Enunciado de la Tarea](Enunciado_BDD_E0.pdf). El programa debe ser capaz de detectar y corregir errores en los datos, y generar nuevos archivos con los datos limpios.

### Estructura del Proyecto

A continuación se muestra la estructura del proyecto y sus archivos:

```pseudo
.
├── archivos
│   ├── functions.php
│   └── main.php
├── CSV_limpios
│   ├── agendaOK.csv
│   ├── avionesOK.csv
│   ├── busesOK.csv
│   ├── empleadosOK.csv
│   ├── personasOK.csv
│   ├── reservasOK.csv
│   ├── transportesOK.csv
│   ├── trenesOK.csv
│   └── usuariosOK.csv
├── CSV_sucios
│   ├── empleados_rescatados.csv
│   └── usuarios_rescatados.csv
├── Enunciado_BDD_E0.pdf
└── README.md

3 carpetas, 15 archivos
```

#### Descripción de los Archivos

- `archivos/`: Contiene los archivos PHP que manejan el proceso de limpieza y validación de datos.
  - `functions.php`: Contiene las funciones utilizadas para limpiar y validar los datos.
  - `main.php`: Archivo principal que ejecuta el programa.

- `CSV_limpios/`: Contiene los archivos CSV ya limpiados, generados por el programa.

- `CSV_sucios/`: Contiene los archivos CSV originales con datos corruptos que deben ser limpiados.

- `Enunciado_BDD_E0.pdf`: Documento del enunciado de la tarea que contiene las especificaciones y requisitos del trabajo.

- `README.md`: Este archivo, que contiene el informe y las instrucciones del proyecto.

---

### Análisis de los Datos Proporcionados

Se entregan dos archivos CSV: `empleados_rescatados.csv` y `usuarios_rescatados.csv`, que contienen información sobre empleados y usuarios respectivamente. La estructura de los archivos, sus columnas y valores permitidos se encuentran en el [Enunciado de la Tarea](Enunciado_BDD_E0.pdf), Sección 7 “Formato de los Datos (por archivo)”.

---

### Tipos de Errores de Datos Detectados y Soluciones Utilizadas

Esta sección describe los errores de datos encontrados y cómo se resolvieron. Por ejemplo:

- **Valores faltantes o `null`:** El programa verifica si la columna permite valores `null` según el enunciado. Si no se permiten, se descarta la fila correspondiente.

- **Valores inválidos:** El programa verifica si los valores en las columnas son válidos conforme al enunciado. Si no lo son, la fila se descarta.

- **Entradas duplicadas:** El programa no valida duplicados, ya que el enunciado no especifica que esto sea un requerimiento.

---

### Nombres de los Archivos de Salida y Explicación de su Contenido

A continuación, se enumeran los archivos de salida generados por el programa luego de limpiar y validar los datos:

- `personasOK.csv`: Contiene información personal general compartida por usuarios y empleados, como nombre, RUN, DV, correo, contraseña, nombre de usuario y número de contacto.

- `usuariosOK.csv`: Contiene información adicional específica de los usuarios, como los puntos acumulados. Esta información proviene de `usuarios_rescatados.csv`.

- `empleadosOK.csv`: Contiene información adicional específica de los empleados, como la jornada, isapre y tipo de contrato. Esta información proviene de `empleados_rescatados.csv`.

- `agendasOK.csv`: Contiene datos de las agendas asociadas a los usuarios, incluyendo correo del usuario, código de agenda, etiqueta y fecha de creación.

- `reservasOK.csv`: Contiene información de reservas realizadas por usuarios, como código de agenda, código de reserva, fecha, monto y cantidad de personas.

- `transportesOK.csv`: Contiene información general sobre los medios de transporte asignados a empleados, como correo del empleado, código de reserva, número de viaje, origen, destino, capacidad, tiempo estimado de viaje, precio del asiento y empresa.

- `busesOK.csv`: Contiene campos adicionales específicos de buses, como el tipo de bus y las comodidades (`comodidades`).

- `trenesOK.csv`: Contiene campos adicionales específicos de trenes, como las paradas (`paradas`) y las comodidades.

- `avionesOK.csv`: Contiene campos adicionales específicos de aviones, como las escalas (`escalas`) y la clase del viaje.

- `datos_descartados.csv`: Contiene las filas descartadas debido a errores de validación o campos requeridos faltantes.

---

### Instrucciones para Ejecutar el Programa

Es fundamental proporcionar instrucciones claras para ejecutar el programa (todos los pasos necesarios, como si se hiciera desde cero). Por ejemplo:

1. Las credenciales para conectarse al servidor se encuentran [aquí](#credenciales-de-acceso-al-servidor).
   - **Usuario:** waarland0  
   - **Contraseña:** 24410853  
   - **Nota:** La contraseña es la misma que el número de alumno.

2. **Conectarse al servidor vía SSH:**
   - Ejecutar el comando: `ssh JuanPerez@bdd1.ing.puc.cl`  
   - Ingresar la contraseña  

3. **Ejecutar el archivo `main.php`:**
   - Navegar a `./Sites/E0/archivos/`.  
   - Ejecutar el comando: `php main.php`.  
   - Esperar a que el proceso termine.

---

### Mejoras Futuras

#### Características Faltantes

- El programa no maneja filas que no son utilizadas. Estas deberían ser añadidas a `datos_descartados_usuarios.csv` y `datos_descartados_empleados.csv` para los archivos `usuarios` y `empleados`, respectivamente.

- El programa no verifica entradas duplicadas. Sería conveniente implementar lógica para manejar esto.

#### Calidad del Código

- Por falta de tiempo, existen áreas con código duplicado. La calidad podría mejorarse aplicando principios como modularidad, abstracción y ortogonalidad, lo que facilitaría la lectura y mantenimiento del código.

- Optimización del rendimiento para evitar cargar archivos completos en memoria.

- El archivo `functions.php` podría dividirse en múltiples archivos con funciones especializadas, lo que facilitaría su mantenimiento. Sin embargo, esto no se realizó debido a las restricciones del enunciado.

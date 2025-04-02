# Entrega 0 - Bases de datos IIC2413

**Nombre:** Nombre Completo
**Número de Alumno:** 12345678
### Credenciales de acceso
**Usuario Uc** usuario.uc@bdd1.ing.puc.cl
**Contraseña** hola1234


## Contenido del Informe

### 1. Análisis de los datos entregados en los archivos
En esta sección se debe realizar un análisis detallado de los tipos de datos presentes en los archivos proporcionados. Por ejemplo:

- Archivo `datos.csv`: contiene información sobre usuarios, con columnas como `nombre`, `edad`, y `correo electrónico`.
- Archivo `transacciones.csv`: incluye datos sobre transacciones, con columnas como `numero_transacción`, `correo_usuario`, `monto`, y `fecha`.

### 2. Tipos de errores de datos detectados por el programa y forma de solución utilizada
Aquí se deben describir los errores de datos encontrados y cómo se solucionaron. Por ejemplo:

Archivo `datos.csv`:
- Edad con decimal: Debido a las reglas de negocio, edad tiene que ser un número entero.
    - Solución: Se reemplazó el dato erroneo por el mismo número pero truncado.

Archivo `transacciones.csv`:
- id_transaccion nulo: Ya que un registro debe tener su identificador, se debe eliminar el registro.
    - Solución: Se eliminó el registro de la tabla y se envió a la tabla `transacciones_erroneas.csv`.

### 3. Nombre de los archivos de salida y explicación de su contenido
En esta sección se deben listar los archivos generados por el programa y describir su contenido. Por ejemplo:

- Archivo `usuarios_limpios.csv`: contiene los datos de usuarios después de la limpieza, con las mismas columnas que `datos.csv`.
- Archivo `transacciones_limpias.csv`: incluye las transacciones después de la limpieza, con las mismas columnas que `transacciones.csv`.
- Archivo `main.php`: es el archivo principal, con este ejecutamos el programa para la limpieza de datos. 

### 4. Instrucciones para ejecutar el programa
Es fundamental proporcionar instrucciones claras para ejecutar el programa (absolutamente todos los pasos necesarios, como si fueras a ejecutarlo de cero). Por ejemplo:

1. Credenciales para conectar al servidor:
    usuario: JuanPerez
    contraseña: 12345678
2. Conexión al servidor mediante ssh:
    ejecutar el comando ssh JuanPerez@bdd1.ing.puc.cl
    colocar contraseña
3. Ejecutar el archivo main.php
    dirigirse a ./Sites/E0/archivos/
    ejecutar el comando: php main.php
    esperar a que termine el proceso

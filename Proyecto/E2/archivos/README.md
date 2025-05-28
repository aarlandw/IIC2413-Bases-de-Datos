<!-- # IIC2413 - Bases de Datos: Entrega 2



## Assumptions

Based on the hierarchicaly strcuture when filtering `usuarious`, and `empleados` they must also fulfill the criterion of the `persona`.

How to handle duplicates, and potential missing information, two with the same primary key e.g. missing phone number?

## Cases

There were a case when inserting into `agenda` where there exists an correo, which does not exist in the `usuario` table.

When inserting data manually, ID could be done dynamically but in this case hard coding was the easiest given time and the SQL language.
 -->

# IIC2413 – Proyecto semestral - **Etapa 2**

Este README explica qué restricciones de integridad fueron implementadas en la base de datos y cómo reproducir toda la entrega desde cero.

- [IIC2413 – Proyecto semestral - **Etapa 2**](#iic2413--proyecto-semestral---etapa2)
  - [Información del Estudiante](#información-del-estudiante)
  - [Credenciales UC](#credenciales-uc)
  - [Estructura del directorio](#estructura-del-directorio)
  - [Restricciones de integridad implementadas (y por qué)](#restricciones-de-integridad-implementadas-y-porqué)
  - [Pasos para ejecutar y corregir la entrega](#pasos-para-ejecutar-y-corregir-la-entrega)
  - [Notas para el corrector](#notas-para-el-corrector)

## Información del Estudiante

| **Nombre Completo**     | **Número de Alumno** |
|-------------------------|----------------------|
| William Aarland      |     25401068 |

## Credenciales UC

| **Usuario UC**                       | **Contraseña** |
|-------------------------------------|----------------|
| waarland0@bdd1.ing.puc.cl         | 25401068 |

---

## Estructura del directorio

```
Sites/E2/
├─ archivos/
│  ├─ crear_tablas.sql        -- DDL completo con DROP/CREATE y checks
│  ├─ poblar_tablas.sql       -- carga CSV  + descartar inválidos
├─ consultas/                 -- 12 consultas pedidas
│  ├─ 1a.sql … 7d.sql
├─ csv/                       -- archivos fuente suministrados
│  ├─ personas.csv … review_seguro.csv
├─ descartados/               -- CSV generados automáticamente
│  ├─ personas_descartados.csv … airbnb_descartados.csv
└─ README.md                  -- este archivo
```

---

## Restricciones de integridad implementadas (y por qué)

| Tipo                  | Tabla / columna                                           | Regla                                                         | Motivo                              |
| --------------------- | --------------------------------------------------------- | ------------------------------------------------------------- | ----------------------------------- |
| **PK**                | *todas las tablas*                                        | `PRIMARY KEY` sobre id o correo                               | Identifica unívocamente cada tupla. |
| **FK**                | `empleado.correo` → `persona.correo`                      | Asegura que todo empleado sea una persona existente.          |                                     |
|                       | `usuario.correo` → `persona.correo`                       | Ídem para usuarios.                                           |                                     |
|                       | `agenda(correo_usuario)` → `usuario.correo`               | Agenda sólo pertenece a un usuario válido.                    |                                     |
|                       | `reserva(agenda_id)` → `agenda.id`            | Una reserva “no disponible” debe estar en la agenda correcta. |                                     |
|                       | `review.reserva_id` → `reserva.id` *(PK‑FK 1:1)*          | Un review siempre yace sobre una reserva y sólo uno.          |                                     |
|                       | `seguro.reserva_id` → `reserva.id`                        | Seguro ligado a una única reserva.                            |                                     |
|                       | `transporte/hospedaje/panorama.reserva_id`                | Mantiene relación 1‑a‑1 con la reserva.                       |                                     |
|                       | Sub‑tipos (`bus`,`tren`,`avion`, etc.) → padre            | Herencia relacional: integridad de especialización.           |                                     |
| **UNIQUE**            | `persona.username`, `persona.correo`, `persona.run`       | Evita duplicados de usuario.                                  |                                     |
| **NOT NULL**          | Atributos esenciales (nombres, id, fechas, etc.)          | El modelo exige que existan siempre.                          |                                     |
| **CHECK**             | `estrellas BETWEEN 1 AND 5`                               | Calificaciones discretas según enunciado.                     |                                     |
|                       | `precio/monto/valor/puntos > 0`                           | Precios y puntos nunca pueden ser negativos.                  |                                     |
|                       | `jornada IN ('Diurno','Nocturno')`, `tipo_bus` enum, etc. | Garantiza valores válidos según reglas de negocio.            |                                     |
|                       | `estado_disponibilidad IN ('Disponible','No disponible')` | Consistencia entre agenda y reserva.                          |                                     |
| **ON DELETE CASCADE** | Varios FK débiles (`participante`, `habitacion`)          | Eliminación encadenada para evitar huérfanos.                 |                                     |

*Todas las restricciones anteriores aparecen explícitas en* **`archivos/crear_tablas.sql`**.

---

## Pasos para ejecutar y corregir la entrega

1. **Conectarse al servidor o a tu PostgreSQL local**

   ```bash
   psql -d <tu_base> -U <usuario>
   ```

2. **Crear el esquema**

   ```bash
   \i archivos/crear_tablas.sql
   ```

3. **Cargar los CSV**

   ```bash
   \i archivos/poblar_tablas.sql
   ```

   *• Los registros que violen las restricciones se escriben automáticamente en `./descartados/`.*

4. **Ejecutar las consultas de la etapa**

   ```bash
   \i archivos/<numero de consulta>.sql
   ```

5. **(Durante desarrollo)** Si modificas CSVs o scripts, repite pasos 2‑4; los `DROP TABLE … CASCADE` en **crear\_tablas.sql** hacen que la ejecución sea idempotente.

---

## Notas para el corrector

* La carga usa tablas temporales *\_raw* y copia *todas* las columnas del CSV, luego inserta sólo las válidas.
* Identificadores artificiales fuera del rango original (por ejemplo IDs $\geq$ 9000 en Consulta 7) se eligieron para no colisionar con los datos reales.
* Scripts siguen el formato y nombres exactos requeridos por el enunciado.

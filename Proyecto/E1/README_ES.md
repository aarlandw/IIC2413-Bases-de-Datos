# Etapa 1 - IIC2413 Bases de Datos

- [Etapa 1 - IIC2413 Bases de Datos](#etapa-1---iic2413-bases-de-datos)
  - [Información del Estudiante](#información-del-estudiante)
  - [Credenciales UC](#credenciales-uc)
  - [1. Modelo E/R](#1-modelo-er)
  - [2. Identificación de Entidades Débiles y Justificación](#2-identificación-de-entidades-débiles-y-justificación)
    - [2.1 ROOM (Entidad Débil bajo HOTEL)](#21-room-entidad-débil-bajo-hotel)
  - [3. Identificación de Llaves Primarias/Compuestas y Justificación](#3-identificación-de-llaves-primariascompuestas-y-justificación)
  - [4. Explicación de las Cardinalidades en el Modelo E/R](#4-explicación-de-las-cardinalidades-en-el-modelo-er)
  - [5. Identificación de Jerarquías](#5-identificación-de-jerarquías)
  - [6. Esquema Relacional (BCNF)](#6-esquema-relacional-bcnf)
  - [7. Justificación de las Tablas de Relaciones](#7-justificación-de-las-tablas-de-relaciones)
  - [8. Justificación Sobre BCNF y la Coherencia del Diseño](#8-justificación-sobre-bcnf-y-la-coherencia-del-diseño)

## Información del Estudiante

| **Nombre Completo**     | **Número de Alumno** |
|-------------------------|----------------------|
| William Aarland      |     25401068 |

## Credenciales UC

| **Usuario UC**                       | **Contraseña** |
|-------------------------------------|----------------|
| waarland0@bdd1.ing.puc.cl         | 24410853 |

---

## 1. Modelo E/R

A continuación se muestra nuestro diagrama E/R final para el escenario de Booked.com. Incluye:

- **PERSON**, que almacena datos básicos (`run`, `dv`, `name`).
- **ACCOUNT**, que maneja los datos de inicio de sesión (`email`, `password`, `username`, `phone`).
- Una jerarquía **ISA** desde **ACCOUNT** hacia **USER** y **EMPLOYEE**.
- **AGENDA** (asociada a un único `USER`).
- **RESERVATION** (asociada 0..1 con una `AGENDA`).
- Una jerarquía **ISA** desde **RESERVATION** a `Transport`, `Hospedaje` y `Panorama`.
- Otra división **ISA** desde `Transport` a `Plane`, `Train`, `Bus` y desde `Hospedaje` a `Hotel` y `AirBnB`.
- **ROOM** como entidad débil dependiente de `Hotel`.
- **INSURANCE** que un `User` puede adquirir para cubrir una `Reservation`.
- **REVISIÓN** está relacionada tanto con `User`, como con `Reservation` y por lo tanto tiene una clave compuesta por `(userEmail, reservationCode)`.

![Diagrama E/R](E1_ER_diagram.png)

---

## 2. Identificación de Entidades Débiles y Justificación

### 2.1 ROOM (Entidad Débil bajo HOTEL)

En el diagrama, **ROOM** es una entidad débil. Su llave parcial es `roomNumber`, la cual es única **solamente** dentro del ámbito de un `Hotel` específico. Utilizamos un rombo doble (double diamond) en la relación de identificación **“has”** entre `Hotel` y `Room`. Si un `Hotel` se elimina, las entidades `Room` asociadas dejan de tener sentido.

---

## 3. Identificación de Llaves Primarias/Compuestas y Justificación

A continuación, se muestran algunos ejemplos de nuestro modelo. (Ajuste si los nombres difieren en su diagrama.)

1. **PERSON**  
   - Llave Primaria: `(run, dv)`  
   - Justificación: El RUN y DV (propio de Chile) identifican de forma única a cada persona.

2. **ACCOUNT**  
   - Llave Primaria: `email`  
   - Justificación: Cada cuenta se identifica de manera única por la dirección de correo electrónico.

3. **USER**  
   - Llave Primaria: `email` (FK a `ACCOUNT`)  
   - Justificación: El mismo correo de `ACCOUNT` se usa para `USER`, garantizando una correspondencia 1:1.

4. **EMPLOYEE**  
   - Llave Primaria: `email` (FK a `ACCOUNT`)  
   - Justificación: De forma similar, hace referencia a `ACCOUNT(email)`, formando otra relación de subtipo 1:1.

5. **AGENDA**  
   - Llave Primaria: `agendaCode`  
   - Justificación: Se utiliza un código o número para identificar cada agenda de forma única.

6. **RESERVATION**  
   - Llave Primaria: `reservationCode`  
   - Justificación: Cada reserva se identifica de forma única por su código.

7. **REVIEW**  
   - Llave Primaria: `(userEmail, reservationCode)`  
   - Justificación: Un usuario deja una reseña por reserva; este par define la combinación única.

8. **INSURANCE**  
   - Llave Primaria: `insuranceID`  
   - Justificación: Se genera un ID único para cada póliza de seguro.

9. **ROOM**  
   - **Entidad débil** con llave parcial `roomNumber` bajo la relación de `Hotel`.  
   - Justificación: `roomNumber` sólo es único dentro del hotel padre.

---

## 4. Explicación de las Cardinalidades en el Modelo E/R

1. **PERSON —HAS— ACCOUNT**  
   - **(1:N)** Una Persona puede tener múltiples Cuentas (con distintos correos).  
   - **(N:1)** Cada Cuenta pertenece a exactamente una Persona.

2. **ACCOUNT —ISA— (USER, EMPLOYEE)**  
   - Cada Cuenta puede especializarse como Usuario (User) o Empleado (Employee).  
   - En el diagrama, `USER` y `EMPLOYEE` heredan la llave primaria `email` de `ACCOUNT`.

3. **USER —OWNS— AGENDA**  
   - **(1:N)** Un solo Usuario puede tener varias Agendas.  
   - **(N:1)** Cada Agenda pertenece a un único Usuario.

4. **AGENDA —CONTAINS— RESERVATION**  
   - **(1:N)** Una Agenda puede contener muchas Reservas (Reservations).  
   - **(0..1)** Una Reserva puede aparecer en como máximo una Agenda (si está “booked” por un usuario).

5. **RESERVATION —ISA— (PANORAMA, HOSPEDAJE, TRANSPORT)**  
   - No hay cardinalidades numéricas en la relación ISA, cada subtipo hereda `reservationCode`.

6. **HOSPEDAJE —ISA— (HOTEL, AIRBNB)**  
   - Similarmente, cada lodging se clasifica como Hotel o AirBnB.

7. **HOTEL —HAS— ROOM** (Relación de Identificación)  
   - **(1:N)** Un Hotel puede tener varias Habitaciones (Rooms).  
   - `ROOM` depende de `HOTEL` para su identidad, por eso se modela como una entidad débil.

8. **TRANSPORT —ISA— (BUS, TRAIN, PLANE)**  
   - Nueva subdivisión. Cada Transporte corresponde a uno de estos tipos.

9. **EMPLOYEE —OPERATES— TRANSPORT**  
   - **(1:N)** Un Empleado puede manejar múltiples Transportes.  
   - **(N:1)** Cada Transporte es operado por un solo Empleado.

10. **USER —purchases— INSURANCE —covers— RESERVATION**  
    - Usualmente:
      - **(1:N)** de `User` a `Insurance` (un usuario puede comprar varios seguros).  
      - **(N:1)** de `Insurance` a `Reservation` (un seguro cubre una reserva concreta).

11. **USER —writes— REVIEW —has— RESERVATION**  
    - Escenario de “puente”: un usuario puede dejar muchas reseñas. Una reserva puede tener cero o una opinión. Una opinión siempre tiene un único usuario y reserva.
  
---

## 5. Identificación de Jerarquías

En nuestro diagrama se presentan varias relaciones **ISA**:

1. **ACCOUNT → USER, EMPLOYEE**  
   - Atributos compartidos en `ACCOUNT`, y campos específicos para `USER` (puntos) y `EMPLOYEE` (jornada, contrato, isapre).

2. **RESERVATION → TRANSPORT, HOSPEDAJE, PANORAMA**  
   - Atributos comunes en `RESERVATION` (e.g., `date`, `amount`) y atributos especializados en cada subtipo (e.g., `placeOrigin` para transportes).

3. **HOSPEDAJE → HOTEL, AIRBNB**  
   - Subdivisión adicional del lodging, con atributos distintos (e.g., `policies` para hotel, `hostName` / `hostNumber` para AirBnB).

4. **TRANSPORT → BUS, TRAIN, PLANE**  
   - Modos de transporte con atributos únicos (p. ej. `busType`, `paradas`, `escalas`).

En todas estas jerarquías ISA, los subtipos heredan llaves de la entidad padre.

---

## 6. Esquema Relacional (BCNF)

Aquí se presenta **un ejemplo** de cómo convertir las entidades/relaciones a un esquema relacional. (En el informe final, incluya todas las tablas con sus llaves primarias, foráneas y tipos de datos.)

```sql
-- PERSON
CREATE TABLE Person (
  run INT,
  dv CHAR(1),
  name VARCHAR(60),
  PRIMARY KEY (run, dv)
);

-- ACCOUNT
CREATE TABLE Account (
  email VARCHAR(100) PRIMARY KEY,
  run INT NOT NULL,
  dv CHAR(1) NOT NULL,
  password VARCHAR(100),
  username VARCHAR(50),
  phone VARCHAR(20),
  FOREIGN KEY (run, dv) REFERENCES Person(run, dv)
);

-- USER (ISA de ACCOUNT)
CREATE TABLE User (
  email VARCHAR(100) PRIMARY KEY,
  puntos INT,
  FOREIGN KEY (email) REFERENCES Account(email)
);

-- EMPLOYEE (ISA de ACCOUNT)
CREATE TABLE Employee (
  email VARCHAR(100) PRIMARY KEY,
  jornada VARCHAR(20),
  contrato VARCHAR(20),
  isapre VARCHAR(50),
  FOREIGN KEY (email) REFERENCES Account(email)
);

-- AGENDA
CREATE TABLE Agenda (
  agendaCode INT PRIMARY KEY,
  etiqueta VARCHAR(50),
  userEmail VARCHAR(100),
  FOREIGN KEY (userEmail) REFERENCES User(email)
);

-- RESERVATION
CREATE TABLE Reservation (
  reservationCode INT PRIMARY KEY,
  date DATE,
  amount FLOAT,
  numberOfPeople INT,
  status VARCHAR(20)  -- e.g. 'Disponible' o 'No disponible'
);

-- REVIEW (entidad independiente)
CREATE TABLE Review (
  userEmail VARCHAR(100),
  reservationCode INT,
  dateTime DATETIME,
  rating INT,
  description TEXT,
  PRIMARY KEY (userEmail, reservationCode),
  FOREIGN KEY (userEmail) REFERENCES User(email),
  FOREIGN KEY (reservationCode) REFERENCES Reservation(reservationCode)
);

-- INSURANCE
CREATE TABLE Insurance (
  insuranceID INT PRIMARY KEY,
  totalPrice FLOAT,
  insuranceType VARCHAR(50),
  clause TEXT,
  company VARCHAR(50),
  userEmail VARCHAR(100) NOT NULL,
  reservationCode INT NOT NULL,
  FOREIGN KEY (userEmail) REFERENCES User(email),
  FOREIGN KEY (reservationCode) REFERENCES Reservation(reservationCode)
);

-- TRANSPORT (ISA de Reservation)
CREATE TABLE Transport (
  reservationCode INT PRIMARY KEY,
  placeOrigin VARCHAR(50),
  placeArrival VARCHAR(50),
  capacity INT,
  estimatedTime INT,
  seatPrice FLOAT,
  company VARCHAR(50),
  departureDate DATE,
  arrivalDate DATE,
  FOREIGN KEY (reservationCode) REFERENCES Reservation(reservationCode)
);

-- BUS / TRAIN / PLANE (subtipos que referencian Transport)
CREATE TABLE Bus (
  reservationCode INT PRIMARY KEY,
  busType VARCHAR(30),
  amenities TEXT,
  FOREIGN KEY (reservationCode) REFERENCES Transport(reservationCode)
);

CREATE TABLE Train (
  reservationCode INT PRIMARY KEY,
  amenities TEXT,
  paradas TEXT,
  FOREIGN KEY (reservationCode) REFERENCES Transport(reservationCode)
);

CREATE TABLE Plane (
  reservationCode INT PRIMARY KEY,
  seatClass VARCHAR(30),
  escalas TEXT,
  FOREIGN KEY (reservationCode) REFERENCES Transport(reservationCode)
);

-- HOSPEDAJE (ISA de Reservation)
CREATE TABLE Hospedaje (
  reservationCode INT PRIMARY KEY,
  h_name VARCHAR(50),
  location VARCHAR(50),
  pricePerNight FLOAT,
  starRating INT,
  amenities TEXT,
  checkInDate DATE,
  checkOutDate DATE,
  FOREIGN KEY (reservationCode) REFERENCES Reservation(reservationCode)
);

-- HOTEL / AIRBNB (referencian Hospedaje)
CREATE TABLE Hotel (
  reservationCode INT PRIMARY KEY,
  policies TEXT,
  FOREIGN KEY (reservationCode) REFERENCES Hospedaje(reservationCode)
);

-- ROOM (Entidad débil bajo HOTEL)
CREATE TABLE Room (
  reservationCode INT NOT NULL,  -- PK parcial con hotel
  roomNumber INT NOT NULL,
  roomType VARCHAR(30),
  PRIMARY KEY (reservationCode, roomNumber),
  FOREIGN KEY (reservationCode) REFERENCES Hotel(reservationCode)
);

CREATE TABLE AirBnB (
  reservationCode INT PRIMARY KEY,
  hostName VARCHAR(50),
  hostNumber VARCHAR(20),
  description TEXT,
  FOREIGN KEY (reservationCode) REFERENCES Hospedaje(reservationCode)
);

-- PANORAMA (ISA de Reservation)
CREATE TABLE Panorama (
  reservationCode INT PRIMARY KEY,
  p_name VARCHAR(50),
  company VARCHAR(50),
  description TEXT,
  location VARCHAR(50),
  hoursDuration INT,
  capacity INT,
  restrictions TEXT,
  datePanorama DATE,
  FOREIGN KEY (reservationCode) REFERENCES Reservation(reservationCode)
);

-- EMPLOYEE - OPERATES - TRANSPORT
-- Si cada Transport está asignado a un solo Empleado:
ALTER TABLE Transport
  ADD COLUMN employeeEmail VARCHAR(100),
  ADD FOREIGN KEY (employeeEmail) REFERENCES Employee(email);
```

---

## 7. Justificación de las Tablas de Relaciones

- PERSON–ACCOUNT:

  - (1:N). Almacenamos (run, dv) como FK en Account. Cada Account referencia a una sola Person.

- ACCOUNT–ISA–USER y ACCOUNT–ISA–EMPLOYEE:

  - Separación en tablas User y Employee, cada una con FK email en Account(email).

- USER–OWNS–AGENDA:

  - (1:N). Agenda tiene userEmail como FK apuntando a User.

- AGENDA–CONTAINS–RESERVATION:

  - (1:N). Reserva tiene agendaCode como un FK a Agenda. Una agenda puede tener múltiples reservas.

- USER–writes–REVIEW–has–RESERVATION:

  - Un usuario puede escribir varias opiniones para diferentes reservas. Cada opinión hace referencia a User(email) y Reservation(reservationCode) como un PK compuesto.
  - Cada opinión sólo tiene una reserva, pero una reserva puede tener cero o una opinión.

- USER–purchases–INSURANCE–covers–RESERVATION:

  - Insurance referencia a User(email) y Reservation(reservationCode).

- RESERVATION–ISA–(TRANSPORT, HOSPEDAJE, PANORAMA):

  - Cada subtipo usa reservationCode como PK-FK a Reservation.

- HOSPEDAJE–ISA–(HOTEL, AIRBNB):

  - Hotel y AirBnB referencian Hospedaje(reservationCode).

- HOTEL–has–ROOM (entidad débil):

  - ROOM se identifica por (reservationCode, roomNumber).

- TRANSPORT–ISA–(BUS, TRAIN, PLANE):

  - Cada subtipo referencia Transport(reservationCode).

- EMPLOYEE–OPERATES–TRANSPORT:

  - Relación (1:N). En el esquema de ejemplo, añadimos employeeEmail en Transport como FK.

---

## 8. Justificación Sobre BCNF y la Coherencia del Diseño

- Fidelidad: El modelo captura todos los datos requeridos por las especificaciones: datos personales (Person), cuentas (Account), reservas, subtipos, etc.

- Redundancia: Al separar subtipos (ISA) y usar entidades específicas (p. ej. Review como tabla), minimizamos duplicación.

- Anomalías: Cada tabla tiene una llave primaria clara, por lo que se evitan problemas de actualización/eliminación/inserción incoherentes.

- Simplicidad: El esquema se organiza lógicamente en entidades (Reservation, Transport, User, etc.) con roles bien definidos.

- Elección de LLaves: Se utiliza reservationCode para reservas y subtipos, (userEmail, reservationCode) para reseñas, etc. Esto garantiza identificación única.

- BCNF: En cada tabla, todos los atributos no llave dependen únicamente de la PK. No hay dependencias parciales ni transitivas, lo que asegura BCNF.

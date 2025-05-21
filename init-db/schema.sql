CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email varchar(150) NOT NULL UNIQUE,
    password varchar(255) NOT NULL
);

CREATE TABLE roles(
    id SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE permisos(
    id SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    descripcion TEXT,
    subject varchar(100) NOT NULL,
    action varchar(100) NOT NULL
);

CREATE TABLE permiso_role(
    id SERIAL PRIMARY KEY,
    role_id INT NOT NULL,
    permiso_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (permiso_id) REFERENCES permisos(id)
);

CREATE TABLE role_user(
    id SERIAL PRIMARY KEY,
    role_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (user_id) REFERENCES users(id)    
);

CREATE TABLE personas (
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    telefono VARCHAR(20),
    direccion TEXT,
    documento_identidad VARCHAR(50) UNIQUE,
    tipo_documento VARCHAR(20),
    nacionalidad VARCHAR(50),
    user_id INT NOT NULL UNIQUE REFERENCES users(id)
);

CREATE TABLE entidad_comercial (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('cliente', 'proveedor')),
    razon_social varchar(255) NOT NULL,
    ci_nit_ruc_rut varchar(100),
    telefono varchar(20),
    direccion varchar(255),
    correo varchar(100),
    activo BOOLEAN NOT NULL
);

CREATE TABLE contactos (
    id SERIAL PRIMARY KEY,
    entidad_comercial_id INT NOT NULL,
    nombre_completo varchar(255),
    rol_contacto varchar(100),
    telefono_secundario varchar(20),
    correo_secundario varchar(150),
    observaciones TEXT,
    FOREIGN KEY (entidad_comercial_id) REFERENCES entidad_comercial(id)
);

CREATE TABLE sucursales (
    id SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    direccion varchar(255) NOT NULL,
    telefono varchar(20) NOT NULL,
    ciudad varchar(100) NOT NULL
);

CREATE TABLE sucursal_user (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    sucursal_id INT NOT NULL REFERENCES sucursales(id),
    role_id INT REFERENCES roles(id)
);

CREATE TABLE almacenes (
    id SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    codigo varchar(100),
    descripcion TEXT,
    sucursal_id INT NOT NULL ,
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id)
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre varchar(200) NOT NULL,
    descripcion TEXT,
    codigo_barra varchar(100) UNIQUE,
    unidad_medida varchar(50) NOT NULL,
    marca varchar(100),
    categoria_id INT NOT NULL,
    precio_venta_actual DECIMAL(12,2) NOT NULL,
    stock_minimo INT,
    imagen_url varchar(255),
    activo BOOLEAN NOT NULL,
    fecha_registro DATE NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE almacen_producto(
    id SERIAL PRIMARY KEY,
    cantidad_actual INT NOT NULL,
    fecha_actualizacion DATE NOT NULL,
    almacen_id INT NOT NULL UNIQUE,
    producto_id INT NOT NULL UNIQUE,
    FOREIGN KEY (almacen_id) REFERENCES almacenes(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE notas(
    id SERIAL PRIMARY KEY,
    codigo_nota varchar(100) NOT NULL UNIQUE,
    fecha_emision DATE NOT NULL,
    tipo_nota varchar(20) NOT NULL, 
    entidad_comercial_id INT NOT NULL,
    user_id INT NOT NULL,
    subtotal DECIMAL(12, 2),
    impuestos DECIMAL(12, 2),
    descuento_total DECIMAL(12, 2),
    total_calculado DECIMAL(12, 2) NOT NULL,
    estado_nota varchar(50) NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (entidad_comercial_id) REFERENCES entidad_comercial(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE movimientos(
    id SERIAL PRIMARY KEY,
    nota_id INT NOT NULL,
    producto_id INT NOT NULL,
    almacen_id INT NOT NULL,
    cantidad INT NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL CHECK (tipo_movimiento IN ('ingreso', 'salida', 'devolucion')),
    precio_unitario_compra DECIMAL(12, 2) NOT NULL,
    precio_unitario_venta DECIMAL(12, 2) NOT NULL,
    total_linea DECIMAL(12, 2) NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (nota_id) REFERENCES notas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (almacen_id) REFERENCES almacenes(id)
);
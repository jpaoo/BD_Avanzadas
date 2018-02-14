--AUTORES
CREATE TABLE PROYECTO_AUTORES(ID_AUTOR NUMBER, NOMBBRE VARCHAR(100));
ALTER TABLE PROYECTO_AUTORES ADD CONSTRAINT PK_AUTORES PRIMARY KEY (ID_AUTOR);

CREATE TABLE PROYECTO_CLIENTES (ID_CLIENTE NUMBER, RFC_CLIENTE VARCHAR(20), NOMBRE VARCHAR(100), TELEFONO VARCHAR(10), EMAIL VARCHAR(100));
ALTER TABLE PROYECTO_CLIENTES ADD CONSTRAINT PK_CLIENTES PRIMARY KEY (ID_CLIENTE);

CREATE TABLE PROYECTO_GENEROS (ID_GENERO NUMBER, NOMBRE VARCHAR(50));
ALTER TABLE PROYECTO_GENEROS ADD CONSTRAINT PK_GENEROS PRIMARY KEY (ID_GENERO);

CREATE TABLE PROYECTO_EDITORIALES (ID_EDITORIAL NUMBER, NOMBRE VARCHAR(100), PAIS VARCHAR(50));
ALTER TABLE PROYECTO_EDITORIALES ADD CONSTRAINT PK_EDITORIALES PRIMARY KEY (ID_EDITORIAL);

CREATE TABLE PROYECTO_METODOS_PAGO (ID_METODO_PAGO NUMBER, NOMBRE VARCHAR(30));
ALTER TABLE PROYECTO_METODOS_PAGO ADD CONSTRAINT PK_METODOS_PAGO PRIMARY KEY (ID_METODO_PAGO);

CREATE TABLE PROYECTO_PROVEEDORES (ID_PROVEEDOR NUMBER, RFC_PROVEEDOR VARCHAR(50), NOMBRE VARCHAR(100), EMAIL VARCHAR (100), DIRECCION VARCHAR(100), TELEFONO VARCHAR(10), CANTIDADMAX NUMBER);
ALTER TABLE PROYECTO_PROVEEDORES ADD CONSTRAINT PK_PROVEEDORES PRIMARY KEY (ID_PROVEEDOR);

CREATE TABLE PROYECTO_SUCURSALES (ID_SUCURSAL NUMBER, DIRECCION VARCHAR(100));
ALTER TABLE PROYECTO_SUCURSALES ADD CONSTRAINT PK_SUCURSALES PRIMARY KEY (ID_SUCURSAL);

CREATE TABLE PROYECTO_LIBROS (ID_LIBRO NUMBER, ISBN VARCHAR(30), ID_AUTOR NUMBER, ID_GENERO NUMBER, ID_EDITORIAL NUMBER, TITULO VARCHAR (100), PAGINAS NUMBER, PRECIO NUMBER(6,2), ANIO NUMBER);
ALTER TABLE PROYECTO_LIBROS ADD CONSTRAINT PK_LIBROS PRIMARY KEY (ID_LIBRO);
ALTER TABLE PROYECTO_LIBROS ADD CONSTRAINT FK_AUTOR FOREIGN KEY (ID_AUTOR) REFERENCES PROYECTO_AUTORES(ID_AUTOR);
ALTER TABLE PROYECTO_LIBROS ADD CONSTRAINT FK_GENERO FOREIGN KEY (ID_GENERO) REFERENCES PROYECTO_GENEROS(ID_GENERO);
ALTER TABLE PROYECTO_LIBROS ADD CONSTRAINT FK_EDITORIAL FOREIGN KEY (ID_EDITORIAL) REFERENCES PROYECTO_EDITORIAL(ID_EDITORIAL);

CREATE TABLE PROYECTO_COMPRAS (ID_COMPRA NUMBER, ID_METODO_PAGO NUMBER, ID_CLIENTE NUMBER, FECHA DATETIME, MONTO NUMBER(9,2), CANTIDAD NUMBER);
ALTER TABLE PROYECTO_COMPRAS ADD CONSTRAINT PK_COMPRA PRIMARY KEY (ID_COMPRA);
ALTER TABLE PROYECTO_COMPRAS ADD CONSTRAINT FK_METODO_PAGO FOREIGN KEY (ID_METODO_PAGO) REFERENCES PROYECTO_METODOS_PAGO(ID_METODO_PAGO);
ALTER TABLE PROYECTO_COMPRAS ADD CONSTRAINT FK_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES PROYECTO_CLIENTES(ID_CLIENTE);

CREATE TABLE PROYECTO_ORDENESCOMPRA (ID_ORDENCOMPRA NUMBER, ID_SUCURSAL NUMBER, ID_PROVEEDOR NUMBER, FECHA DATETIME);
ALTER TABLE PROYECTO_ORDENESCOMPRA ADD CONSTRAINT PK_OC PRIMARY KEY (ID_ORDENCOMPRA);
ALTER TABLE PROYECTO_ORDENESCOMPRA ADD CONSTRAINT FK_SUCURSAL FOREIGN KEY (ID_SUCURSAL) REFERENCES PROYECTO_SUCURSALES(ID_SUCURSAL);
ALTER TABLE PROYECTO_ORDENESCOMPRA ADD CONSTRAINT FK_PROVEEDOR FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROYECTO_PROVEEDORES(ID_PROVEEDOR);

CREATE TABLE PROYECTO_ORDENESLIBRO (ID_ORDENCOMPRA NUMBER, ID_LIBRO NUMBER);
ALTER TABLE PROYECTO_ORDENESLIBRO ADD CONSTRAINT FK_OC PRIMARY KEY (ID_ORDENCOMPRA) REFERENCES PROYECTO_ORDENESCOMPRA(ID_ORDENCOMPRA);
ALTER TABLE PROYECTO_ORDENESLIBRO ADD CONSTRAINT FK_L PRIMARY KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);

CREATE TABLE PROYECTO_LIBROSPROVEEDOR (ID_LIBRO NUMBER, ID_PROVEEDOR NUMBER, COSTO NUMBER(6,2));
ALTER TABLE PROYECTO_LIBROSPROVEEDOR ADD CONSTRAINT FK_LIBRO PRIMARY KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);
ALTER TABLE PROYECTO_LIBROSPROVEEDOR ADD CONSTRAINT FK_PROV PRIMARY KEY (ID_PROVEEDOR) REFERENCES PROYECTO_PROVEEDORES(ID_PROVEEDOR);

CREATE TABLE PROYECTO_LIBROSSUCURSAL (ID_LIBRO NUMBER, ID_SUCURSAL NUMBER, CANTIDAD NUMBER, CANTIDADMINIMA NUMBER);
ALTER TABLE PROYECTO_LIBROSSUCURSAL ADD CONSTRAINT FK_LIBRO PRIMARY KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);
ALTER TABLE PROYECTO_LIBROSSUCURSAL ADD CONSTRAINT FK_SUCURSAL PRIMARY KEY (ID_SUCURSAL) REFERENCES PROYECTO_SUCURSALES(ID_SUCURSAL);

CREATE TABLE PROYECTO_COMPRASLIBRO ADD CONSTRAINT (ID_COMPRA NUMBER, ID_LIBRO);
ALTER TABLE PROYECTO_COMPRASLIBRO ADD CONSTRAINT FK_COMPRA FOREIGN KEY (ID_COMPRA) REFERENCES PROYECTO_COMPRAS(ID_COMPRA);
ALTER TABLE PROYECTO_COMPRASLIBRO ADD CONSTRAINT FK_LIBRO FOREIGN KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);
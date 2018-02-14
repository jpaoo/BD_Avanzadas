--AUTORES

DROP TABLE PROYECTO_COMPRASLIBRO CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_LIBROSSUCURSAL CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_LIBROSPROVEEDOR CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_ORDENESLIBRO CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_ORDENESCOMPRA CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_COMPRAS CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_LIBROS CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_SUCURSALES CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_PROVEEDORES CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_METODOS_PAGO CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_EDITORIALES CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_GENEROS CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_CLIENTES CASCADE CONSTRAINTS;
DROP TABLE PROYECTO_AUTORES CASCADE CONSTRAINTS;


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
ALTER TABLE PROYECTO_LIBROS ADD CONSTRAINT FK_EDITORIAL FOREIGN KEY (ID_EDITORIAL) REFERENCES PROYECTO_EDITORIALES(ID_EDITORIAL);

CREATE TABLE PROYECTO_COMPRAS (ID_COMPRA NUMBER, ID_METODO_PAGO NUMBER, ID_CLIENTE NUMBER, FECHA DATE, MONTO NUMBER(9,2), CANTIDAD NUMBER);
ALTER TABLE PROYECTO_COMPRAS ADD CONSTRAINT PK_COMPRA PRIMARY KEY (ID_COMPRA);
ALTER TABLE PROYECTO_COMPRAS ADD CONSTRAINT FK_METODO_PAGO FOREIGN KEY (ID_METODO_PAGO) REFERENCES PROYECTO_METODOS_PAGO(ID_METODO_PAGO);
ALTER TABLE PROYECTO_COMPRAS ADD CONSTRAINT FK_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES PROYECTO_CLIENTES(ID_CLIENTE);

CREATE TABLE PROYECTO_ORDENESCOMPRA (ID_ORDENCOMPRA NUMBER, ID_SUCURSAL NUMBER, ID_PROVEEDOR NUMBER, FECHA DATE);
ALTER TABLE PROYECTO_ORDENESCOMPRA ADD CONSTRAINT PK_OC PRIMARY KEY (ID_ORDENCOMPRA);
ALTER TABLE PROYECTO_ORDENESCOMPRA ADD CONSTRAINT FK_SUCURSAL_ORDENES FOREIGN KEY (ID_SUCURSAL) REFERENCES PROYECTO_SUCURSALES(ID_SUCURSAL);
ALTER TABLE PROYECTO_ORDENESCOMPRA ADD CONSTRAINT FK_PROVEEDOR FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROYECTO_PROVEEDORES(ID_PROVEEDOR);

CREATE TABLE PROYECTO_ORDENESLIBRO (ID_ORDENCOMPRA NUMBER, ID_LIBRO NUMBER);
ALTER TABLE PROYECTO_ORDENESLIBRO ADD CONSTRAINT FK_OC FOREIGN KEY (ID_ORDENCOMPRA) REFERENCES PROYECTO_ORDENESCOMPRA(ID_ORDENCOMPRA);
ALTER TABLE PROYECTO_ORDENESLIBRO ADD CONSTRAINT FK_L FOREIGN KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);

CREATE TABLE PROYECTO_LIBROSPROVEEDOR (ID_LIBRO NUMBER, ID_PROVEEDOR NUMBER, COSTO NUMBER(6,2));
ALTER TABLE PROYECTO_LIBROSPROVEEDOR ADD CONSTRAINT FK_LIBRO FOREIGN KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);
ALTER TABLE PROYECTO_LIBROSPROVEEDOR ADD CONSTRAINT FK_PROV FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROYECTO_PROVEEDORES(ID_PROVEEDOR);

CREATE TABLE PROYECTO_LIBROSSUCURSAL (ID_LIBRO NUMBER, ID_SUCURSAL NUMBER, CANTIDAD NUMBER, CANTIDADMINIMA NUMBER);
ALTER TABLE PROYECTO_LIBROSSUCURSAL ADD CONSTRAINT FK_LIBRO_SUC FOREIGN KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);
ALTER TABLE PROYECTO_LIBROSSUCURSAL ADD CONSTRAINT FK_SUCURSAL_LIBROS FOREIGN KEY (ID_SUCURSAL) REFERENCES PROYECTO_SUCURSALES(ID_SUCURSAL);

CREATE TABLE PROYECTO_COMPRASLIBRO (ID_COMPRA NUMBER, ID_LIBRO NUMBER);
ALTER TABLE PROYECTO_COMPRASLIBRO ADD CONSTRAINT FK_COMPRA_COMPRAS FOREIGN KEY (ID_COMPRA) REFERENCES PROYECTO_COMPRAS(ID_COMPRA);
ALTER TABLE PROYECTO_COMPRASLIBRO ADD CONSTRAINT FK_LIBRO_COMPRAS FOREIGN KEY (ID_LIBRO) REFERENCES PROYECTO_LIBROS(ID_LIBRO);


CREATE DATABASE LINK "JP.QRO.ITESM.MX" CONNECT TO "A1208471" IDENTIFIED BY VALUES "9HeTuZu" USING 'qro';

DROP DATABASE LINK "KR.SLP.ITESM.MX";
CREATE DATABASE LINK "KR.SLP.ITESM.MX"
   CONNECT TO "A12700666" IDENTIFIED BY VALUES '06BB6F8434D249961EB71F89F8EDD0C0784DCDFD885D345D4CCE1DC66EAE60AF231A27E3491D8D7A78E455007C2C47989C95C27341AE253F72A6C282A97BBBD75BF1296B5FCA6FCE7447E16B7E8A38B53D0D56E0E55587CCCE823012D39E06406F58CE4820CBB27110641799BB80E7E4F5E55D1F834B40BCAF9C98BC3AF0DBAE'
   USING 'slp';
   
DROP DATABASE LINK "MM.QRO.ITESM.MX";
CREATE DATABASE LINK "MM.QRO.ITESM.MX"
   CONNECT TO "A1204818" IDENTIFIED BY VALUES '0618CA70209A23F4DACF02B792DED01350BD90ADB34D2E291C5B081272C1D553F0AB945FB96B9DE5A3075835311CA0A8E03879BBD4EE059FB6CDD4CAEFCEFDB3FAEE80DE3D8A8424646BAABC71BF105E6401D4E3EB623370374243C8394A28332A63F5AC2D0B7457FF04F36239076B979A0330990FB635E24BD1775A7FEF6765'
   USING 'qro';

DROP DATABASE LINK "MC.SLP.ITESM.MX";
CREATE DATABASE LINK "MC.SLP.ITESM.MX"
   CONNECT TO "A1271656" IDENTIFIED BY VALUES '06FC54EF9DF6A2B0703D0449BB4E0884ED67C0E00CA160542F55737D0A1AC282F5B5D662F7E839FF6D1ED5D3941D71D7666618275097703E616E14D96EA05D77BD2B602CEB3388923AF66004475015958774513508F24D44193821DC2EAA26D0E2D56654259AA582601D19D59528FC085ABBB67412872321EE0C4FDD638217C3'
   USING 'slp';
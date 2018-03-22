create view catalogo_libros as
	select libros.id_libro, libros.id_genero, generos.nombre as nombre_genero, libros.id_autor, autores.nombre as nombre_autor,
		libros.id_editorial, editoriales.nombre as nombre_editorial, libros.titulo
	from proyecto_libros@mc libros, proyecto_autores@mc autores, proyecto_generos@mc generos, proyecto_editoriales@mc editoriales
	where libros.id_genero = generos.id_genero and libros.id_autor = autores.id_autor and libros.id_editorial = editoriales.id_editorial;

create view catalogo_proveedor as
	select id_proveedor, rfc_proveedor, nombre
	from proyecto_proveedores@mc;


# Dimensión libros

CREATE TABLE "DWH_SQLMASMAS"."D_LIBROS" 
 (	"ID_LIBRO" NUMBER NOT NULL ENABLE, 
"ID_GENERO" NUMBER NOT NULL ENABLE, 
"NOMBRE_GENERO" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
"ID_AUTOR" NUMBER NOT NULL ENABLE, 
"NOMBRE_AUTOR" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
"ID_EDITORIAL" NUMBER NOT NULL ENABLE, 
"NOMBRE_EDITORIAL" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
"TITULO" VARCHAR2(250 BYTE) NOT NULL ENABLE, 
 CONSTRAINT "D_LIBROS_PK" PRIMARY KEY ("ID_LIBRO")
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
TABLESPACE "USERS"  ENABLE
 ) SEGMENT CREATION DEFERRED 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
TABLESPACE "USERS" ;

# Dimensión proveedor

CREATE TABLE "DWH_SQLMASMAS"."D_PROVEEDOR" 
 (	"ID_PROVEEDOR" NUMBER NOT NULL ENABLE, 
"RFC_PROVEEDOR" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
"NOMBRE" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
 CONSTRAINT "D_PROVEEDOR_PK" PRIMARY KEY ("ID_PROVEEDOR")
USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
TABLESPACE "USERS"  ENABLE
 ) SEGMENT CREATION DEFERRED 
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
NOCOMPRESS LOGGING
TABLESPACE "USERS" ;

# Actualiza dimensión de libros

create or replace procedure actualiza_libros
as begin 
  insert into d_libros 
    select * from catalogo_libros where id_libro not in (select id_libro from d_libros);
        
  commit;
end actualiza_libros;

# Actualiza dimensión de proveedores

create or replace procedure actualiza_proveedores
as begin
	insert into d_proveedor
		select * from catalogo_proveedor where id_proveedor not in (select id_proveedor from d_proveedor);

	commit;
end actualiza_proveedores;
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

# Hechos métodos pago

create sequence seq_h_metodospago;

create or replace view metodos_pago as
	select mp.id_metodo_pago, compra.d_comprapk, tiempo.id_tiempo, sum(compra.total)  "SUMA"
	from d_tiempo tiempo, d_metodos_pago mp, d_compra compra
	where to_date(compra.fecha) = to_date(tiempo.fecha) and mp.id_metodo_pago = compra.id_metodo_pago
	group by (mp.id_metodo_pago, compra.d_comprapk, tiempo.id_tiempo);

# Tabla de hechos métodos pago

CREATE TABLE H_METODOS_PAGO 
(
  ID_METODO_HECHOS NUMBER NOT NULL 
, ID_METODO_PAGO NUMBER NOT NULL 
, ID_COMPRAPK NUMBER NOT NULL 
, ID_TIEMPO NUMBER NOT NULL 
, SUMA NUMBER NOT NULL 
, CONSTRAINT H_METODOS_PAGO_PK PRIMARY KEY 
  (
    ID_METODO_HECHOS 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX H_METODOS_PAGO_PK ON H_METODOS_PAGO (ID_METODO_HECHOS ASC) 
      LOGGING 
      TABLESPACE USERS 
      PCTFREE 10 
      INITRANS 2 
      STORAGE 
      ( 
        BUFFER_POOL DEFAULT 
      ) 
      NOPARALLEL 
  )
  ENABLE 
) 
LOGGING 
TABLESPACE USERS 
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  BUFFER_POOL DEFAULT 
) 
NOCOMPRESS 
NOPARALLEL;

ALTER TABLE H_METODOS_PAGO
ADD CONSTRAINT H_METODOS_PAGO_FK1 FOREIGN KEY
(
  ID_COMPRAPK 
)
REFERENCES D_COMPRA
(
  D_COMPRAPK 
)
ENABLE;

ALTER TABLE H_METODOS_PAGO
ADD CONSTRAINT H_METODOS_PAGO_FK2 FOREIGN KEY
(
  ID_TIEMPO 
)
REFERENCES D_TIEMPO
(
  ID_TIEMPO 
)
ENABLE;

ALTER TABLE H_METODOS_PAGO
ADD CONSTRAINT H_METODOS_PAGO_FK3 FOREIGN KEY
(
  ID_METODO_PAGO 
)
REFERENCES D_METODOS_PAGO
(
  ID_METODO_PAGO 
)
ENABLE;

# procedimiento para actualizar tabla de hechos de metodos_pago

    
create or replace procedure actualiza_metodos_pago_hechos(
	fecha_inicial in date,
	fecha_final in date
) as 
vFechaInicial date;
vFechaFinal date;


v_id_metodo_hechos number;
cursor c_metodos_pago is
	select mp.ID_METODO_HECHOS from h_metodos_pago mp, d_tiempo
	where mp.id_tiempo = d_tiempo.id_tiempo and d_tiempo.fecha between fecha_inicial and fecha_final; 

cursor c_metodospago is
	select mp.id_metodo_pago, mp.d_comprapk, mp.id_tiempo, mp.suma from metodos_pago mp, d_tiempo
	where mp.id_tiempo = d_tiempo.id_tiempo and d_tiempo.fecha between fecha_inicial and fecha_final;

v_metodo_pagos c_metodospago%rowtype;

begin

	vFechaInicial := fecha_inicial;
  vFechaFinal := fecha_final;

	-- Borrar primero los elementos que estén en ese rango de fechas
	open c_metodos_pago;
	fetch c_metodos_pago into v_id_metodo_hechos;
	while c_metodos_pago%FOUND loop
		delete from h_metodos_pago where id_metodo_hechos = v_id_metodo_hechos;
		fetch c_metodos_pago into v_id_metodo_hechos;
	end loop;
	close c_metodos_pago;

	-- Actualizar los nuevos valores
	open c_metodospago;
	fetch c_metodospago into v_metodo_pagos;
	while c_metodospago%FOUND loop
		insert into h_metodos_pago values(seq_h_metodospago.nextval, v_metodo_pagos.id_metodo_pago, v_metodo_pagos.d_comprapk, v_metodo_pagos.id_tiempo, v_metodo_pagos.suma);
		fetch c_metodospago into v_metodo_pagos;
	end loop;
	close c_metodospago;

	commit;
end actualiza_metodos_pago_hechos;

# Pregunta 14
# ¿Qué mes hay más pagos con efectivo?

select * from
 (select t.mes, t.anio, count(mp.id_metodo_hechos) as "PAGOS_CON_EFECTIVO"
 from h_metodos_pago mp, d_tiempo t
 where mp.id_metodo_pago = 1 and mp.id_tiempo = t.id_tiempo
 group by(t.mes, t.anio)
 order by pagos_con_efectivo desc)
where rownum = 1;
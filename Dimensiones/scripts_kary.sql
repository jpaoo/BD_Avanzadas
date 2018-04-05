-- Dimensión sucursal

create view catalogo_sucursal as select * from proyecto_sucursales@kr;


  CREATE TABLE "DWH_SQLMASMAS"."D_SUCURSAL" 
   (	"ID_SUCURSAL" NUMBER NOT NULL ENABLE, 
	"DIRECCION" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
	"NOMBRE" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	 CONSTRAINT "D_SUCURSAL_PK" PRIMARY KEY ("ID_SUCURSAL")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" ;

 
create or replace
PROCEDURE ACTUALIZA_SUCURSAL AS
BEGIN
 insert into d_sucursal
 select *
 from catalogo_sucursal
 where id_sucursal not in (select id_sucursal from d_sucursal);

 commit;
END ACTUALIZA_SUCURSAL;

execute ACTUALIZA_SUCURSAL();

-- Dimensión compra

create sequence seq_d_comprapk;

create or replace view catalogo_compra as 
	select sucursal.id_sucursal, pck.sucursal, pck.id_metodo_pago, count(pck.id_compra) as "TOTAL", pck.fecha
	from proyecto_compras_global@kr pck, proyecto_sucursales@kr sucursal
	where sucursal.nombre = pck.sucursal
    group by(pck.sucursal, sucursal.id_sucursal, pck.id_metodo_pago, fecha);


  CREATE TABLE "DWH_SQLMASMAS"."D_COMPRA" 
   (	"D_COMPRAPK" NUMBER NOT NULL ENABLE, 
	"ID_SUCURSAL" NUMBER NOT NULL ENABLE, 
	"NOMBRE_SUCURSAL" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"ID_METODO_PAGO" NUMBER NOT NULL ENABLE, 
	"TOTAL" NUMBER NOT NULL ENABLE, 
	"FECHA" DATE NOT NULL ENABLE, 
	 CONSTRAINT "D_COMPRA_PK" PRIMARY KEY ("D_COMPRAPK")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" ;


create or replace
PROCEDURE ACTUALIZA_COMPRA AS
v_id_sucursal number;
v_sucursal varchar2(20);
v_id_metodo number;
v_total number;
v_fecha date;
CURSOR c_compra IS 
 select cc.id_sucursal, cc.sucursal, cc.id_metodo_pago, cc.total, cc.fecha
 from catalogo_compra cc where cc.id_sucursal+'+'+cc.id_metodo_pago+'+'+cc.fecha not in (select id_sucursal+'+'+id_metodo_pago+'+'+fecha from d_compra);
BEGIN
 open c_compra;
 fetch c_compra INTO v_id_sucursal, v_sucursal, v_id_metodo, v_total, v_fecha; 
 	WHILE c_compra%FOUND LOOP
		insert into d_compra
 		values (seq_d_comprapk.nextval, v_id_sucursal, v_sucursal, v_id_metodo, v_total, v_fecha);
 		commit;
 	fetch c_compra INTO v_id_sucursal, v_sucursal, v_id_metodo, v_total, v_fecha; 
	END LOOP;
 close c_compra;
END ACTUALIZA_COMPRA;

execute ACTUALIZA_COMPRA();


-- Hechos órdenes de compra

create sequence seq_h_ordenescompra;

create or replace view ordenes_compra as 
	select l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo, sum(pl.cantidad) as "SUMA"
	from d_libros l, d_proveedor p, d_sucursal s, d_tiempo t, proyecto_ordenescompra@kr po, proyecto_ordeneslibro@kr pl
    where to_date(po.fecha) = to_date(t.fecha)
    and pl.id_libro = l.id_libro
    and p.id_proveedor = po.id_proveedor
    and s.id_sucursal = (select id_sucursal from d_sucursal where nombre = 'KR')
    group by (l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo)

    union 

    select l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo, sum(pl.cantidad) as "SUMA"
	from d_libros l, d_proveedor p, d_sucursal s, d_tiempo t, proyecto_ordenescompra@mc po, proyecto_ordeneslibro@mc pl
    where to_date(po.fecha) = to_date(t.fecha)
    and pl.id_libro = l.id_libro
    and p.id_proveedor = po.id_proveedor
    and s.id_sucursal = (select id_sucursal from d_sucursal where nombre = 'MC')
    group by (l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo)

    union 

    select l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo, sum(pl.cantidad) as "SUMA"
	from d_libros l, d_proveedor p, d_sucursal s, d_tiempo t, proyecto_ordenescompra@mm po, proyecto_ordeneslibro@mm pl
    where to_date(po.fecha) = to_date(t.fecha)
    and pl.id_libro = l.id_libro
    and p.id_proveedor = po.id_proveedor
    and s.id_sucursal = (select id_sucursal from d_sucursal where nombre = 'MM')
    group by (l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo)

    union 

    select l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo, sum(pl.cantidad) as "SUMA"
	from d_libros l, d_proveedor p, d_sucursal s, d_tiempo t, proyecto_ordenescompra@jp po, proyecto_ordeneslibro@jp pl
    where to_date(po.fecha) = to_date(t.fecha)
    and pl.id_libro = l.id_libro
    and p.id_proveedor = po.id_proveedor
    and s.id_sucursal = (select id_sucursal from d_sucursal where nombre = 'JP')
    group by (l.id_libro, p.id_proveedor, s.id_sucursal, t.id_tiempo);	

	


CREATE TABLE "DWH_SQLMASMAS"."H_ORDENES_COMPRA" 
   (	"ID_ORDEN_COMPRA" NUMBER NOT NULL ENABLE, 
	"ID_LIBRO" NUMBER NOT NULL ENABLE, 
	"ID_PROVEEDOR" NUMBER NOT NULL ENABLE, 
	"ID_SUCURSAL" NUMBER NOT NULL ENABLE, 
	"ID_TIEMPO" NUMBER NOT NULL ENABLE, 
	"SUMA" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "H_ORDENESCOMPRA_PK" PRIMARY KEY ("ID_ORDEN_COMPRA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "H_ORDENES_COMPRA_FK1" FOREIGN KEY ("ID_LIBRO")
	  REFERENCES "DWH_SQLMASMAS"."D_LIBROS" ("ID_LIBRO") ENABLE, 
	 CONSTRAINT "H_ORDENES_COMPRA_FK2" FOREIGN KEY ("ID_PROVEEDOR")
	  REFERENCES "DWH_SQLMASMAS"."D_PROVEEDOR" ("ID_PROVEEDOR") ENABLE, 
	 CONSTRAINT "H_ORDENES_COMPRA_FK3" FOREIGN KEY ("ID_SUCURSAL")
	  REFERENCES "DWH_SQLMASMAS"."D_SUCURSAL" ("ID_SUCURSAL") ENABLE, 
	 CONSTRAINT "H_ORDENES_COMPRA_FK4" FOREIGN KEY ("ID_TIEMPO")
	  REFERENCES "DWH_SQLMASMAS"."D_TIEMPO" ("ID_TIEMPO") ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" ;


create or replace 
PROCEDURE ACTUALIZA_ORDENES_COMPRA
(
  FECHAINICIAL IN DATE
, FECHAFINAL IN DATE
) AS
  vFechaInicial date;
  vFechaFinal date;
  vLibro number;
  vProv number;
  vSucur number;
  vTiempo number;
  vSuma number;
  
  /* Variable para la eliminación de registros*/
  vIdCompra number;

  cursor c_tiempo is
  SELECT id_orden_compra
  FROM h_ordenes_compra ho, d_tiempo dt 
  WHERE 
  ho.id_tiempo = dt.id_tiempo
  AND dt.fecha BETWEEN vFechaInicial AND vFechaFinal;

  cursor c_orden is
  SELECT oc.id_libro, oc.id_proveedor, oc.id_sucursal, oc.id_tiempo, oc.suma
  FROM ordenes_compra oc, d_tiempo t
  WHERE 
  oc.id_tiempo = t.id_tiempo
  AND t.fecha BETWEEN vFechaInicial AND vFechaFinal;  

BEGIN
 vFechaInicial := FECHAINICIAL;
 vFechaFinal := FECHAFINAL;

 open c_tiempo;
 FETCH c_tiempo INTO vIdCompra;
 WHILE c_tiempo%FOUND LOOP
    /* Ejecucion del borrado de registros*/
    DELETE FROM h_ordenes_compra WHERE id_orden_compra = vIdCompra;
    commit;
    FETCH c_tiempo INTO vIdCompra;
 END LOOP;
 close c_tiempo;

 open c_orden;
 FETCH c_orden INTO vLibro, vProv, vSucur, vTiempo, vSuma;
 WHILE c_orden%FOUND LOOP
    /*Operación de inserción de registros*/
    INSERT INTO h_ordenes_compra VALUES (seq_h_ordenescompra.nextval, vLibro, vProv, vSucur, vTiempo, vSuma);
    commit;
    FETCH c_orden INTO vLibro, vProv, vSucur, vTiempo, vSuma;
 END LOOP;
 close c_orden;
 
END ACTUALIZA_ORDENES_COMPRA;

execute ACTUALIZA_ORDENES_COMPRA(to_date('01/01/2017','DD/MM/YYYY'),to_date('05/04/2018','DD/MM/YYYY'));


-- Query para saber a qué proveedor se le han hecho más órdenes de compra en el año

select *
from (
	select p.nombre, sum(ho.suma) as "TOTAL_ORDENES"
	from h_ordenes_compra ho, d_proveedor p, d_tiempo t
	where ho.id_proveedor = p.id_proveedor
	and ho.id_tiempo = t.id_tiempo
	group by p.nombre
	order by total_ordenes desc)
where rownum = 1;
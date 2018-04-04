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


	 
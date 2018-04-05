CREATE OR REPLACE PROCEDURE PDIMTIEMPO
AS
  FIRST_DATE DATE;
  LAST_DATE DATE;
BEGIN
  FIRST_DATE := TO_DATE('01-01-2017', 'DD-MM-YYYY');
  LAST_DATE := SYSDATE;
  WHILE FIRST_DATE <= LAST_DATE LOOP
    INSERT INTO D_TIEMPO VALUES(SEQ_DTIEMPO.NEXTVAL, FIRST_DATE, to_number(to_char(FIRST_DATE, 'YYYY')), to_number(to_char(FIRST_DATE, 'MM')) , to_number(round(to_number(to_char(FIRST_DATE, 'WW')) / 2)) , to_char(FIRST_DATE, 'FMDAY'));
    FIRST_DATE := FIRST_DATE + 1;
  END LOOP;
COMMIT;
END PDIMTIEMPO;

EXECUTE PDIMTIEMPO;

CREATE VIEW CATALOGO_METODOS_PAGO AS
SELECT ID_METODO_PAGO, NOMBRE
FROM PROYECTO_METODOS_PAGO@MM


CREATE OR REPLACE PROCEDURE ACTUALIZAMETODOSPAGO
AS
BEGIN
INSERT INTO D_METODOS_PAGO
SELECT * FROM CATALOGO_METODOS_PAGO WHERE ID_METODO_PAGO NOT IN (
  SELECT ID_METODO_PAGO FROM D_METODOS_PAGO
);
COMMIT;
END ACTUALIZAMETODOSPAGO;
EXECUTE ACTUALIZAMETODOSPAGO;


CREATE OR REPLACE VIEW CATALOGO_INVENTARIO_SUCURSAL AS
select pls.id_libro, pl.titulo, suc.id_sucursal, pls.cantidad from proyecto_librossucursal@mm pls, proyecto_libros@mm pl, proyecto_sucursales@mm suc where pls.id_libro = pl.id_libro and 'MM' = suc.nombre
union
select pls.id_libro, pl.titulo, suc.id_sucursal, pls.cantidad from proyecto_librossucursal@kr pls, proyecto_libros@mm pl, proyecto_sucursales@mm suc where pls.id_libro = pl.id_libro and 'KR' = suc.nombre
union
select pls.id_libro, pl.titulo, suc.id_sucursal, pls.cantidad from proyecto_librossucursal@jp pls, proyecto_libros@mm pl, proyecto_sucursales@mm suc where pls.id_libro = pl.id_libro and 'JP' = suc.nombre
union
select pls.id_libro, pl.titulo, suc.id_sucursal, pls.cantidad from proyecto_librossucursal@mc pls, proyecto_libros@mm pl, proyecto_sucursales@mm suc where pls.id_libro = pl.id_libro and 'MC' = suc.nombre
order by titulo;


CREATE OR REPLACE PROCEDURE ACTUALIZA_INVENTARIO
AS
BEGIN
INSERT INTO D_INVENTARIO
SELECT ID_LIBRO, ID_SUCURSAL,CANTIDAD, SYSDATE FROM CATALOGO_INVENTARIO_SUCURSAL
--chacalada para asegurar, concatenar ambos con un símbolo cualquiera
WHERE ID_LIBRO + '*' + ID_SUCURSAL NOT IN (
  SELECT ID_LIBRO+ '*'+ID_SUCURSAL FROM D_INVENTARIO
);
COMMIT;
END ACTUALIZA_INVENTARIO;
EXECUTE ACTUALIZA_INVENTARIO;



CREATE OR REPLACE VIEW STOCK AS
SELECT L.ID_LIBRO AS LIBRO, T.ID_TIEMPO AS TIEMPO, T.FECHA AS FECHA, SUM(I.CANTIDAD) AS CANTIDAD
FROM D_TIEMPO T, D_INVENTARIO I, D_LIBROS L
WHERE I.FECHA = T.FECHA AND L.ID_LIBRO =  I.ID_LIBRO
GROUP BY (L.ID_LIBRO, T.ID_TIEMPO, T.FECHA)



CREATE OR REPLACE PROCEDURE ACTUALIZA_STOCK(
  FECHAINICIAL IN DATE,
  FECHAFINAL IN DATE
)
AS
  vFechaInicial date;
  vFechaFinal date;
  V_HSTOCKPK number;

  CURSOR C_TIEMPO IS
  SELECT ID_STOCK FROM H_STOCK H, D_TIEMPO T WHERE H.ID_TIEMPO = T.ID_TIEMPO AND T.FECHA BETWEEN FECHAINICIAL AND FECHAFINAL;

  CURSOR C_STOCK IS
  SELECT LIBRO, TIEMPO, CANTIDAD FROM STOCK WHERE FECHA BETWEEN FECHAINICIAL AND FECHAFINAL;

  V_HSTOCKREG C_STOCK%ROWTYPE;

BEGIN
  vFechaInicial := FECHAINICIAL;
  vFechaFinal := FECHAFINAL;

  OPEN C_TIEMPO;
  FETCH C_TIEMPO INTO V_HSTOCKPK;

  WHILE C_TIEMPO%FOUND LOOP
    DELETE FROM H_STOCK WHERE ID_STOCK = V_HSTOCKPK;
    FETCH C_TIEMPO INTO V_HSTOCKPK;
  END LOOP;
  CLOSE C_TIEMPO;

  OPEN C_STOCK;

  FETCH C_STOCK INTO V_HSTOCKREG;
  WHILE C_STOCK%FOUND LOOP
    INSERT INTO H_STOCK VALUES(SEQ_H_STOCK.NEXTVAL, V_HSTOCKREG.LIBRO, V_HSTOCKREG.TIEMPO, V_HSTOCKREG.CANTIDAD);
    FETCH C_STOCK INTO V_HSTOCKREG;
  END LOOP;
CLOSE C_STOCK;
COMMIT;
END ACTUALIZA_STOCK;
EXECUTE ACTUALIZA_STOCK;


H.ID_LIBRO, H.ID_TIEMPO FROM H_STOCK H, D_TIEMPO T WHERE T.ID_TIEMPO = H.ID_TIEMPO
AND T.ID_TIEMPO IN (
  SELECT ID_TIEMPO FROM D_TIEMPO WHERE MES=2 and anio = 2017
)

--query libro con el stock máximo en un mes y año

select titulo, nombre_genero, nombre_autor from d_libros where id_libro=(select id_libro from h_stock where id_tiempo in (select id_tiempo from h_stock where id_tiempo in (
  select id_tiempo from d_tiempo where mes=3 and anio = 2018
) ) and cantidad_total = (select max(cantidad_total) from h_stock where id_tiempo in (
select id_tiempo from d_tiempo where mes=3 and anio = 2018
)))

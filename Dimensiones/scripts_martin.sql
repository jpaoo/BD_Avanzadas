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
SELECT ID_LIBRO, ID_SUCURSAL,CANTIDAD FROM CATALOGO_INVENTARIO_SUCURSAL
--chacalada para asegurar, concatenar ambos con un símbolo cualquiera
WHERE ID_LIBRO + '*' + ID_SUCURSAL NOT IN (
  SELECT ID_LIBRO+ '*'+ID_SUCURSAL FROM D_INVENTARIO
);
COMMIT;
END ACTUALIZA_INVENTARIO;
EXECUTE ACTUALIZA_INVENTARIO;

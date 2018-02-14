CREATE OR REPLACE VIEW PROYECTO_COMPRAS_GLOBAL AS
SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'MM' AS SUCURSAL FROM PROYECTO_COMPRAS
UNION (
  SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'JP' AS SUCURSAL FROM PROYECTO_COMPRAS@JP
) UNION (
  SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'KR' AS SUCURSAL FROM PROYECTO_COMPRAS@KR
) UNION (
  SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'MC' AS SUCURSAL FROM PROYECTO_COMPRAS@MC
) ORDER BY SUCURSAL


-- INVENTARIO_SUCURSALES

CREATE OR REPLACE VIEW PROYECTO_INVENTARIO_SUCURSALES AS
select pls.id_libro, pl.titulo, 'MC' as Sucursal, pls.cantidad from proyecto_librossucursal pls, proyecto_libros pl where pls.id_libro = pl.id_libro
union
select pls.id_libro, pl.titulo, 'KR' as Sucursal, pls.cantidad from proyecto_librossucursal@kr pls, proyecto_libros pl where pls.id_libro = pl.id_libro
union
select pls.id_libro, pl.titulo, 'JP' as Sucursal, pls.cantidad from proyecto_librossucursal@jp pls, proyecto_libros pl where pls.id_libro = pl.id_libro
union
select pls.id_libro, pl.titulo, 'MM' as Sucursal, pls.cantidad from proyecto_librossucursal@mm pls, proyecto_libros pl where pls.id_libro = pl.id_libro
order by titulo;

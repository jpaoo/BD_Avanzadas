CREATE OR REPLACE VIEW PROYECTO_COMPRAS_GLOBAL AS
SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'MC' AS SUCURSAL FROM PROYECTO_COMPRAS@mc
UNION (
  SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'JP' AS SUCURSAL FROM PROYECTO_COMPRAS
) UNION (
  SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'KR' AS SUCURSAL FROM PROYECTO_COMPRAS@KR
) UNION (
  SELECT ID_COMPRA, ID_METODO_PAGO, ID_CLIENTE, FECHA, MONTO, CANTIDAD, 'MM' AS SUCURSAL FROM PROYECTO_COMPRAS@mm
) ORDER BY SUCURSAL;


-- INVENTARIO_SUCURSALES

CREATE OR REPLACE VIEW PROYECTO_INVENTARIO_SUCURSALES AS
select pls.id_libro, pl.titulo, 'MC' as Sucursal, pls.cantidad from proyecto_librossucursal@mc pls, proyecto_libros pl where pls.id_libro = pl.id_libro
union
select pls.id_libro, pl.titulo, 'KR' as Sucursal, pls.cantidad from proyecto_librossucursal@kr pls, proyecto_libros pl where pls.id_libro = pl.id_libro
union
select pls.id_libro, pl.titulo, 'JP' as Sucursal, pls.cantidad from proyecto_librossucursal pls, proyecto_libros pl where pls.id_libro = pl.id_libro
union
select pls.id_libro, pl.titulo, 'MM' as Sucursal, pls.cantidad from proyecto_librossucursal@mm pls, proyecto_libros pl where pls.id_libro = pl.id_libro
order by titulo;

-- LIBROS VENDIDOS DEL MES PASADO
CREATE OR REPLACE VIEW PROYECTO_VENTAS_MES_ANTERIOR AS
SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
  SELECT CL.ID_LIBRO
  FROM PROYECTO_COMPRAS PC, PROYECTO_COMPRASLIBRO CL
  WHERE PC.FECHA >= ADD_MONTHS(SYSDATE,-1) AND PC.ID_COMPRA = CL.ID_COMPRA
) UNION (
  SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
    SELECT CLM.ID_LIBRO
    FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_COMPRASLIBRO@mm CLM
    WHERE PCM.FECHA >= ADD_MONTHS(SYSDATE,-1) AND PCM.ID_COMPRA = CLM.ID_COMPRA
  )
) UNION (
  SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
    SELECT CLK.ID_LIBRO
    FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_COMPRASLIBRO@KR CLK
    WHERE PCK.FECHA >= ADD_MONTHS(SYSDATE,-1) AND PCK.ID_COMPRA = CLK.ID_COMPRA
  )
) UNION (
  SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
    SELECT CLJ.ID_LIBRO
    FROM PROYECTO_COMPRAS@mc PCJ, PROYECTO_COMPRASLIBRO@mc CLJ
    WHERE PCJ.FECHA >= ADD_MONTHS(SYSDATE,-1) AND PCJ.ID_COMPRA = CLJ.ID_COMPRA
  )
);

-- LIBROS VENDIDOS DEL AÑO PASADO
CREATE OR REPLACE VIEW PROYECTO_VENTAS_ANIO_ANTERIOR AS
SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
  SELECT CL.ID_LIBRO
  FROM PROYECTO_COMPRAS PC, PROYECTO_COMPRASLIBRO CL
  WHERE PC.FECHA >= ADD_MONTHS(SYSDATE,-12) AND PC.ID_COMPRA = CL.ID_COMPRA
) UNION (
  SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
    SELECT CLM.ID_LIBRO
    FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_COMPRASLIBRO@mm CLM
    WHERE PCM.FECHA >= ADD_MONTHS(SYSDATE,-12) AND PCM.ID_COMPRA = CLM.ID_COMPRA
  )
) UNION (
  SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
    SELECT CLK.ID_LIBRO
    FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_COMPRASLIBRO@KR CLK
    WHERE PCK.FECHA >= ADD_MONTHS(SYSDATE,-12) AND PCK.ID_COMPRA = CLK.ID_COMPRA
  )
) UNION (
  SELECT TITULO FROM PROYECTO_LIBROS WHERE ID_LIBRO IN (
    SELECT CLJ.ID_LIBRO
    FROM PROYECTO_COMPRAS@MC PCJ, PROYECTO_COMPRASLIBRO@MC CLJ
    WHERE PCJ.FECHA >= ADD_MONTHS(SYSDATE,-12) AND PCJ.ID_COMPRA = CLJ.ID_COMPRA
  )
);




-- TOTAL DE LIBROS VENDIDOS POR SUCURSAL
CREATE OR REPLACE VIEW PROYECTO_TOTAL_LIBROS_SUCURSAL AS
SELECT SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS, 'JP' AS SUCURSAL
FROM PROYECTO_COMPRAS PC, PROYECTO_COMPRASLIBRO CL
WHERE PC.ID_COMPRA = CL.ID_COMPRA
UNION (
  SELECT SUM(PCM.CANTIDAD) AS LIBROS_VENDIDOS, 'MM' AS SUCURSAL
  FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_COMPRASLIBRO@mm CLM
  WHERE PCM.ID_COMPRA = CLM.ID_COMPRA
)
UNION (
  SELECT SUM(PCK.CANTIDAD) AS LIBROS_VENDIDOS, 'KR' AS SUCURSAL
  FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_COMPRASLIBRO@KR CLK
  WHERE PCK.ID_COMPRA = CLK.ID_COMPRA
)
UNION (
  SELECT SUM(PCJ.CANTIDAD) AS LIBROS_VENDIDOS, 'MC' AS SUCURSAL
  FROM PROYECTO_COMPRAS@MC PCJ, PROYECTO_COMPRASLIBRO@MC CLJ
  WHERE PCJ.ID_COMPRA = CLJ.ID_COMPRA
);



-- VENTAS DE UN CIERTO TITULO
CREATE OR REPLACE VIEW PROYECTO_TOTAL_VENTAS_TITULO AS
SELECT TITULO, SUM(LIBROS_VENDIDOS) AS LIBROS_VENDIDOS FROM (
SELECT PL.TITULO, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
FROM PROYECTO_COMPRAS@MC PC, PROYECTO_COMPRASLIBRO@MC CL, PROYECTO_LIBROS@MC PL
WHERE PC.ID_COMPRA = CL.ID_COMPRA AND CL.ID_LIBRO = PL.ID_LIBRO
GROUP BY PL.TITULO
UNION(
  SELECT PLM.TITULO, SUM(PCM.CANTIDAD) AS LIBROS_VENDIDOS
  FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_COMPRASLIBRO@mm CLM, PROYECTO_LIBROS@mm PLM
  WHERE PCM.ID_COMPRA = CLM.ID_COMPRA AND CLM.ID_LIBRO = PLM.ID_LIBRO
  GROUP BY PLM.TITULO
) UNION (
  SELECT PLK.TITULO, SUM(PCK.CANTIDAD) AS LIBROS_VENDIDOS
  FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_COMPRASLIBRO@KR CLK, PROYECTO_LIBROS@KR PLK
  WHERE PCK.ID_COMPRA = CLK.ID_COMPRA AND CLK.ID_LIBRO = PLK.ID_LIBRO
  GROUP BY PLK.TITULO
) UNION (
  SELECT PLJ.TITULO, SUM(PCJ.CANTIDAD) AS LIBROS_VENDIDOS
  FROM PROYECTO_COMPRAS PCJ, PROYECTO_COMPRASLIBRO CLJ, PROYECTO_LIBROS PLJ
  WHERE PCJ.ID_COMPRA = CLJ.ID_COMPRA AND CLJ.ID_LIBRO = PLJ.ID_LIBRO
  GROUP BY PLJ.TITULO
)) GROUP BY TITULO;

-- TOTAL DE LIBROS COMPRADOS POR CLIENTE
CREATE OR REPLACE VIEW PROYECTO_NR_COMPRAS_CLIENTE AS
SELECT SUM(LIBROS_COMPRADOS) AS TOTAL, CLIENTE FROM (
SELECT SUM(PC.CANTIDAD) AS LIBROS_COMPRADOS, CL.NOMBRE AS CLIENTE
FROM PROYECTO_COMPRAS PC, PROYECTO_CLIENTES CL
WHERE PC.ID_CLIENTE = CL.ID_CLIENTE
GROUP BY CL.NOMBRE
UNION (
  SELECT SUM(PCM.CANTIDAD) AS LIBROS_COMPRADOS, CLM.NOMBRE AS CLIENTE
  FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_CLIENTES@mm CLM
  WHERE PCM.ID_CLIENTE = CLM.ID_CLIENTE
  GROUP BY CLM.NOMBRE
)
UNION (
  SELECT SUM(PCK.CANTIDAD) AS LIBROS_COMPRADOS, CLK.NOMBRE AS CLIENTE
  FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_CLIENTES@KR CLK
  WHERE PCK.ID_CLIENTE = CLK.ID_CLIENTE
  GROUP BY CLK.NOMBRE
)
UNION (
  SELECT SUM(PMM.CANTIDAD) AS LIBROS_COMPRADOS, PCMM.NOMBRE AS CLIENTE
  FROM PROYECTO_COMPRAS@MC PMM, PROYECTO_CLIENTES@MC PCMM
  WHERE PMM.ID_CLIENTE = PCMM.ID_CLIENTE
  GROUP BY PCMM.NOMBRE
)) GROUP BY CLIENTE;

-- VENTAS POR CADA GENERO
CREATE OR REPLACE VIEW PROYECTO_TOTAL_VENTAS_GENERO AS
SELECT NOMBRE, SUM(LIBROS_VENDIDOS) AS LIBROS_VENDIDOS
FROM (
SELECT PG.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
FROM PROYECTO_GENEROS PG, PROYECTO_LIBROS PL, PROYECTO_COMPRAS PC, PROYECTO_COMPRASLIBRO PCL
WHERE PG.ID_GENERO = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
GROUP BY PG.NOMBRE
UNION(
    SELECT PG.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
    FROM PROYECTO_GENEROS@KR PG, PROYECTO_LIBROS@KR PL, PROYECTO_COMPRAS@KR PC, PROYECTO_COMPRASLIBRO@KR PCL
    WHERE PG.ID_GENERO = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
    GROUP BY PG.NOMBRE
)
UNION(
    SELECT PG.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
    FROM PROYECTO_GENEROS@MC PG, PROYECTO_LIBROS@MC PL, PROYECTO_COMPRAS@MC PC, PROYECTO_COMPRASLIBRO@MC PCL
    WHERE PG.ID_GENERO = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
    GROUP BY PG.NOMBRE
)
UNION(
    SELECT PG.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
    FROM PROYECTO_GENEROS@mm PG, PROYECTO_LIBROS@mm PL, PROYECTO_COMPRAS@mm PC, PROYECTO_COMPRASLIBRO@mm PCL
    WHERE PG.ID_GENERO = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
    GROUP BY PG.NOMBRE
)
) GROUP BY NOMBRE;



-- TODAS LAS ORDENES DE COMPRA
CREATE OR REPLACE VIEW PROYECTO_ORD_COMPRA_GLOBAL AS
SELECT ID_ORDENCOMPRA, ID_PROVEEDOR, FECHA, 'MC' AS SUCURSAL FROM PROYECTO_ORDENESCOMPRA@MC
UNION (
  SELECT ID_ORDENCOMPRA, ID_PROVEEDOR, FECHA, 'JP' AS SUCURSAL FROM PROYECTO_ORDENESCOMPRA
) UNION (
  SELECT ID_ORDENCOMPRA, ID_PROVEEDOR, FECHA, 'KR' AS SUCURSAL FROM PROYECTO_ORDENESCOMPRA@KR
) UNION (
  SELECT ID_ORDENCOMPRA, ID_PROVEEDOR, FECHA, 'MM' AS SUCURSAL FROM PROYECTO_ORDENESCOMPRA@mm
) ORDER BY SUCURSAL;




--- Compras por cliente del mes pasado
CREATE OR REPLACE VIEW PROYECTO_NR_COMP_CLI_MES AS
SELECT SUM(LIBROS_COMPRADOS) AS TOTAL, CLIENTE FROM (
SELECT SUM(PC.CANTIDAD) AS LIBROS_COMPRADOS, CL.NOMBRE AS CLIENTE
FROM PROYECTO_COMPRAS PC, PROYECTO_CLIENTES CL
WHERE PC.ID_CLIENTE = CL.ID_CLIENTE
GROUP BY CL.NOMBRE
UNION (
  SELECT SUM(PCM.CANTIDAD) AS LIBROS_COMPRADOS, CLM.NOMBRE AS CLIENTE
  FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_CLIENTES@mm CLM
  WHERE PCM.ID_CLIENTE = CLM.ID_CLIENTE AND PCM.FECHA >= ADD_MONTHS(SYSDATE,-1)
  GROUP BY CLM.NOMBRE
)
UNION (
  SELECT SUM(PCK.CANTIDAD) AS LIBROS_COMPRADOS, CLK.NOMBRE AS CLIENTE
  FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_CLIENTES@KR CLK
  WHERE PCK.ID_CLIENTE = CLK.ID_CLIENTE AND PCK.FECHA >= ADD_MONTHS(SYSDATE,-1)
  GROUP BY CLK.NOMBRE
)
UNION (
  SELECT SUM(PMM.CANTIDAD) AS LIBROS_COMPRADOS, PCMM.NOMBRE AS CLIENTE
  FROM PROYECTO_COMPRAS@MC PMM, PROYECTO_CLIENTES@MC PCMM
  WHERE PMM.ID_CLIENTE = PCMM.ID_CLIENTE AND PMM.FECHA >= ADD_MONTHS(SYSDATE,-1)
  GROUP BY PCMM.NOMBRE
)) GROUP BY CLIENTE;



--- METODOS DE PAGO USADOS POR SUCURSAL
CREATE OR REPLACE VIEW PROYECTO_TIPO_PAGO_SUCURSAL AS
SELECT  *  FROM ( SELECT SUM(PCJ.ID_METODO_PAGO) AS CANTIDAD_PAGOS, CLJ.NOMBRE AS METODO_PAGO, 'JP' AS SUCURSAL
  FROM PROYECTO_COMPRAS PCJ, PROYECTO_METODOS_PAGO CLJ
  WHERE PCJ.ID_METODO_PAGO = CLJ.ID_METODO_PAGO
  GROUP BY CLJ.NOMBRE ORDER BY CANTIDAD_PAGOS DESC ) WHERE ROWNUM <2
UNION (
  SELECT  *  FROM ( SELECT SUM(PCM.ID_METODO_PAGO) AS CANTIDAD_PAGOS, CLM.NOMBRE AS METODO_PAGO, 'MM' AS SUCURSAL
  FROM PROYECTO_COMPRAS@mm PCM, PROYECTO_METODOS_PAGO@mm CLM
  WHERE PCM.ID_METODO_PAGO = CLM.ID_METODO_PAGO
  GROUP BY CLM.NOMBRE ORDER BY CANTIDAD_PAGOS DESC ) WHERE ROWNUM <2
)
UNION (
  SELECT  *  FROM ( SELECT SUM(PCK.ID_METODO_PAGO) AS CANTIDAD_PAGOS, CLK.NOMBRE AS METODO_PAGO, 'KR' AS SUCURSAL
  FROM PROYECTO_COMPRAS@KR PCK, PROYECTO_METODOS_PAGO@KR CLK
  WHERE PCK.ID_METODO_PAGO = CLK.ID_METODO_PAGO
  GROUP BY CLK.NOMBRE ORDER BY CANTIDAD_PAGOS DESC ) WHERE ROWNUM <2
)
UNION (
  SELECT  *  FROM ( SELECT SUM(PC.ID_METODO_PAGO) AS CANTIDAD_PAGOS, MP.NOMBRE AS METODO_PAGO, 'MC' AS SUCURSAL
  FROM PROYECTO_COMPRAS@MC PC, PROYECTO_METODOS_PAGO@MC MP
  WHERE PC.ID_METODO_PAGO = MP.ID_METODO_PAGO
  GROUP BY MP.NOMBRE ORDER BY CANTIDAD_PAGOS DESC ) WHERE ROWNUM <2
);


-- VENTAS POR CADA EDITORIAL
CREATE OR REPLACE VIEW PROYECTO_VENTAS_EDITORIAL AS
SELECT NOMBRE, SUM(LIBROS_VENDIDOS) AS LIBROS_VENDIDOS
FROM (
SELECT PE.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
FROM PROYECTO_EDITORIALES PE, PROYECTO_LIBROS PL, PROYECTO_COMPRAS PC, PROYECTO_COMPRASLIBRO PCL
WHERE PE.ID_EDITORIAL = PL.ID_EDITORIAL AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
GROUP BY PE.NOMBRE
UNION(
    SELECT PE.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
    FROM PROYECTO_EDITORIALES@KR PE, PROYECTO_LIBROS@KR PL, PROYECTO_COMPRAS@KR PC, PROYECTO_COMPRASLIBRO@KR PCL
    WHERE PE.ID_EDITORIAL = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
    GROUP BY PE.NOMBRE
)
UNION(
    SELECT PE.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
    FROM PROYECTO_EDITORIALES@MC PE, PROYECTO_LIBROS@MC PL, PROYECTO_COMPRAS@MC PC, PROYECTO_COMPRASLIBRO@MC PCL
    WHERE PE.ID_EDITORIAL = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
    GROUP BY PE.NOMBRE
)
UNION(
    SELECT PE.NOMBRE, SUM(PC.CANTIDAD) AS LIBROS_VENDIDOS
    FROM PROYECTO_EDITORIALES@mm PE, PROYECTO_LIBROS@mm PL, PROYECTO_COMPRAS@mm PC, PROYECTO_COMPRASLIBRO@mm PCL
    WHERE PE.ID_EDITORIAL = PL.ID_GENERO AND PC.ID_COMPRA = PCL.ID_COMPRA AND PCL.ID_LIBRO = PL.ID_LIBRO
    GROUP BY PE.NOMBRE
)
) GROUP BY NOMBRE;

COMMIT;

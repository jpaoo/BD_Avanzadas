
-- NUEVO_LIBRO

create or replace procedure PROYECTO_NUEVO_LIBRO(
    ID_LIBRO NUMBER,
    ISBN	VARCHAR2,
    ID_AUTOR	NUMBER,
    ID_GENERO	NUMBER,
    ID_EDITORIAL	NUMBER,
    TITULO	VARCHAR2,
    PAGINAS	NUMBER,
    PRECIO	NUMBER,
    ANIO	NUMBER) as

begin
    begin
        insert into proyecto_libros values (id_libro, isbn, id_autor, id_genero, id_editorial, titulo, paginas, precio, anio);
        insert into proyecto_libros@mm values (id_libro, isbn, id_autor, id_genero, id_editorial, titulo, paginas, precio, anio);
        insert into proyecto_libros@kr values (id_libro, isbn, id_autor, id_genero, id_editorial, titulo, paginas, precio, anio);
        insert into proyecto_libros@jp values (id_libro, isbn, id_autor, id_genero, id_editorial, titulo, paginas, precio, anio);
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20000, SUBSTR(SQLERRM, 1, 100));
    end;
end;

-- NUEVO GÉNERO

create or replace procedure PROYECTO_NUEVO_GENERO(
    ID_GENERO	NUMBER,
    NOMBRE	VARCHAR2) as
begin
    begin
        insert into proyecto_generos values (id_genero, nombre);
        insert into proyecto_generos@mm values (id_genero, nombre);
        insert into proyecto_generos@kr values (id_genero, nombre);
        insert into proyecto_generos@jp values (id_genero, nombre);
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20000, SUBSTR(SQLERRM, 1, 100));
    end;
end;

-- NUEVO PROVEEDOR

create or replace procedure PROYECTO_NUEVO_PROVEEDOR(
    ID_PROVEEDOR	NUMBER,
    RFC_PROVEEDOR	VARCHAR2,
    NOMBRE	VARCHAR2,
    EMAIL	VARCHAR2,
    DIRECCION	VARCHAR2,
    TELEFONO	VARCHAR2,
    CANTIDADMAX	NUMBER) as
begin
    begin
        insert into proyecto_proveedores values (id_proveedor, rfc_proveedor, nombre, email, direccion, telefono, cantidadmax);
        insert into proyecto_proveedores@mm values (id_proveedor, rfc_proveedor, nombre, email, direccion, telefono, cantidadmax);
        insert into proyecto_proveedores@kr values (id_proveedor, rfc_proveedor, nombre, email, direccion, telefono, cantidadmax);
        insert into proyecto_proveedores@jp values (id_proveedor, rfc_proveedor, nombre, email, direccion, telefono, cantidadmax);
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20000, SUBSTR(SQLERRM, 1, 100));
    end;
end;

-- NUEVA EDITORIAL

create or replace procedure PROYECTO_NUEVA_EDITORIAL(
    ID_EDITORIAL	NUMBER,
    NOMBRE	VARCHAR2,
    PAIS	VARCHAR2) as
begin
    begin
        insert into proyecto_editoriales values (id_editorial, nombre, pais);
        insert into proyecto_editoriales@mm values (id_editorial, nombre, pais);
        insert into proyecto_editoriales@kr values (id_editorial, nombre, pais);
        insert into proyecto_editoriales@jp values (id_editorial, nombre, pais);
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20000, SUBSTR(SQLERRM, 1, 100));
    end;
end;

-- NUEVO AUTOR

create or replace procedure PROYECTO_NUEVO_AUTOR(
    ID_AUTOR	NUMBER,
    NOMBRE	VARCHAR2) as
begin
    begin
        insert into proyecto_autores values (id_autor, nombre);
        insert into proyecto_autores@jp values (id_autor, nombre);
        insert into proyecto_autores@kr values (id_autor, nombre);
        insert into proyecto_autores@mm values (id_autor, nombre);
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20000, SUBSTR(SQLERRM, 1, 100));
    end;
end;



--- UPDATE PRECIO LIBRO

create or replace procedure PROYECTO_UPDATE_PRECIO_LIBRO(
  NUEVO_NOMBRE VARCHAR2,
  NUEVO_PRECIO NUMBER) as
begin
  begin
    update proyecto_libros set precio = NUEVO_PRECIO where TITULO = NUEVO_NOMBRE;
    update proyecto_libros@kr set precio = NUEVO_PRECIO where TITULO = NUEVO_NOMBRE;
    update proyecto_libros@mm set precio = NUEVO_PRECIO where TITULO = NUEVO_NOMBRE;
    update proyecto_libros@mc set precio = NUEVO_PRECIO where TITULO = NUEVO_NOMBRE;
    commit;
  exception
    when others then
      rollback;
      raise_application_error(-2000, SUBSTR(SQLERRM, 1, 100));
    end;
  end;


  --- UPDATE COSTO LIBRO

create or replace procedure PROYECTO_UPDATE_COSTO_LIBRO(
    ID_LIBRO_CHANGE NUMBER,
    NUEVO_PRECIO NUMBER) as
  begin
    begin
      update PROYECTO_LIBROSPROVEEDOR set costo = NUEVO_PRECIO where ID_LIBRO = ID_LIBRO_CHANGE;
      update PROYECTO_LIBROSPROVEEDOR@kr set costo = NUEVO_PRECIO where ID_LIBRO = ID_LIBRO_CHANGE;
      update PROYECTO_LIBROSPROVEEDOR@mm set costo = NUEVO_PRECIO where ID_LIBRO = ID_LIBRO_CHANGE;
      update PROYECTO_LIBROSPROVEEDOR@mc set costo = NUEVO_PRECIO where ID_LIBRO = ID_LIBRO_CHANGE;
      commit;
    exception
      when others then
        rollback;
        raise_application_error(-2000, SUBSTR(SQLERRM, 1, 100));
      end;
    end;

---- UPDATE MAIL CLIENTE
create or replace procedure PROYECTO_UPDATE_MAIL_CLIENTE(
    RFC_CLIENTE_CAMBIAR VARCHAR,
    EMAIL_NUEVO VARCHAR) as
  begin
    begin
      update PROYECTO_CLIENTES set EMAIL = EMAIL_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      update PROYECTO_CLIENTES@kr set EMAIL = EMAIL_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      update PROYECTO_CLIENTES@mm set EMAIL = EMAIL_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      update PROYECTO_CLIENTES@mc set EMAIL = EMAIL_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      commit;
    exception
      when others then
        rollback;
        raise_application_error(-2000, SUBSTR(SQLERRM, 1, 100));
      end;
    end;


    ---- UPDATE TELEFONO CLIENTE
create or replace procedure PROYECTO_UPDATE_TLF_CLIENTE(
    RFC_CLIENTE_CAMBIAR VARCHAR,
    TLF_NUEVO VARCHAR) as
  begin
    begin
      update PROYECTO_CLIENTES set TELEFONO = TLF_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      update PROYECTO_CLIENTES@kr set TELEFONO = TLF_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      update PROYECTO_CLIENTES@mm set TELEFONO = TLF_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      update PROYECTO_CLIENTES@mc set TELEFONO = TLF_NUEVO where RFC_CLIENTE = RFC_CLIENTE_CAMBIAR;
      commit;
    exception
      when others then
        rollback;
        raise_application_error(-2000, SUBSTR(SQLERRM, 1, 100));
      end;
    end;

-- TRIGGER DESCUENTO DE 1000 COMPRAS

create or replace trigger PROYECTO_DESCUENTO_COMPRA1000
before 
    insert on PROYECTO_COMPRAS
for each row
declare 
    v_cant NUMBER;
begin
    select count(*) into v_cant from proyecto_compras;
    if ( mod((v_cant + 1),1000) = 0 ) then
        :new.monto := :new.monto * 0.9;
    end if;
end PROYECTO_DESCUENTO_COMPRA1000;




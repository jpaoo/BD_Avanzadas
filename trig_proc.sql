
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
/*Proyecto de lenguaje de bases de datos */

--------------------------------------
----Creaci�n de tablas
--------------------------------------
--Pais
CREATE TABLE PAIS_TB(
    ID_PAIS NUMERIC NOT NULL PRIMARY KEY ,
    NOMBRE_PAIS VARCHAR2(30) NOT NULL
);


CREATE TABLE PROVINCIA_TB(
    ID_PROVINCIA NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_PROVINCIA VARCHAR2(30) NOT NULL,
    ID_PAIS NUMERIC NOT NULL,
    CONSTRAINT fk_pais_provincia FOREIGN KEY(ID_PAIS) REFERENCES PAIS_TB(ID_PAIS)
);

CREATE TABLE CANTON_TB(
    ID_CANTON NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_CANTON VARCHAR2(30) NOT NULL,
    ID_PROVINCIA NUMERIC NOT NULL,
    CONSTRAINT fk_provincia_canton FOREIGN KEY(ID_PROVINCIA) REFERENCES PROVINCIA_TB(ID_PROVINCIA)
);

CREATE TABLE DISTRITO_TB(
    ID_DISTRITO NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_DISTRITO VARCHAR2(30) NOT NULL,
    ID_CANTON NUMERIC NOT NULL,
    CONSTRAINT fk_canton_distrito FOREIGN KEY(ID_CANTON) REFERENCES CANTON_TB(ID_CANTON)
);

CREATE TABLE DETALLE_DIRECCION_TB(
    ID_DETALLE_DIRECCION NUMERIC NOT NULL PRIMARY KEY,
    DETALLE_DIRECCION VARCHAR2(30) NOT NULL,
    ID_DISTRITO NUMERIC NOT NULL,
    CODIGO_POSTAL VARCHAR2(5) NOT NULL,
    CONSTRAINT fk_distrito_direccion FOREIGN KEY(ID_DISTRITO) REFERENCES DISTRITO_TB(ID_DISTRITO)
);


--Cliente
CREATE TABLE CLIENTE_TB(
    ID_CLIENTE NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_CLIENTE VARCHAR2(30) NOT NULL,
    PRIMER_APELLIDO VARCHAR2(30) NOT NULL ,
    SEGUNDO_APELLIDO VARCHAR2(30) NOT NULL,
    NUMERO_CEDULA NUMERIC NOT NULL,
    EDAD NUMERIC NOT NULL,
    GENERO VARCHAR2(20),
    ID_DIRECCION NUMERIC NOT NULL,
    CONSTRAINT fk_direccion_cliente FOREIGN KEY (ID_DIRECCION) REFERENCES DETALLE_DIRECCION_TB(ID_DETALLE_DIRECCION)
);

CREATE TABLE TELEFONO_CLIENTE_TB(
    ID_TELEFONO_CLIENTE NUMERIC NOT NULL PRIMARY KEY,
    NUMERO_TELEFONO NUMERIC NOT NULL,
    ID_CLIENTE NUMERIC NOT NULL,
    CONSTRAINT fk_cliente_telefono FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE_TB(ID_CLIENTE)
);

CREATE TABLE EMAIL_CLIENTE_TB(
    ID_EMAIL_CLIENTE NUMERIC NOT NULL PRIMARY KEY,
    EMAIL VARCHAR2(50) NOT NULL,
    ID_CLIENTE NUMERIC NOT NULL,
    CONSTRAINT fk_cliente_email FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE_TB(ID_CLIENTE)
);

--empleado
CREATE TABLE PUESTO_TB(
    ID_PUESTO NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_PUESTO VARCHAR2(30),
    SALARIO NUMBER NOT NULL
);

CREATE TABLE EMPLEADO_TB(
    ID_EMPLEADO NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_EMPLEADO VARCHAR2(30) NOT NULL,
    PRIMER_APELLIDO VARCHAR2(30) NOT NULL ,
    SEGUNDO_APELLIDO VARCHAR2(30) NOT NULL,
    NUMERO_CEDULA NUMERIC NOT NULL,
    EDAD NUMERIC NOT NULL,
    GENERO VARCHAR2(20),
    ID_DIRECCION NUMERIC NOT NULL,
    FECHA_CONTRATACION DATE NOT NULL,
    ID_PUESTO NUMERIC NOT NULL,
    CONSTRAINT fk_direccion_empleado FOREIGN KEY (ID_DIRECCION) REFERENCES DETALLE_DIRECCION_TB(ID_DETALLE_DIRECCION),
    CONSTRAINT fk_puesto_empleado FOREIGN KEY (ID_PUESTO) REFERENCES PUESTO_TB(ID_PUESTO)
);

CREATE TABLE TELEFONO_EMPLEADO_TB(
    ID_TELEFONO_EMPLEADO NUMERIC NOT NULL PRIMARY KEY,
    NUMERO_TELEFONO NUMERIC NOT NULL,
    ID_EMPLEADO NUMERIC NOT NULL,
    CONSTRAINT fk_empleado_telefono FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO_TB(ID_EMPLEADO)
);

CREATE TABLE EMAIL_EMPLEADO_TB(
    ID_EMAIL_EMPLEADO NUMERIC NOT NULL PRIMARY KEY,
    EMAIL VARCHAR2(50) NOT NULL,
    ID_EMPLEADO NUMERIC NOT NULL,
    CONSTRAINT fk_empleado_email FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO_TB(ID_EMPLEADO)
);



-----Proveedor

CREATE TABLE PROVEEDOR_TB(
    ID_PROVEEDOR NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_EMPRESA VARCHAR2(40) NOT NULL,
    PERSONA_CONTACTO VARCHAR2(50) NOT NULL,
    TIPO_PROVEEDOR VARCHAR2(50),
    ID_DIRECCION NUMERIC NOT NULL,
    CONSTRAINT fk_direccion_proveedor FOREIGN KEY(ID_DIRECCION) REFERENCES DETALLE_DIRECCION_TB(ID_DETALLE_DIRECCION)
    );


CREATE TABLE TELEFONO_PROVEEDOR_TB(
    ID_TELEFONO_PROVEEDOR NUMERIC NOT NULL PRIMARY KEY,
    NUMERO_TELEFONO NUMERIC NOT NULL,
    ID_PROVEEDOR NUMERIC NOT NULL,
    CONSTRAINT fk_proveedor_telefono FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR_TB(ID_PROVEEDOR)
);

CREATE TABLE EMAIL_PROVEEDOR_TB(
    ID_EMAIL_PROVEEDOR NUMERIC NOT NULL PRIMARY KEY,
    EMAIL VARCHAR2(50) NOT NULL,
    ID_PROVEEDOR NUMERIC NOT NULL,
    CONSTRAINT fk_proveedor_email FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR_TB(ID_PROVEEDOR)
);




----------------Tablas para el apartado de productos y funcionamiento del inventario

CREATE TABLE CATEGORIA_PRODUCTOS_TB(
    ID_CATEGORIA_PRODUCTOS NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_CATEGORIA VARCHAR2(40) NOT NULL,
    DESCRIPCION_CATEGORIA VARCHAR2(150) NOT NULL,
    ACTIVO NUMBER(1,0)
    );
    
CREATE TABLE PRODUCTO_TB(
    ID_PRODUCTO NUMERIC NOT NULL PRIMARY KEY,
    NOMBRE_PRODUCTO VARCHAR2(40) NOT NULL,
    DESCRIPCION_PRODUCTO VARCHAR2(150) NOT NULL,
    PRECIO NUMBER NOT NULL,
    ID_CATEGORIA NUMERIC NOT NULL,
    CONSTRAINT fk_categoria_producto FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA_PRODUCTOS_TB(ID_CATEGORIA_PRODUCTOS)
    );
    
    
CREATE TABLE INVENTARIO_TB(
    ID_INVENTARIO NUMERIC NOT NULL PRIMARY KEY,
    ID_PRODUCTO NUMERIC NOT NULL,
    CANTIDAD_PRODUCTO NUMBER NOT NULL,
    FECHA_ACTUALIZACION DATE,
    DISPONIBLE NUMBER(1,0),
    CONSTRAINT fk_producto_inventario FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO_TB(ID_PRODUCTO)
    );
    
    
CREATE TABLE AUDITORIA_INVENTARIO_TB(
    ID_AUDI_INVENTARIO NUMBER NOT NULL PRIMARY KEY,
    ACCION VARCHAR2(10),
    ID_PRODUCTO NUMERIC NOT NULL,
    CANTIDAD_ANTERIOR NUMBER ,
    CANTIDAD_ACTUAL NUMBER ,
    FECHA_ACCION DATE,
    CONSTRAINT fk_producto_auditoria FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO_TB(ID_PRODUCTO)
    );

    
CREATE TABLE DESCUENTO_PROMOCION_TB(
    ID_DESCUENTO_PROMOCION NUMERIC NOT NULL PRIMARY KEY,
    ID_PRODUCTO NUMERIC NOT NULL,
    TIPO VARCHAR2(50) NOT NULL,
    DETALLES VARCHAR2(100),
    FECHA_INICIO DATE,
    FECHA_FIN DATE,
    CONSTRAINT fk_producto_desc FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO_TB(ID_PRODUCTO)
    );
    


-----------ORDENES PROVEEDOR

CREATE TABLE ORDEN_PROVEEDOR_TB(
    ID_ORDEN_PROVEEDOR NUMERIC NOT NULL PRIMARY KEY,
    ID_PROVEEDOR NUMERIC NOT NULL,
    DETALLES VARCHAR2(100),
    FECHA_PEDIDO DATE NOT NULL,
    FECHA_ESTIMADA_FIN DATE NOT NULL,
    CONSTRAINT fk_proveedor_ordenProveedor FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR_TB(ID_PROVEEDOR)
    );

    
CREATE TABLE DETALLE_ORDEN_PROVEEDOR_TB(
    ID_DETALLE_ORDEN NUMERIC NOT NULL PRIMARY KEY,
    ID_ORDEN_PROVEEDOR NUMERIC NOT NULL,
    ID_PRODUCTO NUMERIC NOT NULL,
    CANTIDAD NUMBER,
    CONSTRAINT fk_ordenProveedor_detalleOrden FOREIGN KEY (ID_ORDEN_PROVEEDOR) REFERENCES ORDEN_PROVEEDOR_TB(ID_ORDEN_PROVEEDOR),
    CONSTRAINT fk_ordenProveedor_producto FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO_TB(ID_PRODUCTO)
);


--------METODO PAGO
CREATE TABLE METODO_PAGO_TB(
    ID_METODO_PAGO NUMBER GENERATED ALWAYS AS IDENTITY(
        START WITH 50  
        INCREMENT BY 1
    ),
    NOMBRE_METODO_PAGO VARCHAR(50) NOT NULL,
    ACTIVO NUMBER(1,0) default 1,
    DETALLES VARCHAR2(100)
    );

    

/*Comentarios*/
COMMENT ON COLUMN Metodo_Pago_tb.ID_METODO_PAGO IS 'Llave primaria de la tabla';
COMMENT ON COLUMN Metodo_Pago_tb.TIPO_METODO_PAGO IS 'El tipo de metodo de pago: efectivo, tarjeta, transaccion,sinpe';
COMMENT ON COLUMN Metodo_Pago_tb.Activo IS 'Indica si el m�todo de pago est� activo (S�(1)/N0(0))';
COMMENT ON COLUMN Metodo_Pago_tb.DETALLES IS 'Detalles del metodo de pago como el nombre del banco, en colones, dolares';




----------FACTURACION

CREATE TABLE FACTURA_TB(
    ID_FACTURA NUMERIC NOT NULL PRIMARY KEY,
    ID_CLIENTE NUMERIC NOT NULL,
    ID_EMPLEADO NUMERIC NOT NULL,
    ID_METODO_PAGO NUMERIC NOT NULL,
    DETALLES VARCHAR2(100),
    ESTADO VARCHAR2(20),
    FECHA_FACTURACION DATE,
    FECHA_IMPRESION DATE,
    TOTAL NUMBER NOT NULL,
    CONSTRAINT fk_cliente_factura FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE_TB(ID_CLIENTE),
    CONSTRAINT fk_empleado_factura FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO_TB(ID_EMPLEADO),
    CONSTRAINT fk_metodoPago_factura FOREIGN KEY (ID_METODO_PAGO) REFERENCES METODO_PAGO_TB(ID_METODO_PAGO)
    );

CREATE TABLE DETALLE_FACTURA_TB(
    ID_DETALLE_FACTURA NUMERIC NOT NULL PRIMARY KEY,
    ID_FACTURA NUMERIC NOT NULL,
    ID_PRODUCTO NUMERIC NOT NULL,
    CANTIDAD_PRODUCTOS NUMERIC NOT NULL,
    PRECIO_FILA VARCHAR2(100),
    CONSTRAINT fk_factura_detalleFactura FOREIGN KEY (ID_FACTURA) REFERENCES FACTURA_TB(ID_FACTURA),
    CONSTRAINT fk_producto_detalleFactura FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO_TB(ID_PRODUCTO)
    );
    
CREATE TABLE historial_ventas (
    id_venta NUMBER GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOT NULL ENABLE,
    id_factura NUMBER,
    fecha_venta DATE,
    total_venta NUMBER,
    CONSTRAINT fk_factura FOREIGN KEY (id_factura) REFERENCES factura_tb (id_factura)
);

--------PEDIDOS CLIENTE

CREATE TABLE PEDIDO_CLIENTE_TB(
    ID_PEDIDO_CLIENTE NUMERIC NOT NULL PRIMARY KEY,
    ID_FACTURA NUMERIC NOT NULL,
    ID_DIRECCION NUMERIC NOT NULL,    
    ID_CLIENTE NUMERIC NOT NULL,
    ESTADO_PEDIDO VARCHAR2(100),
    CONSTRAINT fk_factura_pedidoCliente FOREIGN KEY (ID_FACTURA) REFERENCES FACTURA_TB(ID_FACTURA),
    CONSTRAINT fk_direccion_pedidoCliente FOREIGN KEY (ID_DIRECCION) REFERENCES DETALLE_DIRECCION_TB(ID_DETALLE_DIRECCION),
    CONSTRAINT fk_cliente_pedidoCliente FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE_TB(ID_CLIENTE)
    );



--------Transacciones

CREATE TABLE TRANSACCION_DEVOLUCION(
    ID_TRANSACCION_DEVOLUCION NUMERIC NOT NULL PRIMARY KEY,
    ID_FACTURA NUMERIC NOT NULL,
    ID_CLIENTE NUMERIC NOT NULL,
    CANTIDAD_DEVUELTA NUMBER NOT NULL,
    FECHA_DEVOLUCION DATE NOT NULL,
    MOTIVO_DEVOLUCION VARCHAR2(200) NOT NULL,
    DETALLES VARCHAR2(150) NOT NULL,
    CONSTRAINT fk_factura_transaccionDev FOREIGN KEY (ID_FACTURA) REFERENCES FACTURA_TB(ID_FACTURA),
    CONSTRAINT fk_cliente_transaccionDev FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE_TB(ID_CLIENTE)
);
    

CREATE TABLE TRANSACCION_COMPRA(
    ID_TRANSACCION_COMPRA NUMERIC NOT NULL PRIMARY KEY,
    ID_ORDEN NUMERIC NOT NULL,
    ID_METODO_PAGO NUMERIC NOT NULL,
    FECHA_TRANSACCION DATE NOT NULL,
    DETALLES VARCHAR2(150) NOT NULL,
    CONSTRAINT fk_orden_transaccionCompra FOREIGN KEY (ID_ORDEN) REFERENCES ORDEN_PROVEEDOR_TB(ID_ORDEN_PROVEEDOR),
    CONSTRAINT fk_metodoPago_transaccionCompra FOREIGN KEY (ID_METODO_PAGO) REFERENCES METODO_PAGO_TB(ID_METODO_PAGO)
);





CREATE TABLE ejemplo_tabla (
    id NUMBER GENERATED ALWAYS AS IDENTITY(
        START WITH 1000  -- Valor inicial espec�fico
        INCREMENT BY 1
    ),
    nombre VARCHAR2(50),
    otro_campo VARCHAR2(50),
    CONSTRAINT pk_ejemplo_tabla PRIMARY KEY (id)
);

drop table ejemplo_tabla
INSERT INTO EJEMPLO_TABLA(nombre,otro_campo)
VALUES('camilo','beto')
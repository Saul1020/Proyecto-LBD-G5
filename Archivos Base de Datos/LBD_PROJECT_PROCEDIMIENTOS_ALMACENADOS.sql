--Archivo para realizar SP dentro de la DB


--Manipulaci�n de los m�todos de pago

--Inserci�n de los metodos de pago
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE INSERTAR_METODOPAGO(
    id_metodo METODO_PAGO_TB.ID_METODO_PAGO%TYPE,
    tipo METODO_PAGO_TB.TIPO_METODO_PAGO%TYPE,
    detalles METODO_PAGO_TB.DETALLES%TYPE
)     
AS
    validar BOOLEAN;
    cantidad NUMBER;

BEGIN
    
    SELECT COUNT(*) INTO cantidad
    FROM METODO_PAGO_TB
    WHERE ID_METODO_PAGO = id_metodo;
    --Validar la existencia de un registro con el id
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    --Si el registro no existe se inserta uno nuevo
    IF validar = FALSE THEN
        INSERT INTO METODO_PAGO_TB(ID_METODO_PAGO,TIPO_METODO_PAGO,DETALLES)
        VALUES(id_metodo,tipo,detalles);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se ha insertado correctamente un registro con el id : ' || id_metodo);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ya existe un registro con el id : ' || id_metodo);
    END IF;

EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;

EXECUTE INSERTAR_METODOPAGO(2,'Efectivo','Pago con d�lares')--Prueba de inserci�n

--Procedimeinto para el Borrado de los m�todos de pago

CREATE OR REPLACE PROCEDURE ELIMINAR_METODOPAGO(id_metodo METODO_PAGO_TB.ID_METODO_PAGO%TYPE)
AS
    validar BOOLEAN;
    cantidad NUMBER;

BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM METODO_PAGO_TB
    WHERE ID_METODO_PAGO = id_metodo;
    --Validar la existencia de un registro con el id
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    --SI EXISTE UNN REGISTRO REALIZAR EL BORRADO
    IF validar = TRUE THEN
        DELETE FROM METODO_PAGO_TB
        WHERE ID_METODO_PAGO = id_metodo;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Registro eliminado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
    END IF;
END;
--PRUEBA DE BORRADO
EXECUTE ELIMINAR_METODOPAGO(1);


--Procedimiento para desactivar el metodo de pago
CREATE OR REPLACE PROCEDURE ACTIVAR_DESACTIVAR_MP(id_metodo METODO_PAGO_TB.ID_METODO_PAGO%TYPE)
AS
    estado NUMBER;
BEGIN
    SELECT ACTIVO INTO estado
    FROM METODO_PAGO_TB
    WHERE ID_METODO_PAGO = id_metodo;
    
    IF estado = 0 THEN
        UPDATE METODO_PAGO_TB
        SET ACTIVO = 1
        WHERE ID_METODO_PAGO = id_metodo;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Activado correctamente');
    ELSIF estado = 1 THEN
        UPDATE METODO_PAGO_TB
        SET ACTIVO = 0
        WHERE ID_METODO_PAGO = id_metodo;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Desactivado correctamente');
    END IF;
    
EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;
        
--PRUEBA DE CAMBIO DE ESTADO
EXEC ACTIVAR_DESACTIVAR_MP(2);

--Procedimiento para actualizar el metodo de pago

CREATE OR REPLACE PROCEDURE ACTUALIZAR_METODO_PAGO(id_metodo METODO_PAGO_TB.ID_METODO_PAGO%TYPE, tipo METODO_PAGO_TB.TIPO_METODO_PAGO%TYPE, detalles METODO_PAGO_TB.DETALLES%TYPE)
AS
    contador NUMBER;
    verificar BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO contador
    FROM METODO_PAGO_TB
    WHERE ID_METODO_PAGO = id_metodo;
    
    IF contador = 0 THEN
        verificar := FALSE;
    ELSIF contador = 1 THEN
        verificar := TRUE;
    END IF;
    
    IF verificar = TRUE THEN
        UPDATE METODO_PAGO_TB
        SET ID_METODO_PAGO = id_metodo, TIPO_METODO_PAGO = tipo, DETALLES = detalles
        WHERE ID_METODO_PAGO = id_metodo;
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe un registro en la base de datos');
    end if;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;
--Prueba actualizar metodo pago
exec ACTUALIZAR_METODO_PAGO(2,'Tarjeta de Credito',  'Banco Nacional');



----Manipulacion de facturas

--Creaci�n de una factura


CREATE OR REPLACE PROCEDURE INSERTAR_FACTURA(
    id_factura FACTURA_TB.ID_FACTURA%TYPE,
    id_cliente FACTURA_TB.ID_CLIENTE%TYPE,
    id_empleado FACTURA_TB.ID_EMPLEADO%TYPE,
    id_metodo FACTURA_TB.ID_METODO_PAGO%TYPE,
    detalles FACTURA_TB.DETALLES%TYPE,
    fecha_factuacion FACTURA_TB.FECHA_FACTURACION%TYPE,
    fecha_impresion FACTURA_TB.FECHA_IMPRESION%TYPE,
    total FACTURA_TB.TOTAL%TYPE
)     
AS
    validar BOOLEAN;
    cantidad NUMBER;

BEGIN
    
    SELECT COUNT(*) INTO cantidad
    FROM FACTURA_TB
    WHERE ID_FACTURA = id_factura;
    
    --Validar la existencia de un registro con el id
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    --Si el registro no existe se inserta uno nuevo
    IF validar = FALSE THEN
        INSERT INTO FACTURA_TB(ID_FACTURA, ID_CLIENTE, ID_EMPLEADO, ID_METODO_PAGO, DETALLES, FECHA_FACTURACION, FECHA_IMPRESION, TOTAL)
        VALUES(id_factura,id_cliente,id_empleado,id_metodo,detalles,fecha_factuacion,fecha_impresion,total);
        COMMIT;

    END IF;

EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;

EXECUTE INSERTAR_FACTURA(1,1,1,1,'direccion','25-MAR-2024','25-MAR-2024',8000);


--Funcion para eliminar una factura
CREATE OR REPLACE PROCEDURE ELIMINAR_FACTURA(id_factura FACTURA_TB.ID_FACTURA%TYPE)
AS
    cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM FACTURA_TB
    WHERE ID_FACTURA = id_factura;
    --Validar la existencia de un registro con el id
    
    --SI EXISTE UNN REGISTRO REALIZAR EL BORRADO
    IF cantidad>0 THEN
        DELETE FROM DETALLE_FACTURA_TB
        WHERE id_factura = id_factura;

        -- Eliminar la factura
        DELETE FROM FACTURA_TB
        WHERE ID_FACTURA = id_factura;

        -- Realizar un commit para hacer permanentes los cambios
        COMMIT;
        
        -- Mensaje de �xito
        DBMS_OUTPUT.PUT_LINE('Factura eliminada correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
    END IF;
END;
--PRUEBA DE BORRADO
EXECUTE ELIMINAR_FACTURA(1);


--Procedimiento para insertar un detalle de factura

CREATE OR REPLACE PROCEDURE INSERTAR_DETALLE_FACTURA(
    id_detalle_factura DETALLE_FACTURA_TB.ID_DETALLE_FACTURA%TYPE,
    id_factura DETALLE_FACTURA_TB.ID_FACTURA%TYPE,
    id_producto DETALLE_FACTURA_TB.ID_PRODUCTO%TYPE,
    cantidad_producto DETALLE_FACTURA_TB.CANTIDAD_PRODUCTOS%TYPE,
    precio_fila DETALLE_FACTURA_TB.PRECIO_FILA%TYPE
)     
AS
    validar BOOLEAN;
    cantidad NUMBER;

BEGIN
    
    SELECT COUNT(*) INTO cantidad
    FROM DETALLE_FACTURA_TB
    WHERE ID_DETALLE_FACTURA = id_detalle_factura;
    
    --Validar la existencia de un registro con el id
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    --Si el registro no existe se inserta uno nuevo
    IF validar = FALSE THEN
        INSERT INTO DETALLE_FACTURA_TB(ID_DETALLE_FACTURA, ID_FACTURA, ID_PRODUCTO, CANTIDAD_PRODUCTOS, PRECIO_FILA)
        VALUES(id_detalle_factura, id_factura,id_producto ,cantidad_producto,precio_fila);
        COMMIT;

    END IF;

EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;


EXECUTE INSERTAR_DETALLE_FACTURA(1,1,1,5,25000);


--PROCEDIMIENTOS PARA EL APARTADO DE HISTORIAL DE VENTAS

--PROCEDIMEINTO PARA INSERTAR LOS HISTORICOS DE VENTAS
CREATE OR REPLACE PROCEDURE CREAR_VENTA(
    id_factura IN historial_ventas.id_factura%TYPE,
    fecha_venta IN historial_ventas.fecha_venta%TYPE,
    total_venta IN historial_ventas.total_venta%TYPE
) AS
BEGIN
    INSERT INTO historial_ventas (id_factura, fecha_venta, total_venta)
    VALUES (id_factura, fecha_venta, total_venta);
    COMMIT;
END;

--PROCEDIMIENTO PARA BORRAR UN HISTORIAL DE VENTA
CREATE OR REPLACE PROCEDURE ELIMINAR_VENTA(
    id_venta IN historial_ventas.id_venta%TYPE
) AS
BEGIN
    DELETE FROM historial_ventas
    WHERE id_venta = id_venta;
    COMMIT;1020Saul
END;


--Procedimientos para pedidos 

-- Gestion pedidos clientes
/* ================================= Inicio Create ================================= */  
CREATE OR REPLACE PROCEDURE INSERTAR_PEDIDO_CLIENTE(
    idPedidoCliente PEDIDO_CLIENTE_TB.ID_PEDIDO_CLIENTE%TYPE,
    id_factura PEDIDO_CLIENTE_TB.ID_FACTURA%TYPE,
    id_direccion PEDIDO_CLIENTE_TB.ID_DIRECCION%TYPE,
    id_cliente PEDIDO_CLIENTE_TB.ID_CLIENTE%TYPE,
    estado_pedido PEDIDO_CLIENTE_TB.ESTADO_PEDIDO%TYPE
)     
AS
    cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantidad FROM PEDIDO_CLIENTE_TB WHERE ID_PEDIDO_CLIENTE = idPedidoCliente;

    IF cantidad=0 THEN
        INSERT INTO PEDIDO_CLIENTE_TB(ID_PEDIDO_CLIENTE, ID_FACTURA, ID_DIRECCION, ID_CLIENTE, ESTADO_PEDIDO)
        VALUES(idPedidoCliente, id_factura, id_direccion, id_cliente, estado_pedido);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se ha insertado correctamente un registro con el ID de pedido cliente: ' || idPedidoCliente);
    ELSE
        -- Si el registro ya existe, mostrar un mensaje
        DBMS_OUTPUT.PUT_LINE('Ya existe un registro con el ID de pedido cliente: ' || idPedidoCliente);
    END IF;
END;

BEGIN
    INSERTAR_PEDIDO_CLIENTE(30000, 23002, 4002, 5002, 'En espera');
END;

SELECT * FROM PEDIDO_CLIENTE_TB;
/* ================================= Fin Create ================================= */  

/* ================================= Inicio Update ================================= */  
CREATE OR REPLACE PROCEDURE ACTUALIZAR_ESTADO_PEDIDO(
    id_pedido_cliente_in PEDIDO_CLIENTE_TB.ID_PEDIDO_CLIENTE%TYPE,
    nuevo_estado_pedido_in PEDIDO_CLIENTE_TB.ESTADO_PEDIDO%TYPE
)
AS
    contador NUMBER;
    verificar BOOLEAN;
BEGIN
    -- En esta parte validamos si el id existe
    SELECT COUNT(*) INTO contador
    FROM PEDIDO_CLIENTE_TB
    WHERE ID_PEDIDO_CLIENTE = id_pedido_cliente_in;
    
    IF contador = 0 THEN
        verificar := FALSE;
    ELSIF contador = 1 THEN
        verificar := TRUE;
    END IF;
    
    IF verificar = TRUE THEN
        UPDATE PEDIDO_CLIENTE_TB
        SET ESTADO_PEDIDO = nuevo_estado_pedido_in
        WHERE ID_PEDIDO_CLIENTE = id_pedido_cliente_in;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('El estado del pedido se actualiza correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ningun pedido con este id.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
END;

-- Prueba de actualizar el pedido ingresando el id de la tabla (ID_CLIENTE_PEDIDO) y cambiendo el estado en este caso "En proceso" 
BEGIN
    ACTUALIZAR_ESTADO_PEDIDO(30000, 'En proceso');
END;

-- Ver la tabla de (PEDIDO_CLIENTE_TB)
SELECT * FROM PEDIDO_CLIENTE_TB;
/* ================================= Fin Update ================================= */  

/* ================================= Inicio Delete ================================= */  
CREATE OR REPLACE PROCEDURE ELIMINAR_PEDIDO_CLIENTE(
    idPedidoCliente PEDIDO_CLIENTE_TB.ID_PEDIDO_CLIENTE%TYPE
)
AS
    validar BOOLEAN;
    cantidad NUMBER;
BEGIN
    -- Verificar la existencia del registro con el ID proporcionado
    SELECT COUNT(*) INTO cantidad
    FROM PEDIDO_CLIENTE_TB
    WHERE ID_PEDIDO_CLIENTE = idPedidoCliente;
    
    -- Validar la existencia del registro
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    -- Si existe un registro, realizar el borrado
    IF validar = TRUE THEN
        DELETE FROM PEDIDO_CLIENTE_TB
        WHERE ID_PEDIDO_CLIENTE = idPedidoCliente;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('El pedido del cliente se eliminó correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
    END IF;
EXCEPTION
    -- Capturar cualquier excepción y mostrar un mensaje de error
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hubo un error al eliminar el pedido: ' || SQLERRM);
END ELIMINAR_PEDIDO_CLIENTE;

-- Prueba de eliminar, en este caso solo se ingresa el id de la tabla (ID_CLIENTE_PEDIDO)
BEGIN
    ELIMINAR_PEDIDO_CLIENTE(30000);
END;

-- Ver la tabla de (PEDIDO_CLIENTE_TB)
SELECT * FROM PEDIDO_CLIENTE_TB;
/* ================================= Fin Delete ================================= */

-- Gestion Clientes
/* ================================= Inicio Create ================================= */
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE INSERTAR_CLIENTE(
    idCliente CLIENTE_TB.ID_CLIENTE%TYPE,
    nombre_cliente CLIENTE_TB.NOMBRE_CLIENTE%TYPE,
    primer_apellido CLIENTE_TB.PRIMER_APELLIDO%TYPE,
    segundo_apellido CLIENTE_TB.SEGUNDO_APELLIDO%TYPE,
    numero_cedula CLIENTE_TB.NUMERO_CEDULA%TYPE,
    edad CLIENTE_TB.EDAD%TYPE,
    genero CLIENTE_TB.GENERO%TYPE,
    id_direccion CLIENTE_TB.ID_DIRECCION%TYPE
)     
AS
    validar BOOLEAN;
    cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM CLIENTE_TB
    WHERE ID_CLIENTE = idCliente;
    
    IF cantidad = 0 THEN
        validar := FALSE;
    ELSE
        validar := TRUE;
    END IF;
    
    -- Validar el id
    IF validar = FALSE THEN
        -- Si el registro no existe, se inserta uno nuevo
        INSERT INTO CLIENTE_TB(ID_CLIENTE, NOMBRE_CLIENTE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, NUMERO_CEDULA, EDAD, GENERO, ID_DIRECCION)
        VALUES(idCliente, nombre_cliente, primer_apellido, segundo_apellido, numero_cedula, edad, genero, id_direccion);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se ha insertado correctamente un cliente con ID: ' || idCliente);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ya existe un cliente con ID: ' || idCliente);
    END IF;
END;

// Cambiar todo los datos menos la direccion
BEGIN
    INSERTAR_CLIENTE(5004, 'Juan', 'Perez', 'Gomez', 119472615, 30, 'Masculino', 4002);
END;

SELECT * FROM cliente_tb
/* ================================= Fin Create ================================= */

/* ================================= Inicio Update ================================= */
CREATE OR REPLACE PROCEDURE ACTUALIZAR_CLIENTE(
    id_cliente_in CLIENTE_TB.ID_CLIENTE%TYPE,
    nombre_cliente_in CLIENTE_TB.NOMBRE_CLIENTE%TYPE,
    primer_apellido_in CLIENTE_TB.PRIMER_APELLIDO%TYPE,
    segundo_apellido_in CLIENTE_TB.SEGUNDO_APELLIDO%TYPE,
    numero_cedula_in CLIENTE_TB.NUMERO_CEDULA%TYPE,
    edad_in CLIENTE_TB.EDAD%TYPE,
    genero_in CLIENTE_TB.GENERO%TYPE,
    id_direccion_in CLIENTE_TB.ID_DIRECCION%TYPE
)
AS
    contador NUMBER;
    verificar BOOLEAN;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO contador
    FROM CLIENTE_TB
    WHERE ID_CLIENTE = id_cliente_in;
    
    IF contador = 0 THEN
        verificar := FALSE;
    ELSIF contador = 1 THEN
        verificar := TRUE;
    END IF;
    
    IF verificar = TRUE THEN
        -- Actualizar los datos del cliente
        UPDATE CLIENTE_TB
        SET NOMBRE_CLIENTE = nombre_cliente_in,
            PRIMER_APELLIDO = primer_apellido_in,
            SEGUNDO_APELLIDO = segundo_apellido_in,
            NUMERO_CEDULA = numero_cedula_in,
            EDAD = edad_in,
            GENERO = genero_in,
            ID_DIRECCION = id_direccion_in
        WHERE ID_CLIENTE = id_cliente_in;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Los datos del cliente se actualizaron correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ningún cliente con el in ingresado ID.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
END;

BEGIN
    ACTUALIZAR_CLIENTE(5003, 'Paul', 'Serrano', 'Salas', 118920171, 20, 'Masculino', 4001);
END;

SELECT * FROM cliente_tb
/* ================================= Fin Update================================= */

/* ================================= Inicio Delete ================================= */
CREATE OR REPLACE PROCEDURE ELIMINAR_CLIENTE(
    idCliente CLIENTE_TB.ID_CLIENTE%TYPE
)
AS
    validar BOOLEAN;
    cantidad NUMBER;
BEGIN
    -- Verificar la existencia del cliente con el ID proporcionado
    SELECT COUNT(*) INTO cantidad
    FROM CLIENTE_TB
    WHERE ID_CLIENTE = idCliente;
    
    -- Validar la existencia del cliente
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    -- Si existe el cliente, se elimina
    IF validar = TRUE THEN
        DELETE FROM CLIENTE_TB
        WHERE ID_CLIENTE = idCliente;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('El cliente se eliminó correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para eliminar.');
    END IF;
EXCEPTION
    -- Capturar cualquier excepción y mostrar un mensaje de error
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hubo un error al eliminar el cliente: ' || SQLERRM);
END ELIMINAR_CLIENTE;

-- Prueba de eliminar un cliente
BEGIN
    ELIMINAR_CLIENTE(5004);
END;

-- Ver la tabla de CLIENTE_TB para verificar los cambios
SELECT * FROM CLIENTE_TB;
/* ================================= Fin Delete ================================= */

-- Gestion Proveedores
/* ================================= Inicio Create ================================= */
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE INSERTAR_PROVEEDOR(
    idProveedor PROVEEDOR_TB.ID_PROVEEDOR%TYPE,
    nombre_empresa PROVEEDOR_TB.NOMBRE_EMPRESA%TYPE,
    persona_contacto PROVEEDOR_TB.PERSONA_CONTACTO%TYPE,
    tipo_proveedor PROVEEDOR_TB.TIPO_PROVEEDOR%TYPE,
    id_direccion PROVEEDOR_TB.ID_DIRECCION%TYPE
)     
AS
    validar BOOLEAN;
    cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM PROVEEDOR_TB
    WHERE ID_PROVEEDOR = idProveedor;
    
    IF cantidad = 0 THEN
        validar := FALSE;
    ELSE
        validar := TRUE;
    END IF;
    
    -- Validar el ID
    IF validar = FALSE THEN
        -- Si el registro no existe, se inserta uno nuevo
        INSERT INTO PROVEEDOR_TB(ID_PROVEEDOR, NOMBRE_EMPRESA, PERSONA_CONTACTO, TIPO_PROVEEDOR, ID_DIRECCION)
        VALUES(idProveedor, nombre_empresa, persona_contacto, tipo_proveedor, id_direccion);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se ha insertado correctamente un proveedor con ID: ' || idProveedor);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ya existe un proveedor con ID: ' || idProveedor);
    END IF;
END;

BEGIN
    INSERTAR_PROVEEDOR(12003, 'Proveedor 123', 'Maria Sanchez', 'Electrodomésticos', 4000);
END;

SELECT * FROM PROVEEDOR_TB;
/* ================================= Fin Create ================================= */

/* ================================= Inicio Update ================================= */
CREATE OR REPLACE PROCEDURE ACTUALIZAR_PROVEEDOR(
    id_proveedor_in PROVEEDOR_TB.ID_PROVEEDOR%TYPE,
    nombre_empresa_in PROVEEDOR_TB.NOMBRE_EMPRESA%TYPE,
    persona_contacto_in PROVEEDOR_TB.PERSONA_CONTACTO%TYPE,
    tipo_proveedor_in PROVEEDOR_TB.TIPO_PROVEEDOR%TYPE,
    id_direccion_in PROVEEDOR_TB.ID_DIRECCION%TYPE
)
AS
    contador NUMBER;
    verificar BOOLEAN;
BEGIN
    -- Verificar si el proveedor existe
    SELECT COUNT(*) INTO contador
    FROM PROVEEDOR_TB
    WHERE ID_PROVEEDOR = id_proveedor_in;
    
    IF contador = 0 THEN
        verificar := FALSE;
    ELSIF contador = 1 THEN
        verificar := TRUE;
    END IF;
    
    IF verificar = TRUE THEN
        -- Actualizar los datos del proveedor
        UPDATE PROVEEDOR_TB
        SET NOMBRE_EMPRESA = nombre_empresa_in,
            PERSONA_CONTACTO = persona_contacto_in,
            TIPO_PROVEEDOR = tipo_proveedor_in,
            ID_DIRECCION = id_direccion_in
        WHERE ID_PROVEEDOR = id_proveedor_in;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Los datos del proveedor se actualizaron correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ningún proveedor con el ID ingresado.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
END;

BEGIN
    ACTUALIZAR_PROVEEDOR(12003, 'Proveedores SA', 'asdfasdfasdf Perez', 'sdfgsdfg', 4001);
END;

SELECT * FROM PROVEEDOR_TB;
/* ================================= Fin Update ================================= */

/* ================================= Inicio Delete ================================= */
CREATE OR REPLACE PROCEDURE ELIMINAR_PROVEEDOR(
    idProveedor PROVEEDOR_TB.ID_PROVEEDOR%TYPE
)
AS
    validar BOOLEAN;
    cantidad NUMBER;
BEGIN
    -- Verificar la existencia del proveedor con el ID proporcionado
    SELECT COUNT(*) INTO cantidad
    FROM PROVEEDOR_TB
    WHERE ID_PROVEEDOR = idProveedor;
    
    -- Validar la existencia del proveedor
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    -- Si existe el proveedor, se elimina
    IF validar = TRUE THEN
        DELETE FROM PROVEEDOR_TB
        WHERE ID_PROVEEDOR = idProveedor;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('El proveedor se eliminó correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para eliminar.');
    END IF;
EXCEPTION
    -- Capturar cualquier excepción y mostrar un mensaje de error
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hubo un error al eliminar el proveedor: ' || SQLERRM);
END ELIMINAR_PROVEEDOR;


BEGIN
    ELIMINAR_PROVEEDOR(12003);
END;

SELECT * FROM PROVEEDOR_TB;
/* ================================= Fin Delete ================================= */

--Procedimientos para prductos

---Insercion de productos en la tabla PRODUCTO_TB
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE INSERTAR_PRODUCTO(
    p_id_producto PRODUCTO_TB.ID_PRODUCTO%TYPE,
    p_nombre_producto PRODUCTO_TB.NOMBRE_PRODUCTO%TYPE,
    p_descripcion_producto PRODUCTO_TB.DESCRIPCION_PRODUCTO%TYPE,
    p_precio PRODUCTO_TB.PRECIO%TYPE,
    p_id_categoria PRODUCTO_TB.ID_CATEGORIA%TYPE
)
AS
    validar BOOLEAN;
    cantidad NUMBER;

BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM PRODUCTO_TB
    WHERE ID_PRODUCTO = p_id_producto;
    
    -- Validar la existencia de un registro con el ID
    IF cantidad > 0 THEN
        validar := TRUE;
    ELSE
        validar := FALSE;
    END IF;
    
    -- Si el registro no existe, se inserta uno nuevo
    IF validar = FALSE THEN
        INSERT INTO PRODUCTO_TB(ID_PRODUCTO, NOMBRE_PRODUCTO, DESCRIPCION_PRODUCTO, PRECIO, ID_CATEGORIA)
        VALUES(p_id_producto, p_nombre_producto, p_descripcion_producto, p_precio, p_id_categoria);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se ha insertado correctamente un producto con el ID: ' || p_id_producto);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ya existe un producto con el ID: ' || p_id_producto);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;

EXECUTE INSERTAR_PRODUCTO(1, 'Martillo', 'Martillo de acero con mango de madera', 15.99, 1); --Prueba de inserci?n


-- Actualizaci?n del precio de un producto
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE ACTUALIZAR_PRECIO_PRODUCTO(
    p_id_producto PRODUCTO_TB.ID_PRODUCTO%TYPE,
    p_nuevo_precio PRODUCTO_TB.PRECIO%TYPE
)
AS
    cantidad NUMBER;

BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM PRODUCTO_TB
    WHERE ID_PRODUCTO = p_id_producto;

    -- Verificar si existe un producto con el ID especificado
    IF cantidad > 0 THEN
        UPDATE PRODUCTO_TB
        SET PRECIO = p_nuevo_precio
        WHERE ID_PRODUCTO = p_id_producto;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Precio del producto actualizado correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontr? ning?n producto con el ID especificado.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar el precio del producto: ' || SQLERRM);
END ACTUALIZAR_PRECIO_PRODUCTO;

EXECUTE ACTUALIZAR_PRECIO_PRODUCTO(1, 19.99); --Prueba de actualizaci?n








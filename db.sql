CREATE TRIGGER trigger_actualizar_stock
AFTER INSERT ON ventas_detalle
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock();
CREATE OR REPLACE FUNCTION registrar_auditoria_venta() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO auditoria_ventas (venta_id, usuario)
  VALUES (NEW.id, current_user);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_registrar_auditoria_venta
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria_venta();
CREATE OR REPLACE FUNCTION notificar_agotado() 
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.stock = 0 THEN
    INSERT INTO alertas_stock (producto_id, nombre_producto, mensaje)
    VALUES (NEW.id, NEW.nombre, 'El producto ha agotado su stock');
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_notificar_agotado
AFTER UPDATE ON productos
FOR EACH ROW
WHEN (OLD.stock > 0 AND NEW.stock = 0)
EXECUTE FUNCTION notificar_agotado();
CREATE OR REPLACE FUNCTION validar_cliente() 
RETURNS TRIGGER AS $$
BEGIN
  -- Validar que el correo no esté vacío
  IF NEW.correo IS NULL OR NEW.correo = '' THEN
    RAISE EXCEPTION 'El correo no puede estar vacío';
  END IF;

  -- Validar que el correo sea único
  IF EXISTS (SELECT 1 FROM clientes WHERE correo = NEW.correo) THEN
    RAISE EXCEPTION 'El correo % ya está registrado', NEW.correo;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_validar_cliente
BEFORE INSERT ON clientes
FOR EACH ROW
EXECUTE FUNCTION validar_cliente();
CREATE OR REPLACE FUNCTION registrar_historial_precio() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo)
  VALUES (NEW.id, OLD.precio, NEW.precio);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_registrar_historial_precio
AFTER UPDATE ON productos
FOR EACH ROW
WHEN (OLD.precio <> NEW.precio)
EXECUTE FUNCTION registrar_historial_precio();
CREATE OR REPLACE FUNCTION bloquear_eliminacion_proveedor() 
RETURNS TRIGGER AS $$
BEGIN
  -- Verificar si el proveedor tiene productos asociados
  IF EXISTS (SELECT 1 FROM productos WHERE proveedor_id = OLD.id) THEN
    RAISE EXCEPTION 'El proveedor % tiene productos asociados y no puede ser eliminado', OLD.nombre;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_bloquear_eliminacion_proveedor
BEFORE DELETE ON proveedores
FOR EACH ROW
EXECUTE FUNCTION bloquear_eliminacion_proveedor();
CREATE OR REPLACE FUNCTION validar_fecha_venta() 
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.fecha > CURRENT_TIMESTAMP THEN
    RAISE EXCEPTION 'La fecha de la venta no puede ser mayor a la fecha actual';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_validar_fecha_venta
BEFORE INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION validar_fecha_venta();
CREATE OR REPLACE FUNCTION actualizar_estado_cliente() 
RETURNS TRIGGER AS $$
BEGIN

  IF NOT EXISTS (SELECT 1 FROM ventas WHERE cliente_id = NEW.cliente_id AND fecha > CURRENT_DATE - INTERVAL '6 months') THEN
    UPDATE clientes SET estado = 'activo' WHERE id = NEW.cliente_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_actualizar_estado_cliente
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_cliente();
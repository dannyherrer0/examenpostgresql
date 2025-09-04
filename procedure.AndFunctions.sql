 -- Iniciar transacción
  BEGIN
    -- Registrar la venta
    INSERT INTO ventas (cliente_id) VALUES (cliente_id) RETURNING id INTO venta_id;

    -- Iterar sobre los productos de la venta
    FOR producto_record IN SELECT * FROM jsonb_array_elements(productos)
    LOOP
      -- Obtener el stock actual del producto
      SELECT stock INTO stock_actual FROM productos WHERE id = producto_record->>'id';

      -- Verificar que haya suficiente stock
      IF stock_actual < (producto_record->>'cantidad')::INT THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto %', producto_record->>'id';
      END IF;

      -- Insertar detalles de la venta
      INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
      VALUES (venta_id, producto_record->>'id', (producto_record->>'cantidad')::INT, (producto_record->>'precio')::NUMERIC);

      -- Actualizar el stock
      UPDATE productos SET stock = stock - (producto_record->>'cantidad')::INT WHERE id = producto_record->>'id';
    END LOOP;
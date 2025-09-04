-- Insertar ventas
INSERT INTO proveedores (nombre) VALUES 
  ('Proveedor A'),
  ('Proveedor B'),
  ('Proveedor C');
  ('Proveedor D');
  ('Proveedor E');
  ('Proveedor F');
  ('Proveedor G');
  ('Proveedor H');
  ('Proveedor I');
  ('Proveedor J');
  ('Proveedor K');
  ('Proveedor L');
  ('Proveedor M');
  ('Proveedor N');
  ('Proveedor O');

-- Insertar productos
INSERT INTO productos (nombre, categoria, precio, stock, proveedor_id) VALUES 
  ('Laptop Dell', 'Laptops', 800.00, 20, 1),
  ('Teléfono Samsung', 'Smartphones', 500.00, 10, 2),
  ('Mouse inalámbrico', 'Accesorios', 25.00, 50, 3);

-- Insertar clientes
INSERT INTO clientes (nombre, correo, telefono) VALUES 
  ('Juan Pérez', 'juan@mail.com', '123456789'),
  ('María Gómez', 'maria@mail.com', '987654321'),
  ('Carlos Ruiz', 'carlos@mail.com', '456123789');

-- Insertar ventas
INSERT INTO ventas (cliente_id, fecha) VALUES 
  (1, '2025-09-01'),
  (2, '2025-09-02');

-- Insertar detalles de ventas
INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario) VALUES
  (1, 1, 1, 800.00),
  (2, 2, 2, 500.00);
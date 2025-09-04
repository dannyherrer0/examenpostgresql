SELECT nombre, stock 
FROM productos 
WHERE stock < 5;
--
SELECT EXTRACT(MONTH FROM fecha) AS mes, SUM(vd.producto_id * vd.cantidad) AS ventas_totales
FROM ventas v
JOIN ventas_detalle vd ON v.id = vd.venta_id
JOIN productos p ON vd.producto_id = p.id
WHERE EXTRACT(MONTH FROM fecha) = 9
GROUP BY mes;
--
SELECT c.nombre, COUNT(v.id) AS cantidad_compras
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id
ORDER BY cantidad_compras DESC LIMIT 1;
SELECT p.nombre, SUM(vd.cantidad) AS cantidad_vendida
FROM ventas_detalle vd
JOIN productos p ON vd.producto_id = p.id
GROUP BY p.id
ORDER BY cantidad_vendida DESC
LIMIT 5;
-- Menor de 5 unidades 
-- Tres días
SELECT * 
FROM ventas 
WHERE fecha BETWEEN '2025-08-25' AND '2025-08-28';

-- Un mes
SELECT * 
FROM ventas 
WHERE fecha BETWEEN '2025-08-01' AND '2025-08-31';
SELECT nombre, correo
FROM clientes c
WHERE NOT EXISTS (
  SELECT 1 
  FROM ventas v 
  WHERE v.cliente_id = c.id AND v.fecha > CURRENT_DATE - INTERVAL '6 months'
);
CREATE OR REPLACE PROCEDURE registrar_venta(
  cliente_id INT,
  productos JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
  producto_record JSONB;
  stock_actual INT;
BEGIN
  -- Verificar que el cliente exista
  IF NOT EXISTS (SELECT 1 FROM clientes WHERE id = cliente_id) THEN
    RAISE EXCEPTION 'Cliente no existe';
  END IF;
  
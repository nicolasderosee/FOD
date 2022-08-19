//• Existe un archivo maestro.
//• Existe un único archivo detalle que modifica al maestro.
//• Cada registro del detalle modifica a un registro del maestro.
//Esto significa que solamente aparecerán datos en el detalle que se correspondan con datos del maestro. Se descarta la posibilidad de
//generar altas en ese archivo.
//• No todos los registros del maestro son necesariamente modificados.
//• Cada elemento del maestro que se modifica es alterado POR UNO Y
//SOLO UN elemento del archivo detalle.
//• Ambos archivos están ordenados por igual criterio.

program ejemplo1;
type
  producto = record
    cod: str4;
    descripcion: string[30];
    pu: real;
    stock: integer;
  end;
  venta_prod = record
    cod: str4;
    cant_vendida: integer;
  end;
  detalle = file of venta_prod;
  maestro = file of producto;

var
  regm: producto;
  regd: venta_prod;
  mae1: maestro;
  det1: detalle;

begin
  assign (mae1, ‘maestro’);
  assign (det1, ‘detalle’);
  reset (mae1);
  reset (det1);
  while (not eof(det1)) do begin
      read(mae1,regm);
      read(det1,regd);
     {se busca en el maestro el producto del detalle}
      while (regm.cod <> regd.cod) do
          read (mae1,regm);
     {se modifica el stock del producto con la cantidad vendida de ese producto}
      regm.stock := regm.stock — regd.cant_vendida;
     {se reubica el puntero en el maestro}
      seek (mae1, filepos(mae1)—1);
     {se actualiza el maestro}
      write(mae1,regm);
  end;
  close(det1);
  close(mae1);
end

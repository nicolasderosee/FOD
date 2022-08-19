//Existe un archivo maestro.
//• Existe un único archivo detalle que modifica al maestro.
//• Cada registro del detalle modifica a un registro del maestro. Esto significa que solamente aparecerán datos en el detalle que se correspondan con
//datos del maestro. Se descarta la posibilidad de generar altas en el maestro.
//• Cada elemento del archivo maestro puede no ser modificado, o ser modificado por uno o más elementos del detalle.
//• Ambos archivos están ordenados por igual criterio. Esta precondición, considerada muy fuerte, se debe a que hasta el momento se manipulan archivos de datos de acuerdo con su orden físico.

program ejemplo_3_3;
const valoralto=’9999’;
type
   str4 = string[4];
   producto = record
      cod: str4;
      descripcion: string[30];
      pu: real;
      cant: integer;
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
   total: integer;
   aux: str4;

procedure leer (var archivo:detalle; var dato:venta_prod);
begin
   if (not eof(archivo)) then read (archivo,dato)
   else dato.cod:= valoralto;
end;

{programa principal}
begin
   assign (mae1, ‘maestro’);
   assign (det1, ‘detalle’);
   reset (mae1);
   reset (det1);
   read(mae1,regm);
   leer(det1,regd);
   {se procesan todos los registros del archivo detalle}
   while (regd.cod <> valoralto) do begin
        aux := regd.cod;
        total := 0;
        {se totaliza la cantidad vendida de productos iguales en el archivo de detalle}
        while (aux = regd.cod) do begin
              total := total + regd.cant_vendida;
              leer(det1,regd);
        end;
       {se busca en el maestro el producto del detalle}
        while (regm.cod <> aux) do
            read (mae1,regm);
        regm.cant := regm.cant — total; {se modifica el stock del producto con la cantidad total vendida de ese producto}
        {se reubica el puntero en el maestro}
        seek (mae1, filepos(mae1)—1);
        {se actualiza el maestro}
        write(mae1,regm);
       {se avanza en el maestro}
       if (not eof (mae1)) then
           read(mae1,regm);
   end;
   close (det1);
   close (mae1);
end.

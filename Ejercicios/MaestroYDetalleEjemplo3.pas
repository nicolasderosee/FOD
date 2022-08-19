//Existe un archivo maestro.
//� Existen 3 archivos detalle que modifican al maestro.
//� Cada registro del detalle modifica a un registro del maestro. Esto
//significa que solamente aparecer�n datos en el detalle que se correspondan con datos del maestro. Se descarta la posibilidad de generar altas en el maestro.
//� Cada elemento del archivo maestro puede no ser modificado, o ser modificado por uno o m�s elementos del detalle.
//� Ambos archivos est�n ordenados por igual criterio.
//El objetivo del procedimiento minimo es determinar el menor de los tres elementos recibidos de cada archivo (para poder retornarlo como el m�s peque�o)
//y leer otro registro del archivo desde donde proven�a ese elemento.

program ejemplo3;;
const valoralto=�9999�;
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
  min, regd1, regd2,regd3: venta_prod;
  mae1: maestro;
  det1,det2,det3: detalle;
  aux: str4;
  total_vendido:integer;

procedure leer (var archivo:detalle; var dato:venta_prod);
begin
 if (not eof(archivo))then read (archivo,dato)
 else dato.cod:= valoralto;
end;

procedure minimo (var r1,r2,r3,min:venta_prod);
begin
 if (r1.cod<=r2.cod) and (r1.cod<=r3.cod)then begin
     min := r1;
     leer(det1,r1);
 end
 else
    if (r2.cod<=r3.cod)then begin
       min := r2;
       leer(det2,r2);
    end
    else begin
       min := r3;
       leer(det3,r3);
    end;
end;

begin
 assign (mae1, �maestro�);
 assign (det1, �detalle1�);
 assign (det2, �detalle2�);
 assign (det3, �detalle3�);
 reset (mae1);
 reset (det1);
 reset (det2);
 reset (det3);
 read(mae1,regm);
 leer(det1, regd1);
 leer(det2, regd2);
 leer(det3, regd3);
 minimo(regd1,regd2,regd3,min);
{se procesan todos los registros de los archivos detalle}
 while (min.cod <> valoralto) do begin
{se totaliza la cantidad vendida de productos iguales en el archivo de detalle}
    aux := min.cod;
    total_vendido := 0
    while (aux = min.cod ) do begin
       total_vendido := total_vendido + min.cantvendida;
       minimo(regd1,regd2,regd3,min);
    end;
{se busca en el maestro el producto del detalle}
    while (regm.cod <> min.cod) do
       read(mae1,regm);
{se modifica el stock del producto con la cantidad total vendida de ese producto}
    regm.cant := regm.cant � total;
{se reubica el puntero en el maestro}
    seek (mae1, filepos(mae1)-1);
{se actualiza el maestro}
    write(mae1,regm);
{se avanza en el maestro}
    if (not eof (mae1)) then read(mae1,regm);
 end;
 close (det1);
 close (det2);
 close (det3);
 close (mae1);
end

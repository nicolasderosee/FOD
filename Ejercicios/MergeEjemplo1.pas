//Se tiene informaci�n en tres archivos detalle.
//� Esta informaci�n se encuentra ordenada por el mismo criterio en cada caso.
//� La informaci�n es disjunta; esto significa que un elemento puede aparecer una sola oportunidad en todo el problema.
//Si el elemento 1 est� en el archivo detalle1, solo puede aparecer una vez en este y no podr� estar en el resto de los archivos.

program ejemplo1;
const valoralto=�9999�;
type
    str4 = string[4];
    producto = record
       codigo: str4;
       descripcion: string[30];
       pu: real;
       cant: integer;
    end;
    detalle = file of producto;
var
 min, regd1, regd2,regd3: producto;
 det1, det2, det3, mae1: detalle;

procedure leer (var archivo:detalle; var dato:producto);
begin
   if (not eof(archivo)) then read (archivo,dato)
   else dato.codigo:= valoralto;
end;

procedure minimo (var r1,r2,r3,min:producto);
begin
 if (r1.codigo<=r2.codigo) and (r1.codigo<=r3.codigo) then begin
     min := r1; leer(det1,r1);
 end
 else
    if (r2.cod<=r3.cod) then begin
        min := r2; leer(det2,r2);
    end
    else begin
        min := r3; leer(det3,r3)
    end;
end;

{programa principal}
begin
 assign (mae1, �maestro�);
 assign (det1, �detalle1�);
 assign (det2, �detalle2�);
 assign (det3, �detalle3�);
 rewrite (mae1);
 reset (det1);
 reset (det2);
 reset (det3);
 leer(det1, regd1);
 leer(det2, regd2);
 leer(det3, regd3);
 minimo(regd1,regd2,regd3,min);
 {se procesan todos los registros de los archivos detalle}
 while (min.codigo <> valoralto) do begin
      write(mae1, min);
      minimo(regd1,regd2,regd3,min);
 end;
 close (det1);
 close (det2);
 close (det3);
 close (mae1);
end.

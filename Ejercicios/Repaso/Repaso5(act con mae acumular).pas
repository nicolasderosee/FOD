Program repaso5;
const
  valorAlto=9999; cant=15;
type
  rango = 1..cant;
  cadena = string[15];
  articulos = record
     cod:integer;
     nom:cadena;
     desc:cadena;
     precio:real;
     talle:integer;
     color:cadena;
     stock:integer;
     stockMin:integer;
  end;
  art = record
     cod:integer;
     cantVendi:integer;
  end;
  maestro = file of articulos;
  detalle = file of art;

  vecDetalles = array [1..cant] of detalle;
  vecRegistros = array [1..cant] of art;

Procedure leerDetalle (var arch:detalle; var dato:art);
begin
   if (not eof(arch)) then read (arch, dato)
   else dato.cod := valorAlto;
end;

Procedure leerMaestro (var arch:maestro; var dato:articulos);
begin
   if (not eof(arch)) then read (arch, dato)
   else dato.cod := valorAlto;
end;

Procedure minimo (var vd:vecDetalles; var vr:vecRegistros; var min:art);
var i,minPos: rango;
begin
      min.cod:= valorAlto;
      for i:= 1 to cant do begin
         if(vr[i].cod < min.cod) then begin
              min:= vr[i];
              minPos:=i;
         end;
      end;
      leerDetalle(vd[minPos], vr[minPos]);  //leo el siguiente registro del detalle que tuvo el codigo minimo y el puntero queda en el otro registro siguiente
end;


Procedure actualizar (var mae:maestro; var vd:vecDetalles; var vr:vecRegistros; var t:text);
var i:rango; regm:articulos; min:art; total,aux:integer;
begin
  reset(mae); leerMaestro(mae,regm);
  rewrite(t);
  for i:= 1 to cant do begin
     leerDetalle(vd[i], vr[i]);
     reset(vd[i]);
  end;
  minimo(vd,vr,min);
  while(regm.cod <> valorAlto) do begin
     aux:= min.cod;
     total:= 0;

     while(regm.cod <> min.cod) do
        leerMaestro(mae,regm);

     while(aux = min.cod) and (regm.cod <> valorAlto) do begin
          total := total + min.cantVendi;
          minimo(vd,vr,min);
     end;

     regm.stock := regm.stock - total;
     seek(mae,filepos(mae)-1);
     write(mae,regm);
     if(regm.stock < regm.stockMin) then begin
        with regm do begin
                 writeln(t,'  ',stock,'   ',precio:3:2,'   ',desc);  //se escribe en un archivo de texto
                 writeln(t, '   ',nom);
        end;
    end;
    leerMaestro(mae,regm); {se avanza en el maestro}
 end;
 writeln('listado con exito en "informe.txt".');
 close (mae); close(t);
 for i:= 1 to cant do begin
     close(vd[i]);
 end;
end;

Var
  mae:maestro;
  vd:vecDetalles;
  vr:vecRegistros;
  i:rango; t:text;

Begin
  assign(mae,'maestro');
  assign (t,'informe.txt');
  for i:= 1 to cant do begin
    assign(vd[i], 'detalle' + intToStr(i));
  end;
  actualizar(mae,vd,vr,t);
End.

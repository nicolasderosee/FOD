//actualización maestro con N detalles (uso el minimo). El archivo maestro existe y debe ser actualizado por los 30 detalles.
//Cada elemento del detalle puede o no modificar a un determinado producto del maestro (recorro a partir de detalles y acumulo).
//Todos los archivos estan ordenados por codigo de producto.

Program repaso1;
const valorAlto = 9999; cant = 30;

type
   rango = 1..cant;
   producto = record
       codProd:integer;
       nom:string[12];
       desc:string[12];
       stock:integer;
       stockMin:integer;
       precio:real;
   end;
   produ = record
       codProd:integer;
       cantVendi:integer;
   end;
   maestro = file of producto;
   detalle = file of produ;

   vecDetalles = array [rango] of detalle; //arreglo con archivos logicos
   vecRegistros = array [rango] of produ; //arreglo con registros de cada archivo logico


Procedure leerDetalle(var arch:detalle; var dato:produ);
begin
    if not eof(arch) then read(arch,dato)
    else dato.codProd:= valorAlto;
end;


Procedure minimo(var vd:vecDetalles; var vr:vecRegistros; var min:produ);
var i, posMin:rango;
begin
   min.codProd:= valorAlto;
   for i:= 1 to cant do begin
      if(vr[i].codProd <= min.codProd) then begin
         min:= vr[i];
         posMin:= i;
      end;
   end;
   leerDetalle(vd[posMin], vr[posMin]);
end;

Procedure actualizar (var mae:maestro; var vd:vecDetalles; var vr:vecRegistros; var t:text);
var
  regm:producto; min:produ; i:rango; aux,total:integer;
begin
  reset(mae); rewrite(t);
  read(mae,regm);
  for i:= 1 to cant do begin
    reset(vd[i]);
    leerDetalle(vd[i],vr[i]);
  end;
  minimo(vd,vr,min); //busco el minimo de todos los registros de cada archivo detalle

  while (min.codProd <> valorAlto) do begin

     while(regm.codProd <> min.codProd) do
        read(mae,regm);

     aux:= min.codProd;
     total:= 0;

     while(aux = min.codProd) do begin
          total := total + min.cantVendi;  //se totaliza la cantidad vendida de productos iguales en el archivo detalle
          minimo(vd,vr,min);
     end;

    regm.stock:= regm.stock - total;
    seek(mae, filepos(mae)-1);
    write(mae, regm);

    if(regm.stock < regm.stockMin) then begin
        with regm do begin
                 writeln(t,'  ',stock,'   ',precio,'   ',nom);
                 writeln(t, '   ',desc);
        end;
    end;
    if (not eof (mae)) then read(mae,regm);
  end;
  writeln('');
  writeln('listado con exito en "informe.txt".');
  close(mae);
  for i:= 1 to cant do begin
     close(vd[i]);
  end;
end;

var
 mae:maestro;
 vd: vecDetalles; vr:vecRegistros;
 t:text;
 i:rango;

begin
 assign (mae, 'Maestro');
 assign (t, 'informe.txt');
 for i:= 1 to cant do begin
    assign(vd[i],'detalle' + intToStr(i));
 end;
 actualizar(mae, vd, vr,t);
end.

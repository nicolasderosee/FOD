//Se dispone de un archivo de empleados donde figura el empleado “Carlos García”.
//Baja Fisica quitando del archivo al empleado sin generar otro archivo
program ejemplo2;
const valoralto=”ZZZ”;
type
  empleado = record;
    Nombre : string[50];
    Direccion : string[50];
    Documento : string[12];
    Edad : integer;
    Observaciones: string[200];
  end;
  archivoemple = file of Empleado;
var
 reg: empleado;
 archivo: archivoemple;

procedure leer (var archivo: archivoemple; var dato:empleado);
begin
  if (not eof(archivo)) then read (archivo,dato)
  else dato.Nombre := valoralto;
end;

{programa principal}
begin
 assign (archivo, 'archemple');
 reset(archivo);
 leer(archivo,reg);
{se avanza hasta Carlos Garcia}
 while (reg.Nombre<>'Carlos Garcia')do begin
    leer(archivo,reg);
 end;
{se avanza hasta el siguiente a Carlos Garcia}
 leer(archivo,reg);
{se copian los registros restantes}
 while (reg.Nombre<>valoralto) do begin //mientras no llegue al fin del archivo hago un corrimiento hacia adelante
     Seek(archivo, filepos(archivo)—2);
     write(archivo,reg); //copia sobre el registro carlos garcia el elemento siguiente y así sucesivamente, repitiendo esta operatoria hasta el final del archivo.
     Seek(archivo, filepos(archivo)+1);
     leer(archivo,reg);
 end;
 truncate(archivo); //coloca la marca de fin en el lugar indicado por el puntero del archivo en ese momento, quitándose todo lo que hubiera desde esa posición en adelante.
end.

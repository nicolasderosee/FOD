//Se dispone de un archivo de empleados donde figura el empleado “Carlos García”.
//Baja Fisica - este algoritmo elegido consiste en recorrer el archivo original de datos, copiando al nuevo archivo toda la información,
//menos la correspondiente al elemento que se desea quitar.
program ejemplo1;
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
 archivo, archivonuevo: archivoemple;

procedure leer (var archivo: archivoemple; var dato:empleado);
begin
  if (not eof(archivo)) then read (archivo,dato)
  else dato.Nombre := valoralto;
end;

{programa principal}
begin
 assign (archivo, 'archemple');
 assign (archivonuevo, 'archnuevo');
 reset(archivo);
 rewrite(archivonuevo);
 leer(archivo,reg)
{se copian los registros previos a Carlos Garcia}
 while (reg.Nombre<>”Carlos Garcia”) do begin //mientras no sea carlos garcia, guardo la info en el archivo nuevo
       write(archivonuevo,reg)
       leer(archivo,reg)
 end;
{se descarta a Carlos Garcia}
 leer(archivo,reg)
{se copian los registros restantes}
 while (reg.Nombre<>valoralto) do begin
       write(archivonuevo,reg)
       leer(archivo,reg)
 end;
 close(archivonuevo);
 close(archivo);
end.

//recorrido de un archivo con borrado logico aplicado

program ejemplo4;
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
 while (reg.Nombre<>valoralto)do begin
    if (reg.Nombre<>’***’)then
       write(‘El nombre de es:’+reg.Nombre)
    leer(archivo,reg);
 end;
 close(archivo);
end.

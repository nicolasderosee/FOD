//Se dispone de un archivo de empleados donde figura el empleado “Carlos García”
//Borrado logico - para ocultar la existencia de uno o varios registros
program ejemplo3;
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
 assign (archivo, ‘archemple’);
 reset(archivo);
 leer(archivo,reg);
 {se avanza hasta Carlos Garcia}
 while (reg.Nombre<>'Carlos Garcia')do begin
     leer(archivo,reg);
 end;
 {se genera una marca de borrado}
 reg.nombre := ”***”
 {se borra lógicamente a Carlos Garcia}
 Seek( archivo, filepos(archivo)-1 );
 write(archivo,reg);
 close(archivo);
end.

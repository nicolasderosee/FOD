Program Ejercicio2P3;
const valoralto = 9999;
type
  str25 = string[25];
  empleado = record
      cod:integer;
      apeynom:str25;
      dire:str25;
      tel:integer;
      dni:integer;
      fechaN:integer;
  end;
  archivo = file of empleado;

Procedure leerEmpleado(var e:empleado);
begin
  writeln('Ingrese el codigo del empleado');
  readln(e.cod);
  if (e.cod<>valoralto) then begin
    writeln('Ingrese el nombre y apellido del empleado');
    readln(e.apeynom);
    writeln('Ingrese la direccion del empleado');
    readln(e.dire);
    writeln('Ingrese el telefono del empleado');
    readln(e.tel);
    writeln('Ingrese el dni del empleado');
    readln(e.dni);
    writeln('Ingrese la fecha de nacimiento del empleado');
    readln(e.fechaN);
   end;
end;

procedure leer (var arch: archivo; var dato:empleado);
begin
 if (not eof(arch)) then read (arch,dato)
 else dato.cod := valoralto;
end;

Procedure crearArchivo(var arc_logico:archivo);
var e:empleado;
begin
    rewrite(arc_logico);
    leerEmpleado(e);
    while (e.cod <> valoralto) do begin
       write(arc_logico, e);
       leerEmpleado(e);
    end;
    close(arc_logico);
end;

Procedure bajaLogica(var arch:archivo);
var reg:empleado;
begin
 reset(arch);
 leer(arch,reg);
 while (reg.cod <> valoralto) do begin  //mientras no sea eof
     if(reg.dni < 8000000) then begin //si el dni es menor a 8 millones, borro el empleado
        reg.apeynom:= '***'; //se genera la marca de borrado
        seek(arch, filepos(arch)-1 ); //me posiciono sobre el registro que se tiene que borrar
        write(arch,reg); //actualizo el registro para que quede borrado logicamente
      end;
      leer(arch,reg);//leo otro empleado
 end;
 close(arch);
end;


var arc_logico: archivo;
    arc_fisico: string[50];

Begin
  write('Ingrese el nombre del archivo:' );
  read(arc_fisico);
  assign(arc_logico, arc_fisico);
  crearArchivo(arc_logico);
  bajaLogica(arc_logico);
  readln();
End.

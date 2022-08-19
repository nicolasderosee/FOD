Program repaso9;
const valorAlto = 9999;
type
  jugador = record
     dni:integer;
     nom:string;
     ap:string;
     pais_nacimiento:string;
  end;

  archivo = file of jugador;

procedure leer(var arch:archivo; var dato:jugador);
begin
  if not eof(arch) then read(arch,dato)
  else dato.dni := valorAlto;
end;

procedure borrarJugador(var arch:archivo; dni:integer);
var reg,cabecera:jugador;
begin
  reset(arch);
  leer(arch,reg);
  cabecera:= reg;
  while(reg.dni <> dni) and (reg.dni <> valorAlto) do begin //uso el valorAlto porque puede pasar que lo que estoy buscando para borrar no exista
      leer(arch,reg);
  end;
  if(reg.dni <> valorAlto) then begin
     seek(arch,filepos(arch)-1);
     reg.dni := (filepos(arch)*-1);
     write(arch,cabecera);
     seek(arch,0);
     write(arch,reg);
  end
  else writeln('no existe el jugador en el archivo');
  close(arch);
end;

procedure agregarJugador(var arch:archivo; nuevojugador:jugador);
var reg:jugador;
begin
  reset(arch);
  read(arch,reg);
  if(reg.dni < 0) then begin //si el dni es negativo, es un enlace que me marca una posicion para reutilizar espacio
     seek(arch,reg.dni*-1);
     leer(arch,reg);
     seek(arch,filepos(arch)-1);
     write(arch,nuevojugador);
     seek(arch,0);
     write(arch,reg);
  end
  else begin
     seek(arch,filesize(arch));
     write(arch,nuevojugador);
  end;
  close(arch);
end;

var
  arch:archivo;
  dni:integer;
  nuevo:jugador;

Begin
  assign(arch,'archivo');
  writeln('ingrese el dni del jugador que desea borrar:');
  readln(dni);
  borrarJugador(arch,dni);
  writeln('ingrese el dni de un nuevo jugador que desea agregar:');
  readln(nuevo.dni);
  agregarJugador(arch,nuevo);
End.

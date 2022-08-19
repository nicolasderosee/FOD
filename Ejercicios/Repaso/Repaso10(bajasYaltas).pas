Program repaso10;
const valorAlto = 'zzz';
type
    cadena = string[15];
    distribucion = record
       nom:cadena;
       anio:integer;
       numV:integer;
       cantD:integer;
       desc:cadena;
    end;

    archivo = file of distribucion;

Procedure leer(var arch:archivo; var dato:distribucion);
begin
  if not eof(arch) then read(arch,dato)
  else dato.nom:= valorAlto;
end;

Procedure leerDistribucion(var d:distribucion);
begin
  writeln('ingrese nombre');
  readln(d.nom);
  if(d.nom <> valorAlto) then begin
     writeln('ingrese anio de lanzamiento');
     readln(d.anio);
     writeln('ingrese numero de kernel');
     readln(d.numV);
     writeln('ingrese cantidad de desarrolladores');
     readln(d.cantD);
     writeln('ingrese descripcion:');
     readln(d.desc);
  end;
end;


Procedure ExisteDistribucion(var arch:archivo; nom:cadena; var nrr:integer);
var d:distribucion;
begin
  reset(arch);
  nrr:= 0;
  leer(arch,d);
  while(d.nom <> valorAlto) and (d.nom <> nom) do
     leer(arch,d);
  if(d.nom = nom) then begin
     seek(arch,filepos(arch)-1);
     nrr:= filepos(arch);  // o se puede asignar directamente sin posicionar nrr:= filepos(arch)-1;
  end;
  close(arch);
end;

Procedure AltaDistribucion(var arch:archivo);
var cabecera,d:distribucion; nrr:integer;
begin
   writeln('ingrese nueva distribucion:');
   leerDistribucion(d);
   ExisteDistribucion(arch,d.nom,nrr);
   if(nrr = 0) then begin
     reset(arch);
     if(not(eof)) then begin
        read(arch,cabecera);
        if(cabecera.cantD < 0) then begin
           nrr:= cabecera.cantD * (-1);
           seek(arch,nrr);
           read(arch,cabecera);
           seek(arch,filepos(arch)-1);
           write(arch,d);
           seek(arch,0);
           write(arch,cabecera);
        end
        else begin
          seek(arch, filesize(arch));
          write(arch,d);
        end;
     end;
     close(arch);
  end
  else writeln('ya existe la distribucion');
end;

Procedure BajaDistribucion(var arch:archivo);
var nom:cadena;cabecera:distribucion; nrr:integer;
begin
   writeln('ingrese el nombre de la distribucion a borrar:');
   readln(nom);
   ExisteDistribucion(arch,nom,nrr);
   if(nrr > 0) then begin
      reset(arch);
      read(arch,cabecera);

      seek(arch,nrr);
      nrr:= filepos(arch) * -1;
      write(arch,cabecera);

      seek(arch,0);
      cabecera.cantD:= nrr;
      write(arch,cabecera);
      close(arch);
   end
   else
     if(nrr = 0) then
       writeln('distribucion inexistente');
end;


var arch:archivo;

begin
   assign (arch,'unArchivo');
   AltaDistribucion(arch);
   BajaDistribucion(arch);
end.







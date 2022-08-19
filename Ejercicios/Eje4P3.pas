program ejercicio4Y5P3;
type
	tTitulo = String[50];
    tArchRevistas = file of tTitulo ;

procedure crearArchivo(var arc:tArchRevistas);
var revista:tTitulo;
begin
    rewrite(arc);
    revista:='0'; //pongo la cabera en 0 para indicar que no hay registros borrados
    write(arc,revista);
    writeln('Ingrese el nombre de la revista');
    readln(revista);
    while(revista<>'') do begin
	   write(arc,revista);
	   writeln('Ingrese el nombre de la revista');
	   readln(revista);
    end;
    close(arc);
end;

procedure eliminar(var arch:tArchRevistas; titulo:string);
 var
   reg:tTitulo;
   pos:integer;
   inicio:tTitulo;
   ok:boolean;
 begin
   reset(arch);
   ok:=true; //para saber si lo encontre
   read(arch,reg);
   while(not EOF(arch)) and ok do begin
     if (reg = titulo) then begin
       pos:=filePos(arch)-1; //me guardo la pos del registro que se quiere borrar
       seek(arch,0);//me posiciono sobre la cabecera
       read(arch,inicio); //leo el registro de la cabecera
       seek(arch,pos); //me posiciono sobre donde se quiere borrar
       write(arch,inicio); //escribo en dicha pos el registro que estaba en la cabecera
       seek(arch,0); //me posiciono en la cabecera
       pos:=pos*(-1); //modifico pos para que quede marcado
       Str(pos,reg); //convierto de numero a cadena y lo guardo en reg
       write(arch,reg); //actualizo la cabecera
       ok:=false;
     end
     else
       read(arch,reg); //leo otro registro
   end;
   if (ok=false) then
     writeln('Operacion realizada con exito')
   else
     writeln('no se encontro la revista');
   close(arch);
 end;

procedure agregar(var arch:tArchRevistas; titulo:tTitulo);
var
  reg:tTitulo;
  aux:tTitulo;
  num:integer;
  c:integer;
begin
    reset(arch); //abro el archivo
    read(arch,reg); //leo un registro del archivo
    if (reg<>'0') then begin //si es distinto de 0 significa que hay registros borrados y puedo reutilizar espacio
	    Val(reg,num,c); //convierte el string de reg a un numero y lo guarda en num. c sirve para ver si la conversión fue exitosa
	    num:=Abs(num); //calcula el valor absoluto de num para que sea una pos valida
	    seek(arch,num); //me posiciono sobre el registro que se indico en la cabecera (registro eliminado)
	    read(arch,aux); //me guardo el registro de dicha pos en aux
	    seek(arch,filePos(arch)-1); //vuelvo a la pos porque se movio automaticamente cuando se hizo el read
	    write(arch,titulo); //escribo en la pos el nuevo titulo recibido por parametro
	    seek(arch,0); //me posiciono sobre la cabecera
	    write(arch,aux); //guardo en la cabecera el registro anterior
    end
    else begin
	    seek(arch,filesize(arch)-1); //me posiciono al final del archivo
	    write(arch,titulo); //lo escribo al final
	    writeln('Se agrego al final del archivo');
    end;
    close(arch);
end;


procedure listado(var archivo:tArchRevistas);
var reg:tTitulo;
begin
   reset(archivo);
   while(not EOF(archivo)) do begin
	    read(archivo,reg);
	    if (reg > '0') then //ignoro los negativos
	      writeln('Titulo: ',reg);
   end;
   close(archivo);
end;

var
  archivo:tArchRevistas;
  n:integer;
  revista:tTitulo;
  nombre:tTitulo;
begin
	assign(archivo,'unArchivo');
	crearArchivo(archivo);
	writeln('Ingrese 1 para dar de baja una revista del archivo');
	writeln('Ingrese 2 para agregar una nueva revista ya sea en un espacio libre o al final si no lo hay');
	writeln('Ingrese 3 para mostrar en pantalla las revistas, omitiendo las eliminadas');
	writeln('Ingrese 0 para salir');
	readln(n);
	while (n<>0) do begin
	  if (n=1) then begin
         writeln('Ingrese el nombre de la revista a eliminar:');
         readln(nombre);
         eliminar(archivo,nombre);
      end
	  else begin
	    if (n=2) then begin
          writeln('Ingrese el titulo de la revista');
          readln(revista);
	      agregar(archivo,revista);
        end
        else begin
          if (n=3) then
             listado(archivo);
        end;
      end;
      writeln('Ingrese 1 para dar de baja una revista del archivo');
      writeln('Ingrese 2 para agregar una nueva revista ya sea en un espacio libre o al final si no lo hay');
      writeln('Ingrese 3 para mostrar en pantalla las revistas, omitiendo las eliminadas');
      writeln('Ingrese 0 para salir');
      readln(n);
    end;
    readln();
end.

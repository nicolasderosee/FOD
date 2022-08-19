Program Ejercicio3P3;
const valoralto = 9999;
type
  novela=record
	 cod:integer;
     genero:String;
	 nombre:String;
	 duracion:integer;
	 director:String;
	 precio:integer;
   end;
   archivo = file of novela;

procedure leerNovela(var nov:novela);
begin
   writeln('Ingrese el codigo de la novela');
   readln(nov.cod);
   if (nov.cod<>valoralto) then begin
     writeln('Ingrese el genero de la novela');
     readln(nov.genero);
     writeln('Ingrese el nombre de la novela');
     readln(nov.nombre);
     writeln('Ingrese la duracion de la novela');
     readln(nov.duracion);
     writeln('Ingrese el nombre del director de la novela');
     readln(nov.director);
     writeln('Ingrese el precio de la novela');
     readln(nov.precio);
   end;
end;


Procedure crearArchivo(var arc_logico:archivo);
var n:novela;
begin
    rewrite(arc_logico); //creo el archivo
    n.cod:= 0; //inicializo el registro cabecera
    write(arc_logico,n); //agrego al archivo el registro cabecera
    leerNovela(n); //leo la primer novela
    while (n.cod <> valoralto) do begin
       write(arc_logico, n);  //escribo novelas
       leerNovela(n);
    end;
    close(arc_logico);
end;


procedure DarAlta(var arch: archivo); //preguntar si esta bien
var nuevoR,reg,regAux: novela;
begin
  reset(arch);
  read(arch, reg);
  leerNovela(nuevoR); //leo una nueva novela
  if (reg.cod <> 0) then begin //si la cabecera no es 0, hay espacio libre
     seek(arch, reg.cod * -1); //me ubico en la pos indiciada por la cabecera. Le multiplico -1 para convertir la marca a pos valida -5*-1 = 5
     read(arch, regAux);//leo el registro de dicha pos y el puntero avanza uno automaticamente
     seek(arch, filepos(arch) - 1); //le resto uno para poder volver a la pos donde se quiere dar la alta
     write(arch, nuevoR); //escribo en dicha pos el nuevo registro
     seek(arch, 0); //me pos sobre la cabecera
     write(arch, regAux); //copio el registro que estaba en la pos donde se hizo el alta, en la cabecera
  end
  else begin //si es 0 entonces no hay espacio para reutilizar y se agrega al final del archivo
     seek(arch, filesize(arch)); //me pos al final
     write(arch, nuevoR); //agrego el nuevo registro a mi archivo
  end;
  close(arch);
end;

Procedure modificarDatos(var arc:archivo); //Preguntar
var
   reg:novela;
   cod:integer;
   ok:boolean;
begin
   reset(arc);
   ok:=true;
   writeln('Ingrese el codigo de la novela que quiera modificar');
   readln(cod);
   while(not EOF(arc)) and ok do begin
     read(arc,reg);
     if (reg.cod=cod) then begin
       writeln('Ingrese el nuevo genero de la novela');
       readln(reg.genero);
       writeln('Ingrese el nuevo nombre de la novela');
       readln(reg.nombre);
       writeln('Ingrese la nueva duracion de la novela');
       readln(reg.duracion);
       writeln('Ingrese el nuevo nombre del director de la novela');
       readln(reg.director);
       writeln('Ingrese el nuevo precio de la novela');
       readln(reg.precio);
       seek(arc,filePos(arc)-1);
       write(arc,reg);
       ok:=false;
     end;
   end;
   if (ok=false) then
     writeln('Se modifico la novela pedida')
   else
     writeln('No se encontro la novela');
   close(arc);
end;

Procedure eliminar(var arc:archivo); //preguntar
var
  cod:integer;
  reg:novela; regCabecera:novela;
  ok:boolean;
begin
	  reset(arc);  //abro el archivo existente
	  ok:=true;//para saber si lo pude eliminar
	  writeln('Ingrese el codigo de la novela que quiera eliminar');
	  readln(cod);
	  while(not EOF(arc)) and ok do begin //mientras no llegue al final del archivo y no encontre
	    read(arc,reg); //leo un registro del archivo
	    if (reg.cod=cod) then begin
	      seek(arc,0); //me posiciono en el registro cabecera
	      read(arc,regCabecera); //leo el reg cabecera
	      seek(arc,reg.cod); //me posiciono sobre el registro que se quiere eliminar
	      write(arc,regCabecera);//escribo en la posicion de donde de quiere eliminar, lo que tenia en la cabecera
	      reg.cod:=-reg.cod; //lo convierto a negativo para que sea la marca de la cabecera
	      seek(arc,0); //me posiciono en la cabecera
	      write(arc,reg);//actualizo  la cabecera
	      ok:=false;
	    end;
	  end;
	  if (ok=false) then
         writeln('Se elimino la novela pedida')
      else
         writeln('No se encontro la novela');
      close(arc);
    end;

Procedure abrirArchivo(var arc:archivo);
var num:integer;
begin
   repeat
     writeln('Ingrese 1 si quiere dar de alta una novela');
     writeln('Ingresa 2 para modificar los datos de una novela');
     writeln('Ingrese 3 eliminar una novela');
     writeln('Ingrese 0 para salir');
     readln(num);
     if (num=1) then
       darAlta(arc)
       else begin
         if (num=2) then
           modificarDatos(arc)
         else begin
             if (num=3) then
               eliminar(arc)
         end;
       end; 
   until (num=0);
end;

procedure listar(var arc:archivo;var t:text);
var reg:novela;
begin
   reset(arc);
   rewrite(t);
   while(not EOF(arc)) do begin
     read(arc,reg);
     writeln(t,reg.cod,' ',reg.duracion,' ',reg.precio,' ',reg.nombre);
     writeln(t,reg.genero);
     writeln(t,reg.director);
   end;
   close(arc); close(t);
end;


var arc_logico: archivo;
    arc_fisico: string[50];
    t:text;
    nume:integer;

Begin
  write('Ingrese el nombre del archivo:' );
  read(arc_fisico);
  assign(arc_logico, arc_fisico);
  repeat
    writeln('Ingrese 1 para crear el archivo, 2 para abrirlo o 0 para salir');
    readln(nume);
    if (nume=1) then
       crearArchivo(arc_logico)
    else begin
       if (nume=2) then
         abrirArchivo(arc_logico);
    end;
  until(nume=0);
  listar(arc_logico,t);
  readln();
End.

program ejercicio6P3;
const valoralto = 9999;
type
	prenda=record
	  cod_prenda:integer;
	  descripcion:string;
	  colores:string;
	  tipo_prenda:string; 
	  stock:integer;
	  precio_unitario:integer;
    end;
	maestro=file of prenda;
	detalle=file of integer;


procedure leerPrenda(var p:prenda);
begin
  writeln('Ingrese el codigo de la prenda del maestro:');
  readln(p.cod_prenda);
  if (p.cod_prenda <> valoralto) then begin
     writeln('Ingrese la descripcion de la prenda:');
     readln(p.descripcion);
     writeln('Ingrese los colores de la prenda:');
     readln(p.colores);
     writeln('Ingrese el tipo de prenda:');
     readln(p.tipo_prenda);
     writeln('Ingrese el stock de la prenda:');
     readln(p.stock);
     writeln('Ingrese el precio de la prenda:');
     readln(p.precio_unitario);
  end;
end;

procedure crearArchivoM(var mae:maestro);
var p:prenda;
begin
   rewrite(mae);
   leerPrenda(p);
   while(p.cod_prenda <> valoralto) do begin
       write(mae,p);
       leerPrenda(p);
   end;
   close(mae);
end;

procedure crearArchivoD(var det:detalle);
var num:integer;
begin
  rewrite(det);
  writeln('Ingrese el codigo de la prenda del detalle');
  readln(num);
  while(num<>valoralto) do begin
    write(det,num);
    writeln('Ingrese el codigo de la prenda del detalle');
    readln(num);
  end;
  close(det);
end;

procedure leerD(var det:detalle;var regd:integer);
begin
  if(not EOF(det)) then read(det,regd)
  else regd:=valoralto;
end;

procedure bajaLogica(var mae:maestro; var det:detalle);
var regm:prenda; regd:integer;
begin
    reset(mae); //abro el maestro
    reset(det); //abro el detalle
    leerD(det,regd); //leo un registro del detalle
    while(regd<>valoralto) do begin //mientras no llegue al fin de archivo
       seek(mae,0); //me posiciono al inicio
       read(mae,regm); //leo un registro del maestro
       while (regm.cod_prenda<>regd) do //mientras no sean el mismo codigo, leo otro registro del maestro
          read(mae,regm);
       //es el mismo codigo
       regm.stock:=-1; //pongo el stock en -1 (marca) para indicar que el registro va a ser borrado
       seek(mae,filePos(mae)-1); //me posiciono correctamente
       write(mae,regm); //actualizo dicho registro con la marca
       leerD(det,regd); //leo otro registro del detalle
    end;
    close(mae);
    close(det);
end;

procedure compactar(var mae:maestro;var nuevoArchivo:maestro);
var regm:prenda;
begin
   reset(mae);
   rewrite(nuevoArchivo);
   while(not EOF(mae)) do begin
      read(mae,regm);
      if (regm.stock<>-1) then
          write(nuevoArchivo,regm);
   end;
   close(mae);
   close(nuevoArchivo);
end;

Var
  det:detalle;
  mae:maestro;
  nuevoArchivo:maestro;
  nombre:string[25];

Begin
    nombre:= 'mestro';
	assign(mae,nombre);
    assign(det,'detalle');
    assign(nuevoArchivo,'nuevoMaestro');
    crearArchivoM(mae);
    crearArchivoD(det);
	bajaLogica(mae,det);
	compactar(mae,nuevoArchivo);
	close(mae);
	erase(mae);
	close(nuevoArchivo);
	rename(nuevoArchivo,nombre);
    readln();
End.

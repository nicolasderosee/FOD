program ejercicio7P2;
const valoralto = 9999;
type
  str20 = String[21];
  producto=record
      cod:integer;
      nom:str20;
	  precio:integer;
	  stockA:integer;
	  stockMin:integer;
  end;
  venta=record
	  cod:integer;
	  cantVendida:integer;
  end;
  maestro=file of producto;
  detalle=file of venta;


Procedure leer (var archivo:detalle; var dato:venta);
begin
      if (not eof(archivo)) then read(archivo,dato)
      else dato.cod := valoralto;
end;

Procedure crearArchivoMaestro(var mae:maestro; var carga:text); //crea un archivo maestro a partir de un txt
var p:producto;
begin
    assign(carga,'productos.txt');
    reset(carga);
    rewrite(mae);
    while (not eof(carga)) do begin
       with p do
          readln(carga, cod, precio, stockA, StockMin, nom);
       write(mae, p);
    end;
    write('Archivo maestro cargado.');
    Readln;
    close(mae); close(carga);
end;

Procedure listarContenidoMaestro(var mae:maestro; var carga:text);
var p:producto;
begin
   assign(carga,'reporte.txt');
   rewrite(carga); //crea el archivo de texto
   reset(mae);
   while(not eof(mae)) do begin
       read(mae, p); //lee productos del archivo maestro
       with p do
          writeln(carga, '   ',cod,'   ',precio,'   ',stockA,'   ',stockMin,'   ',nom);
   end;
   writeln('');
   writeln('listado con exito en "reporte.txt".');
   close(mae); close(carga);
end;


Procedure crearArchivoDetalle(var det:detalle; var carga:text);
var v:venta;
begin
    assign(carga,'detalle.txt');
    reset(carga);
    rewrite(det);
    while (not eof(carga)) do begin
       with v do
          readln(carga, cod, cantVendida);
       write(det, v);
    end;
    write('Archivo detalle cargado.');
    Readln;
    close(det); close(carga);
end;


Procedure informarDetalle(var det:detalle);
var v:venta;
begin
  reset(det);
  while(not EOF(det)) do begin
      read(det,v);
      writeln('Codigo: ',v.cod);
	  writeln('Cantidad vendida: ',v.cantVendida);
  end;
  close(det);
end;

Procedure actualizar(var mae:maestro; var det:detalle);
var regm:producto; regd:venta; aux,total:integer;
begin
    reset(mae);  reset(det);
    read(mae,regm);
    leer(det,regd);
    while (regd.cod <> valoralto) do begin
        aux:= regd.cod;
        total:=0;
        while (aux = regd.cod) do begin //proceso el archivo detalle
          total:= total + regd.cantVendida;
	      leer(det,regd);
        end;
        while(regm.cod <> aux) do  //se busca el codigo correspondiente en el archivo maestro para actualizarlo con la info obtenida del detalle
            read(mae,regm);

        regm.stockA:= regm.stockA + total;
        seek (mae, filepos(mae)-1);
        write(mae,regm); //actualizo el maestro

        if(not(eof(mae))) then  //avanzo en el maestro
           read(mae,regm);
    end;
    close(mae); close(det);
end;

procedure listar(var mae:maestro; var carga:text);
var p:producto;
begin
   assign(carga,'stock_min.txt');
   rewrite(carga); //crea el archivo de texto
   reset(mae);
   while(not eof(mae)) do begin
       read(mae, p); //lee info de productos del archivo maestro
       if(p.stockA < p.stockMin) then begin
          with p do
                 writeln(carga, '   ',cod,'   ',precio,'   ',stockA,'   ',StockMin,'   ',nom);
       end;
   end;
   writeln('');
   writeln('listado con exito en "stock_min.txt".');
   close(mae); close(carga);
end;


procedure opciones(var opc:integer);
begin
  repeat
    writeln('--------------------------------------');
    writeln('Seleccione una opcion:');
    writeln('');
    writeln('0.Terminar el programa');
    writeln('1.Crear el archivo maestro a partir de un archivo de texto');
    writeln('2.Listar el contenido del archivo maestro en un archivo de texto');
    writeln('3.Crear un archivo detalle de ventas a partir de en un archivo de texto');
    writeln('4.Listar en pantalla el contenido del archivo detalle de ventas.');
    writeln('5.Actualizar el archivo maestro con el archivo detalle.');
    writeln('6.Listar en un archivo de texto productos cuyo stock act esté por debajo del stock min permitido.');
    writeln('');
    write('Ingrese numero de opcion:');
    readln(opc);
    writeln(' ');
  until ((opc>=0) and (opc<=7));
end;

Var
    mae1: maestro;
    det1: detalle;
    t1,t2,t3,t4:text;
    opc:integer;

Begin
    opciones(opc);
    if(opc<>0) then begin
      assign (mae1, 'maestro');
      assign (det1, 'detalle');
      repeat
         case opc of
            1: crearArchivoMaestro(mae1,t1);

            2: listarContenidoMaestro(mae1,t2);

            3: crearArchivoDetalle(det1,t3);

            4: informarDetalle(det1);

            5: actualizar(mae1,det1);

            6: listar(mae1,t4);
         end;
         opciones(opc);
      until(opc=0);
    end;
    readln;
End.


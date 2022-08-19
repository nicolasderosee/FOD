Program Ejercicio2P2;
const valorAlto = 9999;
type
  str25 = string[25];
  alumno = record            //ordenado por codigo de alumno
      cod:integer;
      ap:str25;
      nom:str25;
      cantSinFinal:integer;
      cantConFinal:integer;
  end;
  alu = record
      cod: integer;
      info:str25;
  end;

  maestro = file of alumno;
  detalle = file of alu;

Procedure leer (var archivo:detalle; var dato:alu);
begin
      if (not eof(archivo)) then read(archivo,dato)
      else dato.cod := valoralto;
end;

Procedure crearArchivoMaestro(var mae:maestro; var carga:text); //crea un archivo maestro (binario) a partir de un archivo txt
var a:alumno;
begin
    assign(carga,'alumnos.txt');
    reset(carga); //abro el archivo de texto existente
    rewrite(mae); //creo el maestro
    while (not eof(carga)) do begin  //mientras no llegue al final del archivo de texto
       with a do begin //leo del archivo de texto
          readln(carga, cod, cantSinFinal, cantConFinal, nom);
          readln(carga, ap);
       end;
       write(mae, a); //escribo en el archivo maestro
    end;
    write('Archivo maestro cargado.');
    Readln;
    close(mae); close(carga); //cierro ambos archivos
end;

Procedure crearArchivoDetalle(var det:detalle; var carga1:text);
var a:alu;
begin
    assign(carga1,'detalle.txt');
    reset(carga1);
    rewrite(det);
    while (not eof(carga1)) do begin
       with a do
          readln(carga1, cod, info);
       write(det, a);
    end;
    write('Archivo detalle cargado.');
    Readln;
    close(det); close(carga1);
end;

procedure listarContenidoMaestro(var mae:maestro; var carga2:text); //listar de un binario a un txt
var a:alumno;
begin
   assign(carga2,'reporteAlumnos.txt');
   rewrite(carga2); //crea el archivo de texto
   reset(mae);
   while(not eof(mae)) do begin
       read(mae, a); //lee alumnos del archivo maestro
       with a do begin
          writeln(carga2, '   ',cod,'   ',cantSinFinal,'   ',cantConFinal,'   ',nom);
          writeln(carga2, '   ',ap);
       end;
   end;
   writeln('');
   writeln('listado con exito en "reporteAlumnos.txt".');
   close(mae); close(carga2);
end;

procedure listarContenidoDetalle(var det:detalle; var carga3:text);
var a:alu;
begin
   assign(carga3,'reporteDetalle.txt');
   rewrite(carga3); //crea el archivo de texto
   reset(det);
   while(not eof(det)) do begin
       read(det, a); //lee info de alumnos del archivo detalle
       with a do
          writeln(carga3, '   ',cod,'   ',info);
   end;
   writeln('');
   writeln('listado con exito en "reporteAlumnos.txt".');
   close(det); close(carga3);
end;

Procedure actualizar(var mae:maestro; var det:detalle);
var regm:alumno; regd:alu; aux,total1,total2:integer;
begin
    reset(mae);  reset(det); //abro ambos archivos existentes
    read(mae,regm); //leo un alumno del maestro
    leer(det,regd); //leo un alumno del detalle
    while (regd.cod <> valoralto) do begin
        aux:= regd.cod;
        total1:=0;
        total2:=0;
        //proceso el archivo detalle
        while (aux = regd.cod) do begin //mientras tenga el mismo alumno
          if(regd.info = 'Final') then
               total1:= total1 + 1
          else
               total2:= total2 + 1;
	      leer(det,regd); //leo otro alumno del detalle
        end;
        while(regm.cod <> aux) do  //se busca el codigo correspondiente en el archivo maestro para actualizarlo con la info obtenida del detalle
            read(mae,regm);
        regm.cantConFinal:= regm.cantConFinal + total1;
        regm.cantSinFinal:= regm.cantSinFinal + total2;
        seek (mae, filepos(mae)-1);
        write(mae,regm); //actualizo el maestro
        if(not(eof(mae))) then  //no es tan necesario
           read(mae,regm); //leo otro alumno del maestro
    end;
    close(mae); close(det);
end;

procedure listar(var mae:maestro; var carga:text); //genero un archivo txt a partir de un archivo bianario (maestro)
var a:alumno;
begin
   assign(carga,'listado.txt');
   rewrite(carga); //crea el archivo de texto
   reset(mae); //abro el archivo maestro existente
   while(not eof(mae)) do begin
       read(mae, a); //lee info de alumnos del archivo maestro
       if(a.cantSinFinal > 4) then begin
          with a do begin
                 writeln(carga, '   ',cod,'   ',cantSinFinal,'   ',cantConFinal,'   ',nom);
                 writeln(carga, '   ',ap);
          end;
       end;
   end;
   writeln('');
   writeln('listado con exito en "listado.txt".');
   close(mae); close(carga);
end;

var
    mae1: maestro;
    det1: detalle;
    t1,t2,t3,t4,t5:text;

Begin
    assign (mae1, 'maestro');
    assign (det1, 'detalle');
    crearArchivoMaestro(mae1,t1);
    crearArchivoDetalle(det1,t2);
    listarContenidoMaestro(mae1,t3);
    listarContenidoDetalle(det1,t4);
    actualizar(mae1,det1);
    listar(mae1,t5);
    Readln();
End.

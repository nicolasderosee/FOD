Program Ejercicio6P1;
type
  str25 = string[25];
  celular = record
      cod:integer;
      nom:str25;
      marca:str25;
      desc:str25;
      precio:double;
      stockMin:integer;
      stock:integer;
  end;
  archCelulares = file of celular;

procedure leerCelular(var c:celular);
begin
   writeln('');
   write('Ingrese el nombre del celular:');
   readln(c.nom);
   readln;
   if(c.nom <> 'fin') then begin
        write('Ingrese el codigo:');
        readln(c.cod);
        write('Ingrese el precio:');
        readln(c.precio);
        write('Ingrese la marca:');
        readln(c.marca);
        write('Ingrese el stock minimo:');
        readln(c.stockMin);
        write('Ingrese el stock disponible:');
        readln(c.stock);
        write('Ingrese la descripcion:');
        readln(c.desc);
   end;
end;

procedure crearArchivo(var archivo:archCelulares; var carga:text);
var c:celular;
begin
    assign(carga,'celulares.txt');
    reset(carga);
    rewrite(archivo);
    while (not eof(carga)) do begin
       with c do begin
          readln(carga, cod, precio, marca);
          readln(carga, stockMin, stock, desc);
          readln(carga,nom);
       end;
       write(archivo, c);
    end;
    write('Archivo cargado.');
    Readln;
    close(archivo); close(carga);
end;

procedure imprimirDatos(c:celular);
begin
     writeln('codigo:', c.cod);
     writeln('precio:', c.precio:3:2);
     writeln('marca:', c.marca);
     writeln('stock minimo:', c.stockMin);
     writeln('stock disponible:', c.stock);
     writeln('descripcion:', c.desc);
     writeln('nombre:', c.nom);
     writeln('');
     readln;
end;

procedure listarPorStock(var arc_logico:archCelulares);
var c:celular;
begin
       writeln('');
       reset(arc_logico);
   	   while not eof(arc_logico) do begin
          read(arc_logico, c);
          if(c.stock < c.stockMin) then
              imprimirDatos(c);
       end;
       close(arc_logico);
end;

procedure listarPorDescripcion(var arc_logico:archCelulares);
var c:celular;
begin
       reset(arc_logico);
   	   while not eof(arc_logico) do begin
          read(arc_logico, c);
          if(c.desc <> '') then
              imprimirDatos(c);
       end;
       close(arc_logico);
end;

procedure exportar (var arc_logico:archCelulares; var carga1:text);
var c:celular;
begin
   assign(carga1,'cargaCelulares.txt');
   rewrite(carga1); //crea el archivo de texto
   reset(arc_logico);
   while(not eof(arc_logico)) do begin
       read(arc_logico, c); //lee empleados del archivo logico
       with c do
          writeln(carga1, '   ',cod,'   ',precio:3:2,'   ',marca,'   ',stockMin,'   ',stock, '   ',desc, '    ',nom);
   end;
   writeln('');
   writeln('Exportado con exito como "cargaCelulares.txt".');
   close(arc_logico); close(carga1);
end;


procedure agregar (var arc_logico:archCelulares);
var c: celular;
begin
   reset(arc_logico);
   seek(arc_logico, filesize(arc_logico));
   leerCelular(c);
   while (c.nom <> 'fin') do begin
        write(arc_logico, c);
        leerCelular(c);
   end;
   close(arc_logico);
end;

procedure modificarStock(var arc_logico:archCelulares); //PREGUNTAR
var c: celular; nombre:str25; stock:integer;
begin
     writeln('');
     write('ingrese el nombre del celular al que quiera modificarle el stock:');
     readln(nombre); //leo un nombre de celular
     reset(arc_logico); //abro el archivo logico exitente
     while (not eof(arc_logico) and (nombre <> 'fin')) do begin //mientras no llegue al final del archivo y el nombre sea distinto de fin
         read(arc_logico,c); //leo de mi archivo logico un celular
         while((c.nom <> nombre) and (not eof(arc_logico))) do //si el nombre del celular no coincide con el nombre ingresado y no es el final del archivo
                read(arc_logico,c); //leo otro celular de mi archivo
         if(c.nom = nombre) then begin //si el nombre del celular leido de mi archivo coincide con el nombre de celular ingresado
            write('ingresar nuevo stock:');
            readln(stock); //leo un stock
            c.stock:= stock; //modifico el registro
            seek(arc_logico, Filepos(arc_logico) - 1); //me posiciono correctamente porque el puntero me quedo en el siguiente registro
            write(arc_logico,c); //actualizo el archivo logico
            writeln('');
            writeln('el stock fue modificado');
         end
         else
            writeln('El nombre de celular ingresado no existe'); //se llego al fin del archivo y no se encontro ningun celular con el mismo n
         writeln('');
         writeln('Ingrese otro nombre del celular al que quiera modificarle el stock:');
         readln(nombre);
     end;
     close(arc_logico);
end;

procedure exportarSinStock(var arc_logico:archCelulares; var carga:text);
var c:celular;
begin
   assign(carga, 'SinStock.txt');
   rewrite(carga); //crea el archivo de texto
   reset(arc_logico);
   while(not eof(arc_logico)) do begin
      read(arc_logico, c); //lee empleados del archivo logico
      if(c.stock = 0) then begin
         with c do
            writeln(carga, '   ',cod,'   ',precio:3:2,'   ',marca,'   ',stockMin,'   ',stock, '   ',desc, '    ',nom);
      end;
   end;
   writeln('Exportado con exito como "SinStock.txt".');
   close(arc_logico); close(carga);
end;


procedure opciones(var opc:integer);
begin
  repeat
    writeln('--------------------------------------');
    writeln('Seleccione una opcion:');
    writeln('');
    writeln('0.Terminar el programa');
    writeln('1.Crear Archivo de celulares con datos de un archivo de texto');
    writeln('2.Lista de celulares con stock minimo');
    writeln('3.Lista de celulares con descripcion');
    writeln('4.Exportar todos los celulares a un archivo de texto');
    writeln('5.Aniadir celulares');
    writeln('6.Modificar el stock');
    writeln('7.Exportar celulares con stock en 0 a un archivo de texto');
    writeln('');
    write('Ingrese numero de opcion:');
    readln(opc);
    writeln(' ');
  until ((opc>=0) and (opc<=7));
end;

var arc_logico: archCelulares;
    arc_fisico: string[50];
    t:text;
    opc:integer;

begin
    opciones(opc);
    if(opc<>0) then begin
      write('Ingrese el nombre del archivo:' );
      read(arc_fisico);
      assign(arc_logico, arc_fisico);
      repeat
         case opc of
            1: crearArchivo(arc_logico,t);

            2: listarPorStock(arc_logico);

            3: listarPorDescripcion(arc_logico);

            4: exportar(arc_logico,t);

            5: agregar(arc_logico);

            6: modificarStock(arc_logico);

            7: exportarSinStock(arc_logico,t);

         end;
         opciones(opc);
      until(opc=0);
    end;
    readln;
End.


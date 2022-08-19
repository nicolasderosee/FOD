Program Ejercicio7P1;
type
  str25 = string[25];
  novela = record
      cod:integer;
      nom:str25;
      genero:str25;
      precio:double;
  end;
  archNovelas = file of novela;

procedure leerNovela(var n:novela);
begin
   writeln('');
   write('Ingrese el codigo de una novela:');
   readln(n.cod);
   readln;
   if(n.cod <> 0) then begin
        write('Ingrese el nombre:');
        readln(n.nom);
        write('Ingrese el precio:');
        readln(n.precio);
        write('Ingrese el genero:');
        readln(n.genero);
   end;
end;


procedure imprimirDatos(n:novela);
begin
     writeln('Novelas disponibles:');
     writeln('');
     writeln('Codigo:', n.cod, ' Precio:', n.precio:3:2,' Genero:',n.genero);
     writeln('Nombre:', n.nom);
     readln;
end;

procedure crearArchivo(var archivo:archNovelas; var carga:text);  //crea un archivo binario a partir de un archivo de texto
var n:novela;
begin
    assign(carga,'novelas.txt'); //asocio el archivo de texto logico con el archivo de texto fisico existente
    reset(carga); //abro el archivo existente
    rewrite(archivo); //creo el archivo binario logico
    while (not eof(carga)) do begin  //mientras no llegue al final del archivo de texto
       with n do begin
          readln(carga, cod, precio, genero); //voy leyendo del archivo de texto
          readln(carga, nom);
       end;
       write(archivo, n); //voy escribiendo las novelas en el archivo logico binario
    end;
    writeln('Archivo cargado.');
    Readln;
    close(archivo); close(carga);  //cierro ambos archivos
end;

procedure agregar (var arc_logico:archNovelas);
var n: novela;
begin
   writeln('');
   writeln('Agregue una novela');
   reset(arc_logico); //abro el archivo logico binario existente
   seek(arc_logico, filesize(arc_logico)); //me posiciono al final del archivo
   leerNovela(n); //leo una novela nueva
   while (n.cod <> 0) do begin
        write(arc_logico, n); //escribo la novela al final del archivo
        leerNovela(n);  //leo otra novela nueva
   end;
   writeln('');
   writeln('Novela agregada');
   close(arc_logico);
end;

procedure modificar (var archivo:archNovelas);
var n:novela; var cod:integer;
begin
   writeln('');
   write('Ingrese el codigo de novela que desea modificar:');
   readln(cod); //se ingresa un codigo por teclado
   reset(archivo); //abro el archivo existente
   while(not eof(archivo)) do begin //mientras no llegue al final del archivo
       read(archivo,n); //leo una novela del archivo
       if(n.cod = cod) then begin  //si el codigo coincide
            writeln('');
            write('Ingrese nuevo precio:');
            readln(n.precio); //actualizo el precio de la novela
            seek(archivo, filePos(archivo)-1); //me posiciono en el anterior porque el puntero se corrio uno cuando lei del archivo
            write(archivo, n); //reflejo los cambios en el archivo
       end;
   end;
   writeln('');
   writeln('novela modificada');
   close(archivo);
end;

procedure mostrar(var arc_logico:archNovelas);
var n:novela;
begin
       writeln('');
       reset(arc_logico);
   	   while not eof(arc_logico) do begin
          read(arc_logico, n);
          imprimirDatos(n);
       end;
       close(arc_logico);
end;

var arc_logico: archNovelas;
    arc_fisico: string[50];
    t:text;

begin
   write('Ingrese el nombre del archivo:' );
   read(arc_fisico);
   assign(arc_logico, arc_fisico);
   crearArchivo(arc_logico,t);
   agregar(arc_logico);
   modificar(arc_logico);
   mostrar(arc_logico);
   readln;
End.

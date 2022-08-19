Program Ejercicio5P1;
type
  str25 = string[25];
  celular = record
      cod:integer;
      precio:double;
      stockMin:integer;
      stock:integer;
      marca:str25;
      desc:str25;
      nom:str25;
  end;
  archCelulares = file of celular;


procedure crearArchivo(var archivo:archCelulares; var carga:text);  //generar archivo binario a partir de un archivo de texto
var c:celular; nomArch:str25;
begin
    write('ingrese el nombre del archivo de carga:'); //el archivo de texto se llama celulares.txt
    readln(nomArch);
    assign(carga,nomArch); //asocio el archivo logico de texto (carga) con el archivo fisico de texto (celulares.txt)
    reset(carga); //abro el archivo existente
    rewrite(archivo); //crea un archivo binario
    while (not eof(carga)) do begin //mientras no llegue al final del archivo de texto
       with c do begin //voy leyendo celulares
          readln(carga, cod, precio, marca); //*no mas de un string por linea
          readln(carga, stockMin, stock, desc);
          readln(carga,c.nom);
       end;
       write(archivo, c); //escribo lo leido en el archivo logico (binario)
    end;
    write('Archivo cargado.');
    Readln;
    close(archivo); close(carga); //cierro ambos archivos
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
       reset(arc_logico); //abro el archivo logico existente
   	   while not eof(arc_logico) do begin //mientras no llegue al final del archivo logico
          read(arc_logico, c); //voy leyendo celulares de mi archivo logico
          if(c.stock < c.stockMin) then
              imprimirDatos(c); //muestro el celular en pantalla
       end;
       close(arc_logico);//cieroo el archivo logico
end;

procedure listarPorDescripcion(var arc_logico:archCelulares);
var c:celular;
begin
       reset(arc_logico); //abro el archivo logico existente
   	   while not eof(arc_logico) do begin //mientras no llegue al final del archivo logico
          read(arc_logico, c); //voy leyendo celulares
          if(c.desc <> '') then
              imprimirDatos(c); //muestro los celulares que cumplen con la condicion en pantalla
       end;
       close(arc_logico); //cierro el archivo logico
end;

procedure exportar (var arc_logico:archCelulares; var carga1:text); //a partir de un archivo binario genero un archivo de texto
var c:celular;
begin
   assign(carga1,'celulares.txt'); //asocio el archivo de texto logico con el archivo de texto fisico vacio
   rewrite(carga1); //crea el archivo de texto
   reset(arc_logico); //abro el archivo logico binario existente
   while(not eof(arc_logico)) do begin  //mientras no llegue al final del archivo logico binario
       read(arc_logico, c); //lee celulares del archivo logico binario
       with c do
          writeln(carga1, '   ',cod,'   ',precio:3:2,'   ',marca,'   ',stockMin,'   ',stock, '   ',desc,'   ',nom); //escribe celulares en el archivo de texto creado
   end;
   writeln('Exportado con exito como "celulares.txt".');
   close(arc_logico); close(carga1); //cierro ambos archivos
end;

var arc_logico: archCelulares;
    arc_fisico: string[50];
    carga:text; carga1:text;
    opc:integer;

begin
    write('Ingrese el nombre del archivo:' );
    read(arc_fisico);
    assign(arc_logico, arc_fisico);
    writeln('--------------------------------------');
    writeln('Seleccione una opcion:');
    writeln('');
    writeln('1.Crear Archivo de celulares con datos de un archivo de texto');
    writeln('2.Lista de celulares con stock minimo');
    writeln('3.Lista de celulares con descripcion');
    writeln('4.Exportar todos los celulares a un archivo de texto');
    writeln('');
    write('Ingrese numero de opcion:');
    readln(opc);
    writeln(' ');

    case opc of
       1: crearArchivo(arc_logico,carga);

       2: listarPorStock(arc_logico);

       3: listarPorDescripcion(arc_logico);

       4: exportar(arc_logico,carga1);

    end;

Readln;
End.


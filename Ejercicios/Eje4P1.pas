Program Ejercicio4P1;
type
  str10 = string[25];
  empleado = record
      num:integer;
      ap:str10;
      nom:str10;
      edad:integer;
      dni:integer;
  end;
  archEmpleados = file of empleado;


procedure leerEmpleado(var E:empleado);
begin
   writeln('');
   write('Ingrese el apellido de un empleado:');
   readln(E.ap);
   readln;
   if(E.ap <> 'fin') then begin
        write('Ingrese el nombre:');
        readln(E.nom);
        write('Ingrese el numero:');
        readln(E.num);
        write('Ingrese la edad:');
        readln(E.edad);
        write('Ingrese el dni:');
        readln(E.dni);
   end;
end;

procedure imprimirDatos(e:empleado);
begin
     writeln('Nombre:', e.nom);
     writeln('Apellido:', e.ap);
     writeln('Nro de empleado:', e.num);
     writeln('edad:', e.edad);
     writeln('dni:', e.dni);
     writeln('');
     readln;
end;


procedure crearArchivo(var arc_logico:archEmpleados);
var e:empleado;
begin
    rewrite(arc_logico);
    leerEmpleado(e);
    while (E.ap <> 'fin') do begin
       write(arc_logico, E);
       leerEmpleado(E);
    end;
    close(arc_logico);
end;


procedure listarPorNomAp(var arc_logico:archEmpleados);
var e:empleado; nomAp:str10;
begin
       writeln('');
       write('Ingrese nombre o apellido:');
       readln(nomAp);
       reset(arc_logico);
   	   while not eof(arc_logico) do begin
          read(arc_logico, e);
          if(e.nom = nomAp) or (e.ap = nomAp) then begin
               imprimirDatos(e);
          end;
       end;
       close(arc_logico);
end;

procedure imprimirPorLinea(var arc_logico:archEmpleados);
var e:empleado;
begin
       reset(arc_logico);
   	   while not eof(arc_logico) do begin
          read(arc_logico, e);
          writeln(e.nom,' ',e.ap);
       end;
       close(arc_logico);
end;

procedure imprimirJubilados(var arc_logico:archEmpleados);
var e:empleado;
begin
       reset(arc_logico);
   	   while not eof(arc_logico) do begin
          read(arc_logico, e);
          if(e.edad > 70) then writeln(e.nom,' ',e.ap);
       end;
       close(arc_logico);
end;

procedure agregar (var arc_logico:archEmpleados);
var e: empleado;
begin
   reset(arc_logico); //abro el archivo logico existente
   seek(arc_logico, filesize(arc_logico)); //me posiciono al final del archivo logico
   leerEmpleado(e); //leo un empleado de teclado
   while (e.ap <> 'fin') do begin
        write(arc_logico, e); //agrego empleado al final de mi archivo logico
        leerEmpleado(e); //leo otro empleado
   end;
   close(arc_logico); //cierro el archivo
end;

procedure modificar(var arc_logico:archEmpleados); //REVISAR
var e: empleado; numero, edad:integer; sigue:str10;
begin
    reset(arc_logico);
    sigue:= 'si';
    while(sigue = 'si') do begin
        writeln('');
        write('numero de empleado con edad a modificar:');
        readln(numero);
        read(arc_logico,e);
        while (not eof(arc_logico) and (e.num <> numero)) do
            read(arc_logico,e);
        if(e.num = numero) then begin
           write('ingresar nueva edad:');
           readln(edad);
           e.edad:= edad;
           seek(arc_logico, Filepos(arc_logico) - 1);
           write(arc_logico,e);
           writeln('');
           writeln('la edad fue modificada');
        end
        else
           writeln('El numero de empleado no fue encontrado');
        writeln('');
        writeln('desea seguir modificando edades? si/no');
        readln(sigue);
        if(sigue = 'si') then seek(arc_logico,0); //me vuelvo a posicionar al principio del archivo
    end;
    close(arc_logico);
end;

procedure exportarTodos (var arc_logico:archEmpleados; var carga1:text); //a partir de un arch binario genero un arch de texto
var e:empleado;
begin
   assign(carga1,'todos_empleados.txt'); //asocio el archivo de texto existence vacio con carga1
   rewrite(carga1); //crea el archivo de texto
   reset(arc_logico); //abro el archivo logico binario
   while(not eof(arc_logico)) do begin
       read(arc_logico, e); //lee empleados del archivo logico
       with e do
          writeln(carga1, '   ',num,'   ',ap,'   ',nom,'   ',edad,'   ',dni); //escribo el empleado en el archivo de texto
   end;
   writeln('Exportado con exito como "todos_empleados.txt".');
   close(arc_logico); close(carga1); //cierro ambos archivos
end;

procedure exportarSoloDni(var arc_logico:archEmpleados; var carga2:text );
var e:empleado;
begin
   assign(carga2, 'faltaDNIempleado.txt');
   rewrite(carga2); //crea el archivo de texto
   reset(arc_logico);
   while(not eof(arc_logico)) do begin
      read(arc_logico, e); //lee empleados del archivo logico
      if(e.dni = 00) then begin
         with e do
            writeln(carga2, '   ',num,'   ',ap,'   ',nom,'   ',edad,'   ',dni);
      end;
   end;
   writeln('Exportado con exito como "faltaDNIempleado.txt".');
   close(arc_logico); close(carga2);
end;

var arc_logico: archEmpleados;
    arc_fisico: string[50];
    opc:integer;
    exportadoTot,exportadoDNI:text;

begin
    write('Ingrese el nombre del archivo:' );
    read(arc_fisico);
    assign(arc_logico, arc_fisico);
    writeln('--------------------------------------');
    writeln('Seleccione una opcion:');
    writeln('');
    writeln('1.Crear Archivo de empleados');
    writeln('2.Lista de empleados con un nombre y apellido determinado');
    writeln('3.Lista de empleados');
    writeln('4.Lista de empleados mayores a 70');
    writeln('5:Aniadir empleados');
    writeln('6:Modificar edad de empleados');
    writeln('7:Exportar todos los empleados');
    writeln('8:Exportar los empleados sin dni');
    writeln('');
    write('Ingrese numero de opcion:');
    readln(opc);

    case opc of
       1: crearArchivo(arc_logico);

       2: listarPorNomAp(arc_logico);

       3: imprimirPorLinea(arc_logico);

       4: imprimirJubilados(arc_logico);

       5: agregar(arc_logico);

       6: modificar(arc_logico);

       7: exportarTodos(arc_logico, exportadoTot);

       8: exportarSoloDni(arc_logico, exportadoDNI);

    end;

readln;
End.

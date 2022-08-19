Program Ejercicio3AP1;
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


procedure listarPorNomAp(var arc_logico:archEmpleados; nomAp:str10);
var e:empleado;
begin
       reset(arc_logico); //abro el archivo logico exitente
   	   while not eof(arc_logico) do begin //mientras no llegue al final del archivo
          read(arc_logico, e); //leo un empleado
          if(e.nom = nomAp) or (e.ap = nomAp) then begin  //si coincide
               imprimirDatos(e); //muestro el empleado
          end;
       end;
       close(arc_logico); //cierro el archivo logico
end;

procedure imprimirPorLinea(var arc_logico:archEmpleados);
var e:empleado;
begin
       reset(arc_logico); //abro el archivo logico existente
   	   while not eof(arc_logico) do begin //mientras no llegue al final del archivo
          read(arc_logico, e); //leo un empleado
          writeln(e.nom,' ',e.ap);  //muestro el empleado
       end;
       close(arc_logico); //cierro el archivo logico
end;

procedure imprimirJubilados(var arc_logico:archEmpleados);
var e:empleado;
begin
       reset(arc_logico); //abro el archivo logico existente
   	   while not eof(arc_logico) do begin //mientras no llegue al final del archivo
          read(arc_logico, e); //leo un empleado del archivo
          if(e.edad > 70) then writeln(e.nom,' ',e.ap); //si la edad es mayor a 70, muestro empleado
       end;
       close(arc_logico); //cierro el archivo
end;

var arc_logico: archEmpleados;
    arc_fisico: string[50];
    E:empleado;
    opc:integer;
    nomAp:str10;

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
    writeln('');
    write('Ingrese numero de opcion:');
    readln(opc);

    case opc of
       1: begin
             rewrite(arc_logico); //abro el arhcivo logico y lo creo
             leerEmpleado(E); //leo un empleado
             while (E.ap <> 'fin') do begin
                   write(arc_logico, E); //escribo el empleado en el archivo logico
                   leerEmpleado(E); //leo otro empleado
             end;
             close(arc_logico);//cierro el archivo logico
          end;

       2: begin
             writeln('');
             write('Ingrese nombre o apellido:'); //ingreso un nombre o apellido determinao
             readln(nomAp);
             listarPorNomAp(arc_logico, nomAp);
          end;

       3: imprimirPorLinea(arc_logico);

       4: imprimirJubilados(arc_logico);
    end;

readln;
End.

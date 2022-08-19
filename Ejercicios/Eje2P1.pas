//2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creados en el ejercicio 1,
//informe por pantalla cantidad de números menores a 1500 y el promedio de los números ingresados. El nombre del archivo a procesar debe ser
//proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el contenido del archivo en pantalla.

Program Ejercicio2P1;
type
  archivo = file of integer;

var arc_logico:archivo;
    arc_fisico: string[255];
    suma,nro,totalMenores:integer;

begin
    suma:=0; totalMenores:=0;
    writeln('Ingrese el nombre del archivo:');
    readln(arc_fisico);
    assign(arc_logico, arc_fisico);
    reset(arc_logico);
    write('contenido del archivo:');
    while (not eof(arc_logico)) do begin
        read(arc_logico, nro);
        write(nro,' ');
        suma:= suma + nro;
        if(nro<1500) then totalMenores:= totalMenores + 1;
    end;
    writeln();
    writeln('numeros menores a 1500:' , totalMenores);
    writeln('promedio total de numeros ingresados:', suma div filesize(arc_logico));
    close(arc_logico);
    readln();
end.



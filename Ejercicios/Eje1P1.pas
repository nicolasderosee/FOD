//Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
//incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
//archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
//se ingrese el número 30000, que no debe incorporarse al archivo.

Program Ejercicio1P1;
type
  archivo = file of integer;

var arc_logico: archivo; nro: integer;
    arc_fisico: string[12];
begin
    write('Ingrese el nombre del archivo:');
    read(arc_fisico);
    assign(arc_logico, arc_fisico);
    rewrite(arc_logico);
    write('ingrese un numero:');
    read(nro);
    while (nro <> 3000) do begin
        write(arc_logico, nro);
        write('ingrese otro numero:');
        read(nro);
    end;
    close(arc_logico);
end.


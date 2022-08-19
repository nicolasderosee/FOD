Program generarArchivo;
 type archivo = file of integer;
 var archivo_logico: archivo;
     nro:integer;
     archivo_fisico: string[12];

 Procedure Recorrido(var archivo_logico: archivo);
 var  nro: integer;
 begin
       reset(archivo_logico); //abro un archivo existente
   	   while not eof(archivo_logico) do begin //mientras no termina
         read(archivo_logico, nro); //leo un nro del archivo
         write(nro,' '); //imprimo el nro
       end;
       close(archivo_logico);//cierro el archivo
       Readln();
  end;

begin
     write('Ingrese el nombre del archivo:');
     read(archivo_fisico); //leo el nombre del archivo fisico
     assign(archivo_logico, archivo_fisico); //el so hace la relación
     rewrite(archivo_logico); //crea el archivo
     write('Ingrese un nro:');
     read(nro); //leo un numero
     while (nro<>0) do begin
         write(archivo_logico, nro); //escribo en el archivo el nro leído
         write('Ingrese otro nro:');
         read(nro);
     end;
     Recorrido(archivo_logico);
     Readln();
end.


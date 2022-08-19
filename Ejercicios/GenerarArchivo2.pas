Program generarArchivo2; //archivo binario
 type
    persona = record
       dni: string[8];
       apyNom: String [30];
       direccion: String[40];
       sexo: char;
       salario:real;
    end;
    archivo_personas = file of persona;

 var archivo_logico: archivo_personas;
     archivo_fisico: string[12];
     per:persona;

 begin
     write('Ingrese el nombre del archivo:');
     read(archivo_fisico); //leo el nombre del archivo fisico
     assign(archivo_logico, archivo_fisico); //asocio el archivo logico con el archivo fisico
     rewrite(archivo_logico); //apertura del archivo para la creacion

     write('Ingrese el dni de una persona:');
     readln(per.dni); //leo un dni
     while (per.dni<>'') do begin
         //lectura del resto de los datos de la persona
         write('Ingrese el apellido y el nombre:');
         readln(per.apyNom);
         write('Ingrese la direccion:');
         readln(per.direccion);
         write('Ingrese el sexo:');
         readln(per.sexo);
         write('Ingrese el salario:');
         readln(per.salario);
         write(archivo_logico, per); //escribo en el archivo la persona leida
         write('Ingrese el dni de otra persona:');
         readln(per.dni);
     end;
     close(archivo_logico);
     Readln();
end.

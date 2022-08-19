Program MaestroYDetalle;
 type
  emp = record
     nombre: string[30];
     direccion: string[30];
     cht: integer;
  end;
  e_diario = record
     nombre: string[30];
     cht: integer;
  end;
  detalle = file of e_diario; 
  maestro = file of emp; 

 var regM: emp;
     regD:e_diario;
     mae1: maestro;
     det1: detalle;

begin
    assign (mae1, 'maestro'); //relacion archivo logico con archivo fisico
    assign (det1, 'detalle');
    reset (mae1);  
    reset (det1); //abro un archivo existente

    while (not eof(det1)) do begin  //mientras no se apunte al final del archivo detalle

        read(mae1, regm); //leo de maestro el registro de empleados
        read(det1,regd); //leo de detalle el registro de e diario
        
        while (regm.nombre <> regd.nombre) do //mientras el nombre del registro maestro sea distinto al nombre del registro detalle
          read (mae1,regm);  //leo otro empleado

        //salgo del while si se trata del mismo empleado
        
        regm.cht := regm.cht + regd.cht; //modifico-acutalizo la cht del registro del archivo maestro
        seek (mae1, filepos(mae1)-1); //me posiciono correctamente donde tengo que actualizar
        write(mae1,regm); //actualizo el registro correspondiente del archivo maestro
      end;
  end.






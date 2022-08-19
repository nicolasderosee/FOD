//Ambos archivos (maestro y detalle) están ordenados por código del producto
//En el archivo detalle solo aparecen productos que existen en el archivo maestro
//Cada producto del maestro puede ser, a lo largo del día, vendido más de una vez, por lo tanto,
//en el archivo detalle pueden existir varios registros correspondientes al mismo producto
//un elemento del maestro puede ser modificado por mas de un detalle

program actualizar;
const
  valoralto='9999';
type
  str4 = string[4];
  prod = record
     cod: str4;
     descripcion: string[30];
     pu: real;
     cant: integer;
  end;
  v_prod = record
     cod: str4;
     cv: integer;
  end;
  detalle = file of v_prod;
  maestro = file of prod;

var
    regm: prod;
    regd: v_prod;
    mae1: maestro;
    det1: detalle;
    total: integer;

begin
    assign (mae1, 'maestro'); //hago la relación lógico con físico
    assign (det1, 'detalle');
    reset (mae1);  reset (det1); //abro dos archivos existentes

    while (not eof(det1)) do begin  //mientras no apunte al final del archivo detalle
        read(mae1, regm);  //leo el registro del maestro
        read(det1,regd); //leo el registro del detetalle
        while (regm.cod <> regd.cod) do //mientras no coincidan los codigos sigo leyendo registros del maestro
          read (mae1,regm);
		while (regm.cod = regd.cod) do begin //mientras sea el mismo codigo
          regm.cant := regm.cant - regd.cv; //la cantidad de stock de x producto es igual a la cantidad actual que hay en el registroMaestro menos la cantidad vendida del regDetalle
          read (det1,regd); //leo otro registro del detalle
        end;
        seek (mae1, filepos(mae1)-1); //me posiciono correctamente en el registro del maestro para modificarlo
        write(mae1,regm);  //modifico el reistro del maestro para que quede actualizado el stock
      end;
  end.

    
  


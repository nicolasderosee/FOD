//Ambos archivos (maestro y detalle) están ordenados por código del producto
//En el archivo detalle solo aparecen productos que existen en el archivo maestro
//Cada producto del maestro puede ser, a lo largo del día, vendido más de una vez, por lo tanto,
//en el archivo detalle pueden existir varios registros correspondientes al mismo producto

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

procedure leer (var archivo:detalle; var dato:v_prod);
begin
   if (not eof(archivo)) then read(archivo,dato) //si no se está apuntando a eof entonces leo el registro de detalle
   else dato.cod := valoralto; //si se está apuntando a eof al campo codigo le asigno 9999
end;

Begin
    assign (mae1, 'maestro'); //hago la relación archivo lógico con archivo físico
    assign (det1, 'detalle');
    reset (mae1);  reset (det1);  //abro los archivos
    leer(det1,regd); //leo un registro del archivo detalle

    while (regd.cod <> valoralto) do begin   //mientras el codigo del registro archivo detalle no sea 9999. El codigo del detalle puede ser 9999 porque se leyo ese codigo o porque es eof
        read(mae1, regm);   //leo un registro del archivo maestro

        while (regm.cod <> regd.cod) do //si no coinciden leo otro hasta que coincidan
           read (mae1,regm);

        while (regm.cod = regd.cod) do begin //mientras coincidan
           regm.cant := regm.cant - regd.cv;   //modifico el stock total
           leer(det1,regd); //leo otro registro del archivo detalle
        end;

        seek(mae1, filepos(mae1)-1); //me posiciono correctamente en el archivo maestro
        write(mae1,regm); // actualizo en la pos correspondiente
    end;
End.


Program ejercicio6P2;
const valoralto = 9999;
      dimf = 15;
type
  rango = 1..dimf;
  str25 = string[25];
  articulo = record
      cod:integer;
      nom:str25;
      desc:str25;
      talle:char;
      color:str25;
      stock:integer;
      stockMin:integer;
      precio:real;
  end;
  art = record
      cod: integer;
      cantVendi:integer;
  end;

  maestro = file of articulo;
  detalle = file of art;
  vecDet= array[rango] of detalle; //arreglo de archivos logicos
  vecReg= array[rango] of art; //arreglo de registros

Procedure leer (var archivo:detalle; var dato:art);
begin
   if (not eof(archivo)) then read (archivo, dato)
   else dato.cod := valoralto;
end;

Procedure minimo (var reg:vecReg; var min:art; var det:vecDet);
var i,minPos: rango;
begin
      min.cod:= valorAlto;
      for i:= 1 to dimf do begin
         if(reg[i].cod < min.cod) then begin
              min:= reg[i];
              minPos:=i;
         end;
      end;
      if(min.cod <> valorAlto) then
           leer(det[minPos], reg[minPos]);  //leo registro del detalle que tuvo el codigo minimo y el puntero queda en el registro siguiente
end;

Procedure actualizar(var mae:maestro; var det:vecDet);
var regm:articulo; reg_det:vecReg; i:rango; min:art; aux,total:integer; t:text;
begin
 assign(t,'informe.txt');
 rewrite(t);
 reset(mae);
 read(mae,regm);
 for i:= 1 to dimf do begin
    reset(det[i]);
    leer(det[i], reg_det[i]);
 end;
 minimo(reg_det, min, det); {se procesan todos los registros de los archivos detalle}
 while (min.cod <> valoralto) do begin
    aux:= min.cod;
    total:= 0;
    while (aux = min.cod) do begin {se totaliza la cantidad vendida de articulos iguales en el archivo de detalle}
       total:= total + min.cantVendi;
       minimo(reg_det, min, det);
    end;

    while (regm.cod <> min.cod) do   {se busca en el maestro el producto del detalle}
       read(mae,regm);

    regm.stock := regm.stock - total; {se modifica el stock del articulo con la cantidad total vendida de ese articulo}
    seek (mae, filepos(mae)-1); {se reubica el puntero en el maestro}
    write(mae,regm); {se actualiza el maestro}

    if(regm.stock < regm.stockMin) then begin
        with regm do begin
                 writeln(t,'  ',stock,'   ',precio:3:2,'   ',desc);  //se escribe en un archivo de texto
                 writeln(t, '   ',nom);
        end;
    end;
    if (not eof (mae)) then read(mae,regm); {se avanza en el maestro}
 end;
 writeln('listado con exito en "informe.txt".');
 close (mae); close(t);
 for i:= 1 to dimf do
     close(det[i]);
end;

var
    det: vecDet;
    mae: maestro;
    i:rango;
begin
  for i:= 1 to dimf do
    assign (det[i], 'detalle'+i);
  assign (mae, 'maestro');
  actualizar(mae,det);
  readln;
End.

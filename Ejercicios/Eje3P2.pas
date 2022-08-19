Program ejercicio3P2;
const valorAlto = 9999;
type
  rango = 1..30;
  str25 = string[25];
  producto = record
      cod:integer;
      nom:str25;
      desc:str25;
      stock:integer;
      stockMin:integer;
      precio:real;
  end;
  prod = record
      cod: integer;
      cantVendi:integer;
  end;

  maestro = file of producto;
  detalle = file of prod;
  vecDet= array[rango] of detalle; //arreglo de archivos logicos
  vecReg= array[rango] of prod; //arreglo de registros

Procedure leer (var archivo:detalle; var dato:prod);
begin
   if (not eof(archivo)) then read (archivo, dato)
   else dato.cod := valorAlto;
end;

Procedure minimo (var reg:vecReg; var min:prod; var det:vecDet);
var i,minPos: rango;
begin
      min.cod:= valorAlto;
      for i:= 1 to 30 do begin
         if(reg[i].cod < min.cod) then begin
              min:= reg[i];
              minPos:=i;
         end;
      end;
      if(min.cod <> valorAlto) then
           leer(det[minPos], reg[minPos]);
end;

Procedure actualizar(var mae:maestro; var det:vecDet);
var regm:producto; reg_det:vecReg; i:rango; min:prod; aux,total:integer; t:text;
begin
 assign(t,'informe.txt');
 assign (mae, 'maestro');
 reset(mae);
 read(mae,regm);
 for i:= 1 to 30 do begin
    assign (det[i], 'detalle');
    reset(det[i]);
    leer(det[i], reg_det[i]);
 end;
 minimo(reg_det, min, det); {se procesan todos los registros de los archivos detalle}
 while (min.cod <> valoralto) do begin
    aux:= min.cod;
    total:= 0;
    while (aux = min.cod) do begin {se totaliza la cantidad vendida de productos iguales en el archivo de detalle}
       total:= total + min.cantVendi;
       minimo(reg_det, min, det);
    end;
    while (regm.cod <> min.cod) do   {se busca en el maestro el producto del detalle}
       read(mae,regm);
    regm.stock := regm.stock - total; {se modifica el stock del producto con la cantidad total vendida de ese producto}
    seek (mae, filepos(mae)-1); {se reubica el puntero en el maestro}
    write(mae,regm); {se actualiza el maestro}
    if(regm.stock < regm.stockMin) then begin
        with regm do begin
                 writeln(t,'  ',stock,'   ',precio,'   ',nom);
                 writeln(t, '   ',desc);
        end;
    end;
    if (not eof (mae)) then read(mae,regm); {se avanza en el maestro}
 end;
 writeln('');
 writeln('listado con exito en "informe.txt".');
 close (mae); close(t);
 for i:= 1 to 30 do
     close(det[i]);
end;

var
    det: vecDet;
    mae: maestro;
begin
  actualizar(mae,det);
  readln;
End.

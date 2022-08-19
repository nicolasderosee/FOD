//Los vendedores de cierto comercio asientan las ventas realizadas sobre diferentes computadoras. Cada computadora genera un archivo …..
//Precondiciones
//cada vendedor puede realizar varias ventas diarias.
//Los archivos detalle tienen informacion repetida. Se usan estructuras diferentes. N archivos detalle.
//PostCondicion: generar un archivo maestro que resuma para cada vendedor cuanto vendio

program union_de_archivos_III;
const valoralto = '9999';
type
  vendedor = record
     cod: string[4];
     producto: string[10];
     montoVenta: real;
  end;
  ventas = record
     cod: string[4];
     total: real;
  end;
  maestro = file of ventas;

  arc_detalle = array[1..100] of file of vendedor; //vector con los nombres logicos de los archivos
  reg_detalle = array[1..100] of vendedor; //vector de registros

var min: vendedor;
    deta: arc_detalle;
    reg_det: reg_detalle;
    mae1: maestro;
    regm: ventas;
    i,n: integer;

procedure leer (var archivo:detalle; var dato:vendedor);
begin
  if (not eof( archivo )) then read (archivo, dato)
  else dato.cod := valoralto;
end;

procedure minimo (var reg_det: reg_detalle; var min:vendedor; var deta:arc_detalle);
var i: integer;
begin
   for i:= 1 to 100 do begin
       if(reg_det[i].cod < min.cod) then begin
           min:= reg_det[i]:
           leer(deta[i],reg_det[i]);
        end;
   end;
end;

begin
  Read(n) //leo una cantidad de archivos detalle
  for i:= 1 to n do begin
    assign (deta[i], 'det'+i); //cada nombre logico esta en una pos del vector deta y se hace la relacion con el archivo fisico
    { ojo lo anterior es incompatible en tipos}    
    reset(deta[i]); //abro cada uno de los archivos
    leer(deta[i], reg_det[i]); //leo un registro de un archivo detalle
  end;
  assign (mae1, 'maestro'); rewrite (mae1);
  minimo (reg_det, min, deta);

  while (min.cod <> valoralto) do begin
       regm.cod := min.cod;
       regm.total := 0;
       while (regm.cod = min.cod ) do begin
         regm.total := regm.total + min.montoVenta;
         minimo (regd1, regd2, regd3, min);
       end;
       write(mae1, regm);
  end;
end.






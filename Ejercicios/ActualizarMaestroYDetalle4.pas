//Ambos archivos (maestro y detalle) están ordenados por código del producto
//En el archivo detalle solo aparecen productos que existen en el archivo maestro
//Cada producto del maestro puede ser, a lo largo del día, vendido más de una vez, por lo tanto,
//en el archivo detalle pueden existir varios registros correspondientes al mismo producto
//El maestro se actualiza con tres archivos detalles
//Los archivos detalle están ordenados de menor a mayor

Program actualizar;
  const valoralto='9999';
  type str4 = string[4];
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

Var
   regm:prod; min,regd1,regd2,regd3:v_prod;
   mae1:maestro; det1,det2,det3: detalle;


procedure leer (var archivo: detalle; var dato:v_prod);
begin
   if (not eof(archivo)) then read (archivo,dato)
   else dato.cod := valoralto;
end;


procedure minimo (var r1,r2,r3:v_prod; var min:v_prod);
begin
   if (r1.cod<=r2.cod) and (r1.cod<=r3.cod) then begin
      min := r1; leer(det1,r1); //actualizo el minimo y leo otro registro detalle
   end
   else
      if (r2.cod<=r3.cod) then begin
          min := r2; leer(det2,r2);
      end
      else begin
          min := r3; leer(det3,r3);
      end;
end;


begin
  assign(mae1, 'maestro'); assign(det1,'detalle1');
  assign(det2, 'detalle2'); assign(det3,'detalle3');
  reset(mae1); reset (det1); reset(det2); reset(det3); //abro 3 archivos detalle
  
  leer(det1, regd1); leer(det2, regd2); leer(det3, regd3); //leo los registros de cada archivo detalle
  minimo(regd1, regd2, regd3, min); //busco el minimo de los registros de los 3 detalles

  while (min.cod <> valoralto) do  begin
      read(mae1,regm); //leo un registro del archivo maestro
      while (regm.cod <> min.cod) do //mientras sea distinto leo otro registro del archivo maestro
         read(mae1,regm);
      while (regm.cod = min.cod ) do begin //mientras sean iguales voy actualizando el registro maestro
         regm.cant:= regm.cant - min.cantvendida;
         minimo(regd1, regd2, regd3, min); //busco otro minimo
      end;
      seek (mae1, filepos(mae1)-1);
      write(mae1,regm);
  end;
end.



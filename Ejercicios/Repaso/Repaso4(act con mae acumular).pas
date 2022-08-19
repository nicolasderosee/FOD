Program repaso4;
const
 valorAlto = 9999;
type
  producto = record
     codP:integer;
     desc:string[15];
     precio:real;
     stockA:integer;
     stockMin:integer;
  end;
  pedido = record
     codP:integer;
     cantPedida:integer;
  end;

  detalle = file of pedido;
  maestro = file of producto;

Procedure leer(var arch:detalle; var dato:pedido);
begin
  if not eof(arch) then read(arch,dato)
  else dato.codP:= valorAlto;
end;

Procedure leerMaestro(var arch:maestro; var dato:producto);
begin
  if not eof(arch) then read(arch,dato)
  else dato.codP:= valorAlto;
end;


Procedure minimo(var r1,r2,r3,r4,min:pedido; var det1,det2,det3,det4:detalle; var suc:integer);
begin
  if(r1.codP<= r2.codP) and (r1.codP<=r3.codP) and (r1.codP<= r4.codP) then begin
     min:= r1; leer(det1,r1); suc:=1;
  end
  else
    if(r2.codP<=r3.codP) and (r2.codP<= r4.codP) then begin
      min:= r2; leer(det2,r2); suc:=2;
    end
    else
       if(r3.codP<= r4.codP) then begin
           min:=r3; leer(det3,r3); suc:=3;
       end
       else begin
           min:=r4; leer(det4,r4); suc:=4;
       end;
end;

Procedure actualizar(var mae:maestro; var det1,det2,det3,det4:detalle);
var regm:producto; regd1,regd2,regd3,regd4,min:pedido; suc,codigo:integer;
begin
  reset(mae);
  leerMaestro(mae,regm);
  reset(det1); reset(det2); reset(det3); reset(det4);
  leer(det1,regd1); leer(det2,regd2); leer(det3,regd3); leer(det4,regd4);
  minimo(regd1,regd2,regd3,regd4,min,det1,det2,det3,det4,suc);
  while(regm.codP <> valorAlto) do begin
     codigo:= min.codP;
     while(regm.codP <> codigo) do
           leerMaestro(mae,regm);
     while(regm.codP = min.codP) do begin
        regm.stockA := regm.stockA - min.cantPedida;
        if(regm.stockA < 0) then begin
           writeln(suc,min.codP,regm.stockA * -1); //informa la sucursal, el producto y la cantidad pedida que no pudo ser enviada.
           regm.StockA:= 0; //para que no quede en el stock un numero negativo y para indicar que ya no hay disponibilidad
        end;
        minimo(regd1,regd2,regd3,regd4,min,det1,det2,det3,det4,suc);
     end;
     if(regm.stockA < regm.stockMin) then begin
        writeln('El stock del producto: ',codigo,' esta por debajo del stock minimo ');
     end;
     seek(mae,filepos(mae)-1);
     write(mae,regm);
     leerMaestro(mae,regm); //opcional
  end;
  close(det1); close(det2); close(det3); close(det4); close(mae);
end;

Var
mae:maestro;
det1,det2,det3,det4:detalle;

Begin
  assign(mae,'maestro');
  assign(det1,'detalle1');
  assign(det2,'detalle2');
  assign(det3,'detalle3');
  assign(det3,'detalle4');
  actualizar(mae,det1,det2,det3,det4);
End.

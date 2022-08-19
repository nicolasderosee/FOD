Program repaso8;
const valorAlto = 9999;
type
   rango1 = 1..12;
   rango2 = 1..31;
   cadena = string[15];
   ventas = record
       codCli:integer;
       nom:cadena;
       ap:cadena;
       anio:integer;
       mes:rango1;
       dia:rango2;
       monto:integer;
   end;
   maestro = file of ventas;

Procedure leer(var arch:maestro; var dato:ventas);
begin
  if not eof(arch) then read(arch,dato)
  else dato.codCli:= valorAlto;
end;

Procedure reporte (var mae:maestro);
var regm:ventas; totalMensual,totalAnual,totalEmpresa:integer; mes:rango1; anio:integer; cliente:cadena;
begin
  reset(mae); leer(mae,regm);
  totalEmpresa:= 0;
  while(regm.codCli <> valorAlto) do begin
     cliente := regm.nom;
     writeln('codigo de cliente:', regm.codCli);
     writeln('nombre:', cliente);
     writeln('apellido:', regm.ap);
     while(cliente = regm.nom) do begin
        anio := regm.anio;
        totalAnual:= 0;
        while(cliente = regm.nom) and (anio = regm.anio) do begin
            mes := regm.mes;
            totalMensual:=0;
            while(cliente = regm.nom) and (anio = regm.anio) and (mes = regm.mes) do begin
                 totalMensual:= totalMensual + regm.monto;
                 leer(mae,regm);
            end;
            writeln('El total del mes: ',mes,' es: ',totalMensual);
            totalAnual:= totalAnual + totalMensual;
        end;
        writeln('El total del anio :', anio,' es: ', totalAnual);
        totalEmpresa := totalEmpresa + totalAnual;
     end;
  end;
  writeln('El monto total de la empresa es:', totalEmpresa);
  close(mae);
end;

Var mae:maestro;

Begin
  assign(mae,'maestro');
  reporte(mae);
End.

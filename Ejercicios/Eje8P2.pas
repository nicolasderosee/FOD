program ejercicio8P2;
const valoralto = 9999;
type
    rango1 = 1..12;
    rango2 = 2010..2021;
    rango3 = 1..31;
    str30 = string[30];
    cliente = record
       cod:integer;
       nomYAp:str30;
    end;
    formato = record
       cli:cliente;
       anio: rango2;
       mes: rango1;
       dia: rango3;
       monto:integer;
    end;
    maestro = file of formato;

procedure leer (var archivo: maestro; var dato:formato);
begin
  if (not eof(archivo)) then read (archivo,dato)
  else dato.cli.cod:= valoralto;
end;

Procedure informar(var archivo:maestro);
var  regm: formato;  totalEmpresa, totalAnual, totalMensual:integer;
     Codigo:integer; Mes:rango1; Anio:rango2; NombreYApellido:str30;
begin
    reset(archivo);
	totalEmpresa:=0;
	leer(archivo,regm);
	while(regm.cli.cod<>9999) do begin
	  Codigo:=regm.cli.cod;
	  NombreYApellido:=regm.cli.nomYAp;
	  while (regm.cli.cod = Codigo) do begin
	    Anio:=regm.anio;
        totalAnual:=0;
        while (Codigo = regm.cli.cod) and (Anio = regm.anio) do begin
	      Mes:=regm.mes;
	      totalMensual:=0;
	      while (Codigo = regm.cli.cod) and (Mes = regm.mes) and (Anio = regm.anio) do begin
	         totalMensual:=totalMensual+regm.monto;
	         totalAnual:=totalAnual+regm.monto;
	         totalEmpresa:=totalEmpresa+regm.monto;
	         leer(archivo,regm);
	      end;
	      writeln('Total mensual que compro el usuario ',NombreYApellido,'con codigo ',Codigo,' en el mes',Mes,': ',totalMensual);
        end;
        writeln('Total Anual que compro el usuario ',NombreYApellido,'con codigo ',Codigo,' en el ano',Anio,': ',totalAnual);
      end;
    end;
    writeln('Monto total de ventas que consiguio la empresa: ',totalEmpresa);
    close(archivo);
    end;

Var
 archivo: maestro;

Begin
 assign(archivo, 'archivoVentas');
 informar(archivo);
 Readln;
End.


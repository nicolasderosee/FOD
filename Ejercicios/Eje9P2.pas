program ejercicio9P2;
const valoralto = 9999;
type
	informacion=record
        codProv:integer;
        codLoca:integer;
        numMesa:integer;
        cantVotos:integer;
    end;
    maestro= file of informacion;

procedure leer(var archivo:maestro;var dato:informacion);
begin
   if (not EOF(archivo))then read(archivo,dato)
   else dato.codProv:= valoralto;
end;

Procedure informar(var archivo:maestro);
var
 reg:informacion;
 total, totProv, totLoca: integer;
 codigoProv, codigoLoca: integer;
begin
  reset (archivo);
  leer(archivo, reg);
  total:= 0; //total general de votos
  while (reg.codProv <> valoralto) do begin //mientras no llegue al fin de archivo
     writeln('Codigo de Provincia:', reg.codProv);
     codigoProv:= reg.codProv; //me guardo la provincia actual
     totProv:= 0; //inicializo el contador de provincia en 0
     while (codigoProv = reg.codProv) do begin //mientras sea la misma provincia
        writeln('Codigo de Localidad:', reg.codLoca);
        codigoLoca:= reg.codLoca;
        totLoca := 0;
        while (codigoProv = reg.codProv) and (codigoLoca = reg.codLoca) do begin //mientras sea la misma provincia y la misma localidad
              totLoca := totLoca + reg.cantVotos; //totalizo sumando los votos de la localidad
              leer(archivo, reg); //vuelvo a leer
        end;
        writeln('Total de Votos', totLoca); //cambia la localidad
        totProv := totProv + totLoca; //totalizo los votos totales de la provincia
     end;
     writeln('Total de Votos Provincia', totProv); //cambia la provincia
     total := total + totProv; //totalizo los votos generales
 end;
 writeln('Total General de Votos:', total);
 close (archivo);
end;

var mae:maestro;

begin
  assign(mae, 'archivoInformacion');
  informar(mae);
  readln;
end.

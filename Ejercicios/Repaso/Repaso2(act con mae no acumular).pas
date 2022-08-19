Program repaso2;
const
 valorAlto = 9999; cant = 10;
type
   rango = 1 .. cant;
   informacion = record
     codProv:integer;
     nomProv:string[15];
     codLoc:integer;
     nomLoc:string[15];
     sinLuz:integer;
     sinGas:integer;
     chapa:integer;
     sinAgua:integer;
     sinSanitarios:integer;
   end;

   info = record
      codProv:integer;
      codLoc:integer;
      conLuz:integer;
      conGas:integer;
      construidas:integer;
      conAgua:integer;
      sanitarios:integer;
   end;

   maestro = file of informacion;
   detalle = file of info;

   vecDetalles = array [rango] of detalle;
   vecRegistros = array [rango] of info;


Procedure leerDetalle(var arch:detalle; var dato:info);
begin
  if not eof (arch) then read (arch,dato)
  else dato.codProv := valorAlto;
end;

Procedure leerMaestro(var arch:maestro; var dato:informacion);
begin
  if not eof (arch) then read (arch,dato)
  else dato.codProv := valorAlto;
end;

Procedure minimo(var vd:vecDetalles; var vr:vecRegistros; var min:info);
var i, posMin: rango;
begin
   min.codProv:= valorAlto;
   min.codLoc := valorAlto;
   for i:= 1 to cant do begin
      if(vr[i].codProv <= min.codProv) and (vr[i].codLoc < min.codLoc) then begin
         min:= vr[i];
         posMin:= i;
      end;
   end;
   leerDetalle(vd[posMin], vr[posMin]);
end;

Procedure actualizar (var mae:maestro; var vd:vecDetalles; var vr:vecRegistros);
var i:rango; regm:informacion; min:info; cantLoc:integer;
begin
  reset(mae);
  leerMaestro(mae, regm);
  for i:= 1 to cant do begin
     reset(vd[i]);
     leerDetalle(vd[i], vr[i]);
  end;
  minimo(vd,vr,min);
  while(regm.codProv <> valorAlto) do begin
     if(regm.codProv = min.codProv) then begin
        if(regm.codLoc = min.codLoc) then begin
           regm.sinLuz := regm.sinLuz - min.conLuz;
           regm.sinAgua := regm.sinAgua - min.conAgua;
           regm.sinGas := regm.sinGas - min.conGas;
           regm.sinSanitarios := regm.sinSanitarios - min.sanitarios;
           regm.chapa:= regm.chapa - min.construidas;
           minimo(vd,vr,min);
           seek(mae, filepos(mae)-1);
           write(mae,regm);
        end;
     end;
     if(regm.chapa = 0) then
         cantLoc := cantLoc + 1;
     leerMaestro(mae, regm);
  end;
  writeln('cantidad de localidades sin viviendas de chapa', cantLoc);
  close(mae);
  for i:= 1 to cant do begin
     close(vd[i]);
  end;
end;

Var mae: maestro;
    vd: vecDetalles;
    vr: vecRegistros;
    i:rango;

Begin
  assign(mae, 'Maestro');
  for i:= 1 to cant do begin
    assign(vd[i], 'detalle' + intoStr(i));
  end;
  actualizar(mae,vd,vr);
End.




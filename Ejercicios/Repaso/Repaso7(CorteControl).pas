Program repaso7;
const valoralto = 9999;
type
   cadena = string [15];
   informacion = record
     cod_localidad:integer;
     nombre_localidad: cadena;
     cod_municipio:integer;
     cod_hospital:integer;
     nombre_municipio:cadena;
     nombre_hospital:cadena;
     cantPositivos:integer;
   end;

   archivo = file of informacion;

procedure leer (var arch: archivo; var dato:informacion);
begin
 if (not eof(arch)) then read (arch,dato)
 else dato.cod_localidad:= valoralto;
end;

Procedure listado (var arch:archivo; var t:text);
var total, totlocalidad, totmunicipio, tothospital: integer;
    localidad, municipio, hospital: cadena;
    reg: informacion;
begin
  reset(arch); rewrite(t);
  leer(arch,reg);
  total := 0;
  while(reg.cod_localidad <> valorAlto) do begin
     writeln('Localidad:', reg.nombre_localidad);
     localidad:= reg.nombre_localidad;// variable auxiliar para la localidad
     totlocalidad:= 0;
     while(localidad = reg.nombre_localidad) do begin
        writeln('Municipio:', reg.nombre_municipio);
        municipio:= reg.nombre_municipio; //variable auxiliar para el municipio
        totmunicipio:=0;
        while(localidad = reg.nombre_localidad) and (municipio = reg.nombre_municipio) do begin
           writeln('Hospital:', reg.nombre_hospital);
           hospital:= reg.nombre_hospital; //variable auxiliar para el hospital
           tothospital:=0;
           while(localidad = reg.nombre_localidad) and (municipio = reg.nombre_municipio) and (hospital = reg.nombre_hospital) do begin
                tothospital:= tothospital + reg.cantPositivos;
                leer(arch,reg);
           end;
           writeln('cantidad de casos en el hospital', reg.nombre_hospital,': ',reg.cantPositivos);
           totmunicipio:= totmunicipio + tothospital;
        end;
        writeln('cantidad de casos en el municipio', reg.nombre_Municipio,': ',totmunicipio);
        if(totmunicipio > 1500) then begin
           with reg do begin
               writeln(t,'localidad: ', nombre_localidad);
               writeln(t, 'cantidad de casos del municipio ', totmunicipio, 'municipio: ', municipio);
           end;
        end;
        totlocalidad := totlocalidad + totmunicipio;
     end;
     writeln('cantidad de casos en la localidad', reg.nombre_Localidad,': ', totlocalidad);
     total:= total + totlocalidad;
  end;
  writeln('total de casos en la provincia:', total);
  close(arch); close(t);
end;

var
 arch: archivo;
 t:text;

Begin
  assign (arch, 'unArchivo');
  assign(t,'unArchivo.txt');
  listado(arch,t);
End.


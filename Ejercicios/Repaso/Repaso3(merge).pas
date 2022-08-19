Program repaso3;
const
 valorAlto = 9999; cant = 5;
type
  rango = 1..cant;
  info = record
     cod_usuario:integer;
     fecha:integer;
     tiempo_sesion:integer;
  end;
  informacion = record
     cod_usuario:integer;
     fecha:integer;
     tiempo_total_sesiones_abiertas:integer;
  end;

  detalle = file of info;
  maestro = file of informacion;

  vecDetalles = array [rango] of detalle;
  vecRegistros = array [rango] of info;

Procedure leerDetalle(var arch:detalle; var dato:info);
begin
  if not eof (arch) then read(arch,dato)
  else dato.cod_usuario:= valorAlto;
end;

Procedure minimo(var vd:vecDetalles; var vr:vecRegistros; var min:info);
var i,posMin:rango;
begin
   min.cod_usuario:= valorAlto;
   min.fecha:= valorAlto;
   for i:= 1 to cant do begin
      if(vr[i].cod_usuario <= min.cod_usuario) and (vr[i].fecha < min.fecha) then begin //primero verifica que sea menor, si lo es entonces verifica la fecha. Si no es menor tiene que ser igual y despues verifica la fecha. si es mayor no entra ni verifica la fecha
          min:= vr[i];
          posMin:=i;
      end;
   end;
   leerDetalle(vd[posMin],vr[posMin]);
end;


Procedure generarMaestro(var mae:maestro; var vd:vecDetalles; var vr:vecRegistros);
var regm:informacion; i:rango; min:info;
begin
  rewrite(mae);
  for i:= 1 to cant do begin
    reset(vd[i]);
    leerDetalle(vd[i], vr[i]);
  end;
  minimo(vd,vr,min);
  while (min.cod_usuario <> valoralto) do begin
       regm.cod_usuario:= min.cod_usuario;
       regm.fecha:= min.fecha;
       regm.tiempo_total_sesiones_abiertas :=0;
       while (regm.cod_usuario = min.cod_usuario) and (regm.fecha = min.fecha) do begin
          regm.tiempo_total_sesiones_abiertas := regm.tiempo_total_sesiones_abiertas + min.tiempo_sesion;
          minimo(vd,vr,min);
       end;
       write(mae, regm);
  end;
  close(mae);
  for i:= 1 to cant do
     close(vd[i]);
end;

Var
 vd:vecDetalles;
 vr:vecRegistros;
 mae:maestro;

Begin
  assign(vd[1],'detalle1');
  assign(vd[2],'detalle2');
  assign(vd[3],'detalle3');
  assign(vd[4],'detalle4');
  assign(vd[5],'detalle5');
  assign(mae,'/var/log.');
  generarMaestro(mae,vd,vr);
End.

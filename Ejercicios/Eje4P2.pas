Program ejercicio4P2;
const valoralto = 9999;
type
  rango = 1..5;
  usuarioTotal = record
      cod_usuario:integer;
      fecha:integer;
      tiempo_total_sesiones_abiertas:integer;
  end;
  usuario = record
      cod_usuario: integer;
      fecha:integer;
      tiempo_sesion:integer;
  end;

  maestro = file of usuarioTotal;
  detalle = file of usuario;
  vecDet= array[rango] of detalle; //arreglo de archivos logicos (archivos detalle)
  vecReg= array[rango] of usuario; //arreglo de registros

Procedure leer (var archivo:detalle; var dato:usuario);
begin
   if (not eof(archivo)) then read (archivo, dato)
   else dato.cod_usuario := valoralto;
end;

Procedure minimo (var vd:vecDet; var vr:vecReg; var min:usuario);
var i, posMin: rango;
begin
    min.cod_usuario:= valorAlto;
    min.fecha:= valorAlto;
    for i:= 1 to 5 do begin
        if(vr[i].cod_usuario <= min.cod_usuario) and (vr[i].fecha < min.fecha) then begin
              min:= vr[i];
              posMin:= i;
        end;
    end;
    leer(vd[posMin], vr[posMin]);
end;

Procedure generarMaestro(var vd:vecDet; var mae:maestro); //recibe el vector con los nom logicos, el archivo maestro y el vector con los registros detalle
var regm:usuarioTotal; i:rango; min:usuario; vr:vecReg;
begin
  for i:= 1 to 5 do begin
      reset(vd[i]);
      leer(vd[i], vr[i]);
  end;
  rewrite(mae); //creo el maestro
  minimo(vr, min, vd); //busco el archivo detalle con el menor codigo de usuario y menor fecha
  while (min.cod_usuario <> valoralto) do begin
       regm.cod_usuario:= min.cod_usuario;
       regm.fecha:= min.fecha;
       regm.tiempo_total_sesiones_abiertas :=0;
       while (regm.cod_usuario = min.cod_usuario) and (regm.fecha = min.fecha) do begin
          regm.tiempo_total_sesiones_abiertas := regm.tiempo_total_sesiones_abiertas + min.tiempo_sesion;
          minimo(vr, min, vd);
       end;
       write(mae, regm);
  end;
  close(mae);
  for i:= 1 to 5 do
     close(det[i]);
end;

Var
    mae:maestro;
    det:vecDet;
Begin
  assign(det[1],'detalle1');
  assign(det[2],'detalle2');
  assign(det[3],'detalle3');
  assign(det[4],'detalle4');
  assign(det[5],'detalle5');
  assign(mae,'/var/log.');
  generarMaestro(det,mae);
End.

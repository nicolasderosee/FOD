Program Ejercicio1P2;
const valorAlto = 9999;
type
  str25 = string[25];
  empleado = record
      cod:integer;
      nom:str25;
      monto:real;
  end;

  archivo = file of empleado;

procedure leer (var arch:archivo; var dato:empleado);
begin
     if (not eof(arch)) then read (arch,dato) //leo empleado del archivo
     else dato.cod := valorAlto;
end;

Procedure compactar(var arch:Archivo; var archComp:archivo);
var e:empleado; total:double; act:empleado;
begin
   reset(arch); //abro el archivo existente
   rewrite(archComp); //creo el nuevo archivo
   leer(arch,e);//leo un empleado del archivo existente
   while(e.cod <> valorAlto) do begin
     act:=e;
     while(e.cod = act.cod) do begin //mientras sea el mismo empleado
         total:= total + e.monto; //totalizo el monto de todas las comiciones de un mismo empleado
         leer(arch,e); //leo otro empleado
     end;
     act.monto:=total;
     write(archComp,act); //escribo en el nuevo archivo unicos empleados
   end;
   close(arch); close(archComp);
end;


Var arch_logico:archivo; arch_compactado:archivo;
Begin
   assign(arch_logico,'ingresos_percibidos');
   assign(arch_compactado,'ingresos_compactos');
   compactar(arch_logico,arch_compactado);
   readln;
End.

//Suponga que se almacena en un archivo la información de ventas de una cadena de electrodomésticos. Dichas ventas han sido efectuadas
//por los vendedores de cada sucursal de cada ciudad de cada provincia del país. Luego, es necesario informar al gerente de ventas de la
//empresa el total de ventas producidas.
//El archivo se encuentra ordenado por provincia, ciudad, sucursal y vendedor.
//• Se debe informar el total de vendido en cada sucursal, ciudad y provincia, así como el total final.
//• En diferentes provincias pueden existir ciudades con el mismo nombre, o en diferentes ciudades pueden existir sucursales con igual denominación.

program ejemplo1;
const valoralto=”ZZZ”;
type
    nombre = string[30];
    RegVenta = record
       Vendedor: integer;
       MontoVenta: real;
       Sucursal: nombre;
       Ciudad: nombre;
       Provincia: nombre;
    end;
    Ventas = file of RegVenta;

procedure leer (var archivo: Ventas; var dato:RegVenta);
begin
 if (not eof(archivo)) then read (archivo,dato)
 else dato.provincia:= valoralto;
end;

var
 reg: RegVenta;
 archivo: Ventas;
 total, totprov, totciudad, totsuc: integer;
 prov, ciudad, sucursal: nombre;

{programa principal}
begin
 assign(archivo, 'archivoVentas');
 reset (archivo);
 leer(archivo, reg);
 total:= 0; //total general de la empresa
 while (reg.Provincia <> valoralto) do begin //mientras no llegue al fin de archivo
     writeln(“Provincia:”, reg.Provincia); //informo la provincia actual
     prov:= reg.Provincia; //me guardo la provincia actual
     totprov:= 0; //inicializo el contador de provincia en 0
     while (prov = reg.Provincia) do begin //mientras sea la misma provincia
        writeln(“Ciudad:”, reg.Ciudad); //informo la ciudad actual
        ciudad := reg.Ciudad;
        totciudad := 0
        while (prov = reg.Provincia) and (ciudad = reg.Ciudad) do begin //mientras sea la misma provincia y la misma ciudad
           writeln(“Sucursal:”, reg.Sucursal);  //informo sucursal actual
           sucursal := regSucursal;
           totsuc := 0;
           while ((prov=reg.Provincia) and (ciudad=reg.Ciudad) and (sucursal=regSucursal)) do begin //mientras sea la misma provincia, ciudad y sucursal
                 write(“Vendedor:”, reg.Vendedor); //informo el vendedor
                 writeln(reg.MontoVenta);
                 totsuc := totsuc + reg.MontoVenta; //totalizo sumando las ventas de la sucursal
                 leer(archivo, reg); //vuelvo a leer
           end;
           //cambia la provincia, la ciudad o la sucursal
           writeln(“Total Sucursal”, totsuc); //informo el total de la sucursal
           totciudad := totciudad + totsuc; //ese total se lo sumo al total de la ciudad
        end;
        //cambia la ciudad
        writeln(“Total Ciudad”, totciudad); //informo el total de la ciudad
        totprov := totprov + totciudad; //al total de la provincia le sumo el total de la ciudad
     end;
     //cambia la provincia
     writeln(“Total Provincia”, totprov); //informo el total de la provincia
     total := total + totprov, //al total de la empresa le sumo el total de la provincia
 end;
 writeln(“Total Empresa”, total);
 close (archivo);
end.

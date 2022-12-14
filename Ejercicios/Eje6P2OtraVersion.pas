program ejer6;
const
	dimF = 15;
	VALOR_ALTO = 9999;
type
	articulo = record
		cod:integer;
		nombre:string[15];
		descripcion:string[25];
		talle:integer;
		color:string[10];
		stock:integer;
		stockMin:integer;
		precio:real;
	end;

	actualizacion = record
		cod:integer;
		cantV:integer;
	end;
	
	archivo = file of articulo;
	archivo_detalle = file of actualizacion;
	
	arreglo_detalle = array [1..dimF] of archivo_detalle;
	arreglo_act = array[1..dimF] of actualizacion;
	
{==============================================================================================================================================================================}	

procedure leerArticulo(var datos:articulo);
begin
	with datos do begin
		write('Ingrese codigo del articulo: ');
		readln(cod);
		if( cod <> 0) then begin
			write('Ingrese nombre del articulo: ');
			readln(nombre);
			write('Ingrese descripcion del articulo: ');
			readln(descripcion);
			write('Ingrese color del articulo: ');
			readln(color);
			write('Ingrese talle: ');
			readln(talle);
			write('Ingrese stock actual del articulo: ');
			readln(stock);
			write('Ingrese stock minimo del articulo: ');
			readln(stockMin);
			write('Ingrese precio del articulo: ');
			readln(precio);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crearMaestro(var a:archivo);
var
	p:articulo;
begin

	writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE ARTICULO!! ');
	rewrite(a);
	leerArticulo(p);
	while(p.cod <> 0)do begin
		write(a, p);
		leerArticulo(p);
	end;
	close(a);
end;

{==========================================================================================================================================}

procedure leerDetalles(var v:arreglo_detalle);
var
	i: integer;
	datos: actualizacion;
	str_i: string;
begin
	writeln('- - - - - - - - LECTURA DE ARCHIVOS DETALLE - - - - - - - -');
	for i:= 1 to dimF do begin
		
		{abro el archivo de la posicion actual}
		
		Str(i, str_i);
		assign(v[i], 'detalle'+str_i);
		rewrite(v[i]);
		
		{lleno el archivo actual}
		
		writeln('Sucursal ', i, ':');
		writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE ARTICULO!!');
		write('Ingrese codigo de articulo: ');
		readln(datos.cod);
		while(datos.cod <> 0)do begin
			write('Ingrese cantidad vendida: ');
			readln(datos.cantV);
			write(v[i], datos);
			write('Ingrese codigo de producto: ');
			readln(datos.cod);
		end;
		close(v[i]); {cierro el actual}
	end;

end;

{==========================================================================================================================================}

procedure leer(var a:archivo_detalle; var dato:actualizacion);
begin
    if (not eof( a ))then 
		read (a, dato)
    else 
		dato.cod := VALOR_ALTO;
end;

{==========================================================================================================================================}

procedure getMin (var reg_det: arreglo_act; var min:actualizacion; var deta:arreglo_detalle);
var 
	i: integer;
	minCod:integer;
	minPos:integer;
begin
      { busco el m??nimo elemento del 
        vector reg_det en el campo cod,
        supongamos que es el ??ndice i }
    minPos := 1;
    minCod:=32767;
    for i:= 1 to dimF do begin    	
		if(reg_det[i].cod < minCod)then begin
			min := reg_det[i];
			minCod := reg_det[i].cod;
			minPos := i;
		end;
	end;
	leer(deta[minPos], reg_det[minPos]);
	
end;     

{==========================================================================================================================================}

procedure actualizarStock(var a:archivo; var detalles:arreglo_detalle);
var
	i:integer;
	min:actualizacion;
	regm:articulo;
	icast:string;
	reg_det: arreglo_act;
	totalvendido: integer;
	codact: integer;
begin
	for i:= 1 to dimF do begin
		Str(i,icast);
		assign (detalles[i], 'detalle'+icast); 
		reset( detalles[i] );
		leer( detalles[i], reg_det[i]);
		writeln('se abrio el archivo ', i);
	end;
	
	reset(a);
	getMin(reg_det, min, detalles); {busco el detalle minimo}
	while (min.cod <> VALOR_ALTO) do begin
		totalvendido := 0;
		codact := min.cod;
		while(codact = min.cod ) do begin
			totalvendido:= totalvendido + min.cantV;
			getMin (reg_det, min, detalles);
		end;
		
		read(a, regm);
		while(regm.cod <> codact)do 
			read(a, regm);
		regm.stock := regm.stock - totalvendido;
		
		seek(a, filepos(a)-1);
		write(a, regm);
	end;    
	for i:= 1 to dimF do begin
		close(detalles[i]);
	end;
	close(a);
end;

{==============================================================================================================================================================================}

procedure exportarTxt(var a:archivo; var txt:Text);
var
	regm:articulo;
begin
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a,regm);
		if(regm.stock < regm.stockMin)then
			with regm do
				writeln(txt,'Nombre de articulo: ', nombre,' descripcion: ',descripcion,' - stock disponible: ', stock,' - $', precio:2:2,'.');  	
	end;
	close(a);
	close(txt);
end;	
	
{Programa Principal}

var
	maestro : archivo;
	detalles : arreglo_detalle;
	txt: Text;
begin
	assign(maestro, 'maestro');
	assign(txt, 'texto.txt');
	crearMaestro(maestro);
	leerDetalles(detalles);
	ActualizarStock(maestro, detalles);
	exportarTxt(maestro, txt);
end.

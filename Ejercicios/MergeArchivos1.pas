//CADP inscribe a los alumnos que cursarán la materia en tres computadoras separadas.
//C/U de ellas genera un archivo con los datos personales de los estudiantes, luego son ordenados físicamente por otro proceso.
//El problema que tienen los JTP es generar un archivo maestro de la asignatura
//Precondiciones
	//El proceso recibe tres archivos con igual estructura
	//Los archivos están ordenados por nombre de alumno
	//Un alumno solo aparece una vez en el archivo
//Postcondición
	//Se genera el archivo maestro de la asignatura ordenado por nombre del alumno

program union_de_archivos;
const valoralto = 'zzzz';
type
  str30 = string[30];
  str10 = string[10];
  alumno = record
     nombre: str30;
     dni: str10;
     direccion: str30;
     carrera: str10;
  end;
  detalle = file of alumno;

var min,regd1,regd2,regd3: alumno;
    det1,det2,det3,maestro: detalle;

procedure leer (var archivo:detalle; var dato:alumno);
begin
 if (not eof(archivo)) then read (archivo, dato)
 else dato.nombre := valoralto;
end;

procedure minimo (var r1,r2,r3:alumno; var min:alumno);
begin
  if (r1.nombre<r2.nombre) and (r1.nombre<r3.nombre) then begin
      min := r1;
      leer(det1,r1);
  end
  else
     if (r2.nombre<r3.nombre) then begin
        min := r2;
        leer(det2,r2);
     end
     else begin
        min := r3;
        leer(det3,r3);
     end;
end;

begin
    assign (det1,'det1'); assign (det2,'det2'); assign (det3,'det3');
    assign (maestro, 'maestro');
    rewrite (maestro); //se crea un archivo maestro
    reset (det1); reset (det2); reset (det3);  //se abren archivos detalle existentes
    leer(det1, regd1); leer(det2, regd2); leer(det3, regd3); //se leen registros de cada detalle
    minimo(regd1, regd2, regd3, min); //se busca el registro más chico entre los detalles
    while (min.nombre <> valoralto) do
      begin
        write (maestro,min); //escribo en el archivo maestro el más chico
        minimo(regd1,regd2,regd3,min);
      end;
    close (maestro);
end.

 



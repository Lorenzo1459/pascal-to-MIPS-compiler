pRogRam Test;
//isso eh um commentari
(*isso tbm
eh um //comentario
comentario*)
type
	letra_minuscula = 'a'..'z';
	days = array [1..10] OF letra_minuscula;
	fees = real;
var
	a : integer;{ comentario //comentariodentro
	continua}
	b : real;
	c : real;

function maximo(num1, num2: integer): integer;
var
  resultado : integer;
begin
  if (num1 > num2) then
    resultado := num1
  else
    resultado := num2;
  maximo := resultado;
end;

procedure max(num3, num4 :integer);

begin
	if (num1 < num2) then
	writeln(num1)
	else
	writeln(num2);
end;

begin
	a := 4 + 1;
	b := 001;
	c := 1;
	max(a,b);
	max(b,c);
end.

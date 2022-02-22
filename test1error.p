pRogRam Test;
//isso eh um commentari
(*isso tbm
eh um //comentario
comentario*)
type
	letra_minuscula = 'a'..'z';
	days = array [1..10]  letra_minuscula;
	fees = real;
var
	a : real;{ comentario //comentariodentro
	continua}
	b * int;
	c : int

procedure max(num1, num2 :integer);

begin
	if (num1 < num2) then
	writeln(num1)
	else
	writeln(num2);
end;

begin
	a := 4.0;
	b := 001;
	c := 1;
	max(a,b);
	max(b,c);
end.

program function;
var
  a, b, yes : integer;

function maximo(num1, num2: integer): integer;
var
  resultado: integer;
begin
  if (num1 > num2) then
    resultado := num1
  else
    resultado := num2;
  maximo := resultado;
end;

begin
  a := 100;
  b := 200;
  yes = maximo(a, b);
end.

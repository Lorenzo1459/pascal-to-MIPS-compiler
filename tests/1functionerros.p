program funcao;
var
  a, b, max: integer;

function maximo(num1, num2: integer): string;
var
  resultado : integer;
begin
  if (num1 > num2) then
    resultado := num1
  else
    resultado := num2;
  maximo := resultado; /* SEMANTIC ERROR*/
end;

begin
  a := 100;
  b := 200;
  max := maximo(a, b);
end.

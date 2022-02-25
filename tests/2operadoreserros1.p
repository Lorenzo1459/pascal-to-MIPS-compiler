program operadores;
var
    a, b, c, d, f, g, h : integer;
    e : real;
    i, j, k : boolean;

begin
    a := 20;
    b := 10;
    z := 50;                          /*ERRO Z nao declarado*/
    c := a + b;
    d := a - b;
    e := a / b;
    h := a * b;

    if ( a > b ) then
      i := true
    else
      i := false;

    if ( a < b ) then
      i := false
    else
      i := true;

    if ( a >= b ) then
      i := true
    else
      i := false;

    if ( a <= b ) then
      i := false
    else
      i := true;

    j := true;
    k := true;

end.

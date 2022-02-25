program operadores;
var
    a, b, c: integer;
    e : real;
    i, j: boolean;
    m, n : string;
    o, t: array [1..10] of integer;

begin
    a := 20;
    b := 10;
    c := a + b;

    if ( a < b ) then
      i := true
    else
      i := false;

    if ( a <= b ) then
      i := false
    else
      i := true;

    m := 'oi' + 'teste';
    n := 1 + 'teste';

    o[i] := 1 +10;
    t := o;

end.

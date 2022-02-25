program operadores;
var
    a, b, c, d, f, g, h : integer;
    e : real;
    i, j, k : boolean;
    m, n : string;
    o, t: array [1..10] of integer;

begin
    a := 20;
    b := 10;

    c := n + b;             (*erro de tipo -> n é string*)
    d := a - b;
    e := a / b;
    h := a * b;

    if ( a < b ) then
      i := true
    else
      i := false;

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

    m := 'oi' + 'teste';
    n := 1 + 'teste';

    o[i] := a + 10;
    t := o;

end.

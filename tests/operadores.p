program operadores;
var
    a, b, c, d, f, g, h : integer;
    e : real;
    i, j, k : boolean;
begin
    a := 20;
    b := 10;

    c := a + b;
    d := a - b;
    e := a / b;
    h := a * b;
    f := a mod b;
    g := a div b;

    if ( a = b ) then
      i := true
    else
      i := false;

    if ( a <> b ) then
      i := false
    else
      i := true;

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

    i := j and k;
    i := j and then k;
    i := j or k;
    i := j or else k;
    i := not j;
end.

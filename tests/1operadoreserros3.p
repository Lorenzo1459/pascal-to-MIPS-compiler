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

    c := a + b;             
    d := a - b;
    e := a / b;
    h := a * b;
    f := a mod b;           
    g := e div b;              /*erro de operacao -> mod e div só operam com inteiros*/

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

    i := j and k;
    i := j or k;
    i := not j;

    m := 'oi' + 'teste';
    n := 1 + 'teste';

    o[i] := a + 10;
    t := o;

end.

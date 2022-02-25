program operadores;
var
    a, b, c, d, f, g, h : integer;
    e : real;
    o, t: array [1..10] of integer;
    i: string;

begin
    a := 20;
    b := 10;

    c := a + b;             
    d := a - b;
    e := a / b;
    h := a * b;

    // o[a] := e;              (*erro de tipos -> acesso do array só opera com inteiros*)
    o[a] := a + 10;
    t := o;  

end.

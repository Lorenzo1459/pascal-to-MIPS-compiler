program exArrays;
var
   n, k: array [1..10] of integer;   
   i, j: integer;

begin  
   n := k;
   repeat
       k[ i ] := i + 100;  
       i := i + 1;
    until i > 10;
   
   repeat
      // writeln('Element[', j, '] = ', n[j] ); 
      j := j + 1;
    until j > 10;
end.
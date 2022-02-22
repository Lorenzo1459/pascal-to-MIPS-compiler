program exGoto;
label 1;
var
   a, c: integer;
begin
   a := 10;
   c := 20;
   1: repeat
      if( c > 15 ) then
      begin
         a := a + 1;
         goto 1;
      end;
      c := a + 1;
   until a = 20;
end.

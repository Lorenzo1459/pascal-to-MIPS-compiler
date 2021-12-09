program exGoto;
label 1;
var
   a : integer;
begin
   a := 10;
   1: repeat
      if( a = 15 ) then
      begin
         a := a + 1;
         goto 1;
      end;
      a := a + 1;
   until a = 20;
end.

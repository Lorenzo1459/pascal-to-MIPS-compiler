program ifelseChecking;
var
   a, b, c : integer;
   d : string;

begin
   a := 100;
   c := 200;
   if( a < 200 ) then
     b := a + 3
   else
     b := c;

end.
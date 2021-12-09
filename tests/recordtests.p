program recordtests;
type
CartinhasPtr = ^ Cartinha;
Cartinhas = record
   nome: packed array [1..50] of char;
   artista: packed array [1..50] of char;
   flavor: packed array [1..256] of char;
end;

var
   carta1, carta2: CartinhasPtr;

begin
   new(carta1);
   new(carta2);

   carta1^.nome  := 'Tarmogoyf';
   carta1^.artista := 'Justin Murray';
   carta1^.flavor := 'What doesnt grow, dies. An what dies grows the tarmogoyf ';

   carta2^.nome := 'Life from the loam';
   carta2^.artista := 'Dan Mumford';
   carta2^.flavor := 'When there is no one left but the ravens, the Swarm will rise and rule all. —Lost prophecy of Svogthir';

   dispose(carta1);
   dispose(carta2);
end.

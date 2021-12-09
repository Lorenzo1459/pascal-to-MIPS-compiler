program recordtests;
type
Cartinhas = record
   nome: array [1..50] of char;
   artista: array [1..50] of char;
   flavor: array [1..256] of char;
end;

var
   carta1, carta2: Cartinhas;

begin

   carta1.nome  := 'Tarmogoyf';
   carta1.artista := 'Justin Murray';
   carta1.flavor := 'What doesnt grow, dies. An what dies grows the tarmogoyf ';

   carta2.nome := 'Life from the loam';
   carta2.artista := 'Dan Mumford';
   carta2.flavor := 'When there is no one left but the ravens, the Swarm will rise and rule all. —Lost prophecy of Svogthir';

end.
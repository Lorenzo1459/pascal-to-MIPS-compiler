program colorido;

type
  cor = (azul, vermelho, amarelo, verde, branco, preto, laranja);
  cores = set of cor;

procedure mostrarCores(c : cores);
const
  nomes : array [cor] of String[7] = ('azul', 'vermelho', 'amarelo', 'verde', 'branco', 'preto', 'laranja');
var
  cr : cor;
  s : String;
begin
  s := ' ';
  for cr := azul to verde do
    if cr in c then
      begin
        if ( s <> ' ') then
          s := s + ' , ';
          s := s + nomes[cr];
      end;
end;

var
  c : cores;
begin
  c := [red, amarelo, azul, branco, preto];
  mostrarCores(c);
end.

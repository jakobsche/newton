program Nullstelle2;

{$R *.res}

uses NewtonsMethod;

const
  hP = 8 {cm};
  V  = 1000 {cm³};

function f(k: Extended): Extended;
begin
  Result := k * (sqr(k) + 4 * hP / 9 * k) - 8 * V / 3
end;

function dqf(k: Extended): Extended;
begin
  Result := k * (3 * k + 8/9 * hP)
end;

var
  NewtonVerfahren: TNewtonsMethod;
  k, a, b, c, d, e, VT {Testvolumen}, VP {rot}, VQ {blau}: Extended;

begin
  NewtonVerfahren := TNewtonsMethod.Create(nil);
  with NewtonVerfahren do begin
    ToAnalyse := @f;
    Derivate := @dqf;
    InitialGuess := 1;
    k := Root
  end;
  a := k; b := 3 * k / 4; c := k / 2;
  d := 2 * k / 3; e := 3 * k / 4;
  VP := d * e * hP / 3;
  VQ := a * b * c;
  VT := VP + VQ;
  WriteLn;
  WriteLn('Die Nullstelle ist k = ', k, ' cm, berechnet mit Startwert ',
    NewtonVerfahren.InitialGuess, ' in ', NewtonVerfahren.CalcCycles, ' Schritten.');
  WriteLn('Probe:          f(k) = ', f(k), ' cm³');
  WriteLn;
  WriteLn('Antworten');
  WriteLn('a) a = ', a, ' cm');
  WriteLn('   b = ', b, ' cm');
  WriteLn('   c = ', c, ' cm');
  WriteLn;
  WriteLn('b) d = ', d, ' cm');
  WriteLn('   e = ', e, ' cm');
  WriteLn;
  WriteLn('c) rotes Volumen:  ', VP, ' cm³');
  WriteLn('   blaues Volumen: ', VQ, ' cm³');
  WriteLn;
  WriteLn('Probe: Das Gesamtvolumen beträgt ', VT / 1000, ' l.');
  WriteLn;
  NewtonVerfahren.Free
end.


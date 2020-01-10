unit NewtonsMethod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TSimpleFunction = function (x: Extended): Extended;
  TCalcStatus = (csOK, csIterating, csBadInitialGuess, csDerivateIsZero, csFunctionDivergent,
    csDifferencesNotToZero);

type

  { TNewtonsMethod }

  TNewtonsMethod = class(TComponent)
  private
    { Private declarations }
    FCalcCycles: QWord;
    FCalcStatus: TCalcStatus;
    FInitialGuess: Extended;
    FDerivate, FToAnalyse: TSimpleFunction;
    function GetRoot: Extended;
    function NewtonCycle(x: Extended): Extended;
  protected
    { Protected declarations }
  public
    { Public declarations }
    property CalcCycles: QWord read FCalcCycles;
    property CalcStatus: TCalcStatus read FCalcStatus write FCalcStatus;
    property ToAnalyse: TSimpleFunction read FToAnalyse write FToAnalyse;
      {Funktion, deren Nullstelle zu berechnen ist}
    property Derivate: TSimpleFunction read FDerivate write FDerivate;
      {Ableitung der zu untersuchenden Funktion}
    property Root: Extended read GetRoot;
  published
    { Published declarations }
    property InitialGuess: Extended read FInitialGuess write FInitialGuess;
  end;

procedure Register;

implementation

const
  MinTolerance = 1E-12;

procedure Register;
begin
  RegisterComponents('Math', [TNewtonsMethod]);
end;

{ TNewtonsMethod }

function TNewtonsMethod.GetRoot: Extended;
  procedure FirstCycle(out x1, d0, y0, y1: Extended);
  begin
    y0 := ToAnalyse(InitialGuess);
    if Abs(y0) <= MinTolerance then begin
      CalcStatus := csOK;
      d0 := 0;
      y0 := 0;
      y1 := 0;
      x1 := InitialGuess;
      Exit
    end;
    x1 := NewtonCycle(InitialGuess);
    case CalcStatus of
      csOK: begin
          d0 := 0;
          y0 := 0;
          y1 := 0;
          Exit
        end;
      csIterating:;
      else Exit;
    end;
    d0 := x1 - InitialGuess;
    y1 := ToAnalyse(x1);
    if y1 <> 0 then begin
      if Abs(y1) - MinTolerance >= Abs(y0) + MinTolerance then begin
        CalcStatus := csFunctionDivergent;
        Exit
      end
    end
    else CalcStatus := csOK;
  end;
  procedure FollowingCycle(x0, d0, y0: Extended; out x1, d1, y1: Extended);
  begin
    x1 := NewTonCycle(x0);
    case CalcStatus of
      csOK: begin
          d1 := 0;
          y1 := 0;
          Exit;
        end;
      csIterating:;
      else Exit;
    end;
    d1 := x1 - x0;
    if d1 <> 0 then
      if Abs(d1) - MinTolerance > Abs(d0) + MinTolerance then begin
        CalcStatus := csDifferencesNotToZero;
        Exit
      end;
    y1 := ToAnalyse(x1);
    if Abs(y1) > MinTolerance then begin
      if Abs(y1) - MinTolerance > Abs(y0) + MinTolerance then begin
        if CalcCycles > 100 then begin
          CalcStatus := csFunctionDivergent;
          Exit
        end
        else CalcStatus := csOK
      end
    end
    else CalcStatus := csOK;
  end;
var
  d0, d1, x1, y0, y1: Extended;
begin
  CalcStatus := csIterating;
  FCalcCycles := 0;
  FirstCycle(x1, d0, y0, y1);
  case CalcStatus of
    csOK: begin
        Result := x1;
        Exit
      end;
    csIterating: begin
        FollowingCycle(x1, d0, y0, x1, d1, y1);
        case CalcStatus of
          csOK: begin
              Result := x1;
              Exit
            end;
          csIterating: begin
              while (y1 <> 0) and (d1 <> 0) do begin
                FollowingCycle(x1, d1, y1, x1, d1, y1);
                case CalcStatus of
                  csOK: begin
                      Result := x1;
                      Exit
                    end;
                  csIterating:;
                  else Exit;
                end;
              end;
            end;
          end;
        end;
    end
end;

function TNewtonsMethod.NewtonCycle(x: Extended): Extended;
var
  y, dq: Extended;
begin
  y := ToAnalyse(x);
  if y = 0 then begin
    Result := x;
    CalcStatus := csOK;
    Exit
  end;
  dq := Derivate(x);
  if dq = 0 then begin
    CalcStatus := csDerivateIsZero;
    Exit
  end;
  Result := x - y / dq;
  Inc(FCalcCycles)
end;

end.

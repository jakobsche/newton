{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit newton;

interface

uses
  NewtonsMethod, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('NewtonsMethod', @NewtonsMethod.Register);
end;

initialization
  RegisterPackage('newton', @Register);
end.

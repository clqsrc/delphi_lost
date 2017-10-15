unit base64;

//delphi7中EncdDecd单元EncodeString函数好像也是base64编码函数

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  EncdDecd,
  IdGlobal,
  Dialogs, StdCtrls;


function StrToBase64(const str: AnsiString): AnsiString;
//function Base64ToStr(const Base64: string): string;
function Base64ToStr(const Base64: AnsiString): AnsiString;


implementation

function StrToBase64(const str: string): string;
var
  s:AnsiString;
begin
  //Result := EncdDecd.EncodeString(str);exit;
  //Result := EncdDecd.EncodeBase64(str);
  s := str;
  Result := EncdDecd.EncodeBase64(PAnsiChar(s), Length(s));
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);//去掉回车换行,因为有些系统不支持
end;

function Base64ToStr(const Base64: AnsiString): AnsiString;
var
  buf:TBytes;
begin
  //Result := EncdDecd.DecodeString(Base64);Exit;//
  buf := EncdDecd.DecodeBase64(Base64);
  //ShowMessage(PAnsiChar(@buf[0]));

  //Result := stringof(buf);Exit;//这个所谓的标准做法的结果也不对,因为它内部还是转了码的

  //BytesToRaw(buf, head, SizeOf(TProtoHead));
  //Result := BytesToString(buf, TIdTextEncoding.ASCII);Exit;//不对,即使是用了 ASCII 仍然进行了转码,没法得到原始数据
  //Result := BytesToString(buf, TIdTextEncoding.UTF8);

  //Result := (PAnsiChar(@buf[0]));
  SetLength(Result, Length(buf));
  //SetAnsiString(@Result, @buf[0], Length(buf));
  //StrLCopy(PAnsiChar(result), @buf[0], Length(buf));//不行会在 #0 时出错
  CopyMemory(PAnsiChar(result), @buf[0], Length(buf));

end;


end.

unit socketplus;

//稍微扩展一下 socket 而已
//目前主要用于分析网络协议

//author:clq
//from:2017

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, Sockets, WinSock;

function CreateTcpClient:TSocket;

function ConnectIP(so:TSocket; const ip:string; port:Integer):Integer;
function SendBuf(so:TSocket; const s:string):Integer;
//简单的协议分析建议直接在定时器调用即可
function RecvBuf(so:TSocket):string;
//只否可读取
function SelectRead(so:TSocket):Integer;
//只否可发送
function SelectSend(so:TSocket):Integer;

implementation

function CreateTcpClient:TSocket;
begin
  Result := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
end;  

function InitWinSocket: Integer;
var
  wData: WSAData;
begin
  //Result := WSAStartup(MakeWord(2, 2), wData) = 0;
  Result := WSAStartup(MakeWord(2, 2), wData);
end;

function ConnectIP(so:TSocket; const ip:string; port:Integer):Integer;
var
  //sock: TSocket;
  SockAddr: TSockAddr;
begin

  Result := 1;


  FillChar(SockAddr, sizeof(SockAddr), $0);

  SockAddr.sin_family := AF_INET;
  SockAddr.sin_port := htons(Port);
  SockAddr.sin_addr.S_addr := inet_addr(PChar(ip));

  if connect(so, SockAddr, sizeof(SOCKADDR_IN)) = SOCKET_ERROR then
  begin
    //ShowMessageFmt('connect socket error，[%d]', [WSAGetLastError]);
    MessageBox(0, 'connect socket error', '', 0);
    Result := 0;
    Exit;
  end;

end;

//尚未精测试,可能有误
function SendBuf(so:TSocket; const s:string):Integer;
var
  r,count:Integer;
  p:PAnsiChar;
begin
  r := 0;
  Result := 0;
  count := 0;
  p := @s[1];

  while Result<Length(s) do
  begin
    //r := send(so, s[1], Length(s), 0)      s[1+Result]
    r := send(so, p^, Length(s)-Result, 0);
    if  r > 0 then
    begin
      Result := Result + r;
      p := p + r;
    end;


    inc(count);

    if count>10 then
    begin
      MessageBox(0, 'send error', '', 0);

      Exit;
    end;  

  end;

end;

function RecvBuf(so:TSocket):string;
var
  buf:array[0..1024] of AnsiChar;
  r:Integer;
  s:string;
begin

  FillChar(buf, sizeof(buf), $0);

  s := '';
  Result := '';

  r := recv(so, buf, SizeOf(buf)-1, 0); //留下一个 #0 结尾
  if r > 0 then
  begin
    SetLength(s, r);
    //Move(buf, s, r);
    Move(buf, s[1], r);
  end;

  if r = 0 then //一般都是断开了
  begin
    MessageBox(0, 'recv error.[socket close]', '', 0);

    Exit;
  end;

  Result := s;

end;

//是否可读取
function SelectRead(so:TSocket):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
begin
  Result := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := 0; //秒
  timeout.tv_usec := 500;  //毫秒
  timeout.tv_usec := 0;  //毫秒

  if select( 0, @fd_read, nil, nil, @timeout ) > 0 then //至少有1个等待Accept的connection
    Result := 1;

end;  

//是否可发送
function SelectSend(so:TSocket):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
begin
  Result := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := 0; //秒
  timeout.tv_usec := 500;  //毫秒
  timeout.tv_usec := 0;  //毫秒

  if select( 0, nil, @fd_read,  nil, @timeout ) > 0 then //至少有1个等待Accept的connection
    Result := 1;

end;  


end.



















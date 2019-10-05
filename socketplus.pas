unit socketplus;

//��΢��չһ�� socket ����
//Ŀǰ��Ҫ���ڷ�������Э��

//author:clq
//from:2017

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  Math,
  IdTCPClient, Sockets, WinSock;

type
  TCmds = array of string;  

function CreateTcpClient:TSocket;

function ConnectIP(so:TSocket; const ip:string; port:Integer):Integer;
function ConnectHost(so:TSocket; const host:string; port:Integer):Integer;
function SendBuf(so:TSocket; const s:string):Integer;
//�򵥵�Э���������ֱ���ڶ�ʱ�����ü���
function RecvBuf(so:TSocket; var err:Integer):string;
//ֻ��ɶ�ȡ
function SelectRead(so:TSocket):Integer;
//ֻ��ɷ���
function SelectSend(so:TSocket):Integer;
//����Ϊ������ģʽ
procedure SetNoBlock(so:TSocket);

//����ʵ��һ���ַ����ָ������������������Ǻܳ��õģ��ο��������� github ��Ŀ
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/SocketTest1.java
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/book_11/socket_test1.c
//����һ������,����Ƚϼ򵥾��ǰ��ո���зָ�������
//void DecodeCmd(lstring * line, char sp, char ** cmds, int cmds_count)
function DecodeCmd(line:string; sp:AnsiChar; cmds_count:string):TCmds;

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
    //ShowMessageFmt('connect socket error��[%d]', [WSAGetLastError]);
    MessageBox(0, 'connect socket error', '', 0);
    Result := 0;
    Exit;
  end;

end;

//clq �������¼ӵĺ�����Ŀ���ǿ��Ը������������ʣ�����ԭ���Ĵ���ֻ�ܷ��ʾ�����
function ConnectHost(so:TSocket; const host:string; port:Integer):Integer;
var
  addr:TSockAddrIn;
  is_connect:Integer;
  err:Integer;
  address:PAnsiChar;
  pHost:PHostEnt;
begin
  Result := 1;

	//const char * address = host;
	address := PAnsiChar(host);
	is_connect := 0;
	err := 0;
	
	// Create an address structure and clear it
	//struct sockaddr_in addr;
	//memset(&addr, 0, sizeof(addr));
	FillChar(addr, 0, sizeof(addr));

	// Fill in the address if possible//�ȳ��Ե���IP������
	addr.sin_family := AF_INET;
	addr.sin_addr.s_addr := inet_addr(address);
	
	// Was the string a valid IP address?//�������IP�͵�������������
	if (addr.sin_addr.s_addr = -1) then
	begin
		// No, so get the actual IP address of the host name specified
		//struct hostent *pHost;
		pHost := gethostbyname(address);

		//if (pHost != NULL)
		if (pHost <> nil) then
		begin
			if (pHost.h_addr = nil) then
				begin Result := 0; exit; end; //return 0;//false;

			//addr.sin_addr.s_addr := ((struct in_addr *)pHost->h_addr)->s_addr;
			//addr.sin_addr.s_addr := PInAddr((pHost.h_addr)).s_addr; //���ֱ�ӷ����� C ���ԵĴ��벢����ȷ
			//addr.sin_addr.S_un_b := PInAddr((pHost.h_addr)).S_un_b;   //�����˼��ͬ�ϣ�Ҳ�ǲ���//��ʵ������ԭ������ pHost.h_addr �Ľ������ char ��ָ�룬���� char ��ָ���ָ�룬ԭ���ǵ�ַ�����ж������ windows �Զ���ַ����ķ���һ�������� #0 ��β�� #0 �ַ����������صģ���֪����������ῴ������һ��ע��...
      //������������ȷ�ģ�����������һ�㣬����ֱ�Ӹ����ڴ�
      addr.sin_addr.S_un_b.s_b1 := (pHost.h_addr^)[0];
      addr.sin_addr.S_un_b.s_b2 := (pHost.h_addr^)[1];
      addr.sin_addr.S_un_b.s_b3 := (pHost.h_addr^)[2];
      addr.sin_addr.S_un_b.s_b4 := (pHost.h_addr^)[3];

      //�������Ҳ����ȷ�ģ�������Ϊ��ָ��������Եø������
      //addr.sin_addr.S_un_b := PInAddr(pHost.h_addr^).S_un_b;

      //delphi7 ���ڲ����� TIpSocket.LookupHostAddr ��ȡ��һ���ַ�����ַ���ٵ��� inet_addr ת����̫�����˶��Ҳ���ѧ
      //function TIpSocket.LookupHostAddr(const hn: string): TSocketHost;
      //var
      //  h: PHostEnt;
      //begin
      //  Result := '';
      //  if hn <> '' then
      //  begin
      //    if hn[1] in ['0'..'9'] then
      //    begin
      //      if inet_addr(pchar(hn)) <> INADDR_NONE then
      //        Result := hn;
      //    end
      //    else
      //    begin
      //      h := gethostbyname(pchar(hn));
      //      if h <> nil then
      //        with h^ do
      //        Result := format('%d.%d.%d.%d', [ord(h_addr^[0]), ord(h_addr^[1]),
      //      		  ord(h_addr^[2]), ord(h_addr^[3])]);
      //    end;
      //  end
      //  else Result := '0.0.0.0';
      //end;

		end
		else
			begin Result := 0; exit; end; //return 0;//false;
	end;

	addr.sin_port := htons(port);
	
	//���أ�-1 ����ʧ�ܣ�0 ���ӳɹ�
	if (connect(so, addr, sizeof(addr)) = 0) then
	begin
		is_connect := 1;//true;
	end
	else
	begin
		is_connect := 0;//false;
		//����ʧ��

    //PrintError(0);
		//err := WSAGetLastError(); //��ʵ����� GetLastError ��һ����

    //MessageBox(0, "connect socket error", "", 0);
    is_connect := 0;

    //PrintError(err);

    //if (INVALID_SOCKET == so) printf("connect error:INVALID_SOCKET\r\n");		
	end;
	
	result := is_connect;
end;//

//��δ��ȷ����,��������
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

function RecvBuf(so:TSocket;var err:Integer):string;
var
  buf:array[0..1024] of AnsiChar;
  r:Integer;
  s:string;
begin

  FillChar(buf, sizeof(buf), $0);

  s := '';
  Result := '';
  err := 0;

  r := recv(so, buf, SizeOf(buf)-1, 0); //����һ�� #0 ��β
  if r > 0 then
  begin
    SetLength(s, r);
    //Move(buf, s, r);
    Move(buf, s[1], r);
  end;

  if r = 0 then //һ�㶼�ǶϿ���
  begin
    //��ʽ�����в�����������//MessageBox(0, 'recv error.[socket close]', '', 0);
    err := 1;

    Exit;
  end;

  Result := s;

end;

//�Ƿ�ɶ�ȡ
function SelectRead(so:TSocket):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
begin
  Result := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := 0; //��
  timeout.tv_usec := 500;  //����
  timeout.tv_usec := 0;  //����

  if select( 0, @fd_read, nil, nil, @timeout ) > 0 then //������1���ȴ�Accept��connection
    Result := 1;

end;  

//�Ƿ�ɶ�ȡ
function SelectRead_TimeOut(so:TSocket; timeout_sec:Integer):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
begin
  Result := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := timeout_sec; //��
  timeout.tv_usec := 500;  //����
  timeout.tv_usec := 0;  //����

  if select( 0, @fd_read, nil, nil, @timeout ) > 0 then //������1���ȴ�Accept��connection
    Result := 1;

end;  

//�Ƿ�ɷ���
function SelectSend(so:TSocket):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
begin
  Result := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := 0; //��
  timeout.tv_usec := 500;  //����
  timeout.tv_usec := 0;  //����

  if select( 0, nil, @fd_read,  nil, @timeout ) > 0 then //������1���ȴ�Accept��connection
    Result := 1;

end;

//����Ϊ������ģʽ 
//void SetNoBlock(SOCKET so)
procedure SetNoBlock(so:TSocket);
var
  arg:Integer;
begin
	//u_long arg = 0; //�����и�����,32λ���� 4 �ֽ�,64 λ�¿����� 8 �ֽ�,������ 64 λ�����´�����Լ�������
	
	//���ȣ�����ͨѶΪ������ģʽ
	arg := 1;
	//ioctlsocket(so, FIONBIO, &arg);
	ioctlsocket(so, FIONBIO, arg);

end;//


//����ʵ��һ���ַ����ָ������������������Ǻܳ��õģ��ο��������� github ��Ŀ
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/SocketTest1.java
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/book_11/socket_test1.c
//����һ������,����Ƚϼ򵥾��ǰ��ո���зָ�������
//void DecodeCmd(lstring * line, char sp, char ** cmds, int cmds_count)
function DecodeCmd(line:string; sp:AnsiChar; cmds_count:string):TCmds;
//var
//  sl:TStringList; //Delimiter, DelimitedText ���ָ��ַ�����ʵ��������ģ���Ҫ�ǶԿո�� #0 Ҳ�ỻ�еȣ�����������ʵ��
var
  i,index:Integer;
  cmd:string;
  c:AnsiChar;
begin
  //�� 64 ��Ԥ�ȷ���ĺ���
  //SetLength(Result, 64);

  index := 0;
  cmd := '';

  for i := 1 to Length(line) do
  begin
    c := line[i];


    if c = sp then
    begin
      SetLength(Result, index+1);
      Result[index] := cmd;
      
      index := index +1;
      Continue;
    end;  

    cmd := cmd + c;
  end;

  //�������ʣ���
  if Length(cmd)>0 then
  begin
    index := index +1;
    
    SetLength(Result, index+1);
    Result[index] := cmd;
  end;

  //�� 64 ��Ԥ�ȷ���ĺ���
  SetLength(Result, max(64, Length(Result)));

end;


end.



















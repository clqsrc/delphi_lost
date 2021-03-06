unit socketplus;

//稍微扩展一下 socket 而已
//目前主要用于分析网络协议

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
//直接来自 SendBuf ，只是不 sleep 等待而已
function SendBuf_NoBlock(so:TSocket; const s:string):Integer;
function SendBuf_TimeOut(so:TSocket; const s:string; TimeOut_second:Integer):Integer;
//简单的协议分析建议直接在定时器调用即可
function RecvBuf(so:TSocket; var err:Integer):string;
//是否可读取
function SelectRead(so:TSocket):Integer;

//是否可读取,并判断是否已断开连接
//2020 已经连接的情况下调用，可以判断连接是否已经断开
function SelectRead_CheckClose(so:TSocket; var is_close:Integer):Integer;

//是否可发送
function SelectSend(so:TSocket):Integer;
//设置为非阻塞模式
procedure SetNoBlock(so:TSocket);

//这其实是一个字符串分隔函数，在网络编程中是很常用的，参考另外两个 github 项目
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/SocketTest1.java
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/book_11/socket_test1.c
//解码一行命令,这里比较简单就是按空格进行分隔就行了
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
    //ShowMessageFmt('connect socket error，[%d]', [WSAGetLastError]);
    MessageBox(0, 'connect socket error', '', 0);
    Result := 0;
    Exit;
  end;

end;

//clq 这是我新加的函数，目的是可以根据域名来访问，并且原来的代码只能访问局域网
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

	// Fill in the address if possible//先尝试当做IP来解析
	addr.sin_family := AF_INET;
	addr.sin_addr.s_addr := inet_addr(address);
	
	// Was the string a valid IP address?//如果不是IP就当做域名来解析
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
			//addr.sin_addr.s_addr := PInAddr((pHost.h_addr)).s_addr; //这个直接翻译自 C 语言的代码并不正确
			//addr.sin_addr.S_un_b := PInAddr((pHost.h_addr)).S_un_b;   //这个的思想同上，也是不对//其实真正的原因在于 pHost.h_addr 的结果不是 char 的指针，而是 char 的指针的指针，原因是地址可能有多个，而 windows 对多个字符串的返回一向是两个 #0 结尾的 #0 字符串组来返回的，我知道大多数个会看不懂这一段注释...
      //下面的这个是正确的，不过啰嗦了一点，可以直接复制内存
      addr.sin_addr.S_un_b.s_b1 := (pHost.h_addr^)[0];
      addr.sin_addr.S_un_b.s_b2 := (pHost.h_addr^)[1];
      addr.sin_addr.S_un_b.s_b3 := (pHost.h_addr^)[2];
      addr.sin_addr.S_un_b.s_b4 := (pHost.h_addr^)[3];

      //下面这个也是正确的，不过因为有指针操作，显得更难理解
      //addr.sin_addr.S_un_b := PInAddr(pHost.h_addr^).S_un_b;

      //delphi7 的内部类用 TIpSocket.LookupHostAddr 先取到一个字符串地址组再调用 inet_addr 转换，太啰嗦了而且不科学
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
	
	//返回：-1 连接失败；0 连接成功
	if (connect(so, addr, sizeof(addr)) = 0) then
	begin
		is_connect := 1;//true;
	end
	else
	begin
		is_connect := 0;//false;
		//连接失败

    //PrintError(0);
		//err := WSAGetLastError(); //其实这个和 GetLastError 是一样的

    //MessageBox(0, "connect socket error", "", 0);
    is_connect := 0;

    //PrintError(err);

    //if (INVALID_SOCKET == so) printf("connect error:INVALID_SOCKET\r\n");		
	end;
	
	result := is_connect;
end;//

//尚未精确测试,可能有误//这个其实是原来的 SendBuf 函数，需要等待一段时间，如果不想，则使用 SendBuf_NoBlock
function SendBuf_TimeOut(so:TSocket; const s:string; TimeOut_second:Integer):Integer;
var
  r,count:Integer;
  p:PAnsiChar;
  buf_len:Integer;
begin
  r := 0;
  Result := 0;
  count := 0;
  p := @s[1];

  while Result<Length(s) do
  begin
    //r := send(so, s[1], Length(s), 0)      s[1+Result]
    buf_len := Length(s)-Result;
    buf_len := Min(buf_len, 4096);

    //r := send(so, p^, Length(s)-Result, 0);     ll 似乎要控制一下最大长度，要不一次发不出去 //例如 unit Forms; 的整个文件
    r := send(so, p^, buf_len, 0);     //ll 似乎要控制一下最大长度，要不一次发不出去 //例如 unit Forms; 的整个文件

    if  r > 0 then
    begin
      Result := Result + r;

      if Result >= Length(s) then Exit; //安全一点，长度超过就不要操作指针了
      p := p + r;

      Continue;
    end;


    inc(count);
    Sleep(500);  //如果是太长的数据太是要 sleep 一下，等待操作系统把数据发送后再发下一个数据块//以 226k 的 Forms.pas 为例子，发送 10 次入可成功，性能还是很好的

    //if count>10 then
    if count > TimeOut_second * 2 then
    begin
      //MessageBox(0, 'send error', '', 0);

      Result := -1;

      Exit;
    end;

  end;

end;

//尚未精确测试,可能有误//大概最多等待 10 * 0.5 = 5 秒
function SendBuf(so:TSocket; const s:string):Integer;
begin

  Result := SendBuf_TimeOut(so, s, 5);


end;

//直接来自 SendBuf ，只是不 sleep 等待而已
function SendBuf_NoBlock(so:TSocket; const s:string):Integer;
var
  r,count:Integer;
  p:PAnsiChar;
  buf_len:Integer;
begin
  r := 0;
  Result := 0;
  count := 0;
  p := @s[1];

  while Result<Length(s) do
  begin
    //r := send(so, s[1], Length(s), 0)      s[1+Result]
    buf_len := Length(s)-Result;
    buf_len := Min(buf_len, 4096);

    //r := send(so, p^, Length(s)-Result, 0);     ll 似乎要控制一下最大长度，要不一次发不出去 //例如 unit Forms; 的整个文件
    r := send(so, p^, buf_len, 0);     //ll 似乎要控制一下最大长度，要不一次发不出去 //例如 unit Forms; 的整个文件

    if  r > 0 then
    begin
      Result := Result + r;

      if Result >= Length(s) then Exit; //安全一点，长度超过就不要操作指针了
      p := p + r;

      Continue;
    end;


    inc(count);
    ////Sleep(500);  //如果是太长的数据太是要 sleep 一下，等待操作系统把数据发送后再发下一个数据块//以 226k 的 Forms.pas 为例子，发送 10 次入可成功，性能还是很好的

    if count>10 then
    begin
      //MessageBox(0, 'send error', '', 0);

      Result := -1;

      Exit;
    end;

  end;

end;

function RecvBuf(so:TSocket;var err:Integer):string;
var
  buf:array[0..1024] of AnsiChar;
  r:Integer;
  s:string;
  eno:Integer;
begin

  FillChar(buf, sizeof(buf), $0);

  s := '';
  Result := '';
  err := 0;

  r := recv(so, buf, SizeOf(buf)-1, 0); //留下一个 #0 结尾
  if r > 0 then
  begin
    SetLength(s, r);
    //Move(buf, s, r);
    Move(buf, s[1], r);
  end;

  if r = 0 then //一般都是断开了
  begin
    //正式环境中不能这样处理//MessageBox(0, 'recv error.[socket close]', '', 0);
    err := 1;

    Exit;
  end;

  //if (r <= 0)
  if (r < 0) then
  begin
    //到了连接被断开的时候WSAGetLastError返回既不是WSAECONNRESET也不是WSAECONNABORT。。。
    eno := 0;
    eno := WSAGetLastError();

    //if (eno == WSAECONNRESET && eno == WSAECONNABORTED)
    ////if (eno != WSAEWOULDBLOCK) then//按 delphi ScktComp.pas 的源码,返回值为 0 时是不处理的,当返回值为 -1 时只要判断是否为 WSAEWOULDBLOCK 就可以了//发送时也是一样的
    //2019 断开 wifi 还是测不出的，所以还是手工判断心跳最好
    if (eno <> WSAEWOULDBLOCK) then//按 delphi ScktComp.pas 的源码,返回值为 0 时是不处理的,当返回值为 -1 时只要判断是否为 WSAEWOULDBLOCK 就可以了//发送时也是一样的
    begin
      //is_connect = false;//断开了

      //正式环境中不能这样处理//MessageBox(0, 'recv error.[socket close]', '', 0);
      err := 1;

      Exit;
    end;

  end;

  Result := s;

end;

//是否可读取
//2020 其实只返回 0 和 1 是不对的，因为实际上有3种情况：
//socket 有数据，可读取
//socket 无数据，不可读取
//socket 出错了,比如 socket 被关闭了,socket 还没连接上等等
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


//2020 已经连接的情况下调用，可以判断连接是否已经断开
//一般是在 socket 函数返回 -1 的时候进行检查，因为返回 -1 的时候大多时出现了错误（可能是对方直接断开，或者本地直接 closesocket等等）
//这个是 windows 专用的，linux 下似乎应该是判断 errno
function Windows_CheckSocketClose_AtSocketError(so:TSocket):Integer;
var
  eno:Integer;
  is_connect:Integer;
  is_close:Integer;
begin
  Result := 0; //没断开
  is_connect := 1; //没断开
  is_close := 0; //没断开

  //if (r < 0) then
  begin
    //到了连接被断开的时候WSAGetLastError返回既不是WSAECONNRESET也不是WSAECONNABORT。。。
    eno := 0;
    eno := WSAGetLastError();

    //if (eno == WSAECONNRESET && eno == WSAECONNABORTED)
    ////if (eno != WSAEWOULDBLOCK) then//按 delphi ScktComp.pas 的源码,返回值为 0 时是不处理的,当返回值为 -1 时只要判断是否为 WSAEWOULDBLOCK 就可以了//发送时也是一样的
    //2019 断开 wifi 还是测不出的，所以还是手工判断心跳最好
    if (eno <> WSAEWOULDBLOCK) then//按 delphi ScktComp.pas 的源码,返回值为 0 时是不处理的,当返回值为 -1 时只要判断是否为 WSAEWOULDBLOCK 就可以了//发送时也是一样的
    begin
      //is_connect = false;//断开了

      //正式环境中不能这样处理//MessageBox(0, 'recv error.[socket close]', '', 0);
      //err := 1;
      is_connect := 0;
      is_close := 1;

      //Exit;
    end;

  end;  

  Result := is_close;
end;  

//2020 已经连接的情况下调用，可以判断连接是否已经断开
function SelectRead_CheckClose(so:TSocket; var is_close:Integer):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
  r:Integer;
begin
  Result := 0;  //无数据可读取

  is_close := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := 0; //秒
  timeout.tv_usec := 500;  //毫秒
  timeout.tv_usec := 0;  //毫秒

  r := select( 0, @fd_read, nil, nil, @timeout );

  if  r > 0 then //至少有1个等待Accept的connection   //有数据可读取
    Result := 1;

  if r < 0 then //返回值为 -1 时就是错误了
  begin
    if 1 = Windows_CheckSocketClose_AtSocketError(so)
    then is_close := 1;  //一般来说这样的话就确实是断开了
  end;  

end;

//是否可读取
function SelectRead_TimeOut(so:TSocket; timeout_sec:Integer):Integer;
var
  fd_read:TFDSet;
  timeout : TTimeVal;
begin
  Result := 0;

  FD_ZERO( fd_read );
  FD_SET(so, fd_read );

  timeout.tv_sec := timeout_sec; //秒
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

//设置为非阻塞模式 
//void SetNoBlock(SOCKET so)
procedure SetNoBlock(so:TSocket);
var
  arg:Integer;
begin
	//u_long arg = 0; //这里有个问题,32位下是 4 字节,64 位下可能是 8 字节,所以在 64 位环境下大家再自己测试下
	
	//首先，设置通讯为非阻塞模式
	arg := 1;
	//ioctlsocket(so, FIONBIO, &arg);
	ioctlsocket(so, FIONBIO, arg);

end;//


//这其实是一个字符串分隔函数，在网络编程中是很常用的，参考另外两个 github 项目
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/SocketTest1.java
//https://github.com/clqsrc/c_lib_lstring/blob/master/email_book/book_11/socket_test1.c
//解码一行命令,这里比较简单就是按空格进行分隔就行了
//void DecodeCmd(lstring * line, char sp, char ** cmds, int cmds_count)
function DecodeCmd(line:string; sp:AnsiChar; cmds_count:string):TCmds;
//var
//  sl:TStringList; //Delimiter, DelimitedText 来分隔字符串其实是有问题的（主要是对空格和 #0 也会换行等），这里重新实现
var
  i,index:Integer;
  cmd:string;
  c:AnsiChar;
begin
  //给 64 个预先分配的好了
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

  //如果还有剩余的
  if Length(cmd)>0 then
  begin
    index := index +1;
    
    SetLength(Result, index+1);
    Result[index] := cmd;
  end;

  //给 64 个预先分配的好了
  SetLength(Result, max(64, Length(Result)));

end;


end.



















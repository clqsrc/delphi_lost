unit UnitWin10;

//win10 兼容性的单元

interface

uses
  ShlObj, shellapi, windows, SysUtils, Dialogs,
  tlhelp32,
  forms;

//win10 下用户可写的目录

(*
uses System.IOUtils;

//例如 C:\Users\administrator\AppData\Roaming
procedure TForm1.FormCreate(Sender: TObject);
var
  S: string;
begin
  { 三种方法结果一致: C:\Users\wy\AppData\Roaming }
  S := GetHomePath;                       // SysUtils, 能跨平台且简单, 在 Windows 下使用 SHGetFolderPath 完成
  S := TPath.GetHomePath;                 // System.IOUtils
  S := GetEnvironmentVariable('APPDATA'); // 以前一直用这个
end;
*)

//取 windows10 下的程序目录
//例如 C:\Users\administrator\AppData\Roaming
function AppPath(const appname:string; create:boolean=true):string;

//win10下取程序目录下的配置文件,如果在 win10 的 appdata 中没有的话就先复制
function win10ConfigFile(const appname:string; const fn:string):string;

//是否有管理员权限
function IsAdmin: Boolean;
//确实可用//判断程序是否以管理员身份运行
//http://blog.csdn.net/donglinshengan/article/details/18416645
//BOOL FindUacToken_v2()
function IsAdmin_v2: Boolean;

//写入文件的权限
function SetAdmin: Boolean;


implementation

//xp 以后版本,用户权限提醒
function WindowsVersion_highXP: Boolean;
var
  VI: TOSVersionInfoA;
begin
  Result := False;

  VI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);

//DWORD dwOSVersionInfoSize;       //在使用GetVersionEx之前要将此初始化为结构的大小
//
//DWORD dwMajorVersion;               //系统主版本号
//
//DWORD dwMinorVersion;               //系统次版本号
//
//DWORD dwBuildNumber;               //系统构建号
//
//DWORD dwPlatformId;                  //系统支持的平台(详见附1)
//
//TCHAR szCSDVersion[128];          //系统补丁包的名称
//
//WORD wServicePackMajor;            //系统补丁包的主版本
//
//WORD wServicePackMinor;            //系统补丁包的次版本
//
//WORD wSuiteMask;                      //标识系统上的程序组(详见附2)
//
//BYTE wProductType;                    //标识系统类型(详见附3)
//
//BYTE wReserved;                         //保留,未使用

  if GetVersionExA(VI) then
  begin
    if VI.dwMajorVersion>5 then Result := True;

  end;  



end;

function win10:boolean;
var
  VI: TOSVersionInfoA;
begin
  Result := False;

  VI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);

//DWORD dwOSVersionInfoSize;       //在使用GetVersionEx之前要将此初始化为结构的大小
//DWORD dwMajorVersion;            //系统主版本号
//DWORD dwMinorVersion;            //系统次版本号
//DWORD dwBuildNumber;             //系统构建号
//DWORD dwPlatformId;              //系统支持的平台(详见附1)
//TCHAR szCSDVersion[128];         //系统补丁包的名称
//WORD wServicePackMajor;          //系统补丁包的主版本
//WORD wServicePackMinor;          //系统补丁包的次版本
//WORD wSuiteMask;                 //标识系统上的程序组(详见附2)
//BYTE wProductType;               //标识系统类型(详见附3)
//BYTE wReserved;                  //保留,未使用

  if GetVersionExA(VI) then
  begin
    if VI.dwMajorVersion>5 then Result := True;

    //win10 的 dwMinorVersion 应该是 2,dwMajorVersion 应该是6,所以就是 nt6.2//这里简单一点,大于 xp 就算好了

  end;

end;

//windows 和各个目录
function GetShellPath(const itype:integer):string;
var
  pidl: pItemIDList;
  buffer: array[0..255] of char;
begin
  {取指定的文件夹}
  //SHGetSpecialFolderLocation(application.Handle, 28, pidl);
  SHGetSpecialFolderLocation(application.Handle, itype, pidl);
  SHGetPathFromIDList(pidl, buffer);
  //memo1.Lines.Add(strpas(buffer));

  Result := strpas(buffer);
end;

{

得到的结果是：C:\Users\用户名\AppData\Local

组合完毕是：C:\Users\用户名\AppData\Local\Google\Chrome\User Data

那个常数的更全代表意思如下：

'桌面',0
'所有用户桌面',25
'开始菜单程序',2
'所有用户开始菜单程序',23
'我的文档',5
'收藏夹',6
'所有用户收藏夹',31
'启动文件夹',7
'所有用户启动文件夹',24
'Recent文件夹',8
'发送到',9
'登陆用户开始菜单',11
'所有用户开始菜单',22
'网上邻居',19
'字体文件夹',20
'Template文件夹',21
'所有用户Template文件夹',45
'ApplicaionData 文件夹',26
'打印文件夹',27
'当前用户本地应用程序设置文件夹',28
'Internet临时文件夹',32
'Internet缓存文件夹',33
'当前用户历史文件夹',34
'所有用户应用程序设置文件夹',35
'Windows系统目录',36
'程序文件夹',38
'System32系统目录',37
'当前用户图片收藏夹',39
'当前用户文件夹',40
'公共文件夹',43
'管理工具',47
'登陆用户管理工具',48
'所有用户图片收藏夹',54
'所有用户视频收藏夹',55
'主题资源文件夹',56
'CD Burning',59
}


//取 windows10 下的程序目录
//例如 C:\Users\administrator\AppData\Roaming
function AppPath(const appname:string; create:boolean=true):string;
begin
  if win10 then
  begin
    Result := GetShellPath(26);

    if appname<>'' then
    begin
      Result := Result + '\' + appname + '\';
      if create then
      ForceDirectories(Result);
    end;

  end
  else
  begin
    Result := ExtractFilePath(application.ExeName);
  end;

end;

//win10下取程序目录下的配置文件,如果在 win10 的 appdata 中没有的话就先复制
function win10ConfigFile(const appname:string; const fn:string):string;
var
  srcfn:string;
begin

  srcfn := ExtractFilePath(application.ExeName) + fn;

  if win10 then
  begin
    Result := UnitWin10.AppPath(appname) + fn;
    copyfile(pansichar(srcfn), pansichar(Result), true);


  end
  else
  begin
    Result := ExtractFilePath(application.ExeName) + fn;
  end;

end;




//确实可用//判断程序是否以管理员身份运行
//http://blog.csdn.net/donglinshengan/article/details/18416645
//BOOL FindUacToken_v2()
function IsAdmin_v2: Boolean;
var
	hToken:THANDLE;//  = 0;//clq add
	hProcessSnap:THANDLE;// hProcessSnap = NULL;
	bRet: Boolean;// = FALSE;
	pe32:PROCESSENTRY32;
	//pe32 = {0};
  hProcess:THANDLE;

  TokenIsElevated:DWORD;
  dwReturnLength:DWORD;// = 0;

begin
  Result := False;
  bRet := False;

	hProcessSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (hProcessSnap = INVALID_HANDLE_VALUE)
	then exit; //return FALSE;

  FillMemory(@pe32, SizeOf(PROCESSENTRY32), 0);
	pe32.dwSize := sizeof(PROCESSENTRY32);
	hToken := 0;


	//--------------------------------------------------
	//http://blog.csdn.net/qq_26153041/article/details/52168264
    //Open a handle to the access token for the calling process
    //以查询方式打开   当前进程的Token,即是当前登录用户的Token
    //if(!OpenProcessToken(GetCurrentProcess( ),TOKEN_QUERY,&hToken))
    //{
    //    _tprintf(TEXT("OpenProcessToken failed with error %d\n"),GetLastError( ));
    //    return FALSE;
    //}

	//--------------------------------------------------

	//hProcess := OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, pe32.th32ProcessID);
	//if (OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, &hToken))
	hProcess := GetCurrentProcess(); //clq add//用这个应该就可以了，因为原来是遍历所有的进程，这里只判断自己就行了
	if (OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, hToken)) then
	//if (OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, @hToken) = true) then
	begin
    TokenIsElevated := 0;
    dwReturnLength := 0;

    // 获取进程信息，以判断是否以管理员权限运行//(_TOKEN_INFORMATION_CLASS)20 似乎是 TokenElevation 的意思
    //if (GetTokenInformation(hToken, (_TOKEN_INFORMATION_CLASS)20,&TokenIsElevated,sizeof(DWORD),&dwReturnLength))
    if (GetTokenInformation(hToken, TTokenInformationClass(20),@TokenIsElevated,sizeof(DWORD),dwReturnLength)) then
    begin
      //if (dwReturnLength = sizeof(DWORD) && 1 = TokenIsElevated)  // 说明是以管理员权限运行的
      if (dwReturnLength = sizeof(DWORD)) and (1 = TokenIsElevated) then // 说明是以管理员权限运行的
      begin
        //printf("管理员\r\n");

        Result := True;
        (*
        UCHAR InfoBuffer[ 512 ];
        DWORD cbInfoBuffer = 512;
        DWORD cchUser;
        DWORD cchDomain;
        TCHAR UserName[128];
        TCHAR DomainName[128];
        SID_NAME_USE snu;

        // 再次获取进程信息，以判断是否是用户进程
        if ( GetTokenInformation(hToken, TokenUser, InfoBuffer, cbInfoBuffer, &cbInfoBuffer) ) then
        begin
          bRet = LookupAccountSid(NULL, ((PTOKEN_USER)InfoBuffer)->User.Sid, UserName, &cchUser, DomainName, &cchDomain, &snu);


          _tcslwr_s(UserName, 128);
          _tcslwr_s(DomainName, 128);


          if (NULL == _tcsstr(UserName, TEXT("system")) && NULL != _tcsstr(DomainName, TEXT("-pc"))) then
          begin
            Result := True; //return TRUE;
          end;
        end;
        *)
      end;
    end;


    CloseHandle(hToken);
	end;


	CloseHandle(hProcess);
	CloseHandle (hProcessSnap); 


	//return bRet;
  //bRet
end;//


//if AdjustProcessPrivilege(GetCurrentProcess,'SeDebugPrivilege') then　　//提升权限
//Memo1.Lines.Add('提升权限成功')
//else
//Memo1.Lines.Add('提升权限失败');

//提升进程令牌函数
function AdjustProcessPrivilege(ProcessHandle:THandle;Token_Name:Pchar):boolean;
var
  Token:Cardinal;
  TokenPri:_TOKEN_PRIVILEGES;
  ProcessDest:int64;
  l:DWORD;
begin
  Result:=False;
  if OpenProcessToken(ProcessHandle,TOKEN_Adjust_Privileges,Token) then
  begin
      if LookupPrivilegeValue(nil,Token_Name,ProcessDest) then
      begin
        TokenPri.PrivilegeCount:=1;
        TokenPri.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
        TokenPri.Privileges[0].Luid:=ProcessDest;
        l:=0;
        //更新进程令牌，成功返回TRUE
        if AdjustTokenPrivileges(Token,False,TokenPri,sizeof(TokenPri),nil,l) then
          Result:=True;
      end;
  end;
end;


//写入文件的权限
function SetAdmin: Boolean;
begin

//if AdjustProcessPrivilege(GetCurrentProcess,'SeDebugPrivilege') then　　//提升权限
//Memo1.Lines.Add('提升权限成功')
//else
//Memo1.Lines.Add('提升权限失败');

  // SeDebugPrivilege 应该是杀进程需要的权限
  //SeBackupPrivilege 应该是访问所有文件
  if AdjustProcessPrivilege(GetCurrentProcess,'SeBackupPrivilege') then //提升权限
    Result := True //提升权限成功
  else
    Result := False; //提升权限失败

  if AdjustProcessPrivilege(GetCurrentProcess,'SeTakeOwnershipPrivilege') then //提升权限
    //Result := True //提升权限成功
  else
    Result := False; //提升权限失败

  if AdjustProcessPrivilege(GetCurrentProcess,'SeSecurityPrivilege') then //提升权限
    //Result := True //提升权限成功
  else
    Result := False; //提升权限失败

end;



//有问题，不要用
//http://www.delphitop.com/html/xitong/246.html//有问题，不要用
function IsAdmin: Boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
  hAccessToken);

  if Not bSuccess Then
  begin
    If GetLastError = ERROR_NO_TOKEN Then
    bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
  end;

  if bSuccess Then
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    
    if bSuccess Then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
      {$R-}
      for x := 0 To ptgGroups.GroupCount - 1 Do
      begin
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) Then
        begin
          Result := True;
          Break;
        end;
      end;  
      {$R+}
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;


end.

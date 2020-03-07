unit UnitWin10;

//win10 �����Եĵ�Ԫ

interface

uses
  ShlObj, shellapi, windows, SysUtils, Dialogs,
  tlhelp32,
  forms;

//win10 ���û���д��Ŀ¼

(*
uses System.IOUtils;

//���� C:\Users\administrator\AppData\Roaming
procedure TForm1.FormCreate(Sender: TObject);
var
  S: string;
begin
  { ���ַ������һ��: C:\Users\wy\AppData\Roaming }
  S := GetHomePath;                       // SysUtils, �ܿ�ƽ̨�Ҽ�, �� Windows ��ʹ�� SHGetFolderPath ���
  S := TPath.GetHomePath;                 // System.IOUtils
  S := GetEnvironmentVariable('APPDATA'); // ��ǰһֱ�����
end;
*)

//ȡ windows10 �µĳ���Ŀ¼
//���� C:\Users\administrator\AppData\Roaming
function AppPath(const appname:string; create:boolean=true):string;

//win10��ȡ����Ŀ¼�µ������ļ�,����� win10 �� appdata ��û�еĻ����ȸ���
function win10ConfigFile(const appname:string; const fn:string):string;

//�Ƿ��й���ԱȨ��
function IsAdmin: Boolean;
//ȷʵ����//�жϳ����Ƿ��Թ���Ա�������
//http://blog.csdn.net/donglinshengan/article/details/18416645
//BOOL FindUacToken_v2()
function IsAdmin_v2: Boolean;

//д���ļ���Ȩ��
function SetAdmin: Boolean;


implementation

//xp �Ժ�汾,�û�Ȩ������
function WindowsVersion_highXP: Boolean;
var
  VI: TOSVersionInfoA;
begin
  Result := False;

  VI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);

//DWORD dwOSVersionInfoSize;       //��ʹ��GetVersionEx֮ǰҪ���˳�ʼ��Ϊ�ṹ�Ĵ�С
//
//DWORD dwMajorVersion;               //ϵͳ���汾��
//
//DWORD dwMinorVersion;               //ϵͳ�ΰ汾��
//
//DWORD dwBuildNumber;               //ϵͳ������
//
//DWORD dwPlatformId;                  //ϵͳ֧�ֵ�ƽ̨(�����1)
//
//TCHAR szCSDVersion[128];          //ϵͳ������������
//
//WORD wServicePackMajor;            //ϵͳ�����������汾
//
//WORD wServicePackMinor;            //ϵͳ�������Ĵΰ汾
//
//WORD wSuiteMask;                      //��ʶϵͳ�ϵĳ�����(�����2)
//
//BYTE wProductType;                    //��ʶϵͳ����(�����3)
//
//BYTE wReserved;                         //����,δʹ��

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

//DWORD dwOSVersionInfoSize;       //��ʹ��GetVersionEx֮ǰҪ���˳�ʼ��Ϊ�ṹ�Ĵ�С
//DWORD dwMajorVersion;            //ϵͳ���汾��
//DWORD dwMinorVersion;            //ϵͳ�ΰ汾��
//DWORD dwBuildNumber;             //ϵͳ������
//DWORD dwPlatformId;              //ϵͳ֧�ֵ�ƽ̨(�����1)
//TCHAR szCSDVersion[128];         //ϵͳ������������
//WORD wServicePackMajor;          //ϵͳ�����������汾
//WORD wServicePackMinor;          //ϵͳ�������Ĵΰ汾
//WORD wSuiteMask;                 //��ʶϵͳ�ϵĳ�����(�����2)
//BYTE wProductType;               //��ʶϵͳ����(�����3)
//BYTE wReserved;                  //����,δʹ��

  if GetVersionExA(VI) then
  begin
    if VI.dwMajorVersion>5 then Result := True;

    //win10 �� dwMinorVersion Ӧ���� 2,dwMajorVersion Ӧ����6,���Ծ��� nt6.2//�����һ��,���� xp �������

  end;

end;

//windows �͸���Ŀ¼
function GetShellPath(const itype:integer):string;
var
  pidl: pItemIDList;
  buffer: array[0..255] of char;
begin
  {ȡָ�����ļ���}
  //SHGetSpecialFolderLocation(application.Handle, 28, pidl);
  SHGetSpecialFolderLocation(application.Handle, itype, pidl);
  SHGetPathFromIDList(pidl, buffer);
  //memo1.Lines.Add(strpas(buffer));

  Result := strpas(buffer);
end;

{

�õ��Ľ���ǣ�C:\Users\�û���\AppData\Local

�������ǣ�C:\Users\�û���\AppData\Local\Google\Chrome\User Data

�Ǹ������ĸ�ȫ������˼���£�

'����',0
'�����û�����',25
'��ʼ�˵�����',2
'�����û���ʼ�˵�����',23
'�ҵ��ĵ�',5
'�ղؼ�',6
'�����û��ղؼ�',31
'�����ļ���',7
'�����û������ļ���',24
'Recent�ļ���',8
'���͵�',9
'��½�û���ʼ�˵�',11
'�����û���ʼ�˵�',22
'�����ھ�',19
'�����ļ���',20
'Template�ļ���',21
'�����û�Template�ļ���',45
'ApplicaionData �ļ���',26
'��ӡ�ļ���',27
'��ǰ�û�����Ӧ�ó��������ļ���',28
'Internet��ʱ�ļ���',32
'Internet�����ļ���',33
'��ǰ�û���ʷ�ļ���',34
'�����û�Ӧ�ó��������ļ���',35
'WindowsϵͳĿ¼',36
'�����ļ���',38
'System32ϵͳĿ¼',37
'��ǰ�û�ͼƬ�ղؼ�',39
'��ǰ�û��ļ���',40
'�����ļ���',43
'������',47
'��½�û�������',48
'�����û�ͼƬ�ղؼ�',54
'�����û���Ƶ�ղؼ�',55
'������Դ�ļ���',56
'CD Burning',59
}


//ȡ windows10 �µĳ���Ŀ¼
//���� C:\Users\administrator\AppData\Roaming
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

//win10��ȡ����Ŀ¼�µ������ļ�,����� win10 �� appdata ��û�еĻ����ȸ���
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




//ȷʵ����//�жϳ����Ƿ��Թ���Ա�������
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
    //�Բ�ѯ��ʽ��   ��ǰ���̵�Token,���ǵ�ǰ��¼�û���Token
    //if(!OpenProcessToken(GetCurrentProcess( ),TOKEN_QUERY,&hToken))
    //{
    //    _tprintf(TEXT("OpenProcessToken failed with error %d\n"),GetLastError( ));
    //    return FALSE;
    //}

	//--------------------------------------------------

	//hProcess := OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, pe32.th32ProcessID);
	//if (OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, &hToken))
	hProcess := GetCurrentProcess(); //clq add//�����Ӧ�þͿ����ˣ���Ϊԭ���Ǳ������еĽ��̣�����ֻ�ж��Լ�������
	if (OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, hToken)) then
	//if (OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, @hToken) = true) then
	begin
    TokenIsElevated := 0;
    dwReturnLength := 0;

    // ��ȡ������Ϣ�����ж��Ƿ��Թ���ԱȨ������//(_TOKEN_INFORMATION_CLASS)20 �ƺ��� TokenElevation ����˼
    //if (GetTokenInformation(hToken, (_TOKEN_INFORMATION_CLASS)20,&TokenIsElevated,sizeof(DWORD),&dwReturnLength))
    if (GetTokenInformation(hToken, TTokenInformationClass(20),@TokenIsElevated,sizeof(DWORD),dwReturnLength)) then
    begin
      //if (dwReturnLength = sizeof(DWORD) && 1 = TokenIsElevated)  // ˵�����Թ���ԱȨ�����е�
      if (dwReturnLength = sizeof(DWORD)) and (1 = TokenIsElevated) then // ˵�����Թ���ԱȨ�����е�
      begin
        //printf("����Ա\r\n");

        Result := True;
        (*
        UCHAR InfoBuffer[ 512 ];
        DWORD cbInfoBuffer = 512;
        DWORD cchUser;
        DWORD cchDomain;
        TCHAR UserName[128];
        TCHAR DomainName[128];
        SID_NAME_USE snu;

        // �ٴλ�ȡ������Ϣ�����ж��Ƿ����û�����
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


//if AdjustProcessPrivilege(GetCurrentProcess,'SeDebugPrivilege') then����//����Ȩ��
//Memo1.Lines.Add('����Ȩ�޳ɹ�')
//else
//Memo1.Lines.Add('����Ȩ��ʧ��');

//�����������ƺ���
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
        //���½������ƣ��ɹ�����TRUE
        if AdjustTokenPrivileges(Token,False,TokenPri,sizeof(TokenPri),nil,l) then
          Result:=True;
      end;
  end;
end;


//д���ļ���Ȩ��
function SetAdmin: Boolean;
begin

//if AdjustProcessPrivilege(GetCurrentProcess,'SeDebugPrivilege') then����//����Ȩ��
//Memo1.Lines.Add('����Ȩ�޳ɹ�')
//else
//Memo1.Lines.Add('����Ȩ��ʧ��');

  // SeDebugPrivilege Ӧ����ɱ������Ҫ��Ȩ��
  //SeBackupPrivilege Ӧ���Ƿ��������ļ�
  if AdjustProcessPrivilege(GetCurrentProcess,'SeBackupPrivilege') then //����Ȩ��
    Result := True //����Ȩ�޳ɹ�
  else
    Result := False; //����Ȩ��ʧ��

  if AdjustProcessPrivilege(GetCurrentProcess,'SeTakeOwnershipPrivilege') then //����Ȩ��
    //Result := True //����Ȩ�޳ɹ�
  else
    Result := False; //����Ȩ��ʧ��

  if AdjustProcessPrivilege(GetCurrentProcess,'SeSecurityPrivilege') then //����Ȩ��
    //Result := True //����Ȩ�޳ɹ�
  else
    Result := False; //����Ȩ��ʧ��

end;



//�����⣬��Ҫ��
//http://www.delphitop.com/html/xitong/246.html//�����⣬��Ҫ��
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

unit find_file_unicode;

//��ȡ�� see_map ��  sort_file.pas
//ԭ���� delphi7 �� findfile(FindFirst/FindNext) �������ļ����ܳ���Ŀ¼�������� 234 ���������
//�ο� http://newbt.net/ms/vdisk/show_bbs.php?id=9B02FE6CA8FB79EB1678DA51AAFDD9BD&pid=164

//��Ҫ���滻 SysUtils �е�ͬ������

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TSearchRecW = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
{$IFDEF MSWINDOWS}
    FindHandle: THandle  platform;
    FindData: TWin32FindDataW  platform;
{$ENDIF}
{$IFDEF LINUX}
    Mode: mode_t  platform;
    FindHandle: Pointer  platform;
    PathOnly: String  platform;
    Pattern: String  platform;
{$ENDIF}
  end;


function FindFirstW(const Path: WideString; Attr: Integer; var  F: TSearchRecW): Integer;

//ȡ GetLastError ���ַ�����ʾ
function win32error(ErrorCode:DWORD):string;

function FindNextW(var F: TSearchRecW): Integer;

procedure FindCloseW(var F: TSearchRecW);

implementation




//ȡ GetLastError ���ַ�����ʾ
function win32error(ErrorCode:DWORD):string;
var
  //lpBuffer: PChar;
  lpMsgBuf: PChar;
begin
  //FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil,
  //      ErrorCode, LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil);

  //https://baike.baidu.com/item/FormatMessage
  FormatMessage (
      FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
      nil,
      ErrorCode,
      LOCALE_USER_DEFAULT, //MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      @lpMsgBuf,//(LPTSTR) &lpMsgBuf, //ǧ��ע�� @lpMsgBuf ���д���������� lpMsgBuf �� ����˵Ҫ����ָ���ָ��
      0, nil );

  Result := StrPas(lpMsgBuf);
  LocalFree(THandle(lpMsgBuf));  //�� FORMAT_MESSAGE_ALLOCATE_BUFFER ��־������Ҫ�Լ��ͷŵ�

end;


//2020 �������Դ������
//function FindMatchingFile(var F: TSearchRec): Integer;


//ԭʼ�� SysUtils.FindNext ��̫�����ļ���������
function __FindNext(var F: TSearchRec): Integer;
begin
{$IFDEF MSWINDOWS}
  if FindNextFile(F.FindHandle, F.FindData) then
  begin
    //Result := FindMatchingFile(F);
    Result := 0;//FindMatchingFile(F); //2020 ֱ�Ӹ����ɹ�������
  end
  else
  begin
    Result := GetLastError;         //̫�����ļ����᷵�� 234 "�и������ݿ���"
    ShowMessage(IntToStr(Result));
    ShowMessage(win32error(Result));
  end;

{$ENDIF}
{$IFDEF LINUX}
  Result := FindMatchingFile(F);
{$ENDIF}
end;


function _FindNext(var F: TSearchRec): Integer;
begin
{$IFDEF MSWINDOWS}
  if FindNextFile(F.FindHandle, F.FindData) then
    //Result := FindMatchingFile(F)
    Result := 0
    else
    Result := GetLastError;
{$ENDIF}
{$IFDEF LINUX}
  Result := FindMatchingFile(F);
{$ENDIF}
end;



function FindMatchingFileW(var F: TSearchRecW): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFileW(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
      LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function FindNextW(var F: TSearchRecW): Integer;
begin
{$IFDEF MSWINDOWS}
  if FindNextFileW(F.FindHandle, F.FindData) then
    Result := FindMatchingFileW(F)
    //Result := 0
    else
    Result := GetLastError;
{$ENDIF}
{$IFDEF LINUX}
  Result := FindMatchingFile(F);
{$ENDIF}
end;

procedure FindCloseW(var F: TSearchRecW);
begin
{$IFDEF MSWINDOWS}
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
{$ENDIF}
{$IFDEF LINUX}
  if F.FindHandle <> nil then
  begin
    closedir(F.FindHandle);
    F.FindHandle := nil;
  end;
{$ENDIF}
end;

function FindFirstW(const Path: WideString; Attr: Integer;
  var  F: TSearchRecW): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;

begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFileW(PWideChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFileW(F);
    if Result <> 0 then FindCloseW(F);
  end else
    Result := GetLastError;
end;





//windows ��������ʱ��ṹҪת���� delphi ��ʱ���ǱȽ��鷳��
////FileGetDate ��ʵ�ֺ����
//�ο� FileGetDate
function FileTime2Delphi(ftLastWriteTime: TFileTime):TDateTime;
var
  FileTime, LocalFileTime: TFileTime;
  _DosDateTime:Integer;
begin
  FileTime := ftLastWriteTime;//
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToDosDateTime(LocalFileTime, LongRec(_DosDateTime).Hi, LongRec(_DosDateTime).Lo);

  Result := FileDateToDateTime(_DosDateTime);
end;

//����Ŀ¼
procedure FindFiles(path: string; fileList: TStringList; findDir:Boolean; findSub:Boolean=False);
var
  searchRec: TSearchRecW;
  found: Integer;
  tmpStr: string;
  curDir: string;
  dirs: TStringList;
  pszDir: PChar;
  fn:string;

begin

  //����������׺,�õ�����'c:\*.*' ��'c:\windows\*.*'������·��
  tmpStr := path + '*.*';
  //�ڵ�ǰĿ¼���ҵ�һ���ļ�����Ŀ¼
  found := FindFirstW(tmpStr, faAnyFile, searchRec);
  while found = 0 do //�ҵ���һ���ļ���Ŀ¼��
  begin
    fn := path + searchRec.Name;

    if (searchRec.Name <> '.') and (searchRec.Name <> '..') then
    begin
      //����ҵ����Ǹ�Ŀ¼
      if ((searchRec.Attr and faDirectory) <> 0) then
      begin
        if findSub then FindFiles(fn + '\', fileList, findDir, findSub);
        if findDir then fileList.Add(fn);
      end
      else//������ļ�
      begin
        fileList.Add(fn);
      end;
    end;

    //������һ���ļ���Ŀ¼
    found := FindNextW(searchRec);
  end;

  //�ͷ���Դ
  FindCloseW(searchRec);
end;


//����Ŀ¼//�����������İ汾����Ҫ�ã���������� lazarus �Ļ�������ȷ��
procedure __FindFiles(path: string; fileList: TStringList; findDir:Boolean; findSub:Boolean=False);
var
  searchRec: TSearchRec;
  found: Integer;
  tmpStr: string;
  curDir: string;
  dirs: TStringList;
  pszDir: PChar;
  fn:string;

begin

  //����������׺,�õ�����'c:\*.*' ��'c:\windows\*.*'������·��
  tmpStr := path + '*.*';
  //�ڵ�ǰĿ¼���ҵ�һ���ļ�����Ŀ¼
  found := FindFirst(tmpStr, faAnyFile, searchRec);
  while found = 0 do //�ҵ���һ���ļ���Ŀ¼��
  begin
    fn := path + searchRec.Name;

    if (searchRec.Name <> '.') and (searchRec.Name <> '..') then
    begin
      //����ҵ����Ǹ�Ŀ¼
      if ((searchRec.Attr and faDirectory) <> 0) then
      begin
        if findSub then FindFiles(fn + '\', fileList, findDir, findSub);
        if findDir then fileList.Add(fn);
      end
      else//������ļ�
      begin
        fileList.Add(fn);
      end;
    end;

    //������һ���ļ���Ŀ¼
    found := FindNext(searchRec);
  end;

  //�ͷ���Դ
  FindClose(searchRec);
end;


end.










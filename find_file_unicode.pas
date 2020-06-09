unit find_file_unicode;

//提取自 see_map 的  sort_file.pas
//原因是 delphi7 的 findfile(FindFirst/FindNext) 对于有文件名很长的目录遍历返回 234 错误的问题
//参考 http://newbt.net/ms/vdisk/show_bbs.php?id=9B02FE6CA8FB79EB1678DA51AAFDD9BD&pid=164

//主要是替换 SysUtils 中的同名函数

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

//取 GetLastError 的字符串表示
function win32error(ErrorCode:DWORD):string;

function FindNextW(var F: TSearchRecW): Integer;

procedure FindCloseW(var F: TSearchRecW);

implementation




//取 GetLastError 的字符串表示
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
      @lpMsgBuf,//(LPTSTR) &lpMsgBuf, //千万注意 @lpMsgBuf 这个写法，不能是 lpMsgBuf 。 就是说要传递指针的指针
      0, nil );

  Result := StrPas(lpMsgBuf);
  LocalFree(THandle(lpMsgBuf));  //有 FORMAT_MESSAGE_ALLOCATE_BUFFER 标志，就是要自己释放的

end;


//2020 怀疑这个源码有误
//function FindMatchingFile(var F: TSearchRec): Integer;


//原始的 SysUtils.FindNext 对太长的文件名有问题
function __FindNext(var F: TSearchRec): Integer;
begin
{$IFDEF MSWINDOWS}
  if FindNextFile(F.FindHandle, F.FindData) then
  begin
    //Result := FindMatchingFile(F);
    Result := 0;//FindMatchingFile(F); //2020 直接给出成功会怎样
  end
  else
  begin
    Result := GetLastError;         //太长的文件名会返回 234 "有更多数据可用"
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





//windows 搜索到的时间结构要转换成 delphi 的时间是比较麻烦的
////FileGetDate 的实现很奇怪
//参考 FileGetDate
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

//遍历目录
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

  //加上搜索后缀,得到类似'c:\*.*' 、'c:\windows\*.*'的搜索路径
  tmpStr := path + '*.*';
  //在当前目录查找第一个文件、子目录
  found := FindFirstW(tmpStr, faAnyFile, searchRec);
  while found = 0 do //找到了一个文件或目录后
  begin
    fn := path + searchRec.Name;

    if (searchRec.Name <> '.') and (searchRec.Name <> '..') then
    begin
      //如果找到的是个目录
      if ((searchRec.Attr and faDirectory) <> 0) then
      begin
        if findSub then FindFiles(fn + '\', fileList, findDir, findSub);
        if findDir then fileList.Add(fn);
      end
      else//如果是文件
      begin
        fileList.Add(fn);
      end;
    end;

    //查找下一个文件或目录
    found := FindNextW(searchRec);
  end;

  //释放资源
  FindCloseW(searchRec);
end;


//遍历目录//这个是有问题的版本，不要用，不过如果是 lazarus 的话就是正确的
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

  //加上搜索后缀,得到类似'c:\*.*' 、'c:\windows\*.*'的搜索路径
  tmpStr := path + '*.*';
  //在当前目录查找第一个文件、子目录
  found := FindFirst(tmpStr, faAnyFile, searchRec);
  while found = 0 do //找到了一个文件或目录后
  begin
    fn := path + searchRec.Name;

    if (searchRec.Name <> '.') and (searchRec.Name <> '..') then
    begin
      //如果找到的是个目录
      if ((searchRec.Attr and faDirectory) <> 0) then
      begin
        if findSub then FindFiles(fn + '\', fileList, findDir, findSub);
        if findDir then fileList.Add(fn);
      end
      else//如果是文件
      begin
        fileList.Add(fn);
      end;
    end;

    //查找下一个文件或目录
    found := FindNext(searchRec);
  end;

  //释放资源
  FindClose(searchRec);
end;


end.










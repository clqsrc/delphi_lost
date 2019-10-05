
//公用函数

unit Functions;

interface

uses

{$IFDEF BCB}
  StrUtils_d7_bcb6,
{$ELSE}
  ShDocVw,  MSHTML,
{$ENDIF}


  //下面这句控制是否使用含BDE的单元
  {$DEFINE have_bde1}

  //下面这句表示安装控件时有错误，要避免
  {$DEFINE have_bug1}

  //真奇怪，引用这个单元后控件包安装会出错，但直接在程序中改却没错
  //delphi7中就没有这个问题了

{$IFDEF UniCode}
  WideStrings,
{$ENDIF}

  {$IFDEF have_bug1}
  WSDLIntf,
  {$ENDIF}

  {}Valedit,
  IdCoder3To4,
  {}EncdDecd,{含编码函数的}

  des,shellapi,ComCtrls,Variants, ActiveX,Grids,Menus,ExtCtrls,
  ScktComp,winsock,Registry,filectrl,{}Windows, Messages, SysUtils,
  Classes, Graphics,DateUtils,
  Shlobj,Controls, Forms, Dialogs, StdCtrls,StrUtils

  {$IFDEF have_bde1}
  ,DB,adodb, DBTables, DBGrids;
  {$ELSE}
  ;
  {$ENDIF}

//Application.MessageBox 的问题比较多，比如阻止消息显示等//最好不要模式显示//加了句柄显示的选择
function showmessage_windows(handle1:HWnd; s1:string; have_yesno1:boolean=false; caption1:string='Info'):boolean;


//[2-4]Find_in_dir1的扩展，最后一个参数决定加入的是目录还是文件//路径、输出、是否查找子目录
procedure Find_in_dir1(path1:string;out1:tstringlist;sub1:boolean;type1:string);

//[2-21]取得字符串中的特定部分//b_sp1是开始取的位置，e_sp1是结束的位置
//应该不区分大小写
function get_value(in1:string;b_sp1:string;e_sp1:string):string;
//function get_value1(in1:string;b_sp1:string;e_sp1:string):string;



implementation

function get_value(in1:string;b_sp1:string;e_sp1:string):string;
//function get_value1(in1:string;b_sp1:string;e_sp1:string):string;
var
  //开始复制的位置
  b_pos1:longint;
  //复制结束的位置
  e_pos1:longint;
begin
  if e_sp1='' then e_pos1:=length(in1);
  b_pos1:=pos(lowercase(b_sp1),lowercase(in1));
  if b_sp1='' then b_pos1:=1;
  if b_pos1=0 then
  begin
    result:='';
    exit;

  end;
  b_pos1:=b_pos1+(length(b_sp1));
  result:=copy(in1,b_pos1,length(in1));

  e_pos1:=pos(lowercase(e_sp1),lowercase(result))-1;
  if e_pos1=-1 then e_pos1:=length(result);
  result:=copy(result,1,e_pos1);

end;



//Application.MessageBox 的问题比较多，比如阻止消息显示等//最好不要模式显示//加了句柄显示的选择
function showmessage_windows(handle1:HWnd; s1:string; have_yesno1:boolean=false; caption1:string='Info'):boolean;
var
  type1:UINT;
  //handle1:HWnd;
begin
  if have_yesno1
    then type1:=MB_yesno or MB_ICONINFORMATION
    else type1:=MB_ok or MB_ICONINFORMATION;
//  if form1=nil
//    then handle1:= application.handle
//    else handle1:=form1.Handle;

  //if Application.MessageBox(PChar(s1),PChar(caption1), type1)=idyes
  if messagebox(handle1,pchar(s1),pchar(caption1),type1)=idyes   // 2018/3/4 23:49:30 还是 windows 原版稳定，前面那个可能不显示
    then result:=true
    else result:=false;
end;

//[2-4]Find_in_dir1的扩展，最后一个参数决定加入的是目录还是文件//路径、输出、是否查找子目录
procedure Find_in_dir1(path1:string;out1:tstringlist;sub1:boolean;type1:string);
var
  i_fr1: integer;//为了查找文件
  sr_fr1: TSearchRec;//for treeview2 为了查找文件

begin

  {查找文件目录}

  i_fr1 := FindFirst(path1+'*.*',faAnyFile, sr_fr1);
  while i_fr1 = 0 do
  begin
    if (sub1)and(DirectoryExists(path1+sr_fr1.Name+'\'))and(trim(sr_fr1.Name)<>'.')and(trim(sr_fr1.Name)<>'..') then
    begin
      //sr_fr1.Name
      Find_in_dir1(path1+sr_fr1.Name+'\',out1,sub1,type1);
    end;

    if type1='all' then
    begin
      if (sr_fr1.Name<>'..')and(sr_fr1.Name<>'.') then out1.Add(path1+sr_fr1.Name);

    end
    else
    if type1='dir' then
    begin//要得到的是目录
      if (sr_fr1.Name<>'..')and(sr_fr1.Name<>'.')and(DirectoryExists(path1+sr_fr1.Name)) then out1.Add(path1+sr_fr1.Name);
    end
    else//要得到的是文件
    if FileExists(path1+sr_fr1.Name) then out1.Add(path1+sr_fr1.Name);

    i_fr1 := FindNext(sr_fr1);
  end;
  FindClose(sr_fr1);

end;


end.
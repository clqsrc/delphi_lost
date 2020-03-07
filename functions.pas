
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

//[2-21]取得字符串中的特定部分//b_sp是开始取的位置，e_sp是结束的位置
//应该不区分大小写
//  ShowMessage(get_value_sp('key=value', '=', ';'));  //应当为 value
//  ShowMessage(get_value_sp('key=value', '', '='));   //应当为 key
//  ShowMessage(get_value_sp('key=value;', '=', ';')); //应当为 value
//  ShowMessage(get_value_sp('key=value;', '', '='));  //应当为 key
function get_value(in_s:string; b_sp:string; e_sp:string):string;
//function get_value1(in1:string;b_sp1:string;e_sp1:string):string;
//分隔字符串取左边
function sp_str_left(in_s:string; sp:string):string;
//分隔字符串取右边
function sp_str_right(in_s:string; sp:string):string;

//结果应该和 get_value 相同，只是换用更容易理解的算法而已
//  ShowMessage(get_value_sp('key=value', '=', ';'));  //应当为 value
//  ShowMessage(get_value_sp('key=value', '', '='));   //应当为 key
//  ShowMessage(get_value_sp('key=value;', '=', ';')); //应当为 value
//  ShowMessage(get_value_sp('key=value;', '', '='));  //应当为 key
function get_value_sp(in_s:string; b_sp:string; e_sp:string):string;

//[2-6]当前程序的路径
function app_path1:string;

//[2-7]shellexecute的简化版本
procedure shellexecute1(filename1:string);

implementation

//[2-6]当前程序的路径
function app_path1:string;
begin
  result:=extractfilepath(application.ExeName);
end;

//[2-7]shellexecute的简化版本
procedure shellexecute1(filename1:string);
begin
  shellexecute(application.handle,nil,pchar(filename1),nil,nil,sw_shownormal);
  //shellexecute(application.handle,'open',pchar(filename1),nil,nil,sw_shownormal);

end;

//应该是有问题的版本，暂时保留以备参考而已
function get_value_old_v1(in1:string;b_sp1:string;e_sp1:string):string;
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
  if e_pos1=-1 then e_pos1:=length(result); // 2020/2/14 15:22:27 //有问题，这个只是恰好对了。找不到字符串的时候应该立即返回空字符串
  result:=copy(result,1,e_pos1);

end;


//delphi 的起始位置是从 1 开始的，转换成其他语言时一定要注意
//取字符串的分隔符号间的字符串
//例如
// key=value; 中的 value = get_value(s, '=', ';')
// key=value  中的 value = get_value(s, '=', ';') 这是可以省略掉最后的那个结束符
// key=value; 中的 key = get_value(s, '', '=')
//
//如果觉得理解困难的话可以用后面的 sp... 系列字符串分隔函数
function get_value(in_s:string; b_sp:string; e_sp:string):string;
var
  //开始复制的位置
  b_pos:longint;
  //复制结束的位置
  e_pos:longint;
begin
  if e_sp = '' then e_pos := length(in_s); //没有结束符则取到最后一个字符
  b_pos := pos(lowercase(b_sp), lowercase(in_s)); //不要区分大小写
  if b_sp = '' then b_pos := 1;   //没有起始符，则从第一个字符开始取
  if b_pos <= 0 then      //没找到起始符号，立即返回空字符串
  begin
    result := '';
    exit;

  end;
  b_pos := b_pos + (length(b_sp));  //起始位置还要跳过分隔符号的长度
  result := copy(in_s, b_pos, length(in_s));  //先去掉起始分隔符号之前的部分（分隔符本身也不要）

  //---- 好了，前面取得了起始分隔符号后的字符，现在再取结束符号前的字符就可以了
  e_pos := pos(lowercase(e_sp), lowercase(result));
  e_pos := e_pos - 1;  //因为结束符号本身是不需要的，所以查找到的位置向前移一位才是我们要的最后一个字符
  if e_sp = '' then e_pos := length(result);  //没有结束符，则从取到最后一个字符
  //if e_pos1=-1 then e_pos1:=length(result); // 2020/2/14 15:22:27 //有问题，这个只是恰好对了。找不到字符串的时候应该立即返回空字符串

  if e_pos <= 0 then      //没找到结束符，立即返回空字符串//不对，没有结束分隔符号的话应该是返回整个字符串这样就允许数据方不用写最后的结束符类似贪婪算法
  begin
    //result := '';
    exit;

  end;

  //result := copy(result, 1, e_pos);
  result := copy(result, 1, e_pos); //因为delphi 字符串位置是从 1 开始计算的，所以字符所在的位置就是包含它的整个字符串的长度了，不需要再加 1 或者减 1 这样的计算
  //copy() 的参数是起始位置（从1算起）和长度

end;


//将字符串分隔成两半，不要用系统自带的分隔字符串为数组的函数，因为那样的话无法处理字符串中有多个分隔符号的情况
//这个函数是在字符串第一次出现的地方进行分隔，其他的地方再出现的话不再理会，这样才能处理 xml 这样标记多层嵌套的情况
//b_get_left 取分隔后字符串的左边还是右边
function sp_str(in_s:string; sp:string; b_get_left:Boolean):string;
var
  //开始复制的位置
  find_pos:longint;      //查找到的位置
  left_last_pos:Integer; //左边字符串的最后一个字符的位置
  s_left:string;         //左边的字符串
  s_right:string;        //右边的字符串
begin

  find_pos := pos(lowercase(sp), lowercase(in_s)); //不要区分大小写

  if Length(sp)<1 then find_pos := 0; //没有分隔符就当做没找到处理

  if find_pos <= 0 then      //没找到分隔符号，立即返回，这时左边是原字符串，右边是空字符串，类似于分隔成数组后的 【索引1】 和 【索引2】 中的内容
  begin
    s_left := in_s;
    s_right := '';

    result := s_left;
    if False = b_get_left then Result := s_right;

    //result := '';
    exit;

  end;

  left_last_pos := find_pos - 1; //因为结束符号本身是不需要的，所以查找到的位置向前移一位才是我们要的最后一个字符

  //取左边
  s_left := copy(in_s, 1, left_last_pos); //因为delphi 字符串位置是从 1 开始计算的，所以字符所在的位置就是包含它的整个字符串的长度了，不需要再加 1 或者减 1 这样的计算

  //----
  //取右边
  find_pos := find_pos + (length(sp));  //起始位置还要跳过分隔符号的长度
  s_right := copy(in_s, find_pos, length(in_s));  //先去掉起始分隔符号之前的部分（分隔符本身也不要）

  //----
  result := s_left;
  if False = b_get_left then Result := s_right;
  

end;

//分隔字符串取左边
function sp_str_left(in_s:string; sp:string):string;
begin
  Result := sp_str(in_s, sp, true);

end;

//分隔字符串取右边
function sp_str_right(in_s:string; sp:string):string;
begin
  Result := sp_str(in_s, sp, false);

end;

//结果应该和 get_value 相同，只是换用更容易理解的算法而已
//  ShowMessage(get_value_sp('key=value', '=', ';'));  //应当为 value
//  ShowMessage(get_value_sp('key=value', '', '='));   //应当为 key
//  ShowMessage(get_value_sp('key=value;', '=', ';')); //应当为 value
//  ShowMessage(get_value_sp('key=value;', '', '='));  //应当为 key
function get_value_sp(in_s:string; b_sp:string; e_sp:string):string;
begin
  Result := in_s;

  if Length(b_sp)<1 then  //左边分隔符号为空就表示只要右分隔符号之前的
  begin
    Result := sp_str_left(Result, e_sp);
    Exit;
  end;

  if Length(e_sp)<1 then  //右边分隔符号为空就表示只要左分隔符号之后的
  begin
    Result := sp_str_right(Result, b_sp);
    Exit;
  end;

  //两者都有就取分隔符号之间的
  Result := sp_str_right(Result, b_sp);
  Result := sp_str_left(Result, e_sp);
  //Result := sp_str_left(Result, b_sp);
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

//���ú���

unit Functions;

interface

uses

{$IFDEF BCB}
  StrUtils_d7_bcb6,
{$ELSE}
  ShDocVw,  MSHTML,
{$ENDIF}


  //�����������Ƿ�ʹ�ú�BDE�ĵ�Ԫ
  {$DEFINE have_bde1}

  //��������ʾ��װ�ؼ�ʱ�д���Ҫ����
  {$DEFINE have_bug1}

  //����֣����������Ԫ��ؼ�����װ�������ֱ���ڳ����и�ȴû��
  //delphi7�о�û�����������

{$IFDEF UniCode}
  WideStrings,
{$ENDIF}

  {$IFDEF have_bug1}
  WSDLIntf,
  {$ENDIF}

  {}Valedit,
  IdCoder3To4,
  {}EncdDecd,{�����뺯����}

  des,shellapi,ComCtrls,Variants, ActiveX,Grids,Menus,ExtCtrls,
  ScktComp,winsock,Registry,filectrl,{}Windows, Messages, SysUtils,
  Classes, Graphics,DateUtils,
  Shlobj,Controls, Forms, Dialogs, StdCtrls,StrUtils

  {$IFDEF have_bde1}
  ,DB,adodb, DBTables, DBGrids;
  {$ELSE}
  ;
  {$ENDIF}

//Application.MessageBox ������Ƚ϶࣬������ֹ��Ϣ��ʾ��//��ò�Ҫģʽ��ʾ//���˾����ʾ��ѡ��
function showmessage_windows(handle1:HWnd; s1:string; have_yesno1:boolean=false; caption1:string='Info'):boolean;


//[2-4]Find_in_dir1����չ�����һ�����������������Ŀ¼�����ļ�//·����������Ƿ������Ŀ¼
procedure Find_in_dir1(path1:string;out1:tstringlist;sub1:boolean;type1:string);

//[2-21]ȡ���ַ����е��ض�����//b_sp1�ǿ�ʼȡ��λ�ã�e_sp1�ǽ�����λ��
//Ӧ�ò����ִ�Сд
function get_value(in1:string;b_sp1:string;e_sp1:string):string;
//function get_value1(in1:string;b_sp1:string;e_sp1:string):string;



implementation

function get_value(in1:string;b_sp1:string;e_sp1:string):string;
//function get_value1(in1:string;b_sp1:string;e_sp1:string):string;
var
  //��ʼ���Ƶ�λ��
  b_pos1:longint;
  //���ƽ�����λ��
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



//Application.MessageBox ������Ƚ϶࣬������ֹ��Ϣ��ʾ��//��ò�Ҫģʽ��ʾ//���˾����ʾ��ѡ��
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
  if messagebox(handle1,pchar(s1),pchar(caption1),type1)=idyes   // 2018/3/4 23:49:30 ���� windows ԭ���ȶ���ǰ���Ǹ����ܲ���ʾ
    then result:=true
    else result:=false;
end;

//[2-4]Find_in_dir1����չ�����һ�����������������Ŀ¼�����ļ�//·����������Ƿ������Ŀ¼
procedure Find_in_dir1(path1:string;out1:tstringlist;sub1:boolean;type1:string);
var
  i_fr1: integer;//Ϊ�˲����ļ�
  sr_fr1: TSearchRec;//for treeview2 Ϊ�˲����ļ�

begin

  {�����ļ�Ŀ¼}

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
    begin//Ҫ�õ�����Ŀ¼
      if (sr_fr1.Name<>'..')and(sr_fr1.Name<>'.')and(DirectoryExists(path1+sr_fr1.Name)) then out1.Add(path1+sr_fr1.Name);
    end
    else//Ҫ�õ������ļ�
    if FileExists(path1+sr_fr1.Name) then out1.Add(path1+sr_fr1.Name);

    i_fr1 := FindNext(sr_fr1);
  end;
  FindClose(sr_fr1);

end;


end.
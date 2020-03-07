
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

//[2-21]ȡ���ַ����е��ض�����//b_sp�ǿ�ʼȡ��λ�ã�e_sp�ǽ�����λ��
//Ӧ�ò����ִ�Сд
//  ShowMessage(get_value_sp('key=value', '=', ';'));  //Ӧ��Ϊ value
//  ShowMessage(get_value_sp('key=value', '', '='));   //Ӧ��Ϊ key
//  ShowMessage(get_value_sp('key=value;', '=', ';')); //Ӧ��Ϊ value
//  ShowMessage(get_value_sp('key=value;', '', '='));  //Ӧ��Ϊ key
function get_value(in_s:string; b_sp:string; e_sp:string):string;
//function get_value1(in1:string;b_sp1:string;e_sp1:string):string;
//�ָ��ַ���ȡ���
function sp_str_left(in_s:string; sp:string):string;
//�ָ��ַ���ȡ�ұ�
function sp_str_right(in_s:string; sp:string):string;

//���Ӧ�ú� get_value ��ͬ��ֻ�ǻ��ø����������㷨����
//  ShowMessage(get_value_sp('key=value', '=', ';'));  //Ӧ��Ϊ value
//  ShowMessage(get_value_sp('key=value', '', '='));   //Ӧ��Ϊ key
//  ShowMessage(get_value_sp('key=value;', '=', ';')); //Ӧ��Ϊ value
//  ShowMessage(get_value_sp('key=value;', '', '='));  //Ӧ��Ϊ key
function get_value_sp(in_s:string; b_sp:string; e_sp:string):string;

//[2-6]��ǰ�����·��
function app_path1:string;

//[2-7]shellexecute�ļ򻯰汾
procedure shellexecute1(filename1:string);

implementation

//[2-6]��ǰ�����·��
function app_path1:string;
begin
  result:=extractfilepath(application.ExeName);
end;

//[2-7]shellexecute�ļ򻯰汾
procedure shellexecute1(filename1:string);
begin
  shellexecute(application.handle,nil,pchar(filename1),nil,nil,sw_shownormal);
  //shellexecute(application.handle,'open',pchar(filename1),nil,nil,sw_shownormal);

end;

//Ӧ����������İ汾����ʱ�����Ա��ο�����
function get_value_old_v1(in1:string;b_sp1:string;e_sp1:string):string;
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
  if e_pos1=-1 then e_pos1:=length(result); // 2020/2/14 15:22:27 //�����⣬���ֻ��ǡ�ö��ˡ��Ҳ����ַ�����ʱ��Ӧ���������ؿ��ַ���
  result:=copy(result,1,e_pos1);

end;


//delphi ����ʼλ���Ǵ� 1 ��ʼ�ģ�ת������������ʱһ��Ҫע��
//ȡ�ַ����ķָ����ż���ַ���
//����
// key=value; �е� value = get_value(s, '=', ';')
// key=value  �е� value = get_value(s, '=', ';') ���ǿ���ʡ�Ե������Ǹ�������
// key=value; �е� key = get_value(s, '', '=')
//
//�������������ѵĻ������ú���� sp... ϵ���ַ����ָ�����
function get_value(in_s:string; b_sp:string; e_sp:string):string;
var
  //��ʼ���Ƶ�λ��
  b_pos:longint;
  //���ƽ�����λ��
  e_pos:longint;
begin
  if e_sp = '' then e_pos := length(in_s); //û�н�������ȡ�����һ���ַ�
  b_pos := pos(lowercase(b_sp), lowercase(in_s)); //��Ҫ���ִ�Сд
  if b_sp = '' then b_pos := 1;   //û����ʼ������ӵ�һ���ַ���ʼȡ
  if b_pos <= 0 then      //û�ҵ���ʼ���ţ��������ؿ��ַ���
  begin
    result := '';
    exit;

  end;
  b_pos := b_pos + (length(b_sp));  //��ʼλ�û�Ҫ�����ָ����ŵĳ���
  result := copy(in_s, b_pos, length(in_s));  //��ȥ����ʼ�ָ�����֮ǰ�Ĳ��֣��ָ�������Ҳ��Ҫ��

  //---- ���ˣ�ǰ��ȡ������ʼ�ָ����ź���ַ���������ȡ��������ǰ���ַ��Ϳ�����
  e_pos := pos(lowercase(e_sp), lowercase(result));
  e_pos := e_pos - 1;  //��Ϊ�������ű����ǲ���Ҫ�ģ����Բ��ҵ���λ����ǰ��һλ��������Ҫ�����һ���ַ�
  if e_sp = '' then e_pos := length(result);  //û�н����������ȡ�����һ���ַ�
  //if e_pos1=-1 then e_pos1:=length(result); // 2020/2/14 15:22:27 //�����⣬���ֻ��ǡ�ö��ˡ��Ҳ����ַ�����ʱ��Ӧ���������ؿ��ַ���

  if e_pos <= 0 then      //û�ҵ����������������ؿ��ַ���//���ԣ�û�н����ָ����ŵĻ�Ӧ���Ƿ��������ַ����������������ݷ�����д���Ľ���������̰���㷨
  begin
    //result := '';
    exit;

  end;

  //result := copy(result, 1, e_pos);
  result := copy(result, 1, e_pos); //��Ϊdelphi �ַ���λ���Ǵ� 1 ��ʼ����ģ������ַ����ڵ�λ�þ��ǰ������������ַ����ĳ����ˣ�����Ҫ�ټ� 1 ���߼� 1 �����ļ���
  //copy() �Ĳ�������ʼλ�ã���1���𣩺ͳ���

end;


//���ַ����ָ������룬��Ҫ��ϵͳ�Դ��ķָ��ַ���Ϊ����ĺ�������Ϊ�����Ļ��޷������ַ������ж���ָ����ŵ����
//������������ַ�����һ�γ��ֵĵط����зָ��������ĵط��ٳ��ֵĻ�������ᣬ�������ܴ��� xml ������Ƕ��Ƕ�׵����
//b_get_left ȡ�ָ����ַ�������߻����ұ�
function sp_str(in_s:string; sp:string; b_get_left:Boolean):string;
var
  //��ʼ���Ƶ�λ��
  find_pos:longint;      //���ҵ���λ��
  left_last_pos:Integer; //����ַ��������һ���ַ���λ��
  s_left:string;         //��ߵ��ַ���
  s_right:string;        //�ұߵ��ַ���
begin

  find_pos := pos(lowercase(sp), lowercase(in_s)); //��Ҫ���ִ�Сд

  if Length(sp)<1 then find_pos := 0; //û�зָ����͵���û�ҵ�����

  if find_pos <= 0 then      //û�ҵ��ָ����ţ��������أ���ʱ�����ԭ�ַ������ұ��ǿ��ַ����������ڷָ��������� ������1�� �� ������2�� �е�����
  begin
    s_left := in_s;
    s_right := '';

    result := s_left;
    if False = b_get_left then Result := s_right;

    //result := '';
    exit;

  end;

  left_last_pos := find_pos - 1; //��Ϊ�������ű����ǲ���Ҫ�ģ����Բ��ҵ���λ����ǰ��һλ��������Ҫ�����һ���ַ�

  //ȡ���
  s_left := copy(in_s, 1, left_last_pos); //��Ϊdelphi �ַ���λ���Ǵ� 1 ��ʼ����ģ������ַ����ڵ�λ�þ��ǰ������������ַ����ĳ����ˣ�����Ҫ�ټ� 1 ���߼� 1 �����ļ���

  //----
  //ȡ�ұ�
  find_pos := find_pos + (length(sp));  //��ʼλ�û�Ҫ�����ָ����ŵĳ���
  s_right := copy(in_s, find_pos, length(in_s));  //��ȥ����ʼ�ָ�����֮ǰ�Ĳ��֣��ָ�������Ҳ��Ҫ��

  //----
  result := s_left;
  if False = b_get_left then Result := s_right;
  

end;

//�ָ��ַ���ȡ���
function sp_str_left(in_s:string; sp:string):string;
begin
  Result := sp_str(in_s, sp, true);

end;

//�ָ��ַ���ȡ�ұ�
function sp_str_right(in_s:string; sp:string):string;
begin
  Result := sp_str(in_s, sp, false);

end;

//���Ӧ�ú� get_value ��ͬ��ֻ�ǻ��ø����������㷨����
//  ShowMessage(get_value_sp('key=value', '=', ';'));  //Ӧ��Ϊ value
//  ShowMessage(get_value_sp('key=value', '', '='));   //Ӧ��Ϊ key
//  ShowMessage(get_value_sp('key=value;', '=', ';')); //Ӧ��Ϊ value
//  ShowMessage(get_value_sp('key=value;', '', '='));  //Ӧ��Ϊ key
function get_value_sp(in_s:string; b_sp:string; e_sp:string):string;
begin
  Result := in_s;

  if Length(b_sp)<1 then  //��߷ָ�����Ϊ�վͱ�ʾֻҪ�ҷָ�����֮ǰ��
  begin
    Result := sp_str_left(Result, e_sp);
    Exit;
  end;

  if Length(e_sp)<1 then  //�ұ߷ָ�����Ϊ�վͱ�ʾֻҪ��ָ�����֮���
  begin
    Result := sp_str_right(Result, b_sp);
    Exit;
  end;

  //���߶��о�ȡ�ָ�����֮���
  Result := sp_str_right(Result, b_sp);
  Result := sp_str_left(Result, e_sp);
  //Result := sp_str_left(Result, b_sp);
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
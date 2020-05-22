unit cef_functions;



//cef ��׼�������ʵ�ֺ��� //decf3 �汾
//1.ͼƬ���Ϊ
//2.ͼƬ��ַ����
//3.���Ƶ�ǰ��ַ
//4.��ǰ��ַ���������

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  {$IFDEF FPC}

  {$ELSE}
     HTTPApp,
  {$ENDIF}


  cefvcl,
  ceflib,
  Dialogs, StdCtrls,  ExtCtrls, Buttons;
  

//�� cef2623 ���¼��е�����Ӧ�ĺ�������
procedure CEF_BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);

//����ǿհײ˵��İ汾
procedure CEF_BeforeContextMenu_blank(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);

procedure CEF_ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags; out Result: Boolean);

procedure CEF_BeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);

implementation

procedure CEF_BeforeContextMenu_blank(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
var
  i:Integer;
  s:String;
  id:Integer;
  bDfaultMenu:Boolean; //�Ƿ���ȱʡ�˵�
begin
  //model.AddItem(CUSTOMMENUCOMMAND_INSPECTELEMENT, 'Inspect Element'); //clq 2019 ���������һ���Ҽ��˵�

  bDfaultMenu := False;
  for i := 0 to model.GetCount()-1 do
  begin
    s  := model.GetLabelAt(i);
    id := model.GetCommandIdAt(i);

    //ShowMessage(IntToStr(id));

    if LowerCase(Trim(s))='&back' then bDfaultMenu := True; //�з��ز˵�����Ϊ�ǣ���ʵ����׼ȷ
    if 100 = id then bDfaultMenu := True; //�з��ز˵�����Ϊ�ǣ���ʵ����׼ȷ
  end;

  if model.GetCount<7 Then //��ֻ�Ǹ���ʱ�õ�ȡ�ɷ��������Ǳ༭���ǲ˵���Ƚ���
  begin
    //model.get;
    //model.Clear(); //clq �����Ϳ�������Ҽ��˵���
  end;

  if bDfaultMenu Then model.Clear;      //model.Remove();

  //params.;
  //model.SetLabel(); //��ʵҲ���Խ��˵������Ļ�����ȻҲ�����޸��������

  //model.Clear(); //clq �����Ϳ�������Ҽ��˵���

  //��ʵ��Ӧ���ж��Ƿ��� edit ��Щ�ؼ�������ǵĻ���Ӧ�����

end;

//���Ϊ�Ĳ˵���ԭ��� http://newbt.net/ms/vdisk/show_bbs.php?id=1C3BFE02EA55AAF751915FE5AFD58BEC&pid=164
//1.1 ������ BeforeContextMenu �¼��м���˵���Ŀ,������ĿʱҪ�����ڵ� VC �˵�һ�����ò˵������� ID ,Ȼ��Ҫ������һ���¼��и���������� ID ִ�в�ͬ�Ĳ���.
//Ҫ����Ĳ˵������¼��е�һ�� CefMenuModel �ĺ����������,ʾ������:

procedure CEF_BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  //model.AddItem(CUSTOMMENUCOMMAND_INSPECTELEMENT, 'Inspect Element'); //clq 2019 ���������һ���Ҽ��˵�
  //model.Clear(); //clq �����Ϳ�������Ҽ��˵���

  //model.AddItem(100, '���´����д�...'); //clq 2019 ���������һ���Ҽ��˵�
  model.AddItem(200, 'ͼƬ���Ϊ...'); //clq 2019 ���������һ���Ҽ��˵�

end;

//1.2 �� ContextMenuCommand �¼�����Ӧ����˵���.�����е� commandId ����������ǰ�� model.AddItem() �еĵ�һ������.
//ʾ��:
procedure CEF_ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags; out Result: Boolean);
var
  mousePoint: TCefPoint;
  url:string;
begin

  Result := False;
  if (commandId = 200) then
  begin
    //url := params.LinkUrl; //��������ӵ�ַ���������е������ӵĻ�
    //frame.Browser.Host.StartDownload(url);

    //ShowMessage(params.SourceUrl); //������� dom ȡ node �ڵ�� src ����
    frame.Browser.Host.StartDownload(params.SourceUrl);
  end;

end;

//1.3 ���� cef2623 �汾��˵��Ҫ�� BeforeDownload �¼���д���������ر����ļ���ѡ��Ի���//�����õĻ�Ӧ���ǻ����ص�ĳ��Ĭ�ϵ�����·����
procedure CEF_BeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
begin
  ////callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, True); //clq 2019 ���ص�Ĭ��·�� ��2 ������Ӧ�����Ƿ񵯳�ѡ��Ի���
  //callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, False); //clq 2019 ���ص�Ĭ��·�� ��2 ������Ӧ�����Ƿ񵯳�ѡ��Ի���
  //�����������ļ�����ʲô��?

  //callback.Cont(GetLastSavePath() + suggestedName, True);
  //�ο� http://www.freesion.com/article/903186554/ ������ʵ�� callback->Continue("", true); ����˼
  //���� cef2623 ��˵��Ĭ������²���������¼��Ļ��ǲ��ᵯ�����ضԻ����
  callback.Cont('', True);

end;

end.

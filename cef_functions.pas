unit cef_functions;



//cef 标准浏览器的实现函数 //decf3 版本
//1.图片另存为
//2.图片地址复制
//3.复制当前地址
//4.当前地址在浏览器打开

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
  

//在 cef2623 的事件中调用相应的函数即可
procedure CEF_BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);

//这个是空白菜单的版本
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
  bDfaultMenu:Boolean; //是否是缺省菜单
begin
  //model.AddItem(CUSTOMMENUCOMMAND_INSPECTELEMENT, 'Inspect Element'); //clq 2019 这里加入了一个右键菜单

  bDfaultMenu := False;
  for i := 0 to model.GetCount()-1 do
  begin
    s  := model.GetLabelAt(i);
    id := model.GetCommandIdAt(i);

    //ShowMessage(IntToStr(id));

    if LowerCase(Trim(s))='&back' then bDfaultMenu := True; //有返回菜单就认为是，其实并不准确
    if 100 = id then bDfaultMenu := True; //有返回菜单就认为是，其实并不准确
  end;

  if model.GetCount<7 Then //这只是个临时用的取巧方法，当是编辑器是菜单项比较少
  begin
    //model.get;
    //model.Clear(); //clq 这样就可以清除右键菜单了
  end;

  if bDfaultMenu Then model.Clear;      //model.Remove();

  //params.;
  //model.SetLabel(); //其实也可以将菜单项中文化，当然也可以修改命令参数

  //model.Clear(); //clq 这样就可以清除右键菜单了

  //其实还应该判断是否是 edit 这些控件，如果是的话不应该清空

end;

//另存为的菜单，原理见 http://newbt.net/ms/vdisk/show_bbs.php?id=1C3BFE02EA55AAF751915FE5AFD58BEC&pid=164
//1.1 首先在 BeforeContextMenu 事件中加入菜单项目,加入项目时要象早期的 VC 菜单一样订好菜单的命令 ID ,然后要在另外一个事件中根据这个命令 ID 执行不同的操作.
//要加入的菜单是在事件中的一个 CefMenuModel 的函数来加入的,示例如下:

procedure CEF_BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  //model.AddItem(CUSTOMMENUCOMMAND_INSPECTELEMENT, 'Inspect Element'); //clq 2019 这里加入了一个右键菜单
  //model.Clear(); //clq 这样就可以清除右键菜单了

  //model.AddItem(100, '在新窗口中打开...'); //clq 2019 这里加入了一个右键菜单
  model.AddItem(200, '图片另存为...'); //clq 2019 这里加入了一个右键菜单

end;

//1.2 在 ContextMenuCommand 事件中响应这个菜单项.函数中的 commandId 参数就是你前面 model.AddItem() 中的第一个参数.
//示例:
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
    //url := params.LinkUrl; //这个是链接地址，如果点击中的是链接的话
    //frame.Browser.Host.StartDownload(url);

    //ShowMessage(params.SourceUrl); //这个才是 dom 取 node 节点的 src 属性
    frame.Browser.Host.StartDownload(params.SourceUrl);
  end;

end;

//1.3 对于 cef2623 版本来说还要在 BeforeDownload 事件中写明弹出下载本地文件的选择对话框//不设置的话应该是会下载到某个默认的下载路径吧
procedure CEF_BeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
begin
  ////callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, True); //clq 2019 下载的默认路径 第2 个参数应该是是否弹出选择对话框
  //callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, False); //clq 2019 下载的默认路径 第2 个参数应该是是否弹出选择对话框
  //那最后产生的文件名是什么呢?

  //callback.Cont(GetLastSavePath() + suggestedName, True);
  //参考 http://www.freesion.com/article/903186554/ 这里其实是 callback->Continue("", true); 的意思
  //对于 cef2623 来说，默认情况下不重载这个事件的话是不会弹出下载对话框的
  callback.Cont('', True);

end;

end.

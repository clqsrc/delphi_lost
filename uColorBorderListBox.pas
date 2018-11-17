unit uColorBorderListBox;

//简单扩展的 TEdit,因为自定义要求比较高所以没用第三方控件//如果能实现背景色更好

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  //GDIPAPI, GDIPOBJ,
  XMLDoc, XMLIntf,
  ComCtrls, //uTabControlEx,// TPageControl
  //DB,
  Menus //暂时不用 AdvMenus,因为可能会用别的控件
  ;

type
  TColorBorderListBox = class;


  TColorBorderListBox = class(TListBox)

  private
    m_BorderColor : TColor;

    procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
    procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;


    procedure WMGetDlgCode(var Msg : TMessage); //message WM_GETDLGCODE;
    procedure WMMOUSEMOVE(var Msg : TMessage); //message WM_MOUSEMOVE;
    //procedure WMMOUSEMOVE(var Msg : TMessage); message WM_MOUSEMOVE;
    procedure WMLBUTTONDOWN(var Msg : TMessage); //message WM_LBUTTONDOWN;
    procedure WMLBUTTONUP(var Msg : TMessage); //message WM_LBUTTONUP;

    procedure SetBorderColor(const Value: TColor);
    procedure paint2;


  public
    constructor Create(AOwner : TComponent); override;


  published
    property BorderColor : TColor read m_BorderColor write SetBorderColor;



  end;


procedure Register;

implementation


procedure Register;
begin

  //RegisterComponents('UiControlEx', [TPanelEx]);//
  RegisterComponents('UiControlEx', [TColorBorderListBox]);//

end;

procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
    
begin
    DC := GetWindowDC(WinControl.Handle);

    GetWindowRect(WinControl.Handle, R);
    OffsetRect(R, -R.Left, -R.Top);

    Brush := CreateSolidBrush(ColorToRGB(BorderColor));
    FrameRect(DC, R, Brush);
    DeleteObject(Brush);

    if DrawColor then
    begin
        Brush := CreateSolidBrush(ColorToRGB(Color));
        R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);
        FrameRect(DC, R, Brush);
        DeleteObject(Brush);
    end;

    ReleaseDC(WinControl.Handle, DC);
end;

procedure TColorBorderListBox.paint2;
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
  Canvas:TCanvas;//edit 是没有这个的
begin

    DC := GetWindowDC(self.Handle);

  Canvas := TCanvas.Create;//edit 是没有这个的
  Canvas.Handle := DC;


  Canvas.Brush.Color := clred;
  Canvas.FillRect(ClientRect);//这样画实际上只有边框起作用,显示还要有别的消息才行


  Canvas.Free;

  ReleaseDC(self.Handle, DC);
end;


procedure TColorBorderListBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
//    paint2;
end;



procedure TColorBorderListBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
//    paint2;
end;

constructor TColorBorderListBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;

    //UIStyle := GetSUIFormStyle(AOwner);
end;


procedure TColorBorderListBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;


procedure TColorBorderListBox.WMGetDlgCode(var Msg: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TColorBorderListBox.WMMOUSEMOVE(var Msg: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TColorBorderListBox.WMLBUTTONDOWN(var Msg: TMessage);
begin
  inherited;
  Repaint;

end;

procedure TColorBorderListBox.WMLBUTTONUP(var Msg: TMessage);
begin
  inherited;
  Repaint;

end;

end.


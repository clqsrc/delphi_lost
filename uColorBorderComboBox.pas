unit uColorBorderComboBox;

//简单扩展的 TComboBox,因为自定义要求比较高所以没用第三方控件//如果能实现背景色更好

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
  TColorBorderComboBox = class;


  TColorBorderComboBox = class(TComboBox)

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
  RegisterComponents('UiControlEx', [TColorBorderComboBox]);//

end;

  //画箭头[这次是三条线],x y 为中点位置
  procedure DrawTriangle_Down(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pen.Color := color;
    
    //5像素
    ca.MoveTo(x - 4 +1, y);
    ca.LineTo(x + 4, y);
    //3像素
    ca.MoveTo(x - 3 +1, y + 2);
    ca.LineTo(x + 3, y + 2);

    //1像素
    ca.Pixels[x, y + 4] := color;//中心
  end;


//要根据属性判断是否画边框
//procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
    ca:TCanvas;
    pcbi : tagCOMBOBOXINFO;// 2014/5/31 17:34:42 右边的小按钮
    drawBorder:Boolean;
begin
    drawBorder := False;

    DC := GetWindowDC(WinControl.Handle);

    GetWindowRect(WinControl.Handle, R);
    OffsetRect(R, -R.Left, -R.Top);

    Brush := CreateSolidBrush(ColorToRGB(BorderColor));
    //Brush := CreateSolidBrush(ColorToRGB(Color));
    FrameRect(DC, R, Brush);
    DeleteObject(Brush);

    if DrawColor then
    begin
        Brush := CreateSolidBrush(ColorToRGB(Color));
        R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);
        FrameRect(DC, R, Brush);
        DeleteObject(Brush);
    end;

    //--------------------------------------------------
    ca := TCanvas.Create;
    ca.Handle := DC;


    ca.Brush.Color := BorderColor;//clred;
    //ca.FillRect(WinControl.ClientRect);//这样画实际上只有边框起作用,显示还要有别的消息才行

    pcbi.cbSize := SizeOf(pcbi);
    GetComboBoxInfo(WinControl.Handle, pcbi);

    //是否画边框
    //if drawBorder = True then//似乎不行也不用,只要把 BorderColor 改为 背影色就行了
    begin

      ca.FillRect(pcbi.rcButton);//直接画这个小块其实也挺好看了,不过可以考虑再画个白色小箭头

      DrawTriangle_Down(ca,
          pcbi.rcButton.Left + (pcbi.rcButton.Right - pcbi.rcButton.Left) div 2,
          pcbi.rcButton.Top + (pcbi.rcButton.Bottom - pcbi.rcButton.Top) div 2 - 1,
          clWhite);


    end;

    ca.Handle := 0;
    ca.Free;
    //--------------------------------------------------

    ReleaseDC(WinControl.Handle, DC);
end;

procedure TColorBorderComboBox.paint2;
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


procedure TColorBorderComboBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
//    paint2;
end;



procedure TColorBorderComboBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
//    paint2;
end;

constructor TColorBorderComboBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
//    BorderStyle := bsNone;
    BorderWidth := 2;

    BorderColor := $000080FF;

    //UIStyle := GetSUIFormStyle(AOwner);
end;


procedure TColorBorderComboBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;


procedure TColorBorderComboBox.WMGetDlgCode(var Msg: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TColorBorderComboBox.WMMOUSEMOVE(var Msg: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TColorBorderComboBox.WMLBUTTONDOWN(var Msg: TMessage);
begin
  inherited;
  Repaint;

end;

procedure TColorBorderComboBox.WMLBUTTONUP(var Msg: TMessage);
begin
  inherited;
  Repaint;

end;

end.


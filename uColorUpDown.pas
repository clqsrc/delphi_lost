unit uColorUpDown;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CommCtrl,
  Dialogs, StdCtrls, ComCtrls, uColorBorderEdit;

type
  TColorUpDown = class(TUpDown)

  private
    m_BorderColor : TColor;
    m_Color : TColor;
    //分隔颜色
    m_SplitColor : TColor;
    //TUpDown 能自动修改位置,所以要加限制
    m_CanMove : Boolean;
    //绘画偏移
    m_DrawOffUp:Integer;
    m_DrawOffDown:Integer;

    procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
    //可以不允许改变位置吗
    procedure WMPosChange(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
//    procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;


//    procedure WMGetDlgCode(var Msg : TMessage); //message WM_GETDLGCODE;
//    procedure WMMOUSEMOVE(var Msg : TMessage); //message WM_MOUSEMOVE;
    //procedure WMMOUSEMOVE(var Msg : TMessage); message WM_MOUSEMOVE;
    procedure WMLBUTTONDOWN(var Msg : TMessage); message WM_LBUTTONDOWN;
    procedure WMLBUTTONUP(var Msg : TMessage); message WM_LBUTTONUP;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;


    procedure SetBorderColor(const Value: TColor);
    procedure paint2;
    procedure SetColor(const Value: TColor);
    procedure SetSplitColor(const Value: TColor);
    procedure SetCanMove(const Value: Boolean);
    procedure DrawControlBorder(WinControl: TWinControl; BorderColor,
      Color: TColor; DrawColor: Boolean =True);


  public
    constructor Create(AOwner : TComponent); override;


  published
    property BorderColor : TColor read m_BorderColor write SetBorderColor;
    property Color : TColor read m_Color write SetColor;
    property SplitColor : TColor read m_SplitColor write SetSplitColor;
    property CanMove : Boolean read m_CanMove write SetCanMove;



  end;

procedure Register;

implementation

procedure Register;
begin

  RegisterComponents('UiControlEx', [TColorUpDown]);//

end;


procedure TColorUpDown.DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
    ca:TCanvas;
    w,h,l,t:Integer;

  //画空心三角形(箭头)  
  procedure DrawTriangle_Down(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pixels[x, y] := color;//中心
    ca.Pixels[x-1, y] := color;//左
    ca.Pixels[x+1, y] := color;//右
    ca.Pixels[x, y+1] := color;//箭头
    ca.Pixels[x-2, y-1] := color;//箭尾左
    ca.Pixels[x+2, y-1] := color;//箭尾右
    ca.Pixels[x-1, y-1] := color;//箭尾左(内)
    ca.Pixels[x+1, y-1] := color;//箭尾右(内)
  end;

  //画空心三角形(箭头)  
  procedure DrawTriangle_UP(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pixels[x, y] := color;//中心
    ca.Pixels[x-1, y] := color;//左
    ca.Pixels[x+1, y] := color;//右
    ca.Pixels[x, y-1] := color;//箭头
    ca.Pixels[x-2, y+1] := color;//箭尾左
    ca.Pixels[x+2, y+1] := color;//箭尾右
    ca.Pixels[x-1, y+1] := color;//箭尾左(内)
    ca.Pixels[x+1, y+1] := color;//箭尾右(内)
  end;

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

    //FillRect(DC, R, Brush);
    //--------------------------------------------------
    ca := TCanvas.Create;
    ca.Handle := DC;

    ca.Brush.Color := Color;//clBtnFace;
    ca.FillRect(r);

    //
    GetWindowRect(WinControl.Handle, R);//前面 R 修改了,再来一次
    w := R.Right - R.Left;
    h := R.Bottom - R.Top;

    //画中线
    ca.Pen.Color := clGray;
    ca.MoveTo(0 + 1, h div 2);
    ca.LineTo(w - 1, h div 2);

    //画三角形
//    ca.Pixels[w div 2, h div 4] := BorderColor;
//    ca.Pixels[w div 2, Trunc(h * (3/4))] := BorderColor;

    DrawTriangle_UP(ca,   w div 2, h div 4 + m_DrawOffUp,          clBlack);
    DrawTriangle_Down(ca, w div 2, Trunc(h * (3/4)) + m_DrawOffDown, clBlack);

    ca.Handle := 0;
    ca.Free;
    //--------------------------------------------------

    ReleaseDC(WinControl.Handle, DC);

end;


constructor TColorUpDown.Create(AOwner: TComponent);
begin
  inherited;

  m_BorderColor := clWindow;
  m_Color := clBtnFace;
  m_SplitColor := clGray;
  m_CanMove := False;

end;

procedure TColorUpDown.SetCanMove(const Value: Boolean);
begin
  m_CanMove := Value;
end;

procedure TColorUpDown.paint2;
begin

end;

procedure TColorUpDown.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;



procedure TColorUpDown.SetColor(const Value: TColor);
begin
    m_Color := Value;
    Repaint();
end;

procedure TColorUpDown.SetSplitColor(const Value: TColor);
begin
    m_SplitColor := Value;
    Repaint();

end;

procedure TColorUpDown.WMPAINT(var Msg: TMessage);
begin
  inherited;//奇怪没有这个原始的 TUpDown 会画不出来
  DrawControlBorder(self, m_BorderColor, Color);
end;


procedure TColorUpDown.WMPosChange(var Msg: TWMWINDOWPOSCHANGING);
begin

//  if csDesigning in ComponentState then
//  begin
//    inherited;
//    exit;
//  end;

  if CanMove = True then
  begin
    inherited;
    exit;
  end;

  PWindowPos(TMessage(Msg).lParam).Flags :=
      PWindowPos(TMessage(Msg).lParam).Flags or
      SWP_NOMOVE or SWP_NOSIZE;

end;

procedure TColorUpDown.CNNotify(var Message: TWMNotify);
var
  newpos:Integer;
begin
  inherited;

  with Message do
    if NMHdr^.code = UDN_DELTAPOS then
    begin
//      LongBool(Result) := not DoCanChange(PNMUpDown(NMHdr).iPos + PNMUpDown(NMHdr).iDelta,
//                                          PNMUpDown(NMHdr).iDelta);

      newpos := PNMUpDown(NMHdr).iPos;
      //位置的增减量,单击向上箭头此值为负数
      if PNMUpDown(NMHdr).iDelta < 0 then m_DrawOffDown := 1 else
      m_DrawOffUp := 1;
    end;
end;



procedure TColorUpDown.WMLBUTTONDOWN(var Msg: TMessage);
begin
  inherited;

  //m_DrawOff := 2;

end;

procedure TColorUpDown.WMLBUTTONUP(var Msg: TMessage);
begin
  inherited;

  m_DrawOffUp := 0;
  m_DrawOffDown := 0;
end;

end.

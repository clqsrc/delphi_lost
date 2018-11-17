unit uColorCheckBox;

interface

uses
//  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
//  CommCtrl,
//  Dialogs, StdCtrls, ComCtrls;

  Windows, Messages, SysUtils, Variants, Classes, Graphics,

{$IFDEF _REPLACE_STD_CONTROLS_}//替换标准控件
  StdCtrls_std,
{$ELSE}
  StdCtrls,
{$ENDIF}  

  Controls;


type
  TColorCheckBox = class(TCheckBox)

  private
    m_BorderColor : TColor;
    m_Color : TColor;
    //绘画偏移
    m_DrawOffUp:Integer;
    m_DrawOffDown:Integer;

    //procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
    procedure WMPAINT(var Msg : TWMPaint); message WM_PAINT;

    //似乎用这个更好
    //procedure Paint; override;
    //可以不允许改变位置吗
    procedure WMPosChange(var Msg: TWMWINDOWPOSCHANGING); //message WM_WINDOWPOSCHANGING;
    procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;


//    procedure WMGetDlgCode(var Msg : TMessage); //message WM_GETDLGCODE;
//    procedure WMMOUSEMOVE(var Msg : TMessage); //message WM_MOUSEMOVE;
    //procedure WMMOUSEMOVE(var Msg : TMessage); message WM_MOUSEMOVE;
    procedure WMLBUTTONDOWN(var Msg : TMessage); message WM_LBUTTONDOWN;
    procedure WMLBUTTONUP(var Msg : TMessage); message WM_LBUTTONUP;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;

    //根据 TsuiCheckBox 增加如下消息可减轻闪烁
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus (var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure CMFocusChanged(var Msg: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMTextChanged(var Msg : TMessage); message CM_TEXTCHANGED;
    procedure CMFONTCHANGED(var Msg : TMessage); message CM_FONTCHANGED;


    //似乎是点击时的情况
    procedure BMSetState(var Msg: TMessage); message BM_SETSTATE;
    procedure BMSETCHECK(var Msg: TMessage); message BM_SETCHECK;



    procedure SetBorderColor(const Value: TColor);
    procedure paint2;
    procedure SetColor(const Value: TColor);
    procedure DrawControlBorder(WinControl: TWinControl; BorderColor,
      Color: TColor; DrawColor: Boolean =True);


  public
    constructor Create(AOwner : TComponent); override;

    //只为了吸收 WM_PAINT 以免重复刷新
    procedure PaintHandler(var Message: TWMPaint);


  published
    property BorderColor : TColor read m_BorderColor write SetBorderColor;
    property Color : TColor read m_Color write SetColor;



  end;

//替换标准控件,需要加在窗体 pas 所有单元的最后
//type
//  TCheckBox = TColorCheckBox;

{$IFDEF _REPLACE_STD_CONTROLS_}//替换标准控件
type
  TCheckBox = class(TColorCheckBox);
{$ELSE}
{$ENDIF}


procedure Register;

implementation

procedure Register;
begin

  RegisterComponents('UiControlEx', [TColorCheckBox]);//

end;


procedure TColorCheckBox.DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
    RCheck: TRect;//勾选位置的区域
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

  //画勾 
  procedure DrawTriangle_Checked(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pen.Color := clBlack;//clRed;
    ca.Pen.Width := 1;

    //画3个像素的折线就可以了
    ca.MoveTo(x,     y);         //线1
    ca.LineTo(x + 2, y + 2); //线1
    ca.LineTo(x + 7, y - 3); //线3

    ca.MoveTo(x,     y+1);         //线2
    ca.LineTo(x + 2, y+1 + 2); //线2
    ca.LineTo(x + 7, y+1 - 3); //线3

    ca.MoveTo(x,     y+2);         //线2
    ca.LineTo(x + 2, y+2 + 2); //线2
    ca.LineTo(x + 7, y+2 - 3); //线3

  end;



begin
  DC := GetWindowDC(WinControl.Handle);
  try
  //--------------------------------------------------
  //外边框
//
//  GetWindowRect(WinControl.Handle, R);
//  OffsetRect(R, -R.Left, -R.Top);
//
//  Brush := CreateSolidBrush(ColorToRGB(BorderColor));
//  FrameRect(DC, R, Brush);
//  DeleteObject(Brush);

  //--------------------------------------------------

//    if DrawColor then
//    begin
//        Brush := CreateSolidBrush(ColorToRGB(Color));
//        R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);
//        FrameRect(DC, R, Brush);
//        DeleteObject(Brush);
//    end;

    //FillRect(DC, R, Brush);
    //--------------------------------------------------
    //GetWindowRect(WinControl.Handle, R);
    R := WinControl.ClientRect;//用 TCanvas 的话要用这个 rect

    w := R.Right - R.Left;
    h := R.Bottom - R.Top;
    
    //RCheck := Rect(0, 2, 13, 13+2);//勾先区域大小是 13 像素,但和文字一样是上下居中的
    RCheck := Rect(0, 2, 13, 13+2);//勾先区域大小是 13 像素,但和文字一样是上下居中的//应当放在中间
    OffsetRect(RCheck, 0, (h - 16) div 2 );//OffsetRect函数将指定的矩形移动到指定的位置

    ca := TCanvas.Create;
    ca.Handle := DC;

    //--------------------------------------------------
    //背景底色

    ca.Brush.Style := bsSolid;
    ca.Brush.Color := Color;//clBtnFace;
    ca.FillRect(r);    //Exit;
    //--------------------------------------------------
    //勾选区域
    ca.Brush.Style := bsSolid;
    ca.Brush.Color := clGray;//Color;//clBtnFace;
    ca.FillRect(RCheck);    //Exit;

    Inc(RCheck.Top, 1); Inc(RCheck.Left, 1); Inc(RCheck.Right, -1); Inc(RCheck.Bottom, -1);
    ca.Brush.Style := bsSolid;
    ca.Brush.Color := clWhite;//Color;//clBtnFace;
    ca.FillRect(RCheck);    //Exit;
    //--------------------------------------------------
    //文字
    ca.Brush.Style := bsClear;
    ca.Font.Assign(Self.Font);//多语言下非常关键
    ca.TextOut(17, (h - ca.TextHeight('A')) div 2, Caption);

    //--------------------------------------------------

    //
    //GetWindowRect(WinControl.Handle, R);//前面 R 修改了,再来一次
    w := R.Right - R.Left;
    h := R.Bottom - R.Top;

    //画三角形


    if Checked then
    //DrawTriangle_Down(ca, w div 2, Trunc(h * (3/4)) + m_DrawOffDown, clBlack);
    DrawTriangle_Checked(ca, RCheck.Left + 2, RCheck.Top + 4, clBlack);


    //ca.FillRect(r);//test

    ca.Handle := 0;
    ca.Free;
    //--------------------------------------------------
    finally
    ReleaseDC(WinControl.Handle, DC);
    end;

end;


constructor TColorCheckBox.Create(AOwner: TComponent);
begin
  inherited;

  m_BorderColor := clWindow;
  m_Color := clBtnFace;

  //Self.DoubleBuffered := True;
end;


procedure TColorCheckBox.paint2;
begin

end;

procedure TColorCheckBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;



procedure TColorCheckBox.SetColor(const Value: TColor);
begin
    m_Color := Value;
    Repaint();
end;

procedure TColorCheckBox.PaintHandler(var Message: TWMPaint);
var
  I, Clip, SaveIndex: Integer;
  DC: HDC;
  PS: TPaintStruct;
begin

  //ValidateRect(Handle, nil); Exit;//用这个也可以,其实


  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  try
//    PaintWindow(DC);
//    if FControls = nil then PaintWindow(DC) else
//    begin
//      SaveIndex := SaveDC(DC);
//      Clip := SimpleRegion;
//      for I := 0 to FControls.Count - 1 do
//        with TControl(FControls[I]) do
//          if (Visible or (csDesigning in ComponentState) and
//            not (csNoDesignVisible in ControlStyle)) and
//            (csOpaque in ControlStyle) then
//          begin
//            Clip := ExcludeClipRect(DC, Left, Top, Left + Width, Top + Height);
//            if Clip = NullRegion then Break;
//          end;
//      if Clip <> NullRegion then PaintWindow(DC);
//      RestoreDC(DC, SaveIndex);
//    end;
//    PaintControls(DC, nil);
  finally
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
end;

procedure TColorCheckBox.WMPAINT(var Msg: TWMPaint);//TMessage);
var
  sta:TControlState;
begin
//  inherited;//奇怪没有这个原始的 TUpDown 会画不出来

  //Msg.Result

  sta := Self.ControlState;
  //Self.ControlState := [csCustomPaint];
  Include(sta, csCustomPaint);
  Self.ControlState := sta;//似乎无用
//  inherited;
  //Exclude(FControlState, csCustomPaint);
  Exclude(sta, csCustomPaint);
  Self.ControlState := sta;

  //EndPaint()
  //RedrawWindow(

  //Msg.Result := 0;

  DrawControlBorder(self, m_BorderColor, Color);

  PaintHandler(msg);//inherited 中起作用的是这个
//  PaintControls(Msg.DC, nil);

//  UpdateWindow(Self.Handle);

  //inherited;
end;

//procedure Paint(); override;
//begin
//
//end;


procedure TColorCheckBox.WMPosChange(var Msg: TWMWINDOWPOSCHANGING);
begin

//  if csDesigning in ComponentState then
//  begin
//    inherited;
//    exit;
//  end;

//  if CanMove = True then
//  begin
//    inherited;
//    exit;
//  end;
//
//  PWindowPos(TMessage(Msg).lParam).Flags :=
//      PWindowPos(TMessage(Msg).lParam).Flags or
//      SWP_NOMOVE or SWP_NOSIZE;

end;

procedure TColorCheckBox.CNNotify(var Message: TWMNotify);
var
  newpos:Integer;
begin
  inherited;

//  with Message do
//    if NMHdr^.code = UDN_DELTAPOS then
//    begin
////      LongBool(Result) := not DoCanChange(PNMUpDown(NMHdr).iPos + PNMUpDown(NMHdr).iDelta,
////                                          PNMUpDown(NMHdr).iDelta);
//
//      newpos := PNMUpDown(NMHdr).iPos;
//      //位置的增减量,单击向上箭头此值为负数
//      if PNMUpDown(NMHdr).iDelta < 0 then m_DrawOffDown := 1 else
//      m_DrawOffUp := 1;
//    end;
end;



procedure TColorCheckBox.WMLBUTTONDOWN(var Msg: TMessage);
begin
  inherited;

  //m_DrawOff := 2;

  Repaint();//test

end;

procedure TColorCheckBox.WMLBUTTONUP(var Msg: TMessage);
begin
  inherited;

  m_DrawOffUp := 0;
  m_DrawOffDown := 0;

  Repaint();//test

end;

procedure TColorCheckBox.BMSetState(var Msg: TMessage);
begin
  inherited;//这个会画那个左边的勾选框

  //if Msg.WParam = 1 then Checked := True;

  //Checked := True;

  Repaint();

end;

procedure TColorCheckBox.BMSETCHECK(var Msg: TMessage);
begin
  inherited;

  //if Msg.WParam = 1 then Checked := True;

  Repaint();

end;  

procedure TColorCheckBox.WMSetFocus(var Msg: TWMSetFocus);
begin
//  inherited;//这个会画那个虚线框

  Repaint();

end;

procedure TColorCheckBox.WMKillFocus(var Msg: TWMKillFocus);
begin
    inherited;

    Repaint();
end;

//根据 TsuiCheckBox 似乎有处理这个
procedure TColorCheckBox.WMEARSEBKGND(var Msg : TMessage);
begin
   // do nothing
end;

procedure TColorCheckBox.CMFocusChanged(var Msg: TCMFocusChanged);
begin
    inherited;

    Repaint();
end;

procedure TColorCheckBox.CMFONTCHANGED(var Msg: TMessage);
begin
    Repaint();
end;

procedure TColorCheckBox.CMTextChanged(var Msg: TMessage);
begin
    Repaint();
end;


end.

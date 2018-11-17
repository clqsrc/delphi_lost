unit uColorCheckBox;

interface

uses
//  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
//  CommCtrl,
//  Dialogs, StdCtrls, ComCtrls;

  Windows, Messages, SysUtils, Variants, Classes, Graphics,

{$IFDEF _REPLACE_STD_CONTROLS_}//�滻��׼�ؼ�
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
    //�滭ƫ��
    m_DrawOffUp:Integer;
    m_DrawOffDown:Integer;

    //procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
    procedure WMPAINT(var Msg : TWMPaint); message WM_PAINT;

    //�ƺ����������
    //procedure Paint; override;
    //���Բ�����ı�λ����
    procedure WMPosChange(var Msg: TWMWINDOWPOSCHANGING); //message WM_WINDOWPOSCHANGING;
    procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;


//    procedure WMGetDlgCode(var Msg : TMessage); //message WM_GETDLGCODE;
//    procedure WMMOUSEMOVE(var Msg : TMessage); //message WM_MOUSEMOVE;
    //procedure WMMOUSEMOVE(var Msg : TMessage); message WM_MOUSEMOVE;
    procedure WMLBUTTONDOWN(var Msg : TMessage); message WM_LBUTTONDOWN;
    procedure WMLBUTTONUP(var Msg : TMessage); message WM_LBUTTONUP;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;

    //���� TsuiCheckBox ����������Ϣ�ɼ�����˸
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus (var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure CMFocusChanged(var Msg: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMTextChanged(var Msg : TMessage); message CM_TEXTCHANGED;
    procedure CMFONTCHANGED(var Msg : TMessage); message CM_FONTCHANGED;


    //�ƺ��ǵ��ʱ�����
    procedure BMSetState(var Msg: TMessage); message BM_SETSTATE;
    procedure BMSETCHECK(var Msg: TMessage); message BM_SETCHECK;



    procedure SetBorderColor(const Value: TColor);
    procedure paint2;
    procedure SetColor(const Value: TColor);
    procedure DrawControlBorder(WinControl: TWinControl; BorderColor,
      Color: TColor; DrawColor: Boolean =True);


  public
    constructor Create(AOwner : TComponent); override;

    //ֻΪ������ WM_PAINT �����ظ�ˢ��
    procedure PaintHandler(var Message: TWMPaint);


  published
    property BorderColor : TColor read m_BorderColor write SetBorderColor;
    property Color : TColor read m_Color write SetColor;



  end;

//�滻��׼�ؼ�,��Ҫ���ڴ��� pas ���е�Ԫ�����
//type
//  TCheckBox = TColorCheckBox;

{$IFDEF _REPLACE_STD_CONTROLS_}//�滻��׼�ؼ�
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
    RCheck: TRect;//��ѡλ�õ�����
    ca:TCanvas;
    w,h,l,t:Integer;

  //������������(��ͷ)  
  procedure DrawTriangle_Down(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pixels[x, y] := color;//����
    ca.Pixels[x-1, y] := color;//��
    ca.Pixels[x+1, y] := color;//��
    ca.Pixels[x, y+1] := color;//��ͷ
    ca.Pixels[x-2, y-1] := color;//��β��
    ca.Pixels[x+2, y-1] := color;//��β��
    ca.Pixels[x-1, y-1] := color;//��β��(��)
    ca.Pixels[x+1, y-1] := color;//��β��(��)
  end;

  //������������(��ͷ)  
  procedure DrawTriangle_UP(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pixels[x, y] := color;//����
    ca.Pixels[x-1, y] := color;//��
    ca.Pixels[x+1, y] := color;//��
    ca.Pixels[x, y-1] := color;//��ͷ
    ca.Pixels[x-2, y+1] := color;//��β��
    ca.Pixels[x+2, y+1] := color;//��β��
    ca.Pixels[x-1, y+1] := color;//��β��(��)
    ca.Pixels[x+1, y+1] := color;//��β��(��)
  end;

  //���� 
  procedure DrawTriangle_Checked(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pen.Color := clBlack;//clRed;
    ca.Pen.Width := 1;

    //��3�����ص����߾Ϳ�����
    ca.MoveTo(x,     y);         //��1
    ca.LineTo(x + 2, y + 2); //��1
    ca.LineTo(x + 7, y - 3); //��3

    ca.MoveTo(x,     y+1);         //��2
    ca.LineTo(x + 2, y+1 + 2); //��2
    ca.LineTo(x + 7, y+1 - 3); //��3

    ca.MoveTo(x,     y+2);         //��2
    ca.LineTo(x + 2, y+2 + 2); //��2
    ca.LineTo(x + 7, y+2 - 3); //��3

  end;



begin
  DC := GetWindowDC(WinControl.Handle);
  try
  //--------------------------------------------------
  //��߿�
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
    R := WinControl.ClientRect;//�� TCanvas �Ļ�Ҫ����� rect

    w := R.Right - R.Left;
    h := R.Bottom - R.Top;
    
    //RCheck := Rect(0, 2, 13, 13+2);//���������С�� 13 ����,��������һ�������¾��е�
    RCheck := Rect(0, 2, 13, 13+2);//���������С�� 13 ����,��������һ�������¾��е�//Ӧ�������м�
    OffsetRect(RCheck, 0, (h - 16) div 2 );//OffsetRect������ָ���ľ����ƶ���ָ����λ��

    ca := TCanvas.Create;
    ca.Handle := DC;

    //--------------------------------------------------
    //������ɫ

    ca.Brush.Style := bsSolid;
    ca.Brush.Color := Color;//clBtnFace;
    ca.FillRect(r);    //Exit;
    //--------------------------------------------------
    //��ѡ����
    ca.Brush.Style := bsSolid;
    ca.Brush.Color := clGray;//Color;//clBtnFace;
    ca.FillRect(RCheck);    //Exit;

    Inc(RCheck.Top, 1); Inc(RCheck.Left, 1); Inc(RCheck.Right, -1); Inc(RCheck.Bottom, -1);
    ca.Brush.Style := bsSolid;
    ca.Brush.Color := clWhite;//Color;//clBtnFace;
    ca.FillRect(RCheck);    //Exit;
    //--------------------------------------------------
    //����
    ca.Brush.Style := bsClear;
    ca.Font.Assign(Self.Font);//�������·ǳ��ؼ�
    ca.TextOut(17, (h - ca.TextHeight('A')) div 2, Caption);

    //--------------------------------------------------

    //
    //GetWindowRect(WinControl.Handle, R);//ǰ�� R �޸���,����һ��
    w := R.Right - R.Left;
    h := R.Bottom - R.Top;

    //��������


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

  //ValidateRect(Handle, nil); Exit;//�����Ҳ����,��ʵ


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
//  inherited;//���û�����ԭʼ�� TUpDown �ử������

  //Msg.Result

  sta := Self.ControlState;
  //Self.ControlState := [csCustomPaint];
  Include(sta, csCustomPaint);
  Self.ControlState := sta;//�ƺ�����
//  inherited;
  //Exclude(FControlState, csCustomPaint);
  Exclude(sta, csCustomPaint);
  Self.ControlState := sta;

  //EndPaint()
  //RedrawWindow(

  //Msg.Result := 0;

  DrawControlBorder(self, m_BorderColor, Color);

  PaintHandler(msg);//inherited �������õ������
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
//      //λ�õ�������,�������ϼ�ͷ��ֵΪ����
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
  inherited;//����ử�Ǹ���ߵĹ�ѡ��

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
//  inherited;//����ử�Ǹ����߿�

  Repaint();

end;

procedure TColorCheckBox.WMKillFocus(var Msg: TWMKillFocus);
begin
    inherited;

    Repaint();
end;

//���� TsuiCheckBox �ƺ��д������
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

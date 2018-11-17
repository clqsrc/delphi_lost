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
    //�ָ���ɫ
    m_SplitColor : TColor;
    //TUpDown ���Զ��޸�λ��,����Ҫ������
    m_CanMove : Boolean;
    //�滭ƫ��
    m_DrawOffUp:Integer;
    m_DrawOffDown:Integer;

    procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
    //���Բ�����ı�λ����
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
    GetWindowRect(WinControl.Handle, R);//ǰ�� R �޸���,����һ��
    w := R.Right - R.Left;
    h := R.Bottom - R.Top;

    //������
    ca.Pen.Color := clGray;
    ca.MoveTo(0 + 1, h div 2);
    ca.LineTo(w - 1, h div 2);

    //��������
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
  inherited;//���û�����ԭʼ�� TUpDown �ử������
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
      //λ�õ�������,�������ϼ�ͷ��ֵΪ����
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

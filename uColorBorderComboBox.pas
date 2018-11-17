unit uColorBorderComboBox;

//����չ�� TComboBox,��Ϊ�Զ���Ҫ��Ƚϸ�����û�õ������ؼ�//�����ʵ�ֱ���ɫ����

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  //GDIPAPI, GDIPOBJ,
  XMLDoc, XMLIntf,
  ComCtrls, //uTabControlEx,// TPageControl
  //DB,
  Menus //��ʱ���� AdvMenus,��Ϊ���ܻ��ñ�Ŀؼ�
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

  //����ͷ[�����������],x y Ϊ�е�λ��
  procedure DrawTriangle_Down(ca:TCanvas; x, y:Integer; color:TColor);
  begin
    ca.Pen.Color := color;
    
    //5����
    ca.MoveTo(x - 4 +1, y);
    ca.LineTo(x + 4, y);
    //3����
    ca.MoveTo(x - 3 +1, y + 2);
    ca.LineTo(x + 3, y + 2);

    //1����
    ca.Pixels[x, y + 4] := color;//����
  end;


//Ҫ���������ж��Ƿ񻭱߿�
//procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
    ca:TCanvas;
    pcbi : tagCOMBOBOXINFO;// 2014/5/31 17:34:42 �ұߵ�С��ť
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
    //ca.FillRect(WinControl.ClientRect);//������ʵ����ֻ�б߿�������,��ʾ��Ҫ�б����Ϣ����

    pcbi.cbSize := SizeOf(pcbi);
    GetComboBoxInfo(WinControl.Handle, pcbi);

    //�Ƿ񻭱߿�
    //if drawBorder = True then//�ƺ�����Ҳ����,ֻҪ�� BorderColor ��Ϊ ��Ӱɫ������
    begin

      ca.FillRect(pcbi.rcButton);//ֱ�ӻ����С����ʵҲͦ�ÿ���,�������Կ����ٻ�����ɫС��ͷ

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
  Canvas:TCanvas;//edit ��û�������
begin

    DC := GetWindowDC(self.Handle);

  Canvas := TCanvas.Create;//edit ��û�������
  Canvas.Handle := DC;


  Canvas.Brush.Color := clred;
  Canvas.FillRect(ClientRect);//������ʵ����ֻ�б߿�������,��ʾ��Ҫ�б����Ϣ����


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


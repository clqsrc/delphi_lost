unit uColorBorderListBox;

//����չ�� TEdit,��Ϊ�Զ���Ҫ��Ƚϸ�����û�õ������ؼ�//�����ʵ�ֱ���ɫ����

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


unit uImagePanel;

//������ͼ�����: ��ˢ�±���,��͸��

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  //GDIPAPI, GDIPOBJ,
  //XMLDoc, XMLIntf,
  ComCtrls,// TPageControl
  //DB,
  Menus //��ʱ���� AdvMenus,��Ϊ���ܻ��ñ�Ŀؼ�
  ;

type
  TBorderBrawKind = (bbkLeft, bbkTop, bbkRight, bbkBottom);//�߿���ʽ
  TBorderBrawKinds = set of TBorderBrawKind;

  TImagePanel = class;

  //TPanelEx = class(TPanel)//(TCustomControl)//(TPanel)
  TImagePanel = class(TPanel)//(TCustomControl)//(TPanel)

  private
    FOnPaint: TNotifyEvent;
    m_Transparent: Boolean;
    m_BorderColor: TColor;

    FBkImage: TPicture;
    FFillImage: TPicture;
    FBorderBrawKinds: TBorderBrawKinds;
    FBorderWidth_v: Integer;

    //virtual;//TPanel ��������Ҫ�� override ,������ virtual . �� override �Ļ�������������ʾ�����ؼ�
    procedure Paint;override;
    procedure SetTransparent(const Value: Boolean);
    procedure SetBkImage(const Value: TPicture);
    procedure SetFillImage(const Value: TPicture);
    procedure DrawFillImage(Canvas: TCanvas);
    procedure SetBorderColor(const Value: TColor);
    function IsBorderBrawKindsStored: Boolean;
    procedure SetBorderBrawKinds(const Value: TBorderBrawKinds);
    procedure DrawFrameRect(Canvas: TCanvas; r: TRect);
    procedure DrawFrameRect2(Canvas: TCanvas; r: TRect);
    procedure SetBorderWidth_v(const Value: Integer);


  public
    isFree:Boolean;//�Ƿ��Ѿ��ͷ�//if not Assigned(Self) then Exit;//�����Ҳ��

    procedure  WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Canvas;
  published
    //OnPaint;
    //property OnPaint: TNotifyEvent read FOnPaint write FOnPaint stored IsForm;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    //�Ƿ�͸��
    property Transparent : Boolean Read m_Transparent Write SetTransparent default false;
    //�߿���ɫ
    property BorderColor : TColor read m_BorderColor write SetBorderColor;


    //����ͼ
    property BkImage: TPicture read FBkImage write SetBkImage;
    //�󱳾�ͼ
    property FillImage: TPicture read FFillImage write SetFillImage;


    property Align;
    property Anchors;
    property Caption;
    property TabOrder;
    property Color;

    //���� TGraphicControl����Ҫ�� png ��չ����ʱ���ƺ�ֻ�������������˸����Ϊ��û��  WM_ERASEBKGND ��Ӧ
    property DoubleBuffered;
    property BorderBrawKinds: TBorderBrawKinds read FBorderBrawKinds write SetBorderBrawKinds stored IsBorderBrawKindsStored default [bbkLeft, bbkTop, bbkRight, bbkBottom];
    //ֻӰ��滭,��Ӱ�첼�ֵ����� BorderWidth // 2014-11-1 19:33:43
    property BorderWidth_v: Integer read FBorderWidth_v write SetBorderWidth_v default 0;

  end;



procedure DoTrans(Canvas : TCanvas; Control : TWinControl);

procedure Register;

implementation


//���� SUIPublic.pas ,ԭ���ƺ����Ȱѿؼ���������͸����,Ȼ��Ѹ��ؼ�����ȥ
procedure DoTrans(Canvas : TCanvas; Control : TWinControl);
var
    DC : HDC;
    SaveIndex : HDC;
    Position: TPoint;
begin
    if Control.Parent <> nil then
    begin
{$R-}
        DC := Canvas.Handle;
        SaveIndex := SaveDC(DC);
        GetViewportOrgEx(DC, Position);
        SetViewportOrgEx(DC, Position.X - Control.Left, Position.Y - Control.Top, nil);
        IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight);
        Control.Parent.Perform(WM_ERASEBKGND, DC, 0);
        Control.Parent.Perform(WM_PAINT, DC, 0);
        RestoreDC(DC, SaveIndex);
{$R+}
    end;
end;



procedure Register;
begin

  RegisterComponents('UiControlEx', [TImagePanel]);//

end;



{ TImagePanel }

constructor TImagePanel.Create(AOwner: TComponent);
begin
  inherited;
  isFree := False;

  //ͼƬ�ؼ�һ��Ҫ����
  FBkImage := TPicture.Create;
  //FActiveBkImage := TPicture.Create;
  FFillImage := TPicture.Create;

  FBorderBrawKinds := [bbkLeft, bbkTop, bbkRight, bbkBottom];

end;

destructor TImagePanel.Destroy;
begin
  isFree := True;

  FreeAndNil(FBkImage);
  FreeAndNil(FFillImage);
  //FreeAndNil(FActiveBkImage);  

  inherited;
end;

//�������صı߿�
procedure TImagePanel.DrawFrameRect(Canvas: TCanvas; r:TRect);
begin

  //--------------------------------------------------
  // 2014/4/2 14:52:17 ����߿���ɫ
  //if BorderWidth>0 then
  begin
    Canvas.Pen.Width := 1;
    //Canvas.Pen.Color := BorderColor;
    //Canvas.FrameRect(Self.ClientRect);//�����ƺ�ֻ��һ�����ؿ��

    Canvas.MoveTo(r.Left, r.Top);

    if bbkTop in FBorderBrawKinds then Canvas.LineTo(r.Right-1, r.Top) else Canvas.MoveTo(r.Right-1, r.Top);

    if bbkRight in FBorderBrawKinds then Canvas.LineTo(r.Right-1, r.Bottom-1) else Canvas.MoveTo(r.Right-1, r.Bottom-1);
    if bbkBottom in FBorderBrawKinds then Canvas.LineTo(r.Left, r.Bottom-1) else Canvas.MoveTo(r.Left, r.Bottom-1);
    if bbkLeft in FBorderBrawKinds then Canvas.LineTo(r.Left, r.Top) else Canvas.MoveTo(r.Left, r.Top);

    //4�����ϵĵ���Ҫ����һ��



  end;
end;

//�������صı߿�
procedure TImagePanel.DrawFrameRect2(Canvas: TCanvas; r:TRect);
var
  i:Integer;
  darwBorderWidth:Integer;
begin
  darwBorderWidth := BorderWidth;
  if BorderWidth_v > 0 then darwBorderWidth := BorderWidth_v;

  //--------------------------------------------------
  // 2014/4/2 14:52:17 ����߿���ɫ
  //for i := 0 to BorderWidth-1 do
  for i := 0 to darwBorderWidth-1 do
  begin
    Canvas.Pen.Width := 1;
    //Canvas.Pen.Color := BorderColor;
    //Canvas.FrameRect(Self.ClientRect);//�����ƺ�ֻ��һ�����ؿ��

    //Canvas.MoveTo(r.Left, r.Top);

    //��Ϊ���ÿ��Ǻ���� moveto ���Կ���ֱ�ӻ������� x,y �����ټ�1��
    {
    if bbkTop    in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Top + i); Canvas.LineTo(r.Right-0, r.Top + i) ; end;
    if bbkRight  in FBorderBrawKinds then begin Canvas.MoveTo(r.Right-1 - i, r.Top); Canvas.LineTo(r.Right-1 - i, r.Bottom-1) ; end;
    ////if bbkBottom in FBorderBrawKinds then begin Canvas.MoveTo(r.Right-1, r.Bottom-1);  Canvas.LineTo(r.Left-1, r.Bottom-1) ;  end;
    if bbkBottom in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Bottom-1 - i); Canvas.LineTo(r.Right-0, r.Bottom-1 - i) ; end;
    ////if bbkLeft   in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Bottom-1); Canvas.LineTo(r.Left, r.Top) ;   end;
    if bbkLeft   in FBorderBrawKinds then begin Canvas.MoveTo(r.left-0 + i, r.Top); Canvas.LineTo(r.left-0 + i, r.Bottom-1) ; end;
    }
    // 2014-10-5 13:59:53 //�ƺ� r,b ���򶼲��ÿ��Ǽ� 1 ������//����ǰ��������ƺ��� web/css ��ʽ�γɵ�ͼ�����Щ,�Ժ��ټ��ݰ�
    //{
    if bbkTop    in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Top + i); Canvas.LineTo(r.Right, r.Top + i) ; end;
    if bbkRight  in FBorderBrawKinds then begin Canvas.MoveTo(r.Right-1 - i, r.Top); Canvas.LineTo(r.Right -1 - i, r.Bottom) ; end;
    if bbkBottom in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Bottom-1 - i); Canvas.LineTo(r.Right, r.Bottom-1 - i) ; end;
    if bbkLeft   in FBorderBrawKinds then begin Canvas.MoveTo(r.left + i, r.Top); Canvas.LineTo(r.left + i, r.Bottom) ; end;
    //}
  end;
end;

procedure TImagePanel.DrawFillImage(Canvas: TCanvas);
var
  r:TRect;
  i:Integer;
  darwBorderWidth:Integer;
begin
  darwBorderWidth := BorderWidth;
  if BorderWidth_v > 0 then darwBorderWidth := BorderWidth_v;

  //--------------------------------------------------
  // 2014/4/2 14:52:17 ����߿���ɫ
  //if BorderWidth>0 then
  if darwBorderWidth>0 then
  begin
    Canvas.Pen.Width := 1;//BorderWidth; //ֱ�����ñʵĿ�ȵĻ��ử��Բ��(���Ǵ�������ı�)
    Canvas.Pen.Color := BorderColor;
    //Canvas.FrameRect(Self.ClientRect);//�����ƺ�ֻ��һ�����ؿ��
    r := Self.ClientRect;
//    Canvas.MoveTo(1, 1);
//    Canvas.LineTo(r.Right-BorderWidth, 1);
//    Canvas.LineTo(r.Right-BorderWidth, r.Bottom-BorderWidth);
//    Canvas.LineTo(1, r.Bottom-BorderWidth);
//    Canvas.LineTo(1, 1);

    //���������ȫ�պ�ʱ�ܺ�,����ֻ��Ҫ�����ֱ߿�ʱ����4�������γ�������
//    for i := 0 to BorderWidth-1 do
//    begin
//      DrawFrameRect(Canvas, r);
//      //DrawFrameRect2(Canvas, r);
//      R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);
//    end;

    DrawFrameRect2(Canvas, r);

    //DrawFrameRect(Canvas, r);

  end;

  //������ʿ�ķ�������Բ��?ֻ��һ������
  //R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);


  //--------------------------------------------------


  if (Assigned(FillImage))and(Assigned(FillImage.Graphic))
  //then Canvas.Draw(0, 0, FillImage.Graphic);
  then Canvas.StretchDraw(Self.ClientRect, FillImage.Graphic);//����õı���ͼӦ���������,����������û��͸����

end;


function TImagePanel.IsBorderBrawKindsStored: Boolean;
begin
  Result := True;
end;

procedure TImagePanel.Paint;
var
  Buf : TBitmap;

begin
  inherited;//����������Ļ�������ʾ���ϵ��ӿؼ�(��ʵ�������ǿ��Ե�)

  {
  //--------------------------------------------------
  //͸���õ�˫����

  Buf := TBitmap.Create();
  Buf.Height := Height;
  Buf.Width := Width;

  //if m_Transparent then
    DoTrans(Buf.Canvas, self);

  //--------------------------------------------------

  //--------------------------------------------------
  //͸���õ�˫����
  BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);
  Buf.Free();

  //--------------------------------------------------
  }
  //DoTrans(Canvas, self);//����ֱ������Ҳ����,��֪����ʲô����

  if m_Transparent then
  begin
    //DoTrans(Canvas, self);//����ֱ������Ҳ����,��֪����ʲô����

    //--------------------------------------------------
    //͸���õ�˫����

    Buf := TBitmap.Create();
    Buf.Height := Height;
    Buf.Width := Width;

    //if m_Transparent then
      DoTrans(Buf.Canvas, self);

    //--------------------------------------------------
    DrawFillImage(Buf.Canvas);
    if Assigned(BkImage)
    then Buf.Canvas.Draw(0, 0, BkImage.Graphic);

    //--------------------------------------------------
    //͸���õ�˫����
    BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);
    Buf.Free();

    //--------------------------------------------------
  end
  else
  begin
    //������Ǵ� Tpanel �̳е�,��Ҫ�Լ���һ��
//    Canvas.Brush.Color := Color;
//    Canvas.FillRect(ClientRect);
    DrawFillImage(Canvas);
  end;

  if Assigned(FOnPaint) then FOnPaint(Self);

end;

procedure TImagePanel.SetBkImage(const Value: TPicture);
begin
  //FBkImage := Value;
  FBkImage.Assign(Value);  
end;

procedure TImagePanel.SetBorderBrawKinds(const Value: TBorderBrawKinds);
begin
  FBorderBrawKinds := Value;
  Repaint();
end;

procedure TImagePanel.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TImagePanel.SetFillImage(const Value: TPicture);
begin
  //FFillImage := Value;
  FFillImage.Assign(Value);

end;

procedure TImagePanel.SetTransparent(const Value: Boolean);
begin
  m_Transparent := Value;
end;

procedure TImagePanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
//   Message.Result := 1;
  //����Ϣ����ֵΪ1����ʾ������ϵͳĬ����Ϣ����DefWindowProc������//���������û����

end;



procedure TImagePanel.SetBorderWidth_v(const Value: Integer);
begin
  FBorderWidth_v := Value;
end;

end.

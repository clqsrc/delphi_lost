unit uImagePanel;

//带背景图的面板: 不刷新背景,能透明

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  //GDIPAPI, GDIPOBJ,
  //XMLDoc, XMLIntf,
  ComCtrls,// TPageControl
  //DB,
  Menus //暂时不用 AdvMenus,因为可能会用别的控件
  ;

type
  TBorderBrawKind = (bbkLeft, bbkTop, bbkRight, bbkBottom);//边框样式
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

    //virtual;//TPanel 就有所以要用 override ,不能用 virtual . 用 override 的话才能在其上显示其他控件
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
    isFree:Boolean;//是否已经释放//if not Assigned(Self) then Exit;//用这个也行

    procedure  WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Canvas;
  published
    //OnPaint;
    //property OnPaint: TNotifyEvent read FOnPaint write FOnPaint stored IsForm;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    //是否透明
    property Transparent : Boolean Read m_Transparent Write SetTransparent default false;
    //边框颜色
    property BorderColor : TColor read m_BorderColor write SetBorderColor;


    //背景图
    property BkImage: TPicture read FBkImage write SetBkImage;
    //大背景图
    property FillImage: TPicture read FFillImage write SetFillImage;


    property Align;
    property Anchors;
    property Caption;
    property TabOrder;
    property Color;

    //当有 TGraphicControl（主要是 png 扩展）的时候似乎只能用这个消除闪烁，因为其没有  WM_ERASEBKGND 响应
    property DoubleBuffered;
    property BorderBrawKinds: TBorderBrawKinds read FBorderBrawKinds write SetBorderBrawKinds stored IsBorderBrawKindsStored default [bbkLeft, bbkTop, bbkRight, bbkBottom];
    //只影响绘画,不影响布局的虚拟 BorderWidth // 2014-11-1 19:33:43
    property BorderWidth_v: Integer read FBorderWidth_v write SetBorderWidth_v default 0;

  end;



procedure DoTrans(Canvas : TCanvas; Control : TWinControl);

procedure Register;

implementation


//来自 SUIPublic.pas ,原理似乎是先把控件做成区域透明的,然后把父控件画上去
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

  //图片控件一定要创建
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

//单个像素的边框
procedure TImagePanel.DrawFrameRect(Canvas: TCanvas; r:TRect);
begin

  //--------------------------------------------------
  // 2014/4/2 14:52:17 加入边框颜色
  //if BorderWidth>0 then
  begin
    Canvas.Pen.Width := 1;
    //Canvas.Pen.Color := BorderColor;
    //Canvas.FrameRect(Self.ClientRect);//这样似乎只有一个像素宽度

    Canvas.MoveTo(r.Left, r.Top);

    if bbkTop in FBorderBrawKinds then Canvas.LineTo(r.Right-1, r.Top) else Canvas.MoveTo(r.Right-1, r.Top);

    if bbkRight in FBorderBrawKinds then Canvas.LineTo(r.Right-1, r.Bottom-1) else Canvas.MoveTo(r.Right-1, r.Bottom-1);
    if bbkBottom in FBorderBrawKinds then Canvas.LineTo(r.Left, r.Bottom-1) else Canvas.MoveTo(r.Left, r.Bottom-1);
    if bbkLeft in FBorderBrawKinds then Canvas.LineTo(r.Left, r.Top) else Canvas.MoveTo(r.Left, r.Top);

    //4个角上的点需要修正一下



  end;
end;

//单个像素的边框
procedure TImagePanel.DrawFrameRect2(Canvas: TCanvas; r:TRect);
var
  i:Integer;
  darwBorderWidth:Integer;
begin
  darwBorderWidth := BorderWidth;
  if BorderWidth_v > 0 then darwBorderWidth := BorderWidth_v;

  //--------------------------------------------------
  // 2014/4/2 14:52:17 加入边框颜色
  //for i := 0 to BorderWidth-1 do
  for i := 0 to darwBorderWidth-1 do
  begin
    Canvas.Pen.Width := 1;
    //Canvas.Pen.Color := BorderColor;
    //Canvas.FrameRect(Self.ClientRect);//这样似乎只有一个像素宽度

    //Canvas.MoveTo(r.Left, r.Top);

    //因为不用考虑后面的 moveto 所以可以直接画到最后的 x,y 不用再减1了
    {
    if bbkTop    in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Top + i); Canvas.LineTo(r.Right-0, r.Top + i) ; end;
    if bbkRight  in FBorderBrawKinds then begin Canvas.MoveTo(r.Right-1 - i, r.Top); Canvas.LineTo(r.Right-1 - i, r.Bottom-1) ; end;
    ////if bbkBottom in FBorderBrawKinds then begin Canvas.MoveTo(r.Right-1, r.Bottom-1);  Canvas.LineTo(r.Left-1, r.Bottom-1) ;  end;
    if bbkBottom in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Bottom-1 - i); Canvas.LineTo(r.Right-0, r.Bottom-1 - i) ; end;
    ////if bbkLeft   in FBorderBrawKinds then begin Canvas.MoveTo(r.Left, r.Bottom-1); Canvas.LineTo(r.Left, r.Top) ;   end;
    if bbkLeft   in FBorderBrawKinds then begin Canvas.MoveTo(r.left-0 + i, r.Top); Canvas.LineTo(r.left-0 + i, r.Bottom-1) ; end;
    }
    // 2014-10-5 13:59:53 //似乎 r,b 方向都不用考虑减 1 的问题//不过前面的那种似乎与 web/css 方式形成的图像更像些,以后再兼容吧
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
  // 2014/4/2 14:52:17 加入边框颜色
  //if BorderWidth>0 then
  if darwBorderWidth>0 then
  begin
    Canvas.Pen.Width := 1;//BorderWidth; //直接设置笔的宽度的话会画出圆角(除非创建特殊的笔)
    Canvas.Pen.Color := BorderColor;
    //Canvas.FrameRect(Self.ClientRect);//这样似乎只有一个像素宽度
    r := Self.ClientRect;
//    Canvas.MoveTo(1, 1);
//    Canvas.LineTo(r.Right-BorderWidth, 1);
//    Canvas.LineTo(r.Right-BorderWidth, r.Bottom-BorderWidth);
//    Canvas.LineTo(1, r.Bottom-BorderWidth);
//    Canvas.LineTo(1, 1);

    //这个方法在全闭合时很好,但在只需要画部分边框时会在4个角上形成三角形
//    for i := 0 to BorderWidth-1 do
//    begin
//      DrawFrameRect(Canvas, r);
//      //DrawFrameRect2(Canvas, r);
//      R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);
//    end;

    DrawFrameRect2(Canvas, r);

    //DrawFrameRect(Canvas, r);

  end;

  //上面设笔宽的方法会有圆角?只能一条条画
  //R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);


  //--------------------------------------------------


  if (Assigned(FillImage))and(Assigned(FillImage.Graphic))
  //then Canvas.Draw(0, 0, FillImage.Graphic);
  then Canvas.StretchDraw(Self.ClientRect, FillImage.Graphic);//填充用的背景图应该是拉伸的,不过这样就没法透明了

end;


function TImagePanel.IsBorderBrawKindsStored: Boolean;
begin
  Result := True;
end;

procedure TImagePanel.Paint;
var
  Buf : TBitmap;

begin
  inherited;//不调用这个的话不能显示其上的子控件(其实在这里是可以的)

  {
  //--------------------------------------------------
  //透明用的双缓冲

  Buf := TBitmap.Create();
  Buf.Height := Height;
  Buf.Width := Width;

  //if m_Transparent then
    DoTrans(Buf.Canvas, self);

  //--------------------------------------------------

  //--------------------------------------------------
  //透明用的双缓冲
  BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);
  Buf.Free();

  //--------------------------------------------------
  }
  //DoTrans(Canvas, self);//好象直接这样也可以,不知道有什么区别

  if m_Transparent then
  begin
    //DoTrans(Canvas, self);//好象直接这样也可以,不知道有什么区别

    //--------------------------------------------------
    //透明用的双缓冲

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
    //透明用的双缓冲
    BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);
    Buf.Free();

    //--------------------------------------------------
  end
  else
  begin
    //如果不是从 Tpanel 继承的,则要自己画一下
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
  //让消息返回值为1，表示不交给系统默认消息函数DefWindowProc来处理//在这里好象没区别

end;



procedure TImagePanel.SetBorderWidth_v(const Value: Integer);
begin
  FBorderWidth_v := Value;
end;

end.


//���ؼ���TStringGrid�����ұȽϳ��õ�һ���ؼ��������� OnDrawCell �¼������Զ�����Եõ��ǳ�������Ư��Ч����
//
//��������ʵ�ֹ��Ķ���Ч���Ĳ�ͬ�汾��
//֮���Բ�ͬ�汾����������һ���ļ���Ϊ�˷���ȶԲ�ͬ�ķ�������Ϊ�Ƚϸ��ӣ��ñȶ�������ñȽ���������ؽ�Լ��ʱ��
//ϣ���Ժ���޸���Ҳ��Ҫ�����Ǻϲ�Ϊ��һ�ļ��������Ļ����ѶԱ�ά����
//
//Ŀǰֻ���� delphi7,�����汾��Ҫ�Լ������޸��¡�
//

//���ǵ�3���İ汾//��Ҫ�ǶԱ���ߵ������и���Ķ���Ȩ

unit on_draw_cell_v3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTHttpThread, ActiveX,ComObj, GIFImage, pngimage, Grids, ShellAPI, ShlObj,
  XMLIntf, uColorBorderEdit, StdCtrls, Wininet, WinSock,
  XMLDoc, 
  Dialogs, ExtCtrls;


//�Զ���ı��ؼ�����
//  color_line  := clWhite; //�߿���ɫ
//  color_brush := $00F2F4F5; //����ɫ
//�Զ���ı��ؼ�����
//  color_line  := clWhite; //�߿���ɫ
//  color_brush := $00F2F4F5; //����ɫ
procedure OnGridDrawCell_v3(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState;
  color_line:TColor  = clSilver;       //�߿���ɫ
  color_brush:TColor = clWindow;       //����ɫ
  color_title:TColor = $00F9F9F9 //clBtnFace       //��һ�еı���ɫ
  );


implementation

//�Զ���ı��ؼ�����
//  color_line  := clWhite; //�߿���ɫ
//  color_brush := $00F2F4F5; //����ɫ
procedure OnGridDrawCell_v3(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState;
  color_line:TColor  = clSilver;       //�߿���ɫ
  color_brush:TColor = clWindow;       //����ɫ
  color_title:TColor = $00F9F9F9 //clBtnFace       //��һ�еı���ɫ
  );
var
  grid:TStringGrid;
  uFormat, uFormat1,uFormat2:UINT;//���ֵĸ�ʽ

  bgRect: TRect; //ȫ������ rect
begin
  {
  TStringGrid�б��ָ��ߵ���ɫ
  (in Grids.pas)
        LineColor := clSilver;
        if ColorToRGB(Color) = clSilver then LineColor := clGray;
  ��Delphi��Դ�������ѱ��̶�
  ��Ҫ�޸ģ����Լ���һ��TStringGrid����
  ���ɲο�Grids.pas��
  }
  grid := sender as TStringGrid;


  grid.Canvas.Pen.Color := color_line; //�߿�ɫ

  //--------------------------------------------------
  //�Ȼ�����
  begin

    //ʵ��������Ҫ�ǹ������
    grid.Canvas.Brush.Color := color_line;

    bgRect := Rect;
    //bgRect.Bottom := Rect.Bottom + 1;
    //bgRect.Right := Rect.Right + 1;
    bgRect.Bottom := Rect.Bottom + grid.GridLineWidth;
    bgRect.Right := Rect.Right + grid.GridLineWidth;
    grid.Canvas.FillRect(bgRect);

    //�ٻ������ rect
    grid.Canvas.Brush.Color := color_brush; //grid.Color;
    grid.Canvas.FillRect(Rect);
  end;

  //--------------------------------------------------
  //�ٻ���

  if ARow = 0 then//��һ��
  begin
    //ʵ��������Ҫ�ǹ������
    grid.Canvas.Brush.Color := color_line;
    //grid.Canvas.Brush.Color := clRed;
    grid.Canvas.FillRect(bgRect);

    //�ٻ������ rect
    Rect.Top := Rect.Top + grid.GridLineWidth; //��һ��Ҫ����������
     
    grid.Canvas.Brush.Color := color_title; //grid.Color; //��һ�е���ɫ�ǲ�ͬ��
    //grid.Canvas.Brush.Color := clRed;
    grid.Canvas.FillRect(Rect);

    //if ACol = 0 then//��һ��,����߿����
  end;
  //else
  if ACol = 0 then//��һ��,����߿����
  begin
    //ʵ��������Ҫ�ǹ������
    //grid.Canvas.Brush.Color := color_title;
    grid.Canvas.Brush.Color := color_line;
    grid.Canvas.FillRect(bgRect);

    //�ٻ������ rect
    Rect.Left := Rect.Left + grid.GridLineWidth; //��һ��Ҫ����ߵ���

    grid.Canvas.Brush.Color := color_brush; //grid.Color;
    if ARow = 0 then grid.Canvas.Brush.Color := color_title; //��һ�е���ɫ�ǲ�ͬ��
    grid.Canvas.FillRect(Rect);
  end ;//Exit;
  //else

  //--------------------------------------------------
  //�о�������ǻ���ȥ�ȽϺÿ�//��Ȼ�����в����ĺÿ�,���߿��Ի����Զ���Ŀ�
  if gdFocused in State then
  begin
    grid.Canvas.DrawFocusRect(rect);
  end;
  //--------------------------------------------------

  grid.Canvas.Font.Color := grid.Font.Color;
  grid.Canvas.Font.Size := grid.Font.Size;
  grid.Canvas.Font.Name := grid.Font.Name;
  grid.Canvas.Font.Style := grid.Font.Style; //clq 2019 �������

  Rect.Left := Rect.Left + 1;//����̫��
  Rect.Right := Rect.Right - 1;//����̫��

  //--------------------------------------------------
  //���ֵĸ�ʽ
  uFormat1 := DT_SINGLELINE or //����
            DT_VCENTER or //����ˮƽ���У����Ե��У�
            DT_CENTER;
  uFormat2 := //DT_SINGLELINE or //����
            DT_VCENTER or //����ˮƽ���У����Ե��У�
            DT_CENTER
            or DT_EDITCONTROL or DT_WORDBREAK //DT_EDITCONTROL��DT_WORDBREAK���ʹ�ò��У����ֿ����Զ������ˡ�
            ;

  uFormat := uFormat1;
  if (ARow<>0)and(grid.Canvas.TextWidth(grid.Cells[ACol, ARow]) > Rect.Right - Rect.Left)
  then uFormat := uFormat2;

  grid.Canvas.Brush.Style := bsClear;
  //grid.Canvas.TextRect(Rect, 0, 0, grid.Cells[ACol, ARow]+'aaa');
  DrawText(grid.Canvas.Handle
            , PChar(grid.Cells[ACol, ARow])
            , -1
            , Rect
            ,
            uFormat
            );

end;


end.


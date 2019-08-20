
//���ؼ���TStringGrid�����ұȽϳ��õ�һ���ؼ��������� OnDrawCell �¼������Զ�����Եõ��ǳ�������Ư��Ч����
//
//��������ʵ�ֹ��Ķ���Ч���Ĳ�ͬ�汾��
//֮���Բ�ͬ�汾����������һ���ļ���Ϊ�˷���ȶԲ�ͬ�ķ�������Ϊ�Ƚϸ��ӣ��ñȶ�������ñȽ���������ؽ�Լ��ʱ��
//ϣ���Ժ���޸���Ҳ��Ҫ�����Ǻϲ�Ϊ��һ�ļ��������Ļ����ѶԱ�ά����
//
//Ŀǰֻ���� delphi7,�����汾��Ҫ�Լ������޸��¡�
//

//���ǵ�2���İ汾������һ����Ŀ�õ��ģ��������ڴ���ο�

unit on_draw_cell_v2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTHttpThread, ActiveX,ComObj, GIFImage, pngimage, Grids, ShellAPI, ShlObj,
  XMLIntf, uColorBorderEdit, StdCtrls, Wininet, WinSock,
  XMLDoc, 
  Dialogs, ExtCtrls;


//�Զ���ı��ؼ�����
procedure OnGridCzDrawCell_2(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);


implementation

//�Զ���ı��ؼ�����
procedure OnGridCzDrawCell_2(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  grid:TStringGrid;
  uFormat, uFormat1,uFormat2:UINT;//���ֵĸ�ʽ
  color_line:TColor; //�߿���ɫ
  color_brush:TColor; //����ɫ
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

  //color_line  := clRed; //�߿���ɫ
  color_line  := clWhite; //�߿���ɫ
  //color_brush := clWhite; //����ɫ
  color_brush := $00F2F4F5; //����ɫ

  grid.Canvas.Pen.Color := color_line; //�߿�ɫ

  //--------------------------------------------------
  //�Ȼ�����
  begin

    //ʵ��������Ҫ�ǹ������
    grid.Canvas.Brush.Color := color_line;

    bgRect := Rect;
    bgRect.Bottom := Rect.Bottom + 1;
    bgRect.Right := Rect.Right + 1;
    grid.Canvas.FillRect(bgRect);

    //�ٻ������ rect
    grid.Canvas.Brush.Color := color_brush; //grid.Color;
    grid.Canvas.FillRect(Rect);
  end;

  //--------------------------------------------------
  //��һ��ȫ�����⴦��
  if ARow=0 then
  begin

  end;

  //--------------------------------------------------
  //�ٻ���

  if ACol = 0 then//��һ��,����߿����
  begin
    grid.Canvas.Brush.Color := $00F9F9F9;//clGray;
    grid.Canvas.Font.Color := clRed;

    Rect.Bottom := Rect.Bottom + 1;//����Ҫȥ��Щ����
    Rect.Right := Rect.Right + 1;//����Ҫȥ��Щ����


    grid.Canvas.MoveTo(Rect.Left, Rect.Top);
    grid.Canvas.LineTo(Rect.Left, Rect.Bottom-1);
  end ;//Exit;
  //else


  //grid.Canvas.FrameRect(rect);

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


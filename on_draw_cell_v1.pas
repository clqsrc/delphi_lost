
//���ؼ���TStringGrid�����ұȽϳ��õ�һ���ؼ��������� OnDrawCell �¼������Զ�����Եõ��ǳ�������Ư��Ч����
//
//��������ʵ�ֹ��Ķ���Ч���Ĳ�ͬ�汾��
//֮���Բ�ͬ�汾����������һ���ļ���Ϊ�˷���ȶԲ�ͬ�ķ�������Ϊ�Ƚϸ��ӣ��ñȶ�������ñȽ���������ؽ�Լ��ʱ��
//ϣ���Ժ���޸���Ҳ��Ҫ�����Ǻϲ�Ϊ��һ�ļ��������Ļ����ѶԱ�ά����
//
//Ŀǰֻ���� delphi7,�����汾��Ҫ�Լ������޸��¡�
//

//���ǵ�һ���İ汾

unit on_draw_cell_v1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTHttpThread, ActiveX,ComObj, GIFImage, pngimage, Grids, ShellAPI, ShlObj,
  XMLIntf, uColorBorderEdit, StdCtrls, Wininet, WinSock,
  XMLDoc, 
  Dialogs, ExtCtrls;


//�Զ���ı��ؼ�����
procedure OnGridCzDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);


implementation

//�Զ���ı��ؼ�����
procedure OnGridCzDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  grid:TStringGrid;
  uFormat, uFormat1,uFormat2:UINT;//���ֵĸ�ʽ
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

  //--------------------------------------------------
  //�Ȼ�����
  begin
    grid.Canvas.Brush.Color := grid.Color;
    grid.Canvas.FillRect(Rect);
  end;

  //--------------------------------------------------
  //�ٻ��� 

  if ARow = 0 then//��һ��
  begin
    grid.Canvas.Brush.Color := $00F9F9F9;//clGray;
    //grid.Canvas.Font.Color := clRed;

    Rect.Bottom := Rect.Bottom + 1;//����Ҫȥ��Щ����
    Rect.Right := Rect.Right + 1;//����Ҫȥ��Щ����

    grid.Canvas.FillRect(Rect);
    //grid.Canvas.Brush.Color := clSilver;//clRed;
    //grid.Canvas.FrameRect(Rect);
    //grid.Canvas.Brush.Color := $00F9F9F9;//clGray;
    grid.Canvas.MoveTo(Rect.Left, Rect.Top);
    grid.Canvas.LineTo(Rect.Right-1, Rect.Top);
    grid.Canvas.LineTo(Rect.Right-1, Rect.Bottom-1);
    grid.Canvas.LineTo(Rect.Left-1, Rect.Bottom-1);

    //if ACol = 0 then//��һ��,����߿����
  end;
  //else
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

  //--------------------------------------------------
  //�о�������ǻ���ȥ�ȽϺÿ�//��Ȼ�����в����ĺÿ�,���߿��Ի����Զ���Ŀ�
  if gdFocused in State then
  begin
    grid.Canvas.DrawFocusRect(rect);
  end;
  //--------------------------------------------------

  grid.Canvas.Font.Color := grid.Font.Color;

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


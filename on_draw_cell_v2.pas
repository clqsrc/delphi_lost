
//表格控件（TStringGrid）是我比较常用的一个控件，对它的 OnDrawCell 事件进行自定义可以得到非常多样的漂亮效果。
//
//这里是我实现过的多种效果的不同版本。
//之所以不同版本都独立生成一个文件是为了方便比对不同的方法，因为比较复杂，用比对软件看得比较清楚，大大地节约了时间
//希望以后的修改者也不要将它们合并为单一文件，那样的话很难对比维护。
//
//目前只用于 delphi7,其他版本需要自己动手修改下。
//

//这是第2个的版本，这是一个项目用到的，仅仅用于代码参考

unit on_draw_cell_v2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTHttpThread, ActiveX,ComObj, GIFImage, pngimage, Grids, ShellAPI, ShlObj,
  XMLIntf, uColorBorderEdit, StdCtrls, Wininet, WinSock,
  XMLDoc, 
  Dialogs, ExtCtrls;


//自定义的表格控件绘制
procedure OnGridCzDrawCell_2(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);


implementation

//自定义的表格控件绘制
procedure OnGridCzDrawCell_2(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  grid:TStringGrid;
  uFormat, uFormat1,uFormat2:UINT;//画字的格式
  color_line:TColor; //边框颜色
  color_brush:TColor; //背景色
  bgRect: TRect; //全背景的 rect
begin
  {
  TStringGrid中表格分隔线的颜色
  (in Grids.pas)
        LineColor := clSilver;
        if ColorToRGB(Color) = clSilver then LineColor := clGray;
  在Delphi的源程序中已被固定
  若要修改，可自己做一个TStringGrid构件
  （可参考Grids.pas）
  }
  grid := sender as TStringGrid;

  //color_line  := clRed; //边框颜色
  color_line  := clWhite; //边框颜色
  //color_brush := clWhite; //背景色
  color_brush := $00F2F4F5; //背景色

  grid.Canvas.Pen.Color := color_line; //边框色

  //--------------------------------------------------
  //先画背景
  begin

    //实际上这里要盖过表格线
    grid.Canvas.Brush.Color := color_line;

    bgRect := Rect;
    bgRect.Bottom := Rect.Bottom + 1;
    bgRect.Right := Rect.Right + 1;
    grid.Canvas.FillRect(bgRect);

    //再画里面的 rect
    grid.Canvas.Brush.Color := color_brush; //grid.Color;
    grid.Canvas.FillRect(Rect);
  end;

  //--------------------------------------------------
  //第一行全部特殊处理
  if ARow=0 then
  begin

  end;

  //--------------------------------------------------
  //再画线

  if ACol = 0 then//第一列,画左边框就行
  begin
    grid.Canvas.Brush.Color := $00F9F9F9;//clGray;
    grid.Canvas.Font.Color := clRed;

    Rect.Bottom := Rect.Bottom + 1;//首行要去掉些东西
    Rect.Right := Rect.Right + 1;//首行要去掉些东西


    grid.Canvas.MoveTo(Rect.Left, Rect.Top);
    grid.Canvas.LineTo(Rect.Left, Rect.Bottom-1);
  end ;//Exit;
  //else


  //grid.Canvas.FrameRect(rect);

  //--------------------------------------------------

  grid.Canvas.Font.Color := grid.Font.Color;
  grid.Canvas.Font.Size := grid.Font.Size;
  grid.Canvas.Font.Name := grid.Font.Name;
  grid.Canvas.Font.Style := grid.Font.Style; //clq 2019 粗体等于

  Rect.Left := Rect.Left + 1;//不能太满
  Rect.Right := Rect.Right - 1;//不能太满

  //--------------------------------------------------
  //画字的格式
  uFormat1 := DT_SINGLELINE or //单行
            DT_VCENTER or //正文水平居中（仅对单行）
            DT_CENTER;
  uFormat2 := //DT_SINGLELINE or //单行
            DT_VCENTER or //正文水平居中（仅对单行）
            DT_CENTER
            or DT_EDITCONTROL or DT_WORDBREAK //DT_EDITCONTROL和DT_WORDBREAK组合使用才行，发现可以自动换行了。
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


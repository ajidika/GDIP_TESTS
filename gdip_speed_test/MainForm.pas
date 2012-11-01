unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls, GDIPOBJ,
  GDIPAPI;

type
  TfrmTest = class(TForm)
    Panel1: TPanel;
    edtFileName: TAdvFileNameEdit;
    btnImageStart: TButton;
    btnRectStart: TButton;
    pbTest: TPaintBox;
    btnCchdImgStart: TButton;
    procedure btnImageStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnRectStartClick(Sender: TObject);
    procedure btnCchdImgStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTest: TfrmTest;

implementation

{$R *.dfm}

procedure TfrmTest.FormCreate(Sender: TObject);
begin
//  imgTest.Picture.Bitmap := TBitmap.Create;
  //FormResize(Self);
end;

procedure TfrmTest.FormResize(Sender: TObject);
begin
//  with imgTest.Picture.Bitmap do
//  begin
//    Width := imgTest.Width;
//    Height := imgTest.Height;
//  end;
end;

procedure TfrmTest.btnImageStartClick(Sender: TObject);
var
  img: TGPImage;
  grph: TGPGraphics;
  i: Integer;
  tick: Cardinal;
  speed: Single;
  pnt: TGPPointF;
const
  pictcnt = 1000;
begin
  img := nil;
  grph := nil;
  if FileExists(edtFileName.FileName) then
  begin
    try
      img := TGPImage.Create(edtFileName.FileName);
      grph := TGPGraphics.Create(pbTest.Canvas.Handle);
      tick := GetTickCount;
      for i := 0 to pictcnt-1 do
      begin
        pnt.X := random(pbTest.Width) - (img.GetWidth div 2);
        pnt.Y := random(pbTest.Height) - (img.GetHeight div 2);
        grph.DrawImage(img, pnt);
      end;
      tick := GetTickCount - tick;
      if tick > 0 then
        speed := pictcnt /(tick / 1000)
      else
        speed := 0;
      ShowMessage(Format('%d pictures drawed in %d ms - %.2f pps', [pictcnt, tick, speed]));
    finally
      img.Free;
      grph.Free;
    end;
  end;
end;

procedure TfrmTest.btnRectStartClick(Sender: TObject);
var
  grph: TGPGraphics;
  rect: TGPRectF;
  pen: TGPPen;
  brush: TGPSolidBrush;
  i: Integer;
  tick: Cardinal;
  speed: Single;
  pnt: TGPPointF;
  status: TStatus;
const
  pictcnt = 1000;
begin
  grph := nil;
  brush := TGPSolidBrush.Create($AF007F00);
  pen := TGPPen.Create($FF000000);
  pen.SetWidth(3);
  rect.Width := 988;//187;
  rect.Height := 460;//142;

  try
    grph := TGPGraphics.Create(pbTest.Canvas.Handle);
    tick := GetTickCount;
    for i := 0 to pictcnt-1 do
    begin
      rect.X := random(pbTest.Width) - (rect.Width / 2);
      rect.Y := random(pbTest.Height) - (rect.Height / 2);
      status := grph.FillRectangle(brush, rect);
      grph.DrawRectangle(pen, rect);
    end;
    tick := GetTickCount - tick;
    speed := pictcnt /(tick / 1000);
    ShowMessage(Format('%d pictures drawed in %d ms - %.2f pps', [pictcnt, tick, speed]));
  finally
    grph.Free;
    brush.Free;
    pen.Free;
  end;
end;

procedure TfrmTest.btnCchdImgStartClick(Sender: TObject);
var
  img: TGPBitmap;
  chd: TGPCachedBitmap;
  grph: TGPGraphics;
  i: Integer;
  tick: Cardinal;
  speed: Single;
  pnt: TPoint;
const
  pictcnt = 1000;
begin
  img := nil;
  chd := nil;
  grph := nil;
  if FileExists(edtFileName.FileName) then
  begin
    try
      img := TGPBitmap.Create(edtFileName.FileName);
      grph := TGPGraphics.Create(pbTest.Canvas.Handle);
      chd := TGPCachedBitmap.Create(img, grph);
      tick := GetTickCount;
      for i := 0 to pictcnt-1 do
      begin
        pnt.X := random(pbTest.Width) - (img.GetWidth div 2);
        pnt.Y := random(pbTest.Height) - (img.GetHeight div 2);
        //grph.DrawImage(img, pnt);
        grph.DrawCachedBitmap(chd, pnt.X, pnt.Y);
      end;
      tick := GetTickCount - tick;
      if tick > 0 then
        speed := pictcnt /(tick / 1000)
      else
        speed := 0;
      ShowMessage(Format('%d pictures drawed in %d ms - %.2f pps', [pictcnt, tick, speed]));
    finally
      img.Free;
      chd.Free;
      grph.Free;
    end;
  end;
end;

end.

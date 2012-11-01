unit mainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, DateUtils,

  ClockComponent, ExtCtrls, Grids, ComCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    lvClock: TListView;
    dtMain: TDateTimePicker;
    edtValue: TEdit;
    udValue: TUpDown;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    trbLuminosity: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure trbLuminosityChange(Sender: TObject);
    procedure lvClockSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    clck: TExClock;
    lum: TLuminosity;
    procedure RefillListClock();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  clck.Sectors.AddSector(dtMain.Time, udValue.Position);
  RefillListClock();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Assigned(lvClock.Selected) then
  begin
    clck.Sectors.DeleteSector(lvClock.Selected.Index);
    RefillListClock();
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  clck := TExClock.Create(Self);
  clck.Parent := self;
  clck.Left := 20;
  clck.Top := 20;
  clck.Width := 296;
  clck.Height := 296;
  clck.Sectors.AddSector(EncodeTime(0, 0, 0, 0), 0);
  clck.Sectors.AddSector(EncodeTime(2, 0, 0, 0), 10);
  clck.Sectors.AddSector(EncodeTime(4, 0, 0, 0), 20);
  clck.Sectors.AddSector(EncodeTime(6, 0, 0, 0), 30);
  clck.Sectors.AddSector(EncodeTime(8, 0, 0, 0), 40);
  clck.Sectors.AddSector(EncodeTime(10, 0, 0, 0), 50);
  clck.Sectors.AddSector(EncodeTime(12, 0, 0, 0), 60);
  clck.Sectors.AddSector(EncodeTime(14, 0, 0, 0), 70);
  clck.Sectors.AddSector(EncodeTime(16, 0, 0, 0), 80);
  clck.Sectors.AddSector(EncodeTime(18, 0, 0, 0), 90);
  clck.Sectors.AddSector(EncodeTime(20, 0, 0, 0), 100);
  clck.Sectors.AddSector(EncodeTime(22, 0, 0, 0), 0);
  RefillListClock();

  lum := TLuminosity.Create(Self);
  lum.Parent := Self;
  lum.Left := 560;
  lum.Top := 8;
  lum.Width := 222;
  lum.Height := 325;
  trbLuminosity.Position := 0;
  trbLuminosityChange(trbLuminosity);

  Image1.Picture.LoadFromFile('back.jpg');
end;

procedure TForm1.RefillListClock;
var
  i: Integer;
  li: TListItem;
begin
  lvClock.Clear;
  for i := 0 to clck.Sectors.Count - 1 do
  begin
    li := lvClock.Items.Add;
    li.Caption := TimeToStr(clck.Sectors.StartTime[i]);
    li.SubItems.Add(FloatToStr(clck.Sectors.Value[i]));
  end;
end;

procedure TForm1.trbLuminosityChange(Sender: TObject);
begin
  with Sender as TTrackBar do
    lum.Value := Max - Position;
end;

procedure TForm1.lvClockSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  tm: TDateTime;
  val: Integer;
begin
  if Assigned(item) and Selected then
    if TryStrToTime(item.Caption, tm) then
    begin
      dtMain.Time := TimeOf(tm);
      if TryStrToInt(Item.SubItems[0], val) then
        udValue.Position := val
      else
        udValue.Position := 0;
    end;
end;

end.

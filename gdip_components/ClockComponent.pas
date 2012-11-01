unit ClockComponent;

{$R GDIPCmp}

interface

uses
  Windows, Classes, SysUtils, Controls, Messages, Graphics, ExtCtrls,

  GDIPAPI, GDIPOBJ, GDIPComponents;

type
  TSector = record
    Time: TTime;
    Value: Single;
  end;

  TSectorList = class
  private
    function GetCount: Integer;
    function GetEndTime(index: Integer): TTime;
    function GetStartTime(index: Integer): TTime;
    function GetValue(index: Integer): Single;
  protected
    FList: array of TSector;
    FParent: TWinControl;
    function  InsertSector(index: Integer; Time: TTime; Value: Single): Integer;
    function  Normalize(Time: TTime): TTime;
  public
    constructor Create(Parent: TWinControl);
    destructor  Destroy(); override;
    property  Count: Integer read GetCount;
    function  AddSector(Time: TTime; Value: Single): Integer;
    procedure DeleteSector(index: integer);
    function  IndexOf(Time: TTime): Integer;
    function  InSectorOf(Time: TTime): Integer;
    property  StartTime[index: Integer]: TTime read GetStartTime;
    property  EndTime[index: Integer]: TTime read GetEndTime;
    property  Value[index: Integer]: Single read GetValue;
  end;

  TExClock = class(TCustomTransparentControl)
  protected
    FGraphics: TGPGraphics;
    FBitmap: TGPImageEx;
    FSectors: TSectorList;
    FAutoUpdateTime: Boolean;
    FUpdateTimer: TTimer;
    procedure Paint(); override;
    function  TimeToStartAngle(Time: TTime): Single;
    function  TimesToAngleSweep(Time1, Time2: TTime): Single;
    function  ValueToColor(Value, min, max: Single): TGPColor;
    procedure FUpdateTimerTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy(); override;
    property  Sectors: TSectorList read FSectors;
    property  AutoUpdateTime: Boolean read FAutoUpdateTime write FAutoUpdateTime;
  end;

  TLuminosity = class(TCustomControl)
  protected
    FGraphics: TGPGraphics;
    FSkyBitmap: TGPImageEx;
    FTreeBitmap: TGPImageEx;
    FValue: Single;
    FMinValue: Single;
    FMaxValue: Single;
    procedure SetMaxValue(const Value: Single);
    procedure SetMinValue(const Value: Single);
    procedure SetValue(const Value: Single);
    procedure Paint(); override;
    function  ValueToColor(): TGPColor;
    function  ValueToSunTop(): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy(); override;
    property  Value: Single read FValue write SetValue;
    property  MinValue: Single read FMinValue write SetMinValue;
    property  MaxValue: Single read FMaxValue write SetMaxValue;

  end;

implementation

{ TSectorList }

function TSectorList.AddSector(Time: TTime; Value: Single): Integer;
begin
  Result := InSectorOf(Time);
  if Result >= 0 then
    Result := InsertSector(Result+1, Time, Value)
  else
    Result := InsertSector(Length(FList), Time, Value);
end;

constructor TSectorList.Create;
begin
  FParent := Parent;
end;

procedure TSectorList.DeleteSector(index: integer);
var
  n: Integer;
begin
  if (index >= 0) and (index < Length(Flist)) then
  begin
    n := Length(FList)-1;
    if n - index > 0 then
      Move(FList[index+1], FList[index], SizeOf(Flist[0])*(n-index));
    SetLength(FList, n);
    FParent.Invalidate();
  end;
end;

destructor TSectorList.Destroy;
begin
  FParent := nil;
  SetLength(FList, 0);
  inherited;
end;

function TSectorList.GetCount: Integer;
begin
  Result := Length(FList);
end;

function TSectorList.GetEndTime(index: Integer): TTime;
begin
  if index < Length(FList)-1 then // не последний элемент
    Result := FList[index+1].Time
  else if index = Length(FList)-1 then
    Result := FList[0].Time
  else
    Result := 0;
end;

function TSectorList.GetStartTime(index: Integer): TTime;
begin
  Result := FList[index].Time;
end;

function TSectorList.GetValue(index: Integer): Single;
begin
  Result := FList[index].Value;
end;

function TSectorList.IndexOf(Time: TTime): Integer;
var
  i: Integer;
begin
  Time := Normalize(Time);
  Result := -1;
  for i := Length(FList)-1 downto 0 do
    if FList[i].Time = frac(Time) then
    begin
      Result := i;
      Break;
    end;
end;

function TSectorList.InSectorOf(Time: TTime): Integer;
var
  i: Integer;
begin
  Time := Normalize(Time);
  Result := -1;
  for i := Length(FList)-1 downto 0 do
    if FList[i].Time < frac(Time) then
    begin
      Result := i;
      Break;
    end;
end;

function TSectorList.InsertSector(index: Integer; Time: TTime; Value: Single): Integer;
var
  n: Integer;
begin
  Time := Normalize(Time);
  Result := IndexOf(Time);
  if Result >= 0 then  // если такое время уже есть
  begin
    FList[Result].Value := Value;
    if Assigned(FParent) then
      FParent.Invalidate();
  end
  else if index < 0 then
    Result := InsertSector(0, Time, Value)
  else if index > Length(FList) then
    Result := InsertSector(Length(FList), Time, Value)
  else
  begin
    n := Length(FList);
    SetLength(FList, n+1);
    if (n > 0) and (index < n-1) then
      Move(FList[index], FList[index+1], SizeOf(FList[0])*(n-index));
    FList[index].Time := frac(Time);
    FList[index].Value := Value;
    Result := index;
    FParent.Invalidate();
  end;

end;

function TSectorList.Normalize(Time: TTime): TTime;
var
  hr, min, sec, msec: Word;
begin
  DecodeTime(Time, hr, min, sec, msec);
  Result := EncodeTime(hr, min, sec, 0);
end;

{ TExClock }

constructor TExClock.Create(AOwner: TComponent);
begin
  inherited;
  FSectors := TSectorList.Create(Self);
  FBitmap := FBitmap.FromResource('clock_png', RT_RCDATA);
  FUpdateTimer := TTimer.Create(self);
  FUpdateTimer.OnTimer := FUpdateTimerTimer;
  FUpdateTimer.Interval := 10000;
  FUpdateTimer.Enabled := True;
  FAutoUpdateTime := True;
end;

destructor TExClock.Destroy;
begin
  FSectors.Free;
  inherited;
end;

procedure TExClock.FUpdateTimerTimer(Sender: TObject);
begin
  if FAutoUpdateTime then
    invalidate;
end;

procedure TExClock.Paint;
var
  pen: TGPPen;
  rct: TGPRect;
  pnt: TGPPointF;
  brsh: TGPSolidBrush;
  i: Integer;
  stang, angsweep: Single;
  mtrx: TGPMatrix;
  hr, min, sec, msec: Word;
  path: TGPGraphicsPath;
begin
  FGraphics := TGPGraphics.Create(Canvas.Handle);
  FGraphics.SetSmoothingMode(SmoothingModeAntiAlias);

  pen := TGPPen.Create($FF003FFF);
  brsh := TGPSolidBrush.Create($FF000000);

  // сектора
  rct.X := 20;
  rct.Y := 20;
  rct.Width := 254;
  rct.Height := 254;

  for i := 0 to FSectors.Count - 1 do
  begin
    stang := TimeToStartAngle(FSectors.StartTime[i]);
    angsweep := TimesToAngleSweep(FSectors.StartTime[i], FSectors.EndTime[i]);
    brsh.SetColor(ValueToColor(FSectors.Value[i], 0, 100));
    FGraphics.FillPie(brsh, rct, stang, angsweep);
  end;

  // стрелки
  DecodeTime(Now(), hr, min, sec, msec);
  pnt.X := 147.5;
  pnt.Y := 147.5;
  brsh.SetColor($FF000000);
  mtrx := TGPMatrix.Create();
  path := TGPGraphicsPath.Create();
  path.AddLine(143.5, 168, 151.5, 168);
  path.AddLine(151.5, 168, 149.5, 75);
  path.AddLine(149.5, 75, 145.5, 75);
  path.AddLine(145.5, 75, 143.5, 168);
  mtrx.RotateAt(360/24*(hr+min/60), pnt);
  FGraphics.SetTransform(mtrx);
  FGraphics.FillPath(brsh, path);
  FGraphics.ResetTransform();

  path.Reset;
  mtrx.Reset;
  path.AddLine(145.5, 168, 149.5, 168);
  path.AddLine(149.5, 168, 148.5, 55);
  path.AddLine(148.5, 55, 146.6, 55);
  path.AddLine(146.5, 55, 145.5, 168);
  mtrx.RotateAt(360/60*(min), pnt);
  FGraphics.SetTransform(mtrx);
  FGraphics.FillPath(brsh, path);
  FGraphics.ResetTransform;
  path.Free;
  mtrx.Free;

  brsh.Free;
  pen.Free;

  // фон
  rct.X := 0;
  rct.Y := 0;
  rct.Width := Width-1;
  rct.Height := Height-1;

  FGraphics.DrawImage(FBitmap, rct);

  FGraphics.Free;
end;

function TExClock.TimesToAngleSweep(Time1, Time2: TTime): Single;
var
  val: Single;
begin
  val := frac(Time2-Time1);
  Result := 360 * val;
  if Result < 0 then
    Result := Result + 360;
end;

function TExClock.TimeToStartAngle(Time: TTime): Single;
var
  val: Single;
begin
  val := frac(Time);
  Result := 360 * val - 90;
  if Result < 0 then
    Result := Result + 360;
end;

function TExClock.ValueToColor(Value, min, max: Single): TGPColor;

  function ValToByte(value, min, max: Single): Byte;
  begin
    Result := round(255/(max-min) * (value-min));
  end;

var
  a: byte;
  mid: Single;
begin
  if Value > max then
    Value := max
  else if Value < min then
    Value := min;

  mid := (min+max)/2;

  if Value < mid then
  begin
    a := round(255/(mid-min) * (Value - min));
    Result := MakeColor($ff, a, $ff, 0);
  end
  else
  begin
    a := round(255/(max-mid) * (Value - mid));
    Result := MakeColor($ff, $ff, $ff-a, 0);
  end;
end;

{ TLuminosity }

constructor TLuminosity.Create(AOwner: TComponent);
begin
  inherited;
  FSkyBitmap := FSkyBitmap.FromResource('sky_png', RT_RCDATA);
  FTreeBitmap := FTreeBitmap.FromResource('tree_png', RT_RCDATA);
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 0;
  FDoubleBuffered := True;
end;

destructor TLuminosity.Destroy;
begin
  FSkyBitmap.Free;
  FTreeBitmap.Free;
  inherited;
end;

procedure TLuminosity.Paint;
var
  brsh: TGPSolidBrush;
  rct: TGPRect;
begin
  FGraphics := TGPGraphics.Create(Canvas.Handle);
  try
    FGraphics.SetSmoothingMode(SmoothingModeAntiAlias);
    brsh := TGPSolidBrush.Create(ValueToColor());

    rct.X := 0;
    rct.Y := 0;
    rct.Width := Width-1;
    rct.Height := Height-1;

    FGraphics.DrawImage(FSkyBitmap, rct);

    FGraphics.FillRectangle(brsh, rct);


    brsh.SetColor($FFFFFF00);

    rct.X := 140;
    rct.Y := ValueToSunTop();
    rct.Width := 20;
    rct.Height := 20;

    FGraphics.FillEllipse(brsh, rct);

    rct.X := 0;
    rct.Y := 190;
    rct.Width := Width-1;
    rct.Height := 325-190-1;

    FGraphics.DrawImage(FTreeBitmap, rct);

    brsh.Free;
  finally
    FGraphics.Free;
  end;

end;

procedure TLuminosity.SetMaxValue(const Value: Single);
begin
  if Value >= FMinValue then
    FMaxValue := Value
  else
    FMaxValue := FMinValue;

  SetValue(FValue);
end;

procedure TLuminosity.SetMinValue(const Value: Single);
begin
  if Value <= FMaxValue then
    FMinValue := Value
  else
    FMinValue := FMaxValue;

  SetValue(FValue);
end;

procedure TLuminosity.SetValue(const Value: Single);
var
  FOld: Single;
begin
  FOld := FValue;

  if Value < FMinValue then
    FValue := FMinValue
  else if Value > FMaxValue then
    FValue := FMaxValue
  else
    FValue := Value;

  if FOld <> FValue then
    Invalidate();
end;

function TLuminosity.ValueToColor(): TGPColor;
var
  a: byte;
begin
  a := round(255*0.7 * (FMaxValue - FValue) / (FMaxValue - FMinValue));
  Result := MakeColor(a, 0, 0, 0);
end;

function TLuminosity.ValueToSunTop: Integer;
const
  sunMax = 20;
  sunMin = 293;
begin
  if FMaxValue = FMinValue then
    Result := sunMax
  else
    Result := SunMin - round((sunMin - sunMax)/(FMaxValue - FMinValue) * FValue);
end;

end.


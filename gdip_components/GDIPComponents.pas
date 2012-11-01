unit GDIPComponents;

interface

uses
  Windows, Classes, SysUtils, Graphics, Controls, Messages, ActiveX,

  GDIPOBJ, GDIPAPI;

type
  TCustomTransparentControl = class(TCustomControl)
  private
    FInterceptMouse: Boolean;
  protected
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure InvalidateControlsUnderneath;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Invalidate; override;
    property InterceptMouse: Boolean read FInterceptMouse write FInterceptMouse default False;
  end;

  TGPImageEx = class(TGPImage)
  public
    constructor Create(filename: WideString; useEmbeddedColorManagement: BOOL = FALSE); overload;
    constructor Create(stream: IStream; useEmbeddedColorManagement: BOOL  = FALSE); reintroduce; overload;
    function FromStream(stream: TStream; useEmbeddedColorManagement: BOOL = FALSE): TGPImageEx; overload;
    function FromResource(Instance: THandle; ResName: String; ResType: PChar;
        useEmbeddedColorManagement: BOOL = FALSE): TGPImageEx; overload;
    function FromResource(ResName: String; ResType: PChar;
        useEmbeddedColorManagement: BOOL = FALSE): TGPImageEx; overload;
    function FromResource(Instance: THandle; ResID: Integer; ResType: PChar;
        useEmbeddedColorManagement: BOOL = FALSE): TGPImageEx; overload;
    function FromResource(ResID: Integer; ResType: PChar;
        useEmbeddedColorManagement: BOOL = FALSE): TGPImageEx; overload;
  end;

implementation

{ TCustomTransparentControl }

constructor TCustomTransparentControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  Brush.Style := bsClear;
end;

procedure TCustomTransparentControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
end;

procedure TCustomTransparentControl.Invalidate;
begin
  InvalidateControlsUnderneath;
  inherited Invalidate;
end;

procedure TCustomTransparentControl.InvalidateControlsUnderneath;
var
  I: Integer;
  Invalidating: Boolean;
  Control: TControl;

  procedure DoInvalidate(AControl: TControl);
  var
    I: Integer;
    Control: TControl;
  begin
    if AControl is TWinControl then
    begin
      if TWinControl(AControl).HandleAllocated then
        with TWinControl(AControl) do
        begin
          RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME);
          InvalidateRect(Handle, nil, True);
        end;
      if (csAcceptsControls in AControl.ControlStyle) then
        for I := 0 to TWinControl(AControl).ControlCount - 1 do
        begin
          Control := TWinControl(AControl).Controls[I];
          DoInvalidate(Control);
        end;
    end else
      AControl.Invalidate;
  end;

begin
  Invalidating := False;
  if HandleAllocated then
  begin
    for I := Parent.ControlCount - 1 downto 0 do
    begin
      Control := Parent.Controls[I];
      if Invalidating then
        DoInvalidate(Control)
      else if Control = Self then
        Invalidating := True;
    end;
    InvalidateRect(Parent.Handle, nil, True);
  end;
end;

procedure TCustomTransparentControl.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if not FInterceptMouse then
    Message.Result := HTTRANSPARENT;
end;

{ TGPImageEx }

function TGPImageEx.FromResource(ResName: String; ResType: PChar;
  useEmbeddedColorManagement: BOOL): TGPImageEx;
begin
  Result := FromResource(HInstance, ResName, ResType, useEmbeddedColorManagement);
end;

function TGPImageEx.FromResource(Instance: THandle; ResName: String;
  ResType: PChar; useEmbeddedColorManagement: BOOL): TGPImageEx;
var
  rc: TResourceStream;
begin
  rc := TResourceStream.Create(Instance, ResName, ResType);
  Result := FromStream(rc, useEmbeddedColorManagement);
end;

constructor TGPImageEx.Create(filename: WideString;
  useEmbeddedColorManagement: BOOL);
begin
  inherited;
end;

constructor TGPImageEx.Create(stream: IStream;
  useEmbeddedColorManagement: BOOL);
begin
  inherited;
end;

function TGPImageEx.FromResource(ResID: Integer; ResType: PChar;
  useEmbeddedColorManagement: BOOL): TGPImageEx;
begin
  Result := FromResource(HInstance, ResID, ResType, useEmbeddedColorManagement);
end;

function TGPImageEx.FromResource(Instance: THandle; ResID: Integer;
  ResType: PChar; useEmbeddedColorManagement: BOOL): TGPImageEx;
var
  rc: TResourceStream;
begin
  rc := TResourceStream.CreateFromID(Instance, ResID, ResType);
  Result := FromStream(rc, useEmbeddedColorManagement);
end;

function TGPImageEx.FromStream(stream: TStream;
  useEmbeddedColorManagement: BOOL): TGPImageEx;
var
  adapt: IStream;
begin
  adapt := TStreamAdapter.Create(Stream, soOwned);
  Result := TGPImageEx.Create(adapt, useEmbeddedColorManagement) as TGPImageEx;
end;

end.

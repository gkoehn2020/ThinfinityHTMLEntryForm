unit untSysWebComponentEntryForm;

interface

uses
  Vcl.Controls
, System.Classes
, VirtualUI_SDK
  ;

type
  TWebEntryForm = class(TObject)
  private
    FRemoteObj: TJSObject;
    FXtagDir: string;
    FOnFormCloseClickedEvent: TNotifyEvent;
    function GetXTagDir: string;
    function GetHtmlDir: string;
  public
    constructor Create(aControl: TWinControl);
    destructor Destroy; override;
    procedure CreateWebComponent(aControl: TWinControl);
    property  XTagDir: string read FXtagDir write FXTagDir;
    property OnFormCloseClickedEvent: TNotifyEvent read FOnFormCloseClickedEvent write FOnFormCloseClickedEvent;
    procedure ShowThisModal;
  end;

implementation

uses
  System.SysUtils
, System.IOUtils
, Vcl.Dialogs
  ;

{ TWebEntryForm }

constructor TWebEntryForm.Create(aControl: TWinControl);
var
  lXtagDir: string;
  lHtmlDir: string;
begin
  lXtagDir := GetXTagDir;
  if lXtagDir <> '' then
    VirtualUI.HTMLDoc.CreateSessionURL('x-tag',lXtagDir);

  lHtmlDir := GetHtmlDir;
  if lHtmlDir <> '' then
    VirtualUI.HTMLDoc.CreateSessionURL('HtmlToAdd', lHtmlDir);
end;

procedure TWebEntryForm.CreateWebComponent(aControl: TWinControl);
begin
  VirtualUI.HTMLDoc.LoadScript('/x-tag/x-tag-core.min.js','');
  VirtualUI.HTMLDoc.ImportHTML('/HtmlToAdd/HTMLEntryForm.html','');

  FRemoteObj := TJSObject.Create(AControl.Name);
  FRemoteObj.Events.Add('ShowThisModal');
  FRemoteObj.Methods.Add('orCancel') // Returns a IJSMethod
    .OnCall(TJSCallback.Create( // Adds the callback
      procedure(const Parent: IJSObject; const Method: IJSMethod)
      begin
        if assigned(OnFormCloseClickedEvent) then
          OnFormCloseClickedEvent(nil);
       end));

  FRemoteObj.ApplyModel;

  VirtualUI.HTMLDoc.CreateComponent(AControl.Name, 'x-entryform1', AControl.Handle);
end;

destructor TWebEntryForm.Destroy;
begin
  FRemoteObj := nil;
  inherited;
end;

function TWebEntryForm.GetHtmlDir: string;
var
  lBaseDir : string;
  lHtmlDirTest: string;
begin
  result := '';
  lBaseDir := ExtractFilePath(ParamStr(0));
  while (lBaseDir <> '') and (length(lBaseDir) > 2) do
    begin
      lHtmlDirTest := lBaseDir + 'html\';
      if DirectoryExists(lHtmlDirTest) then
        begin
          result := lHtmlDirTest;
          break;
        end;
      {$WARN SYMBOL_PLATFORM OFF}
      lBaseDir := ExtractFilePath(ExcludeTrailingBackSlash(lBaseDir));
      {$WARN SYMBOL_PLATFORM ON}
    end;
end;

function TWebEntryForm.GetXTagDir: string;
var
  lBaseDir : string;
  lXtagDirTest: string;
begin
  result := '';
  lBaseDir := ExtractFilePath(ParamStr(0));
  while (lBaseDir <> '') and (length(lBaseDir) > 2) do
    begin
      lXtagDirTest := lBaseDir + 'x-tag\';
      if DirectoryExists(lXtagDirTest) then
        begin
          result := lXtagDirTest;
          break;
        end;
      {$WARN SYMBOL_PLATFORM OFF}
      lBaseDir := ExtractFilePath(ExcludeTrailingBackSlash(lBaseDir));
      {$WARN SYMBOL_PLATFORM ON}
    end;
end;

procedure TWebEntryForm.ShowThisModal;
begin
  FRemoteObj.Events['ShowThisModal'].Fire;
end;

end.

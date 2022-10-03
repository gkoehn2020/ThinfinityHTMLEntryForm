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
    function GetXTagDir: string;
    function GetHtmlDir: string;
  public
    constructor Create(aControl: TWinControl);
    destructor Destroy; override;
    procedure CreateWebComponent(aControl: TWinControl);
    property  XTagDir: string read FXtagDir write FXTagDir;
    procedure Start;
    procedure Stop;
    procedure PushMsg(aMsg: string);
  end;

implementation

uses
  System.SysUtils
, System.IOUtils
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
  FRemoteObj.Events.Add('start');
  FRemoteObj.Events.Add('stop');
  FRemoteObj.Events.Add('msgupdate').AddArgument('newmsg',JSDT_STRING);
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

procedure TWebEntryForm.PushMsg(aMsg: string);
begin
  FRemoteObj.Events['msgupdate'].ArgumentAsString('newmsg',aMsg).Fire;
end;

procedure TWebEntryForm.Start;
begin
  FRemoteObj.Events['start'].Fire;
end;

procedure TWebEntryForm.Stop;
begin
  FRemoteObj.Events['stop'].Fire;
end;

end.

unit frmUISecondOne;

interface

uses
  untSysWebComponentEntryForm,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TSecondForm = class(TForm)
    pnlOneHost: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FWebComponent: TWebEntryForm;
  public
    { Public declarations }
    procedure ShowWebForm;
    procedure UpdateMsg(aMsg: string);
    procedure StopProgress;
    procedure OnCloseAction(Sender: TObject);
  end;

var
  SecondForm: TSecondForm;

implementation

{$R *.dfm}

procedure TSecondForm.FormCreate(Sender: TObject);
begin
  self.TransparentColor := True;
  self.TransparentColorValue := self.Color;
  FWebComponent := TWebEntryForm.Create(pnlOneHost);
  FWebComponent.CreateWebComponent(pnlOneHost);
  FWebComponent.OnFormCloseClickedEvent := OnCloseAction;
end;

procedure TSecondForm.OnCloseAction(Sender: TObject);
begin
  self.close;
end;

procedure TSecondForm.ShowWebForm;
begin
  Self.BringToFront;
  Application.ProcessMessages;
  FWebComponent.Start;
end;

procedure TSecondForm.StopProgress;
begin
  FWebComponent.Stop;
end;

procedure TSecondForm.UpdateMsg(aMsg: string);
begin
  FWebComponent.PushMsg(aMsg);
end;

end.

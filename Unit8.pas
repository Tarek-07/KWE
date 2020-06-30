unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm_Shutdown = class(TForm)
    Label_Intro: TLabel;
    Button_SaveKCM: TButton;
    Button_SaveKCMAs: TButton;
    Button_SaveOPL: TButton;
    Button_SaveOPLAs: TButton;
    Button_SaveKSM: TButton;
    Button_SaveKSMAs: TButton;
    Button_SaveAll: TButton;
    Button_AbortShutdown: TButton;
    Button_Proceed: TButton;
    Label_OPL: TLabel;
    Label_KCM: TLabel;
    Label_KSM: TLabel;
    procedure Button_AbortShutdownClick(Sender: TObject);
    procedure Button_SaveAllClick(Sender: TObject);
    procedure Button_ProceedClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_SaveKCMClick(Sender: TObject);
    procedure Button_SaveOPLClick(Sender: TObject);
    procedure Button_SaveKSMClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_SaveKCMAsClick(Sender: TObject);
    procedure Button_SaveOPLAsClick(Sender: TObject);
    procedure Button_SaveKSMAsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Shutdown: TForm_Shutdown;

implementation

uses Unit1, Unit7;

{$R *.dfm}

procedure TForm_Shutdown.Button_AbortShutdownClick(Sender: TObject);
begin
  //Form_Main.BringToFront;
  Self.Hide;
end;

procedure TForm_Shutdown.Button_SaveAllClick(Sender: TObject);
var
  x1:Integer;
begin
  Form_Main.Timer_AutoSave.Enabled:=False;
  If Form_Main.KCM<>nil then
  begin
    Form_Main.KCM.SaveToFile(Form_Main.KCM.FileLocation);
    Form_main.KCM.Destroy;
  end;
  If Form_Main.OPL<>nil then
  begin
    try
      Form_Main.OPL.SaveToFile(Form_Main.OPL.FileLocation);
      Form_main.OPL.Destroy;
      Form_Main.GLDummyCube_OPLObjects.DeleteChildren;
    except
    end;
  end;
  If Form_Main.KSM<>nil then
  begin
    Form_Main.KSM.SaveToFile(Form_Main.KSM.FileLocation);
    Form_main.KSM.Destroy;
  end;
  try
    Form_Login.Close;
  except
    Application.Terminate;
  end;
end;

procedure TForm_Shutdown.Button_ProceedClick(Sender: TObject);
var
  x1:Integer;
begin
  Form_Main.Timer_AutoSave.Enabled:=False;
  If Form_Main.KCM<>nil then
  begin
    Form_main.KCM.Destroy;
  end;
  If Form_Main.OPL<>nil then
  begin
    try
      Form_main.OPL.Destroy;
      Form_Main.GLDummyCube_OPLObjects.DeleteChildren;
    except
    end;
  end;
  If Form_Main.KSM<>nil then
  begin
    Form_main.KSM.Destroy;
  end;
  try
    Form_Login.Close;
  except
    Application.Terminate;
  end;
end;

procedure TForm_Shutdown.FormShow(Sender: TObject);
begin
  If Form_Main.KCM<>nil then
  begin
    Button_SaveKCM.Enabled:=True;
    Button_SaveKCMAs.Enabled:=True;
    Label_KCM.Visible:=True;
    If Form_main.KCM.Saved=True then
    begin
      Label_KCM.Caption:='Saved';
      Label_KCM.Font.Color:=clGreen
    end
    else
    begin
      Label_KCM.Caption:='Unsaved';
      Label_KCM.Font.Color:=clRed;
    end;
  end
  else
  begin
    Button_SaveKCM.Enabled:=False;
    Button_SaveKCMAs.Enabled:=False;
    Label_KCM.Visible:=False;
  end;
  If Form_Main.OPL<>nil then
  begin
    Button_SaveOPL.Enabled:=True;
    Button_SaveOPLAs.Enabled:=True;
    Label_OPL.Visible:=True;
    If Form_main.OPL.Saved=True then
    begin
      Label_OPL.Caption:='Saved';
      Label_OPL.Font.Color:=clGreen
    end
    else
    begin
      Label_OPL.Caption:='Unsaved';
      Label_OPL.Font.Color:=clRed;
    end;
  end
  else
  begin
    Button_SaveOPL.Enabled:=False;
    Button_SaveOPLAs.Enabled:=False;
    Label_OPL.Visible:=False;
  end;
  If Form_Main.KSM<>nil then
  begin
    Button_SaveKSM.Enabled:=True;
    Button_SaveKSMAs.Enabled:=True;
    Label_KSM.Visible:=True;
    If Form_main.KSM.Saved=True then
    begin
      Label_KSM.Caption:='Saved';
      Label_KSM.Font.Color:=clGreen
    end
    else
    begin
      Label_KSM.Caption:='Unsaved';
      Label_KSM.Font.Color:=clRed;
    end;
  end
  else
  begin
    Button_SaveKSM.Enabled:=False;
    Button_SaveKSMAs.Enabled:=False;
    Label_KSM.Visible:=False;
  end;
end;

procedure TForm_Shutdown.Button_SaveKCMClick(Sender: TObject);
begin
  Form_main.KCM.SaveToFile(Form_Main.KCM.FileLocation);
  Label_KCM.Visible:=True;
  Label_KCM.Caption:='Saved';
  Label_KCM.Font.Color:=clGreen
end;

procedure TForm_Shutdown.Button_SaveOPLClick(Sender: TObject);
begin
  Form_main.OPL.SaveToFile(Form_Main.OPL.FileLocation);
  Label_OPL.Visible:=True;
  Label_OPL.Caption:='Saved';
  Label_OPL.Font.Color:=clGreen
end;

procedure TForm_Shutdown.Button_SaveKSMClick(Sender: TObject);
begin
  Form_main.KSM.SaveToFile(Form_Main.KSM.FileLocation);
  Label_KSM.Visible:=True;
  Label_KSM.Caption:='Saved';
  Label_KSM.Font.Color:=clGreen
end;

procedure TForm_Shutdown.FormClose(Sender: TObject;var Action: TCloseAction);
var
  x1:Integer;
begin
  Form_Main.Timer_AutoSave.Enabled:=False;
  If Form_Main.KCM<>nil then
  begin
    Form_main.KCM.Destroy;
  end;
  If Form_Main.OPL<>nil then
  begin
    try
      Form_main.OPL.Destroy;
      Form_Main.GLDummyCube_OPLObjects.DeleteChildren;
    except
    end;
  end;
  If Form_Main.KSM<>nil then
  begin
    Form_main.KSM.Destroy;
  end;
  try
    Form_Login.Close;
  except
    Application.Terminate;
  end;
end;

procedure TForm_Shutdown.Button_SaveKCMAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
begin
  If Form_Main.KCM.FileLocation<>''then
  begin
    saveDialog:=TSaveDialog.Create(Form_Main);
    saveDialog.Title:='Save your KalClientMap';
    saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
    saveDialog.Filter := 'Kal Client Maps|*.kcm;';
    saveDialog.DefaultExt := 'kcm';
    saveDialog.FileName:='n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'.kcm';
    If SaveDialog.Execute Then
    begin
      Form_Main.KCM.SaveToFile(saveDialog.FileName);
    end;
    Form_Main.KCM.Saved:=True;
    Label_KCM.Caption:='Saved';
    Label_KCM.Color:=clGreen;
  end;
end;

procedure TForm_Shutdown.Button_SaveOPLAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
begin
  If Form_Main.OPL.FileLocation<>''then
  begin
    saveDialog:=TSaveDialog.Create(Form_Main);
    saveDialog.Title:='Save your KalClientMap';
    saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
    saveDialog.Filter := 'Kal Client Maps|*.OPL;';
    saveDialog.DefaultExt := 'OPL';
    saveDialog.FileName:='n_0'+IntToStr(Form_Main.OPL.Header.MapX)+'_0'+IntToStr(Form_Main.OPL.Header.MapY)+'.OPL';
    If SaveDialog.Execute Then
    begin
      Form_Main.OPL.SaveToFile(saveDialog.FileName);
    end;
    Form_Main.OPL.Saved:=True;
    Label_OPL.Caption:='Saved';
    Label_OPL.Color:=clGreen;
  end;
end;

procedure TForm_Shutdown.Button_SaveKSMAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
begin
  If Form_Main.KSM.FileLocation<>''then
  begin
    saveDialog:=TSaveDialog.Create(Form_Main);
    saveDialog.Title:='Save your KalClientMap';
    saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
    saveDialog.Filter := 'Kal Client Maps|*.KSM;';
    saveDialog.DefaultExt := 'KSM';
    //saveDialog.FileName:='n_0'+IntToStr(Form_Main.KSM.Header.MapX)+'_0'+IntToStr(Form_Main.KSM.Header.MapY)+'.KSM';
    If SaveDialog.Execute Then
    begin
      Form_Main.KSM.SaveToFile(saveDialog.FileName);
    end;
    Form_Main.KSM.Saved:=True;
    Label_KSM.Caption:='Saved';
    Label_KSM.Color:=clGreen;
  end;
end;

end.

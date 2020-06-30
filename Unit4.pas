unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,KalClientMap, Menus, INIFiles;

type
  TBorder=(nBorder,sBorder,wBorder,eBorder);
  TForm_BorderCenter = class(TForm)
    Image1: TImage;
    Button_NBorder: TButton;
    Button_ZBorder: TButton;
    Button_EBorder: TButton;
    Button_WBorder: TButton;
    PopupMenu1: TPopupMenu;
    Saveborder1: TMenuItem;
    Loadborder1: TMenuItem;
    procedure Create(Sender :TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_NBorderClick(Sender: TObject);
    procedure Saveborder1Click(Sender: TObject);
    procedure Loadborder1Click(Sender: TObject);
    procedure Button_ZBorderClick(Sender: TObject);
    procedure Button_EBorderClick(Sender: TObject);
    procedure Button_WBorderClick(Sender: TObject);
    function AddZeros(Num,FinalLength:Integer):String;
  private
    Border:TBorder;
  public
    { Public declarations }
  end;

var
  Form_BorderCenter: TForm_BorderCenter;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm_BorderCenter.Create(Sender :TObject);
var
  x1:Integer;
  h:THandle;
const
  WBorder:String='West Border';
  EBorder:String='East Border';
begin
  //Allowing multiline:
  h := (Button_WBorder as TButton).Handle;
  SetWindowLong(h, GWL_STYLE, GetWindowLong(h, GWL_STYLE) OR BS_MULTILINE) ;
  h := (Button_EBorder as TButton).Handle;
  SetWindowLong(h, GWL_STYLE, GetWindowLong(h, GWL_STYLE) OR BS_MULTILINE) ;

  //Writing "West Border" to Button_WBorder
  Button_WBorder.Caption:='';
  Button_WBorder.Caption:=WBorder[1];
  For x1:=2 to Length(WBorder) do
  begin
    Button_WBorder.Caption:=Button_WBorder.Caption+#13+WBorder[x1];
  end;

  //Writing "East Border" to Button_WBorder
  Button_EBorder.Caption:='';
  Button_EBorder.Caption:=EBorder[1];
  For x1:=2 to Length(WBorder) do
  begin
    Button_EBorder.Caption:=Button_EBorder.Caption+#13+EBorder[x1];
  end;
end;

procedure TForm_BorderCenter.FormShow(Sender: TObject);
var
  x1,y1:Integer;
begin
  Try
    For x1:=0 to 256 do
    begin
      For y1:=0 to 256 do
      begin
        Image1.Canvas.Pixels[x1,y1]:=rgb(round(Form_Main.KCM.HeightMap[x1][y1]/16),round(Form_Main.KCM.HeightMap[x1][y1]/16),round(Form_Main.KCM.HeightMap[x1][y1]/16));
     // Image1.Canvas.Pixels[x1,y1]:=rgb(KCM.ColorMap[x1][y1][0],KCM.ColorMap[x1][y1][1],KCM.ColorMap[x1][y1][2]);
      end;
    end;
  except;
    Self.Close;
  end;
end;


procedure TForm_BorderCenter.Button_NBorderClick(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  PopUpMenu1.Popup(P.X,P.Y);
  Border:=nBorder;
end;

procedure TForm_BorderCenter.Saveborder1Click(Sender: TObject);
var
  x1,y1,XMin,Xmax,YMin,YMax:Integer;
  F:File;
  IniFile:TINIFile;
  SaveDialog:TSaveDialog;
  //FileDialog:String;
  FileLocation:String;
  Brdr:String;
begin
  Case Border of
      nBorder: Brdr:='N';
      sBorder: Brdr:='S';
      wBorder: Brdr:='W';
      eBorder: Brdr:='E';
    end;
  SaveDialog:=TSaveDialog.Create(Form_BorderCenter);
  CreateDir(ExtractFileDir(Application.ExeName)+'\Borders\');
  SaveDialog.InitialDir:=ExtractFileDir(Application.ExeName)+'\Borders\';
  SaveDialog.FileName:='n_'+AddZeros(Form_Main.KCM.Header.MapX,3)+'_'+AddZeros(Form_Main.KCM.Header.MapY,3)+'_'+Brdr+'.kwebf';
  SaveDialog.Title:='Save your border file';
  SaveDialog.Filter := 'KWE Border File|*.kwebf;';
  SaveDialog.DefaultExt := '.kwebf';
  if SaveDialog.Execute then
  begin
    FileLocation:=SaveDialog.FileName;

    //Deleting the file so we can start from scratch
    If FileExists(FileLocation)=True then
    begin
      WINDOWS.DeleteFile(PChar(FileLocation));
    end;

    //Creating files using ini's lol,, couldn't figure anything else
    INIFile:=TINIFile.Create(FileLocation);
    INIFile.WriteString('nil','nil','temp');
    INIFIle.Free;

    //Assinging the file for writing
    AssignFile(F,FileLocation);
    Reset(F,1);
    Seek(F,0);

    //Selecting the border to copy
    Case Border of
      nBorder:  Begin
                XMin:=0;
                XMax:=256;
                YMin:=0;
                YMax:=0;
              end;
      sBorder:  Begin
                XMin:=0;
                XMax:=256;
                YMin:=256;
                YMax:=256;
              end;
      wBorder:  Begin
                XMin:=0;
                XMax:=0;
                YMin:=0;
                YMax:=256;
              end;
      eBorder:  Begin
                XMin:=256;
                XMax:=256;
                YMin:=0;
                YMax:=256;
              end;
    end;

    //Writing the border to a file:)
    for y1 := YMax downto YMin  do
    begin
      for x1 := XMin to XMax do
      begin
        BlockWrite(F,Form_Main.KCM.HeightMap[x1][y1],2);
      end;
    end;
    SaveDialog.Free;
  end;
end;

procedure TForm_BorderCenter.Loadborder1Click(Sender: TObject);
var
  x1,y1,XMin,Xmax,YMin,YMax:Integer;
  F:File;
  OpenDialog:TOpenDialog;
  FileLocation:String;
  map:TKCMHeightMap;
begin
  OpenDialog:=TOpenDialog.Create(Form_BorderCenter);
  CreateDir(ExtractFileDir(Application.ExeName)+'\Borders\');
  OpenDialog.InitialDir:=ExtractFileDir(Application.ExeName)+'\Borders\';
  OpenDialog.Title:='Save your border file';
  OpenDialog.Filter := 'KWE Border File|*.kwebf;';
  OpenDialog.DefaultExt := '.kwebf';
  if OpenDialog.Execute then
  begin
    FileLocation:=OpenDialog.FileName;

    //Assinging the file for writing
    AssignFile(F,FileLocation);
    Reset(F,1);
    Seek(F,0);

    //Selecting the border to copy
    Case Border of
      nBorder:  Begin
                XMin:=0;
                XMax:=256;
                YMin:=0;
                YMax:=0;
              end;
      sBorder:  Begin
                XMin:=0;
                XMax:=256;
                YMin:=256;
                YMax:=256;
              end;
      wBorder:  Begin
                XMin:=0;
                XMax:=0;
                YMin:=0;
                YMax:=256;
              end;
      eBorder:  Begin
                XMin:=256;
                XMax:=256;
                YMin:=0;
                YMax:=256;
              end;
    end;

    //Writing the border to a file:)
    map:=Form_Main.KCM.HeightMap;
    try
      for y1 := YMax downto YMin  do
      begin
        for x1 := XMin to XMax do
        begin
          BlockRead(F,Map[x1][y1],2);
        end;
      end;
    finally
      Form_Main.KCM.HeightMap:=map;
      Form_Main.GLHeightField.StructureChanged;
    end;
    OpenDialog.Free;
  end;
end;

procedure TForm_BorderCenter.Button_ZBorderClick(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  PopUpMenu1.Popup(P.X,P.Y);
  Border:=sBorder;
end;

procedure TForm_BorderCenter.Button_EBorderClick(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  PopUpMenu1.Popup(P.X,P.Y);
  Border:=eBorder;
end;

procedure TForm_BorderCenter.Button_WBorderClick(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  PopUpMenu1.Popup(P.X,P.Y);
  Border:=wBorder;
end;

function TForm_BorderCenter.AddZeros(Num,FinalLength:Integer):String;
var
  x1:Integer;
begin
  Result:=IntToSTr(Num);
  For x1:=1 to FinalLength do
  begin
    If Length(Result)<FinalLength then
    begin
      Result:='0'+Result
    end;
  end;
end;

end.

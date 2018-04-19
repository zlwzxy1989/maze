unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    needResize: boolean;
  end;

var
  Form2: TForm2;

implementation

uses Unit1;
{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  needResize := false;
  if gCellWidth <> StrToInt(Edit1.Text) then
  begin
    gCellWidth := StrToInt(Edit1.Text);
    needResize := true;
  end;
  gAnime := CheckBox1.Checked;
  self.close;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Button1Click(Sender);
  end;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Edit1.Text := IntToStr(gCellWidth);
  CheckBox1.Checked := gAnime;
end;

end.

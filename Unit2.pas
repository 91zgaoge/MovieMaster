unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,   Vcl.ComCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DateUtils,RegularExpressions, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    IdEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lbl1: TLabel;
    edtcnameedt: TEdit;
    lbl2: TLabel;
    edtonameedt: TEdit;
    lbl3: TLabel;
    edtyearedt3: TEdit;
    lbl4: TLabel;
    edtcountryedt: TEdit;
    chk1: TCheckBox;
    chk2: TCheckBox;
    edtjiedt: TEdit;
    edtpic: TEdit;
    lbl5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure IdEditChange(Sender: TObject);
    procedure edtjiedtChange(Sender: TObject);
    procedure edtcnameedtChange(Sender: TObject);
    procedure edtonameedtChange(Sender: TObject);
    procedure edtyearedt3Change(Sender: TObject);
    procedure edtcountryedtChange(Sender: TObject);
    procedure edtpicChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
 uses unit1;
procedure TForm2.chk1Click(Sender: TObject);
begin
Form2.IdEdit.Text :='X' + VarToStr(DateTimeToUnix(Now)*(1002+ Random(20) )) ;
end;

procedure TForm2.edtcnameedtChange(Sender: TObject);
begin
TtmpFilmData.ForceName('title').AsString  :=form2.edtcnameedt .Text;
end;

procedure TForm2.edtcountryedtChange(Sender: TObject);

begin
TtmpFilmData.ForceName('countriestxt').AsString  :=form2.edtcountryedt.Text;

end;

procedure TForm2.edtjiedtChange(Sender: TObject);
begin
TtmpFilmData.ForceName('seq').AsString :=form2.edtjiedt .Text;
end;

procedure TForm2.edtonameedtChange(Sender: TObject);
begin
TtmpFilmData.ForceName('original_title').AsString :=form2.edtonameedt .Text;
end;

procedure TForm2.edtpicChange(Sender: TObject);
begin
TtmpFilmData.ForcePath ('images.large').AsString:=form2.edtpic .Text;
end;

procedure TForm2.edtyearedt3Change(Sender: TObject);
begin
TtmpFilmData.ForceName('year').AsString:=form2.edtyearedt3 .Text;
end;

procedure TForm2.FormShow(Sender: TObject);
var
   myMoviefile: PmoviezFile;
  Item: TListItem;
  abe:string;
begin
  if Form1.listview1.SelCount > 0 then
    begin
    Item := Form1.listview1.Selected;
    new(myMoviefile);
    abe:=    Item.subitems.strings[6];
    myMoviefile := GetMoviezfilesFromHash(Item.subitems.strings[6]);
       if myMoviefile.doubanid <>'' then
      form2.IdEdit.Text:=myMoviefile.doubanid  else
      form2.IdEdit.Text:=Item.subitems.strings[4];
       if myMoviefile.cnname  <>'' then
      form2.edtcnameedt.Text:=myMoviefile.cnname   else
      form2.edtcnameedt.Text := Item.Caption   ;
             if myMoviefile.cnoname   <>'' then
      Form2.edtonameedt .text:=myMoviefile.cnoname   else
      Form2.edtonameedt .text:=Item.subitems.strings[0];
                   if myMoviefile.year    <>'' then
      Form2.edtyearedt3 .text:=myMoviefile.year    else
      Form2.edtyearedt3 .text:=Item.subitems.strings[1];
                         if myMoviefile.sep     <>'' then
      Form2.edtjiedt  .text:=myMoviefile.sep     else
      Form2.edtjiedt  .text:=Item.subitems.strings[2];
                         if myMoviefile.countries      <>'' then
      Form2.edtcountryedt .text:=myMoviefile.countries ;
    end;

form2.IdEdit.SetFocus;
end;

procedure TForm2.IdEditChange(Sender: TObject);
begin
TtmpFilmData.ForceName('id').AsString :=form2.IdEdit.Text;
end;

end.

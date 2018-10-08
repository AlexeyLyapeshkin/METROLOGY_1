unit UI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, uLexer, uDictionary, Math;

type
  TForm1 = class(TForm)
    mainmenu: TMainMenu;
    N1: TMenuItem;
    Open: TMenuItem;
    SG1: TStringGrid;
    dlgOpen1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure ShowClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lexems: TLexems;
  operands, operators: TLexems;
  operands_info: TLexemsInf;
  operators_info: TLexemsInf;
  programDictionary, programLength, programVolume: Integer;
 // programVolume: real;


implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SG1.Visible := False;
SG1.Cells[0,0]:= '                         J';
SG1.Cells[1,0]:= '                  Оператор';
SG1.Cells[2,0]:= '                     F(1j)';
SG1.Cells[3,0]:= '                         I';
SG1.Cells[4,0]:= '                   Операнд';
SG1.Cells[5,0]:= '                     F(2j)';


end;

procedure TForm1.ShowClick(Sender: TObject);
begin
    ShowMessage('Объем программы: '+inttostr(programVolume)+#10+#13+'Длина программы: '+inttostr(programLength)+#10+#13+'Словарь программы: '+inttostr(programDictionary));
end;

procedure AddMainItem(s: string);
var
  newitem: Tmenuitem;
begin
  newitem := tmenuitem.create(Form1.mainmenu);
  newitem.caption := s;
  newitem.onclick:= Form1.ShowClick;
  Form1.mainmenu.items.insert(Form1.mainmenu.items.count, newitem);
end;


procedure generateTable(filename : string);
var  filekek : TextFile;
    tempOperandsCount, tempOperatorsCount,i,mem,kek: Integer;

begin
  Form1.SG1.Visible := true;
 //

  lexems := lexems_from_file(filename);
  lex_alloc(operands, operators, lexems);
  operands_info := get_lexem_info(operands);
  operators_info := get_lexem_info(operators);
  //ShowMessage(intToStr(programDictionary));

  programDictionary := length(operands_info)  + Length(operators_info);
  tempOperandsCount := 0;
  tempOperatorsCount := 0;
  for i:= 0 to Length(operands_info)-1 do
      inc(tempOperandsCount, operands_info[i].count);
  for i:= 0 to Length(operators_info)-1 do
      inc(tempOperatorsCount, operators_info[i].count);
  programLength := tempOperandsCount + tempOperatorsCount;
  if programDictionary <> 0 then
  programVolume := Round(programLength * log2(programDictionary));

  if programLength <> 0 then
  begin
    for i:=0 to Length(operators_info)-1 do
    begin
      Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
      Form1.SG1.Cells[0,i+1] := IntToStr(i+1);
      Form1.SG1.Cells[1,i+1] := operators_info[i].name;
      Form1.SG1.Cells[2,i+1] := IntToStr(operators_info[i].count);
    end;
    //ShowMessage(IntToStr(i));
    mem := i;
    for i:=0 to Length(operands_info)-1 do
    begin
      if i >= mem+1 then
      begin
        Form1.SG1.Cells[0,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[1,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[2,form1.SG1.RowCount]:=' :))';
        Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
        Form1.SG1.Cells[0,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[1,form1.SG1.RowCount]:=' :))';
        Form1.SG1.Cells[2,form1.SG1.RowCount]:=' :))';
      end;
      Form1.SG1.Cells[3,i+1] := IntToStr(i+1);
      Form1.SG1.Cells[4,i+1] := operands_info[i].name;
      Form1.SG1.Cells[5,i+1] := IntToStr(operands_info[i].count);
    end;

    kek := i;
    Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
    Form1.SG1.Cells[0,Form1.SG1.RowCount] := 'Уникальных операторов';
    Form1.SG1.Cells[1,Form1.SG1.RowCount] := 'Вхождения операторв (N1)';
    Form1.SG1.Cells[2,Form1.SG1.RowCount] := 'Уникальных операндов ';
    Form1.SG1.Cells[3,Form1.SG1.RowCount] := 'Вхождения операндов (N2)';
    Form1.SG1.RowCount := Form1.SG1.RowCount + 1;
    Form1.SG1.Cells[0,Form1.SG1.RowCount] := IntToStr(mem);
    Form1.SG1.Cells[2,Form1.SG1.RowCount] := IntToStr(kek);
    Form1.SG1.Cells[1,Form1.SG1.RowCount] := IntToStr(tempOperatorsCount);
    Form1.SG1.Cells[3,Form1.SG1.RowCount] := IntToStr(tempOperandsCount);


    ShowMessage('Объем программы: '+inttostr(programVolume)+#10+#13+'Длина программы: '+inttostr(programLength)+#10+#13+'Словарь программы: '+inttostr(programDictionary));

     AddMainItem('Расширенные');
   end
   else ShowMessage('К сожалению, файл пуст :(');
end;


procedure TForm1.OpenClick(Sender: TObject);
var
  i,j:Integer;
begin
    with Form1.SG1 do
      for i:= + fixedcols to colcount do
        for j:= 1 + fixedrows to rowcount do
          Cells[i,j] := '';
    if dlgOpen1.Execute then
      generateTable(dlgOpen1.filename);
   SG1.RowCount := SG1.RowCount + 1;
   Repaint;
end;

end.

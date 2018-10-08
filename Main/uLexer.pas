unit uLexer;

interface

uses
  uDictionary; {������� �������� ���� � ���������� python}

function lexems_from_line(const line_str: String): TLexems;
procedure lex_alloc(var operands, operators: TLexems; const lexems: TLexems);
function lexems_from_file(const filename: String): TLexems;
function get_lexem_info(const lexems: TLexems): TLexemsInf;


implementation

function get_lexem_info(const lexems: TLexems): TLexemsInf;
{
*������� ������
}
var
  i, index: Integer;
begin
  SetLength(Result, 0);
  for i := 0 to length(lexems) - 1 do
  begin
    index := lexem_in_list(Result, lexems[i]);
    if index = -1 then
    begin  //���������� ������ ��������
      SetLength(Result, length(Result) + 1);
      Result[length(Result) - 1].name := lexems[i];
      Result[length(Result) - 1].count := 1;
    end
    else  //���������� ��������
    begin
      with Result[index] do
        count := count + 1;
    end;
  end;
end;

function lexems_from_file(const filename: String): TLexems;
{
*������ ��������� ����, ������� �� �������
*���������� ��� ������� �� �����
}
var
  F: TextFile;
  line: String;
  lexems_in_line: TLexems;
  i: Integer;
  index: Integer;
  len: Integer;
begin
  AssignFile(F, filename);

    
  Reset(F);
  
  line := '';
  SetLength(Result, 0);
  while not (EOF(F)) do
  begin
    readln(F, line);
    SetLength(lexems_in_line, 0);
    for i:=1 to Length(line) do
    begin
      if line[i] = '#' then Delete(line, i, Length(line)-i+1);
      Break;
    end;
    lexems_in_line := lexems_from_line(line);
    index := length(Result); //������, � �������� ��������� ������
    len := length(Result) + length(lexems_in_line); //���������� ������
    SetLength(Result, len);
    for i := 0 to length(lexems_in_line) - 1 do
    begin
      Result[index] := lexems_in_line[i];
      index := index + 1;
    end;
  end;
  CloseFile(F);
end;

procedure lex_alloc(var operands, operators: TLexems; const lexems: TLexems);
{
*������������� ������ �� �������� ���������, ����������
*�������� - ����������, ���������
*��������� - ���.
*���������� ��� �������
}
var
  i: Integer;
begin
  SetLength(operators, 0);
  SetLength(operands,0);
  for i := 0 to length(lexems) - 1 do
  begin
    if (lexem_in_py_statements(lexems[i])) or (lexem_in_py_keywords(lexems[i])) then
    begin  //���� �������� �����/��������
      SetLength(operators, length(operators) + 1);
      operators[length(operators) - 1] := lexems[i];
    end
    else
    begin
      if pos('( )', lexems[i]) <> 0 then
      begin //���� �������
        SetLength(operators, length(operators) + 1);
        operators[length(operators) - 1] := lexems[i];
      end
      else
      begin //�������
        SetLength(operands, length(operands) + 1);
        operands[length(operands) - 1] := lexems[i];
      end;
    end;
  end;
end;

function lexems_from_line(const line_str: String): TLexems;
{
*������� ������ ���� �� �������
}
var
  i: Integer;
  lexem_pos: Integer;
  lexem: TLexem;
begin
  SetLength(Result, 0);
  lexem_pos := 1;

  lexem := '';

  while lexem_pos <= length(line_str) do
  begin
    while line_str[lexem_pos] = ' ' do
      lexem_pos := lexem_pos + 1;

    if line_str[lexem_pos] = '#' then //������������ �����������  - �����
    begin
      Break;
    end;

    i := lexem_pos;

    while (line_str[i] in py_identifier) do
      i := i + 1;
    //���� ������� �����(!) - ����������
    if (line_str[lexem_pos] in ['0'..'9']) and (line_str[i] = '.') then
    begin
      i := i + 1;
      while (line_str[i] in py_identifier) do
        i := i + 1;
    end;
    //���� ��������� ������
    if ((line_str[i] = '"') or (line_str[i] = '''')) then
    begin
      i := i + 1;  // �������� ����������� ������
      while not ((line_str[i] = '"') or (line_str[i] = '''')) do
        i := i + 1;  // �������� �����
      i := i + 1; // �������� ������������ ������
    end;
    //���� �� �������������
    if i = lexem_pos then
      while lexem_in_py_statements(line_str[i]) do
        i := i + 1;

    lexem := copy(line_str, lexem_pos, i - lexem_pos);

    if ((line_str[i] = '(')) and (not (lexem_in_py_statements(lexem))) then //���� ������� ��� ��������-������
    begin
      lexem := lexem + '( )';
      i := i + 1;
    end;

    if (line_str[i] = ')') then
      i := i + 1;

    if lexem <> '' then //���� ������/������� �� ���������� - ������ �� �����������
    begin
      SetLength(Result, length(Result) + 1);
      Result[length(result) - 1] := lexem;
    end;

    //������� �� ��������� �������
    if lexem_pos < i then
      lexem_pos := i
    else //���� ������� ������ �� ��������� - ������� �� ����� ������
      lexem_pos := i + 1;
  end;
end;



end.

unit MyTStringsCustomSort; //�Զ���� TStringList ��������

interface

uses
  Windows, SysUtils, Variants, Classes, Controls, StdCtrls;

type
  TSortData = array of TStringList;


procedure MyStringsCustomSort(var aData: TSortData; SortIndex, SortType: Integer; SortFlg: Bool); //�Զ�������

implementation
uses unit1;

//-------�������� 1

function NumberSort_1(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Value1 := StrToInt(List[Index1]);
    Value2 := StrToInt(List[Index2]);
    if Value1 > Value2 then
      Result := -1
    else if Value1 < Value2 then
      Result := 1
    else
      Result := 0;
  except
  end;
end;

//-------�������� 2

function NumberSort_2(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Value1 := StrToInt(List[Index1]);
    Value2 := StrToInt(List[Index2]);
    if Value1 > Value2 then
      Result := 1
    else if Value1 < Value2 then
      Result := -1
    else
      Result := 0;
  except
  end;
end;

//-------�������� 1

function DateTimeSort_1(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: TDateTime;
begin
  Result := 0;
  try
    Value1 := StrToDateTime(List[Index1]);
    Value2 := StrToDateTime(List[Index2]);
    if Value1 > Value2 then
      Result := -1
    else if Value1 < Value2 then
      Result := 1
    else
      Result := 0;
  except
  end;
end;

//-------�������� 2

function DateTimeSort_2(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: TDateTime;
begin
  Result := 0;
  try
    Value1 := StrToDateTime(List[Index1]);
    Value2 := StrToDateTime(List[Index2]);
    if Value1 > Value2 then
      Result := 1
    else if Value1 < Value2 then
      Result := -1
    else
      Result := 0;
  except
  end;
end;

//-------�ַ������� 1

function StrSort_1(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Result := -CompareStr(List[Index1], List[Index2]);
  except
  end;
end;

//-------�ַ������� 2

function StrSort_2(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Result := CompareStr(List[Index1], List[Index2]);
  except
  end;
end;


//-------�����ַ����鵥Ԫ--------
//SortIndex Ҫ���е� ������ ID
//SortType �������� 0 ��С, 1 ʱ��,3 ����
//SortFlg ˳���Ƿ���

procedure MyStringsCustomSort(var aData: TSortData; SortIndex, SortType: Integer; SortFlg: Bool); //�Զ�������
var
  tls: TStringList;
  SwpStrs: TStringList;
  i: integer;
  Array_i: Integer;
begin
  tls := TStringList.Create;
  SwpStrs := TStringList.Create;
  try
    for i := 0 to aData[SortIndex].Count - 1 do
      tls.AddObject(aData[SortIndex][i], TObject(i));

    case sortType of
      0: case SortFlg of //���ִ�С��������
          True: tls.CustomSort(NumberSort_1);
          False: tls.CustomSort(NumberSort_2);
        end;
      1: case SortFlg of //���ڴ�С��������
          True: tls.CustomSort(DateTimeSort_1);
          False: tls.CustomSort(DateTimeSort_2);
        end;
      2: case SortFlg of //����˳����������
          True: tls.CustomSort(StrSort_1);
          False: tls.CustomSort(StrSort_2);
        end;

    end;

    for Array_i := 0 to High(aData) do
    begin
      SwpStrs.Clear;
      for i := 0 to tls.Count - 1 do
        SwpStrs.Append(aData[Array_i][integer(tls.Objects[i])]);
      aData[Array_i].Text := SwpStrs.Text;
    end;

  finally
    tls.Free;
    SwpStrs.Free;
  end;
end;

end.


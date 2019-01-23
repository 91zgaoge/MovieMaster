unit MyTStringsCustomSort; //自定义的 TStringList 排列类型

interface

uses
  Windows, SysUtils, Variants, Classes, Controls, StdCtrls;

type
  TSortData = array of TStringList;


procedure MyStringsCustomSort(var aData: TSortData; SortIndex, SortType: Integer; SortFlg: Bool); //自定义排序

implementation
uses unit1;

//-------数字排序 1

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

//-------数字排序 2

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

//-------日期排序 1

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

//-------日期排序 2

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

//-------字符串排序 1

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

//-------字符串排序 2

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


//-------排列字符串组单元--------
//SortIndex 要排列的 数据行 ID
//SortType 排列类型 0 大小, 1 时间,3 文字
//SortFlg 顺序还是反序

procedure MyStringsCustomSort(var aData: TSortData; SortIndex, SortType: Integer; SortFlg: Bool); //自定义排序
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
      0: case SortFlg of //数字大小排列数据
          True: tls.CustomSort(NumberSort_1);
          False: tls.CustomSort(NumberSort_2);
        end;
      1: case SortFlg of //日期大小排列数据
          True: tls.CustomSort(DateTimeSort_1);
          False: tls.CustomSort(DateTimeSort_2);
        end;
      2: case SortFlg of //文字顺序排列数据
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


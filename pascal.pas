Program CountryDatabase;

Uses
  Objects, Strings;

Const
  DatabaseFile = 'database.txt';

Type
  CountryRecord = Object
    Country, Capital: String;
    Area: Real;
    Population: Integer;
    Constructor Init(Country, Capital: String; Area: Real; Population: Integer);
  End;

Constructor CountryRecord.Init(Country, Capital: String; Area: Real; Population: Integer);
Begin
  Self.Country := Country;
  Self.Capital := Capital;
  Self.Area := Area;
  Self.Population := Population;
End;

Var
  Records: Array Of CountryRecord;
  Choice: Integer;
  Country, Capital: String;
  Area: Real;
  Population: Integer;
  I: Integer;

Procedure LoadRecords;
Var
  F: Text;
  Line, Parts: Array Of String;
  Record: CountryRecord;
Begin
  SetLength(Records, 0);
  Assign(F, DatabaseFile);
  Reset(F);
  While Not EoF(F) Do
  Begin
    ReadLn(F, Line);
    Parts := Split(Line[0], ',');
    If Length(Parts) = 4 Then
    Begin
      Record := New(CountryRecord, Init(Parts[0], Parts[1], StrToFloat(Parts[2]), StrToInt(Parts[3])));
      SetLength(Records, Length(Records) + 1);
      Records[Length(Records) - 1] := Record;
    End;
  End;
  Close(F);
End;

Procedure SaveRecords;
Var
  F: Text;
Begin
  Assign(F, DatabaseFile);
  Rewrite(F);
  For I := 0 To Length(Records) - 1 Do
    WriteLn(F, Records[I].Country, ',', Records[I].Capital, ',', Records[I].Area:0:2, ',', Records[I].Population);
  Close(F);
End;

Procedure AddRecord;
Var
  Record: CountryRecord;
Begin
  Write('Страна: ');
  ReadLn(Country);
  Write('Столица: ');
  ReadLn(Capital);
  Write('Площадь: ');
  ReadLn(Area);
  Write('Население: ');
  ReadLn(Population);
  Record := New(CountryRecord, Init(Country, Capital, Area, Population));
  SetLength(Records, Length(Records) + 1);
  Records[Length(Records) - 1] := Record;
  SaveRecords;
  WriteLn('Данные добавлены');
End;

Procedure DeleteRecord;
Var
  CapitalToDelete: String;
  I: Integer;
Begin
  Write('Введите столицу страны, данные о которой надо удалить: ');
  ReadLn(CapitalToDelete);
  For I := 0 To Length(Records) - 1 Do
    If Records[I].Capital = CapitalToDelete Then
    Begin
      Records[I].Free;
      For I := I To Length(Records) - 2 Do
        Records[I] := Records[I + 1];
      SetLength(Records, Length(Records) - 1);
      Break;
    End;
  SaveRecords;
  WriteLn('Данные удалены.');
End;

Procedure PrintRecordsByCapital;
Var
  CapitalToPrint: String;
  I: Integer;
Begin
  Write('Введите столицу страны, данные о которой надо вывести: ');
  ReadLn(CapitalToPrint);
  For I := 0 To Length(Records) - 1 Do
    If Records[I].Capital = CapitalToPrint Then
    Begin
      WriteLn('Страна: ', Records[I].Country);
      WriteLn('Площадь: ', Records[I].Area:0:2, ' кв. км.');
      WriteLn('Население: ', Records[I].Population, ' чел.');
    End;
End;

Procedure FindMinMaxPopulationDensity;
Var
  MinDensity, MaxDensity: Real;
  MinCountry, MaxCountry: String;
  I: Integer;
Begin
  MinDensity := MaxReal;
  MaxDensity := 0;
  For I := 0 To Length(Records) - 1 Do
  Begin
    Var
      Density: Real;
    Density := Records[I].Population / Records[I].Area;
    WriteLn('Плотность населения ', Records[I].Country, ' --> ', Density:0:2);
    If Density < MinDensity Then
    Begin
      MinDensity := Density;
      MinCountry := Records[I].Country;
    End;
    If Density > MaxDensity Then
    Begin
      MaxDensity := Density;
      MaxCountry := Records[I].Country;
    End;
  End;
  WriteLn('Минимальная плотность населения в ', MinCountry, ': ', MinDensity:0:2);
  WriteLn('Максимальная плотность населения в ', MaxCountry, ': ', MaxDensity:0:2);
End;

Begin
  LoadRecords;
  Repeat
    WriteLn('Что сделать?');
    WriteLn('1) Записать в файл;');
    WriteLn('2) Удалить из файла;');
    WriteLn('3) Вывести все данные на экран (По столице);');
    WriteLn('4) Найти государство с мин/макс плотностью населения');
    WriteLn('(Введите число)');
    ReadLn(Choice);
    Case Choice Of
      1: AddRecord;
      2: DeleteRecord;
      3: PrintRecordsByCapital;
      4: FindMinMaxPopulationDensity;
    Else
      WriteLn('Неверный ввод!');
    End;
  Until Choice < 1 Or Choice > 4;
  WriteLn('Программа закрывается!');
End.
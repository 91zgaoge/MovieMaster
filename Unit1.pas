unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  FileCtrl, IOUtils, Types, RegularExpressions, StrUtils, Math, qjson, qstring,
  qmsgpack, ExtActns, iduri, httpapp, qworker, QXML, ExtCtrls, DateUtils, Vcl.Menus,
  RzCommon, RzLookup, ShellAPI, IdHTTP, System.Net.HttpClient, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient,IdCoderMIME,IdGlobal, sevenzip, Vcl.Mask, RzEdit,
  RzSpnEdt, System.Net.URLClient,OpensubtitlesAPI,FMX.Platform
  //,HproseClient, HproseCommon, HproseHttpClient
  ;

const
  SELDIRHELP = 1000;

type
  TmoviezFile = record
    filename: string;   //      原始文件名含全路径
    oname: string;   //      文件名（无扩展名）
    ext: string;   //      扩展名
    path: string;   //      原始文件路径
    beename: string;   //      由文件名判断得出的电影、剧名
    cnname: string;   //      豆瓣电影、剧名
    cnoname: string;   //      豆瓣原电影、剧名
    sep: string;      //        季集
    year: string;      //         年份
    countries : string;      //         年份
    fcreatime: string;      //         创建时间
    doubanid: string;      //         豆瓣ID号
    fhash: string;      //         原始文件指纹
    srtYN: Boolean;      //         字幕有无
    ver: string;           //  版本WEB-DL
    others: string; //      备注
    encoder: string;  //        小组
    resolution: string; //          分辨率1080P
    videoBite: string;    //                   编码H264
  end;
PmoviezFile = ^TmoviezFile;
type
  TMyComplexRecord = record
    bId: string;
    bhash: string;
  end;

  PMyComplexRecord = ^TMyComplexRecord;
type
  TMyDown = record
    url: string;
    downfilename: string;
    movefilename: string;
    sid :Integer;
    sauto: string;
  end;

  PMyDown = ^TMyDown;
type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Label1: TLabel;
    PopupMenu2: TPopupMenu;
    N2: TMenuItem;
    RzLookupDialog1: TRzLookupDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    menuGetsrt: TMenuItem;
    GroupBox1: TGroupBox;
    pathListBox: TListBox;
    addPathButton: TButton;
    GroupBox2: TGroupBox;
    rssListBox: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    rssUrlEdit: TEdit;
    rssNameEdit: TEdit;
    addRssButton: TButton;
    Label4: TLabel;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    subLanSortEdit: TEdit;
    subTeamEdit: TEdit;
    subonlyCheckBox: TCheckBox;
    GroupBox4: TGroupBox;
    pathFindTimeRzSpinEdit: TRzSpinEdit;
    subFindTimeRzSpinEdit: TRzSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    infFindTimeRzSpinEdit: TRzSpinEdit;
    Label10: TLabel;
    updateRssButton: TButton;
    N7: TMenuItem;
    edtdeltxttitle: TEdit;
    lbl1: TLabel;
    rg1: TRadioGroup;
    N6: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure pathListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure addPathButtonClick(Sender: TObject);
    procedure HashClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure findFileButtonClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure menuGetsrtClick(Sender: TObject);
    procedure addRssButtonClick(Sender: TObject);
    procedure rssListBoxClick(Sender: TObject);
    procedure subLanSortEditChange(Sender: TObject);
    procedure subTeamEditChange(Sender: TObject);
    procedure pathFindTimeRzSpinEditChange(Sender: TObject);
    procedure subonlyCheckBoxClick(Sender: TObject);
    procedure infFindTimeRzSpinEditChange(Sender: TObject);
    procedure subFindTimeRzSpinEditChange(Sender: TObject);
    procedure updateRssButtonClick(Sender: TObject);
    procedure rssListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure rssfindTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure edtdeltxttitleChange(Sender: TObject);
    procedure rg1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Click(Sender: TObject);
  private
    { Private declarations }
    procedure URL_OnDownloadProgress(Sender: TDownLoadURL; Progress, ProgressMax: Cardinal; StatusCode: TURLDownloadStatus; StatusText: string; var Cancel: Boolean);
  public
    { Public declarations }

  end;
procedure DoJobDown(AJob: PQJob);

   //以豆瓣ID号索引douban.data写入电影标题简介等资料
procedure DoJobFindPath(AJob: PQJob);

procedure DoJobView(AJob: PQJob);
procedure DoJobNetPut(AJob: PQJob);
procedure DoJobRssUpdate(AMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt);
procedure DoJobGetdoubanid(AJob: PQJob);
procedure DoJobRssFind(AJob: PQJob);

procedure DoJobWritenfo(AJob: PQJob);

procedure DoFreeMyComplexRecord(AData: Pointer);
 procedure DoFreeMydown(AData: Pointer);
 procedure DoFreeMymoviezfile(AData: Pointer);
procedure Writenfo(var Did: string; var ohash: string);
 function myStrToHex(s:string):string; //字串转16进制
 function myHexToStr(S:string):string; //16进制转字串
function MultiMaxnum(AInt: array of Integer): Integer;

function Matchnum(ss: string; subteam: string): integer;
function DownloadFile(const URL: string; const filename: string): Boolean;
function Getsub(chash: string; auto: string = '-a'): Boolean;
 function Base64Encode(s : string) : string;
 function Base64Decode(s : string) : string;  //base64 解码
//procedure Getdoubanid(const Mysub: string; const ohash: string; var Resultd: TQJson; mysid: string = '');

function CustomSortProc(Item1, Item2: TListItem; ParamSort: Integer): Integer; stdcall;

function CustomSorttxtProc(Item1, Item2: TListItem; ParamSort: Integer): Integer; stdcall;

function cuttext(pptext: string; addex: string = ''): string;

function getyear(pptext: string): string;

//利用IFMXApplicationService接口，访问AppVersion即可取得应用的版本号。
//代码如下，Win32,Android测试通过，需要引用FMX.Platform单元。
function GetAppVersion: String;

function SplitStrings(const source, ch: string): TStringList;

function Getdoubanid(ohash: string;mysid: string = '' ;auto:string = '-no' ): TQJson;
function Getidc(doubanourdata: TQJson): TQJson;
procedure GetFilenames(sPath, sFilename: string; AList: TStrings);

function SearchFiles(const path, pattern: string; list: TStrings = nil): Boolean;
  //更名字幕，OKpath为整个目录下的字幕更名，适合剧集目录
function renamesub(ohash: string): Boolean;//
function Mysort(tempqjson: TQjson): TQjson;
//获取豆瓣ID后写入各数据文件中共4个

procedure WriteHashIDData(var mysid: string; var ohash: string);

procedure QuickSortStd(var abc: array of Integer);
    //将若干个基本数据合并为最新数据   命名格式 Data.IDHashData Data.nmaeIDData Data.HashpropertiesData Data.DoubanData

procedure MyaddData;
    //基本数据初始化

procedure Myinitialize;

procedure JsonWritenfo(var tmpxml: TQXMLNode; var DonbanData: TQJson; var Did: string; var fhashs: string; var Myxmlfilename: string);
//基本数据保存为数据文件
procedure MySaveData;

function my_cmp(Item1, Item2: Pointer): Integer;

function getep(pptext: string; eps: string = ''): string;
   //读取网页结果

function GetURLstring(url: string; otherstr: string; sitename: string = ''): string;
   //用ID查找豆瓣电影和片名等

function Getdoubanall(Myid: string): TQJson;
 //取文件名的扩展名前一个以.分隔的字符如chs或简体

function GetStrR2(vString: string): string;
 //获取文件大小

function GetFileSizes(AFileName: string): Int64;
 //取副标题里的备注[]中的内容

function getstitle(pptext: string): Boolean;
 //根据Rss副标题写入文件名对应的信息_nameid.data

function CompFile(const f1,f2: string): Boolean;
  function DecodeUtf8Str(const S: UTF8String): String;

 //取跳转URL的最终链接值

function GetHttpAurl(AUrl: string): string;
//判断文件类型函数：

function GetFileType(FileName: string): string;

  //数字转中文

function numcn(ii: integer): string;
  //从hash找文件各属性获取全部属性

function GetMoviezfilesFromHash(fhashs: string): PmoviezFile;
   //从可能不规范的集数中提取数字转成标准的S01E03

function numtosep(pptext: string): string;

//http://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes
// opensubtitles函数
function CalcGabestHash(const fname: string): string;

//射手网hash函数
function CSVhash(const iFileName: string): string;
procedure WriteSubRSS(const rssname: string; Sender: TObject);

var
  Form1: TForm1;
  FOptionJson, IDHashDataJson, MyfileJson,DoubanIDJson, DoubanDataJson, HashDataJson, PubNameIDDataJson, NameIDDataJson, RssDataJson,TtmpFilmData: TQJson;
  //MyFilelistJson:TQJson; //writeto _file.data[{"moviename":"","pathinfo":"","filehash":"","lastatime":""},...]最后写入时间 TFile.GetLastAccessTime();
  Deltxttitle: string;
  Myoptionfilename, IDHashData,DoubanIDData,Myfilename, PubNameIDData, NameIDData, HashData, RssData: string;
  m_bSort: Boolean = false; //控制双向排序

implementation

uses
  IdHashMessageDigest, Unit2, Unit3;
{$R *.dfm}

procedure Tform1.URL_OnDownloadProgress;
begin
   //加上这句界面不卡死.
  Application.ProcessMessages;
 //  ProgressBar1.Max:= ProgressMax;
 // ProgressBar1.Position:= Progress;
end;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: Integer): Integer; stdcall;
var
    // txt1, txt2: string;
  txt1, txt2: Integer;
begin
  if ParamSort <> 0 then
  begin
    try
      txt1 := StrToIntDef(Item1.SubItems.Strings[ParamSort - 1], 0);
      txt2 := StrToIntDef(Item2.SubItems.Strings[ParamSort - 1], 1);
      if m_bSort then
      begin
          // Result := CompareText(txt1, txt2);
        Result := txt1 - txt2;
      end
      else
      begin
        Result := -(txt1 - txt2);
          // Result := -CompareText(txt1, txt2);
      end;
    except
    end;

  end
  else
  begin
    if m_bSort then
    begin

      Result := CompareText(Item1.Caption, Item2.Caption);
    end
    else
    begin
      Result := -CompareText(Item1.Caption, Item2.Caption);
    end;
  end;
end;

function CustomSorttxtProc(Item1, Item2: TListItem; ParamSort: Integer): Integer; stdcall;
var
  txt1, txt2: string;
    //txt1, txt2: Integer;
begin
  if ParamSort <> 0 then
  begin
    try

      txt1 := Item1.SubItems.Strings[ParamSort - 1];

      txt2 := Item2.SubItems.Strings[ParamSort - 1];
      if m_bSort then
      begin
        Result := CompareText(txt1, txt2);
         // Result := txt1 - txt2;
      end
      else
      begin
         //  Result := -(txt1 - txt2);
        Result := -CompareText(txt1, txt2);
      end;
    except
    end;

  end
  else
  begin
    if m_bSort then
    begin

      Result := CompareText(Item1.Caption, Item2.Caption);
    end
    else
    begin
      Result := -CompareText(Item1.Caption, Item2.Caption);
    end;
  end;
end;
 //以上是数字的排序，如果需要汉字什么的排序，这将上面的strtoint去掉，并将上面的注释行替换上面的行就行了










  { 取文件MD5码 }
 //射手影音智能字幕查询API（JSON）SVPlayer视频文件hash算法 （草）
 //https://www.shooter.cn/api/subapi.php?filehash=8B1F2B55A0C9E1EA5D72020EF226602F;9954BC38F591E1600FC9CBC28CD4EC96;42F30D525EFCAA974E5E9CFD95A97F6C;F6F336321B54C805F7FF68F083002645&pathinfo=d:/Hunters.S01E01.720p.HDTV.x264-AVS.mkv&format=json&lang=chn
 //Version. 0.1    Date: 2008-11-04方案
 //取文件第4k位置，再根据floor( 文件总长度/3 )计算，取中间2处，再取文件结尾倒数第8k的位置， 4个位置各取4k区块做md5。共得到4个md5值，均设为索引。可以进行智能匹配。 （可以应用于不完全下载的p2p文件）
 //https://docs.google.com/document/d/1w5MCBO61rKQ6hI5m9laJLWse__yTYdRugpVyz4RzrmM/preview

function CSVhash(const iFileName: string): string;
var
  MemSteam: TFileStream;
  Target: TMemoryStream;
//MemSteam: TmemoryStream;
  MyMD5: TIdHashMessageDigest5;
  timecost: LongInt;
  szMD5, szRet: string;
  ftotallen: int64;
  offset: array[0..3] of int64;
// Buffer:Array[0..4096] of byte;
  I: integer;
begin
  //timecost:=GetTickCount;
 // MemSteam:= TFileStream.Create();
 // try
  //MemSteam:=TFile.open(iFileName,TFileMode.fmAppend,TFileAccess.faRead,TFileShare.fsRead);

{ Filestream:=TFileStream.Create(AFileName,fmShareExclusive);

       Filestream.Position:=0;

       FileStream.Read(ABuffer,sizeof(ABuffer));

     FreeAndNil(FileStream);
   将两个流分离
var
  Source: TFileStream;
  Target: TMemoryStream;
  MyFileSize: integer;
Begin
MyFileSize:=辅文件长度;
  Target :=TMemoryStream.Create;
  Source:=TFileStream.Create(主文件, fmOpenRead  or
          fmShareDenyNone);
      Source.Seek(-MyFileSize, soFromEnd); //定位到资源位置
//注意：这里面-sizeof(MyFileSize)的原表达式是0-SizeOf(MyFileSize)。意思将指针移到离末尾MyFileSize个字节处，准备从该处起读取数据。参数soFromEnd就是“离末尾”的意思，如果参数是soFromBeginning，那就是“离前面”的意思。
  Target.CopyFrom(Source, MyFileSize); //取出资源
  Target.SaveToFile(TargetFile); //存放到文件
  共享模式：
fmShareCompat :共享模式与FCBs兼容
fmShareExclusive:不允许别的程序以任何方式打开该文件
fmShareDenyWrite:不允许别的程序以写方式打开该文件
fmShareDenyRead :不允许别的程序以读方式打开该文件
fmShareDenyNone :别的程序可以以任何方式打开该文件

     }
 //  Target :=TMemoryStream.Create;
  if tfile.Exists(iFileName) then
  begin
    try
      MemSteam := TFileStream.Create(iFileName, fmOpenRead or fmShareDenyNone);

      MemSteam.Position := 0;
  // SetLength(MemSteam,GetFileSize(iFileName));
  //  fs.ReadBuffer((PChar(str))^,fs.Size);
      ftotallen := GetFileSizes(iFileName);
      if (ftotallen < 8192) then
      begin
      Result := '';
      end
      else
      begin
        offset[3] := ftotallen - 8192;
        offset[2] := round(ftotallen / 3);
        offset[1] := round(ftotallen / 3 * 2);
        offset[0] := 4096;
        MyMD5 := TIdHashMessageDigest5.Create;
        for I := 0 to 3 do
        begin
  //      MemSteam.Seek(offset[I],0);
  //      Target.CopyFrom(MemSteam,4096);
          szMD5 := MyMD5.HashStreamAsHex(MemSteam, offset[I], 4096);
          if szRet <> '' then
            szRet := szRet + ';';
          szRet := szRet + szMD5;
        end;
 // timecost:=GetTickCount-timecost;
 // Result := szRet + '||||'  + inttostr(timecost);
        Result := szRet;
      end;
  //finally
    //  MyMD5.Free;
  // MemSteam:=nil ;
//  end;
 //  MyMD5.Free;
      FreeAndNil(MemSteam);
                 FreeAndNil(MyMD5);
    except
      Result := '';
 // MyMD5.Free;
 //  FreeAndNil(MemSteam);
    end;
  end;

  end;


function SplitStrings(const source, ch: string): TStringList;
var
  temp, t2: string;
  i: integer;
begin
  result := TStringList.Create;
  temp := source;
  i := pos(ch, source);
  while i <> 0 do
  begin
    t2 := copy(temp, 0, i - 1);
    if (t2 <> '') then
      result.Add(t2);
    delete(temp, 1, i - 1 + Length(ch));
    i := pos(ch, temp);
  end;
  result.Add(temp);
end;

function myStrToHex(s:string):string; //字串转16进制
var
  TmpStr:string;
  i:integer;
begin
  TmpStr:='';
  for i:=1 to Length(s)do
    TmpStr:=TmpStr+IntToHex(ord(s[i]),2);
  Result:=TmpStr;
end;

function myHexToStr(S:string):string; //16进制转字串
var
  HexS,TmpStr:string;
  i:Integer;
  a:Byte;
begin
  HexS:=s;
  if Length(HexS) mod 2=1 then
    HexS:=HexS+'0';
  TmpStr:='';
  for i:=1 to(Length(HexS)div 2)do
  begin
    a:=StrToInt('$'+HexS[2*i-1]+HexS[2*i]);
    TmpStr:=TmpStr+Chr(a);
  end;
  Result:=TmpStr;
end;




//获取json豆瓣电影数据
function Mygetjson(Myqjsonsur: TQJSON): tstringlist;
var
  aqjson, aqjsonarr: TQJSON;
  i: Integer;
  tmpstrlist: tstringlist;
begin
  tmpstrlist := tstringlist.Create;
  aqjson := TQJSON.Create;
  aqjsonarr := TQJSON.Create;
  aqjson.parse(Myqjsonsur.ToString);
  if aqjson.ValueByName('subjects', '') <> '' then
  begin
    aqjsonarr := aqjson.ItemByName('subjects');
                        {images.large
                    rating.average
                    countries
                    genres
                    current_season
                    summary
                    subtype
                    }
    if aqjsonarr.Items[0].ValueByName('title', '') <> '' then
      tmpstrlist.Values['stitle'] := aqjsonarr.Items[0].ValueByName('title', '');
    if aqjsonarr.Items[0].ValueByName('year', '') <> '' then
      tmpstrlist.Values['stime'] := aqjsonarr.Items[0].ValueByName('year', '');
    if aqjsonarr.Items[0].ValueByName('id', '') <> '' then
      tmpstrlist.Values['sid'] := aqjsonarr.Items[0].ValueByName('id', '');
    if aqjsonarr.Items[0].ValueByName('original_title', '') <> '' then
      tmpstrlist.Values['sotitle'] := aqjsonarr.Items[0].ValueByName('original_title', '');
    tmpstrlist.Values['txt'] := tmpstrlist.Values['stitle'] + '|' + tmpstrlist.Values['sotitle'] + '|' + tmpstrlist.Values['sid'] + '|' + tmpstrlist.Values['stime'];
 //  result:=stitle + '|' + sotitle + '|' + sid + '|' + stime;
    result := tmpstrlist;
  end;
  FreeAndNil(tmpstrlist);
  FreeAndNil(aqjson);
  FreeAndNil(aqjsonarr);
end;




//用百分比比较两个字符串(彼此之间有多少相似度) 返回 byte 类型，从 0 到 100%

function CompareStringsInPercent(Str1, Str2: string): Byte;
type
  TLink = array[0..1] of Byte;
var
  tmpPattern: TLink;
  PatternA, PatternB: array of TLink;
  IndexA, IndexB, LengthStr: Integer;
begin
  Result := 100;
  // Building pattern tables
  LengthStr := Max(Length(Str1), Length(Str2));
  for IndexA := 1 to LengthStr do
  begin
    if Length(Str1) >= IndexA then
    begin
      SetLength(PatternA, (Length(PatternA) + 1));
      PatternA[Length(PatternA) - 1][0] := Byte(Str1[IndexA]);
      PatternA[Length(PatternA) - 1][1] := IndexA;
    end;
    if Length(Str2) >= IndexA then
    begin
      SetLength(PatternB, (Length(PatternB) + 1));
      PatternB[Length(PatternB) - 1][0] := Byte(Str2[IndexA]);
      PatternB[Length(PatternB) - 1][1] := IndexA;
    end;
  end;
  // Quick Sort of pattern tables
  IndexA := 0;
  IndexB := 0;
  while ((IndexA < (Length(PatternA) - 1)) and (IndexB < (Length(PatternB) - 1))) do
  begin
    if Length(PatternA) > IndexA then
    begin
      if PatternA[IndexA][0] < PatternA[IndexA + 1][0] then
      begin
        tmpPattern[0] := PatternA[IndexA][0];
        tmpPattern[1] := PatternA[IndexA][1];
        PatternA[IndexA][0] := PatternA[IndexA + 1][0];
        PatternA[IndexA][1] := PatternA[IndexA + 1][1];
        PatternA[IndexA + 1][0] := tmpPattern[0];
        PatternA[IndexA + 1][1] := tmpPattern[1];
        if IndexA > 0 then
          Dec(IndexA);
      end
      else
        Inc(IndexA);
    end;
    if Length(PatternB) > IndexB then
    begin
      if PatternB[IndexB][0] < PatternB[IndexB + 1][0] then
      begin
        tmpPattern[0] := PatternB[IndexB][0];
        tmpPattern[1] := PatternB[IndexB][1];
        PatternB[IndexB][0] := PatternB[IndexB + 1][0];
        PatternB[IndexB][1] := PatternB[IndexB + 1][1];
        PatternB[IndexB + 1][0] := tmpPattern[0];
        PatternB[IndexB + 1][1] := tmpPattern[1];
        if IndexB > 0 then
          Dec(IndexB);
      end
      else
        Inc(IndexB);
    end;
  end;
  // Calculating simularity percentage
  LengthStr := Min(Length(PatternA), Length(PatternB));
  for IndexA := 0 to (LengthStr - 1) do
  begin
    if PatternA[IndexA][0] = PatternB[IndexA][0] then
    begin
      if Max(PatternA[IndexA][1], PatternB[IndexA][1]) - Min(PatternA[IndexA][1], PatternB[IndexA][1]) > 0 then
        Dec(Result, ((100 div LengthStr) div (Max(PatternA[IndexA][1], PatternB[IndexA][1]) - Min(PatternA[IndexA][1], PatternB[IndexA][1]))))
      else if Result < 100 then
        Inc(Result);
    end
    else
      Dec(Result, (100 div LengthStr))
  end;
  SetLength(PatternA, 0);
  SetLength(PatternB, 0);
end;



 //根据文件列表进行分类索引
function GetMovieindexlist(fileslist: TQJson): TQJson;
var
  SOtmptitle, Myfilelistname, tmpssur: string;
  SOlists, tmplist, tmpindexsr: TQJson;
begin
//  form1.ListBox1.Items.Clear;
  tmpindexsr := TQJson.Create;
  SOlists := TQJson.Create;
  tmplist := TQJson.Create;
  Myfilelistname := ExtractFilePath(Application.ExeName) + '_data.data';
  fileslist.RevertOrder(True);
  tmplist := fileslist;
  for tmpindexsr in tmplist do
  begin
    tmpssur := tmpindexsr.ValueByName('filename', '');
    SOtmptitle := cuttext(TPath.GetFileNameWithoutExtension(TPath.GetFileName(tmpssur)));

 // form1.ListBox1.Items.Add(SOtmptitle);

    if (SOtmptitle <> '') then
    begin
      SOlists.ForcePath(SOtmptitle + '.path[].name').AsString := tmpssur;
//      SOlists.ForcePath('title').AsString:= SOtmptitle;
    end;

  end;
  SOlists.SaveToFile(Myfilelistname, teUtf8, True, True);
  Result := SOlists;
   FreeAndNil(tmpindexsr);
  FreeAndNil(SOlists);
  FreeAndNil(tmplist);
end;



 //根据Rss副标题写入文件名对应的信息_nameid.data
procedure WriteSubRSS(const rssname: string; Sender: TObject);
type
  at = array of string;
var
  xyss: at;
  Action: TDownloadUrl;
  urltxt: string;
  tmpedata: TQJson;
  AXML, tmpxml: TQXMLNode;
begin

  tmpedata := TQJson.Create;
  AXML := TQXMLNode.Create;
  tmpxml := TQXML.Create;
 // Action := TDownloadUrl.Create(self);
  Action := TDownloadUrl.Create(application);
  Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;
  urltxt := Foptionjson.ValueByPath('rss.' + rssname, '');
//       urltxt:=StringReplace(urltxt,'#1' ,chash, [rfReplaceAll, rfIgnoreCase]);
//       urltxt:=StringReplace(urltxt,'#2' ,filepath, [rfReplaceAll, rfIgnoreCase]);

  xyss := at.Create('', '');
  if urltxt <> '' then
  begin
    try
      Action.URL := TIdUri.URLEncode(urltxt);
//    Action.Filename:=ExtractFilePath(Application.ExeName)+rssname + inttostr(DateTimeToUnix(Now)) +'_tmp.xml';
      Action.Filename := ExtractFilePath(Application.ExeName) + rssname + '_tmp.xml';
      if Action.Execute then
      begin
        if tfile.Exists(Action.Filename) then
        begin
          tmpxml.LoadFromFile(Action.Filename);

          if Assigned(tmpxml.ItemByPath('rss.channel.item')) then
          begin
            for AXML in tmpxml.ItemByPath('rss.channel.item.title') do
            begin
              if getstitle(AXML.Text) then
 //                 HashDataJson.Forcename(xyss[0]).AsString := xyss[1];

            end;
          end;

          DeleteFile(Action.Filename);
        end;
      end;

    except
      Action.Free;
    //  DeleteFile(Action.Filename);
    end;
  end;
     FreeAndNil(tmpedata);
  FreeAndNil(AXML);
  FreeAndNil(tmpxml);
end;


 //写入nfo
procedure JsonWritenfo(var tmpxml: TQXMLNode; var DonbanData: TQJson; var Did: string; var fhashs: string; var Myxmlfilename: string);
var
  I, iin: integer;
  Myxmlfilenamebak,dsubtype, seasontxt, episodetxt, septxt, tmpsss, tmpstxt, s, e,filepath,cnnamefile: string;
  myMoviefile: PmoviezFile;
begin

new(myMoviefile);
  myMoviefile := GetMoviezfilesFromHash(fhashs);
  filepath:= myMoviefile.filename  ;
 cnnamefile := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + DonbanData.ForceName('title').ToString + '.nfo';

  //"subtype":"movie","subtype":"tv",
           if DonbanData.ForceName('subtype').IsString  then dsubtype := DonbanData.ForceName('subtype').ToString;
  if dsubtype = 'tv' then
    dsubtype := 'tvshow' else     dsubtype := 'movie';

  tmpxml.Add(dsubtype);
 //   tmpxml.ForcePath(dsubtype +'.title').AddText(DonbanData.ForcePath(Did + '.title').ToString);
 //filenameandpath
  tmpxml.ForcePath(dsubtype + '.year').AddText(DonbanData.ForceName('year').ToString);
  tmpxml.ForcePath(dsubtype + '.originaltitle').AddText(DonbanData.ForceName('original_title').ToString);
  tmpxml.ForcePath(dsubtype + '.doubanid').AddText(DonbanData.ForceName('id').ToString);
  tmpxml.ForcePath(dsubtype + '.filenameandpath').AddText(filepath);

          if Assigned(HashDataJson.ItemByPath(fhashs + '.sep')) then
        begin
      septxt := HashDataJson.ItemByPath(fhashs + '.sep').Value;

    end else
     septxt := getep(TPath.GetFileNameWithoutExtension(TPath.GetFileName(filepath))); //加上季集数
     //判断如果是电视剧
  if ((dsubtype = 'tvshow') or (septxt <> '')) and (dsubtype <> 'movie') then
  begin
    seasontxt := TRegEx.Replace(septxt, '[s]{0,1}([0-9]{0,3})[e]{0,1}[0-9]{0,5}', '$1', [roIgnoreCase]);
    s := inttostr(StrToIntDef(seasontxt, 1));
    episodetxt := TRegEx.Replace(septxt, '[s]{0,1}[0-9]{0,3}[e]{0,1}([0-9]{0,5})', '$1', [roIgnoreCase]);
    e := inttostr(StrToIntDef(episodetxt, 1));
//总季集数
    tmpstxt := DonbanData.ForceName ('seasons_count').ToString;
    if tmpstxt = '' then
      tmpstxt := '1';
    tmpxml.ForcePath(dsubtype + '.season').AddText(tmpstxt);
    tmpxml.ForcePath(dsubtype + '.episode').AddText(DonbanData.ForceName('episodes_count').ToString);
//当前季集数
    tmpxml.ForcePath(dsubtype + '.displayseason').AddText(s);
    tmpxml.ForcePath(dsubtype + '.displayepisode').AddText(e);
 //kodi需要将目录命名为showtitle同样名字
 //    tmpxml.ForcePath(dsubtype +'.showtitle').AddText(TPath.GetFileNameWithoutExtension(TPath.GetFileName(filepath)));
 //简陋地在标题上加上季集数便于识别
    tmpxml.ForcePath(dsubtype + '.title').AddText(DonbanData.ForceName('title').ToString + septxt);
     //.AsXML(DonbanData.ForcePath(Did + '.title').ToString +septxt);;
   //kodi set 标签
  //  tmpxml.ForcePath(dsubtype + '.set').AddText(DonbanData.ItemByPath('title').ToString);
  end
  else
    tmpxml.ForcePath(dsubtype + '.title').AddText(DonbanData.ForceName('title').ToString);


  tmpsss := DonbanData.ForceName('title').ToString;
  if (TRegEx.ISMatch(septxt, '[S]{0,1}[0-9]{0,3}[E]{0,1}[0-9]{0,5}', [roIgnoreCase])) and (septxt <> '') and
   not (TRegEx.ISMatch(tmpsss, '季|第', [roIgnoreCase])) and (dsubtype <> 'movie') then
  begin
    tmpstxt := TRegEx.Replace(septxt, '[S]{0,1}([0-9]{0,3})[E]{0,1}[0-9]{1,5}', '$1', [roIgnoreCase]);
    if tmpstxt = '' then
      tmpstxt := '1';
    iin := StrToIntDef(tmpstxt, 1);
    tmpstxt := '第' + numcn(iin) + '季';
  //kodi set 标签
    tmpxml.ForcePath(dsubtype + '.set').AddText(DonbanData.ForceName('title').ToString + ' ' + tmpstxt);
  end
  else
  begin
    if IDHashDataJson.ItemByName(Did).Count > 1 then
      tmpxml.ForcePath(dsubtype + '.set').AddText(DonbanData.ForceName( 'title').ToString);
  end;


                   //tmpxml.ForcePath('movie.countries').AddText(DonbanData.ForcePath(Ddata + '.doubandata.countries').ToString);
  if DonbanData.ForceName('countries').IsArray then
    for I := 0 to DonbanData.ForceName('countries').Count - 1 do
    begin
      with tmpxml.ForcePath(dsubtype).Add('countries') do
      begin
        AddText(DonbanData.ForceName('countries').Items[I].ToString);
      end;
    end;
  if DonbanData.ForceName('genres').IsArray then
    for I := 0 to DonbanData.ForceName( 'genres').Count - 1 do
    begin
      with tmpxml.ForcePath(dsubtype).Add('genre') do
      begin
        AddText(DonbanData.ForceName('genres').Items[I].ToString);
      end;
    end;
  tmpxml.ForcePath(dsubtype + '.rating').AddText(DonbanData.ForcePath('rating.average').ToString);
  if DonbanData.ForceName('directors').IsArray  then
  begin
  if DonbanData.ForceName('directors').AsArray <>'[]'    then
  tmpxml.ForcePath(dsubtype + '.director').AddText(DonbanData.ForcePath( 'directors[0].name').ToString);
 // tmpxml.ForcePath(dsubtype + '.director').AddText(DonbanData.ItemByName('directors').AsArray);
  end else
  begin
  tmpxml.ForcePath(dsubtype + '.director').AddText(DonbanData.ForceName('directors').AsString);
  end;
                   //tmpxml.ForcePath('movie.genre').AddText(DonbanData.ForcePath(Ddata + '.doubandata.genres').ToString);
  tmpxml.ForcePath(dsubtype + '.plot').AddText(DonbanData.ForceName('summary').ToString);
  tmpxml.ForcePath(dsubtype + '.sorttitle').AddText(DonbanData.ForceName( 'aka').ToString);
  if DonbanData.ForceName('directors').IsArray then
    for I := 0 to DonbanData.ForceName('directors').Count - 1 do
    begin
      with tmpxml.ForcePath(dsubtype).Add('director') do
      begin
        AddText(DonbanData.ForcePath('directors').Items[I].ValueByName('name', ''));
      end;

    end;
                    {
                    tmpxml.ForcePath('movie').Attrs.AsString['title'] := tmpedata.Values['stitle'];
                    tmpxml.ForcePath('movie').Attrs.AsString['year'] := tmpedata.Values['stime'];
                    tmpxml.ForcePath('movie').Attrs.AsString['originaltitle']:= tmpedata.Values['sotitle'];
                    tmpxml.ForcePath('movie').Attrs.AsString['id']:= tmpedata.Values['sid'];  }
  tmpxml.SaveToFile(cnnamefile, teUtf8, True, True);
 // Myxmlfilenamebak := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + '.bak.' + inttostr(DateTimeToUnix(Now)) + '.nfo';
  Myxmlfilenamebak := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + '.bak.nfo';
  tmpxml.SaveToFile(Myxmlfilenamebak, teUtf8, True, True);
      if tfile.Exists(Myxmlfilename) then
    begin
   //     if CompFile(Myxmlfilename,cnnamefile)=False then
   //   begin
     Tfile.SetAttributes(Myxmlfilename, [TFileAttribute.faNormal]);
 // RenameFile(Myxmlfilename,Myxmlfilenamebak);
      TFile.Copy(Myxmlfilename, Myxmlfilenamebak, True); {将覆盖同名的文件}
 //DeleteFile(Myxmlfilename);
      try
     //   TFile.Delete(Myxmlfilenamebak);
        tmpxml.SaveToFile(Myxmlfilename, teUtf8, True, True);
      except
     //   ShowMessage('nfo文件无法更名或存档' + Myxmlfilename);
      end;
  //    end else TFile.Delete(Myxmlfilenamebak);;

    end else  tmpxml.SaveToFile(Myxmlfilename, teUtf8, True, True);
     //把原nfo文件改名



  tmpxml.Clear(true);
end;


function CompFile(const f1,f2: string): Boolean;
var
  fs1,fs2: TFileStream;
  ms: TMemoryStream;
  i,p: Integer;
  b1,b2: Byte;
begin
  Result := False;
  if not (FileExists(f1) and FileExists(f2)) then Exit;
  fs1 := TFileStream.Create(f1, fmOpenRead);
  fs2 := TFileStream.Create(f2, fmOpenRead);

  if fs1.Size <> fs2.Size then
  begin
    fs1.Free;
    fs2.Free;
    Exit;
  end;

  Result := True;
  Randomize;
  for i := 0 to 9 do
  begin
    p := Random(fs1.Size);
    fs1.Position := p;
    fs2.Position := p;
    fs1.ReadBuffer(b1,1);
    fs2.ReadBuffer(b2,1);
    if b1 <> b2 then
    begin
      Result := False;
      Break;
    end;
  end;

  fs1.Free;
  fs2.Free;
end;






  //更名字幕，(OKpath)为整个目录下的字幕更名，适合剧集目录
function renamesub(ohash: string): Boolean;//
var
  Myxmlfilenamebak, Myxmlfilename, filepath, Extsub, tmpsub, Exttxt, tmpext, tts, bbm, cck, eet, ffg, msubFileName: string;
  myMoviefile: PmoviezFile;
  tmpidtxt, mkvfilename, subfilename: TStrings;
  tmpindexsr, Aru, AItem: TQJson;
begin
  Result := False;
  mkvfilename := TStringList.Create;
  subfilename := TStringList.Create;
  tmpidtxt := tstringlist.Create;
  tmpindexsr := TQJson.Create;
  Aru := TQJson.Create;
  new(myMoviefile);
  myMoviefile := GetMoviezfilesFromHash(ohash);

  if (SearchFiles(myMoviefile.path, '*.ass', subfilename)) or (SearchFiles(myMoviefile.path, '*.srt', subfilename)) then
  begin

    Extsub := '.ass;.srt';
    tmpidtxt := SplitStrings(Extsub, ';');
    for tmpext in tmpidtxt do
    begin
      SearchFiles(myMoviefile.path, '*' + tmpext, subfilename);
    end;
    tmpext:='';
    if myMoviefile.sep <> '' then
    begin

      for tmpext in subfilename do
      begin
   //TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames));
        tts := cuttext(tpath.GetFileNameWithoutExtension(TPath.GetFileName(tmpext))) + getep(tpath.GetFileNameWithoutExtension(TPath.GetFileName(tmpext)));
        ffg := cuttext(myMoviefile.oname )+ getep(myMoviefile.oname);

        if (lowercase(ffg)) = (lowercase(tts)) then
        begin
          eet := myMoviefile.path;             {提取路径}
          bbm := TPath.GetExtension(tmpext); {提取扩展名}
          cck := GetStrR2(tmpext); {提取扩展名前的.chs这种标注字段}
          msubFileName := eet + myMoviefile.oname + '.' + cck + bbm;

          try
            if tfile.Exists(msubFileName) then
              TFile.Delete(msubFileName);
            TFile.Copy(eet + tmpext, msubFileName);
            Result := True;
            exit
          except
     //   ShowMessage('文件无法更名或存档' + msubFileName);
            Result := False;
            exit
          end;

        end;

      end;

    end
    else
    begin

      for tmpext in subfilename do
      begin
   //TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames));
        tts := tpath.GetFileNameWithoutExtension(TPath.GetFileName(tmpext));
        if lowercase(cuttext(myMoviefile.oname )) = lowercase(cuttext(tts)) then
        begin
          eet := myMoviefile.path;             {提取路径}
          bbm := TPath.GetExtension(tmpext); {提取扩展名}
          cck := GetStrR2(tmpext); {提取扩展名前的.chs这种标注字段}
          msubFileName := eet + myMoviefile.oname + '.' + cck + bbm;
          try
            if tfile.Exists(msubFileName) then
              TFile.Delete(msubFileName);
            TFile.Copy(eet + tmpext, msubFileName);
            Result := True;
            exit
          except
     //   ShowMessage('文件无法更名或存档' + msubFileName);
            Result := False;
            exit
          end;
        end;

      end;

    end;

  end;
  freeandnil( mkvfilename);
  freeandnil( subfilename);
  freeandnil( tmpidtxt );
  freeandnil( tmpindexsr);
  freeandnil( Aru);
end;


function Base64Encode(s : string) : string;  //base64 编码
var base64 : TIdEncoderMIME;
    tmpBytes : TBytes;
begin
  base64 := TIdEncoderMIME.Create(nil);
  try
    base64.FillChar := '=';
    tmpBytes := TEncoding.UTF8.GetBytes(s);
    Result := base64.EncodeBytes(TIdBytes(tmpBytes));
  finally
    base64.Free;
  end;
end;

function Base64Decode(s : string) : string;  //base64 解码
var base64 : TIdDeCoderMIME;
    tmpBytes : TBytes;
begin
  Result := s;
  base64 := TIdDecoderMIME.Create(nil);
  try
    base64.FillChar := '=';
    tmpBytes := TBytes(base64.DecodeBytes(s));
    Result := TEncoding.UTF8.GetString(tmpBytes);
  finally
    base64.Free;
  end;
end;







 //以豆瓣ID号索引douban.data写入电影标题简介等资料
procedure Writenfo(var Did: string; var ohash: string);
var
  cnnamefile, covernamefile, Myxmlfilenamebak,DoubanData, Myxmlfilename, Myimgname, imgurl, tmpssur, filepath: string;
  tmpedata: TQJson;
  fileslist, tmpindexsr: TQJson;
  AXML, tmpxml: TQXMLNode;
  Action: TDownloadUrl;
  I: integer;
  Adata,Apicfanart:PMydown;
begin
     fileslist := TQJson.Create;
    tmpindexsr := TQJson.Create;
    tmpedata := TQJson.Create;
    AXML := TQXMLNode.Create;
    tmpxml := TQXML.Create;
     Action := TDownloadUrl.Create(form1);
  if not (TRegEx.IsMatch(Did, '.*[a-w]{1,2}.*', [roIgnoreCase]))  then
  begin
//     filepath := MyfileJson.ForcePath(ohash + '.filename').Value;

    filepath := Base64Decode(MyfileJson.ValueByPath (ohash + '.filename',''));

    Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;

    Myimgname := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + '.tbn';
    Myxmlfilename := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + '.nfo';


  // 下载海报并保存

         DoubanData:= ExtractFilePath(Application.ExeName) + '\databak\' +
   Did +'_douban.data';
   if tfile.Exists(DoubanData) then


    begin

       DoubanDataJson := TQJson.Create;
      DoubanDataJson.LoadFromFile(DoubanData);

      cnnamefile := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + DoubanDataJson.ForceName('title').ToString + '.nfo';
      //covernamefile := ExtractFilePath(filepath) + 'cover.jpg';
      covernamefile := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) +  '-poster.jpg';
      imgurl := DoubanDataJson.forcePath ('images.large').ToString;
      if imgurl <> '' then
      begin
            New(AData);

            AData.url := imgurl;
            AData.downfilename :=Myimgname;
            AData.movefilename :=covernamefile;
            Workers.Post(DoJobDown, TQJobExtData.Create(AData, DoFreeMydown), false, jdfFreeAsObject);
            New(APicfanart);
            APicfanart.url :=DoubanDataJson.ValueByPath  ('photos[0].image','');
            //APicfanart.downfilename := ExtractFilePath(filepath) + 'fanart.jpg';
            APicfanart.downfilename := ExtractFilePath(filepath) + tpath.GetFileNameWithoutExtension(filepath) + '-fanart.jpg';
            Workers.Post(DoJobDown, TQJobExtData.Create(APicfanart, DoFreeMydown), false, jdfFreeAsObject);
       end;
       //按kodi nfo 格式写入豆瓣电影或电视信息
      JsonWritenfo(tmpxml, DoubanDataJson, Did, ohash, Myxmlfilename);
                    //fileslist.SaveToFile(Myfilelistname,teUtf8,True,True);
   //                 DonbanData.SaveToFile(DoubanData,teUtf8,True,True);
  // DoubanDataJson.free;
   freeandnil(DoubanDataJson);
    end;
  end;
  tmpxml.Free;
   freeandnil(fileslist);
  freeandnil( tmpindexsr);
  freeandnil( tmpedata );
  freeandnil( AXML);
  freeandnil( tmpindexsr);
  freeandnil( Action);
end;




 //进程暂停
procedure PDelay(ms: Integer);
var
  FirstTickCount: longint;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
  until ((GetTickCount - FirstTickCount) >= Longint(ms));
end;


//获取文件大小
function GetFileSizes(AFileName: string): Int64;
var
  sr: TSearchRec;
  AHandle: Integer;
begin
  AHandle := FindFirst(AFileName, faAnyFile, sr);
  if AHandle = 0 then
  begin
    Result := sr.Size;
    FindClose(sr);
  end
  else
    Result := 0;
end;




 //查找豆瓣电影ID和片名等

function Getdoubanid(ohash: string;mysid: string = '' ;auto:string = '-no' ): TQJson;
var
  myMoviefile: PmoviezFile;
  Mysub: string;
  Action: TDownloadUrl;
  T, Speed: Cardinal;
  AFileSize: Int64;
  tmptestarr, tmptestarrb: TQJson;
  AList:TQJsonItemList;
  FJson: TQJson;
  Mysubtmptxt, Mysubtmp, urltxt: string;
  filepath: string;
  tmpidtxt, tmpidlist: tstrings;
  I:Integer;
label
  1;
begin
 //  DoubanDataJson := TQJson.Create;
 //  if tfile.Exists(DoubanData) then DoubanDataJson.LoadFromFile(DoubanData);
 new(myMoviefile);
  myMoviefile := GetMoviezfilesFromHash(ohash);
  Mysub := myMoviefile.oname;
     tmpidtxt := tstringlist.Create;
    tmpidlist := tstringlist.Create;
    Action := TDownloadUrl.Create(form1);
 //   Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;
    FJson := TQJson.Create;
    tmptestarr := TQJson.Create;
    AList:=TQJsonItemList.Create;
    tmptestarrb := TQJson.Create;
  if (trim(mysid) = '') and (TRegEx.IsMatch(mysid, '[a-w]+', [roIgnoreCase]) = false) then
  begin
    mysid := myMoviefile.doubanid;
    if TRegEx.IsMatch(getep(LowerCase(Mysub)), 's', [roIgnoreCase]) then
      Mysubtmp := trim(cuttext(LowerCase(Mysub), '-sep'))
    else
      Mysubtmp := trim(cuttext(LowerCase(Mysub)));

    Mysubtmptxt := cuttext(LowerCase(Mysub));


   // if TRegEx.IsMatch(mysid, '[a-z]+', [roIgnoreCase]) then  mysid := '';

    //检索本地nameid数据和公共差异数据中有无对应doubanid
    //AJson.ItemByName('Name',AList,True)
    PubnameIDDataJson.ItemByName(Mysubtmp,AList,false);
    if AList.Count >0 then
    begin
    tmpidlist.clear;
    tmptestarr.clear;
      for tmptestarr  in AList do
      begin
        if (trim(tmptestarr.Value) <> '') and Assigned(DoubanIDJson.ItemByName(tmptestarr.Value)) then
        begin
          tmptestarrb := DoubanIDJson.ItemByName(tmptestarr.Value);
          tmpidlist.Add(tmptestarrb.ValueByName('id', '') + ';' + tmptestarrb.ValueByName('title', '') + ';' + tmptestarrb.ValueByName('year', '') + ';' + tmptestarrb.ValueByName('original_title', ''));
        end;
      end;
      if auto='-yes' then
      begin
              tmpidtxt := SplitStrings(tmpidlist[0], ';');
        mysid := tmpidtxt[0];
        if (trim(mysid) <> '') AND (trim(Mysubtmp) <> '') then
          NameIDDataJson.ForceName(Mysubtmp).AsString := mysid
          else
         mysid := '' ;
      end
        else
        begin
          form1.RzLookupDialog1.List.Clear ;
      form1.RzLookupDialog1.List := tmpidlist;
      if form1.RzLookupDialog1.Execute then
      begin
        tmpidtxt := SplitStrings(form1.RzLookupDialog1.SelectedItem, ';');
        mysid := tmpidtxt[0];
        if (trim(mysid) <> '') AND (trim(Mysubtmp) <> '') then
          NameIDDataJson.ForceName(Mysubtmp).AsString := mysid;
      end
      else
      begin
        mysid := '';
      end;
        end;


    end;



   //此ItemByName函数用于在当前结点下查找指定名称的子结点，如果指不到，返回NIL/NULL。
   //如果要确保结点存在，用ForcePath来代替此函数。
   if Assigned(NameIDDataJson.ItemByName(Mysubtmp)) and (TRegEx.IsMatch(NameIDDataJson.ItemByName(Mysubtmp).Value, '[a-w]+', [roIgnoreCase]) = false) then
    begin
      mysid := NameIDDataJson.ItemByName(Mysubtmp).Value;
      Result := DoubanIDJson.Forcename(mysid).Clone;
    end
    else
    begin

      urltxt := Foptionjson.ValueByName('GetseatchDoubanUrl', 'https://api.douban.com/v2/movie/search?q=#&apikey=0a0a604697c5185a1e1f20d3c74f490e');
      urltxt := StringReplace(urltxt, '#', Mysubtmptxt, [rfReplaceAll, rfIgnoreCase]);
      Action.URL := TIdUri.URLEncode(urltxt);
      Action.Filename := ExtractFilePath(Application.ExeName) + '_url.html';
      try
        if Action.Execute then
        begin
          FJson.LoadFromFile(Action.Filename);

//查找所有可能的答案并显示选择对话框
          if fjson.IntByName('total', 0) > 1 then
          begin
            tmpidlist.clear;
            tmptestarr.clear;
            for tmptestarr in fjson.Forcename('subjects') do
            begin
              tmpidlist.Add(tmptestarr.ValueByName('id', '') + ';' + tmptestarr.ValueByName('title', '') + ';' + tmptestarr.ValueByName('year', '') + ';' + tmptestarr.ValueByName('original_title', ''));
              if trim(myMoviefile.year) = '' then
              begin
                if CompareStringsInPercent(Mysubtmptxt, LowerCase(trim(tmptestarr.ValueByName('original_title', '')))) > 0.9 then
                begin
                  mysid := tmptestarr.ValueByName('id', '');
                  break;
                end;

              end
              else if (myMoviefile.year = tmptestarr.ValueByName('year', '')) and (CompareStringsInPercent(Mysubtmptxt, LowerCase(trim(tmptestarr.ValueByName('original_title', '')))) > 0.9) then
              begin
                mysid := tmptestarr.ValueByName('id', '');
                break;
              end;

             {
      if Mysubtmptxt = LowerCase(trim(tmptestarr.ValueByName('original_title', ''))) then
              begin
              if myMoviefile.year ='' then
                begin
                mysid := tmptestarr.ValueByName('id', '');
                break;
                end
                else if (myMoviefile.year = tmptestarr.ValueByName('year', ''))  then
                begin
                mysid := tmptestarr.ValueByName('id', '');
                break;
                end;



              end;


               }
            end;
            if (mysid = '') AND (tmpidlist.Count >0) then
            begin

                  if auto='-yes' then
      begin
              tmpidtxt := SplitStrings(tmpidlist[0], ';');
        mysid := tmpidtxt[0];
        if (trim(mysid) <> '') AND (trim(Mysubtmp) <> '') then
          NameIDDataJson.ForceName(Mysubtmp).AsString := mysid
          else
          begin
         mysid := '' ;
         Result := nil;
          end;
      end
        else
        begin

            form1.RzLookupDialog1.List.Clear ;
              form1.RzLookupDialog1.List := tmpidlist;
              if form1.RzLookupDialog1.Execute then
              begin
                tmpidtxt := SplitStrings(form1.RzLookupDialog1.SelectedItem, ';');
                mysid := tmpidtxt[0];
              end
              else
              begin
                mysid := '';
                Result := nil;
              end;
        end;
            end;
  //   mysid:=fjson.ForcePath('subjects.[0].id').ToString ;
          end
          else if fjson.IntByName('total', 0) = 1 then
          begin
            mysid := FJson.ForcePath('subjects[0]').ValueByName('id', '');
          end
          else
            mysid := '';
          DeleteFile(Action.Filename);
        end;

      finally
       // Action.Free;
      end;
    end;
  end;

1:
  if (mysid <> '') and not (TRegEx.IsMatch(mysid, '[a-w]+', [roIgnoreCase])) then
  begin
    Result := Getdoubanall(mysid);
    WriteHashIDData(mysid, ohash);

    Writenfo(mysid, ohash);


  end
  else
  begin

    Result := nil;
  end;
 // FreeANDnil(DoubanDataJson) ;

    freeandnil(tmpidtxt);
  freeandnil( tmpidlist);
  freeandnil( Action );
  freeandnil( FJson);
  // freeandnil( tmptestarr);
  freeandnil( AList);
 //   freeandnil( tmptestarrb);
end;

//获取豆瓣ID后写入各数据文件中共4个
procedure WriteHashIDData(var mysid: string; var ohash: string);
var
  myMoviefile: PmoviezFile;
  Mysep, Mysub, Myosub, Mysubtmp, Mysubtmptxt, tts, cck: string;
begin
  // DoubanDataJson := TQJson.Create;
  // if tfile.Exists(DoubanData) then DoubanDataJson.LoadFromFile(DoubanData);
  if mysid <> '' then
  begin
    new(myMoviefile);
    myMoviefile := GetMoviezfilesFromHash(ohash);
    Mysub := myMoviefile.oname;
    Mysubtmp := myMoviefile.beename;
    Mysep := myMoviefile.sep;
//   mysid:= myMoviefile.doubanid;
{  if TRegEx.IsMatch(Mysep, 'e', [roIgnoreCase]) then
    Mysubtmp := trim(cuttext(LowerCase(Mysub), '-sep'))
  else
    Mysubtmp := trim(cuttext(LowerCase(Mysub)));
 }

    Mysubtmptxt := DoubanIDJson.ForcePath(mysid + '.title').Value;
    Myosub := DoubanIDJson.ForcePath(mysid + '.original_title').Value;
    if Mysep <> '' then
      HashDataJson.ForcePath(ohash + '.sep').AsString := Mysep;
   if trim(mysid)<>'' then HashDataJson.ForcePath(ohash + '.ID').AsString := mysid;
    //
   if (myMoviefile.filename)<> '' then  tts := TPath.GetFileNameWithoutExtension(myMoviefile.filename); {提取无扩展名的文件名}
   if (myMoviefile.path)<> '' then cck := TPath.GetDirectoryName(myMoviefile.path);            {提取路径}
//        bbm := TPath.GetExtension(TPath.GetFileName(tmptestarr.ForcePath('url').ToString)); {提取扩展名}
//        Action.Filename := ExtractFilePath(Application.ExeName) + tts + bbm;

    if SearchFiles(cck, tts + '*.ass') or SearchFiles(cck, tts + '.srt') then
      HashDataJson.ForcePath(ohash + '.srts').AsBoolean := true
    else
      HashDataJson.ForcePath(ohash + '.srts').AsBoolean := false;
    HashDataJson.SaveToFile(HashData, teUtf8, True, True);
   if (trim(LowerCase(Mysub)) <> '') then NameIDDataJson.Forcename(trim(LowerCase(Mysub))).AsString := mysid;
   if (trim(LowerCase(Myosub)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(Myosub))).AsString := mysid;
   if (trim(LowerCase(Mysubtmptxt)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(Mysubtmptxt))).AsString := mysid;
   if (trim(LowerCase(Mysubtmp)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(Mysubtmp))).AsString := mysid;
   if (trim(LowerCase(myMoviefile.cnname)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(myMoviefile.cnname))).AsString := mysid;
   if (trim(LowerCase(myMoviefile.cnoname)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(myMoviefile.cnoname))).AsString := mysid;
    NameIDDataJson.SaveToFile(NameIDData, teUtf8, False, True);  /////////////////////////
    IDHashDataJson.ForcePath(mysid + '.' + ohash).AsString := ohash;
    IDHashDataJson.SaveToFile(IDHashData, teUtf8, True, True);

  end;
 // FreeANDnil(DoubanDataJson) ;
end;

procedure GetFilenames(sPath, sFilename: string; AList: TStrings);
//功能描述:   列出sPath目录中(不含子目录)所有文件名符合sFilename规则的文件名
//入口参数:
//     sPath           -   目录路径
//     sFilename   -   文件名
//出口参数:
//     AList           -   sPath目录中所有符合的文件名被添加到了这一列表中
var
  SR: TSearchRec;
begin
  if FindFirst(sPath + sFilename, faReadOnly + faHidden + faSysFile + faArchive + faAnyFile, SR) = 0 then
  begin
    repeat
      AList.Add(sPath + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

//调用举例:   在ListBox1中列出   d:\aaa*.*
//GetFilenames   ( 'd:\ ',   'aaa*.* ',   ListBox1.Items);
//e.g.  SearchFiles('C:\', edtSearch.Text, Memo1.Lines);
function SearchFiles(const path, pattern: string; list: TStrings = nil): Boolean;
var
  filter: string;
  f: TSearchRec;
begin
 // list:=TStringList.Create; //建立List对象
  filter := IncludeTrailingPathDelimiter(path) + pattern;
  if Pos('*', filter) = 0 then
    filter := filter + '*';
  Result := FindFirst(filter, faAnyFile, f) = 0;
  if Result then
  begin
    repeat
      if list <> nil then
        list.Add(f.Name);
    until FindNext(f) <> 0;
    FindClose(f);
  end;

end;

function GetMoviezfilesFromHash(fhashs: string): PmoviezFile;
var
  myMoviefile: PmoviezFile;
  cnnamefile,fnames, tts, cck: string;
  AData: PMyComplexRecord;
begin
 //DoubanDataJson := TQJson.Create;
// if tfile.Exists(DoubanData) then DoubanDataJson.LoadFromFile(DoubanData);
New(myMoviefile);
//  MyFileJson.Clear;
//  MyFileJson.LoadFromFile(ExtractFilePath(Application.ExeName) + '_file.data');
 //if MyFileJson.Count >0 then fnames := Base64Decode(MyFileJson.ValueByPath(fhashs + '.filename','') )  else fnames := '报错';
 //if  MyFileJson.Exists('\'+fhashs + '\filename')   then
 if  MyFileJson.Exists(fhashs)   then
 begin
  fnames := MyFileJson.ValueByPath(fhashs + '.filename','') ;
    fnames := Base64Decode(fnames);
 end
  else
  fnames := '';
 {
if Assigned(MyFileJson.ItemByPath('\'+fhashs + '\filename'))  then
 begin
  fnames := MyFileJson.ValueByPath(fhashs + '.filename','') ;
    fnames := Base64Decode(fnames);
 end
  else
  fnames := ''; }
{  if MyFileJson.IndexOf(fhashs)>=0 then
 begin
   fnames := MyFileJson.ForceName(fhashs).ForcePath('filename').AsString;
 fnames := Base64Decode(fnames);
 end
 else
 fnames := '';  }
  if TFile.Exists(fnames) then
  begin
    myMoviefile.doubanid := '';
    if Assigned(HashDataJson.ItemByPath(fhashs + '.ID')) then
      myMoviefile.doubanid := HashDataJson.ItemByPath(fhashs + '.ID').Value;

    myMoviefile.srtYN := HashDataJson.BoolByPath(fhashs + '.srts', False);
    myMoviefile.filename := fnames;
    myMoviefile.fhash := fhashs;
    myMoviefile.fcreatime := inttostr(DateTimeToUnix(TFile.GetCreationTime(fnames)));
    myMoviefile.oname := TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames));
    myMoviefile.ext := Tpath.GetExtension(TPath.GetFileName(fnames));
    myMoviefile.path := ExtractFilePath(fnames);
    if myMoviefile.srtYN = False then
    begin
      tts := TPath.GetFileNameWithoutExtension(myMoviefile.filename); {提取无扩展名的文件名}
      cck := TPath.GetDirectoryName(myMoviefile.path);            {提取路径}
      if SearchFiles(cck, tts + '*.ass') or SearchFiles(cck, tts + '*.srt') then
        HashDataJson.ForcePath(myMoviefile.fhash + '.srts').AsBoolean := true
      else
        HashDataJson.ForcePath(myMoviefile.fhash + '.srts').AsBoolean := false;
    end;
    myMoviefile.srtYN := HashDataJson.BoolByPath(fhashs + '.srts', False);

    if myMoviefile.doubanid <> '' then
    begin
      myMoviefile.cnname := DoubanIDJson.ForcePath(myMoviefile.doubanid + '.title').ToString;
      myMoviefile.year := DoubanIDJson.ForcePath(myMoviefile.doubanid + '.year').ToString;
    end
    else
    begin
      myMoviefile.year := getyear(TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames)));

    end;

        if Assigned(HashDataJson.ItemByPath(fhashs + '.sep')) then
        begin
      myMoviefile.sep := HashDataJson.ItemByPath(fhashs + '.sep').Value;
   myMoviefile.beename := cuttext(TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames)))+ ' ' +myMoviefile.sep; //加上季集数
        end else
        begin
      myMoviefile.sep := getep(TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames)));
         myMoviefile.beename := cuttext(TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames)), '-sep'); //加上季集数
       end;
  // myMoviefile.beename := cuttext(TPath.GetFileNameWithoutExtension(TPath.GetFileName(fnames)));

//

    if Assigned(NameIDDataJson.ItemByName(trim(LowerCase(myMoviefile.beename)))) and (myMoviefile.doubanid = '') then
      myMoviefile.doubanid := NameIDDataJson.ItemByName(trim(LowerCase(myMoviefile.beename))).Value;
    if Assigned(NameIDDataJson.ItemByName(trim(LowerCase(myMoviefile.cnname)))) and (myMoviefile.doubanid = '') then
      myMoviefile.doubanid := NameIDDataJson.ItemByName(trim(LowerCase(myMoviefile.cnname))).Value;
    if Assigned(NameIDDataJson.ItemByName(trim(LowerCase(myMoviefile.oname)))) and (myMoviefile.doubanid = '') then
      myMoviefile.doubanid := NameIDDataJson.ItemByName(trim(LowerCase(myMoviefile.oname))).Value;

    if myMoviefile.doubanid <> '' then
    begin
      myMoviefile.cnoname := DoubanIDJson.ForcePath(myMoviefile.doubanid + '.original_title').Value;
      myMoviefile.cnname := DoubanIDJson.ForcePath(myMoviefile.doubanid + '.title').ToString;
      myMoviefile.year := DoubanIDJson.ForcePath(myMoviefile.doubanid + '.year').ToString;
      myMoviefile.countries := DoubanIDJson.ForcePath(myMoviefile.doubanid + '.countries').ToString;
      if not (Assigned(HashDataJson.ItemByPath(fhashs + '.ID'))) then
        HashDataJson.ForcePath(fhashs + '.ID').AsString := myMoviefile.doubanid;
      IDHashDataJson.ForcePath(myMoviefile.doubanid + '.' + fhashs).AsString := fhashs;
    if (trim(LowerCase(myMoviefile.oname)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(myMoviefile.oname))).AsString := myMoviefile.doubanid;
    if (trim(LowerCase(myMoviefile.beename)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(myMoviefile.beename))).AsString := myMoviefile.doubanid;
    if (trim(LowerCase(myMoviefile.cnoname)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(myMoviefile.cnoname))).AsString := myMoviefile.doubanid;
    if (trim(LowerCase(myMoviefile.cnname)) <> '') then  NameIDDataJson.Forcename(trim(LowerCase(myMoviefile.cnname))).AsString := myMoviefile.doubanid;
      cnnamefile := myMoviefile.path + myMoviefile.oname + myMoviefile.cnname + '.nfo';
           if not(tfile.Exists(cnnamefile)) then
    begin
      New(AData);
      AData.bId := myMoviefile.doubanid;
      AData.bhash := fhashs;
      Workers.Post(DoJobWritenfo, TQJobExtData.Create(AData, DoFreeMyComplexRecord), false, jdfFreeAsObject);
    end;
    end;



  if TRegEx.IsMatch(myMoviefile.doubanid, '[a-w]+', [roIgnoreCase]) then
    myMoviefile.doubanid := '';

  end;

 Result := myMoviefile;

end;

    //将若干个基本数据合并为最新数据   命名格式 Data.IDHashData Data.nmaeIDData Data.HashpropertiesData Data.DoubanData
procedure MyaddData;
var
  datafiles: Tstrings;
  pathfile: string;
  tmpjson: Tqjson;
begin


  datafiles := TStringList.Create;
  if TFile.Exists(Myfilename) and SearchFiles(ExtractFilePath(Application.ExeName), 'Data.*', datafiles) then
  begin
    for pathfile in datafiles do
    begin
      tmpjson := TQJson.Create;
      tmpjson.LoadFromFile(pathfile);
  {    if Tpath.GetExtension(pathfile) = '.DoubanData' then
      begin
         DoubanDataJson := TQJson.Create;
   if tfile.Exists(DoubanData) then DoubanDataJson.LoadFromFile(DoubanData,teUtf8);
      tmpjson := TQJson.Create;
      tmpjson.LoadFromFile(pathfile,teUtf8);
    DoubanDataJson.Merge(tmpjson, jmmIgnore);
       // FreeANDnil(tmpjson);
       tmpjson.Free ;
        DoubanDataJson.SaveToFile(DoubanData, teUtf8, True, True);
         FreeANDnil(DoubanDataJson) ;

        DeleteFile(pathfile);
      end;       }
      if Tpath.GetExtension(pathfile) = '.DoubanID' then
      begin
        DoubanIDJson.Merge(tmpjson, jmmIgnore);
        FreeANDnil(tmpjson);
        DoubanIDJson.SaveToFile(DoubanIDData, teUtf8, True, True);
        DeleteFile(pathfile);
      end;
      if Tpath.GetExtension(pathfile) = '.IDHashData' then
      begin
        IDHashDataJson.Merge(tmpjson, jmmIgnore);
        FreeANDnil(tmpjson);
        IDHashDataJson.SaveToFile(IDHashData, teUtf8, True, True);
        DeleteFile(pathfile);
      end;
      if Tpath.GetExtension(pathfile) = '.nameIDData' then
      begin
    //合并新数据中原数据没有的
        NameIDDataJson.Merge(tmpjson, jmmIgnore);
        NameIDDataJson.SaveToFile(NameIDData, teUtf8, True, True);
    //找出新数据包内余下没有合并进去的差异数据，包括原数据中差异部分
        tmpjson.Diff(NameIDDataJson);
    //把上述差异数据全部写入公共差异数据中供备选
        PubNameIDDataJson.Merge(tmpjson, jmmAppend);
        FreeANDnil(tmpjson);
        PubNameIDDataJson.SaveToFile(PubNameIDData, teUtf8, True, True);
        DeleteFile(pathfile);
      end;
      if Tpath.GetExtension(pathfile) = '.HashpropertiesData' then
      begin
        HashDataJson.Merge(tmpjson, jmmIgnore);
        FreeANDnil(tmpjson);
        HashDataJson.SaveToFile(HashData, teUtf8, True, True);
        DeleteFile(pathfile);
      end;

    end;

  end;

  datafiles.Free;
end;



   //基本数据初始化
procedure Myinitialize;
var
  Oldname, Newname,DoubanData: string;
  tmpjson,kkjson,ujson: TQJson;
begin
   // 初始化基本数据
   //设置option，豆瓣数据douban，本地文件数据file，片名与豆瓣ID对应数据nameid，文件名与片名对应数据nameStitle
  FOptionJson := TQJson.Create;
  IDHashDataJson := TQJson.Create;
  MyfileJson := TQJson.Create;
  DoubanDataJson := TQJson.Create;
    DoubanIDJson := TQJson.Create;
  NameIDDataJson := TQJson.Create;
  HashDataJson := TQJson.Create;
  RssDataJson := TQJson.Create;
  PubNameIDDataJson := TQJson.Create;
  ujson := TQJson.Create;
  kkjson := TQJson.Create;
  TtmpFilmData := TQJson.Create;
   //
  if not FileExists(ExtractFilePath(Application.ExeName) + '\databak\') then
//if not DirectoryExists(Edit1.Text) then 判断目录是否存在
 // try
  begin
    CreateDir(ExtractFilePath(Application.ExeName) + '\databak\');
    //ForceDirectories(Edit1.Text);   创建目录
  end;
   //CC RSS表，以标题析后名为主索引，包含备注 值
  RssData := ExtractFilePath(Application.ExeName) + '_Rss.data';
 // if tfile.Exists(RssData) then RssDataJson.LoadFromFile(RssData);

  //BB表，以Hash为主索引，包含集数、有无字幕、豆瓣ID三个属性与值
  //_nameStitle.data
  Oldname := ExtractFilePath(Application.ExeName) + '_nameStitle.data';
  HashData := ExtractFilePath(Application.ExeName) + '_Hash_properties.data';
  if tfile.Exists(Oldname) and not (tfile.Exists(HashData)) then
    RenameFile(Oldname, HashData);

  if tfile.Exists(HashData) then
    HashDataJson.LoadFromFile(HashData);
 //A表，豆瓣ID为主索引，写入豆瓣所有数据
  DoubanData := ExtractFilePath(Application.ExeName) + '_douban.data';  //
//  if tfile.Exists(DoubanData) then DoubanDataJson.LoadFromFile(DoubanData);
    //Aaaa表，豆瓣ID为主索引，写入豆瓣最简数据
  DoubanIDData := ExtractFilePath(Application.ExeName) + '_doubanID.data';  //
  if tfile.Exists(DoubanIDData) then  DoubanIDJson.LoadFromFile(DoubanIDData)  ;

   if tfile.Exists(DoubanData) then
   begin
    DoubanDataJson.LoadFromFile(DoubanData);
  for  ujson  in DoubanDataJson do
      begin
  //         DoubanIDJson.Forcename(FJson.Forcename('id').Value).Assign(Getidc(FJson));
  if Assigned(Getidc(ujson)) then
  begin
    kkjson:= Getidc(ujson) ;
   DoubanIDJson.Forcename(kkjson.Forcename('id').Value).Assign(kkjson);
   ujson.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\' +
   ujson.Forcename('id').Value +'_douban.data', teUtf8, True, True);
  end;

      end;
       if not(tfile.Exists(DoubanIDData)) then     DoubanIDJson.SaveToFile(DoubanIDData, teUtf8, True, True);
    FreeAndNil(DoubanDataJson);
    tfile.Delete (DoubanData);
   end;

 //B表，以本地硬盘文件 HASH为主索引,对应所在全路径，hash:path
  Myfilename := ExtractFilePath(Application.ExeName) + '_file.data';
  if tfile.Exists(Myfilename) then
    MyfileJson.LoadFromFile(Myfilename);

  Myoptionfilename := ExtractFilePath(Application.ExeName) + '_option.data';
  if TFile.Exists(Myoptionfilename) then
    FOptionJson.LoadFromFile(Myoptionfilename)
  else
  begin
    tmpjson := TQJson.Create;

    tmpjson.AddVariant ('search-url', 'http://www.subhd.com/search/');
    tmpjson.AddVariant('downsub-url', 'http://subhd.com/ajax/down_ajax');
    tmpjson.AddVariant('Accept', 'application/json, text/javascript, */*; q=0.01');
    tmpjson.AddVariant('AcceptEncoding', 'gzip, deflate');
    tmpjson.AddVariant('ContentType', 'application/x-www-form-urlencoded; charset=UTF-8');
    tmpjson.AddVariant('UserAgent', 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0');
    FOptionJson.AddVariant('MovieHere', '');
   //  const getUrl = 'https://api.douban.com/v2/movie/search?q=#&count=1';
   //  const ArrayExtt: array[0..7] of string =('.mkv', '.mp4', '.ts','.avi','.mpg','.mpeg', '.tp', '.rmvb');
    FOptionJson.AddVariant('Movie-search-mini-size-MB', 128);
//   FOptionJson.AddVariant('Refresh-time',0);   {在扫描时自行添加}
    FOptionJson.AddVariant('SubLanSort', '双语;简体;chs;cht;eng');
    FOptionJson.AddVariant('SubTeamSort', 'yyets;衣柜;深影;伊甸园;猪猪');
    FOptionJson.AddVariant('deltxttitle', 'uk|tsks|1080p|hbo|bbc|tvn|Marvels|大河ドラマ');
    FOptionJson.AddVariant('Subonlycheck', 0);
    FOptionJson.AddVariant('PathFindTime', 1);
   // FOptionJson.SaveToFile(Myoptionfilename, teUtf8, True, True);
    FOptionJson.AddVariant('InfFindTime', 1);
    FOptionJson.AddVariant('SubFindTime', 1);
    FOptionJson.AddVariant('GetseatchDoubanUrl', 'https://api.douban.com/v2/movie/search?q=#');
    FOptionJson.AddVariant('GetseatchshooterUrl', 'https://api.assrt.net/v1/sub/search?token=7ycnKK0e70S4lSUIkaiH9je16sLSYek6&q=#&cnt=15&pos=0');
    FOptionJson.AddVariant('Movie-ext', '.mkv;.mp4;.ts;.avi;.mpg;.mpeg;.tp;.rmvb;.mov');
    FOptionJson.add('subhd', tmpjson);

    // FreeAndNil(tmpjson);
 //   FOptionJson.SaveToFile(Myoptionfilename, teUtf8, True, True);
  //  FOptionJson.LoadFromFile(ExtractFilePath(Application.ExeName) + '_option.data');
  end;
  //AA表，以豆瓣ID为主索引，对应Hash，ID：Hash
  //_pubID.data
  IDHashData := ExtractFilePath(Application.ExeName) + '_ID_Hash.data';
  if TFile.Exists(IDHashData) then
    IDHashDataJson.LoadFromFile(IDHashData);
 //C表，快速索引，标题析后名 ，文件名，豆瓣剧名，对应豆瓣ID，一次写入三个以便快速搜索 name:ID
 //_nameid.data
  Oldname := ExtractFilePath(Application.ExeName) + '_nameid.data';
  NameIDData := ExtractFilePath(Application.ExeName) + '_Name_ID.data';
  if tfile.Exists(Oldname) and not (tfile.Exists(NameIDData)) then
    RenameFile(Oldname, NameIDData);
  if tfile.Exists(NameIDData) then
    NameIDDataJson.LoadFromFile(NameIDData);
  PubNameIDData := ExtractFilePath(Application.ExeName) + '_Pub_Name_ID.data';
  if tfile.Exists(PubNameIDData) then
    PubNameIDDataJson.LoadFromFile(PubNameIDData);

    FreeAndNil(ujson);
    FreeAndNil(kkjson);


end;


    //基本数据保存为数据文件
procedure MySaveData;
var
  Achild: Tqjson;
begin


   // 基本数据保存为数据文件
   //设置option，豆瓣数据douban，本地文件数据file，片名与豆瓣ID对应数据nameid，文件名与片名对应数据nameStitle
   //Data.IDHashData Data.nmaeIDData Data.HashpropertiesData   ExtractFilePath(Application.ExeName)
 { if Assigned(RssDataJson) then
  begin
    if RssDataJson.HasChild('', Achild) then
      RssDataJson.ItemByName('').Delete;
    RssDataJson.SaveToFile(RssData, teUtf8, True, True);
  end; }
  if HashDataJson.Count >0 then
  begin
    if HashDataJson.HasChild('', Achild) then
      HashDataJson.ItemByName('').Delete;
    HashDataJson.SaveToFile(HashData, teUtf8, True, True);
    HashDataJson.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\Data.HashpropertiesData', teUtf8, True, True);
  end;
  // FreeAndNil(HashDataJson);
 { if Assigned(DoubanDataJson) then
  begin
    if DoubanDataJson.HasChild('', Achild) then
      DoubanDataJson.ItemByName('').Delete;
    DoubanDataJson.SaveToFile(DoubanData, teUtf8, True, True);
    DoubanDataJson.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\Data.DoubanData', teUtf8, True, True);
  end;
   FreeAndNil(DoubanDataJson); }
  if DoubanIDJson.Count >0 then
  begin
    if DoubanIDJson.HasChild('', Achild) then
      DoubanIDJson.ItemByName('').Delete;
    DoubanIDJson.SaveToFile(DoubanIDData, teUtf8, True, True);
    DoubanIDJson.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\Data.DoubanID', teUtf8, True, True);
  end;
    if FOptionJson.Count >0 then
  begin
   // if FOptionJson.HasChild('', Achild) then FOptionJson.ItemByName('').Delete;
    FOptionJson.SaveToFile(Myoptionfilename, teUtf8, True, True);
  end;
 //   FreeAndNil(FOptionJson);
  if IDHashDataJson.Count >0 then
  begin
    if IDHashDataJson.HasChild('', Achild) then
      IDHashDataJson.ItemByName('').Delete;
    IDHashDataJson.SaveToFile(IDHashData, teUtf8, True, True);
    IDHashDataJson.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\Data.IDHashData', teUtf8, True, True);
  end;
 //  FreeAndNil(IDHashDataJson);
  if NameIDDataJson.Count >0 then
  begin
    if NameIDDataJson.HasChild('', Achild) then
      NameIDDataJson.ItemByName('').Delete;
    NameIDDataJson.SaveToFile(NameIDData, teUtf8, True, True);
    NameIDDataJson.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\Data.nameIDData', teUtf8, True, True);
  end;
 //  FreeAndNil(NameIDDataJson);
  //PubNameIDDataJson
  if PubNameIDDataJson.Count >0 then
  begin
    PubNameIDDataJson.SaveToFile(PubNameIDData, teUtf8, True, True);
  end;
  if MyfileJson.Count >0 then
  begin
  //  if MyfileJson.HasChild('', Achild) then
  //   MyfileJson.ItemByName('').Delete;
  //  MyfileJson.SaveToFile(Myfilename, teUtf8, True,True );
  end;
 //FreeAndNil(MyfileJson) ;


end;


  //显示电影
procedure Myview;

var
  A: array of string;
  epnum, fyear, fid, fname, cname, oname, ftime, fhash, Myfilelistname: string;
  str: TQJson;
  item: TListItem;
  i: Integer;
  myMoviefile: PmoviezFile;
   AData:PMyDown;
begin
  str := TQJson.Create;
  form1.ListView1.Items.Clear;
  SetLength(A,7); //分配6个元素位置: 0-6
  for str in MyfileJson do
  begin
    fhash := str.Name;
    new(myMoviefile);
    myMoviefile := GetMoviezfilesFromHash(fhash);
    fname := myMoviefile.filename;
    fid := myMoviefile.doubanid;


    if TFile.Exists(fname) then
    begin
      oname := myMoviefile.beename;
      if myMoviefile.beename <> myMoviefile.cnoname then
        oname := oname + '(' + myMoviefile.cnoname + ')';

      if myMoviefile.srtYN then
        oname := oname + '(有字幕)';

      fyear := myMoviefile.year;
 //     fyear := getyear(TPath.GetFileNameWithoutExtension(TPath.GetFileName(fname)));


      cname := myMoviefile.cnname + myMoviefile.countries;

      epnum := myMoviefile.sep;

      ftime := myMoviefile.fcreatime;
 //     for i := Low(A) to High(A) do
      //给每个元素赋值
      begin
    A[0] := oname;
        A[1] := fyear;
            A[2] := epnum;
                A[3] := fname;
                    A[4] := fid;
                        A[5] := ftime;
                            A[6] := fhash;
      end;

     // A := (oname, fyear, epnum, fname, fid, ftime, fhash);
      item := form1.ListView1.Items.Add;
      item.Caption := cname;
      for i := 0 to high(A) do
      begin
        item.SubItems.Add(A[i]);
      end;
     //
    end;
    cname := '';
    oname := '';
    fyear := '';
    epnum := '';
    fname := '';
    fid := '';
    ftime := '';
    fhash := '';
  end;
//  form1.Button3.Caption:=inttostr(form1.ListView1.Items.Count);
  form1.StatusBar1.Panels[0].Text := '导入' + inttostr(form1.ListView1.Items.Count) + '个';
  Form1.ListView1.CustomSort(@CustomSortProc, 6);

//自动更新豆瓣电影信息，受豆瓣API并发查询时间限制
{
        for i := 0 to Form1.ListView1.Items.Count-1 do
      begin


     if form1.ListView1.Items.Item[i].SubItems.strings[4]='' then
  begin
      New(AData);
      AData.sid:=i;
      AData.sauto:='-yes';
      Workers.Post(DoJobGetdoubanid, TQJobExtData.Create(AData, DoFreeMydown), false, jdfFreeAsObject);
  end;
   end;
 }
  m_bSort := not m_bSort;
  FreeAndNil(str);

end;



 //获取指定目录及其子目录下的文件
procedure Mysearchfile;
var
  files: TStringDynArray;
  hashtt, rrtt, constr, path, str, ssut, Exttxt, Mylistname: string;
  tmprrr, Moviepathlist: TStrings;
  Myfilelist, sortlist: TStringlist;
  i, ii, sl, ftime: Integer;
  oldrefreshtime, minisize: int64;
begin
  Moviepathlist := TStrings.Create;
  Myfilelist := TStringList.Create;
  sortlist := TStringList.Create;

  ii := 0;
  sl := 0;

  constr := FOptionJson.ValueByName('MovieHere', '');
  minisize := FOptionJson.IntByName('Movie-search-mini-size-MB', 128) * 1024 * 1024;
  Exttxt := Foptionjson.ValueByName('Movie-ext', '.mkv;.mp4;.ts;.avi;.mpg;.mpeg;.tp;.rmvb;.mov');
 // oldrefreshtime := FOptionJson.ValueByName ('Refresh-time.' + path,20000000) - 10000000;
  if constr = '' then
    constr := 'd:\movie\;';
  StringReplace(constr, '\\', '\', [rfReplaceAll, rfIgnoreCase]);

  Moviepathlist := SplitStrings(constr, ';');

  try
  MyfileJson.Clear;
    for i := 0 to Moviepathlist.Count - 1 do
    begin
      path := Moviepathlist[i];
      if TDirectory.Exists(path) then
      begin
        files := TDirectory.GetFiles(path, '*.*', TSearchOption.soAllDirectories);
        oldrefreshtime := FOptionJson.IntByName ('Refresh-time.' + path,20000000) - 10000000;
        FOptionJson.Forcename('Refresh-time.' + path).AsInt64 := DateTimeToUnix(Now);
        for str in files do
        begin
          ssut := TPath.GetExtension(TPath.GetFileName(str));

          if (ansiContainsText(Exttxt, ssut) = True) and (GetFileSizes(str) >= minisize) and (DateTimeToUnix(TFile.GetCreationTime(str)) >= oldrefreshtime) then
          begin

            hashtt := CSVhash(str);
 //          if (hashtt<>'') then MyFileJson.ForcePath(hashtt + '.filename').AsString := Base64Encode(str);
           if (hashtt<>'') then MyFileJson.ForcePath(hashtt + '.filename').AsString := Base64Encode(DecodeUtf8Str(UTF8String(str)));

            sl := ii + 1;

            ii := ii + 1;

          end;
        end;

      end;

    end;

    MyFileJson.SaveToFile(Myfilename, teUtf8, True, True);
   // Myinitialize;

    Moviepathlist.Free;
    Myfilelist.Free;
    sortlist.Free;

  except
    MyfileJson.Clear;
    if tfile.Exists(Myfilename) then     MyfileJson.LoadFromFile(Myfilename);
  //  MyFileJson.SaveToFile(Myfilename, teUtf8, True, True);

  end;

end;

 function DecodeUtf8Str(const S: UTF8String): String;
var lenSrc, lenDst  : Integer;
begin
  lenSrc  := Length(S);
  if(lenSrc=0)then Exit;
  lenDst  := MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, nil, 0);
  SetLength(Result, lenDst);
  MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, Pointer(Result), lenDst);
end;

//取最接近判断条件的字幕
function GetSubResult(MytmpSublist: TQjson; sublang: string; subteam: string): string;
var
  I, Inum: Integer;
  tmptestarr: TQjson;
  tmpidlist: tstringlist;
  ss: string;
  AInt: array of Integer;
begin
  tmpidlist := tstringlist.Create;
  I := 0;
  for tmptestarr in MytmpSublist do
  begin
    ss := tmptestarr.ValueByName('zu', '');
    ss := TRegEx.Replace(ss, '字幕组', '');
    Inum := Matchnum(tmptestarr.ValueByName('clang', ''), sublang) + Matchnum(ss, subteam);
    SetLength(AInt, I + 1);
    tmpidlist.Add(tmptestarr.ValueByName('cherf', ''));
    AInt[I] := Inum;
    I := I + 1;
{ tmpidlist.Add(tmptestarr.ValueByName ('cherf','') +';' + tmptestarr.ValueByName ('cname','')
 +';' + tmptestarr.ValueByName ('ctitle','') +';' + tmptestarr.ValueByName ('zu','')+';' + tmptestarr.ValueByName ('clang',''));
 }
  end;
  I := MultiMaxnum(AInt);

    //  try
  Result := tmpidlist[I];
    //  except
    //  Result := MytmpSublist.ValueByPath('[0].cherf');
    //  end;
    FreeAndNil(tmpidlist);
    end;


function MultiMaxnum(AInt: array of Integer): Integer;
var
  I, RR: Integer;
begin
  if Length(AInt) = 0 then
    Result := 0
  else
  begin
    RR := AInt[0];
    for I := 0 to High(AInt) do
      if RR < AInt[i] then
        RR := AInt[I];
    for I := 0 to High(AInt) do
      if AInt[I] = RR then
        Result := I;
  end;
end;

function Matchnum(ss: string; subteam: string): integer;
var
  i: integer;
  sse: string;
begin
  sse := lowercase(trim(ss) + ';');
  if TRegEx.IsMatch(subteam, sse) then
    Result := 1000 div (pos(sse, subteam) + 1)
  else
    Result := 0;
end;



 //排序
function my_cmp(Item1, Item2: Pointer): Integer;
var
  nValue1, nValue2: Integer;
begin
  // 从大到小排列
  nValue1 := Integer(Item1);
  nValue2 := Integer(Item2);
  if nValue1 > nValue2 then
    Result := 1
  else if nValue1 < nValue2 then
    Result := -1
  else
    Result := 0;

end;



 //排序整理
function Mysort(tempqjson: TQjson): TQjson;
type
  TA = array of Integer;
var
  A: TA;
var
  tmpresult, ssv: TQjson;
begin
  tmpresult := TQjson.Create;
  ssv := TQjson.Create;
  A := TA.Create(1, 2, 3, 4);
  for ssv in tempqjson do
  begin
    tmpresult.ForcePath(ssv.ValueByName('csvhash', '') + '.filename').asstring := ssv.ValueByName('name', '');
    if IDHashDataJson.ForcePath(ssv.ValueByName('csvhash', '') + '.id').IsArray = False then
      ;
//IDHashDataJson.ForcePath(ssv.ValueByName('csvhash','')).AddArray('id');
  end;
  IDHashData := ExtractFilePath(Application.ExeName) + '_pubID.data';
  IDHashDataJson.SaveToFile(IDHashData, teUtf8, True, True);
  result := tmpresult;
//  tmpresult.free;
 FreeAndNil(tmpresult);
  FreeAndNil(ssv);
   FreeAndNil(A);
end;

 //取剧集名
function getep(pptext: string; eps: string = ''): string;
const
  pattern = '.*\.([P][0-9]{1,3})\..*|.*\.([E][P][0-9]{1,3})\..*|.*\.([S][0-9]{1,2})\..*|.*\.([E][0-9]{1,3})$|.*\.([E][0-9]{1,3})\..*|.*\.([S][0-9]{1,2}[E][0-9]{1,2})\..*|.*\.([S][0-9]{1,2}[E][0-9]{1,2}[E][0-9]{1,2})\..*';
var
  xxxpattern, oo: string;
begin
  oo := trim(cuttext(pptext, ''));
//    oo := TRegEx.Replace(pptext, '\[(.*?)\]', '.');
  xxxpattern := '.*?([a-z]{3,4}-[0-9]{2,3}).*';
  if TRegEx.IsMatch(pptext, xxxpattern, [roIgnoreCase]) then
  begin
    pptext := TRegEx.Replace(pptext, '　| ', '.');
    result := TRegEx.Replace(pptext, xxxpattern, '$1', [roIgnoreCase]);
    if (length(result) < 10) and (trim(result) <> oo) then
      result := trim(result)
    else
      result := '';
    exit;
  end;

  pptext := trim(pptext);
  pptext := TRegEx.Replace(pptext, '_', '.');
  pptext := TRegEx.Replace(pptext, '　| ', '.') + '.';
  pptext := TRegEx.Replace(pptext, '\.\.', '.');

  pptext := TRegEx.Replace(pptext, '\(|\)|\[|\]', '.');
  pptext := TRegEx.Replace(pptext, '\.part\.([0-9]{1,2})\..*', '.E$1.', [roIgnoreCase]);
  pptext := TRegEx.Replace(pptext, '([E][0-9]{1,2})-([E][0-9]{1,2})', '$1$2', [roIgnoreCase]);
  pptext := TRegEx.Replace(pptext, '第([0-9]{1,2})集.*', '.E$1.');
  pptext := TRegEx.Replace(pptext, '第([0-9]{1,2})回.*', '.E$1.');
  pptext := TRegEx.Replace(pptext, '第([0-9]{1,2})話.*', '.E$1.');
  pptext := TRegEx.Replace(pptext, '\(.*?\).*', '');
  pptext := TRegEx.Replace(pptext, '-', '.');
//pptext:=TRegEx.Replace(pptext, '「[^\x00-\xff]+」.*', '');
  pptext := TRegEx.Replace(pptext, '「(.*?)」', '');
  if TRegEx.ISMatch(pptext, pattern, [roIgnoreCase]) then
  begin
    pptext := TRegEx.Replace(pptext, pattern, '$1$2$3$4$5$6', [roIgnoreCase]);
  end
  else
  begin
    pptext := TRegEx.Replace(pptext, '.*\.([0-9]{2})\..*', '.E$1.');
  end;
  if (length(pptext) < 10) and (trim(pptext) <> oo) then
    result := trim(pptext)
  else
    result := '';

  if Result <> '' then
  begin
    Result := numtosep(Result);
    if eps = 'eps' then
    begin
      Result := TRegEx.Replace(Result, '[s]{0,1}[0-9]{0,3}[e][p]{0,1}([0-9]{0,3})', '$1', [roIgnoreCase]);
      Result := '第' + IntToStr(StrToIntDef(Result, 1)) + '集';
    end else if  eps = 'cn' then
     begin
      Result := TRegEx.Replace(Result, '[s]{0,1}[0-9]{0,3}[e][p]{0,1}([0-9]{0,3})', '$1', [roIgnoreCase]);
      Result := '第' + numcn(StrToIntDef(Result, 1)) + '集';
    end;
  end;
end;

  //从可能不规范的集数中提取数字转成标准的S01E03
function numtosep(pptext: string): string;
var
  pattern: string;
  matchs: TMatchCollection;
begin
  Result := '';
  pattern := '(?<name1>[0-9]+)'; //命名小括号为组，与  roExplicitCapture配套，只取有命名的组的值
  matchs := TRegEx.Matches(pptext, pattern, [roExplicitCapture]);
  if matchs.Count = 2 then
    Result := 'S' + matchs.Item[0].Value + 'E' + matchs.Item[1].Value;
  if matchs.Count = 1 then
    Result := 'E' + matchs.Item[0].Value;
  if Result = '' then
    Result := pptext;

end;


 //数字转中文
function numcn(ii: integer): string;
const
  cnnumtxt: widestring = '一二三四五六七八九十';
var
  rr, ss: integer;
begin
  if ii <= 10 then
    result := cnnumtxt[ii]
  else
  begin
    rr := ii mod 10;
    ss := ii div 10;
    if ss > 1 then
      result := cnnumtxt[ss] + '十' + cnnumtxt[rr]
    else
      result := '十' + cnnumtxt[rr];
  end;

end;

{ type TmoviezFile = record
  filename  :string;   //      原始文件名
  path     :string;   //      原始文件路径
  cnname :string;   //      电影、剧名
  sep  :string;      //        季集
  year :string;      //         年份
  fcreatime:string;      //         创建时间
  doubanid:string;      //         豆瓣ID号
  fhash:string;      //         原始文件指纹
  srtYN :integer;      //         字幕有无
  ver  :string;           //  版本WEB-DL
  others:string; //      备注
  encoder:string;  //        小组
  resolution :string;//          分辨率1080P
  videoBite:string;    //                   编码H264
}
  //从hash找文件各属性






 //取标题名
function cuttext(pptext: string; addex: string = ''): string;
var
  xxxpattern, ortxt, tmpstxt, deltxt, patternb: string; //第几季
  iin: integer;
  matchs: TMatchCollection;
  match: tmatch;
const
  pattern = '\.[0-9]{4,6}\..*|\.[E][P][0-9]{1,2}\..*|\.[S][0-9]{1,2}\..*|\.[E][0-9]{1,3}\..*|\.[S][0-9]{1,2}[E][0-9]{1,2}\..*|\.[S][0-9]{1,2}[E][0-9]{1,2}[E][0-9]{1,2}\..*';
begin
  ortxt := pptext;
  xxxpattern := '.*?([a-z]{3,4}-[0-9]{2,3}).*';
  if TRegEx.IsMatch(pptext, xxxpattern, [roIgnoreCase]) then
  begin
    result := TRegEx.Replace(pptext, xxxpattern, '$1', [roIgnoreCase]);
    exit;
  end;
  pptext := TRegEx.Replace(pptext, ' ', '.');
  pptext := TRegEx.Replace(pptext, '_', '.');
  if TRegEx.ISMatch(pptext, '\.([S][0-9]{1,2})[E][0-9]{1,3}\.', [roIgnoreCase]) then
  begin
    tmpstxt := TRegEx.Match(pptext, '[S][0-9]{1,2}', [roIgnoreCase]).Value;
    iin := StrToIntDef(copy(tmpstxt, 2, length(tmpstxt)), 1);
    tmpstxt := '第' + numcn(iin) + '季';
  end
  else
    tmpstxt := '';
    //[TSKS][2017][Goblin][E007-E008(720P)][KO_CN]  [TSKS][Goblin][E013(720P)][KO_CN]
  if TRegEx.IsMatch(ortxt, 'TSKS', [roIgnoreCase]) then
  begin
    pptext := TRegEx.Replace(ortxt, '\[[0-9]{4}\]', '');
    pptext := TRegEx.Replace(ortxt, 'E[0-9]{1,3}.*', '', [roIgnoreCase]);
  end;
 // pptext :=TRegEx.Replace(ortxt, '\[[0-9]{4}\]', '') + TRegEx.Replace(pptext, '.*\[([0-9]{4})\].*', '$1.');
 //  pptext :=numtosep(pptext);
  pptext := TRegEx.Replace(pptext, '\((.*?)\)', '');
    //把不需要的符号换成.
  pptext := TRegEx.Replace(pptext, '\(|\)|\[|\]|,', '.');
  deltxt := FOptionJson.ValueByName('deltxttitle', 'uk|tsks|1080p|hbo|bbc|tvn|Marvels|大河ドラマ');
  pptext := TRegEx.Replace(pptext, '\.(' + deltxt + ')\.', '.', [roIgnoreCase]); //不区分大小写
  pptext := TRegEx.Replace(pptext, '\.\.', '.');
  pptext := TRegEx.Replace(pptext, '^\.', '');
  pptext := TRegEx.Replace(pptext, '\.WEB-DL\..*', '.', [roIgnoreCase]);
  pptext := TRegEx.Replace(pptext, '\.part\.([0-9]{1,2})\.', '.e$1.', [roIgnoreCase]);
  pptext := TRegEx.Replace(pptext, '第([0-9]{1,2})回.*', '.e$1.');
  pptext := TRegEx.Replace(pptext, '第([0-9]{1,2})話.*', '.e$1.');
  pptext := TRegEx.Replace(pptext, '第([0-9]{1,2})集.*', '.e$1.');
  pptext := TRegEx.Replace(pptext, '\(.*?\)', '');
//pptext:=TRegEx.Replace(pptext, '「[^\x00-\xff]+」.*', '');
//【Classic字幕组】
  pptext := TRegEx.Replace(pptext, '★(.*?)★', '');
    pptext := TRegEx.Replace(pptext, '【(.*?)】', '');
  pptext := TRegEx.Replace(pptext, '「(.*?)」', '$1.');
  pptext := TRegEx.Replace(pptext, '\[(.*?)\]', '$1.');
  //把年份或集数后面的文字全部去除
  pptext := TRegEx.Replace(pptext, pattern, '', [roIgnoreCase]); //不区分大小写
//-sep加上季集数
  if addex = '-sep' then
    result := trim(TRegEx.Replace(pptext, '\.', ' ') + ' ' + tmpstxt)
  else
    result := trim(TRegEx.Replace(pptext, '\.', ' '));
  if Result = '' then
    result := ortxt;

end;


 //取标题里的年份
function getyear(pptext: string): string;
const
  pattern = '.*?\.([0-9]{4})\..*';
var
  oo: string;
begin
  pptext := TRegEx.Replace(pptext, ' ', '.');
  oo := pptext;
  oo := TRegEx.Replace(pptext, pattern, '$1', [roIgnoreCase]); //不区分大小写
  if oo = pptext then
    result := ''
  else
    result := oo;

end;

 //取RSS副标题里的备注[]中的内容
function getstitle(pptext: string): Boolean;
const
  pattern = '\[[^[]+\]';
var
  oo, pp: string;
  matchs: TMatchCollection;
  match: TMatch;
//  bbx: tstringlist;
  ii: integer;
begin
//]]

  ii := 0;

  oo := trim(TRegEx.Replace(pptext, pattern, '', [roIgnoreCase])); //不区分大小写
  oo := TRegEx.replace(oo, '\/|\[|\]', '', [roIgnoreCase]);
  if oo <> '' then
  begin
    oo := lowercase(cuttext(oo, '-sep') + ' ' + getep(oo));
    oo := TRegEx.replace(oo, '\/|\[|\]', '', [roIgnoreCase]);
  end
  else
  begin
    matchs := TRegEx.Matches(pptext, pattern);
    for match in matchs do
    begin
      if ii = 1 then
      begin
        oo := match.Value;
        oo := TRegEx.replace(oo, '\/|\[|\]', '', [roIgnoreCase]);
        oo := lowercase(cuttext(oo, '-sep') + ' ' + getep(oo));
      end;
 // pp:=pp + match.Value;
      ii := ii + 1;
    end;
  end;
{if pp<>'' then pp := TRegEx.replace(pp, '\[|\]',' ',[roIgnoreCase])
else}
  pp := TRegEx.replace(pptext, '\/|\[|\]', ' ', [roIgnoreCase]);
  pp := TRegEx.replace(trim(pp), ' ', '.', [roIgnoreCase]);

  if trim(oo) <> '' then
  begin
    RssDataJson.ForceName(trim(oo)).Value := trim(pp);
    Result := True;
  end
  else
    Result := False;

end;





// 标准快速排序
procedure QuickSortStd(var abc: array of Integer);

  procedure QSS(var abc: array of Integer; aFirst: Integer; aLast: Integer);
  var
    L, R: Integer;
    Pivot: Integer;
    Temp: Integer;
  begin
    while (aFirst < aLast) do
    begin
      Pivot := abc[(aFirst + aLast) div 2];
      L := pred(aFirst);
      R := succ(aLast);
      while true do
      begin
        repeat
          dec(R);
        until (abc[R] <= Pivot);

        repeat
          inc(L);
        until (abc[L] >= Pivot);

        if (L >= R) then
          Break;

        Temp := abc[L];
        abc[L] := abc[R];
        abc[R] := Temp;
      end;
      if (aFirst < R) then
        QSS(abc, aFirst, R);
      aFirst := succ(R);
    end;
  end;

begin
  QSS(abc, 0, High(abc));
end;

procedure TForm1.findFileButtonClick(Sender: TObject);
begin
  Workers.at(DoJobFindPath, 1 * qworker.Q1Second, qworker.Q1Hour, nil, False);
//  TThread.CreateAnonymousThread(Mysearchfile).Start; //!!!
end;

procedure TForm1.addRssButtonClick(Sender: TObject);
begin
  if (form1.rssUrlEdit.Text <> '') and (form1.rssNameEdit.Text <> '') then
  begin
 //
    if (TRegEx.ISMatch(form1.rssUrlEdit.Text, '&ismalldescr=1', [roIgnoreCase]) = False) and (TRegEx.ISMatch(form1.rssUrlEdit.Text, '&linktype=dl', [roIgnoreCase]) = TRUE) then
      form1.rssUrlEdit.Text := form1.rssUrlEdit.Text + '&ismalldescr=1&isize=1';
  if form1.rssUrlEdit.Text<>'' then  FOptionJson.ForcePath('rss' + '.' + form1.rssNameEdit.Text).AsString := form1.rssUrlEdit.Text;
    FOptionJson.SaveToFile(Myoptionfilename, teUtf8, True, True);
    if form1.addRssButton.Caption = '添加RSS' then
      form1.rssListBox.Items.Add(form1.rssNameEdit.Text);
  end;

  form1.rssUrlEdit.Text := '';
  form1.rssNameEdit.Text := '';
  form1.addRssButton.Caption := '添加RSS';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  TThread.CreateAnonymousThread(Myview).Start; //!!!
// form1.Button3.Caption:=inttostr(form1.ListView1.Items.Count);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  tet: string;
begin
  tet := 'Banshee.S31E02.720p.BluRay.x264-WiKi.mkv';
  form1.Label1.Caption := cuttext(tet);
//form1.Label1.Caption:=getep(form1.Label1.Caption);
//The.Last.Ship.S01E08.720p.HDTV.X264-DIMENSION
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
//  TThread.CreateAnonymousThread(Myview).Start; //!!!
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if form1.subLanSortEdit.Text<>'' then FOptionJson.Forcename('SubLanSort').AsString := form1.subLanSortEdit.Text;
 if form1.subTeamEdit.Text<>'' then FOptionJson.Forcename('SubTeamSort').AsString := form1.subTeamEdit.Text;
  if form1.subonlyCheckBox.Checked then
    FOptionJson.Forcename('Subonlycheck').AsInteger := 1
  else
    FOptionJson.Forcename('Subonlycheck').AsInteger := 0;

 //保存数据为文件
  MySaveData;

  if Application.MessageBox('你确认要退出吗？', '请确认', MB_YesNo + MB_IconQuestion) = IDno then
    application.run;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  pathlist: TStringList;
  constr: string;
  tmprss, rsstxt: TQJson;
begin
  rsstxt := TQJson.Create;
  tmprss := TQJson.Create;


  // 初始化基本数据
  Myinitialize;
  MyaddData;
  if Assigned(FOptionJson.ItemByName('rss')) then
   rsstxt := FOptionJson.Forcename('rss');
  for tmprss in rsstxt do
  begin
    if tmprss.Name <> '' then
      form1.rssListBox.Items.Add(tmprss.Name);
  end;

  constr := FOptionJson.ItemByName('MovieHere').ToString;
  StringReplace(constr, '\\', '\', [rfReplaceAll, rfIgnoreCase]);
  if constr <> '' then
  begin
    pathlist := TStringList.Create;
    pathlist := SplitStrings(constr, ';');
    form1.pathListBox.Items.AddStrings(pathlist);
  end;
 freeandnil(  rsstxt);
 freeandnil(  tmprss);

end;

procedure TForm1.FormShow(Sender: TObject);
begin

  form1.rg1.ItemIndex := FOptionJson.intByName('SubWebSite', 0);
  form1.subLanSortEdit.Text := FOptionJson.ValueByName('SubLanSort', '双语;简体;chs;cht;eng');
  form1.subTeamEdit.Text := FOptionJson.ValueByName('SubTeamSort', 'yyets;衣柜;深影;伊甸园;猪猪');
  form1.edtdeltxttitle.Text := FOptionJson.ValueByName('deltxttitle', 'uk|tsks|1080p|hbo|bbc|tvn|Marvels|大河ドラマ');
  form1.pathFindTimeRzSpinEdit.Value := FOptionJson.FloatByName('PathFindTime', 1);
  form1.infFindTimeRzSpinEdit.Value := FOptionJson.FloatByName('InfFindTime', 1);
  form1.subFindTimeRzSpinEdit.Value := FOptionJson.FloatByName('SubFindTime', 1);
  if FOptionJson.IntByName('Subonlycheck', 0) = 1 then
    form1.subonlyCheckBox.Checked := true
  else
    form1.subonlyCheckBox.Checked := false;

  form1.Caption := Application.ExeName + '- 高歌@CCF -' + GetAppVersion;
//  ShowMessage('这个任务将在1秒后第一次启动，以后每隔1小时定时启动一次。');
  if Form1.ListView1.Showing then
    Workers.at(DoJobFindPath, 1 * qworker.Q1Second, qworker.Q1Hour, nil, False);
 // Workers.at(DoJobRssFind, 5 * qworker.Q1Second, qworker.Q1Hour, nil, False);

end;

procedure DoJobRssFind(AJob: PQJob);
begin
  if FoptionJson.itemByName('rss').Count > 0 then
    TQForJobs.for (0, FoptionJson.itemByName('rss').Count - 1, DoJobRssUpdate, True, nil);
end;

procedure DoJobRssUpdate(AMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt);
var
  tmptxt: string;
begin
  tmptxt := '';
  tmptxt := FoptionJson.itemByName('rss').Items[AIndex].Name;
  if tmptxt <> '' then
  begin
    Workers.Delay(
      procedure(AJob: PQJob)
      var
        temptxt: string;
      begin
        temptxt := AJob.ExtData.AsString;
        writesubrss(temptxt, form1);
      end, 150 * qworker.Q1Second, TQJobExtData.Create(tmptxt), False, jdfFreeAsObject, False);
   //writesubrss(tmptxt,form1);
  end;
//form1.StatusBar1.Panels[0].Text :='自动扫描RSS ' + tmptxt;

end;


procedure DoJobGetdoubanid(AJob: PQJob);
var
  ohash, tet,sauto: string;
  tmpjson: tqjson;
  R: PMyDown ;
  Setid:Integer;
begin
  R := AJob.ExtData.Origin;
 Setid := R.sid;
 sauto:=R.sauto;
  tmpjson := tqjson.Create;
  if Setid >= 0 then
  begin
    tet := TPath.GetFileNameWithoutExtension(TPath.GetFileName(form1.ListView1.Items.Item[Setid].subitems.strings[3]));
 //tet:= LowerCase(tet);//改成小写
    ohash := form1.ListView1.Items.Item[Setid].subitems.strings[6];
    if NameIDDataJson.ValueByName(tet, '') <> '' then
    begin
      NameIDDataJson.Forcename(tet).AsString := '';
      NameIDDataJson.SaveToFile(NameIDData, teUtf8, True, True);
    end; //清除原记录
    HashDataJson.ForcePath(ohash + '.ID').AsString := '';
    HashDataJson.SaveToFile(HashData, teUtf8, True, True);
    tmpjson := Getdoubanid(ohash,'',sauto);
    if (tmpjson <> nil) AND (tmpjson.ValueByName('id', '') <> '') then
    begin
      form1.Label1.Caption := tmpjson.ValueByName('id', '');
      form1.ListView1.Items.Item[Setid].Caption := tmpjson.ValueByName('title', '');
      form1.ListView1.Items.Item[Setid].subitems.strings[0] := tmpjson.ValueByName('original_title', '');
      form1.ListView1.Items.Item[Setid].subitems.strings[4] := tmpjson.ValueByName('id', '');
      form1.ListView1.Items.Item[Setid].subitems.strings[1] := tmpjson.ValueByName('year', '');
    end;
  end;
  if tmpjson <> nil then

FreeAndNil(tmpjson);
end;


procedure DoJobView(AJob: PQJob);
var datafiles: Tstrings;
begin
//  AtomicIncrement(FRuns);
  if FoptionJson.itemByName('MovieHere').ToString <> '' then
  begin
  datafiles := TStringList.Create;
     if TFile.Exists(Myfilename) and SearchFiles(ExtractFilePath(Application.ExeName), 'Data.*', datafiles) then
  begin
    form1.StatusBar1.Panels[0].Text := '发现数据文件，导入';
     MyaddData;

  end;
    Myview;
//    form1.StatusBar1.Panels[0].Text := form1.StatusBar1.Panels[0].Text + '...列表完成';
    datafiles.Free;
  end;

end;

procedure TForm1.edtdeltxttitleChange(Sender: TObject);
begin
if form1.edtdeltxttitle.Text<>'' then  FOptionJson.Forcename('deltxttitle').AsString := form1.edtdeltxttitle.Text;
end;

procedure DoJobFindPath(AJob: PQJob);
begin
//  AtomicIncrement(FRuns);
  if FoptionJson.itemByName('MovieHere').ToString <> '' then
  begin
    form1.StatusBar1.Panels[0].Text := '自动开始扫描媒体目录...';
    if FoptionJson.itemByName('MovieHere').ToString <> '' then
    begin
      Mysearchfile;
    end;
    form1.StatusBar1.Panels[0].Text := '已经完成扫描媒体目录' + FoptionJson.itemByName('MovieHere').ToString + '，载入媒体列表';

    //Workers.at(DoJobView, 1 * qworker.Q1Second, qworker.Q1Hour, nil, False);
    Workers.Post(DoJobView,nil,False);

  end;
end;

procedure DoJobDown(AJob: PQJob);
var
  R: PMyDown;
  imgurl, downfilename,movefilename: string;
    Action: TDownloadUrl;
begin
  R := AJob.ExtData.Origin;
  imgurl := PChar(R.url);
  downfilename := PChar(R.downfilename);
  movefilename := PChar(R.movefilename);
      Action := TDownloadUrl.Create(application);
 //   Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;
      if imgurl <> '' then
      begin
        try
          if (rightStr(imgurl, 1) = '.') then
          begin
            imgurl := TRegEx.Replace(imgurl, '\.$', '');
          end;
          Action.URL := TIdUri.URLEncode(imgurl);
          Action.Filename := downfilename;
          if Action.Execute then
          begin
          if  movefilename <> ''  then

            Tfile.Copy(Action.Filename, movefilename, True);
          end;
        except
          Action.Free;
        end;
      end;
end;




procedure DoJobWritenfo(AJob: PQJob);
var
  R: PMyComplexRecord;
  bid, bHash: string;
begin
  R := AJob.ExtData.Origin;
  bid := PChar(R.bId);
  bHash := PChar(R.bhash);
  if not (TRegEx.IsMatch(bid, '.*[a-z]{1,2}.*', [roIgnoreCase])) then
  begin
    Writenfo(bid, bHash);
  end;
end;

procedure DoFreeMyComplexRecord(AData: Pointer);
begin
  Dispose(PMyComplexRecord(AData));
end;

 procedure DoFreeMydown(AData: Pointer);
begin
  Dispose(PMydown(AData));
end;

 procedure DoFreeMymoviezfile(AData: Pointer);
begin
  Dispose(PmoviezFile(AData));
end;



 function DownloadFile(const URL: string; const filename: string): Boolean;
 var
 ms:TMemoryStream;
 Hc:Thttpclient;
 begin
   ms:=TMemoryStream.Create;
   hc:=Thttpclient.Create;
   try
   try
  //   sleep(3000);
     hc.Get(URL,ms);
     ms.SaveToFile(filename) ;
     Result:=True;
    except
     on e:Exception do
     ApplicationShowException(e);
   end;

   finally
      hc.Free;
      ms.Free;
   end;
 end;









//根据hash写入字幕的后台作业 subhd

function Getsub(chash: string; auto: string = '-a'): Boolean;
var
  Action: TDownloadUrl;
  FEndDown: TNotifyEvent;
  Arch: I7zInArchive;
  strList: TStringList;
  ii, Counter: integer;
  tmptestarr, MytmpSublist: TQJson;
  FJson: TQJson;
  Mysubtmp, mysid: string;
  Mysub, pattern, tts, bbm, cck, eet, ffg: string;
  testName, mFileName, Dstreamtxt, urltxt, Mytitle: string;
  tmpidtxt, tmpidlist: tstringlist;
  matchs: TMatchCollection;
  match: TMatch;
//  Dstream:TStream;
  Dstream: TmemoryStream;
  myMoviefile: PmoviezFile;
  label
  2;
begin
  Result := False;
 // testName := ExtractFilePath(Application.ExeName)+'_test.txt';
  Dstream := TmemoryStream.Create;
  FJson := TQJson.Create;
   MytmpSublist := TQJson.Create;
  tmptestarr := TQJson.Create;
  tmpidlist := tstringlist.Create;
  new(myMoviefile);
  myMoviefile := GetMoviezfilesFromHash(chash);
  //取影片名和剧集名
 // Mytitle := cuttext(myMoviefile.cnname);


  Action := TDownloadUrl.Create(application);
  Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;
  FEndDown := Action.AfterDownload;
  if Assigned(FOptionJson.ItemByName('SubWebSite')) then
  begin

    if FOptionJson.IntByName('SubWebSite', 0) = 0 then
    begin
      urltxt := Foptionjson.ValueByName('subhd.search-url', 'http://subhd.com/search0/#');
      Mytitle := cuttext(myMoviefile.oname) + ' ' + getep(myMoviefile.filename);
     urltxt := StringReplace(urltxt, '#', Mytitle, [rfReplaceAll, rfIgnoreCase]);
  Action.URL := TIdUri.URLEncode(urltxt);
  Action.Filename := ExtractFilePath(Application.ExeName) + inttostr(DateTimeToUnix(Now)) + '_url.html';
   // T:=GetTickCount;
  if Action.Execute then
  begin
 //str := TFile.ReadAllText(path, TEncoding.UTF8); {可指定编码格式}
    Mysub := TFile.ReadAllText(Action.Filename, TEncoding.UTF8);
    Mysub := TRegEx.Replace(Mysub, '\n', '', [roIgnoreCase]);
  end;
  DeleteFile(Action.Filename);



    end;
    if FOptionJson.IntByName('SubWebSite', 0) = 1 then
    begin
 //   if myMoviefile.sep <> '' then
  // Mytitle := myMoviefile.cnname + ' ' + getep(myMoviefile.filename, 'cn')
 //  Mytitle := myMoviefile.cnname  + ' '  + myMoviefile.sep
 //  else
 //     Mytitle := myMoviefile.beename   + ' '  + myMoviefile.sep ;
           Mytitle := myMoviefile.cnoname    ;
      urltxt := Foptionjson.ValueByName('zimuku.search-url', 'https://www.zimuku.cn/search?q=#');
      urltxt := StringReplace(urltxt, '#', Mytitle, [rfReplaceAll, rfIgnoreCase]);
  2:
  Action.URL := TIdUri.URLEncode(urltxt);
  Action.Filename := ExtractFilePath(Application.ExeName) + inttostr(DateTimeToUnix(Now)) + '_url.html';
   // T:=GetTickCount;
  if Action.Execute then
  begin
 //str := TFile.ReadAllText(path, TEncoding.UTF8); {可指定编码格式}
    Mysub := TFile.ReadAllText(Action.Filename, TEncoding.UTF8);
    Mysub := TRegEx.Replace(Mysub, '\n', '', [roIgnoreCase]);
  end;
  DeleteFile(Action.Filename);
  //<div class="title"><p class="tt clearfix"><a href="/subs/42117.html" target="_blank"><b>禁忌 Taboo (2017)</b></a></p>
//<div class="title"><p class="tt clearfix"><a href="/subs/46447.html" target="_blank"><b>贼巢 Den of Thieves (2018)</b></a></p>
       pattern := '<td colspan=3  class="tac  hidden-xs hidden-sm"><a target="_blank" href=".*?"><span';
      if TRegEx.IsMatch(Mysub, pattern, [roIgnoreCase])  then
       begin
          urltxt :='https://www.zimuku.cn' + TRegEx.Replace(Mysub, '.*<td colspan=3  class="tac  hidden-xs hidden-sm"><a target="_blank" href="(.*?)"><span.*', '$1', [roIgnoreCase]);
      goto 2;
       end;
         pattern := '<div class="title"><p class="tt clearfix">.*?</b></a></p>';
      matchs := TRegEx.Matches(Mysub, pattern);
      ii := 0;
      for match in matchs do
      begin
      if TRegEx.IsMatch(match.Value, Mytitle, [roIgnoreCase])  then
       begin
        if TRegEx.IsMatch(match.Value, '<div class="title"><p class="tt clearfix"><a href=".*?" target="_blank"><b>.*?</b></a></p>', [roIgnoreCase]) then
          tts := TRegEx.Replace(match.Value, '<div class="title"><p class="tt clearfix"><a href="(.*?)" target="_blank"><b>.*?</b></a></p>', '$1', [roIgnoreCase])
        else
          tts := '';
       end;
      end;
     if tts <>'' then
     begin
       urltxt := 'https://www.zimuku.cn/'+ tts ;
       Action.URL := TIdUri.URLEncode(urltxt);
  Action.Filename := ExtractFilePath(Application.ExeName) + inttostr(DateTimeToUnix(Now)) + '_url.html';
   // T:=GetTickCount;
  if Action.Execute then
  begin
 //str := TFile.ReadAllText(path, TEncoding.UTF8); {可指定编码格式}
    Mysub := TFile.ReadAllText(Action.Filename, TEncoding.UTF8);
    Mysub := TRegEx.Replace(Mysub, '\n', '', [roIgnoreCase]);
  end;
  DeleteFile(Action.Filename);
     end;

    end;

  end;







  pattern := '';
  if length(Mysub) > 10 then
  begin

    if FOptionJson.IntByName('SubWebSite', 0) = 0 then
    begin

      pattern := '<div class="container list">.*?<div style="padding:15px 0 0 0;">';
      matchs := TRegEx.Matches(Mysub, pattern);
      ii := 0;
      for match in matchs do
      begin
//    TFile.WriteAllText(ExtractFilePath(Application.ExeName)+'_test.txt', match.Value, TEncoding.UTF8); {可指定编码格式}
        if TRegEx.IsMatch(match.Value, '.*?<td><h4><a href=".*?">(.*?)</a></h4></td>.*', [roIgnoreCase]) then
          tts := TRegEx.Replace(match.Value, '.*?<td><h4><a href=".*?">(.*?)</a></h4></td>.*', '$1', [roIgnoreCase])
        else
          tts := '';
        if TRegEx.IsMatch(match.Value, '.*?<td><h4><a href="\/[a-z]{1,3}[0-9]{0,3}\/([0-9]{1,6}?)">.*?</a></h4></td>.*', [roIgnoreCase]) then
          bbm := TRegEx.Replace(match.Value, '.*?<td><h4><a href="\/[a-z]{1,3}[0-9]{0,3}\/([0-9]{1,6}?)">.*?</a></h4></td>.*', '$1', [roIgnoreCase])
        else
          bbm := '';
        if TRegEx.IsMatch(match.Value, '.*?<div class="d_title"><a href=".*?" target="_blank" data-toggle="tooltip" data-placement="top" title=".*?">(.*?)</a></div>.*', [roIgnoreCase]) then
          cck := TRegEx.Replace(match.Value, '.*?<div class="d_title"><a href=".*?" target="_blank" data-toggle="tooltip" data-placement="top" title=".*?">(.*?)</a></div>.*', '$1', [roIgnoreCase])
        else
          cck := '';
        if TRegEx.IsMatch(match.Value, '.*?<div class="d_zu"><a href=".*?" target="_blank">(.*?)</a></div>.*', [roIgnoreCase]) then
          eet := TRegEx.Replace(match.Value, '.*?<div class="d_zu"><a href=".*?" target="_blank">(.*?)</a></div>.*', '$1', [roIgnoreCase])
        else
          eet := '';
        if TRegEx.IsMatch(match.Value, '.*?<span class="label label-success">简体</span>.*|.*?<span class="label label-info">双语</span>.*|.*?<span class="label label-default">英文</span>.*|.*?<span class="label label-primary">繁体</span>.*', [roIgnoreCase]) then
          ffg := TRegEx.Replace(match.Value, '.*?<span class="label label-success">(简体)</span>.*|.*?<span class="label label-info">(双语)</span>.*|.*?<span class="label label-default">(英文)</span>.*|.*?<span class="label label-primary">(繁体)</span>.*', '$1$2$3$4', [roIgnoreCase])
        else
          ffg := '';
        if bbm <> '' then
        begin
          MytmpSublist.ForcePath(bbm + '.cname').AsString := tts;
          MytmpSublist.ForcePath(bbm + '.cherf').AsString := bbm;
          MytmpSublist.ForcePath(bbm + '.zu').AsString := eet;
          MytmpSublist.ForcePath(bbm + '.ctitle').AsString := cck;
          MytmpSublist.ForcePath(bbm + '.clang').AsString := ffg;
        end;
        ii := ii + 1;
      end;

     //查找所有可能的答案并显示选择对话框
      if MytmpSublist.Count > 1 then
      begin
//     MytmpSublist.SaveToFile(testname,teUtf8,True,True);
        if auto = '-a' then
        begin
          mysid := GetSubResult(MytmpSublist, Foptionjson.ValueByName('SubLanSort', '双语;简体;chs;cht;eng'), Foptionjson.ValueByName('SubTeamSort', 'yyets;衣柜;深影;伊甸园;猪猪'));
        end
        else
        begin
          tmpidlist.Clear ;
          for tmptestarr in MytmpSublist do
          begin
            tmpidlist.Add(tmptestarr.ValueByName('cherf', '') + ';' + tmptestarr.ValueByName('cname', '') + ';' + tmptestarr.ValueByName('ctitle', '') + ';' + tmptestarr.ValueByName('zu', '') + ';' + tmptestarr.ValueByName('clang', ''));
          end;
          form1.RzLookupDialog1.List.Clear ;
          form1.RzLookupDialog1.List := tmpidlist;

          if form1.RzLookupDialog1.Execute then
          begin
            tmpidtxt := SplitStrings(form1.RzLookupDialog1.SelectedItem, ';');
            mysid := tmpidtxt[0];
          end
          else
            mysid := '';

        end;
  //   mysid:=fjson.ForcePath('subjects.[0].id').ToString ;
      end
      else if MytmpSublist.Count = 1 then
      begin
        mysid := MytmpSublist.ForcePath('[0]').ValueByName('cherf', '');
      end
      else
        mysid := '';

      if mysid <> '' then
      begin
        urltxt := Foptionjson.ValueByName('downsub-url', 'http://subhd.com/ajax/down_ajax');
        mysid := 'sub_id=' + mysid;
     // mysid := '{"sub_id":"' + mysid + '","success":"1"}' ;
        if tmptestarr <> nil then
          tmptestarr.Clear;
        Mysub := GetURLstring(urltxt, mysid, 'subhd');
        tmptestarr.TryParse(Mysub);
        if TPath.GetExtension(TPath.GetFileName(tmptestarr.Forcename('url').ToString)) <> '' then
        begin
          urltxt := tmptestarr.Forcename('url').ToString;
          Action.URL := TIdUri.URLEncode(urltxt);
          tts := myMoviefile.oname; {提取无扩展名的文件名}
          cck := myMoviefile.path;            {提取路径}
          bbm := TPath.GetExtension(TPath.GetFileName(tmptestarr.Forcename('url').ToString)); {提取扩展名}
          Action.Filename := ExtractFilePath(Application.ExeName) + tts + bbm;
          cck := ExtractFilePath(Application.ExeName) + tts + bbm;
          Action.Filename := TRegEx.Replace(cck, '''', ' ');

//    Action.Filename:= cck + '\' + tts + bbm  ;
   // T:=GetTickCount;
// TThread.CreateAnonymousThread(procedure begin Getsub2unrar(Action) end).Start; //!!!

 //  Action.OnDownloadProgress:=form1.URL_OnDownloadProgress;
   //     FEndDown := Action.AfterDownload;
        end;

      end;

    end;
    //
    //
    if FOptionJson.IntByName('SubWebSite', 0) = 1 then
    begin

      pattern := '<td class="first">.*?<td  class="tac lang">';
      matchs := TRegEx.Matches(Mysub, pattern);
      ii := 0;
      for match in matchs do
      begin
//    TFile.WriteAllText(ExtractFilePath(Application.ExeName)+'_test.txt', match.Value, TEncoding.UTF8); {可指定编码格式}
//<a href="/detail/85106.html" target="_blank" title="24小时：遗产(第7集-简繁英双语字幕-Orange字幕组)
//24.Legacy.S01E07.PROPER.720p.HDTV.x264-BRISK.rar"><b>24小时：遗产(第7集-简繁英双语字幕-Orange字幕组)24.Legacy.S01E07.PROPER.720p.HDTV.x264-BRISK.rar</b></a>
        if TRegEx.IsMatch(match.Value, '.*?<a href="/detail/.*?">(.*?)</b></a>.*', [roIgnoreCase]) then
          bbm := TRegEx.Replace(match.Value, '.*\/([0-9]{5,6})\.html.*', '$1', [roIgnoreCase])
        else
          bbm := '';
        if TRegEx.IsMatch(match.Value, 'title="', [roIgnoreCase]) then
          tts := TRegEx.Replace(match.Value, '.*title="(.*)"><b>.*', '$1', [roIgnoreCase])
        else
          tts := '';
//<td class="last hidden-xs hidden-sm"><span class="glyphicon glyphicon-save"></span>242</td>
        if TRegEx.IsMatch(match.Value, '.*?<td class="last hidden-xs hidden-sm"><span class="glyphicon glyphicon-save"></span>242</td>.*', [roIgnoreCase]) then
          eet := TRegEx.Replace(match.Value, '.*?<div class="d_zu"><a href=".*?" target="_blank">(.*?)</a></div>.*', '$1', [roIgnoreCase])
        else
          eet := '';

        if bbm <> '' then
        begin
          MytmpSublist.ForcePath(bbm + '.cname').AsString := tts;
          MytmpSublist.ForcePath(bbm + '.cherf').AsString := bbm;
          MytmpSublist.ForcePath(bbm + '.zu').AsString := eet;
          MytmpSublist.ForcePath(bbm + '.ctitle').AsString := cck;
          MytmpSublist.ForcePath(bbm + '.clang').AsString := ffg;
        end;
        ii := ii + 1;
      end;




  //查找所有可能的答案并显示选择对话框
      if MytmpSublist.Count > 1 then
      begin
//     MytmpSublist.SaveToFile(testname,teUtf8,True,True);
        if auto = '-a' then
        begin
          mysid := GetSubResult(MytmpSublist, Foptionjson.ValueByName('SubLanSort', '双语;简体;chs;cht;eng'), Foptionjson.ValueByName('SubTeamSort', 'yyets;衣柜;深影;伊甸园;猪猪'));
        end
        else
        begin
          tmpidlist.Clear ;
          for tmptestarr in MytmpSublist do
          begin
            tmpidlist.Add(tmptestarr.ValueByName('cherf', '') + ';' + tmptestarr.ValueByName('cname', '') + ';' + tmptestarr.ValueByName('ctitle', '') + ';' + tmptestarr.ValueByName('zu', '') + ';' + tmptestarr.ValueByName('clang', ''));
          end;
          form1.RzLookupDialog1.List.Clear ;
          form1.RzLookupDialog1.List := tmpidlist;

          if form1.RzLookupDialog1.Execute then
          begin
            tmpidtxt := SplitStrings(form1.RzLookupDialog1.SelectedItem, ';');
            mysid := tmpidtxt[0];
          end
          else
            mysid := '';

        end;
  //   mysid:=fjson.ForcePath('subjects.[0].id').ToString ;
      end
      else if MytmpSublist.Count = 1 then
      begin
        mysid := MytmpSublist.ForcePath('[0]').ValueByName('cherf', '');
      end
      else
        mysid := '';

      if mysid <> '' then
      begin

  //      urltxt := 'http://www.zimuku.cn/detail/' + mysid + '.html';
  //http://www.subku.net/dld/102697.html
   urltxt := 'http://www.subku.net/dld/' + mysid + '.html';
        Action.URL := TIdUri.URLEncode(urltxt);
        Action.Filename := ExtractFilePath(Application.ExeName) + inttostr(DateTimeToUnix(Now)) + '_url.html';
   // T:=GetTickCount;
        if Action.Execute then
        begin
 //str := TFile.ReadAllText(path, TEncoding.UTF8); {可指定编码格式}
          Mysub := TFile.ReadAllText(Action.Filename, TEncoding.UTF8);
          if TRegEx.IsMatch(Mysub, '[a-z0-9]{70,90}', [roIgnoreCase]) then
          begin
            match := TRegEx.Match(Mysub, '[a-z0-9]{70,90}', [roIgnoreCase]);
            Mysub := match.Value;
  //  Mysub := TRegEx.Replace(Mysub, '.*\/([a-z0-9]{70,90})?.*', '$1', [roIgnoreCase]);
          end;
        end;
        DeleteFile(Action.Filename);
 //http://www.subku.net/download/MTAyNjk3fDAzZGYzYTgzMzE0NWE3NjBjMDczYjQ2ZHwxNTIzNjA0NzE1fGI0NDMyZTZhfHJlbW90ZQ%3D%3D/svr/dx1

     //      if TPath.GetExtension(TPath.GetFileName(urltxt)) <> '' then
     // begin
        urltxt := 'http://www.subku.net/download/' + Mysub +'%3D%3D/svr/dx1';
      //  Action.URL := TIdUri.URLEncode(urltxt);
        Action.URL := TIdUri.URLEncode(GetHttpAURl(urltxt));
        tts := myMoviefile.oname; {提取无扩展名的文件名}
        cck := myMoviefile.path;            {提取路径}
     //   bbm :=TPath.GetExtension(TPath.GetFileName(GetHttpAURl(urltxt))); {提取扩展名}
        Action.Filename := ExtractFilePath(Application.ExeName) + tts;
        cck := ExtractFilePath(Application.ExeName) + tts;
        Action.Filename := TRegEx.Replace(cck, '''', ' ');
      end;

    end;
   //
   //
   //
   //
   //
   //
    if (Action.URL <> '') and (mysid <> '') then
    begin
      FEndDown := Action.AfterDownload;
      strList := TStringList.Create;
      strList.Add('.zip');
      strList.Add('.rar');
      strList.Add('.7z');
      strList.Add('.srt');
      strList.Add('.ass');
    //  if Action.Execute then
      if Downloadfile(action.URL,action.Filename) then
      begin
 // form1.URL_OnDownloadProgress(Action);
        if tfile.Exists(Action.Filename) then
        begin
          if FOptionJson.IntByName('SubWebSite', 0) = 0 then
          begin
            bbm := LowerCase(TPath.GetExtension(Action.Filename));
          end
          else
            bbm := GetFileType(Action.Filename);

          case strList.IndexOf(bbm) of
            0:
              Arch := CreateInArchive(CLSID_CFormatZip);
            1:
              Arch := CreateInArchive(CLSID_CFormatRar);
            2:
              Arch := CreateInArchive(CLSID_CFormat7z);
            3:
              begin
                tts := myMoviefile.oname; {提取无扩展名的文件名}
                eet := myMoviefile.path;             {提取路径}
                bbm := '.srt'; {提取扩展名}
               // cck := GetStrR2(Arch.ItemPath[Counter]); {提取扩展名前的.chs这种标注字段}
                mFileName := eet + '\' + tts + bbm;
                tfile.Copy(Action.Filename, mFileName, true);
                if tfile.Exists(Action.Filename) then
                  DeleteFile(Action.Filename);
                Result := True;
                strList.Free;
                exit;
              end;
            4:
              begin
                tts := myMoviefile.oname; {提取无扩展名的文件名}
                eet := myMoviefile.path;             {提取路径}
                bbm := '.ass'; {提取扩展名}
               // cck := GetStrR2(Arch.ItemPath[Counter]); {提取扩展名前的.chs这种标注字段}
                mFileName := eet + '\' + tts + bbm;
                tfile.Copy(Action.Filename, mFileName, true);
                if tfile.Exists(Action.Filename) then
                  DeleteFile(Action.Filename);
                Result := True;
                strList.Free;
                exit;
              end;
          end;

   // Arch.SetProgressCallback(nil, ProgressCallback);
          Arch.OpenFile(Action.Filename);
          for Counter := 0 to Arch.NumberOfItems - 1 do
          begin
            if not Arch.ItemIsFolder[Counter] then
            begin
 //     memoOutput.Lines.Append('包含文件：' + Arch.ItemPath[Counter]);
              Dstream.Position := 0;
              Arch.ExtractItem(Counter, Dstream, false);
              tts := myMoviefile.oname; {提取无扩展名的文件名}
              eet := myMoviefile.path;             {提取路径}
              bbm := TPath.GetExtension(Arch.ItemPath[Counter]); {提取扩展名}
              cck := GetStrR2(Arch.ItemPath[Counter]); {提取扩展名前的.chs这种标注字段}
              mFileName := eet + '\' + tts + '.' + cck + bbm;
              if (bbm = '.ass') or (bbm = '.srt') then
              begin
                Dstream.SaveToFile(mFileName);
                Result := True;
              end;

            end;
          end;

          Arch.Close;
        end;
        if tfile.Exists(Action.Filename) then
          DeleteFile(Action.Filename);
      end;

    end;

  end;
  if tfile.Exists(Action.Filename) then
    DeleteFile(Action.Filename);
  strList.Free;
 // Dstream.Free;
    freeandnil(Dstream);
      freeandnil(FJson);
      freeandnil(MytmpSublist);
      freeandnil(tmptestarr);

end;


//判断文件类型函数：

function GetFileType(FileName: string): string;
var
  MyImage: TMemoryStream;
  Buffer: Word;
  i: integer;
begin

  Result := 'Err';

  MyImage := TMemoryStream.Create;

  try

    MyImage.LoadFromFile(FileName);

    MyImage.Position := 0;                      // 指针文件开头的位置

    if MyImage.Size = 0 then
      Exit;              // 文件大小等于0退出

    MyImage.ReadBuffer(Buffer, 2);               // 读取文件的前２个字节[低位到高位]，放到Buffer里面

    if Buffer = 19280 then
      Result := '.zip';

    if Buffer = 24914 then
      Result := '.rar';
     if (Buffer = 8508)  or (Buffer = 48111) then
      Result := '.ass';
    if (Buffer = 65279) or (Buffer = 3377) then
      Result := '.srt';
  {
    if Buffer=$4947 then  Result :='GIFP';

    if Buffer=$050A then  Result :='PCX';

    if Buffer=$5089 then  Result :='PNG';

    if Buffer=$4238 then  Result :='PSD';

    if Buffer=$A659 then  Result :='RAS';

    if Buffer=$DA01 then  Result :='SGI';

    if Buffer=$4949 then  Result :='TIFF';  }

  finally

    MyImage.Free;                              // 释放内存流对象

  end;

end;







//取跳转URL的最终链接值
function GetHttpAurl(AUrl: string): string;
var
  AHttp: THttpClient;
  AResp: IHttpResponse;
  I, AMaxRedirectTimes: Integer;
begin
  AHttp := THttpClient.Create;
  AHttp.HandleRedirects := False;
  AHttp.AcceptLanguage :='zh-CN,zh;q=0.9,zh-TW;q=0.8,en;q=0.7';
  AHttp.AcceptEncoding :='gzip, deflate';
  AHttp.Accept:='text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8';
  AHttp.ContentType :='text/html';
  AHttp.AllowCookies:=True;
  AHttp.UserAgent :='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36';
  AMaxRedirectTimes := 10;


  I := 0;
  repeat
    AResp := AHttp.Get(AUrl);
    if Assigned(AResp) then
    begin

    // if ((AResp.StatusCode >= 301) and (AResp.StatusCode <= 304)) or (AResp.StatusCode = 307) then
       if (AResp.StatusCode = 301) then
      begin
        AUrl := TURI.PathRelativeToAbs(AResp.GetHeaderValue('Location'), TURI.Create(AUrl));
        Inc(I);
        if I < AMaxRedirectTimes then
          continue;
      end
      else
        Break;
    end
    else
      Break;
  until 1 > 2;
 // AUrl := TRegEx.Replace(AUrl, 'static', 'www');
  Result := AUrl;
  FreeAndNil(AHttp);
end;







 //取文件名的扩展名前一个以.分隔的字符如chs或简体

function GetStrR2(vString: string): string;
var
  tmpidtxt: tstringlist;
begin
  tmpidtxt := SplitStrings(vString, '.');
  if tmpidtxt.count >= 2 then
    Result := tmpidtxt[tmpidtxt.count - 2]
  else
    Result := '';
  tmpidtxt.Free;
end;

function StringToFile(mString: string; mFileName: TFileName): Boolean;
{   返回字符串保存到文件是否成功   }
var
  vFileChar: file of Char;
  I: Integer;
begin
{$I-}
  AssignFile(vFileChar, mFileName);
  Rewrite(vFileChar);
  for I := 1 to Length(mString) do
    Write(vFileChar, mString[I]);
  CloseFile(vFileChar);
{$I+}
  Result := (IOResult = 0) and (mFileName <> '');
end;   {   StringToFile   }









 //读取网页结果

function GetURLstring(url: string; otherstr: string; sitename: string = ''): string;
var
  AResponse: IHttpResponse;
  FHttpClient: THttpClient;
  AStream: TStringStream;
  AReply: TQJson;
begin
 {

  FHttpClient:= THttpClient.Create;
  AStream := TStringStream.Create('', TEncoding.UTF8, False);
    FHttpClient.Accept := 'application/json, text/javascript, */*; q=0.01';
    FHttpClient.AcceptEncoding :='gzip, deflate';
    FHttpClient.ContentType := 'application/x-www-form-urlencoded; charset=UTF-8';
   FHttpClient.UserAgent :='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0';

    AStream.WriteString(otherstr);
    AStream.Position := 0;
    AResponse := FHttpClient.Post('http://subhd.com/ajax/down_ajax', AStream);
    AReply := TQJson.Create;
    AReply.TryParse(AResponse.ContentAsString());
    result :=AReply.ToString ;
    FHttpClient.Free;
    AStream.Free;
    FreeAndNil(AReply);



end;        }
 FHttpClient := THttpClient.Create;
  AStream := TStringStream.Create('', TEncoding.UTF8, False);
  FHttpClient.Accept := FOptionJson.ValueByPath(sitename + '.Accept', '');
  FHttpClient.AcceptEncoding := FOptionJson.ValueByPath(sitename + '.AcceptEncoding', '');
  FHttpClient.ContentType := FOptionJson.ValueByPath(sitename + '.ContentType', '');
  FHttpClient.UserAgent := FOptionJson.ValueByPath(sitename + '.UserAgent', '');

  AStream.WriteString(otherstr);
  //AStream.
  AStream.Position := 0;
  AResponse := FHttpClient.Post(url, AStream);
    //AReply := TQJson.Create;
    //AReply.TryParse(AResponse.ContentAsString(TEncoding.UTF8));
    //result :=AReply.ToString ;
  result := AResponse.ContentAsString(TEncoding.UTF8);
 //   FHttpClient.Free;
  AStream.Free;

end;
{var
  HttpClient: TIdHttp;
  ParamList: TStringList;
  SS: TStringStream;
  tsdw: TQJson;
  sdfsdf:string;
  AResponse: IHttpResponse;
begin
tsdw:=TQJson.Create;
  SS := TStringStream.Create('', TEncoding.UTF8);
  HttpClient := TIdHttp.Create();
  ParamList := TStringList.Create;
  ParamList.Add(otherstr);
  ParamList.Add('success=1');
 HttpClient.Post(url, ParamList, SS);
  sdfsdf:=SS.DataString;
  tsdw.LoadFromStream(SS,teUTF8 ) ;
  sdfsdf:=  tsdw.ValueByName('url','');
  result := sdfsdf ;
end;    }

function Getidc(doubanourdata: TQJson): TQJson;
var  vJson: TQJson;
begin
 vJson := TQJson.Create;
  Result := nil ;
 if ( Trim(doubanourdata.ForceName('id').Value) <> '') and (Trim(doubanourdata.ForceName('title').Value) <> '') then
 begin

//  with  vJson.ForcePath(doubanourdata.ForceName('id').Value) do
  with  vJson do
 begin
 Add('id',doubanourdata.ForceName('id').Value,jdtString);
 Add('title',doubanourdata.ForceName('title').Value,jdtString);
 Add('original_title',doubanourdata.ForceName('original_title').Value,jdtString);
  Add('year',doubanourdata.ForceName('year').Value,jdtString);
  if doubanourdata.ForceName('countries').IsArray  then
     Add('countries',doubanourdata.ForceName('countries').Value,jdtArray);
 end;
   Result := vjson;
 end;



end;

  //用ID查找豆瓣电影和片名等
function Getdoubanall(Myid: string): TQJson;
var
  Action: TDownloadUrl;
 // T,Speed:Cardinal;
//  AFileSize:Int64;
  FJson: TQJson;
  urltxt,DoubanData: string;
begin
  begin
   DoubanDataJson := TQJson.Create;
            DoubanData:= ExtractFilePath(Application.ExeName) + '\databak\' +
   Myid +'_douban.data';
   if tfile.Exists(DoubanData) then
   begin

    DoubanDataJson.LoadFromFile(DoubanData) ;
    DoubanIDJson.Forcename(DoubanDataJson.Forcename('id').Value).Assign(Getidc(DoubanDataJson));
    Result := DoubanDataJson;
   end
   else
   begin
    Action := TDownloadUrl.Create(application);
  //  Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;
    FJson := TQJson.Create;

    try
      randomize;
      urltxt := 'http://api.douban.com/v2/movie/subject/#?apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&client=&udid=';
      urltxt := StringReplace(urltxt, '#', Myid, [rfReplaceAll, rfIgnoreCase]);
      Action.URL := TIdUri.URLEncode(urltxt);
      Action.Filename := ExtractFilePath(Application.ExeName) + inttostr(DateTimeToUnix(Now)) + '_url.html';
   // T:=GetTickCount;
      if Action.Execute then
      begin
        FJson.LoadFromFile(Action.Filename);
        if FJson.Forcename('id').Value <> '' then
        begin
          DoubanIDJson.Forcename(FJson.Forcename('id').Value).Assign(Getidc(FJson));
          DoubanDataJson:=FJson;
          DoubanDataJson.SaveToFile(DoubanData, teUtf8, True, True);
        end;
        Result := fjson;
        DeleteFile(Action.Filename);
      end;
    except
      Action.Free;

    end;
  end;
  end;
 //  FreeAndNil( DoubanDataJson);
  //  FJson.Free;
end;

procedure TForm1.HashClick(Sender: TObject);
var
  Action: TDownloadUrl;
  testjson: tqjson;
begin
  testjson := tqjson.Create;
  Action := TDownloadUrl.Create(application);
  Action.OnDownloadProgress := Form1.URL_OnDownloadProgress;
//form1.Hashstring.Text :=CSVhash(ExtractFilePath(Application.ExeName)+'Hunters.S01E01.720p.HDTV.x264-AVS.mkv');
{
form1.Hashstring.Text :='https://www.shooter.cn/api/subapi.php?filehash='
+ HTTPEncode ('8B1F2B55A0C9E1EA5D72020EF226602F;9954BC38F591E1600FC9CBC28CD4EC96;42F30D525EFCAA974E5E9CFD95A97F6C;F6F336321B54C805F7FF68F083002645')
+ '&pathinfo=' + HTTPEncode('d:/Hunters.S01E01.720p.HDTV.x264-AVS.mkv')
+ '&format=' +HTTPEncode('json')
+ '&lang=' + HTTPEncode('chn');
 }

//    Action.URL:=form1.Hashstring.Text;
  Action.Filename := ExtractFilePath(Application.ExeName) + '_url.html';
  if Action.Execute then
  begin
    testjson.LoadFromFile(Action.Filename);
//    form1.Hashstring.Text :=testjson.ToString;
    DeleteFile(Action.Filename);
  end;

end;

procedure TForm1.infFindTimeRzSpinEditChange(Sender: TObject);
begin
  if (FOptionJson.FloatByName ('InfFindTime',0)>0) and (FOptionJson.FloatByName('InfFindTime', 1) <> form1.infFindTimeRzSpinEdit.Value) then
    FOptionJson.ForceName('InfFindTime').AsFloat := form1.infFindTimeRzSpinEdit.Value;

end;

procedure TForm1.ListView1Click(Sender: TObject);
var
 Item: TListItem;
begin
  if form1.ListView1.SelCount > 0 then
    Item := listview1.Selected;

end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = 6 then
  begin
    Form1.ListView1.CustomSort(@CustomSortProc, Column.Index);
    m_bSort := not m_bSort;
  end;
  if (Column.Index = 1) or (Column.Index = 4) or (Column.Index = 0) then
  begin
    Form1.ListView1.CustomSort(@CustomSorttxtProc, Column.Index);
    m_bSort := not m_bSort;
  end;
end;

procedure TForm1.N10Click(Sender: TObject);
var
 Item: TListItem;
begin
  if form1.ListView1.SelCount > 0 then
  begin
    Item := listview1.Selected;
    while Item <> nil do
    begin

    //此时Item就是其中的一个选择的Item，可以对其进行任何操作
      renamesub(Item.subitems.strings[6]);
      Item := listview1.GetNextItem(Item, sdAll, [isSelected]);
    end;
  end;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  if form1.pathListBox.ItemIndex >= 0 then
    form1.pathListBox.Items.Delete(form1.pathListBox.ItemIndex);
end;

procedure TForm1.N2Click(Sender: TObject);
var
AData:PMyDown;
begin


  if form1.ListView1.SelCount >= 0 then
  begin
      New(AData);
      AData.sid:=form1.ListView1.Selected.Index;
      Workers.Post(DoJobGetdoubanid, TQJobExtData.Create(AData, DoFreeMydown), false, jdfFreeAsObject);
  end;

end;

procedure TForm1.N4Click(Sender: TObject);
begin
  if form1.ListView1.SelCount >= 0 then
  begin
    ShellExecute(Handle, 'open', PChar(form1.ListView1.selected.subitems.strings[3]), nil, nil, SW_SHOW);
  end;

end;

procedure TForm1.N5Click(Sender: TObject);
begin
  if form1.ListView1.SelCount >= 0 then
  begin
    ShellExecute(Handle, 'explore', PChar(ExtractFilePath(form1.ListView1.selected.subitems.strings[3])), nil, nil, SW_SHOW);
  end;
end;

procedure TForm1.menuGetsrtClick(Sender: TObject);
var
  temphash: string;
begin
  if form1.ListView1.SelCount >= 0 then
  begin
    temphash := form1.ListView1.selected.subitems.strings[6];
  //  Getsub(temphash, '');
    if Getsub(temphash, '') then
      form1.ListView1.selected.subitems.strings[0] := form1.ListView1.selected.subitems.strings[0] + '(有字幕)';
  end;
end;

procedure TForm1.N7Click(Sender: TObject);
var
  tmpqjson: Tqjson;
  Item: TListItem;
  bid, bHash: string;
begin
  form2.ShowModal;
  if form2.IdEdit.Text <> '' then
  begin
  tmpqjson := tqjson.Create;
  if form2.ModalResult = mrOK then
  begin

  if (Trim(TtmpFilmData.ForceName ('title').ToString) <>'') and (Trim(TtmpFilmData.ForceName('id').ToString) <>'') then
  begin
   DoubanIDJson.ForceName(TtmpFilmData.ItemByName('id').ToString).Assign(TtmpFilmData );
if  TRegEx.IsMatch(TtmpFilmData.ForceName('countriestxt').ToString, '\["', [roIgnoreCase]) then
TtmpFilmData.ForceName('countries').AsArray  :=TtmpFilmData.ForceName('countriestxt').ToString  else
TtmpFilmData.ForceName('countries').AsArray  :='["' +TtmpFilmData.ForceName('countriestxt').ToString +'"]';
   TtmpFilmData.SaveToFile(ExtractFilePath(Application.ExeName) + '\databak\' +
   TtmpFilmData.Forcename('id').Value +'_douban.data', teUtf8, True, True);
  end;





    if listview1.SelCount > 0 then
    begin
      Item := listview1.Selected;
      while Item <> nil do
      begin

    //此时Item就是其中的一个选择的Item，可以对其进行任何操作
        Item.subitems.strings[4] := form2.IdEdit.text;
        tmpqjson := Getdoubanid(Item.subitems.strings[6], form2.IdEdit.text);
        if (Assigned(tmpqjson)) AND (tmpqjson.Count >0) then
        begin
          form1.Label1.Caption := tmpqjson.ValueByName('id', '');
          Item.Caption := tmpqjson.ValueByName('title', '');
          Item.subitems.strings[0] := tmpqjson.ValueByName('original_title', '');
          Item.subitems.strings[4] := tmpqjson.ValueByName('id', '');
          Item.subitems.strings[1] := tmpqjson.ValueByName('year', '');
        end;
        Item := listview1.GetNextItem(Item, sdAll, [isSelected]);
      end;
    end;
    form2.Close;
  end;
 end ;
   if form2.edtjiedt .Text <> '' then
  begin
   if form2.ModalResult = mrOK then
  begin
    if listview1.SelCount > 0 then
    begin
       Item := listview1.Selected;
  //    while Item <> nil do
  //    begin
       Item.subitems.strings[2] := form2.edtjiedt .text;
       HashDataJson.ForcePath(Item.subitems.strings[6] + '.sep').AsString := form2.edtjiedt .text;
       if Item.subitems.strings[4] <> '' then
       begin
       bid:=  Item.subitems.strings[4];
       bHash:= Item.subitems.strings[6];
         Writenfo(bid,bHash);
       end;
   //   end;
    end;
  end;
  end;
end;


//  刷新;
procedure TForm1.N8Click(Sender: TObject);
begin
Workers.Post(DoJobFindPath,nil,False);
end;

procedure TForm1.addPathButtonClick(Sender: TObject);
var
  path: string;
begin
  if SelectDirectory('请选择文件夹', '', path) then
  begin
    form1.pathListBox.Items.Add(path);
    Workers.at(DoJobFindPath, 1 * qworker.Q1Second, qworker.Q1Hour, nil, False);

  end;

end;

procedure TForm1.pathFindTimeRzSpinEditChange(Sender: TObject);
begin
  if Assigned(FOptionJson.Forcename('PathFindTime')) and (FOptionJson.FloatByName('PathFindTime', 1) <> form1.pathFindTimeRzSpinEdit.Value) then
    FOptionJson.Forcename('PathFindTime').AsFloat := form1.pathFindTimeRzSpinEdit.Value;

end;

procedure TForm1.pathListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ssurtxt: string;
  I: integer;
begin
  (Control as TListBox).Canvas.FillRect(Rect);
  (Control as TListBox).Canvas.TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  //Edit1.Text := ListBox1.Items[Index];
  if form1.pathListBox.Items.Count > 0 then
  begin
    for I := 0 to form1.pathListBox.Items.Count - 1 do
    begin
      if trim(form1.pathListBox.Items.Strings[I]) <> '' then
        if (rightStr(form1.pathListBox.Items.Strings[I], 1) <> '\') then
          form1.pathListBox.Items.Strings[I] := form1.pathListBox.Items.Strings[I] + '\';
      ssurtxt := form1.pathListBox.Items.Strings[I] + ';' + ssurtxt;
    end;
    if (ssurtxt <> '') then
    begin
      if (rightStr(ssurtxt, 1) <> ';') then
        ssurtxt := ssurtxt + ';';
      FoptionJson.itemByName('MovieHere').AsString := ssurtxt;
      Myoptionfilename := ExtractFilePath(Application.ExeName) + '_option.data';
      FOptionJson.SaveToFile(Myoptionfilename, teUtf8, True, True);
    end;
  end;
end;

procedure TForm1.rg1Click(Sender: TObject);
begin
if  form1.rg1.ItemIndex<> null then  FOptionJson.ForceName('SubWebSite').AsInteger := form1.rg1.ItemIndex;
end;

procedure TForm1.rssfindTimerTimer(Sender: TObject);
var
  iii: integer;
  rsstmpjson: TQjson;
begin
  for rsstmpjson in FOptionJson.Forcename('rss') do
  begin
    if rsstmpjson.Name <> '' then
      TThread.CreateAnonymousThread(
        procedure
        begin
          writesubrss(rsstmpjson.Name, form1)
        end).Start; //!!!
  end;
end;

procedure TForm1.rssListBoxClick(Sender: TObject);
begin
  if form1.rssListBox.ItemIndex >= 0 then
  begin
    form1.rssUrlEdit.Text := FOptionJson.ForcePath('rss' + '.' + form1.rssListBox.Items[form1.rssListBox.ItemIndex]).ToString;
    form1.rssNameEdit.Text := form1.rssListBox.Items[form1.rssListBox.ItemIndex];
    form1.addRssButton.Caption := '编辑';
  end;
end;

procedure TForm1.rssListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case button of
    mbright:
     //按下右键时你想要实现的功能
      begin
        form1.rssUrlEdit.Text := '';
        form1.rssNameEdit.Text := '';
        form1.addRssButton.Caption := '添加RSS';
      end;
  end;
end;

procedure TForm1.subFindTimeRzSpinEditChange(Sender: TObject);
begin
  if Assigned(FOptionJson.Forcename('SubFindTime')) and (FOptionJson.FloatByName('SubFindTime', 1) <> form1.subFindTimeRzSpinEdit.Value) then
    FOptionJson.Forcename('SubFindTime').AsFloat := form1.subFindTimeRzSpinEdit.Value;
end;

procedure TForm1.subLanSortEditChange(Sender: TObject);
begin

  FOptionJson.Forcename('SubLanSort').AsString := form1.subLanSortEdit.Text;

end;

procedure TForm1.subonlyCheckBoxClick(Sender: TObject);
begin
  if form1.subonlyCheckBox.Checked then
    FOptionJson.Forcename('Subonlycheck').AsInteger := 1
  else
    FOptionJson.Forcename('Subonlycheck').AsInteger := 0;

end;

procedure TForm1.subTeamEditChange(Sender: TObject);
begin
 if trim(form1.subTeamEdit.Text) <> '' then
  FOptionJson.Forcename('SubTeamSort').AsString := form1.subTeamEdit.Text;

end;

procedure TForm1.updateRssButtonClick(Sender: TObject);
begin
  if form1.rssListBox.ItemIndex >= 0 then
  begin
    writesubrss(form1.rssListBox.Items[form1.rssListBox.ItemIndex], form1);
  end;
end;
procedure DoJobNetPut(AJob: PQJob);
{var
  client : THproseHttpClient;//定义HproseClient对象
  Args: TVariants;//RPC远程函数的参数
  Rslt: string;//返回值  }
begin
 { client := THproseHttpClient.Create(nil);
  //设置Hprose的服务地址
  //用MVCXE开发的Hprose服务，以/hprose/开始，加上服务所在的bpl文件名
  client.UseService('http://localhost:8399/hprose/Example');
  SetLength(Args, 2);
  Args[0]:='a';
  Args[1]:='b';
  //调用远程单元Helloworld中的test函数，并传入两个参数
  Rslt:=VarToStr(client.Invoke('Helloworld.test',Args));
  //显示返回值
  ShowMessage(Rslt); }
end;

//利用IFMXApplicationService接口，访问AppVersion即可取得应用的版本号。
//代码如下，Win32,Android测试通过，需要引用FMX.Platform单元。
function GetAppVersion: String;
var
  ApplicationService: IFMXApplicationService;
begin
  result := '';

  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationService,
    ApplicationService) then
  begin

      result := ApplicationService.AppVersion;

  end;
end;

  //http://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes
function CalcGabestHash(const fname: string): string;
var
  i : integer;
  s : array[1..8] of char;
  tmp       : Int64 absolute s;
  hash      : Int64;
  readed    : integer;

  aStream: TFileStream;
begin
  result := '';
  if not FileExists(fname) then Exit;

  aStream := TFileStream.Create(fName, fmShareDenyNone);
  hash := aStream.Size;

  i := 0; readed := 1;
  while ((i < 8192) and (readed > 0)) do begin
    readed := aStream.Read(s, sizeof(s));
    if readed > 0 then
    begin
      hash := hash + tmp;
    end;
    i := i + 1;
  end;

  aStream.Seek(-65536, soFromEnd); // 65536

  i := 0; readed:= 1;
  while ((i < 8192) and (readed > 0)) do begin
    readed := aStream.Read(s, sizeof(s));
    if readed > 0 then
      hash := hash + tmp;
    i := i + 1;
  end;
  aStream.Free;
  result := Format('%.16x',[hash]);
end;
end.


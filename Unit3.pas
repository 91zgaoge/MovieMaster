unit Unit3;

interface

uses
ExtActns,ComCtrls;
{ TDownLoad }

type
TDownLoad = class(TObject)
private
FDownLoadFileURL:string;
FLocalFileName:string;
FProgressBar:TProgressBar;
FDownLoadURL : TDownLoadURL;
protected

procedure OnDownloadProgress(Sender: TDownLoadURL; Progress,
ProgressMax: Cardinal; StatusCode: TURLDownloadStatus;
StatusText: String; var Cancel: Boolean);
public
property DownLoadFileURL:string read FDownLoadFileURL write FDownLoadFileURL;
property LocalFileName:string read FLocalFileName write FLocalFileName;
property ProgressBar:TProgressBar read FProgressBar write FProgressBar;

//constructor Create;
constructor Create(ProgressBar:TProgressBar);
function DownLoad():Boolean;overload;
function DownLoad(Url,LocalFilename:string):Boolean;overload;
destructor Destroy; override;
published

end;

implementation

constructor TDownLoad.Create(ProgressBar:TProgressBar);
begin
inherited Create();
FProgressBar:=ProgressBar;
FDownLoadURL:= TDownLoadURL.Create(nil);
FDownLoadURL.OnDownloadProgress:=OnDownloadProgress;
end;


procedure TDownLoad.OnDownloadProgress(Sender: TDownLoadURL; Progress,
ProgressMax: Cardinal; StatusCode: TURLDownloadStatus;
StatusText: String; var Cancel: Boolean);
begin
FProgressBar.Max := ProgressMax;
FProgressBar.Position := Progress;
end;

function TDownLoad.DownLoad():Boolean;
begin
Result:=false;
if (FDownLoadFileURL='') or (FLocalFileName='') then
//RaiseFieldNotFound();
exit;

try
with FDownLoadURL do
begin
FileName := FLocalFileName;
URL := FDownLoadFileURL;
ExecuteTarget(FDownLoadURL);
end;
except
//
end;
Result:=True;
end;

function TDownLoad.DownLoad(Url,LocalFilename:string):Boolean;
begin
Result:=False;
FDownLoadFileURL:=Url;
FLocalFileName:=LocalFilename;
try
with FDownLoadURL do
begin
FileName := FLocalFileName;
URL := FDownLoadFileURL;
ExecuteTarget(FDownLoadURL);
end;
except
//
end;
Result:=True;
end;


destructor TDownLoad.Destroy;
begin
//
end;

end.
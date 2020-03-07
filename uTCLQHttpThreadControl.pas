unit uTCLQHttpThreadControl;

//���߳��з��� http �н���������߳���Ӧ����

interface

uses
  Classes,IdBaseComponent, IdComponent, IdTCPConnection, forms, activex,
  SysUtils,IdTCPClient, IdHTTP, Dialogs, OleCtrls, Variants;
  //,uTWebBrowserHttp1;

type
  TCLQHttpThreadEvent = procedure(const out1:string;succeed1:boolean) of object;
  TCLQHttpThreadEvent2 = procedure(const out1:string;succeed1:boolean);  //û�пؼ���

type
  TCLQHttpThread = class(TThread)
  private
    { Private declarations }
  protected
    out1:string;
    ok1:boolean;
    IdHTTP1: TIdHTTP;
    //Ӧ�����ⲿ����//Webhttp1:TWebBrowserHttp1;

    procedure do_ok;
    procedure Execute; override;
  public
    post_url1:string; //����http�������ַ
    post_data1:tstrings; //IdHTTP����Ҫ��post����

    on_ok1:TCLQHttpThreadEvent; //�ɹ�����¼�
    on_ok2:TCLQHttpThreadEvent2; //�ɹ�����¼�
    is_get1:boolean;//ʹ�� get ����

    //Webhttp1:TWebBrowserHttp1;
    //WebBrowser1:TWebBrowser;

    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

type
  TCLQHttpThreadControl = class (TComponent)
  private
    procedure set_post_data1(const Value: TStrings);
    procedure set_pre_data1(const Value: TStrings);
    { Private declarations }
  protected
    out1:string;
    ok1:boolean;
    IdHTTP1: TIdHTTP;
    post_url1:string; //����http�������ַ
    post_data1:tstrings; //IdHTTP����Ҫ��post����
    pre_url1:string; //����http�������ַ
    is_get1:boolean; //�Ƿ�ʹ�� get ����
    pre_data1:tstrings; //IdHTTP����Ҫ��post����
    fon_ok:TCLQHttpThreadEvent; //�ɹ�����¼�
                     
    //WebBrowser1:TWebBrowser;
    http1:TCLQHttpThread;
    
  public

    //�¼�
    on_ok2: TCLQHttpThreadEvent2;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure execute;
  published

    property post_data: TStrings read post_data1 write set_post_data1;
    property post_url: string read post_url1 write post_url1;
    property pre_data: TStrings read pre_data1 write set_pre_data1;
    property pre_url: string read pre_url1 write pre_url1;
    property is_get: boolean read is_get1 write is_get1;//�Ƿ�ʹ�� get ����
    //�¼�
    property on_ok: TCLQHttpThreadEvent read fon_ok write fon_ok;
    //�¼�
    //property on_ok2: TCLQHttpThreadEvent2;

  end;

procedure Register;

implementation


{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TPostHttpThread1.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TPostHttpThread1 }

procedure Register;
begin
  RegisterComponents('clq', [TCLQHttpThreadControl]);
end;

//--------------------------------------------------
//bcb6 ����
//function TIdCustomHTTP.Post(AURL: string; const ASource: TStrings): string;
function http_post(http:TIdHTTP; AURL: string; const ASource: TStrings): string;
var
  LResponse: TStringStream;
begin
  LResponse := TStringStream.Create('');
  try
    http.Post(AURL, ASource, LResponse);
  finally
    result := LResponse.DataString;
    LResponse.Free;
  end;
end;

//--------------------------------------------------
      
constructor TCLQHttpThreadControl.Create(AOwner: TComponent);
begin
  inherited;
  post_data1:=tstringlist.Create;
  pre_data1:=tstringlist.Create;
  is_get1:=false;

  //WebBrowser1:=TWebBrowser.Create(application.MainForm);
  //WebBrowser1.Visible:=false;
  
end;

destructor TCLQHttpThreadControl.Destroy;
begin
  //http1.free; //?��Ҫ���������?
  post_data1.Free;
  pre_data1.Free;
  inherited;
  
end;
  

procedure TCLQHttpThreadControl.execute;
begin
  http1:=TCLQHttpThread.create(true);
  http1.post_data1:=self.post_data;
  http1.post_url1:=self.post_url;

  
  http1.on_ok1:=self.on_ok;
  http1.on_ok2:=self.on_ok2;
  //http1.WebBrowser1:=self.WebBrowser1;
  http1.is_get1:=is_get1;

  http1.Resume;//�����Զ�free
end;


procedure TCLQHttpThread.Execute;
var
  b_new1:boolean;//�Ƿ��Ѿ����й�ȡ���µ�URL�Ķ���[�����Ƿ�ɹ�]
  s1:string;

  strData: string;
  PostData: OleVariant;
  Headers: OleVariant;
  i:integer;
  
  procedure do_exit1;
  begin
    //post_data1.Free;
    if IdHTTP1<>nil then
    begin
      IdHTTP1.Free;
    end;
  end;


begin
  //CoInitialize(nil);

  s1:=self.post_data1.Text;
  b_new1:=false;
  IdHTTP1:= TIdHTTP.Create(nil);


  ok1:=true;
  out1:='';


  //���û���ҵ�����ֹ
  if trim(self.post_url1)='' then
  begin
    ok1:=false;
    Synchronize(do_ok);
    do_exit1;
    exit;
  end;

  //��ʼ���������ĵ�ַ
  try

      if is_get1
      then out1:=IdHTTP1.Get(self.post_url1)
      else out1:=http_post(IdHTTP1,self.post_url1,self.post_data1);

  except
    post_url1:='';//Ҫ�޸�Ϊ�գ�����GetNewPostUrl����ȡ������url
    ok1:=false;
    out1:='';
  end;

  //������URL���ʲ�����������û��ȡ�ù��µ�URL����ô����ȡURL���ٷ���һ��
  if (b_new1=false)and(ok1=false) then
  begin

    b_new1:=true;

    //���û���ҵ�����ֹ
    if trim(self.post_url1)='' then
    begin
      ok1:=false;
      Synchronize(do_ok);
      do_exit1;
      exit;
    end;
    //��ʼ���������ĵ�ַ
    try
      self.post_data1.Text:=s1;

//      if use_ie1
//      then out1:=webHTTP1.Post1(self.post_url1,self.post_data1)
//      else
      out1:=http_post(IdHTTP1,self.post_url1,self.post_data1);
    except
      ok1:=false;
      out1:='';
    end;
  end;

  Synchronize(do_ok);
  do_exit1;
end;

procedure TCLQHttpThread.do_ok;
begin
  if assigned(self.on_ok1) then self.on_ok1(out1,ok1);
  if assigned(self.on_ok2) then self.on_ok2(out1,ok1);

end;


procedure TCLQHttpThreadControl.set_post_data1(const Value: TStrings);
begin
  post_data1 := Value;

end;

procedure TCLQHttpThreadControl.set_pre_data1(const Value: TStrings);
begin
  pre_data1 := Value;

end;

constructor TCLQHttpThread.Create(CreateSuspended: Boolean);
begin
  inherited;

  is_get1:=false;
end;

destructor TCLQHttpThread.Destroy;
begin

  inherited;
end;

initialization
  { Initialization section goes here }
  //CoInitialize(nil);

finalization
  { Finalization section goes here }
  //CoUninitialize();



end.

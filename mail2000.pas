//本文件为 clq 修改自 TMail2000 控件,修改只涉及编解码部分,通讯部分并没有用它
//目前最新代码位于 https://github.com/clqsrc/delphi_lost

// 2019/7/24 21:56:42 增加了一个邮件 mime 各个部分的未解码字符集的原始字符串属性，因为 utf-8 的 html 显示时需要。参考 self.Decoded_Bin 相关代码
// 2019/7/31 19:53:11 GetTimeZoneBias: Double; //这个函数实际上是得到 delphi 的小时数值的表示//1 就表示 24 个小时，所以要得到 8 小时的 delphi tdatetime 值就是 8 除以 24

(*

Component name...................: Mail2000 (Mail2000.pas)
Classes implemented..............: TPOP2000, TSMTP2000, TMailMessage2000
Version..........................: 1.9.5
Status...........................: Beta
Last update......................: 2001-08-02
Author...........................: Marcello 'Panda' Tavares
Homepage.........................: http://groups.yahoo.com/group/tmail2000
Comments, bugs, suggestions to...: tmail2000@yahoogroups.com
Language.........................: English
Platform (tested)................: Windows 95/98/98SE/2000
Requires.........................: Borland Delphi 5 Professional or better


Features
--------

1. Retrieve and delete messages from POP3 servers;

2. Send messages through SMTP servers;

3. Parse MIME or UUCODE messages in header, body, alternative texts and
   attachments;

4. Create or modify MIME messages on-the-fly;

5. HTML and embedded graphics support;

6. Save or retrieve messages or attachments from files or streams;

7. Ideal for automated e-mail processing.


Know limitations
----------------

1. Does not build UUCODE messages;

2. Some problems when running on Windows NT/2000/ME (worth a try);

3. Strange behaviours when netlink not present;

4. Some troubles when handling very big messages;

5. New messages will always be multipart;

6. Some bugs and memory leaks.


How to install
--------------

Create a directory;
Extract archive contents on it;
Open Delphi;
Click File/Close All;
Click Component/Install Component;
In "Unit File Name" select mail2000.pas;
Click Ok;
Select Yes to rebuild package;
Wait for the message saying that the component is installed;
Click File/Close All;
Select Yes to save the package;
Now try to run the demo.


How to use
----------

The better way to learn is playing with the demo application.
I'm not planning to type a help file.
Fell free to mail your questions to me, expect aswer for 1-2 weeks.
See 'Discussion Group' section below.
Good luck!


License stuff
-------------

Mail2000 Copyleft 1999-2001

This software is provided as-is, without any express or implied
warranty. In no event will the author be held liable for any damages
arising from the use of this software.

As a freeware, the author reserve your rights to not provide support,
requested changes in the code, specific versions, improvements of any
kind and bug fixes. The main purpose is to help a little the programmers
community over the world as a whole, not just one person or organization.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented, you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated.

2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being an original software.

3. If you make changes to this software, you must send me the modified
   integral version.

Please, consider my hard work.


Thanks to
---------

Mariano D. Podesta (marianopodesta@usa.net) - The author of wlPop3
component, from where I copied some decoding routines;

Sergio Kessler (sergio@perio.unlp.edu.ar) - The author of SakEmail
component, from where I based my encoding and smtp algorithms;

Delphi Super Page (http://delphi.icm.edu.pl) - For providing
the best way to find great programs and to join the Delphi community;

Yunarso Anang (yasx@hotmail.com) - For providing some functions for
correct threatment of oriental charsets;

Christian Bormann (chris@xynx.de) - For giving a lot of suggestions
and hard testing of this component;

Tommy Andersen (sorry, I lost his address) - For warning about some
bugs in code;

Kunikazu Okada (kunikazu@okada.cc) - For detailed and careful suggestions
to help mail composition;

Anderson (andermuller@conex.com.br) - Advices;

Rene de Jong (rmdejong@ism.nl) - Extensive bugfixes;

Hou Yg (yghou@yahoo.com) - Improvements;

Peter Baars (peter.baars@elburg.nl) - Bugfixes;

Giuseppe Mingolla (gmingolla@criptanet.it) - AttachStream method;

Milkopb (milkopb@yahoo.com) - Bugfixes;

David P. Schwartz (davids@desertigloo.com) - Code fixes;

Anyone interested in helping me to improve this component, including you,
just by downloading it.


What's new in 1.1 version
-------------------------

1.  Fixed the threatment of encoded fields in header;
2.  Fixed some fake attachments found in message;
3.  Included a string property "LastMessage" containing the source of
    last message retrieved;
4.  Now decoding file names;
5.  Fixed way to identify kind of host address;
6.  Added support for some tunnel proxy servers (eg via telnet port);
7.  Socket changed to non-blocking to improve communication;
8.  Fixed crashes when decoding encoded labels;
9.  Fixed header decoding with ansi charsets;
10. Fixed crashes when there are deleted messages on server;
11. Now recognizing text/??? file attachments;
12. Added Content-ID label at attachment header, now you can reference
    attached files on HTML code as <img src=cid:file.ext>;
13. Improved a lot the speed when decoding messages;
14. Thousands of minor bug fixes.


What's new in 1.2 version
-------------------------

1.  Added HELO command when talking to SMTP server;
2.  Changed CCO: fields (in portuguese) to BCC:
3.  It doesn't remove BCC: field after SMTP send anymore;
4.  Some random bugs fixed.


What's new in 1.3 version
-------------------------

1.  POP and SMTP routines discontinued, but they will remain in the code;
2.  Some suggestions added.


What's new in 1.4 version
-------------------------

1.  Improved UUCODE decoding;
2.  Range overflow bugs fixed;
3.  Changed MailMessage to MailMessage2000 to avoid class name conflicts.


What's new in 1.5 version
-------------------------

1.  I decided to improve POP and SMTP, but still aren't reliable;
2.  Another sort of bug fixes;
3.  TPOP2000.RetrieveHeader procedure added;
4.  TPOP2000.DeleteAfterRetrieve property added;
5.  Improved threatment of messages with no text parts;
6.  Proxy support will remain, but has been discontinued;
7.  TMailMessage2000.LoadFromFile procedure added;
8.  TMailMessage2000.SaveToFile procedure added.


What's new in 1.6 version
-------------------------

1.  Fixed expecting '+OK ' instead of '+OK' from SMTP;
2.  Stopped using TClientSocket.ReceiveLength, which is innacurate.


What's new in 1.7 version
-------------------------

1.  Handling of 'Received' (hop) headers. Now it is possible to trace the
    path e-mail went on;
2.  Again, bug fixes;
3.  Added properties to read (and just to read) 'To:' information and 'Cc:'
    information using TStringList;
4.  Added procedures to set destinations in comma-delimited format;
5.  Removed text/rtf handling.


What's new in 1.8 version
-------------------------

1.  Guess what? Bug fixes;
2.  Some memory leaks identified and fixed;
3.  Improved SMTP processing;
4.  Exception fixed in function 'Fill';
5.  Added 'AttachStream' method.


What's new in 1.9.x version
-------------------------

1.  Improved date handling;
2.  Improved 'Received' header handling;
3.  Added 'Mime-Version' field;
4.  Added 'Content-Length' field;
5.  Fixed bug when there is comma between quotes;
6.  Several compatibility improvements;
7.  Several redundancies removed;
8.  Added 'Embedded' option for attachments;
9.  Improved mail bulding structure and algorithm;
10. Added 'FindParts' to identify texts and attachments of foreing messages;
11. Removed 'GetAttachList' (now obsolete);
12. Added 'Normalize' to reformat foreing messages on Mail2000 standards;
13. Changed 'SetTextPlain' and 'SetTextHTML' to work with String type;
14. Added 'LoadFromStream' and 'SaveToStream';
15. Added 'MessageSource' read/write String property;
16. Added 'GetUIDL' method to POP component;
17. Added 'DetachFile' method;
18. Added 'Abort' method to POP and SMTP components;
19. Better handling of recipient fields (TMailRecipients);
20. Added 'AttachString' method;
21. Added 'AddHop' method;
22. Added 'SendMessageTo' method to SMTP component;
23. Added 'SendStringTo' method to SMTP component;
24. POP and SMTP components hard-tested;
25. POP and SMTP doesn't require MailMessage to work anymore;
26. Removed proxy support (but still working with ordinary proxy redirection);
27. Fixed one dot line causing SMTP to truncate the message;
28. Fixed long lines on header;
29. Added 'TextEncoding' published property;
30. SendMessage will abort on first recipient rejected;
31. Treatment of dates without seconds.


Author data
-----------

Marcello Roberto Tavares Pereira
mycelo@yahoo.com
http://mpanda.8m.com
ICQ 5831833
Sorocaba/SP - BRAZIL
Spoken languages: Portuguese, English, Spanish


Discussion Group
----------------

Please join TMail2000 group, exchange information about mailing
application development with another power programmers, and receive
suggestions, advices, bugfixes and updates about this component.

http://groups.yahoo.com/group/tmail2000
tmail2000-subscribe@yahoogroups.com

This site stores all previous messages, you can find valuable
information about this component there. If you have a question,
please search this site before asking me, I will not post the
same answer twice.

*)

(*
clq:
以下为我修改后的注释:

代码是我多年前在 mail2000 在进行修改的,很惭愧代码改得很乱.以后有时间再整理吧,最
近因为要写电子邮件文章又进行了一些改进,改得这么烂的实在不想放上来,但又害怕弄丢了,
所以大家将就用吧.以下是一些修改记录(2018 年后的,之前的没有了).

1.
2018.02.05
原来对 mime 的理解不足,解码 utf8 时没有考虑编码的情况,现在修正为已经 base64 解码
后的再转换字符集
self.FDecoded.SaveToStream(f_buf1); //clq 2018.02.05 应该转码解码后的字符串流

2.
修改了函数 TMailPart.GetLabelValue
2018-2-5 clq 从这一行开始后面以空格或者 tab 开头的其实都算是它的内容,因为是折行后的

*)

unit Mail2000;

{Please don't remove the following line}
{$BOOLEVAL OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CVCode,//big5,
  DateUtils,
  IdCoderQuotedPrintable,
  StrUtils,
  WinSock, ScktComp, Math, Registry, ExtCtrls;

type

  TMailPartList = class;
  TMailMessage2000 = class;
  TSocketTalk = class;

  TMessageSize = array of Integer;

  TSessionState = (stNone, stConnect, stUser, stPass, stStat, stList, stRetr, stDele, stUIDL, stHelo, stMail, stRcpt, stData, stSendData, stQuit);
  TTalkError = (teGeneral, teSend, teReceive, teConnect, teDisconnect, teAccept, teTimeout, teNoError);
  TEncodingType = (etBase64, etQuotedPrintable, etNoEncoding, et7Bit);

  TProgressEvent = procedure(Sender: TObject; Total, Current: Integer) of object;
  TEndOfDataEvent = procedure(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean) of object;
  TSocketTalkErrorEvent = procedure(Sender: TObject; SessionState: TSessionState; TalkError: TTalkError) of object;
  TReceiveDataEvent = procedure(Sender: TObject; Sessionstate: TSessionState; Data: String; var ServerResult: Boolean) of object;

  TReceivedField = (reFrom, reBy, reFor, reDate, reNone);

  TReceived = record
    From: String;
    By: String;
    Address: String;
    Date: TDateTime;
  end;

  { TMailPart - A recursive class to handle parts, subparts, and the mail by itself }

  TMailPart = class(TComponent)
  private

    FHeader: TStringList {TMailText};
    FBody: TMemoryStream;
    
    // 2019/7/24 21:20:09 //clq 这个应该指的是解码后的结果
    FDecoded: TMemoryStream;

    FParentBoundary: String;
    FOwnerMessage: TMailMessage2000;
    FSubPartList: TMailPartList;
    FOwnerPart: TMailPart;
    FAttachedMessage: TMailMessage2000;
    FIsDecoded: Boolean;
    FEmbedded: Boolean;
    FDecoded_Bin: TMemoryStream;

    function GetAttachInfo: String;
    function GetFileName: String;
    function GetBoundary: String;
    function GetSource: String;

    procedure Fill(Data: PChar; HasHeader: Boolean);
    procedure SetSource(const Text: String);

  public
    charset:string; // 2019/7/24 21:30:08//clq add 这个部分的字符集，例如 utf-8,gb2312 //已经转化为全小写  
  public

    constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

    function GetLabelValue(const cLabel: String): String;                     // Get the value of a label. e.g. Label: value
    function GetLabelParamValue(const cLabel, Param: String): String;         // Get the value of a label parameter. e.g. Label: xxx; param=value
    function LabelExists(const cLabel: String): Boolean;                      // Determine if a label exists
    function LabelParamExists(const cLabel, Param: String): Boolean;          // Determine if a label parameter exists

    function Decode: Boolean;                                                 // Decode Body stream into Decoded stream and result true if successful

    procedure Encode(const ET: TEncodingType);
    procedure EncodeText;                                                     // Encode Decoded stream into Body stream using quoted-printable
    procedure EncodeBinary;                                                   // Encode Decoded stream into Body stream using Base64
                                
    //clq 用这两个函数进行标志扩展是没问题的
    procedure SetLabelValue(const cLabel, cValue: String);                    // Set the value of a label
    procedure SetLabelParamValue(const cLabel, cParam, cValue: String);       // Set the value of a label parameter

    procedure Remove;                                                         // Delete this mailpart from message

    procedure LoadFromFile(FileName: String);                                 // Load the data from a file
    procedure SaveToFile(FileName: String);                                   // Save the data to a file
    procedure LoadFromStream(Stream: TStream);                                // Load the data from a stream
    procedure SaveToStream(Stream: TStream);                                  // Save the data to a stream

    property PartSource: String read GetSource write SetSource;
    property Header: TStringList read FHeader;                                // The header text
    property Body: TMemoryStream read FBody;                                  // The original body

    // 2019/7/24 21:49:31//clq 这个是解码 base64 的字符集后的字符串，所以要加一个未解码字符集的
    property Decoded: TMemoryStream read FDecoded;                            // Stream with the body decoded
    property Decoded_Bin: TMemoryStream read FDecoded_Bin;

    property SubPartList: TMailPartList read FSubPartList;                    // List of subparts of this mail part
    property FileName: String read GetFileName;                               // Name of file when this mail part is an attached file
    property AttachInfo: String read GetAttachInfo;                           // E.g. application/octet-stream
    property OwnerMessage: TMailMessage2000 read FOwnerMessage;               // Main message that owns this mail part
    property OwnerPart: TMailPart read FOwnerPart;                            // Father part of this part (can be the main message too)
    property IsDecoded: Boolean read FIsDecoded;                              // If this part is decoded
    property Embedded: Boolean read FEmbedded write FEmbedded;                // E.g. if is a picture inside HTML text
  end;

  { TMailPartList - Just a collection of TMailPart's }

	TMailPartList = class(TList)
	private

		function Get(const Index: Integer): TMailPart;

	public

		destructor Destroy; override;

		property Items[const Index: Integer]: TMailPart read Get; default;
	end;

  { TMailRecipients - Handling of recipient fields }

  TMailRecipients = class(TObject)
  private

    FMessage: TMailMessage2000;
    FField: String;
    FNames: TStringList;
    FAddresses: TStringList;
    FCheck: Integer;

    function GetName(const Index: Integer): String;
    function GetAddress(const Index: Integer): String;
    function GetCount: Integer;

    procedure SetName(const Index: Integer; const Name: String);
    procedure SetAddress(const Index: Integer; const Address: String);

    function FindName(const Name: String): Integer;
    function FindAddress(const Address: String): Integer;
    function GetAllNames: String;
    function GetAllAddresses: String;

    procedure HeaderToStrings;
    procedure StringsToHeader;

  public

    constructor Create(MailMessage: TMailMessage2000; Field: String); //override;
    destructor Destroy; override;

    procedure Add(const Name, Address: String);
    procedure Replace(const Index: Integer; const Name, Address: String);
    procedure Delete(const Index: Integer);
    procedure SetAll(const Names, Addresses: String);
    procedure AddNamesTo(const Str: TStrings);
    procedure AddAddressesTo(const Str: TStrings);
    procedure Clear;

    property Count: Integer read GetCount;
    property Name[const Index: Integer]: String read GetName write SetName;
    property Address[const Index: Integer]: String read GetAddress write SetAddress;
    property ByName[const Name: String]: Integer read FindName;
    property ByAddress[const Name: String]: Integer read FindAddress;
    property AllNames: String read GetAllNames;
    property AllAddresses: String read GetAllAddresses;
  end;

  { TMailMessage2000 - A descendant of TMailPart with some tools to handle the mail }

  TMailMessage2000 = class(TMailPart)
  private

    FAttachList: TMailPartList;
    FTextPlain: TStringList;
    FTextHTML: TStringList;
    FTextPlainPart: TMailPart;
    FTextHTMLPart: TMailPart;
    FMixedPart: TMailPart;
    FRelatedPart: TMailPart;
    FAlternativePart: TMailPart;
    FCharset: String;
    FOnProgress: TProgressEvent;
    FNameCount: Integer;
    FToList: TMailRecipients;
    FCcList: TMailRecipients;
    FBccList: TMailRecipients;
    FTextEncoding: TEncodingType;

    FNeedRebuild: Boolean;
    FNeedNormalize: Boolean;
    FNeedFindParts: Boolean;

    function GetDestName(Field: String; const Index: Integer): String;
    function GetDestAddress(Field: String; const Index: Integer): String;

    function GetReceivedCount: Integer;
    function GetReceived(const Index: Integer): TReceived;

    function GetAttach(const FileName: String): TMailPart;

    function GetFromName: String;
    function GetFromAddress: String;
    function GetReplyToName: String;
    function GetReplyToAddress: String;
    function GetSubject: String;
    function GetDate: TDateTime;
    function GetMessageId: String;

    procedure PutText(Text: String; Part: TMailPart; Content: String);

    procedure SetSubject(const Subject: String);
    procedure SetDate(const Date: TDateTime);
    procedure SetMessageId(const MessageId: String);

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetFrom(const Name, Address: String);                           // Create/modify the From: field
    procedure SetReplyTo(const Name, Address: String);                        // Create/modify the Reply-To: field

    procedure FindParts;                                                      // Search for the attachments and texts
    procedure Normalize;                                                      // Reconstruct message on Mail2000 standards (multipart/mixed)
    procedure RebuildBody;                                                    // Build the raw mail body according to mailparts
    procedure Reset;                                                          // Clear all stored data in the object
    procedure SetTextPlain(const Text: String);                               // Create/modify a mailpart for text/plain (doesn't rebuild body)
    procedure SetTextHTML(const Text: String);                                // Create/modify a mailpart for text/html (doesn't rebuild body)
    procedure RemoveTextPlain;                                                // Remove the text/plain mailpart (doesn't rebuild body)
    procedure RemoveTextHTML;                                                 // Remove the text/html mailpart (doesn't rebuild body)

    procedure AttachFile(const FileName: String; const ContentType: String = ''; const EncodingType: TEncodingType = etBase64; const IsEmbedded: Boolean = False);
              // Create a mailpart and encode a file on it (doesn't rebuild body)
    procedure AttachString(const Text, FileName: String; const ContentType: String = ''; const EncodingType: TEncodingType = etBase64; const IsEmbedded: Boolean = False);
              // Create a mailpart and encode a string on it (doesn't rebuild body)
    procedure AttachStream(const AStream: TStream; const FileName: String; const ContentType: String = ''; const EncodingType: TEncodingType = etBase64; const IsEmbedded: Boolean = False);
              // Create a mailpart and encode a stream on it (doesn't rebuild body)
    procedure DetachFile(const FileName: String);
              // Remove attached file from message by name
    procedure DetachFileIndex(const Index: Integer);
              // Remove attached file from message by index of AttachList

    procedure AddHop(const From, By, Aplic, Address: String);                 // Add a 'Received:' in message header

    property Received[const Index: Integer]: TReceived read GetReceived;      // Retrieve the n-th 'Received' header
    property ReceivedCount: Integer read GetReceivedCount;                    // Count the instances of 'Received' fields (hops)
    property AttachByName[const FileName: String]: TMailPart read GetAttach;  // Returns the MailPart of an attachment by filename
    property ToList: TMailRecipients read FToList;                            // Handling of To: recipients
    property CcList: TMailRecipients read FCcList;                            // Handling of Cc: recipients
    property BccList: TMailRecipients read FBccList;                          // Handling of Bcc: recipients

    property MessageSource: String read GetSource write SetSource;
    property FromName: String read GetFromName;                               // Retrieve the From: name
    property FromAddress: String read GetFromAddress;                         // Retrieve the From: address
    property ReplyToName: String read GetReplyToName;                         // Retrieve the Reply-To: name
    property ReplyToAddress: String read GetReplyToAddress;                   // Retrieve the Reply-To: address
    property Subject: String read GetSubject write SetSubject;                // Retrieve or set the Subject: string
    property Date: TDateTime read GetDate write SetDate;                      // Retrieve or set the Date: in TDateTime format
    property MessageId: String read GetMessageId write SetMessageId;          // Retrieve or set the Message-Id:
    property AttachList: TMailPartList read FAttachList;                      // A list of all attached files
    property TextPlain: TStringList read FTextPlain;                          // A StringList with the text/plain from message
    property TextHTML: TStringList read FTextHTML;                            // A StringList with the text/html from message
    property TextPlainPart: TMailPart read FTextPlainPart;                    // The text/plain part
    property TextHTMLPart: TMailPart read FTextHTMLPart;                      // The text/html part
    property NeedRebuild: Boolean read FNeedRebuild;                          // True if RebuildBody is needed
    property NeedNormalize: Boolean read FNeedNormalize;                      // True if message needs to be normalized
    property NeedFindParts: Boolean read FNeedFindParts;                      // True if message has parts to be searched for

  published

    //property Charset: String read FCharSet write FCharset  default 'sss';//'iso-8859-1';                      // Charset to build headers and text
    //property TextEncoding: TEncodingType read FTextEncoding write FTextEncoding default etQuotedPrintable; // How text will be encoded
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;      // Occurs when storing message in memory
  end;

  { TSocketTalk }

  TSocketTalk = class(TComponent)
  private

    FTimeOut: Integer;
    FExpectedEnd: String;
    FLastResponse: String;
    FDataSize: Integer;
    FPacketSize: Integer;
    FTalkError: TTalkError;
    FSessionState: TSessionState;
    FClientSocket: TClientSocket;
    FWaitingServer: Boolean;
    FTimer: TTimer;
    FServerResult: Boolean;

    FOnProgress: TProgressEvent;
    FOnEndOfData: TEndOfDataEvent;
    FOnSocketTalkError: TSocketTalkErrorEvent;
    FOnReceiveData: TReceiveDataEvent;
    FOnDisconnect: TNotifyEvent;

    procedure SocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer(Sender: TObject);

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Talk(Buffer, EndStr: String; SessionState: TSessionState);
    procedure Cancel;
    procedure ForceState(SessionState: TSessionState);
    procedure WaitServer;

    property LastResponse: String read FLastResponse;
    property DataSize: Integer read FDataSize write FDataSize;
    property PacketSize: Integer read FPacketSize write FPacketSize;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property TalkError: TTalkError read FTalkError;
    property ClientSocket: TClientSocket read FClientSocket;
    property ServerResult: Boolean read FServerResult;

    property OnEndOfData: TEndOfDataEvent read FOnEndOfData write FOnEndOfData;
    property OnSocketTalkError: TSocketTalkErrorEvent read FOnSocketTalkError write FOnSocketTalkError;
    property OnReceiveData: TReceiveDataEvent read FOnReceiveData write FOnReceiveData;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
  end;

  { TPOP2000 }

  TPOP2000 = class(TComponent)
  private

    FMailMessage: TMailMessage2000;

    FSessionMessageCount: Integer;
    FSessionMessageSize: TMessageSize;
    FSessionConnected: Boolean;
    FSessionLogged: Boolean;
    FLastMessage: String;
    FSocketTalk: TSocketTalk;

    FUserName: String;
    FPassword: String;
    FPort: Integer;
    FHost: String;
    FDeleteOnRetrieve: Boolean;

    procedure EndOfData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
    procedure SocketTalkError(Sender: TObject; SessionState: TSessionState; TalkError: TTalkError);
    procedure ReceiveData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
    procedure SocketDisconnect(Sender: TObject);

    function GetTimeOut: Integer;
    procedure SetTimeOut(Value: Integer);

    function GetProgress: TProgressEvent;
    procedure SetProgress(Value: TProgressEvent);

    function GetLastResponse: String;

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Connect: Boolean;                                                // Connect to mail server
    function Login: Boolean;                                                  // Autenticate to mail server
    function Quit: Boolean;                                                   // Logout and disconnect

    procedure Abort;                                                          // Force disconnect

    function RetrieveMessage(Number: Integer): Boolean;                       // Retrieve mail number # and put in MailMessage
    function RetrieveHeader(Number: Integer; Lines: Integer = 0): Boolean;    // Retrieve header and put in MailMessage
    function DeleteMessage(Number: Integer): Boolean;                         // Delete mail number #
    function GetUIDL(Number: Integer): String;                                // Get UIDL from mail number #

    property SessionMessageCount: Integer read FSessionMessageCount;          // Number of messages found on server
    property SessionMessageSize: TMessageSize read FSessionMessageSize;       // Dynamic array with size of the messages
    property SessionConnected: Boolean read FSessionConnected;                // True if conencted to server
    property SessionLogged: Boolean read FSessionLogged;                      // True if autenticated on server
    property LastMessage: String read FLastMessage;                           // Last integral message text
    property LastResponse: String read GetLastResponse;                       // Last string received from server

  published

    property UserName: String read FUserName write FUserName;                 // User name to login on server
    property Password: String read FPassword write FPassword;                 // Password
    property Port: Integer read FPort write FPort;                            // Port (usualy 110)
    property Host: String read FHost write FHost;                             // Host address
    property MailMessage: TMailMessage2000 read FMailMessage write FMailMessage;  // Message retrieved
    property TimeOut: Integer read GetTimeOut write SetTimeOut;               // Max time to wait for server reply in seconds
    property OnProgress: TProgressEvent read GetProgress write SetProgress;   // Occurs when receiving data from server
    property DeleteOnRetrieve: Boolean read FDeleteOnRetrieve write FDeleteOnRetrieve;  // If message will be deleted after successful retrieve
  end;

  { TSMTP2000 }

  TSMTP2000 = class(TComponent)
  private

    FMailMessage: TMailMessage2000;

    FSessionConnected: Boolean;
    FSocketTalk: TSocketTalk;
    FPacketSize: Integer;

    FPort: Integer;
    FHost: String;

    procedure EndOfData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
    procedure SocketTalkError(Sender: TObject; SessionState: TSessionState; TalkError: TTalkError);
    procedure ReceiveData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
    procedure SocketDisconnect(Sender: TObject);

    function GetTimeOut: Integer;
    procedure SetTimeOut(Value: Integer);

    function GetProgress: TProgressEvent;
    procedure SetProgress(Value: TProgressEvent);

    function GetLastResponse: String;

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Connect: Boolean;                                                // Connect to mail server
    function Quit: Boolean;                                                   // Disconnect

    procedure Abort;                                                          // Force disconnect

    function SendMessage: Boolean;                                            // Send MailMessage to server
    function SendMessageTo(const From, Dests: String): Boolean;               // Send MailMessage to specified recipients
    function SendStringTo(const Msg, From, Dests: String): Boolean;           // Send string to specified recipients

    property SessionConnected: Boolean read FSessionConnected;                // True if conencted to server
    property LastResponse: String read GetLastResponse;                       // Last string received from server

  published

    property Port: Integer read FPort write FPort;                            // Port (usualy 25)
    property Host: String read FHost write FHost;                             // Host address
    property TimeOut: Integer read GetTimeOut write SetTimeOut;               // Max time to wait for a response in seconds
    property MailMessage: TMailMessage2000 read FMailMessage write FMailMessage;  // Message to send
    property PacketSize: Integer read FPacketSize write FPacketSize;          // Size of packets to send to server
    property OnProgress: TProgressEvent read GetProgress write SetProgress;   // Occurs when sending data to server
  end;

procedure Register;

{ Very useful functions ====================================================== }

function DecodeLine7Bit(Texto: String): String; forward;
function DecodeLine7Bit_m(s: String): String;
function EncodeLine7Bit(Texto, Charset: String): String; forward;


function DecodeQuotedPrintable(const Texto: String): String; forward;

function EncodeQuotedPrintable(Texto: String; HeaderLine: Boolean): String; forward;
function DecodeUUCODE(Encoded: PChar; Decoded: TMemoryStream): Boolean; forward;
function DecodeLineUUCODE(const Buffer: String; Decoded: PChar): Integer; forward;
function DecodeLineBASE64(const Buffer: String; Decoded: PChar): Integer; forward;
function EncodeBASE64(Encoded: TMemoryStream {TMailText}; Decoded: TMemoryStream): Integer; forward;
function NormalizeLabel(Texto: String): String; forward;
function LabelValue(cLabel: String): String; forward;
function WriteLabelValue(cLabel, Value: String): String; forward;
function LabelParamValue(cLabel, cParam: String): String; forward;
function WriteLabelParamValue(cLabel, cParam, Value: String): String; forward;
function GetTimeZoneBias: Double; forward;
function PadL(const Str: String; const Tam: Integer; const PadStr: String): String; forward;
function GetMimeType(const FileName: String): String; forward;
function GetMimeExtension(const MimeType: String): String; forward;
function GenerateBoundary: String; forward;
function SearchStringList(Lista: TStringList; const Chave: String; const Occorrence: Integer = 0): Integer; forward;
procedure DataLine(var Data, Line: String; var nPos: Integer); forward;
procedure DataLinePChar(const Data: PChar; const TotalLength: Integer; var LinePos, LineLen: Integer; var Line: PChar; var DataEnd: Boolean); forward;
function IsIPAddress(const SS: String): Boolean; forward;
function TrimSpace(const S: string): string; forward;
function TrimLeftSpace(const S: string): string; forward;
function TrimRightSpace(const S: string): string; forward;
function MailDateToDelphiDate(const DateStr: String): TDateTime; forward;
function DelphiDateToMailDate(const Date: TDateTime): String; forward;
function ValidFileName(FileName: String): String; forward;
function WrapHeader(Text: String): String; forward;

procedure save_to_file1(msg1:TMailMessage2000;fn1:string);

const
  //clq 扩展的标志//例子为 X-Clq: yes; half="yes"; filename="1.bmp; v_filename="200307..."; index=0
  //函数调用为
  {
    Part.SetLabelValue(_CLQ_, _CLQ_YES);
    Part.SetLabelParamValue(_CLQ_, _CLQ_HALF, '"'+_CLQ_YES+'"');
    //下面是文件名,一般还要用EncodeLine7Bit处理,可放入多个文件名
    Part.SetLabelParamValue(_CLQ_, _CLQ_HALF_FILENAME, '"'+"1.bmp"+'"');

  }
  _CLQ_                   = 'X-Clq';
  _CLQ_YES                = 'yes';
  _CLQ_HALF               = 'half';           //大文件分块模式
  _CLQ_HALF_FILENAME      = 'filename';       //大文件分块模式  文件名
  _CLQ_HALF_VFILENAME     = 'v_filename';
  _CLQ_HALF_INDEX         = 'index';
  _CLQ_HALF_COUNT         = 'count';

  _CLQ_MMAIL              = 'mmail';          //存在此Param的话就是群发
  _CLQ_MMAIL_ADDRS        = 'X-Clq-mmail_addrs';    //群发邮件的地址表
  

implementation

uses clq_pub_pas1, clq_work_pub_pas1;

const
  _C_T  = 'Content-Type';
  _C_D  = 'Content-Disposition';
  _C_TE = 'Content-Transfer-Encoding';
  _C_ID = 'Content-ID';
  _C_L  = 'Content-Length';
  _CONT = 'Content-';
  _FFR  = 'From';
  _FRT  = 'Reply-To';
  _M_V  = 'Mime-Version';
  _M_ID = 'Message-ID';
  _X_M  = 'X-Mailer';

const
  _TXT  = 'text/';
  _T_P  = 'text/plain';
  _T_H  = 'text/html';
  _MP   = 'multipart/';
  _M_M  = 'multipart/mixed';
  _M_A  = 'multipart/alternative';
  _M_R  = 'multipart/related';
  _M_RP = 'multipart/report';
  _A_OS = 'application/octet-stream';
  _BDRY = 'boundary';
  _ATCH = 'attachment';
  _INLN = 'inline';

const
  _MIME_Msg = 'This is a multipart message in mime format.'#13#10;
//  _XMailer  = 'Mail2000 1.9 beta http://groups.yahoo.com/group/tmail2000';
  _XMailer  = 'Mail2000 [clq modify 2018 https://github.com/clqsrc/delphi_lost] 1.9 beta http://groups.yahoo.com/group/tmail2000';
  _TXTFN    = 'textpart.txt';
  _HTMLFN   = 'textpart.htm';
  _CHARSET  = 'GB2312'; //英文版本应该是'iso-8859-1';//以后可以改用screen.font.Charset来算出来
  _DATAEND1 = #13#10'.'#13#10;
  _DATAEND2 = #13#10'..'#13#10;
  _LINELEN  = 72;

procedure Register;
begin

  RegisterComponents('clq', [TPOP2000, TSMTP2000, TMailMessage2000]);
end;
  
//clq 这里应该是解码标题等的东东
//对应函数为 EncodeLine7Bit
// Decode an encoded field e.g. =?iso-8859-1?x?xxxxxx=?=
{
clq:对于日文的系统中 X-Mailer: Microsoft Outlook Express 6.00.2462.0000的情况下可能有
Subject: =?utf-8?B?5YWz5LqO5LuK5aSp55qE5bel5L2c?=
这样是字符串无法正确显示

所以要加以修正
}

function DecodeLine7Bit_old(Texto: String): String;
var
  Buffer: PChar;
  Encoding: Char;
  Size: Integer;
  nPos0: Integer;
  nPos1: Integer;
  nPos2: Integer;
  nPos3: Integer;
  Found: Boolean;
  //clq   
  old1:string;
  clq_get1:boolean;
  //clq_end;

begin
      
  //clq   
  old1:=Texto;
  clq_get1:=false;
  //clq_end;

  Result := TrimSpace(Texto);

  repeat

    nPos0 := Pos('=?', Result);
    Found := False;

    if nPos0 > 0 then
    begin

      nPos1 := Pos('?', Copy(Result, nPos0+2, Length(Result)))+nPos0+1;
      nPos2 := Pos('?=', Copy(Result, nPos1+1, Length(Result)))+nPos1;
      nPos3 := Pos('?', Copy(Result, nPos2+1, Length(Result)))+nPos2;

      if nPos3 > nPos2 then
      begin

        if Length(Result) > nPos3 then
        begin

          if Result[nPos3+1] = '=' then
          begin

            nPos2 := nPos3;
          end;
        end;
      end;

      if (nPos1 > nPos0) and (nPos2 > nPos1) then
      begin

        Texto := Copy(Result, nPos1+1, nPos2-nPos1-1);

        if (Length(Texto) >= 2) and (Texto[2] = '?') and (UpCase(Texto[1]) in ['B', 'Q', 'U']) then
        begin

          Encoding := UpCase(Texto[1]);
        end
        else
        begin

          Encoding := 'Q';
        end;

        Texto := Copy(Texto, 3, Length(Texto)-2);

        case Encoding of

          'B':
          begin

            GetMem(Buffer, Length(Texto));
            Size := DecodeLineBASE64(Texto, Buffer);
            Buffer[Size] := #0;
            Texto := String(Buffer);
          end;

          'Q':
          begin

            while Pos('_', Texto) > 0 do
              Texto[Pos('_', Texto)] := #32;
                                              
            //当字符串中含有?号和=号等并同时含有中文时,这里的作为输入的Texto是错误的,应当另外取给它
            //clq //我的算法也有漏洞,不过相对好一些
            Texto := str1.get_value1(old1,'Q?'); //先取=?GB2312?Q?=D6=D0=CE=C4??=中=?GB2312?Q?之后的
            //Texto := str1.get_value1(Texto,'','?=');  //再取实际由QuotedPrintable组成的字符串
            Texto := copy(Texto,1,length(Texto)-2);
            clq_get1:=true;
            //clq_end;
            Texto := DecodeQuotedPrintable(Texto);
          end;

          'U':
          begin

            GetMem(Buffer, Length(Texto));
            Size := DecodeLineUUCODE(Texto, Buffer);
            Buffer[Size] := #0;
            Texto := String(Buffer);
          end;
        end;

        Result := Copy(Result, 1, nPos0-1)+Texto+Copy(Result,nPos2+2,Length(Result));
        //clq
        if clq_get1 then Result := Texto;
        //clq_end;
        Found := True;
      end;
    end;

  until not Found;

  //clq//这样可以解决utf8编码的标题
  if pos('?utf-8',lowercase(old1))<>0
   then result:=utf8toansi(result);
end;

function RightPosEx(const Substr,S: string): Integer; //来自 http://tech.ccidnet.com/art/1079/20060110/411587_1.html
var 
  iPos: Integer;
  TmpStr:string;
  i,j,len: Integer;
  PCharS,PCharSub:PChar;
begin 
  PCharS:=PChar(s); //将字符串转化为PChar格式
  PCharSub:=PChar(Substr);
  Result:=0;
  len:=length(Substr);
  for i:=0 to length(S)-1 do
  begin
    for j:=0 to len-1 do
    begin
      if PCharS[i+j]<>PCharSub[j] then break;
    end;
    if j=len then Result:=i+1;
  end;  
end;

// Decode an encoded field e.g. =?iso-8859-1?x?xxxxxx=?=
//按道理应当按代码原意进行修改,不过我们这样修改后更容易于维护及扩展[主要是字符集的支持]
function DecodeLine7Bit(Texto: String): String;
var
  Buffer: PChar;
  Encoding: Char;
  sCharset: string;//字符集
  Size: Integer;
  nPos_b: Integer;
  nPos_e: Integer;
  nPos1: Integer;
  nPos2: Integer;
  nPos3: Integer;

  prop1, prop2:string;//这个字符串的属性,可能是字符集或编码方式,顺序并不固定

begin
  Result := DecodeLine7Bit_m(Texto); Exit; //clq 2018/12/9 

  Result := TrimSpace(Texto);

  sCharset:='';

  //repeat

    nPos_b := Pos('=?', Result);
    nPos_e := length(Result)-2; //先假定后面两个字符就是'?='//StrUtils//Pos('?=', Result);

    //查找'?='的位置,其实应当用rigthpos函数
    //if StrUtils.RightBStr(result, 2)='?='
    {
    if StrUtils.RightStr(result, 2)='?='
    then result:=copy(result, 1, Length(Result)-2)
    else nPos_e:=0;//不存在'?='
    }

    nPos_e:=RightPosEx('?=', Result);

    //if nPos0 > 0 then
    if (nPos_b > 0)and(nPos_e > nPos_b) then
    begin

      nPos1 := PosEx('?', Result, nPos_b+2);//再查找的位置要加上'?='的长度

      if nPos1 > 0
      then nPos2 := PosEx('?', Result, nPos1+1)//再查找的位置要加上'?'的长度
      else nPos2 := 0;//不存在


      if (nPos1 > 0) and (nPos2 > nPos1) then
      begin

        prop1 := Copy(Result, nPos_b+2, nPos1-nPos_b-2);
        prop2 := Copy(Result, nPos1+1, nPos2-nPos1-1);
        Texto := Copy(Result, nPos2+1, Length(Result)-nPos2-2);

        //长度为1的属性值为编码方式,另一个就应当是字符集了
        if (Length(prop1) = 1) then
        begin
          Encoding := UpCase(prop1[1]);
          sCharset:=prop2;
        end
        else
        begin
          Encoding := UpCase(prop2[1]);
          sCharset:=prop1;
        end;

          //都不是的话就默认用这个解码
          //用默认不太好,如果它根本就没编码的话//Encoding := 'Q';

        case Encoding of

          'B':
          begin

            GetMem(Buffer, Length(Texto));
            Size := DecodeLineBASE64(Texto, Buffer);
            Buffer[Size] := #0;
            Texto := String(Buffer);
          end;

          'Q':
          begin

            while Pos('_', Texto) > 0 do
              Texto[Pos('_', Texto)] := #32;

            Texto := DecodeQuotedPrintable(Texto);
          end;

          'U':
          begin

            GetMem(Buffer, Length(Texto));
            Size := DecodeLineUUCODE(Texto, Buffer);
            Buffer[Size] := #0;
            Texto := String(Buffer);
          end;
        end;

        //Result := Copy(Result, 1, nPos0-1)+Texto+Copy(Result,nPos2+2,Length(Result));
        Result := Texto;
      end;
    end;

  //until not Found;

  //clq//这样可以解决utf8编码的标题
  if pos('utf-8',lowercase(sCharset))<>0
    then result:=utf8toansi(result);

  if pos('big5',lowercase(sCharset))<>0
    then result:=BIG5toGB(result);
end;


// Encode a header field e.g. =?iso-8859-1?x?xxxxxx=?=

function EncodeLine7Bit(Texto, Charset: String): String;
var
  Loop: Integer;
  Encode: Boolean;
begin

  Encode := False;

  for Loop := 1 to Length(Texto) do
    if (Ord(Texto[Loop]) > 127) or (Ord(Texto[Loop]) < 32) then
    begin

      Encode := True;
      Break;
    end;

  if Encode then
    Result := '=?'+Charset+'?Q?'+EncodeQuotedPrintable(Texto, True)+'?='
  else
    Result := Texto;
end;

function EncodeLineBASE64(Texto, Charset: String): String;
//clq 2004.5.26//因为Q的编码在mail2000上有一些问题,所以尽量用base64
//仿造EncodeLine7Bit而来
var
  Loop: Integer;
  Encode: Boolean;
begin

  Encode := False;

  for Loop := 1 to Length(Texto) do
    if (Ord(Texto[Loop]) > 127) or (Ord(Texto[Loop]) < 32) then
    begin

      Encode := True;
      Break;
    end;

  if Encode then
    Result := '=?'+Charset+'?B?'+base64encode1(Texto)+'?='
  else
    Result := Texto;
end;

// Decode a quoted-printable encoded string


//clq 参考了一个c语言的算法//忘记在哪看到的了，似乎是 https://bbs.csdn.net/topics/110165494
(*
int DecodeQuoted(const char* pSrc, unsigned char* pDst, int nSrcLen)
{
    int nDstLen;        // 输出的字符计数
    int i;

    i = 0;
    nDstLen = 0;

    while (i < nSrcLen)
    {
        if (strncmp(pSrc, "=\r\n", 3) == 0)        // 软回车，跳过
        {
            pSrc += 3;
            i += 3;
        }
        else
        {
            if (*pSrc == '=')        // 是编码字节
            {
                sscanf(pSrc, "=%02X", pDst);
                pDst++;
                pSrc += 3;
                i += 3;
            }
            else        // 非编码字节
            {
                *pDst++ = (unsigned char)*pSrc++;
                i++;
            }

            nDstLen++;
        }
    }

    // 输出加个结束符
    *pDst = '\0';

    return nDstLen;
}
将解码之后的数据用mbstocws成unicode即可
有中文的话需要先调用setlocale(LC_ALL,"chs");
*)
function DecodeQuoted(pSrc:pchar):string;
var
    nDstLen:integer;        // 输出的字符计数
    i:integer;
    Dst:string;
    pDst:pchar;
    nSrcLen:integer;
    b : Byte;
    Hex:string;

begin
    i := 0;
    nDstLen := 0;
    nSrcLen := length(pSrc);
    setlength(Dst, nSrcLen);//先分配空间
    pDst := pchar(Dst);

    while (i < nSrcLen) do
    begin
        //if (strncmp(pSrc, "=\r\n", 3) == 0)        // 软回车，跳过
        if (StrLComp(pSrc, '='#13#10, 3) = 0) then        // 软回车，跳过
        begin
            pSrc := pSrc+3;
            i := i+3;
        end
        else
        if (StrLComp(pSrc, '='#13, 2) = 0) then        // 软回车，跳过
        begin
            pSrc := pSrc+2;
            i := i+2;
        end
        else
        if (StrLComp(pSrc, '='#10, 2) = 0) then        // 软回车，跳过
        begin
            pSrc := pSrc+2;
            i := i+2;
        end
        else
        begin
            //if (pSrc[0] = '=') then        // 是编码字节
            //if (pSrc[0] = '=')and(StrToIntDef('$'+pSrc[1]+pSrc[2], -1)<>-1) then        // 是编码字节
            //注意容错,字符串长度,是否可转换等
            if (pSrc[0] = '=')and(StrToIntDef('$'+pSrc[1]+pSrc[2], -1)<>-1)and(i+2 < nSrcLen) then
            begin
                //sscanf(pSrc, "=%02X", pDst);
                //sscanf(pSrc, "=%02X", pDst);
                //pDst++;
                Hex := pSrc[1]+pSrc[2];
                b := StrToInt('$'+Hex);
                pDst^ := char(b);
                pDst := pDst+1;
                pSrc := pSrc+3;
                i := i+3;
            end
            else        // 非编码字节
            begin
                pDst^ := pSrc^;
                pDst := pDst+1;
                pSrc := pSrc+1;
                i := i+1;
            end
            //nDstLen := nDstLen+1;
        end;
    end;
    // 输出加个结束符
    pDst^ := #0;
    //return nDstLen;
    //result := Dst;
    result := pchar(Dst);//一定要这样，去掉后面的多余字符
end;
 
 
//clq modify
function DecodeQuotedPrintable(const Texto: String): String;
var
  b : Byte;
  next_c : char;
  c,c1,c2,c3:char;
  Hex:string;
  i1:integer;
  sl1:tstringlist;
  len1:integer;
begin

  result:=DecodeQuoted(pchar(Texto));exit;

  //Texto:=stringreplace(texto, '='#13, '', [rfReplaceAll]);
  //Texto:=stringreplace(texto, '='#10, '', [rfReplaceAll]);

  c:=#0;c1:=#0;c2:=#0;c3:=#0;
  len1:=length(texto);
  for i1:=1 to len1 do
  begin
    c:=texto[i1];
    if (c=#10)or(c=#13) then continue;//回车换行不算

    if i1<>len1 then//最后一个字符当然不用判断了
    begin
      next_c:=texto[i1+1];
      if ((next_c=#10)or(next_c=#13)) and (c='=') then continue;//每行最后的一个‘=’号也不算//ibm的邮件中有很多这种情况
    end;  

    if (c1=#0) then
    begin
      c1:=c;//第一个字符，如果一直没得到处理的话，最后的结果是要加上它的
      continue;
    end;
    if (c2=#0) then
    begin
      c2:=c;//第一个字符，如果一直没得到处理的话，最后的结果是要加上它的
      continue;
    end;
    if (c3=#0) then
    begin
      c3:=c;
      //continue;
    end;

    if (c1='=')and(c2 in ['0'..'9','a'..'f','A'..'F'])and(c3 in ['0'..'9','a'..'f','A'..'F']) then
    begin//转换
      Hex:=c2+c3;
      b := StrToInt('$'+Hex);
      //if b>126
      //then result:=result+char(b)
      //else result:=result+c1+c2+c3;
      result:=result+char(b);

      c1:=#0;c2:=#0;c3:=#0;
    end
    else//不转换
    begin
      if (c2='=')and(c3 in ['0'..'9','a'..'f','A'..'F']) then
      begin
        c1:=c2;
        c2:=c3;
        c3:=#0;
      end
      else if (c3='=') then
      begin
        c1:=c3;
        c2:=#0;
        c3:=#0;
      end
      else
      begin
        result:=result+c1+c2+c3;
        c1:=#0;c2:=#0;c3:=#0;
      end;
    end;

  end;

  //----------------------------------------------------------------------------
  //最后可能还剩有字符
    if (c1<>#0) then
    begin
      result:=result+c1;
    end;
    if (c2<>#0) then
    begin
      result:=result+c2;
    end;
    

  //showmessage(result);
  result:=result+'';
end;

function DecodeQuotedPrintable_old(Texto: String): String;//这个函数实在是太慢了
var
  nPos: Integer;
  nLastPos: Integer;
  lFound: Boolean;

begin

  Result := Texto;

  lFound := True;
  nLastPos := 0;

  while lFound do
  begin

    lFound := False;

    if nLastPos < Length(Result) then
      nPos := Pos('=', Copy(Result, nLastPos+1, Length(Result)-nLastPos))+nLastPos
    else
      nPos := 0;

    if (nPos < (Length(Result)-1)) and (nPos > nLastPos) then
    begin

      if (Result[nPos+1] in ['A'..'F', '0'..'9']) and (Result[nPos+2] in ['A'..'F', '0'..'9']) then
      begin

        Insert(Char(StrToInt('$'+Result[nPos+1]+Result[nPos+2])), Result, nPos);
        Delete(Result, nPos+1, 3);
      end
      else
      begin

        if (Result[nPos+1] = #13) and (Result[nPos+2] = #10) then
        begin

          Delete(Result, nPos, 3);
          Dec(nPos, 3);
        end
        else
        begin

          if (Result[nPos+1] = #10) and (Result[nPos+2] = #13) then
          begin

            Delete(Result, nPos, 3);
            Dec(nPos, 3);
          end
          else
          begin

            if (Result[nPos+1] = #13) and (Result[nPos+2] <> #10) then
            begin

              Delete(Result, nPos, 2);
              Dec(nPos, 2);
            end
            else
            begin

              if (Result[nPos+1] = #10) and (Result[nPos+2] <> #13) then
              begin

                Delete(Result, nPos, 2);
                Dec(nPos, 2);
              end;
            end;
          end;
        end;
      end;

      lFound := True;
      nLastPos := nPos;
    end
    else
    begin

      if nPos = Length(Result) then
      begin

        Delete(Result, nPos, 1);
      end;
    end;
  end;
end;

// Encode a string in quoted-printable format

function EncodeQuotedPrintable(Texto: String; HeaderLine: Boolean): String;
var
  nPos: Integer;
  LineLen: Integer;

begin

  Result := '';
  LineLen := 0;

  for nPos := 1 to Length(Texto) do
  begin

    if (Texto[nPos] > #127) or
       (Texto[nPos] = '=') or
       ((Texto[nPos] <= #32) and HeaderLine) or
       ((Texto[nPos] in ['"', '_']) and HeaderLine) then
    begin

      Result := Result + '=' + PadL(Format('%2x', [Ord(Texto[nPos])]), 2, '0');
      Inc(LineLen, 3);
    end
    else
    begin

      Result := Result + Texto[nPos];
      Inc(LineLen);
    end;

    if Texto[nPos] = #13 then LineLen := 0;

    if (LineLen >= _LINELEN) and (not HeaderLine) then
    begin

      Result := Result + '='#13#10;
      LineLen := 0;
    end;
  end;
end;

// Decode an UUCODE encoded line

function DecodeLineUUCODE(const Buffer: String; Decoded: PChar): Integer;
const
	CHARS_PER_LINE = 45;
	Table: String = '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';

var
	A24Bits: array[0..8 * CHARS_PER_LINE] of Boolean;
	i, j, k, b: Word;
	LineLen, ActualLen: Byte;

	function p_ByteFromTable(Ch: Char): Byte;
	var
		ij: Integer;
	begin

		ij := Pos(Ch, Table);

		if (ij > 64) or (ij = 0) then
		begin
			if Ch = #32 then
				Result := 0 else
				raise Exception.Create('UUCODE message format error');
		end else
			Result := ij - 1;
	end;

begin

  if Buffer = '' then
  begin

    Result := 0;
    Exit;
  end;

	LineLen := p_ByteFromTable(Buffer[1]);
	ActualLen := 4 * LineLen div 3;

	FillChar(A24Bits, 8 * CHARS_PER_LINE + 1, 0);
	Result := LineLen;

	if ActualLen <> (4 * CHARS_PER_LINE div 3) then
		ActualLen := Length(Buffer) - 1;

	k := 0;
	for i := 2 to ActualLen + 1 do
	begin
		b := p_ByteFromTable(Buffer[i]);
		for j := 5 downto 0 do
		begin
			A24Bits[k] := b and (1 shl j) > 0;
			Inc(k);
		end;
	end;

	k := 0;
	for i := 1 to CHARS_PER_LINE do
	begin
		b := 0;
		for j := 7 downto 0 do
		begin
			if A24Bits[k] then b := b or (1 shl j);
			Inc(k);
		end;
		Decoded[i-1] := Char(b);
	end;
end;

// Decode an UUCODE text

function DecodeUUCODE(Encoded: PChar; Decoded: TMemoryStream): Boolean;
var
  nTL, nPos, nLen: Integer;
  Line: PChar;
  LineDec: array[0..79] of Char;
  LineLen: Integer;
  DataEnd: Boolean;

begin

  Decoded.Clear;

  DataEnd := False;
  nPos := -1;
  nTL := StrLen(Encoded);

  DataLinePChar(Encoded, nTL, nPos, nLen, Line, DataEnd);

  while not DataEnd do
  begin

    if nLen > 0 then
    begin

      LineLen := DecodeLineUUCODE(String(Line), LineDec);

      if LineLen > 0 then
        Decoded.Write(LineDec[0], LineLen);
    end;

    DataLinePChar(Encoded, nTL, nPos, nLen, Line, DataEnd);
  end;

  Result := True;
end;

// Decode a BASE64 encoded line

function DecodeLineBASE64(const Buffer: String; Decoded: PChar): Integer;
var
  A1: array[1..4] of Byte;
  B1: array[1..3] of Byte;
  I, J: Integer;
  BytePtr, RealBytes: Integer;

begin

  BytePtr := 0;
  Result := 0;

  for J := 1 to Length(Buffer) do
  begin

    Inc(BytePtr);

    case Buffer[J] of

      'A'..'Z': A1[BytePtr] := Ord(Buffer[J])-65;

      'a'..'z': A1[BytePtr] := Ord(Buffer[J])-71;

      '0'..'9': A1[BytePtr] := Ord(Buffer[J])+4;

      '+': A1[BytePtr] := 62;

      '/': A1[BytePtr] := 63;

      '=': A1[BytePtr] := 64;
    end;

    if BytePtr = 4 then
    begin

      BytePtr := 0;
      RealBytes := 3;

      if A1[1] = 64 then RealBytes:=0;

      if A1[3] = 64 then
      begin

        A1[3] := 0;
        A1[4] := 0;
        RealBytes := 1;
      end;

      if A1[4] = 64 then
      begin

        A1[4] := 0;
        RealBytes := 2;
      end;

      B1[1] := A1[1]*4 + (A1[2] div 16);
      B1[2] := (A1[2] mod 16)*16+(A1[3] div 4);
      B1[3] := (A1[3] mod 4)*64 + A1[4];

      for I := 1 to RealBytes do
      begin

        Decoded[Result+I-1] := Chr(B1[I]);
      end;

      Inc(Result, RealBytes);
    end;
  end;
end;

// Padronize header labels; remove double spaces, decode quoted text, lower the cases, indentify mail addresses

function NormalizeLabel(Texto: String): String;
var
  Quote: Boolean;
  Quoted: String;
  Loop: Integer;
  lLabel: Boolean;
  sLabel: String;
  Value: String;

begin

  Quote := False;
  lLabel := True;
  Value := '';
  sLabel := '';

  for Loop := 1 to Length(Texto) do
  begin

    if (Texto[Loop] = '"') and (not lLabel) then
    begin

      Quote := not Quote;

      if Quote then
      begin

        Quoted := '';
      end
      else
      begin

        Value := Value + Quoted;
      end;
    end;

    if not Quote then
    begin

      if lLabel then
      begin

        if (sLabel = '') or (sLabel[Length(sLabel)] = '-') then
          sLabel := sLabel + UpCase(Texto[Loop])
        else
          if (Copy(sLabel, Length(sLabel)-1, 2) = '-I') and (UpCase(Texto[Loop]) = 'D') and
             (Loop < Length(Texto)) and (Texto[Loop+1] = ':') then
            sLabel := sLabel + 'D'
          else
            sLabel := sLabel + LowerCase(Texto[Loop]);

        if Texto[Loop] = ':' then
        begin

          lLabel := False;
          Value := '';
        end;
      end
      else
      begin

        if Texto[Loop] = #32 then
        begin

          Value := TrimRightSpace(Value) + #32;
        end
        else
        begin

          Value := Value + Texto[Loop];
        end;
      end;
    end
    else
    begin

      Quoted := Quoted + Texto[Loop];
    end;
  end;

  Result := TrimSpace(sLabel)+' '+TrimSpace(Value);
end;

// Return the value of a label; e.g. Label: value

function LabelValue(cLabel: String): String;
var
  Loop: Integer;
  Quote: Boolean;
  Value: Boolean;
  Ins: Boolean;

begin

  Quote := False;
  Value := False;
  Result := '';

  for Loop := 1 to Length(cLabel) do
  begin

    Ins := True;

    if cLabel[Loop] = '"' then
    begin

      Quote := not Quote;
//    Ins := False;
    end;

    if not Quote then
    begin

      if (cLabel[Loop] = ':') and (not Value) then
      begin

        Value := True;
        Ins := False;
      end
      else
      begin

        if (cLabel[Loop] = ';') and Value then
        begin

          Break;
        end;
      end;
    end;

    if Ins and Value then
    begin

      Result := Result + cLabel[Loop];
    end;
  end;

  Result := TrimSpace(Result);

  if (Copy(Result, 1, 1) = '"') and (Copy(Result, Length(Result), 1) = '"') then
    Result := Copy(Result, 2, Length(Result)-2);
end;

// Set the value of a label;

function WriteLabelValue(cLabel, Value: String): String;
var
  Loop: Integer;
  Quote: Boolean;
  ValPos, ValLen: Integer;

begin

  Quote := False;
  ValPos := 0;
  ValLen := -1;

  for Loop := 1 to Length(cLabel) do
  begin

    if cLabel[Loop] = '"' then
    begin

      Quote := not Quote;
    end;

    if not Quote then
    begin

      if (cLabel[Loop] = ':') and (ValPos = 0) then
      begin

        ValPos := Loop+1;
      end
      else
      begin

        if (cLabel[Loop] = ';') and (ValPos > 0) then
        begin

          ValLen := Loop - ValPos;
          Break;
        end;
      end;
    end;
  end;

  Result := cLabel;

  if (ValLen < 0) and (ValPos > 0) then
    ValLen := Length(cLabel) - ValPos + 1;

  if ValPos > 0 then
  begin

    Delete(Result, ValPos, ValLen);
    Insert(' '+TrimSpace(Value), Result, ValPos);
  end;
end;

// Return the value of a label parameter; e.g. Label: xxx; param=value

function LabelParamValue(cLabel, cParam: String): String;
var
  Loop: Integer;
  Quote: Boolean;
  Value: Boolean;
  Params: Boolean;
  ParamValue: Boolean;
  Ins: Boolean;
  Param: String;

begin

  Quote := False;
  Value := False;
  Params := False;
  ParamValue := False;

  Param := '';
  Result := '';

  cLabel := TrimSpace(cLabel);

  if Copy(cLabel, Length(cLabel), 1) <> ';' then cLabel := cLabel + ';';

  for Loop := 1 to Length(cLabel) do
  begin

    Ins := True;

    if cLabel[Loop] = '"' then
    begin

      Quote := not Quote;
//    Ins := False;
    end;

    if not Quote then
    begin

      if (cLabel[Loop] = ':') and (not Value) and (not Params) then
      begin

        Value := True;
        Params := False;
        ParamValue := False;
        Ins := False;
      end
      else
      begin

        if (cLabel[Loop] = ';') and (Value or Params) then
        begin

          Params := True;
          Value := False;
          ParamValue := False;
          Param := '';
          Ins := False;
        end
        else
        begin

          if (cLabel[Loop] = '=') and Params then
          begin

            ParamValue := UpperCase(TrimSpace(Param)) = UpperCase(TrimSpace(cParam));
            Ins := False;
            Param := '';
          end;
        end;
      end;
    end;

    if Ins and ParamValue then
    begin

      Result := Result + cLabel[Loop];
    end;

    if Ins and (not ParamValue) and Params then
    begin

      Param := Param + cLabel[Loop];
    end;
  end;

  Result := TrimSpace(Result);

  if (Copy(Result, 1, 1) = '"') and (Copy(Result, Length(Result), 1) = '"') then
    Result := Copy(Result, 2, Length(Result)-2);
end;

// Set the value of a label parameter;

function WriteLabelParamValue(cLabel, cParam, Value: String): String;
var
  Loop: Integer;
  Quote: Boolean;
  LabelValue: Boolean;
  Params: Boolean;
  ValPos, ValLen: Integer;
  Ins: Boolean;
  Param: String;

begin

  Quote := False;
  LabelValue := False;
  Params := False;
  ValPos := 0;
  ValLen := -1;

  Param := '';
  Result := '';

  cLabel := TrimSpace(cLabel);

  if cLabel[Length(cLabel)] <> ';' then
    cLabel := cLabel + ';';

  for Loop := 1 to Length(cLabel) do
  begin

    Ins := True;

    if cLabel[Loop] = '"' then
    begin

      Quote := not Quote;
//    Ins := False;
    end;

    if not Quote then
    begin

      if (cLabel[Loop] = ':') and (not LabelValue) and (not Params) then
      begin

        LabelValue := True;
        Params := False;
        ValPos := 0;
        ValLen := 0;
        Ins := False;
      end
      else
      begin

        if (cLabel[Loop] = ';') and (LabelValue or Params) then
        begin

          if Params and (ValPos > 0) then
          begin

            ValLen := Loop - ValPos;
            Break;
          end;

          Params := True;
          LabelValue := False;
          Param := '';
          Ins := False;
        end
        else
        begin

          if (cLabel[Loop] = '=') and Params then
          begin

            if UpperCase(TrimSpace(Param)) = UpperCase(TrimSpace(cParam)) then
            begin

              ValPos := Loop+1;
              ValLen := 0;
            end;

            Ins := False;
            Param := '';
          end;
        end;
      end;
    end;

    if Ins and (ValPos = 0) and Params then
    begin

      Param := Param + cLabel[Loop];
    end;
  end;

  Result := cLabel;

  if Result[Length(Result)] = ';' then
    Delete(Result, Length(Result), 1);

  if ValPos = 0 then
  begin

    Result := TrimSpace(Result) + '; ' + TrimSpace(cParam) + '=' + TrimSpace(Value);
  end
  else
  begin

    if (ValLen < 0) and (ValPos > 0) then
      ValLen := Length(cLabel) - ValPos + 1;

    Delete(Result, ValPos, ValLen);
    Insert(TrimSpace(Value), Result, ValPos);
  end;
end;

//clq 原 GetTimeZoneBias 有问题，直接用二者时间差算出好了
function GetTimeZoneBias_v2: Double;
var
  SystemTime: TSystemTime;
  LocalTime: TSystemTime;
  tl:TDateTime;
  ts:TDateTime;
begin
  GetLocalTime(LocalTime);     //本地时间
  GetSystemTime(SystemTime);   //GetSystemTime:所返回的是UTC

  tl := EncodeTime(LocalTime.wHour, LocalTime.wMinute, LocalTime.wSecond, LocalTime.wMilliseconds);
  ts := EncodeTime(SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond, SystemTime.wMilliseconds);

  //DateUtils.HourSpan()
  //DateUtils.HoursBetween()
  //在两个TDATE时间值之间调用HurStun，以小时为单位获得差异。HourSpan不像HoursIntern函数那样只计算整个小时，它报告的不完整小时只是整个小时的一小部分

  //两个都不能用，因为那是绝对值

  Result := 24 * (tl - ts); //TDateTime 的差是天数，所以乘 24 就可追踪以得到小时数了. HourSpan 源码也是如此

end;  

// Return the Timezone adjust in days

function GetTimeZoneBias: Double;
var
  TzInfo: TTimeZoneInformation;

begin
  Result := GetTimeZoneBias_v2;

  //GetTimeZoneBias_v2 得到的是小时数，所以还要除以 24
  Result := Result / 24; // 2019/7/31 19:50:28

  //这个函数实际上是得到 delphi 的小时数值的表示
  //1 就表示 24 个小时，所以要得到 8 小时的 delphi tdatetime 值就是 8 除以 24


  Exit; //clq

  case GetTimeZoneInformation(TzInfo) of

    1: Result := - (TzInfo.StandardBias + TzInfo.Bias) / (24*60);

    2: Result := - (TzInfo.DaylightBias + TzInfo.Bias) / (24*60);

    else Result := 0;
  end;
end;



// Fills left of string with char

function PadL(const Str: String; const Tam: Integer; const PadStr: String): String;
var
  TempStr: String;

begin

  TempStr := TrimLeftSpace(Str);

  if Length(TempStr) <= Tam then
  begin

    while Length(TempStr) < Tam do
      TempStr := PadStr + TempStr;
  end
  else
  begin

    TempStr := Copy(TempStr, Length(TempStr) - Tam + 1, Tam);
  end;

  Result := TempStr;
end;

// Get mime type of a file extension

function GetMimeType(const FileName: String): String;
var
  Key: string;

begin

  Result := '';

  with TRegistry.Create do
    try

      RootKey := HKEY_CLASSES_ROOT;
      Key := ExtractFileExt(FileName);

      if KeyExists(Key) then
      begin

        OpenKey(Key, False);
        Result := ReadString('Content Type');
        CloseKey;
      end;

    finally

      if Result = '' then
        Result := _A_OS;

      Free;
    end;
end;

// Get file extension of a mime type

function GetMimeExtension(const MimeType: String): String;
var
  Key: string;

begin

  Result := '';

  with TRegistry.Create do
    try

      RootKey := HKEY_CLASSES_ROOT;

      if OpenKey('MIME\Database\Content Type', False) then
      begin

        Key := MimeType;

        if KeyExists(Key) then
        begin

          OpenKey(Key,false);
          Result := ReadString('Extension');
          CloseKey;
        end;
      end;

    finally

      Free;
    end;
end;

// Generate a random boundary

function GenerateBoundary: String;
begin

  Result := _BDRY+PadL(Format('%8x', [Random($FFFFFFFF)]), 8, '0');
end;

// Encode in base64

function EncodeBASE64(Encoded: TMemoryStream {TMailText}; Decoded: TMemoryStream): Integer;
const
  _Code64: String[64] =
    ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/');
var
  I: LongInt;
  B: array[0..2279] of Byte;
  J, K, L, M, Quads: Integer;
  Stream: string[76];
  EncLine: String;

begin

  Encoded.Clear;

  Stream := '';
  Quads := 0;
  J := Decoded.Size div 2280;

  Decoded.Position := 0;

  for I := 1 to J do
  begin

    Decoded.Read(B, 2280);

    for M := 0 to 39 do
    begin

      for K := 0 to 18 do
      begin

        L:= 57*M + 3*K;

        Stream[Quads+1] := _Code64[(B[L] div 4)+1];
        Stream[Quads+2] := _Code64[(B[L] mod 4)*16 + (B[L+1] div 16)+1];
        Stream[Quads+3] := _Code64[(B[L+1] mod 16)*4 + (B[L+2] div 64)+1];
        Stream[Quads+4] := _Code64[B[L+2] mod 64+1];

        Inc(Quads, 4);

        if Quads = 76 then
        begin

          Stream[0] := #76;
          EncLine := Stream+#13#10;
          Encoded.Write(EncLine[1], Length(EncLine));
          Quads := 0;
        end;
      end;
    end;
  end;

  J := (Decoded.Size mod 2280) div 3;

  for I := 1 to J do
  begin

    Decoded.Read(B, 3);

    Stream[Quads+1] := _Code64[(B[0] div 4)+1];
    Stream[Quads+2] := _Code64[(B[0] mod 4)*16 + (B[1] div 16)+1];
    Stream[Quads+3] := _Code64[(B[1] mod 16)*4 + (B[2] div 64)+1];
    Stream[Quads+4] := _Code64[B[2] mod 64+1];

    Inc(Quads, 4);

    if Quads = 76 then
    begin

      Stream[0] := #76;
      EncLine := Stream+#13#10;
      Encoded.Write(EncLine[1], Length(EncLine));
      Quads := 0;
    end;
  end;

  if (Decoded.Size mod 3) = 2 then
  begin

    Decoded.Read(B, 2);

    Stream[Quads+1] := _Code64[(B[0] div 4)+1];
    Stream[Quads+2] := _Code64[(B[0] mod 4)*16 + (B[1] div 16)+1];
    Stream[Quads+3] := _Code64[(B[1] mod 16)*4 + 1];
    Stream[Quads+4] := '=';

    Inc(Quads, 4);
  end;

  if (Decoded.Size mod 3) = 1 then
  begin

    Decoded.Read(B, 1);

    Stream[Quads+1] := _Code64[(B[0] div 4)+1];
    Stream[Quads+2] := _Code64[(B[0] mod 4)*16 + 1];
    Stream[Quads+3] := '=';
    Stream[Quads+4] := '=';
    Inc(Quads, 4);
  end;

  Stream[0] := Chr(Quads);

  if Quads > 0 then
  begin

    EncLine := Stream+#13#10;
    Encoded.Write(EncLine[1], Length(EncLine));
  end;

  Result := Encoded.Size;
end;

// Search in a StringList

function SearchStringList(Lista: TStringList; const Chave: String; const Occorrence: Integer = 0): Integer;
var
  nPos: Integer;
  lAchou: Boolean;
  Casas: Integer;
  Temp: String;
  nOccor: Integer;

begin

  Casas := Length(Chave);
  lAchou := False;
  nPos := 0;
  nOccor := 0;

  try

    if Lista <> nil then
    begin

      while (not lAchou) and (nPos < Lista.Count) do
      begin

        Temp := Lista[nPos];

        if UpperCase(Copy(Temp, 1, Casas)) = UpperCase(Chave) then
        begin

          if nOccor = Occorrence then
          begin

            lAchou := True;
          end
          else
          begin

            Inc(nOccor);
          end;
        end;

        if not lAchou then
          Inc(nPos);
      end;
    end;

  finally

    if lAchou then
      result := nPos
    else
      result := -1;
  end;
end;

// Search lines into a string

procedure DataLine(var Data, Line: String; var nPos: Integer);
begin

  Line := '';

  while True do
  begin

    Line := Line + Data[nPos];
    Inc(nPos);

    if nPos > Length(Data) then
    begin

      nPos := -1;
      Break;
    end
    else
    begin

      if Length(Line) >= 2 then
      begin

        if (Line[Length(Line)-1] = #13) and (Line[Length(Line)] = #10) then
        begin

          Break;
        end;
      end;
    end;
  end;
end;

// Search lines into a string
// I need to do in this confusing way in order to improve performance

procedure DataLinePChar(const Data: PChar; const TotalLength: Integer; var LinePos, LineLen: Integer; var Line: PChar; var DataEnd: Boolean); assembler;
begin

  if LinePos >= 0 then
  begin

    Data[LinePos+LineLen] := #13;
    LinePos := LinePos+LineLen+2;
    LineLen := 0;
  end
  else
  begin

    LinePos := 0;
    LineLen := 0;
  end;

  while (LinePos+LineLen) < TotalLength do
  begin

    if Data[LinePos+LineLen] = #13 then
    begin

      if (LinePos+LineLen+1) < TotalLength then
      begin

        if Data[LinePos+LineLen+1] = #10 then
        begin

          Data[LinePos+LineLen] := #0;
          Line := @Data[LinePos];
          Exit;
        end;
      end;
    end;

    Inc(LineLen);
  end;

  if LinePos < TotalLength then
    Line := @Data[LinePos]
  else
    DataEnd := True;
end;

// Determine if string is a numeric IP or not (Thanks to Hou Yg yghou@yahoo.com)

function IsIPAddress(const SS: String): Boolean;
var
  Loop: Integer;
  P: String;

begin

  Result := True;
  P := '';

  for Loop := 1 to Length(SS)+1 do
  begin

    if (Loop > Length(SS)) or (SS[Loop] = '.') then
    begin

      if StrToIntDef(P, -1) < 0 then
      begin

        Result := False;
        Break;
      end;

      P := '';
    end
    else
    begin

      P := P + SS[Loop];
    end;
  end;
end;

// Remove leading and trailing spaces from string
// Thanks to Yunarso Anang (yasx@hotmail.com)

function TrimSpace(const S: string): string;
var
  I, L: Integer;

begin

  L := Length(S);
  I := 1;

  while (I <= L) and (S[I] = ' ') do
    Inc(I);

  if I > L then Result := '' else
  begin

    while S[L] = ' ' do
      Dec(L);

    Result := Copy(S, I, L - I + 1);
  end;
end;

// Remove left spaces from string
// Thanks to Yunarso Anang (yasx@hotmail.com)

function TrimLeftSpace(const S: string): string;
var
  I, L: Integer;

begin

  L := Length(S);
  I := 1;

  while (I <= L) and (S[I] = ' ') do
    Inc(I);

  Result := Copy(S, I, Maxint);
end;

// Remove right spaces from string
// Thanks to Yunarso Anang (yasx@hotmail.com)

function TrimRightSpace(const S: string): string;
var
  I: Integer;

begin

  I := Length(S);

  while (I > 0) and (S[I] = ' ') do
    Dec(I);

  Result := Copy(S, 1, I);
end;

//clq  2018/12/8
//分割字符串 ExtractStrings
type
  TCmds = array[0..9] of string;

function DecodeCmds(s: String; sp :char):TCmds; //算法不好，临时用而已
var
  //s: String;
  List: TStringList;
  i:Integer;
begin
  //s := 'about: #delphi; #pascal, programming';
  List := TStringList.Create;
  //ExtractStrings([';',',',':'],['#',' '],PChar(s),List);
  //第一个参数是分隔符; 第二个参数是开头被忽略的字符

//  ShowMessage(List.Text);  //about
//                           //delphi
//                           //pascal
//                           //programming

  //ExtractStrings([' '],[],PChar(s),List);
  ExtractStrings([sp],[],PChar(s),List);
  //StringReplace(s, #9, ' ');//tab 要替换掉

  for i := 0 to List.Count-1 do
  begin
    Result[i] := List[i];

    if i>=9 then Break;
  end;

  List.Free;
end;

//clq 2018/12/8 原来的解码兼容性太差了
//最复杂的格式类似于 Date: Fri, 7 Dec 2018 14:42:17 +0800 (CST)
//其中根据 https://www.w3.org/Protocols/rfc822/#z28 或者 rfc5322 先要判断有无周日日期部分，然后再分割后面的就可以了
{
5. Date and Time Specification
5.1. SYNTAX

date-time   =  [ day "," ] date time        ; dd mm yy
                                            ;  hh:mm:ss zzz

day         =  "Mon"  / "Tue" /  "Wed"  / "Thu"
            /  "Fri"  / "Sat" /  "Sun"

date        =  1*2DIGIT month 2DIGIT        ; day month year
                                            ;  e.g. 20 Jun 82

month       =  "Jan"  /  "Feb" /  "Mar"  /  "Apr"
            /  "May"  /  "Jun" /  "Jul"  /  "Aug"
            /  "Sep"  /  "Oct" /  "Nov"  /  "Dec"

time        =  hour zone                    ; ANSI and Military

hour        =  2DIGIT ":" 2DIGIT [":" 2DIGIT]
                                            ; 00:00:00 - 23:59:59

zone        =  "UT"  / "GMT"                ; Universal Time
                                            ; North American : UT
            /  "EST" / "EDT"                ;  Eastern:  - 5/ - 4
            /  "CST" / "CDT"                ;  Central:  - 6/ - 5
            /  "MST" / "MDT"                ;  Mountain: - 7/ - 6
            /  "PST" / "PDT"                ;  Pacific:  - 8/ - 7
            /  1ALPHA                       ; Military: Z = UT;
                                            ;  A:-1; (J not used)
                                            ;  M:-12; N:+1; Y:+12
            / ( ("+" / "-") 4DIGIT )        ; Local differential
                                            ;  hours+min. (HHMM)

5.2. SEMANTICS
If included, day-of-week must be the day implied by the date specification.

Time zone may be indicated in several ways. "UT" is Universal Time (formerly called "Greenwich Mean Time"); "GMT" is permitted as a reference to Universal Time. The military standard uses a single character for each zone. "Z" is Universal Time. "A" indicates one hour earlier, and "M" indicates 12 hours earlier; "N" is one hour later, and "Y" is 12 hours later. The letter "J" is not used. The other remaining two forms are taken from ANSI standard X3.51-1975. One allows explicit indication of the amount of offset from UT; the other uses common 3-character strings for indicating time zones in North America. 
}
//所以 Fri, 7 Dec 2018 14:42:17 +0800 (CST) 可以分解为
//day_of_week = Fri
//day = 7
//month = Dec
//year = 2018
//time = 14:42:17
//TimeZone = +0800
//TimeZone_name = (CST)
//其中 TimeZone_name 应该是 rfc822 中的，而 rfc5322 应该是加了它的数字表示，也就是 TimeZone 部分
function MailDateToDelphiDate_v2(DateStr: String): TDateTime;
const
  Months: String = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,';

var
  Field, Loop: Integer;
  //Hour, Min, Sec, Year, Month, Day: Double;
  fHour, fMin, fSec, fYear, fMonth, fDay: Double;
  //sHour, sMin, sSec, sYear, sMonth, sDay, sTZ: String;
  sHour, sMin, sSec, sYear, sMonth, sDay: String;
  HTZM, MTZM: Word;
  STZM: Integer;
  TZM: Double;
  Final: Double;
  //day_of_week:string;
  dateField:tcmds;
  timeField:tcmds;

  day_of_week:string;
  day:string;
  month:string;
  year:string;
  time:string;
  TimeZone:string;
  TimeZone_name:string;

  hour, min, sec:string;

  mailTimeZone:Double;
  localTimeZone:Double;

begin

  sHour := '';
  sMin := '';
  sSec := '';
  sYear := '';
  sMonth := '';
  sDay := '';
  //sTZ := '';

  DateStr := StringReplace(DateStr, #9, ' ', [rfReplaceAll]); //tab 要替换掉
  DateStr := StringReplace(DateStr, '  ', ' ', [rfReplaceAll]); //简单合并一下多空格
  DateStr := StringReplace(DateStr, '  ', ' ', [rfReplaceAll]); //简单合并一下多空格

  //dateField := DecodeCmds(DateStr, ' ');
  dateField := DecodeCmds(DateStr, #32);

  day_of_week   := dateField[0];
  day           := dateField[1];
  month         := dateField[2];
  year          := dateField[3];
  time          := dateField[4];
  TimeZone      := dateField[5];
  TimeZone_name := dateField[6];

  timeField := DecodeCmds(time, ':');
  hour := timeField[0];
  min  := timeField[1];
  sec  := timeField[2];

  //--------------------------------------------------

  sDay := day;
  sMonth := month;
  sYear := year;
  sHour := hour;
  sMin := min;
  sSec := sec;
  //sTZ := TimeZone;


  fHour := StrToIntDef(sHour, 0);
  fMin := StrToIntDef(sMin, 0);
  fSec := StrToIntDef(sSec, 0);
  fYear := StrToIntDef(sYear, 0);
  fDay := StrToIntDef(sDay, 0);

  //if sMonth[1] in ['0'..'9'] then
  if (Length(sMonth)>0)and(sMonth[1] in ['0'..'9']) then
    fMonth := StrToIntDef(sMonth, 0)
  else
    fMonth := (Pos(sMonth, Months)-1) div 4 + 1;  //这也最个比较巧妙的算法，查找子字符串

    if fYear < 100 then  //应该是纠正 2000 年
    begin

      if fYear < 50 then
        fYear := 2000 + fYear
      else
        fYear := 1900 + fYear;
    end;

    if (fYear = 0) or (fMonth = 0) or (fDay = 0) then
    begin
      Result := 0;
      Exit;
    end;

//    else
//    begin
//

    Result := EncodeDate(Trunc(fYear), Trunc(fMonth), Trunc(fDay))
      + fHour*(1/24) + fMin*(1/24/60) + fSec*(1/24/60/60);

    if Length(TimeZone) = 0 then Exit; //可能没有时区

    //时区可能由两部分也可能由一部分组成,旧格式只有时区字符，很啰嗦，所以可以只考虑有新格式的情况
    if (TimeZone[1] in ['+', '-']) then
    begin
      mailTimeZone := StrToIntDef(TimeZone, 0);
      mailTimeZone := mailTimeZone * 0.01;
      localTimeZone := GetTimeZoneBias_v2();

      Result := Result - mailTimeZone / 24; //邮件时区时间要还原成 gmt 时间
      Result := Result + localTimeZone / 24; //加上当前时区的时间差就可以了//GetTimeZoneBias_v2 得到的是小时数，所以还要除以 24

    end
    else //旧格式，当作 gmt 处理就可以了
    begin
      Result := Result + GetTimeZoneBias_v2 / 24; //加上当前时区的时间差就可以了//GetTimeZoneBias_v2 得到的是小时数，所以还要除以 24
    end;

//      if (sTZ = 'GMT') or (Length(Trim(sTZ)) <> 5) then
//      begin
//
//        STZM := 1;
//        HTZM := 0;
//        MTZM := 0;
//      end
//      else
//      begin
//
//        STZM := StrToIntDef(Copy(sTZ, 1, 1)+'1', 1);
//        HTZM := StrToIntDef(Copy(sTZ, 2, 2), 0);
//        MTZM := StrToIntDef(Copy(sTZ, 4, 2), 0);
//      end;
//
//      try
//        //clq 2003.7.5 修正
//        if (Trunc(Year)=0)or (Trunc(Month)=0)or (Trunc(Day)=0) then
//        begin
//          Result := 0;
//          exit;
//        end;
//        //clq 2003.7.5 修正
//
//        TZM := EncodeTime(HTZM, MTZM, 0, 0)*STZM;
//        Final := EncodeDate(Trunc(Year), Trunc(Month), Trunc(Day));
//        Final := Final + Hour*(1/24) + Min*(1/24/60) + Sec*(1/24/60/60);
//        Final := Final - TZM + GetTimeZoneBias;
//
//        Result := Final;
//
//      except
//
//        Result := 0;
//      end;
//    end;

end;

// Convert date from message to Delphi format
// Returns zero in case of error

{
//clq 2003.7.5
这里的代码经常出错,以后要改进
}
function MailDateToDelphiDate(const DateStr: String): TDateTime;
const
  Months: String = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,';

var
  Field, Loop: Integer;
  Hour, Min, Sec, Year, Month, Day: Double;
  sHour, sMin, sSec, sYear, sMonth, sDay, sTZ: String;
  HTZM, MTZM: Word;
  STZM: Integer;
  TZM: Double;
  Final: Double;

begin

  Result := MailDateToDelphiDate_v2(DateStr); Exit;

  sHour := '';
  sMin := '';
  sSec := '';
  sYear := '';
  sMonth := '';
  sDay := '';
  sTZ := '';

  if DateStr <> '' then
  begin

    if DateStr[1] in ['0'..'9'] then
      Field := 1
    else
      Field := 0;

    for Loop := 1 to Length(DateStr) do
    begin

      if DateStr[Loop] in [#32, ':', '/'] then
      begin

        Inc(Field);
        if (Field = 6) and (DateStr[Loop] = #32) then Field := 7;
      end
      else
      begin

        case Field of

          1: sDay := sDay + DateStr[Loop];
          2: sMonth := sMonth + DateStr[Loop];
          3: sYear := sYear + DateStr[Loop];
          4: sHour := sHour + DateStr[Loop];
          5: sMin := sMin + DateStr[Loop];
          6: sSec := sSec + DateStr[Loop];
          7: sTZ := sTZ + DateStr[Loop];
        end;
      end;
    end;

    Hour := StrToIntDef(sHour, 0);
    Min := StrToIntDef(sMin, 0);
    Sec := StrToIntDef(sSec, 0);
    Year := StrToIntDef(sYear, 0);
    Day := StrToIntDef(sDay, 0);

    if sMonth[1] in ['0'..'9'] then
      Month := StrToIntDef(sMonth, 0)
    else
      Month := (Pos(sMonth, Months)-1) div 4 + 1;

    if Year < 100 then
    begin

      if Year < 50 then
        Year := 2000 + Year
      else
        Year := 1900 + Year;
    end;

    if (Year = 0) or (Month = 0) or (Year = 0) then
    begin

      Result := 0;
    end
    else
    begin

      if (sTZ = 'GMT') or (Length(Trim(sTZ)) <> 5) then
      begin

        STZM := 1;
        HTZM := 0;
        MTZM := 0;
      end
      else
      begin

        STZM := StrToIntDef(Copy(sTZ, 1, 1)+'1', 1);
        HTZM := StrToIntDef(Copy(sTZ, 2, 2), 0);
        MTZM := StrToIntDef(Copy(sTZ, 4, 2), 0);
      end;

      try
        //clq 2003.7.5 修正
        if (Trunc(Year)=0)or (Trunc(Month)=0)or (Trunc(Day)=0) then
        begin
          Result := 0;
          exit;
        end;
        //clq 2003.7.5 修正

        TZM := EncodeTime(HTZM, MTZM, 0, 0)*STZM;
        Final := EncodeDate(Trunc(Year), Trunc(Month), Trunc(Day));
        Final := Final + Hour*(1/24) + Min*(1/24/60) + Sec*(1/24/60/60);
        Final := Final - TZM + GetTimeZoneBias;

        Result := Final;

      except

        Result := 0;
      end;
    end;
  end
  else
  begin

    Result := 0;
  end;
end;

// Convert numeric date to mail format

//clq 2018 这个明显有问题
function DelphiDateToMailDate(const Date: TDateTime): String;
const
  Months: String = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,';
  Weeks: String = 'Sun,Mon,Tue,Wed,Thu,Fri,Sat,';

var
  TZH: Double;
  DateStr: String;
  TZStr: String;
  Day, Month, Year: Word;

begin

  TZH := GetTimeZoneBias;
  DecodeDate(Date, Year, Month, Day);

  if TZH < 0 then
  begin

    TZStr := '-'+FormatDateTime('hhmm', Abs(TZH));
  end
  else
  begin

    if TZH = 0 then
    begin

      TZStr := 'GMT'
    end
    else
    begin

      TZStr := '+'+FormatDateTime('hhmm', Abs(TZH));
    end;
  end;

  DateStr := Copy(Weeks, (DayOfWeek(Date)-1)*4+1, 3)+',';
  DateStr := DateStr + FormatDateTime(' dd ', Date);
  DateStr := DateStr + Copy(Months, (Month-1)*4+1, 3);
  DateStr := DateStr + FormatDateTime(' yyyy hh:nn:ss ', Date) + TZStr;

  Result := DateStr;
end;

// To make sure that a file name (without path!) is valid

function ValidFileName(FileName: String): String;
const
  InvChars: String = ':\/*?"<>|'#39;

var
  Loop: Integer;

begin

  FileName := Copy(TrimSpace(FileName), 1, 254);
  Result := '';

  for Loop := 1 to Length(FileName) do
  begin
         
    //clq 绝妙!用pos和字符串代替了集合类型的in操作
    if (Ord(FileName[Loop]) < 32) or (Pos(FileName[Loop], InvChars) > 0) then
      Result := Result + '_'
    else
      Result := Result + FileName[Loop];
  end;
end;

// Wrap an entire message header

function WrapHeader(Text: String): String;
var
  Line: String;
  nPos: Integer;
  fPos: Integer;
  Quote: Char;
  Ok: Boolean;

begin

  Result := '';
  Text := AdjustLineBreaks(Text);

  while Copy(Text, Length(Text)-1, 2) = #13#10 do
    Delete(Text, Length(Text)-1, 2);

  while Text <> '' do
  begin

    nPos := Pos(#13#10, Text);

    if nPos > 0 then
    begin

      Line := Copy(Text, 1, nPos-1);
      Text := Copy(Text, nPos+2, Length(Text));
    end
    else
    begin

      Line := Text;
      Text := '';
    end;

    if Length(Line) <= _LINELEN then
    begin

      Result := Result + Line + #13#10;
    end
    else
    begin

      nPos := Length(Line);
      Quote := #0;
      Ok := False;

      if Line[1] <> #9 then
        fPos := Pos(':'#32, Line)+2
      else
        fPos := _LINELEN div 2;

      while nPos >= fPos do
      begin

        if (Quote = #0) and (Line[nPos] in [#39, '"']) then
          Quote := Line[nPos]
        else
          if (Quote <> #0) and (Line[nPos] = Quote) then
            Quote := #0;

        if (Quote = #0) and (nPos <= _LINELEN) and (Line[nPos] in [#32, ',', ';']) then
        begin

          Ok := True;
          Break;
        end;

        Dec(nPos);
      end;

      if Ok then
      begin

        if Line[nPos] = #32 then
          Result := Result + Copy(Line, 1, nPos-1) + #13#10#9
        else
          Result := Result + Copy(Line, 1, nPos) + #13#10#9;

        Text := Copy(Line, nPos+1, Length(Line)) + #13#10 + Text;
      end
      else
      begin

        Result := Result + Line + #13#10;
      end;
    end;
  end;
end;

{ TMailPart ================================================================== }

// Initialize MailPart

constructor TMailPart.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  FHeader := TStringList.Create;
  FBody := TMemoryStream.Create;
  FDecoded := TMemoryStream.Create;
  FDecoded_Bin := TMemoryStream.Create; //clq add // 2019/7/24 21:50:57
  FSubPartList := TMailPartList.Create;
  FOwnerPart := nil;
  FOwnerMessage := nil;
  FAttachedMessage := nil;
  FEmbedded := False;
end;

// Finalize MailPart

destructor TMailPart.Destroy;
var
  Loop: Integer;

begin

  for Loop := 0 to FSubPartList.Count-1 do
    FSubPartList.Items[Loop].Destroy;

  FHeader.Free;
  FBody.Free;
  FDecoded.Free;
  FSubPartList.Free;

  if FAttachedMessage <> nil then
    FAttachedMessage.Free;

  inherited Destroy;
end;

// Return the value of a label from the header like "To", "Subject"

function TMailPart.GetLabelValue(const cLabel: String): String;
var
  Loop,i: Integer;
  line:string;

begin
  // 2018-2-5 11:28:50 //clq 原来的代码有一个问题,头信息中有内容折行的情况,例如标题或者邮件服务器中的扩展信息

  Result := '';
  Loop := SearchStringList(FHeader, cLabel+':');


  if Loop >= 0 then
  begin
    Result := TrimSpace(LabelValue(FHeader[Loop]));
    
    //--------------------------------------------------
    // 2018-2-5 clq 从这一行开始后面以空格或者 tab 开头的其实都算是它的内容,因为是折行后的
    for i := Loop+1 to FHeader.Count-1 do
    begin
      line := FHeader[i];
      if Length(line)<1 then Break;
      if not(line[1] in [' ', #9]) then Break; //不是空格和 tab 开头就跳出了

      //Result := Result + FHeader[i];
      Result := Result + #13#10 + FHeader[i]; //clq 2018 还是加硬回车，后面再处理
    end;
    //--------------------------------------------------

  end;


  if Length(Result) > 2 then
  begin

    if (Result[1] in ['"', #39]) and
       (Result[Length(Result)] in ['"', #39]) then
      Result := Copy(Result, 2, Length(Result)-2);
  end;
end;

// Return de value of a parameter of a value from the header

function TMailPart.GetLabelParamValue(const cLabel, Param: String): String;
var
  Loop: Integer;

begin

  Result := '';
  Loop := SearchStringList(FHeader, cLabel+':');

  if Loop >= 0 then
    Result := TrimSpace(LabelParamValue(FHeader[Loop], Param));

  if Length(Result) > 2 then
  begin

    if (Result[1] in ['"', #39]) and
       (Result[Length(Result)] in ['"', #39]) then
      Result := Copy(Result, 2, Length(Result)-2);
  end;
end;

// Set the value of a label

procedure TMailPart.SetLabelValue(const cLabel, cValue: String);
var
  Loop: Integer;

begin

  Loop := SearchStringList(FHeader, cLabel+':');

  if cValue <> '' then
  begin

    if Loop < 0 then
    begin

      FHeader.Add(cLabel+': ');
      Loop := FHeader.Count-1;
    end;

    FHeader[Loop] := WriteLabelValue(FHeader[Loop], cValue);
  end
  else
  begin

    if Loop >= 0 then
    begin

      FHeader.Delete(Loop);
    end;
  end;
end;

// Set the value of a label parameter

procedure TMailPart.SetLabelParamValue(const cLabel, cParam, cValue: String);
var
  Loop: Integer;

begin

  Loop := SearchStringList(FHeader, cLabel+':');

  if Loop < 0 then
  begin

    FHeader.Add(cLabel+': ');
    Loop := FHeader.Count-1;
  end;

  FHeader[Loop] := WriteLabelParamValue(FHeader[Loop], cParam, cValue);
end;

// Look for a label in the header

function TMailPart.LabelExists(const cLabel: String): Boolean;
begin

  Result := SearchStringList(FHeader, cLabel+':') >= 0;
end;

// Look for a parameter in a label in the header

function TMailPart.LabelParamExists(const cLabel, Param: String): Boolean;
var
  Loop: Integer;

begin

  Result := False;
  Loop := SearchStringList(FHeader, cLabel+':');

  if Loop >= 0 then
    Result := TrimSpace(LabelParamValue(FHeader[Loop], Param)) <> '';
end;

// Divide header and body; normalize header;

procedure TMailPart.Fill(Data: PChar; HasHeader: Boolean);
const
  CRLF: array[0..2] of Char = (#13, #10, #0);

var
  Loop: Integer;
  BoundStart: array[0..99] of Char;
  BoundEnd: array[0..99] of Char;
  InBound: Boolean;
  IsBoundStart: Boolean;
  IsBoundEnd: Boolean;
  BoundStartLen: Integer;
  BoundEndLen: Integer;
  PartText: PChar;
  DataEnd: Boolean;
  MultPart: Boolean;
  NoParts: Boolean;
  InUUCode: Boolean;
  UUFile, UUBound: String;
  Part: TMailPart;
  nPos: Integer;
  nLen: Integer;
  nTL: Integer;
  nSPos: Integer;
  Line: PChar;
  SChar: Char;

begin

  if (FOwnerMessage = nil) or (not (FOwnerMessage is TMailMessage2000)) then
  begin

    Exception.Create(Self.Name+': TMailPart must be owned by a TMailMessage2000');
    Exit;
  end;

  for Loop := 0 to FSubPartList.Count-1 do
    FSubPartList.Items[Loop].Destroy;

  FHeader.Clear;
  FBody.Clear;
  FDecoded.Clear;
  FSubPartList.Clear;
  FIsDecoded := False;
  FEmbedded := False;
  FOwnerMessage.FNeedRebuild := True;
  FOwnerMessage.FNeedNormalize := True;
  FOwnerMessage.FNeedFindParts := True;

  nPos := -1;
  DataEnd := False;
  nTL := StrLen(Data);
  nSPos := nTL+1;

  if (Self is TMailMessage2000) and Assigned(FOwnerMessage.FOnProgress) then
  begin

    FOwnerMessage.FOnProgress(Self, nTL, 0);
    Application.ProcessMessages;
  end;

  if HasHeader then
  begin

    // Get Header

    DataLinePChar(Data, nTL, nPos, nLen, Line, DataEnd);

    while not DataEnd do
    begin

      if nLen = 0 then
      begin

        Break;
      end
      else
      begin

        if (Line[0] in [#9, #32]) and (FHeader.Count > 0) then
        begin

          FHeader[FHeader.Count-1] := FHeader[FHeader.Count-1] + #32 + String(PChar(@Line[1]));
        end
        else
        begin

          FHeader.Add(String(Line));
        end;
      end;

      DataLinePChar(Data, nTL, nPos, nLen, Line, DataEnd);

      if (Self is TMailMessage2000) and Assigned(FOwnerMessage.FOnProgress) then
      begin

        FOwnerMessage.FOnProgress(Self, nTL, nPos+1);
        Application.ProcessMessages;
      end;
    end;

    for Loop := 0 to FHeader.Count-1 do
      FHeader[Loop] := NormalizeLabel(FHeader[Loop]);
  end;

  MultPart := LowerCase(Copy(GetLabelValue(_C_T), 1, 10)) = _MP;
  InBound := False;
  IsBoundStart := False;
  IsBoundEnd := False;
  UUBound := '';

  if MultPart then
  begin

    StrPCopy(BoundStart, '--'+GetBoundary);
    StrPCopy(BoundEnd, '--'+GetBoundary+'--');
    BoundStartLen := StrLen(BoundStart);
    BoundEndLen := StrLen(BoundEnd);
    NoParts := False;
  end
  else
  begin

    if LabelExists(_C_T) then
    begin

      NoParts := True;
      BoundStartLen := 0;
      BoundEndLen := 0;
    end
    else
    begin

      StrPCopy(BoundStart, 'begin 6');
      StrPCopy(BoundEnd, 'end');
      BoundStartLen := StrLen(BoundStart);
      BoundEndLen := StrLen(BoundEnd);
      NoParts := False;
    end;
  end;

  PartText := nil;

  // Get Body

  DataLinePChar(Data, nTL, nPos, nLen, Line, DataEnd);

  while (not DataEnd) and (not InBound) do
  begin

    if (not NoParts) and (((Line[0] = '-') and (Line[1] = '-')) or ((Line[0] = 'b') and (Line[1] = 'e'))) then
    begin

      IsBoundStart := StrLComp(Line, BoundStart, BoundStartLen) = 0;
    end;

    if NoParts or (not IsBoundStart) then
    begin

      if PartText = nil then
      begin

        PartText := Line;
        nSPos := nPos;
      end;

      DataLinePChar(Data, nTL, nPos, nLen, Line, DataEnd);

      if (Self is TMailMessage2000) and Assigned(FOwnerMessage.FOnProgress) then
      begin

        FOwnerMessage.FOnProgress(Self, nTL, nPos+1);
        Application.ProcessMessages;
      end;
    end
    else
    begin

      InBound := True;
    end;
  end;

  if nPos > nSPos then
  begin

    SChar := Data[nPos];
    Data[nPos] := #0;

    if PartText <> nil then
      FBody.Write(PartText[0], nPos-nSPos);

    Data[nPos] := SChar;
  end;

  if not NoParts then
  begin

    PartText := nil;

    if MultPart then
    begin

      // Get Mime parts

      while not DataEnd do
      begin

        if IsBoundStart or IsBoundEnd then
        begin

          if (PartText <> nil) and (PartText[0] <> #0) then
          begin

            Part := TMailPart.Create(Self.FOwnerMessage);
            Part.FOwnerPart := Self;
            Part.FOwnerMessage := Self.FOwnerMessage;

            SChar := Data[nPos-2];
            Data[nPos-2] := #0;
            Part.Fill(PartText, True);
            Data[nPos-2] := SChar;

            Part.FParentBoundary := GetBoundary;
            FSubPartList.Add(Part);
            PartText := nil;
          end;

          if IsBoundEnd then
          begin

            Break;
          end;

          IsBoundStart := False;
          IsBoundEnd := False;
        end
        else
        begin

          if PartText = nil then
          begin

            PartText := Line;
          end;
        end;

        DataLinePChar(Data, nTL, nPos, nLen, Line, DataEnd);

        if (Self is TMailMessage2000) and Assigned(FOwnerMessage.FOnProgress) then
        begin

          FOwnerMessage.FOnProgress(Self, nTL, nPos+1);
          Application.ProcessMessages;
        end;

        if not DataEnd then
        begin

          if (Line[0] = '-') and (Line[1] = '-') then
          begin

            IsBoundStart := StrLComp(Line, BoundStart, BoundStartLen) = 0;

            if not IsBoundStart then
            begin

              IsBoundEnd := StrLComp(Line, BoundEnd, BoundEndLen) = 0;
            end;
          end;
        end;
      end;
    end
    else
    begin

      // Get UUCode parts

      InUUCode := IsBoundStart;

      while not DataEnd do
      begin

        if IsBoundStart then
        begin

          if UUBound = '' then
          begin

            GetMem(PartText, FBody.Size+1);
            UUBound := GenerateBoundary;
            StrLCopy(PartText, FBody.Memory, FBody.Size);
            PartText[FBody.Size] := #0;

            Part := TMailPart.Create(Self.FOwnerMessage);
            Part.FOwnerPart := Self;
            Part.FOwnerMessage := Self.FOwnerMessage;
            Part.Fill(PChar(EncodeQuotedPrintable(String(PartText), False)), False);
            Part.FParentBoundary := UUBound;
            Part.SetLabelValue(_C_T, _T_P);
            Part.SetLabelParamValue(_C_T, 'charset', '"'+FOwnerMessage.FCharset+'"');
            Part.SetLabelValue(_C_TE, 'quoted-printable');

            FSubPartList.Add(Part);
            SetLabelValue(_C_T, '');
            SetLabelValue(_C_T, _M_M);
            SetLabelParamValue(_C_T, _BDRY, '"'+UUBound+'"');

            FreeMem(PartText);
          end;

          PartText := nil;
          IsBoundStart := False;
          UUFile := TrimSpace(Copy(String(Line), 11, 999));
        end
        else
        begin

          if IsBoundEnd then
          begin

            Part := TMailPart.Create(Self.FOwnerMessage);
            Part.FOwnerPart := Self;
            Part.FOwnerMessage := Self.FOwnerMessage;

            SChar := Data[nPos-2];
            Data[nPos-2] := #0;
            DecodeUUCODE(PartText, Part.FDecoded);
            Data[nPos-2] := SChar;

            Part.EncodeBinary;
            Part.FParentBoundary := UUBound;
            Part.SetLabelValue(_C_T, GetMimeType(UUFile));
            Part.SetLabelValue(_C_TE, 'base64');
            Part.SetLabelValue(_C_D, _ATCH);
            Part.SetLabelParamValue(_C_T, 'name', '"'+UUFile+'"');
            Part.SetLabelParamValue(_C_D, 'filename', '"'+UUFile+'"');

            FSubPartList.Add(Part);
            PartText := nil;
            IsBoundEnd := False;
          end
          else
          begin

            if PartText = nil then
            begin

              PartText := Line;
            end;
          end;
        end;

        DataLinePChar(Data, nTL, nPos, nLen, Line, DataEnd);

        if (Self is TMailMessage2000) and Assigned(FOwnerMessage.FOnProgress) then
        begin

          FOwnerMessage.FOnProgress(Self, nTL, nPos+1);
          Application.ProcessMessages;
        end;

        if not DataEnd then
        begin

          if (Line[0] = 'b') and (Line[1] = 'e') then
          begin

            IsBoundStart := StrLComp(Line, BoundStart, BoundStartLen) = 0;
            InUUCode := True;
          end;

          if (not IsBoundStart) and InUUCode then
          begin

            if (Line[0] = 'e') and (Line[1] = 'n') and (Line[2] = 'd') then
            begin

              IsBoundEnd := True;
              InUUCode := False;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// Remove mailpart from its owner

procedure TMailPart.Remove;
begin

  if (FOwnerPart <> nil) and (Self <> FOwnerMessage) and
     (FOwnerPart.FSubPartList.IndexOf(Self) >= 0) then
  begin

    FOwnerPart.FSubPartList.Delete(FOwnerPart.FSubPartList.IndexOf(Self));
    FOwnerPart := nil;
  end;
end;

// Fill part with a file contents

procedure TMailPart.LoadFromFile(FileName: String);
var
  SL: TStringList;

begin

  SL := TStringList.Create;
  SL.LoadFromFile(FileName);

  Fill(PChar(SL.Text), True);

  SL.Free;
end;

// Save the part data to a file

procedure TMailPart.SaveToFile(FileName: String);
var
  SL: TStringList;

begin

  SL := TStringList.Create;
  SL.Text := GetSource;
  
  try

    SL.SaveToFile(FileName);

  finally
  
    SL.Free;
  end;
end;

// Fill part with a stream contents

procedure TMailPart.LoadFromStream(Stream: TStream);
var
  Buffer: PChar;

begin

  GetMem(Buffer, Stream.Size+1);
  Stream.Position := 0;
  Stream.ReadBuffer(Buffer[0], Stream.Size);
  Buffer[Stream.Size] := #0;
  Fill(Buffer, True);
  FreeMem(Buffer);
end;

// Save the part data to a stream

procedure TMailPart.SaveToStream(Stream: TStream);
var
  Text: String;

begin

  Text := GetSource;
  Stream.Size := Length(Text);
  Stream.Position := 0;
  Stream.WriteBuffer(Text[1], Length(Text));
end;

// Fill part with a string contents

procedure TMailPart.SetSource(const Text: String);
begin

  Fill(PChar(Text), True);
end;

// Copy the part data to a string

function TMailPart.GetSource: String;
begin

  SetLength(Result, FBody.Size);
  FBody.Position := 0;
  FBody.ReadBuffer(Result[1], FBody.Size);
  Result := WrapHeader(FHeader.Text)+#13#10+Result;
end;

// Get file name of attachment

function TMailPart.GetFileName: String;
var
  Name: String;

begin

  Name := '';

  if LabelParamExists(_C_T, 'name') then
  begin

    Name := GetLabelParamValue(_C_T, 'name');
  end
  else
  begin

    if LabelParamExists(_C_D, 'filename') then
    begin

      Name := GetLabelParamValue(_C_D, 'filename');
    end
    else
    begin

      if LabelExists(_C_ID) then
      begin

        Name := GetLabelValue(_C_ID);
      end
      else
      begin

        if LabelExists(_C_T) then
        begin

          Name := GetLabelValue(_C_T)+GetMimeExtension(GetLabelValue(_C_T));
        end
        else
        begin

          Name := 'unknown';
        end;
      end;
    end;
  end;

  Name := DecodeLine7Bit(Name);

  if Pos('.', Name) = 0 then
    Name := Name + GetMimeExtension(GetLabelValue(_C_T));

  Result := ValidFileName(Name);
end;

// Get kind of attachment

function TMailPart.GetAttachInfo: String;
begin

  Result := LowerCase(GetLabelValue(_C_T));
end;

// Get boundary of this part (when it is a multipart header)

function TMailPart.GetBoundary: String;
begin

  Result := GetLabelParamValue(_C_T, _BDRY);
end;

// Decode mail part

function TMailPart.Decode;
var
  Content: String;
  Encoding: String;
  Data: String;
  DecoLine: String;
  Buffer: PChar;
  Size: Integer;
  nPos: Integer;

  //clq
  f_charset1:string; //为了兼容utf8
  f_buf1,f_buf2:TStringStream;
  //clq_end;

begin

  Result := True;

  if FIsDecoded then
    Exit;

  FIsDecoded := True;

  if FBody.Size = 0 then Exit;

  Content := GetAttachInfo;
  Encoding := GetLabelValue(_C_TE);

  //clq
  f_charset1:=GetLabelParamValue(_C_T, 'charset');
  Self.charset := f_charset1;
  //clq_end;
  
  //clq 这里应该改为全小写的,因为后面的都是与小写的字符串进行对比的,会引起错误
  //比如 X-Mailer: JMail 4.3.0 Free Version by Dimac 中就用了大写单词头一个字母
  //的方式导致了其出错
  Encoding:=lowercase(trim(Encoding));

  FDecoded.Clear;

  if (Encoding = 'quoted-printable') or (Encoding = '7bit') then
  begin

    GetMem(Buffer, FBody.Size+1);
    StrLCopy(Buffer, FBody.Memory, FBody.Size);
    Buffer[FBody.Size] := #0;
    //clq add
    if (Encoding = '7bit')//7bit应当是原文
    then DecoLine := strpas(Buffer)
    else DecoLine := DecodeQuotedPrintable(Buffer);
    //clq add end;
    //clq//DecoLine := DecodeQuotedPrintable(Buffer);
    FreeMem(Buffer);

    GetMem(Buffer, Length(DecoLine)+1);
    StrPCopy(Buffer, DecoLine);
    FDecoded.Write(Buffer^, Length(DecoLine));
    FreeMem(Buffer);
  end
  else
  begin

    if Encoding = 'base64' then
    begin

      nPos := 1;

      SetLength(Data, FBody.Size);
      FBody.Position := 0;
      FBody.ReadBuffer(Data[1], FBody.Size);

      while nPos >= 0 do
      begin

        DataLine(Data, DecoLine, nPos);

        //clq del 奇怪 132 是怎么来的//GetMem(Buffer, 132);
        //这样肯定是错的,应该先分配足够的内存//它可能先假设了每行的字符不能大于多少

        //GetMem(Buffer, 132);
        GetMem(Buffer, Length(DecoLine)+1);//给结束符一个位置
        //clq end;

        Size := DecodeLineBASE64(TrimSpace(DecoLine), Buffer);
        Buffer[Size] := #0;//clq add//参见对 'B': 我解码

        if Size > 0 then
          FDecoded.Write(Buffer^, Size);

        FreeMem(Buffer);
      end;
    end
    else
    begin

      if Encoding = 'uucode' then
      begin

        nPos := 1;

        SetLength(Data, FBody.Size);
        FBody.Position := 0;
        FBody.ReadBuffer(Data[1], FBody.Size);

        while nPos >= 0 do
        begin

          DataLine(Data, DecoLine, nPos);

          //clqGetMem(Buffer, 80);
          GetMem(Buffer, length(DecoLine));//clq//参见 'U': 形式的解码//不能假设每行只有 80 个字符
          Size := DecodeLineUUCODE(TrimSpace(DecoLine), Buffer);
          FDecoded.Write(Buffer^, Size);
          FreeMem(Buffer);
        end;

        EncodeBinary; // Convert to base64
      end
      else
      begin

        GetMem(Buffer, FBody.Size);
        FBody.Position := 0;
        FBody.Read(Buffer^, FBody.Size);
        FDecoded.Write(Buffer^, FBody.Size);
        FreeMem(Buffer);
      end;
    end;
  end;

  //clq//当内容是utf8的字符集的时候还是要转换的

  // 2019/7/24 21:46:40 //html 有时候要使用未转换字符集的原文，所以要加一个属性先保存一下
  self.Decoded_Bin.LoadFromStream(self.Decoded);

  if (lowercase(trim(f_charset1))='"utf-8"')or(lowercase(trim(f_charset1))='utf-8') then
  begin
    //原始内容在 self.FBody 中,解码后要写入 FDecoded
    f_buf1:=TStringStream.Create('');
    f_buf2:=TStringStream.Create('');
    
    //self.FBody.SaveToStream(f_buf1);
    self.FDecoded.SaveToStream(f_buf1); //clq 2018.02.05 应该转码解码后的字符串流

    f_buf2.WriteString(utf8toansi(f_buf1.DataString));
    self.Decoded.LoadFromStream(f_buf2);

    f_buf1.Free;
    f_buf2.free;
  end;
  //clq_end;
  
end;

// Encode mail part

procedure TMailPart.Encode(const ET: TEncodingType);
begin

  case ET of

    etBase64: EncodeBinary;

    etQuotedPrintable: EncodeText;

    etNoEncoding:
    begin

      FDecoded.Position := 0;
      FBody.Clear;
      FBody.LoadFromStream(FDecoded);
      SetLabelValue(_C_TE, '');
    end;

    et7Bit:
    begin

      FDecoded.Position := 0;
      FBody.Clear;
      FBody.LoadFromStream(FDecoded);
      SetLabelValue(_C_TE, '7bit');
    end;
  end;
end;

// Encode mail part in quoted-printable

procedure TMailPart.EncodeText;
var
  Buffer: String;
  Encoded: String;
  
begin

  FBody.Clear;
  SetLabelValue(_C_TE, 'quoted-printable');

  if FDecoded.Size > 0 then
  begin

    SetLength(Buffer, FDecoded.Size);
    FDecoded.Position := 0;
    FDecoded.ReadBuffer(Buffer[1], FDecoded.Size);
    Encoded := EncodeQuotedPrintable(Buffer, False);
    FBody.Write(Encoded[1], Length(Encoded));
  end;
end;

// Encode mail part in base64

procedure TMailPart.EncodeBinary;
begin

  EncodeBASE64(FBody, FDecoded);
  SetLabelValue(_C_TE, 'base64');
end;

{ TMailPartList ============================================================== }

// Retrieve an item from the list

function TMailPartList.Get(const Index: Integer): TMailPart;
begin

	Result := inherited Items[Index];
end;

// Finalize MailPartList

destructor TMailPartList.Destroy;
begin

  inherited Destroy;
end;

{ TMailRecipients ================================================================ }

// Initialize MailRecipients

constructor TMailRecipients.Create(MailMessage: TMailMessage2000; Field: String);
begin

  inherited Create;

  FMessage := MailMessage;
  FField := Field;
  FNames := TStringList.Create;
  FAddresses := TStringList.Create;
  FCheck := -1;
end;

// Finalize MailRecipients

destructor TMailRecipients.Destroy;
begin

  FNames.Free;
  FAddresses.Free;

  inherited Destroy;
end;

// Copy recipients to temporary string list

procedure TMailRecipients.HeaderToStrings;
var
  Dests: String;
  Loop: Integer;
  Quote: Boolean;
  IsName: Boolean;
  sName: String;
  sAddress: String;

begin

  if Length(FMessage.FHeader.Text) = FCheck then
    Exit;

  Dests := TrimSpace(FMessage.GetLabelValue(FField));
  FCheck := Length(FMessage.FHeader.Text);
  sName := '';
  sAddress := '';
  Quote := False;
  IsName := True;

  FNames.Clear;
  FAddresses.Clear;

  for Loop := 1 to Length(Dests) do
  begin

    if Dests[Loop] = '"' then
    begin

      Quote := not Quote;
    end
    else
    begin

      if (not Quote) and (Dests[Loop] in [',', ';']) then
      begin

        if IsName then
        begin

          FNames.Add('');
          FAddresses.Add(TrimSpace(sName));
        end
        else
        begin

          FNames.Add(DecodeLine7Bit(TrimSpace(sName)));
          FAddresses.Add(TrimSpace(sAddress));
        end;

        sName := '';
        sAddress := '';
        IsName := True;
      end;

      if IsName then
      begin

        if Quote then
          sName := sName + Dests[Loop]
        else
          if not (Dests[Loop] in [',', ';', '<', '>']) then
            sName := sName + Dests[Loop];
      end
      else
      begin

        if (not Quote) and (not (Dests[Loop] in [',', ';', '<', '>', #32])) then
          sAddress := sAddress + Dests[Loop];
      end;

      if (Dests[Loop] = '<') and (not Quote) then
      begin

        IsName := False;
      end;
    end;
  end;

  if Dests <> '' then
  begin

    if IsName then
    begin

      FNames.Add('');
      FAddresses.Add(TrimSpace(sName));
    end
    else
    begin

      FNames.Add(DecodeLine7Bit(TrimSpace(sName)));
      FAddresses.Add(TrimSpace(sAddress));
    end;
  end;
end;

// Replace recipients with temporary string list

procedure TMailRecipients.StringsToHeader;
var
  Dests: String;
  Loop: Integer;

begin

  if FAddresses.Count > 0 then
  begin

    Dests := '';

    for Loop := 0 to FAddresses.Count-1 do
    begin

      if TrimSpace(FNames[Loop]) <> '' then
        Dests := Dests+'"'+EncodeLine7Bit(TrimSpace(FNames[Loop]), FMessage.FCharSet)+'"'#32'<'+TrimSpace(FAddresses[Loop])+'>'
      else
        Dests := Dests+'<'+TrimSpace(FAddresses[Loop])+'>';

      if Loop < FAddresses.Count-1 then
        Dests := Dests+','#32;
    end;

    FMessage.SetLabelValue(FField, Dests);
  end
  else
  begin

    FMessage.SetLabelValue(FField, '');
  end;

  FCheck := Length(FMessage.FHeader.Text);
end;

// Retrieve a name by index

function TMailRecipients.GetName(const Index: Integer): String;
begin

  HeaderToStrings;
  Result := FNames[Index];
end;

// Retrieve a address by index

function TMailRecipients.GetAddress(const Index: Integer): String;
begin

  HeaderToStrings;
  Result := FAddresses[Index];
end;

// Returns number of recipients

function TMailRecipients.GetCount: Integer;
begin

  HeaderToStrings;
  Result := FAddresses.Count;
end;

// Replace a name by index

procedure TMailRecipients.SetName(const Index: Integer; const Name: String);
begin

  HeaderToStrings;
  FNames[Index] := Name;
  StringsToHeader;
end;

// Replace an address by index

procedure TMailRecipients.SetAddress(const Index: Integer; const Address: String);
begin

  HeaderToStrings;
  FAddresses[Index] := Address;
  StringsToHeader;
end;

// Find an recipient by name

function TMailRecipients.FindName(const Name: String): Integer;
begin

  HeaderToStrings;
  Result := SearchStringList(FNames, Name);
end;

// Find an recipient by address

function TMailRecipients.FindAddress(const Address: String): Integer;
begin

  HeaderToStrings;
  Result := SearchStringList(FAddresses, Address);
end;

// Put all names on commatext

function TMailRecipients.GetAllNames: String;
begin

  HeaderToStrings;
  Result := FNames.CommaText;
end;

// Put all addresses on commatext

function TMailRecipients.GetAllAddresses: String;
begin

  HeaderToStrings;
  Result := FAddresses.CommaText;
end;

// Set all recipients from commatext

procedure TMailRecipients.SetAll(const Names, Addresses: String);
begin

  FNames.CommaText := Names + ',';
  FAddresses.CommaText := Addresses + ',';
  FCheck := -1;

  while FNames.Count < FAddresses.Count do
    FNames.Add('');

  while FAddresses.Count < FNames.Count do
    FNames.Delete(FNames.Count-1);

  StringsToHeader;
end;

// Add recipient names to TStrings

procedure TMailRecipients.AddNamesTo(const Str: TStrings);
begin

  HeaderToStrings;
  Str.AddStrings(FNames);
end;

// Add recipient addresses to TStrings

procedure TMailRecipients.AddAddressesTo(const Str: TStrings);
begin

  HeaderToStrings;
  Str.AddStrings(FAddresses);
end;

// Add a new recipient

procedure TMailRecipients.Add(const Name, Address: String);
begin

  HeaderToStrings;
  FNames.Add(Name);
  FAddresses.Add(Address);
  StringsToHeader;
end;

// Replace an recipient by index

procedure TMailRecipients.Replace(const Index: Integer; const Name, Address: String);
begin

  HeaderToStrings;
  FNames[Index] := Name;
  FAddresses[Index] := Address;
  StringsToHeader;
end;

// Delete an recipient by index

procedure TMailRecipients.Delete(const Index: Integer);
begin

  HeaderToStrings;
  FNames.Delete(Index);
  FAddresses.Delete(Index);
  StringsToHeader;
end;

// Delete all recipients

procedure TMailRecipients.Clear;
begin

  FNames.Clear;
  FAddresses.Clear;
  FMessage.SetLabelValue(FField, '');
  FCheck := Length(FMessage.FHeader.Text);
end;

{ TMailMessage2000 =============================================================== }

// Initialize MailMessage

constructor TMailMessage2000.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  FAttachList := TMailPartList.Create;
  FTextPlain := TStringList.Create;
  FTextHTML := TStringList.Create;
  FTextPlainPart := nil;
  FTextHTMLPart := nil;
  FMixedPart := nil;
  FRelatedPart := nil;
  FAlternativePart := nil;
  FNeedRebuild := False;
  FNeedNormalize := True;
  FNeedFindParts := False;
  FCharset := _CHARSET;
  FNameCount := 0;
  FOwnerMessage := Self;
  FToList := TMailRecipients.Create(Self, 'To');
  FCcList := TMailRecipients.Create(Self, 'Cc');
  FBccList := TMailRecipients.Create(Self, 'Bcc');
  FTextEncoding := etBase64; //base64更安全//etQuotedPrintable;
end;

// Finalize MailMessage

destructor TMailMessage2000.Destroy;
begin

  FAttachList.Free;
  FTextPlain.Free;
  FTextHTML.Free;
  FToList.Free;
  FCcList.Free;
  FBccList.Free;

  inherited Destroy;
end;

// Get a dest. name from a field

function TMailMessage2000.GetDestName(Field: String; const Index: Integer): String;
var
  Dests: String;
  Loop: Integer;
  Count: Integer;
  Quote: Boolean;
  Name: String;

begin

  Dests := TrimSpace(GetLabelValue(Field));
  Count := 0;
  Name := '';
  Quote := False;

  for Loop := 1 to Length(Dests) do
  begin

    if Dests[Loop] = '"' then
    begin

      Quote := not Quote;
    end
    else
    begin

      if (not Quote) and (Dests[Loop] in [',', ';']) then Inc(Count);

      if Count > Index then
      begin

        Name := '';
        Break;
      end;

      if Count = Index then
      begin

        if (Dests[Loop] = '<') and (not Quote) then
        begin

          Break;
        end
        else
        begin

          if Quote or (not (Dests[Loop] in [',', ';'])) then
            Name := Name + Dests[Loop];
        end;
      end;
    end;

    if Loop = Length(Dests) then Name := '';
  end;

  Result := DecodeLine7Bit(TrimSpace(Name));
end;

// Get a dest. address from a field

function TMailMessage2000.GetDestAddress(Field: String; const Index: Integer): String;
var
  Dests: String;
  Loop: Integer;
  Count: Integer;
  Quote: Boolean;
  Address: String;

begin

  Dests := TrimSpace(GetLabelValue(Field));
  Count := 0;
  Address := '';
  Quote := False;

  for Loop := 1 to Length(Dests) do
  begin

    if Dests[Loop] = '"' then
    begin

      Quote := not Quote;
    end
    else
    begin

      if (not Quote) and (Dests[Loop] in [',', ';']) then Inc(Count);

      if Count > Index then Break;

      if Count = Index then
      begin

        if (not Quote) and (not (Dests[Loop] in [',', ';', '<', '>', #32])) then
          Address := Address + Dests[Loop];

        if (Dests[Loop] = '<') and (not Quote) then
        begin

          Address := '';
        end;

        if (Dests[Loop] = '>') and (not Quote) then
        begin

          Break;
        end;
      end;
    end;
  end;

  Result := TrimSpace(Address);
end;

// Count the instances of 'Received' fields in header

function TMailMessage2000.GetReceivedCount: Integer;
begin

  Result := 0;

  while SearchStringList(FHeader, 'Received:', Result) >= 0 do
    Inc(Result);
end;

// Retrieve a 'Received' field

function TMailMessage2000.GetReceived(const Index: Integer): TReceived;
var
  Dests: String;
  Loop: Integer;
  Quote: Integer;
  Value: String;
  Field: TReceivedField;

begin

  Result.From := '';
  Result.By := '';
  Result.Address := '';
  Result.Date := 0;

  Dests := Trim(Copy(FHeader[SearchStringList(FHeader, 'Received', Index)], 10, 9999))+#1;
  Value := '';
  Field := reNone;
  Quote := 0;

  for Loop := 1 to Length(Dests) do
  begin

    if Dests[Loop] in ['(', '['] then
      Inc(Quote);

    if Dests[Loop] in [')', ']'] then
      Dec(Quote);

    if Quote < 0 then
      Quote := 0;

    if (not (Dests[Loop] in ['"', '<', '>', #39, ')', ']'])) and (Quote = 0) then
    begin

      if (Dests[Loop] = #32) and (Field = reNone) then
      begin

        if LowerCase(Trim(Value)) = 'from' then
          Field := reFrom;

        if LowerCase(Trim(Value)) = 'by' then
          Field := reBy;

        if LowerCase(Trim(Value)) = 'for' then
          Field := reFor;

        Value := '';
      end;

      if Dests[Loop] in [#32, ';'] then
      begin

        if (Trim(Value) <> '') and (Field in [reFrom, reBy, reFor]) then
        begin

          case Field of

            reFrom: Result.From := Trim(Value);

            reBy: Result.By := Trim(Value);

            reFor: Result.Address := Trim(Value);
          end;

          Value := '';
          Field := reNone;
        end;
      end;

      if not (Dests[Loop] in [#32, ';']) then
      begin

        Value := Value + Dests[Loop];
      end;

      if Dests[Loop] = ';' then
      begin

        Value := Copy(Dests, Loop+1, Length(Dests));
        Result.Date := MailDateToDelphiDate(Trim(Value));
        Break;
      end;
    end;
  end;
end;

// Add a 'Received:' in message header

procedure TMailMessage2000.AddHop(const From, By, Aplic, Address: String);
var
  Text: String;

begin

  Text := 'Received:';

  if From <> '' then
    Text := Text + #32'from'#32+From;

  if By <> '' then
    Text := Text + #32'by'#32+By;

  if Aplic <> '' then
    Text := Text + #32'with'#32+Aplic;

  if Address <> '' then
    Text := Text + #32'for'#32'<'+Address+'>';

  Text := Text + ';'#32+DelphiDateToMailDate(Now);

  FHeader.Insert(0, Text);
end;

// Get the From: name

function TMailMessage2000.GetFromName: String;
begin

  Result := GetDestName(_FFR, 0);
end;

// Get the From: address

function TMailMessage2000.GetFromAddress: String;
begin

  Result := GetDestAddress(_FFR, 0);
end;

// Get the Reply-To: name

function TMailMessage2000.GetReplyToName: String;
begin

  Result := GetDestName(_FRT, 0);
end;

// Get the Reply-To: address

function TMailMessage2000.GetReplyToAddress: String;
begin

  Result := GetDestAddress(_FRT, 0);
end;

// Set the From: name/address

procedure TMailMessage2000.SetFrom(const Name, Address: String);
begin

  if (Name <> '') and (Address <> '') then
    SetLabelValue(_FFR, '"' + EncodeLine7Bit(Name, FCharset) + '" <' + Address + '>')
  else
    if Address <> '' then
      SetLabelValue(_FFR, '<' + Address + '>')
    else
      SetLabelValue(_FFR, '');
end;

// Set the Reply-To: name/address

procedure TMailMessage2000.SetReplyTo(const Name, Address: String);
begin

  if (Name <> '') and (Address <> '') then
    SetLabelValue(_FRT, '"' + EncodeLine7Bit(Name, FCharset) + '" <' + Address + '>')
  else
    if Address <> '' then
      SetLabelValue(_FRT, '<' + Address + '>')
    else
      SetLabelValue(_FRT, '');
end;



//取标签的算法已经分成两个了，所以可以按 贪婪算法 了。即取首尾 =? ?= 之间的字符串就可以了
function find_decode_string_v2(s: String;
  var lstr:string;//合法字符串左边的字符串
  var rstr1:string;//处理后余下的字符串
  var sEncoding: string;//编码规则
  var sCharset: string;//字符集
  var sDecode:string//要解码的部分
  ): boolean;//寻找一个合法的编码字符串
var
  pos1,pos2,pos3,pos4:integer;
  //rs1:string;//要解码的一部分
begin
  result := False;

  s := Trim(s);

  if Length(s)<5 then Exit; //长度不足

  if pos('=?',s)<1 then Exit; //没有首尾标识字符

  if RightStr(s, 2)<>'?=' then Exit; //没有首尾标识字符

  s := Copy(s, 3, Length(s)-4); //去掉首尾标识字符

    ////////////////////////////////////////余下 UTF-8?Q?
    pos2:=pos('?',s);//查找 第1个 "?"
    if pos2<1 then exit;

    sCharset:=copy(s,1,pos2-1);//取出  =?UTF-8?Q? 中的 UTF-8
    rstr1:=copy(s,pos2+1,length(s));//临时处理后余下的字符串
    s:=rstr1;//临时处理后余下的字符串

    if length(sCharset)=0 then exit;//不能为空
    ////////////////////////////////////////余下 Q?......
    pos3:=pos('?',s);//查找 第2个 "?"
    if pos3<1 then exit;

    sEncoding:=copy(s,1,pos3-1);//取出  Q? 中的 Q
    rstr1:=copy(s,pos3+1,length(s));//临时处理后余下的字符串
    s:=rstr1;//临时处理后余下的字符串

    if length(sEncoding)=0 then exit;//不能为空

    sDecode := s;//临时处理后余下的字符串



  Result := True;

  //原版函数也还是有用的，例如以下标题新算法就不行，不过那样处理就太麻烦了，以后再改进吧
  //Subject: =?UTF-8?B?5oKo55qE5paw5a+G56CB55qE55So5oi35biQ5oi35LiKY28=?=.de
  //Subject: =?gb2312?Q?FW:_newbt.?= =?gb2312?B?bmV00/LD+8PcwuvNqNaq?=

end;

//clq add//按 OE 的算法,应当是在 [=?] [?=] 内的按解码算法,在这之外的都按一般算法,其中[?=]不是贪婪算法,而是取第一个

function find_decode_string(s: String;
  var lstr:string;//合法字符串左边的字符串
  var rstr1:string;//处理后余下的字符串
  var sEncoding: string;//编码规则
  var sCharset: string;//字符集
  var sDecode:string//要解码的部分
  ): boolean;//寻找一个合法的编码字符串
var
  pos1,pos2,pos3,pos4:integer;
  //rs1:string;//要解码的一部分
begin

  Result := find_decode_string_v2(s, lstr,rstr1, sEncoding, sCharset, sDecode); Exit;  //用新算法

  result:=false;
  //while true do
  begin

    pos1:=pos('=?',s);//查找

    if pos1<1 then//没有 =?
    begin

      exit;
    end;

    lstr:=copy(s,1,pos1-1);
    rstr1:=copy(s,pos1+2,length(s));//临时处理后余下的字符串
    s:=rstr1;//临时处理后余下的字符串

    ////////////////////////////////////////余下 UTF-8?Q?
    pos2:=pos('?',s);//查找 第1个 "?"
    if pos2<1 then exit;

    sCharset:=copy(s,1,pos2-1);//取出  =?UTF-8?Q? 中的 UTF-8
    rstr1:=copy(s,pos2+1,length(s));//临时处理后余下的字符串
    s:=rstr1;//临时处理后余下的字符串

    if length(sCharset)=0 then exit;//不能为空
    ////////////////////////////////////////余下 Q?......
    pos3:=pos('?',s);//查找 第2个 "?"
    if pos3<1 then exit;

    sEncoding:=copy(s,1,pos3-1);//取出  Q? 中的 Q
    rstr1:=copy(s,pos3+1,length(s));//临时处理后余下的字符串
    s:=rstr1;//临时处理后余下的字符串

    if length(sEncoding)=0 then exit;//不能为空
    ////////////////////////////////////////余下 ......?=...
    pos4:=posex('?=',s,2);//查找 ?= //注意! 象 "=?UTF-8?Q?=E4=.." 这样的字符串是可能存在的,所以不能在s后直接找,而是向下移动一个字符
    //当然了,假如它刚好就是空字符串...@#$%@!!
    if pos4<1 then exit;

    sDecode:=copy(s,1,pos4-1);//取出  Q? 中的 Q
    rstr1:=copy(s,pos4+2,length(s));//临时处理后余下的字符串
    s:=rstr1;//临时处理后余下的字符串

    //这时 rstr1 应当是下一个  "=?UTF-8?Q?=E4=..",但它们之间一般有空格,所以要处理一下//删除第一个字符
    if (length(rstr1)>0 )and(rstr1[1] in [' ',#9]) then rstr1:=copy(rstr1,2,length(rstr1));

    //if length(sEncoding)=0 then exit;//不能为空


    ////////////
  end;

  result:=true;
end;


function DecodeLine7Bit_m(s: String): String;
var
  pos1,pos2:integer;

  var lstr:string;//合法字符串左边的字符串
  var rstr1:string;//处理后余下的字符串
  var sEncoding: string;//编码规则
  var sCharset: string;//字符集
  var sDecode:string;//要解码的部分

  Buffer: PChar;
  Texto: String;
  Size:integer;
  sl:TStringList;
  i:Integer;
begin

  Result := '';


  sl := TStringList.Create;
  sl.Text := s;

  for i := 0 to sl.Count-1 do
  begin


      //if not find_decode_string(s, lstr, rstr1, sEncoding, sCharset, sDecode) then
      if not find_decode_string(sl[i], lstr, rstr1, sEncoding, sCharset, sDecode) then
      begin//不正常的字符串
        Result := Result + s;
        //Exit;
        //break;
        Continue;
      end;

      //Texto:=sDecode;//要解码的内容
      Texto := Texto + sDecode;//要解码的内容

      Result := Result + sDecode;

  end;

  if Length(sEncoding)<1 then //没有编码信息则返回原文
  begin
    Result := s;
    Exit;
  end;  

    //解码
    //    case (sEncoding[1]) of
        case (UpperCase(sEncoding)[1]) of

          'B':
          begin

            GetMem(Buffer, Length(Texto));
            Size := DecodeLineBASE64(Texto, Buffer);
            Buffer[Size] := #0;
            Texto := String(Buffer);

            freemem(Buffer);//原来没有的
          end;

          'Q':
          begin

            while Pos('_', Texto) > 0 do
              Texto[Pos('_', Texto)] := #32;

            Texto := DecodeQuotedPrintable(Texto);
          end;

          'U':
          begin

            GetMem(Buffer, Length(Texto));
            Size := DecodeLineUUCODE(Texto, Buffer);
            Buffer[Size] := #0;
            Texto := String(Buffer);

            freemem(Buffer);//原来没有的
          end;
        end;

    //clq//这样可以解决utf8编码的标题
    //clq 2018 还是有问题，如果 base64 折半了会出问题，因为 utf8 会有半个字符在上一行半个字符在下一行
    //例如
    //Subject: =?utf-8?B?6Z2e5Yeh6L2v5Lu256uZ55So5oi35ZCNY2xxZnTlrqHmoLjn?=
    // =?utf-8?B?u5Pmnpwg5pe26Ze0OjIwMTgvMTEvMTIgMTU6MzM6NTQ=?=
    //所以要合并后再解码为好
//    if pos('utf-8',lowercase(sCharset))<>0
//      then Texto := Utf8Decode(Texto); //Texto:=utf8toansi(Texto);
//
//    if pos('big5',lowercase(sCharset))<>0
//      then Texto:=BIG5toGB(Texto);

    //result:=result+lstr+Texto;
    //result:=result+Texto;


  //end;
  Result := Texto; //要放到前面来
  if pos('utf-8',lowercase(sCharset))<>0 then
  begin
    //Texto := Utf8Decode(Texto);
    //Texto := Utf8ToAnsi(Texto);
    //utf8 解码可能出错，所以还要再处理一下。以后再用 iconv 等加强
    result := Utf8ToAnsi(Texto);

    if result='' then result := Texto; //有些标题，例如 pinterest 的信件中中间标题就是错误的(至少现在 [2018 年] 是这样)，所以要再恢复一下

  end;

  if pos('big5',lowercase(sCharset))<>0 then
  begin
    result := BIG5toGB(Texto);
  end;  

  //result := Texto;
  //application.MainForm.caption:=result;

end;
//clq add end;

// Get the subject

function TMailMessage2000.GetSubject: String;
var
  sl:TStringList;
  i:Integer;
  sCharset: string;
begin

  //Result := DecodeLine7Bit(GetLabelValue('Subject'));

  //对于很多邮件系统,它们的标题是由很多[=?][?=]组成的,必须分开
  sl := TStringList.Create;
  sl.Text := GetLabelValue('Subject');
  ////Result := DecodeLine7Bit_m(GetLabelValue('Subject'));

  Result:= '';
  sCharset := '';
//  for i := 0 to sl.Count-1 do
//  begin
//    Result := Result + DecodeLine7Bit_m(sl.Strings[i], sCharset);
//  end;

  //Result := DecodeLine7Bit_m(GetLabelValue('Subject'), sCharset);
  Result := DecodeLine7Bit_m(GetLabelValue('Subject'));

//  if pos('utf-8',lowercase(sCharset))<>0
//    then Result := Utf8Decode(Result); //Texto:=utf8toansi(Texto);
//
//  if pos('big5',lowercase(sCharset))<>0
//    then Result := BIG5toGB(Result);

  sl.Free;
end;



// Set the subject

procedure TMailMessage2000.SetSubject(const Subject: String);
begin

  //SetLabelValue('Subject', EncodeLine7Bit(Subject, FCharset));
  //clq//改用base64试试
  SetLabelValue('Subject', EncodeLineBASE64(Subject, FCharset));
end;

// Get the date in TDateTime format

function TMailMessage2000.GetDate: TDateTime;
begin
  Result := 0;
  try
  Result := MailDateToDelphiDate(TrimSpace(GetLabelValue('Date')));
  except
  end;

end;

// Set the date in RFC822 format
//golang 似乎是 rfc5322，不过也差不多

procedure TMailMessage2000.SetDate(const Date: TDateTime);
begin

  SetLabelValue('Date', DelphiDateToMailDate(Date));
end;

// Get message id

function TMailMessage2000.GetMessageId: String;
begin

  Result := GetLabelValue(_M_ID);
end;

// Set a unique message id (the parameter is just the host)

procedure TMailMessage2000.SetMessageId(const MessageId: String);
var
  IDStr: String;

begin

  IDStr := '<'+FormatDateTime('yyyymmddhhnnss', Now)+'.'+TrimSpace(Format('%8x', [Random($FFFFFFFF)]))+'.'+TrimSpace(Format('%8x', [Random($FFFFFFFF)]))+'@'+MessageId+'>';

  SetLabelValue(_M_ID, IDStr);
end;

// Searches for attached files and determines AttachList, TextPlain, TextHTML.

procedure TMailMessage2000.FindParts;

  function GetPart(Part: TMailPart): Boolean;

    function GetText(Info: String): Boolean;
    var
      Buffer: PChar;

    begin

      Result := False;

      if (FTextPlainPart = nil) and (Info = _T_P) then
      begin

        if Part.Decode then
        begin

          FTextPlainPart := Part;

          GetMem(Buffer, Part.FDecoded.Size+1);
          StrLCopy(Buffer, Part.FDecoded.Memory, Part.FDecoded.Size);
          Buffer[Part.FDecoded.Size] := #0;
          FTextPlain.SetText(Buffer);
          FreeMem(Buffer);

          Result := True;
        end;
      end;

      if (FTextHTMLPart = nil) and (Info = _T_H) then   //clq 这里就是得到 html 内容
      begin

        if Part.Decode then
        begin

          FTextHTMLPart := Part;

          GetMem(Buffer, Part.FDecoded.Size+1);
          StrLCopy(Buffer, Part.FDecoded.Memory, Part.FDecoded.Size);  //clq 这里是已经解码过字符集的了，所以取这里不是原始二进制内容
          Buffer[Part.FDecoded.Size] := #0;
          FTextHTML.SetText(Buffer);
          FreeMem(Buffer);

          Result := True;
        end;
      end;
    end;

  begin

    Result := True;

    // Check for multipart/mixed

    if (FMixedPart = nil) and (Part.GetAttachInfo = _M_M) then
    begin

      FMixedPart := Part;
      Exit;
    end;

    // Check for multipart/related

    if (FRelatedPart = nil) and (Part.GetAttachInfo = _M_R) then
    begin

      FRelatedPart := Part;
      Exit;
    end;

    // Check for multipart/alternative

    if (FAlternativePart = nil) and (Part.GetAttachInfo = _M_A) then
    begin

      FAlternativePart := Part;
      Exit;
    end;

    // Check for texts (when message is only one text)

    if (Part = Self) and (Copy(Part.GetAttachInfo, 1, Length(_TXT)) = _TXT) and (FSubPartList.Count = 0) then
    begin

      if GetText(Part.GetAttachInfo) then
        Exit;
    end;

    // Check for texts (when message is only one text - no mime info)

    if (Part = Self) and (Part.GetAttachInfo = '') and (FSubPartList.Count = 0) then
    begin

      if GetText(_T_P) then
        Exit;
    end;

    // Check for texts (when message has one text plus attachs)

    if (FMixedPart <> nil) and (Part.FOwnerPart = FMixedPart) and (FAlternativePart = nil) then
    begin

      if GetText(Part.GetAttachInfo) then
        Exit;
    end;

    // Check for texts (when message one text with embedded)

    if (FRelatedPart <> nil) and (Part.FOwnerPart = FRelatedPart) then
    begin

      if GetText(Part.GetAttachInfo) then
        Exit;
    end;

    // Check for texts (when message has alternative texts)

    //clq html 的入口是这里，其实不一定，所以还要再修改，实际上现在邮件可以加为 html 内容的地方非常多
    //以后再改进了//ll
    if (FAlternativePart <> nil) and (Part.FOwnerPart = FAlternativePart) then
    begin

      if GetText(Part.GetAttachInfo) then
        Exit;
    end;

    // If everything else failed, assume attachment

    if Part.FSubPartList.Count = 0 {Copy(Part.GetAttachInfo, 1, Length(_MP)) <> _MP} then
    begin

      Part.FEmbedded := Part.FOwnerPart = FRelatedPart;
      FAttachList.Add(Part);
    end;
  end;

  procedure DecodeRec(MP: TMailPart);
  var
    Loop: Integer;

  begin

    if GetPart(MP) then
    begin

      for Loop := 0 to MP.FSubPartList.Count-1 do
      begin

        DecodeRec(MP.FSubPartList[Loop]);
      end;
    end;
  end;

begin

  if not FNeedFindParts then
    Exit;

  FAttachList.Clear;
  FTextPlainPart := nil;
  FTextHTMLPart := nil;
  FMixedPart := nil;
  FRelatedPart := nil;
  FAlternativePart := nil;
  FTextPlain.Clear;
  FTextHTML.Clear;
  FNeedFindParts := False;

  DecodeRec(Self);
end;

// Ajust parts to the Mail2000 standards

procedure TMailMessage2000.Normalize;
var
  nLoop, nOcor: Integer;
  SaveBody, Part, TmpMixed, TmpRelated, TmpAlternative: TMailPart;
  Ext, FName: String;

begin

  if not FNeedNormalize then
    Exit;

  FindParts;

  FNeedRebuild := True;
  FNeedNormalize := False;
  FNameCount := 0;

  // Save current body

  if (FBody.Size > 0) then
  begin

    SaveBody := TMailPart.Create(Self);
    SaveBody.FBody.LoadFromStream(FBody);
    SaveBody.FOwnerMessage := Self;

    // Remove useless fields from main header

    nOcor := 0;

    repeat
    begin

      nLoop := SearchStringList(FHeader, _CONT, nOcor);
      Inc(nOcor);
      if nLoop >= 0 then
        SaveBody.FHeader.Add(FHeader[nLoop]);
    end
    until nLoop < 0;

    if Self = FTextPlainPart then
      FTextPlainPart := SaveBody
    else
      if Self = FTextHTMLPart then
        FTextHTMLPart := SaveBody
      else
        if Self = FMixedPart then
          FMixedPart := SaveBody
        else
          if Self = FRelatedPart then
            FRelatedPart := SaveBody
          else
            if Self = FAlternativePart then
              FAlternativePart := SaveBody
            else
              if (FSubPartList.Count = 0) then
                FAttachList.Add(SaveBody)
              else
                SaveBody.Free;
  end;

  // If entire mail is an attach, remove from list.

  if FAttachList.IndexOf(Self) >= 0 then
    FAttachList.Delete(FAttachList.IndexOf(Self));

  // Create new multiparts

  SetLabelValue(_C_T, '');
  SetLabelValue(_C_TE, '');
  SetLabelValue(_C_D, '');
  SetLabelValue(_C_T, _M_M);
  SetLabelParamValue(_C_T, _BDRY, '"'+GenerateBoundary+'_mixed"');
  SetLabelValue(_M_V, '1.0');
  SetLabelValue(_X_M, _XMailer);

  TmpMixed := Self;

  TmpRelated := TMailPart.Create(Self);
  TmpRelated.FOwnerMessage := Self;
  TmpRelated.FOwnerPart := TmpMixed;
  TmpRelated.FParentBoundary := TmpMixed.GetBoundary;
  TmpRelated.SetLabelValue(_C_T, _M_R);
  TmpRelated.SetLabelParamValue(_C_T, _BDRY, '"'+GenerateBoundary+'_related"');
  TmpMixed.FSubPartList.Add(TmpRelated);

  TmpAlternative := TMailPart.Create(Self);
  TmpAlternative.FOwnerMessage := Self;
  TmpAlternative.FOwnerPart := TmpRelated;
  TmpAlternative.FParentBoundary := TmpRelated.GetBoundary;
  TmpAlternative.SetLabelValue(_C_T, _M_A);
  TmpAlternative.SetLabelParamValue(_C_T, _BDRY, '"'+GenerateBoundary+'_alternative"');
  TmpRelated.FSubPartList.Add(TmpAlternative);

  // Normalize text parts

  if FTextPlainPart <> nil then
  begin

    FTextPlainPart.Remove;
    FTextPlainPart.FOwnerPart := TmpAlternative;
    FTextPlainPart.FParentBoundary := TmpAlternative.GetBoundary;
    FTextPlainPart.SetLabelValue(_C_T, _T_P);
//clq    FTextPlainPart.SetLabelParamValue(_C_T, 'name', '"'+_TXTFN+'"');
    FTextPlainPart.SetLabelValue(_C_D, _INLN);
//clq    FTextPlainPart.SetLabelParamValue(_C_D, 'filename', '"'+_TXTFN+'"');
    FTextPlainPart.Decode;
    FTextPlainPart.Encode(FTextEncoding);
    FTextPlainPart.SetLabelValue(_C_L, IntToStr(FTextPlainPart.FBody.Size));
    FTextPlainPart.FSubPartList.Clear;
    TmpAlternative.FSubPartList.Add(FTextPlainPart);
  end;

  if FTextHTMLPart <> nil then
  begin

    FTextHTMLPart.Remove;
    FTextHTMLPart.FOwnerPart := TmpAlternative;
    FTextHTMLPart.FParentBoundary := TmpAlternative.GetBoundary;
    FTextHTMLPart.SetLabelValue(_C_T, _T_H);
    FTextHTMLPart.SetLabelParamValue(_C_T, 'name', '"'+_HTMLFN+'"');
    FTextHTMLPart.SetLabelValue(_C_D, _INLN);
    FTextHTMLPart.SetLabelParamValue(_C_D, 'filename', '"'+_HTMLFN+'"');
    FTextHTMLPart.Decode;
    FTextHTMLPart.Encode(FTextEncoding);
    FTextHTMLPart.SetLabelValue(_C_L, IntToStr(FTextHTMLPart.FBody.Size));
    FTextHTMLPart.FSubPartList.Clear;
    TmpAlternative.FSubPartList.Add(FTextHTMLPart);
  end;

  // Normalize attachments

  for nLoop := 0 to FAttachList.Count-1 do
  begin

    Part := FAttachList[nLoop];

    Part.Remove;

    if Part.GetLabelValue(_C_T) = '' then
    begin

      Part.SetLabelValue(_C_T, _A_OS);
    end;

    Ext := GetMimeExtension(Part.GetLabelValue(_C_T));

    if (Part.GetLabelParamValue(_C_T, 'name') = '') then
    begin

      Part.SetLabelParamValue(_C_T, 'name', '"file_'+IntToStr(FNameCount)+Ext+'"');
      Inc(FNameCount);
    end;

    FName := Part.GetLabelParamValue(_C_T, 'name');

    if (Part.GetLabelParamValue(_C_D, 'filename') = '') then
    begin

      Part.SetLabelParamValue(_C_D, 'filename', '"'+FName+'"');
    end;

    if Part.FEmbedded then
    begin

      if Part.GetLabelValue(_C_ID) = '' then
        Part.SetLabelValue(_C_ID, FName);

      Part.SetLabelValue(_C_D, _INLN);
      Part.FOwnerPart := TmpRelated;
      Part.FParentBoundary := TmpRelated.GetBoundary;
      TmpRelated.FSubPartList.Add(Part);
    end
    else
    begin

      Part.SetLabelValue(_C_D, _ATCH);
      Part.FOwnerPart := TmpMixed;
      Part.FParentBoundary := TmpMixed.GetBoundary;
      TmpMixed.FSubPartList.Add(Part);
    end;
  end;

  // Remove old multiparts

  if (FAlternativePart <> nil) and (FAlternativePart <> Self) then
  begin

    FAlternativePart.Remove;
    FAlternativePart.Free;
  end;

  if (FRelatedPart <> nil) and (FRelatedPart <> Self) then
  begin

    FRelatedPart.Remove;
    FRelatedPart.Free;
  end;

  if (FMixedPart <> nil) and (FMixedPart <> Self) then
  begin

    FMixedPart.Remove;
    FMixedPart.Free;
  end;

  FMixedPart := TmpMixed;
  FRelatedPart := TmpRelated;
  FAlternativePart := TmpAlternative;
end;

// Insert a text on message

procedure TMailMessage2000.PutText(Text: String; Part: TMailPart; Content: String);
begin

  Normalize;

  Text := AdjustLineBreaks(Text);

  if Part = nil then
  begin

    Part := TMailPart.Create(Self);
    Part.FOwnerPart := FAlternativePart;
    Part.FOwnerMessage := Self.FOwnerMessage;
    Part.FParentBoundary := FAlternativePart.GetBoundary;
    FAlternativePart.FSubPartList.Add(Part);
  end;

  Part.Decoded.Clear;
  Part.Decoded.Write(Text[1], Length(Text));
  Part.Encode(FTextEncoding);

  Part.SetLabelValue(_C_T, Content);
  Part.SetLabelParamValue(_C_T, 'charset', '"'+FCharset+'"');
  Part.SetLabelValue(_C_D, _INLN);
  Part.SetLabelValue(_C_L, IntToStr(Part.FBody.Size));

  if Content = _T_P then
  begin

//    Part.SetLabelParamValue(_C_T, 'name', '"'+_TXTFN+'"');
//    Part.SetLabelParamValue(_C_D, 'filename', '"'+_TXTFN+'"');
  end;

  if Content = _T_H then
  begin

    Part.SetLabelParamValue(_C_T, 'name', '"'+_HTMLFN+'"');
    Part.SetLabelParamValue(_C_D, 'filename', '"'+_HTMLFN+'"');
  end;

  FNeedRebuild := True;
end;

// Replace or create a mailpart for text/plain

procedure TMailMessage2000.SetTextPlain(const Text: String);
begin

  PutText(Text, FTextPlainPart, _T_P);
  FTextPlain.Text := Text;
end;

// Replace or create a mailpart for text/html

procedure TMailMessage2000.SetTextHTML(const Text: String);
begin

  PutText(Text, FTextHTMLPart, _T_H);
  FTextHTML.Text := Text;
end;

// Remove text/plain mailpart

procedure TMailMessage2000.RemoveTextPlain;
begin

  Normalize;

  if FTextPlainPart <> nil then
  begin

    FTextPlainPart.Remove;
    FTextPlainPart.Free;
    FTextPlainPart := nil;
    FTextPlain.Clear;
    FNeedRebuild := True;
  end;
end;

// Remove text/html mailpart

procedure TMailMessage2000.RemoveTextHTML;
begin

  Normalize;

  if FTextHTMLPart <> nil then
  begin

    FTextHTMLPart.Remove;
    FTextHTMLPart.Free;
    FTextHTMLPart := nil;
    FTextHTML.Clear;
    FNeedRebuild := True;
  end;
end;

// Create a mailpart and encode the file

procedure TMailMessage2000.AttachFile(const FileName: String; const ContentType: String = ''; const EncodingType: TEncodingType = etBase64; const IsEmbedded: Boolean = False);
var
  MemFile: TMemoryStream;

begin

  MemFile := TMemoryStream.Create;
  MemFile.LoadFromFile(FileName);

  AttachStream(MemFile, FileName, ContentType, EncodingType, IsEmbedded);

  MemFile.Free;
end;

// Create a mailpart and encode the string

procedure TMailMessage2000.AttachString(const Text, FileName: String; const ContentType: String = ''; const EncodingType: TEncodingType = etBase64; const IsEmbedded: Boolean = False);
var
  MemFile: TMemoryStream;

begin

  MemFile := TMemoryStream.Create;
  MemFile.WriteBuffer(Text[1], Length(Text));

  AttachStream(MemFile, FileName, ContentType, EncodingType, IsEmbedded);

  MemFile.Free;
end;

// Create a mailpart and encode the stream

procedure TMailMessage2000.AttachStream(const AStream: TStream; const FileName: String; const ContentType: String = ''; const EncodingType: TEncodingType = etBase64; const IsEmbedded: Boolean = False);
var
  Part: TMailPart;

begin

  Normalize;

  Part := TMailPart.Create(Self);
  Part.FOwnerMessage := Self;
  AStream.Position := 0;
  Part.Decoded.LoadFromStream(AStream);
  Part.Decoded.Position := 0;
  Part.Encode(EncodingType);

  if ContentType = '' then
    Part.SetLabelValue(_C_T, GetMimeType(ExtractFileName(FileName)))
  else
    Part.SetLabelValue(_C_T, ContentType);

  Part.SetLabelParamValue(_C_T, 'name', '"'+EncodeLine7Bit(ExtractFileName(FileName), FCharSet)+'"');
  Part.SetLabelParamValue(_C_D, 'filename', '"'+EncodeLine7Bit(ExtractFileName(FileName), FCharSet)+'"');
  Part.SetLabelValue(_C_L, IntToStr(Part.FBody.Size));
  Part.FEmbedded := IsEmbedded;

  if IsEmbedded then
  begin

    Part.FOwnerPart := FRelatedPart;
    Part.FParentBoundary := FRelatedPart.GetBoundary;
    FRelatedPart.FSubPartList.Add(Part);
    Part.SetLabelValue(_C_D, _INLN);
    Part.SetLabelValue(_C_ID, '<'+ExtractFileName(FileName)+'>');
  end
  else
  begin

    Part.FOwnerPart := FMixedPart;
    Part.FParentBoundary := FMixedPart.GetBoundary;
    FMixedPart.FSubPartList.Add(Part);
    Part.SetLabelValue(_C_D, _ATCH);
  end;

  FAttachList.Add(Part);

  FNeedRebuild := True;
end;

// Remove attached file from message

procedure TMailMessage2000.DetachFile(const FileName: String);
var
  nLoop: Integer;

begin

  Normalize;

  for nLoop := 0 to FAttachList.Count-1 do
  begin

    if LowerCase(FAttachList[nLoop].FileName) = LowerCase(ExtractFileName(FileName)) then
    begin

      FAttachList[nLoop].Remove;
      FAttachList[nLoop].Free;
      FAttachList.Delete(nLoop);
      FNeedRebuild := True;
      Break;
    end;
  end;

  if not FNeedRebuild then
    raise Exception.Create(Self.Name+': Attachment filename not found');
end;

// Remove attached file from message by AttachList index

procedure TMailMessage2000.DetachFileIndex(const Index: Integer);
begin

  Normalize;

  if (Index < FAttachList.Count) and (Index >= 0) then
  begin

    FAttachList[Index].Remove;
    FAttachList[Index].Free;
    FAttachList.Delete(Index);
    FNeedRebuild := True;
  end
  else
    raise Exception.Create(Self.Name+': Attachment index not found');
end;

// Find the part containing the specified attachment

function TMailMessage2000.GetAttach(const FileName: String): TMailPart;
var
  nLoop: Integer;

begin

  Normalize;

  Result := nil;

  for nLoop := 0 to FAttachList.Count-1 do
  begin

    if LowerCase(FAttachList[nLoop].FileName) = LowerCase(FileName) then
    begin

      Result := FAttachList[nLoop];
      Break;
    end;
  end;

  if Result = nil then
    raise Exception.Create(Self.Name+': Attachment filename not found');
end;

// Rebuild body text according to the mailparts

procedure TMailMessage2000.RebuildBody;
var
  sLine: String;

  procedure RebuildBodyRec(MP: TMailPart);
  var
    Loop: Integer;
    Line: Integer;
    Data: String;
    nPos: Integer;

  begin

    for Loop := 0 to MP.SubPartList.Count-1 do
    begin

      sLine := #13#10;
      FBody.Write(sLine[1], Length(sLine));

      sLine :=  '--'+MP.SubPartList[Loop].FParentBoundary+#13#10;
      FBody.Write(sLine[1], Length(sLine));

      for Line := 0 to MP.SubPartList[Loop].FHeader.Count-1 do
      begin

        if Length(MP.SubPartList[Loop].FHeader[Line]) > 0 then
        begin

          sLine := MP.SubPartList[Loop].FHeader[Line]+#13#10;
          FBody.Write(sLine[1], Length(sLine));
        end;
      end;

      sLine := #13#10;
      FBody.Write(sLine[1], Length(sLine));

      if MP.SubPartList[Loop].SubPartList.Count > 0 then
      begin

        RebuildBodyRec(MP.SubPartList[Loop]);
      end
      else
      begin

        SetLength(Data, MP.SubPartList[Loop].FBody.Size);

        if MP.SubPartList[Loop].FBody.Size > 0 then
        begin

          MP.SubPartList[Loop].FBody.Position := 0;
          MP.SubPartList[Loop].FBody.ReadBuffer(Data[1], MP.SubPartList[Loop].FBody.Size);

          nPos := 1;

          while nPos >= 0 do
          begin

            DataLine(Data, sLine, nPos);

            sLine := sLine;
            FBody.Write(sLine[1], Length(sLine));
          end;
        end;
      end;
    end;

    if MP.SubPartList.Count > 0 then
    begin

      sLine := #13#10;
      FBody.Write(sLine[1], Length(sLine));

      sLine := '--'+MP.SubPartList[0].FParentBoundary+'--'#13#10;
      FBody.Write(sLine[1], Length(sLine));
    end;
  end;

begin

  if not FNeedRebuild then
    Exit;

  if SubPartList.Count > 0 then
  begin

    FBody.Clear;

    sLine := _MIME_Msg;
    FBody.Write(sLine[1], Length(sLine));

    RebuildBodyRec(Self);

    SetLabelValue(_C_L, IntToStr(FBody.Size));
  end;

  FNeedRebuild := False;
end;

// Empty data stored in the object

procedure TMailMessage2000.Reset;
var
  Loop: Integer;

begin

  for Loop := 0 to FSubPartList.Count-1 do
    FSubPartList.Items[Loop].Destroy;

  FHeader.Clear;
  FBody.Clear;
  FDecoded.Clear;
  FSubPartList.Clear;

  FAttachList.Clear;
  FTextPlain.Clear;
  FTextHTML.Clear;
  FTextPlainPart := nil;
  FTextHTMLPart := nil;
  FMixedPart := nil;
  FRelatedPart := nil;
  FAlternativePart := nil;
  FNeedRebuild := False;
  FNeedNormalize := True;
  FNeedFindParts := False;
  FNameCount := 0;
end;

{ TSocketTalk =================================================================== }

// Initialize TSocketTalk

constructor TSocketTalk.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  FClientSocket := TClientSocket.Create(Self);
  FClientSocket.ClientType := ctNonBlocking;
  FClientSocket.OnRead := SocketRead;
  FClientSocket.OnDisconnect := SocketDisconnect;
  FClientSocket.Socket.OnErrorEvent := SocketError;

  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.OnTimer := Timer;

  FTimeOut := 60;
  FLastResponse := '';
  FExpectedEnd := '';
  FDataSize := 0;
  FPacketSize := 0;
  FTalkError := teNoError;
end;

// Finalize TSocketTalk

destructor TSocketTalk.Destroy;
begin

  FClientSocket.Free;
  FTimer.Free;

  inherited Destroy;
end;

// Occurs when data is comming from the socket

procedure TSocketTalk.SocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Buffer: String;
  BufLen: Integer;

begin

  SetLength(Buffer, Socket.ReceiveLength);
  BufLen := Socket.ReceiveBuf(Buffer[1], Length(Buffer));
  FLastResponse := FLastResponse + Copy(Buffer, 1, BufLen);
  FTalkError := teNoError;
  FTimer.Enabled := False;

  if Assigned(FOnReceiveData) then
  begin

    FOnReceiveData(Self, FSessionState, Buffer, FServerResult);
  end;

  if (FDataSize > 0) and Assigned(FOnProgress) then
  begin

    FOnProgress(Self.Owner, FDataSize, Length(FLastResponse));
  end;

  if (FExpectedEnd = '') or (Copy(FLastResponse, Length(FLastResponse)-Length(FExpectedEnd)+1, Length(FExpectedEnd)) = FExpectedEnd) then
  begin

    FTalkError := teNoError;
    FDataSize := 0;
    FExpectedEnd := '';
    FWaitingServer := False;

    if Assigned(FOnEndOfData) then
    begin

      FOnEndOfData(Self, FSessionState, FLastResponse, FServerResult);
    end;

    FSessionState := stNone;
  end
  else
  begin

    FTimer.Enabled := True;
  end;
end;

// Occurs when socket is disconnected

procedure TSocketTalk.SocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin

  if Assigned(FOnDisconnect) then
    FOnDisconnect(Self);

  FTimer.Enabled := False;
  FWaitingServer := False;
  FSessionState := stNone;
  FExpectedEnd := '';
  FDataSize := 0;
  FPacketSize := 0;
end;

// Occurs on socket error

procedure TSocketTalk.SocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin

  FTimer.Enabled := False;
  FTalkError := TTalkError(Ord(ErrorEvent));
  FDataSize := 0;
  FExpectedEnd := '';
  FWaitingServer := False;
  FServerResult := False;

  if Assigned(FOnSocketTalkError) then
  begin

    FOnSocketTalkError(Self, FSessionState, FTalkError);
  end;

  FSessionState := stNone;
  ErrorCode := 0;
end;

// Occurs on timeout

procedure TSocketTalk.Timer(Sender: TObject);
begin

  FTimer.Enabled := False;
  FTalkError := teTimeout;
  FDataSize := 0;
  FExpectedEnd := '';
  FWaitingServer := False;
  FServerResult := False;

  if Assigned(FOnSocketTalkError) then
  begin

    FOnSocketTalkError(Self, FSessionState, FTalkError);
  end;

  FSessionState := stNone;
end;

// Cancel the waiting for server response

procedure TSocketTalk.Cancel;
begin

  FTimer.Enabled := False;
  FTalkError := teNoError;
  FSessionState := stNone;
  FExpectedEnd := '';
  FDataSize := 0;
  FWaitingServer := False;
  FServerResult := False;
end;

// Inform that the data comming belongs

procedure TSocketTalk.ForceState(SessionState: TSessionState);
begin

  FExpectedEnd := '';
  FLastResponse := '';
  FTimer.Interval := FTimeOut * 1000;
  FTimer.Enabled := True;
  FDataSize := 0;
  FTalkError := teNoError;
  FSessionState := SessionState;
  FWaitingServer := True;
  FServerResult := False;
end;

// Send a command to server

procedure TSocketTalk.Talk(Buffer, EndStr: String; SessionState: TSessionState);
var
  nPos: Integer;
  nLen: Integer;

begin

  FExpectedEnd := EndStr;
  FSessionState := SessionState;
  FLastResponse := '';
  FTimer.Interval := FTimeOut * 1000;
  FTalkError := teNoError;
  FWaitingServer := True;
  FServerResult := False;
  nPos := 1;

  if (FPacketSize > 0) and (Length(Buffer) > FPacketSize) then
  begin

    if Assigned(OnProgress) then
      OnProgress(Self.Owner, Length(Buffer), 0);

    while nPos <= Length(Buffer) do
    begin

      Application.ProcessMessages;

      if (nPos+FPacketSize-1) > Length(Buffer) then
        nLen := Length(Buffer)-nPos+1
      else
        nLen := FPacketSize;

      FTimer.Enabled := True;

      while (FClientSocket.Socket.SendBuf(Buffer[nPos], nLen) = -1) do
        Sleep(10);

      FTimer.Enabled := False;
      nPos := nPos + nLen;

      if Assigned(OnProgress) then
        OnProgress(Self.Owner, Length(Buffer), nPos-1);
    end;
  end
  else
  begin

    while (FClientSocket.Socket.SendBuf(Buffer[1], Length(Buffer)) = -1 )
       do Sleep (10);
  end;

  FPacketSize := 0;
end;

// Wait for server response
// by Rene de Jong (rmdejong@ism.nl)

procedure TSocketTalk.WaitServer;
begin

  FTimer.Interval := FTimeOut * 1000;

  while FWaitingServer and (not FServerResult) do
  begin

    FTimer.Enabled := True;
    Application.ProcessMessages;
  end;

  FTimer.Enabled:= False;
end;

{ TPOP2000 ====================================================================== }

// Initialize TPOP2000

constructor TPOP2000.Create;
begin

  FSocketTalk := TSocketTalk.Create(Self);
  FSocketTalk.OnEndOfData := EndOfData;
  FSocketTalk.OnSocketTalkError := SocketTalkError;
  FSocketTalk.OnReceiveData := ReceiveData;
  FSocketTalk.OnDisconnect := SocketDisconnect;

  FHost := '';
  FPort := 110;
  FUserName := '';
  FPassword := '';
  FSessionMessageCount := -1;
  FSessionConnected := False;
  FSessionLogged := False;
  FMailMessage := nil;
  FDeleteOnRetrieve := False;

  SetLength(FSessionMessageSize, 0);

  inherited Create(AOwner);
end;

// Finalize TPOP2000

destructor TPOP2000.Destroy;
begin

  FSocketTalk.Free;

  SetLength(FSessionMessageSize, 0);

  inherited Destroy;
end;

// Set timeout

procedure TPOP2000.SetTimeOut(Value: Integer);
begin

  FSocketTalk.TimeOut := Value;
end;

// Get timeout

function TPOP2000.GetTimeOut: Integer;
begin

  Result := FSocketTalk.TimeOut;
end;

// Set OnProgress event

procedure TPOP2000.SetProgress(Value: TProgressEvent);
begin

  FSocketTalk.OnProgress := Value;
end;

// Get OnProgress event

function TPOP2000.GetProgress: TProgressEvent;
begin

  Result := FSocketTalk.OnProgress;
end;

// Get LastResponse

function TPOP2000.GetLastResponse: String;
begin

  Result := FSocketTalk.LastResponse;
end;

// When data from server ends

procedure TPOP2000.EndOfData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
begin

  case SessionState of

    stConnect, stUser, stPass, stStat, stList, stRetr, stQuit, stDele, stUIDL:
    if Copy(Data, 1, 3) = '+OK' then
      ServerResult := True;
  end;
end;

// On socket error

procedure TPOP2000.SocketTalkError(Sender: TObject; SessionState: TSessionState; TalkError: TTalkError);
begin

  FSocketTalk.Cancel;
end;

// On data received

procedure TPOP2000.ReceiveData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
begin

  if (Copy(Data, 1, 4) = '-ERR') and (Copy(Data, Length(Data)-1, 2) = #13#10) then
  begin

    ServerResult := False;
    FSocketTalk.Cancel;
  end;
end;

// On socket disconnected

procedure TPOP2000.SocketDisconnect(Sender: TObject);
begin

  FSessionMessageCount := -1;
  FSessionConnected := False;
  FSessionLogged := False;

  SetLength(FSessionMessageSize, 0);
end;

// Connect socket

function TPOP2000.Connect: Boolean;
begin

  if FSessionConnected or FSocketTalk.ClientSocket.Active then
  begin

    Result := False;
    Exit;
  end;

  if Length(FHost) = 0 then
  begin

    Result := False;
    Exit;
  end;

  if not IsIPAddress(FHost) then
  begin

    FSocketTalk.ClientSocket.Host := FHost;
    FSocketTalk.ClientSocket.Address := '';
  end
  else
  begin

    FSocketTalk.ClientSocket.Host := '';
    FSocketTalk.ClientSocket.Address := FHost;
  end;

  FSocketTalk.ClientSocket.Port := FPort;
  FSocketTalk.ForceState(stConnect);
  FSocketTalk.ClientSocket.Open;

  FSocketTalk.WaitServer;

  FSessionConnected := FSocketTalk.ServerResult;
  Result := FSocketTalk.ServerResult;
end;

// POP3 Logon

function TPOP2000.Login: Boolean;
var
  MsgList: TStringList;
  Loop: Integer;
  cStat: String;

begin

  Result := False;

  if (not FSessionConnected) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.Talk('USER'#32+FUserName+#13#10, #13#10, stUser);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    FSocketTalk.Talk('PASS'#32+FPassword+#13#10, #13#10, stPass);
    FSocketTalk.WaitServer;

    if FSocketTalk.ServerResult then
    begin

      FSessionLogged := True;

      FSocketTalk.Talk('LIST'#13#10, _DATAEND1, stList);
      FSocketTalk.WaitServer;

      if FSocketTalk.ServerResult then
      begin

        MsgList := TStringList.Create;
        MsgList.Text := FSocketTalk.LastResponse;

        if MsgList.Count > 2 then
        begin

          cStat := TrimSpace(MsgList[MsgList.Count-2]);

          FSessionMessageCount := StrToIntDef(Copy(cStat, 1, Pos(#32, cStat)-1), -1);

          if FSessionMessageCount > 0 then
          begin

            for Loop := 1 to MsgList.Count-2 do
            begin

              cStat := TrimSpace(MsgList[Loop]);
              cStat := Copy(cStat, 1, Pos(#32, cStat)-1);

              SetLength(FSessionMessageSize, StrToInt(cStat)+1);

              if StrToIntDef(cStat, 0) > 0 then
                FSessionMessageSize[StrToInt(cStat)] := StrToIntDef(Copy(MsgList[Loop], Pos(#32, MsgList[Loop])+1, 99), 0);
            end;

            FSessionMessageSize[0] := 0;
          end;
        end
        else
        begin

          FSessionMessageCount := 0;
          SetLength(FSessionMessageSize, 0);
        end;

        MsgList.Free;
      end;
    end;
  end;

  Result := FSessionLogged;
end;

// POP3 Quit

function TPOP2000.Quit: Boolean;
begin

  Result := False;

  if (not FSessionConnected) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.Talk('QUIT'#13#10, #13#10, stQuit);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    FSocketTalk.ClientSocket.Close;
    FSessionConnected := False;
    FSessionLogged := False;
    FSessionMessageCount := -1;
    Result := True;
  end;
end;

// Force disconnection

procedure TPOP2000.Abort;
begin

  FSocketTalk.ClientSocket.Close;
  FSessionConnected := False;
  FSessionLogged := False;
  FSessionMessageCount := -1;
end;

// Retrieve message#

function TPOP2000.RetrieveMessage(Number: Integer): Boolean;
var
  MailTxt: TStringList;

begin

  Result := False;
  FLastMessage := '';

  if (not FSessionConnected) or (not FSessionLogged) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.DataSize := FSessionMessageSize[Number-1];
  FSocketTalk.Talk('RETR'#32+IntToStr(Number)+#13#10, _DATAEND1, stRetr);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    MailTxt := TStringList.Create;
    MailTxt.Text := FSocketTalk.LastResponse;
    MailTxt.Delete(MailTxt.Count-1);
    MailTxt.Delete(0);
    FLastMessage := MailTxt.Text;
    MailTxt.Free;

    if Assigned(FMailMessage) then
    begin

      FMailMessage.Reset;
      FMailMessage.Fill(PChar(FLastMessage), True);
    end;

    Result := True;

    if FDeleteOnRetrieve then
      DeleteMessage(Number);
  end;
end;

// Retrieve message# (only header)

function TPOP2000.RetrieveHeader(Number: Integer; Lines: Integer = 0): Boolean;
var
  MailTxt: TStringList;

begin

  Result := False;
  FLastMessage := '';

  if (not FSessionConnected) or (not FSessionLogged) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.DataSize := FSessionMessageSize[Number-1];
  FSocketTalk.Talk('TOP'#32+IntToStr(Number)+#32+IntToStr(Lines)+#13#10, _DATAEND1, stRetr);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    MailTxt := TStringList.Create;
    MailTxt.Text := FSocketTalk.LastResponse;
    MailTxt.Delete(MailTxt.Count-1);
    MailTxt.Delete(0);
    FLastMessage := MailTxt.Text;

    if Assigned(FMailMessage) then
    begin

      FMailMessage.Reset;
      FMailMessage.FHeader.Text := PChar(FLastMessage);
    end;

    Result := True;
  end;
end;

// Delete message#

function TPOP2000.DeleteMessage(Number: Integer): Boolean;
begin

  Result := False;

  if (not FSessionConnected) or (not FSessionLogged) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.Talk('DELE'#32+IntToStr(Number)+#13#10, #13#10, stDele);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    Result := True;
  end;
end;

// Get UIDL from message#

function TPOP2000.GetUIDL(Number: Integer): String;
var
  MsgNum: String;

begin

  Result := '';
  MsgNum := IntToStr(Number);

  if (not FSessionConnected) or (not FSessionLogged) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.Talk('UIDL'#32+MsgNum+#13#10, #13#10, stUIDL);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    Result := FSocketTalk.LastResponse;
    Result := Trim(Copy(Result, Pos(MsgNum+#32, Result)+Length(MsgNum)+1, Length(Result)));
  end;
end;

{ TSMTP2000 ====================================================================== }

// Initialize TSMTP2000

constructor TSMTP2000.Create;
begin

  FSocketTalk := TSocketTalk.Create(Self);
  FSocketTalk.OnEndOfData := EndOfData;
  FSocketTalk.OnSocketTalkError := SocketTalkError;
  FSocketTalk.OnReceiveData := ReceiveData;
  FSocketTalk.OnDisconnect := SocketDisconnect;

  FHost := '';
  FPort := 25;
  FSessionConnected := False;
  FPacketSize := 102400;

  inherited Create(AOwner);
end;

// Finalize TSMTP2000

destructor TSMTP2000.Destroy;
begin

  FSocketTalk.Free;

  inherited Destroy;
end;

// Set timeout

procedure TSMTP2000.SetTimeOut(Value: Integer);
begin

  FSocketTalk.TimeOut := Value;
end;

// Get timeout

function TSMTP2000.GetTimeOut: Integer;
begin

  Result := FSocketTalk.TimeOut;
end;

// Set OnProgress event

procedure TSMTP2000.SetProgress(Value: TProgressEvent);
begin

  FSocketTalk.OnProgress := Value;
end;

// Get OnProgress event

function TSMTP2000.GetProgress: TProgressEvent;
begin

  Result := FSocketTalk.OnProgress;
end;

// Get LastResponse

function TSMTP2000.GetLastResponse: String;
begin

  Result := FSocketTalk.LastResponse;
end;

// When data from server ends

procedure TSMTP2000.EndOfData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
begin

  case SessionState of

    stConnect:
    if Copy(Data, 1, 3) = '220' then
      ServerResult := True;

    stHelo, stMail, stRcpt, stSendData:
    if Copy(Data, 1, 3) = '250' then
      ServerResult := True;

    stData:
    if Copy(Data, 1, 3) = '354' then
      ServerResult := True;

    stQuit:
    if Copy(Data, 1, 3) = '221' then
      ServerResult := True;
  end;
end;

// On socket error

procedure TSMTP2000.SocketTalkError(Sender: TObject; SessionState: TSessionState; TalkError: TTalkError);
begin

  FSocketTalk.Cancel;
end;

// On data received

procedure TSMTP2000.ReceiveData(Sender: TObject; SessionState: TSessionState; Data: String; var ServerResult: Boolean);
begin

  if (StrToIntDef(Copy(Data, 1, 3), 0) >= 500) and (Copy(Data, Length(Data)-1, 2) = #13#10) then
  begin

    ServerResult := False;
    FSocketTalk.Cancel;
  end;
end;

// On socket disconnected

procedure TSMTP2000.SocketDisconnect(Sender: TObject);
begin

  FSessionConnected := False;
end;

// Connect socket

function TSMTP2000.Connect: Boolean;
begin

  Result := False;

  if FSessionConnected or FSocketTalk.ClientSocket.Active then
  begin

    Exit;
  end;

  if Length(FHost) = 0 then
  begin

    Exit;
  end;

  if not IsIPAddress(FHost) then
  begin

    FSocketTalk.ClientSocket.Host := FHost;
    FSocketTalk.ClientSocket.Address := '';
  end
  else
  begin

    FSocketTalk.ClientSocket.Host := '';
    FSocketTalk.ClientSocket.Address := FHost;
  end;

  FSocketTalk.ClientSocket.Port := FPort;
  FSocketTalk.ForceState(stConnect);
  FSocketTalk.ClientSocket.Open;

  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    FSocketTalk.Talk('HELO'#32+FSocketTalk.FClientSocket.Socket.LocalHost+#13#10, #13#10, stHelo);
    FSocketTalk.WaitServer;
  end;

  FSessionConnected := FSocketTalk.ServerResult;
  Result := FSocketTalk.ServerResult;
end;

// SMTP Quit

function TSMTP2000.Quit: Boolean;
begin

  Result := False;

  if (not FSessionConnected) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  FSocketTalk.Talk('QUIT'#13#10, #13#10, stQuit);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    FSocketTalk.ClientSocket.Close;
    FSessionConnected := False;
    Result := True;
  end;
end;

// Force disconnection

procedure TSMTP2000.Abort;
begin

  FSocketTalk.ClientSocket.Close;
  FSessionConnected := False;
end;

// Send message

function TSMTP2000.SendMessage: Boolean;
var
  sDests: String;

begin

  if not Assigned(FMailMessage) then
  begin

    Exception.Create(Self.Name+': MailMessage unassigned');
    Result := False;
    Exit;
  end;

  if FMailMessage.ToList.Count > 0 then
    sDests := FMailMessage.ToList.AllAddresses;

  if FMailMessage.CcList.Count > 0 then
  begin

    if sDests <> '' then sDests := sDests + ',';
    sDests := sDests + FMailMessage.CcList.AllAddresses;
  end;

  if FMailMessage.BccList.Count > 0 then
  begin

    if sDests <> '' then sDests := sDests + ',';
    sDests := sDests + FMailMessage.BccList.AllAddresses;
  end;

  Result := SendMessageTo(FMailMessage.FromAddress, sDests);
end;

// Send message to specified recipients

function TSMTP2000.SendMessageTo(const From, Dests: String): Boolean;
var
  Loop: Integer;
  AllOk: Boolean;
  sDests: TStringList;
  sHeader: String;

begin

  Result := False;

  if (not FSessionConnected) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  if not Assigned(FMailMessage) then
  begin

    Exception.Create(Self.Name+': MailMessage unassigned');
    Exit;
  end;

  if FMailMessage.FNeedRebuild then
  begin

    Exception.Create(Self.Name+': MailMessage need rebuild');
    Exit;
  end;

  sDests := TStringList.Create;
  sDests.Sorted := True;
  sDests.Duplicates := dupIgnore;
  sDests.CommaText := Dests;

  if sDests.Count = 0 then
  begin

    Exception.Create(Self.Name+': No recipients to send message');
    Exit;
  end;

  FSocketTalk.Talk('MAIL FROM: <'+From+'>'#13#10, #13#10, stMail);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    AllOk := True;

    for Loop := 0 to sDests.Count-1 do
    begin

      FSocketTalk.Talk('RCPT TO: <'+sDests[Loop]+'>'#13#10, #13#10, stRcpt);
      FSocketTalk.WaitServer;

      if not FSocketTalk.ServerResult then
      begin

        AllOk := False;
        Break;
      end;
    end;

    if AllOk then
    begin

      FMailMessage.SetMessageId(FSocketTalk.ClientSocket.Socket.LocalAddress);
      sHeader := FMailMessage.FHeader.Text;
      FMailMessage.SetLabelValue('Bcc', '');

      FSocketTalk.Talk('DATA'#13#10, #13#10, stData);
      FSocketTalk.WaitServer;

      if FSocketTalk.ServerResult then
      begin

        FSocketTalk.PacketSize := FPacketSize;
        FSocketTalk.Talk(StringReplace(FMailMessage.MessageSource, _DATAEND1, _DATAEND2, [rfReplaceAll])+_DATAEND1, #13#10, stSendData);
        FSocketTalk.WaitServer;

        if FSocketTalk.ServerResult then
        begin

          Result := True;
        end;
      end;

      FMailMessage.FHeader.Text := sHeader;
    end;
  end;

  sDests.Free;
end;

// Send string to specified recipients

function TSMTP2000.SendStringTo(const Msg, From, Dests: String): Boolean;
var
  Loop: Integer;
  AllOk: Boolean;
  sDests: TStringList;

begin

  Result := False;

  if (not FSessionConnected) or (not FSocketTalk.ClientSocket.Active) then
  begin

    Exit;
  end;

  sDests := TStringList.Create;
  sDests.Sorted := True;
  sDests.Duplicates := dupIgnore;
  sDests.CommaText := Dests;

  if sDests.Count = 0 then
  begin

    Exception.Create(Self.Name+': No recipients to send message');
    Exit;
  end;

  FSocketTalk.Talk('MAIL FROM: <'+From+'>'#13#10, #13#10, stMail);
  FSocketTalk.WaitServer;

  if FSocketTalk.ServerResult then
  begin

    AllOk := True;

    for Loop := 0 to sDests.Count-1 do
    begin

      FSocketTalk.Talk('RCPT TO: <'+sDests[Loop]+'>'#13#10, #13#10, stRcpt);
      FSocketTalk.WaitServer;

      if not FSocketTalk.ServerResult then
      begin

        AllOk := False;
        Break;
      end;
    end;

    if AllOk then
    begin

      FSocketTalk.Talk('DATA'#13#10, #13#10, stData);
      FSocketTalk.WaitServer;

      if FSocketTalk.ServerResult then
      begin

        FSocketTalk.PacketSize := FPacketSize;
        FSocketTalk.Talk(StringReplace(Msg, _DATAEND1, _DATAEND2, [rfReplaceAll])+_DATAEND1, #13#10, stSendData);
        FSocketTalk.WaitServer;

        if FSocketTalk.ServerResult then
        begin

          Result := True;
        end;
      end;
    end;
  end;

  sDests.Free;
end;

//clq
procedure save_to_file1(msg1:TMailMessage2000;fn1:string);
var
  i1:integer;
  sl1,sl2:tstringlist;
  part1:TMailPart;
  s1:string;

  function GetBodySource(fpart1:TMailPart): String;
  begin

    SetLength(Result, fpart1.FBody.Size);
    fpart1.FBody.Position := 0;
    fpart1.FBody.ReadBuffer(Result[1], fpart1.FBody.Size);
    //Result := WrapHeader(FHeader.Text)+#13#10+Result;
  end;

  function GetHeaderSource(fpart1:TMailPart;fbz1:string=''): String;
  begin
    //先取得头信息
    part1.Header.Text:=fpart1.Header.Text;
    //如果是邮件的头信息就改变分隔界线
    if fbz1='mail' then part1.SetLabelParamValue(_C_T, _BDRY, '"'+s1+'"');
    //如果是正文的头信息就删除文件名
    if fbz1='text' then part1.SetLabelValue('Content-Disposition','inline');
    Result := WrapHeader(part1.Header.Text);
  end;

  //加入一个tmailpart中的源码，并进行必要修正
  procedure AddPartSource(fpart1:TMailPart;fbz1:string='');
  begin
    //分隔行
    sl1.Add('');
    //分界符
    sl1.Add('--'+s1);

    part1.Header.Text:=fpart1.Header.Text;
    //得到头信息
    sl2.Text:=GetHeaderSource(part1,fbz1);
    sl1.Add(sl2.Text);
    //得到body的信息
    sl2.Text:=GetBodySource(fpart1);
    sl1.Add(sl2.Text);

  end;

begin
  sl1:=tstringlist.Create;
  sl2:=tstringlist.Create;
  part1:=TMailPart.Create(nil);
  s1:=GenerateBoundary;

  //这句是一定要有的
  msg1.FNeedFindParts:=true;
  //这句是一定要有的[可能是mail2000的bug，没有上一句的话，FTextPlainPart是空的]
  msg1.FindParts;

  //邮件信息头
  sl1.Add(GetHeaderSource(msg1,'mail'));

  //正文
  AddPartSource(msg1.FTextPlainPart,'text');


  //附件
  for i1:=0 to msg1.AttachList.Count-1 do
  begin
    AddPartSource(msg1.AttachList.Items[i1]);

    //好象是最后一部分时要再加一个"--"在后面，其余的部分都是在前面加就可以了
    if i1=msg1.AttachList.Count-1  then sl1.Add('--'+s1+'--')
    
  end;

  sl1.SaveToFile(fn1);
  sl1.Free;
  sl2.Free;
  part1.Free;

end;

// =============================================================================
//唐的算法有误已删除
//标题：关于字符集的问题! 恳请指点!!唐晓峰请进!诸位专家请进! (100分)
//Nuke2 (1999-5-25 20:26) 109912

begin

  Randomize;
end.

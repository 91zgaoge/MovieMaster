unit OpensubtitlesAPI;

interface

uses
  IdHTTP, Classes, SysUtils;

  function LogIn(aUsername, aPassword,
                 aLanguage, aUserAgent: string): string;
  function LogOut(aToken: string): string;
  function SearchSubtitles(aToken, aSublanguageID,
                           aMovieHash: string;
                           aMovieByteSize: Cardinal): string;  overload;
  function SearchSubtitles(aToken, aSublanguageID: string;
                           aImdbID: Cardinal): string; overload;
  function SearchSubtitles(aToken, aSublanguageID,
                           aQuery: string): string;  overload;

implementation

function XML_RPC(aRPCRequest: string): string;
const
  cURL= 'http://api.opensubtitles.org/xml-rpc';
var
  lHTTP: TIdHTTP;
  Source,
  ResponseContent: TStringStream;
begin
  lHTTP := TIdHTTP.Create(nil);
  lHTTP.Request.ContentType := 'text/xml';
  lHTTP.Request.Accept := '*/*';
  lHTTP.Request.Connection := 'Keep-Alive';
  lHTTP.Request.Method := 'POST';
  lHTTP.Request.UserAgent := 'OS Test User Agent';
  Source := TStringStream.Create(aRPCRequest);
  ResponseContent:= TStringStream.Create;
  try
    try
      lHTTP.Post(cURL, Source, ResponseContent);
      Result:= ResponseContent.DataString;
    except
      Result:= '';
    end;
  finally
    lHTTP.Free;
    Source.Free;
    ResponseContent.Free;
  end;
end;

function LogIn(aUsername, aPassword, aLanguage, aUserAgent: string): string;
const
  LOG_IN = '<?xml version="1.0"?>' +
           '<methodCall>' +
           '  <methodName>LogIn</methodName>' +
           '  <params>'   +
           '    <param>'  +
           '      <value><string>%0:s</string></value>' +
           '    </param>' +
           '    <param>'  +
           '      <value><string>%1:s</string></value>' +
           '    </param>' +
           '    <param>'  +
           '      <value><string>%2:s</string></value>' +
           '    </param>' +
           '    <param>'  +
           '      <value><string>%3:s</string></value>' +
           '    </param>' +
           '  </params>'  +
           '</methodCall>';
begin
  //TODO: XML Encoding
  Result:= XML_RPC(Format(LOG_IN, [aUsername, aPassword, aLanguage, aUserAgent]));
end;

function LogOut(aToken: string): string;
const
  LOG_OUT = '<?xml version="1.0"?>' +
           '<methodCall>' +
           '  <methodName>LogOut</methodName>' +
           '  <params>'   +
           '    <param>'  +
           '      <value><string>%0:s</string></value>' +
           '    </param>' +
           '  </params>'  +
           '</methodCall>';
begin
  //TODO: XML Encoding
  Result:= XML_RPC(Format(LOG_OUT, [aToken]));
end;

function SearchSubtitles(aToken, aSublanguageID, aMovieHash: string; aMovieByteSize: Cardinal): string;
const
  SEARCH_SUBTITLES = '<?xml version="1.0"?>' +
                     '<methodCall>' +
                     '  <methodName>SearchSubtitles</methodName>' +
                     '  <params>' +
                     '    <param>' +
                     '      <value><string>%0:s</string></value>' +
                     '    </param>' +
                     '  <param>' +
                     '   <value>' +
                     '    <array>' +
                     '     <data>' +
                     '      <value>' +
                     '       <struct>' +
                     '        <member>' +
                     '         <name>sublanguageid</name>' +
                     '         <value><string>%1:s</string>' +
                     '         </value>' +
                     '        </member>' +
                     '        <member>' +
                     '         <name>moviehash</name>' +
                     '         <value><string>%2:s</string></value>' +
                     '        </member>' +
                     '        <member>' +
                     '         <name>moviebytesize</name>' +
                     '         <value><double>%3:d</double></value>' +
                     '        </member>' +
                     '       </struct>' +
                     '      </value>' +
                     '     </data>' +
                     '    </array>' +
                     '   </value>' +
                     '  </param>' +
                     ' </params>' +
                     '</methodCall>';

begin
  //TODO: XML Encoding
  Result:= XML_RPC(Format(SEARCH_SUBTITLES, [aToken, aSublanguageID, aMovieHash, aMovieByteSize]));
end;

function SearchSubtitles(aToken, aSublanguageID: string;
  aImdbID: Cardinal): string;
const
  SEARCH_SUBTITLES = '<?xml version="1.0"?>' +
                     '<methodCall>' +
                     '  <methodName>SearchSubtitles</methodName>' +
                     '  <params>' +
                     '    <param>' +
                     '      <value><string>%0:s</string></value>' +
                     '    </param>' +
                     '  <param>' +
                     '   <value>' +
                     '    <array>' +
                     '     <data>' +
                     '      <value>' +
                     '       <struct>' +
                     '        <member>' +
                     '         <name>sublanguageid</name>' +
                     '         <value><string>%1:s</string>' +
                     '         </value>' +
                     '        </member>' +
                     '        <member>' +
                     '         <name>imdbid</name>' +
                     '         <value><string>%2:d</string></value>' +
                     '        </member>' +
                     '       </struct>' +
                     '      </value>' +
                     '     </data>' +
                     '    </array>' +
                     '   </value>' +
                     '  </param>' +
                     ' </params>' +
                     '</methodCall>';

begin
  //TODO: XML Encoding
  Result:= XML_RPC(Format(SEARCH_SUBTITLES, [aToken, aSublanguageID, aImdbID]));
end;

function SearchSubtitles(aToken, aSublanguageID,
  aQuery: string): string;
const
  SEARCH_SUBTITLES = '<?xml version="1.0"?>' +
                     '<methodCall>' +
                     '  <methodName>SearchSubtitles</methodName>' +
                     '  <params>' +
                     '    <param>' +
                     '      <value><string>%0:s</string></value>' +
                     '    </param>' +
                     '  <param>' +
                     '   <value>' +
                     '    <array>' +
                     '     <data>' +
                     '      <value>' +
                     '       <struct>' +
                     '        <member>' +
                     '         <name>sublanguageid</name>' +
                     '         <value><string>%1:s</string>' +
                     '         </value>' +
                     '        </member>' +
                     '        <member>' +
                     '         <name>query</name>' +
                     '         <value><string>%2:s</string></value>' +
                     '        </member>' +
                     '       </struct>' +
                     '      </value>' +
                     '     </data>' +
                     '    </array>' +
                     '   </value>' +
                     '  </param>' +
                     ' </params>' +
                     '</methodCall>';

begin
  //TODO: XML Encoding
  Result:= XML_RPC(Format(SEARCH_SUBTITLES, [aToken, aSublanguageID, aQuery]));
end;
{
http://www.yanniel.info/2012/01/open-subtitles-api-in-delphi.html
 Finally, I present you some sample calls:

Logging- in anonymously (empty credentials) and getting the token:

LogIn('', '', 'en', 'OS Test User Agent');

Logging- out (disposing the token):

LogOut('81nt6bgl9vde06l3ptq7v1a7r1');

Search English subtitles for the movie whose ImdbID is 120737

SearchSubtitles(Edit1.Text, 'eng', 120737);

Search English subtitles for The Lord of the Rings

SearchSubtitles(Edit1.Text, 'eng', 'The Lord of the Rings');


Search English subtitles for the movie whose hash is 7d9cd5def91c9432 and size is 735934464.

SearchSubtitles(Edit1.Text, 'eng', '7d9cd5def91c9432', 735934464);

}
end.


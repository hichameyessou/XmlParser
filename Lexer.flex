
%%

%byaccj

%x TAG ATTR DOC

%{
	private Parser yyparser;
	
	public Yylex(java.io.Reader r, Parser yyparser) {
		this(r);
		this.yyparser = yyparser;
	}

%}

TAG_MESSAGE = "message"
TAG_HEADER = "header"
TAG_DATA = "data"
TYPE = "type"
TAG_METADATA = "metadata"
TAG_FORMAT = "format"
TAG_EMPTY = "empty"
TAG_SECTION = "section"
TAG_PARAGRAPH = "paragraph"
TAG_FIGURE = "figure"
TAG_TABLE = "table"
TAG_ANCHOR = "anchor"
TAG_LINK = "link"
TAG_ROW = "row"
TAG_CELL = "cell"

ATTR_ID = "id"
ATTR_NORMAL = "normal"
ATTR_REASON = "reason"
ATTR_FORWARD = "forward"
ATTR_REPLY = "reply"
ATTR_NAME = "name"
ATTR_EXTVALUE = "value"
ATTR_PLAIN = "plain"
ATTR_STRUCTURED = "structured"
ATTR_TITLE = "title"
ATTR_CAPTION = "caption"
ATTR_PATH = "path"
ATTR_TARGET = "target"
ATTR_VALUE = \"[\ a-zA-Z0-9\-_\.]+\" | \'[\ a-zA-Z0-9\-_\.]+\' | "\"\""
PATH_VALUE = \"[a-zA-Z]+\/[a-zA-Z]+\/[a-zA-Z]+.[a-zA-Z]+"\""

TAG_START = "<"
TAG_CLOSE = ">"
TAG_FINISH = <\/
TAG_FINISH_SHORT = \/>
EQUAL = "="
CONTENT = [^<\=\">]+
DOC_CONTENT = [^<>]+
SPACE = [\n\t\r\ ]+

DOC_START = "<!" | "<?"


%%

/*YYINITIAL è stato inclusivo*/
/*yybegin mi pone il lexer nello stato tra parentesi*/

<YYINITIAL, TAG, ATTR, DOC> {SPACE} {}
<YYINITIAL> {CONTENT} {yyparser.yylval = new ParserVal(yytext()); return Parser.CONTENT;}
<YYINITIAL> {TAG_START}	{yybegin(TAG); return Parser.TAG_START;}
<YYINITIAL> {TAG_FINISH} {yybegin(TAG); return Parser.TAG_FINISH;}
<YYINITIAL> {DOC_START} {yybegin(DOC); return Parser.DOC_START;}

<TAG> {TAG_MESSAGE} {yybegin(ATTR); return Parser.TAG_MESSAGE;}
<TAG> {TAG_HEADER} {yybegin(ATTR); return Parser.TAG_HEADER;}
<TAG> {TAG_DATA} {yybegin(ATTR); return Parser.TAG_DATA;}
<TAG> {TYPE} {yybegin(ATTR); return Parser.TYPE;} 
<TAG> {TAG_METADATA} {yybegin(ATTR); return Parser.TAG_METADATA;}
<TAG> {TAG_FORMAT} {yybegin(ATTR); return Parser.TAG_FORMAT;}
<TAG> {TAG_EMPTY} {yybegin(ATTR); return Parser.TAG_EMPTY;}
<TAG> {TAG_SECTION} {yybegin(ATTR); return Parser.TAG_SECTION;}
<TAG> {TAG_PARAGRAPH} {yybegin(ATTR); return Parser.TAG_PARAGRAPH;}
<TAG> {TAG_FIGURE} {yybegin(ATTR); return Parser.TAG_FIGURE;}
<TAG> {TAG_TABLE} {yybegin(ATTR); return Parser.TAG_TABLE;}
<TAG> {TAG_ANCHOR} {yybegin(ATTR); return Parser.TAG_ANCHOR;}
<TAG> {TAG_LINK} {yybegin(ATTR); return Parser.TAG_LINK;}
<TAG> {TAG_ROW} {yybegin(ATTR); return Parser.TAG_ROW;}
<TAG> {TAG_CELL} {yybegin(ATTR); return Parser.TAG_CELL;}

<ATTR> {ATTR_ID} {return Parser.ATTR_ID;}
<ATTR> {ATTR_NORMAL} {return Parser.ATTR_NORMAL;}
<ATTR> {ATTR_REASON} {return Parser.ATTR_REASON;}
<ATTR> {ATTR_FORWARD} {return Parser.ATTR_FORWARD;}
<ATTR> {ATTR_REPLY} {return Parser.ATTR_REPLY;}
<ATTR> {ATTR_NAME} {return Parser.ATTR_NAME;}
<ATTR> {ATTR_EXTVALUE} {return Parser.ATTR_EXTVALUE;}
<ATTR> {TYPE} {return Parser.TYPE;}
<ATTR> {ATTR_PLAIN} {return Parser.ATTR_PLAIN;}
<ATTR> {ATTR_STRUCTURED} {return Parser.ATTR_STRUCTURED;}
<ATTR> {ATTR_TITLE} {return Parser.ATTR_TITLE;}
<ATTR> {ATTR_CAPTION} {return Parser.ATTR_CAPTION;}
<ATTR> {ATTR_PATH} {return Parser.ATTR_PATH;}
<ATTR> {ATTR_TARGET} {return Parser.ATTR_TARGET;}
<ATTR> {ATTR_VALUE} {yyparser.yylval = new ParserVal(yytext());return Parser.ATTR_VALUE;}
<ATTR> {PATH_VALUE} {yyparser.yylval = new ParserVal(yytext());return Parser.PATH_VALUE;}
<ATTR> {EQUAL} {return Parser.EQUAL;}

<ATTR> {TAG_CLOSE} {yybegin(YYINITIAL);	return Parser.TAG_CLOSE;}
<ATTR> {TAG_FINISH_SHORT} {yybegin(YYINITIAL); return Parser.TAG_FINISH_SHORT;}
<DOC> {DOC_CONTENT} {yyparser.yylval = new ParserVal(yytext());return Parser.DOC_CONTENT;}
<DOC> {TAG_CLOSE} {yybegin(YYINITIAL); return Parser.TAG_CLOSE;}
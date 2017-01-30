%{
import java.io.*;
import javax.xml.parsers.*;
import org.xml.sax.*;
%}

%token DOC_START TAG_START TAG_CLOSE TAG_FINISH TAG_FINISH_SHORT EQUAL TAG_MESSAGE TAG_HEADER TAG_DATA TAG_METADATA TAG_FORMAT TAG_EMPTY TAG_SECTION TAG_PARAGRAPH TAG_FIGURE TAG_TABLE TAG_ANCHOR TAG_LINK TAG_ROW TAG_CELL ATTR_ID ATTR_NORMAL ATTR_FORWARD ATTR_REPLY ATTR_NAME ATTR_EXTVALUE TYPE ATTR_PLAIN ATTR_STRUCTURED ATTR_TITLE ATTR_CAPTION ATTR_PATH ATTR_TARGET ATTR_REASON /*dico quali sono i simboli terminali*/
%token<sval> CONTENT DOC_CONTENT ATTR_VALUE	PATH_VALUE	/*dico quali sono i simobli terminali di tipo stringa*/
%type<sval> doc doc_value message message_attr header data contenuto type type_attr metadata metadata_attr format format_attr section section_value section_attr section_content figure figure_attr table table_attr paragraph anchor anchor_attr link link_attr row cell metadatadata data_content

%%

/* defining the productions */

start		: doc message {System.out.println("{\n"+$1+$2+"\n}");}
			;

doc: doc_value doc_value 
				{
					$$="\t\"tag\":\"Xml-Version\",\n\t\"content\": "+$1+",\n\t\"tag\":\"doctype\",\n\t\"content\": "+$2+",";
				}

doc_value : DOC_START DOC_CONTENT TAG_CLOSE 
				{
					$$=$2;
				}
				
message		: TAG_START TAG_MESSAGE message_attr TAG_CLOSE header data TAG_FINISH TAG_MESSAGE TAG_CLOSE
				{
					$$="\n\t\"tag\": \"message\""+$3+",\n\t\"content\": ["+$5+","+$6+"],"; 
				}
				
message_attr: ATTR_ID EQUAL ATTR_VALUE
				{
					$$=",\n\t\"@id\": "+$3+"";
				}
			
header:	TAG_START TAG_HEADER TAG_CLOSE type metadata format TAG_FINISH TAG_HEADER TAG_CLOSE
		{
			$$="\n\t\"tag\": \"header\",\n\t\"content\":["+$4+""+$5+","+$6+"]"; 
		}
		|
		TAG_START TAG_HEADER TAG_CLOSE type metadata TAG_FINISH TAG_HEADER TAG_CLOSE
		{
			$$="\n\t\"tag\": \"header\",\n\tcontent: ["+$4+","+$5+"]"; 
		}
;

type: TAG_START TYPE type_attr TAG_FINISH_SHORT
		{
			$$="\n\t\"tag\": \"type\""+$3+""; 
		}

type_attr: ATTR_ID EQUAL ATTR_VALUE ATTR_REASON EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@id\": "+$3+""; 
		}
		
metadata: metadatadata {$$=$1;} | metadata metadatadata {$$=$1+$2;}

metadatadata: TAG_START TAG_METADATA metadata_attr TAG_FINISH_SHORT
		{
			$$=",\n\t\"tag\": \"metadata\""+$3+""; 
		}

metadata_attr: ATTR_ID EQUAL ATTR_VALUE ATTR_NAME EQUAL ATTR_VALUE ATTR_EXTVALUE EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@id\": "+$3+",\n\t\"@name\": "+$6+",\n\t\"@value\": "+$9+"";
		}
		| ATTR_ID EQUAL ATTR_VALUE ATTR_NAME EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@id\": "+$3+",\n\t\"@name\": "+$6+"";
		}

format: TAG_START TAG_FORMAT TAG_FINISH_SHORT {$$="";} | TAG_START TAG_FORMAT format_attr TAG_FINISH_SHORT
		{
			$$="\n\t\"tag\": \"format\""+$3+""; 
		}

format_attr: TYPE EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@type\": "+$3+"";
		}

data: TAG_START TAG_DATA TAG_CLOSE data_content TAG_FINISH TAG_DATA TAG_CLOSE
		{
			$$="\n\t{\n\t\"tag\": \"data\",\n\t\"content\": "+$4+"\n\t}"; 
		}
		| TAG_START TAG_DATA TAG_CLOSE section TAG_FINISH TAG_DATA TAG_CLOSE
		{
			$$="\n\t{\n\t\"tag\": \"data\",\n\t\"section\": ["+$4+"]}";
		}
		
data_content: contenuto {$$=$1;} |
				section {$$=$1;} |
				data_content contenuto {$$=$1+$2;} |
				data_content section {$$=$1+$2;};

section : section_value { $$=$1+""; }
		| section section_value { $$=$1+","+$2+""; }
;

section_value: TAG_START TAG_SECTION section_attr TAG_CLOSE section_content TAG_FINISH TAG_SECTION TAG_CLOSE
		  {
					$$="\n\t{\n\t\"tag\": \"section\""+$3+",\n\t\"content\" :["+$5+"],}";
		  }
;

section_content : contenuto {$$=$1+""; }
				| figure { $$=$1+""; }
				| table { $$=$1+""; } 
				| section { $$=$1+""; }
				| paragraph { $$=$1+""; }
				| anchor { $$=$1+""; }
				| link { $$=$1+""; }
				| section_content contenuto { $$=$1+""+$2+""; }
				| section_content figure { $$=$1+""+$2+""; }
				| section_content table { $$=$1+""+$2+""; }
				| section_content section { $$=$1+","+$2+""; }
				| section_content paragraph { $$=$1+""+$2+""; }
				| section_content anchor { $$=$1+""+$2+""; }
				| section_content link { $$=$1+""+$2+""; }
;

section_attr: ATTR_ID EQUAL ATTR_VALUE ATTR_TITLE EQUAL ATTR_VALUE
				{
					$$=",\n\t\"@id\": "+$3+",\n\t\"@title\": "+$6+"";
				}

contenuto: { $$=""; } | CONTENT { $$="\t[\n\t\t"+$1+"\n\t],"; }
;

paragraph: TAG_START TAG_PARAGRAPH TAG_CLOSE contenuto TAG_FINISH TAG_PARAGRAPH TAG_CLOSE
		{
			$$="\n\t\"tag\": \"paragraph\"\n"+$4+""; 
		}

figure: TAG_START TAG_FIGURE figure_attr TAG_FINISH_SHORT
		{
			$$="\n\t\"tag\": \"figure\" " +$3+""; 
		}

figure_attr: ATTR_ID EQUAL ATTR_VALUE ATTR_CAPTION EQUAL ATTR_VALUE ATTR_PATH EQUAL PATH_VALUE
		{
			$$=",\n\t\"@id\": "+$3+",\n\t\"@caption\": \""+$6+"\",\n\t@\"path\": "+$9+"\n\t";
		}
		| ATTR_ID EQUAL ATTR_VALUE ATTR_PATH EQUAL PATH_VALUE
		{
			$$=",\n\t\"@id\": "+$3+",\n\t\"@path\": "+$6+"\n\t";
		}

table: TAG_START TAG_TABLE table_attr TAG_CLOSE row TAG_FINISH TAG_TABLE TAG_CLOSE
		{
			$$="{\n\t\"tag\": \"table\""+$3+",\n\t\"row\" :["+$5+"]}";
		}
		
table_attr: ATTR_ID EQUAL ATTR_VALUE ATTR_CAPTION EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@id\": "+$3+",\n\t\"@caption\": "+$6+"";
		}

row: TAG_START TAG_ROW TAG_CLOSE cell TAG_FINISH TAG_ROW TAG_CLOSE
		{
			$$="{\n\t\"tag\": \"row\""+$4+"}";
		}

cell: TAG_START TAG_CELL TAG_CLOSE contenuto TAG_FINISH TAG_CELL TAG_CLOSE
		{ 
			$$="{\n\t\"tag\": \"cell\",\n\t\"content\": ["+$4+"]}";
		}

anchor: TAG_START TAG_ANCHOR anchor_attr TAG_CLOSE contenuto TAG_FINISH TAG_ANCHOR TAG_CLOSE
		{ 
			$$="{\n\t\"tag\": \"anchor\",\n\t\"content\": ["+$5+"]}";
		}

anchor_attr: ATTR_ID EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@id\": \""+$3+"\"";
		}

link: TAG_START TAG_LINK link_attr TAG_CLOSE contenuto TAG_FINISH TAG_LINK TAG_CLOSE
		{ 
			$$="{\n\t\"tag\": \"link\""+$3+",\n\t\"content\" :["+$5+"]}";
		}
link_attr: ATTR_TARGET EQUAL ATTR_VALUE ATTR_TITLE EQUAL ATTR_VALUE
		{
			$$=",\n\t\"@target\": "+$3+",\n\t\"@title\": "+$6+"";
		}
%%

private Yylex lexer;


private int yylex () {

	int yyl_return = -1;
	try {
		yyval = new ParserVal(0);
		yyl_return = lexer.yylex();
	}
	catch (IOException e) {
		System.err.println("IO error :" +e);
	}
	return yyl_return;
}



public void yyerror(String error) {
	System.err.println("Error: " + error);
}

public Parser(Reader r) {
	lexer = new Yylex(r, this);
}

public static void main(String[] args) throws FileNotFoundException{
	if(args.length == 0){
		System.out.println("Inserire il file da processare.");
	} else if(Parser.isXmlValid(args[0])){
		Parser yyparser = new Parser(new FileReader(args[0]));
		yyparser.yyparse();
	}
}

private static boolean isXmlValid(String file){
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	factory.setValidating(true);
	factory.setNamespaceAware(true);

	DocumentBuilder builder;
	try {
		builder = factory.newDocumentBuilder();
	} catch (ParserConfigurationException e1) {
		System.out.println("Errore durante la generazione del DocumentBuilder.");
		return false;
	}
	
	builder.setErrorHandler(new ErrorHandler() {
		@Override
		public void warning(SAXParseException exception) throws SAXException {
			throw exception;
		}
		
		@Override
		public void fatalError(SAXParseException exception) throws SAXException {
			throw exception;
		}
		
		@Override
		public void error(SAXParseException exception) throws SAXException {
			throw exception;
		}
	});
	
	boolean isValid = true;
	
	try {
		builder.parse(new InputSource(file));
	} catch (SAXException e) {
		System.out.println("File xml non valido. " + e.getMessage());
		isValid = false;
	} catch (IOException e) {
		System.out.println("File non trovato: " + e.getMessage());
		isValid = false;
	}
	
	return isValid;
}

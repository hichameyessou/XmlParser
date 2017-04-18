# XmlParser
<br />
XML -> JSON <br /><br />
Compile the BYACC and FLEX files, compile the Java's and run passing through command line the XML's
<br />
Usage: 
yacc -J Parser.y
jflex Lexer.flex
javac *.java
<br />
java -cp . Parser message1.xml > OutputFile.json

# XmlParser
XML -> JSON
Compile the BYACC and FLEX files, compile the Java's and run passing through command line the XML's

Usage: 
yacc -J Parser.y
jflex Lexer.flex
javac *.java

java -cp . Parser message1.xml > OutputFile.json

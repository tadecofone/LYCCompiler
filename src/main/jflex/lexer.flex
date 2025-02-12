package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;import lyc.compiler.table.DataType;import lyc.compiler.table.SymbolEntry;import lyc.compiler.table.SymbolTableManager;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
  StringBuffer sb;
%}


LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]

Init = "init"

Int = "Int"
Float = "Float"
String = "String"

If = "if"
While = "while"
Else = "else"

Write = "write"
Read = "read"

/* Special Functions */
NegativeCalculation = "negativeCalculation"
SumFirstPrimes = "sumFirstPrimes"


Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Assig = ":="
Rest = "%"

Mayor = ">"
Lower = "<"
MayorI = ">="
LowerI = "<="
Equal = "=="
NotEqual = "!="

AndCond = "AND"
OrCond = "OR"
NotCond = "NOT"

OpenBracket = "("
CloseBracket = ")"
OpenCurlyBrace = "{"
CloseCurlyBrace = "}"
OpenSquareBracket = "["
CloseSquareBracket = "]"

Comma = ","
SemiColon = ";"
Dot = "."
DoubleDot = ":"

Letter = [a-zA-Z]
Digit = [0-9]
Digit19 = [1-9]
InvalidCharacter = [^a-zA-z0-9<>:,@/\%\+\*\-\.\[\];\(\)=?!]


TraditionalComment = "#+" [^#]* "+#"
NestedComment = "#+" ([^#] | {TraditionalComment})* "+#"
Comment = {TraditionalComment} | {NestedComment}


WhiteSpace = {LineTerminator} | {Identation}

Identifier = {Letter} ({Letter}|{Digit}|_)*

IntegerConstant = {Digit}+
InvalidIntegerConstant = 0+{Digit19}+
FloatConstant = (({Digit}|{Digit19}{Digit}+)?\.{Digit}+)
StringConstant = \"(([^\"\n]*)\")
%%


   /* Conditionals */
   {AndCond}  {
       System.out.println("Token AND_COND encontrado: " + yytext());
       return symbol(ParserSym.AND_COND);
   }
   {OrCond}  {
       System.out.println("Token OR_COND encontrado: " + yytext());
       return symbol(ParserSym.OR_COND);
   }
   {NotCond} {
       System.out.println("Token NOT_COND encontrado: " + yytext());
       return symbol(ParserSym.NOT_COND);
   }

/* keywords */

<YYINITIAL> {

  /* Declaration */
  {Init}                                    { return symbol(ParserSym.INIT); }

  /* Logical */
  {If}                                     { return symbol(ParserSym.IF); }
  {Else}                                   { return symbol(ParserSym.ELSE); }
  {While}                                  { return symbol(ParserSym.WHILE); }


  /*Special functions*/
  {NegativeCalculation}                              { return symbol(ParserSym.NEGATIVE_CALCULATION); }
  {SumFirstPrimes}                          { return symbol(ParserSym.SUM_FIRST_PRIMES); }


  /* Data types */
  {Int}                                     { return symbol(ParserSym.INT); }
  {Float}                                   { return symbol(ParserSym.FLOAT); }
  {String}                                  { return symbol(ParserSym.STRING); }


  /* I/O */
  {Write}                                  { return symbol(ParserSym.WRITE); }
  {Read}                                   { return symbol(ParserSym.READ); }


  /* Identifiers */
  {Identifier}                             {
                                              if(yytext().length() > 15) {
                                                  throw new InvalidLengthException("Identifier length not allowed: " + yytext());
                                              }
                                              if(!SymbolTableManager.existsInTable(yytext())){
                                                    SymbolEntry entry = new SymbolEntry(yytext());
                                                    SymbolTableManager.insertInTable(entry);
                                              }
                                              return symbol(ParserSym.IDENTIFIER, yytext());
                                          }

  /* Constants */
  {IntegerConstant}                        {
                                                if(yytext().length() > 5 || Integer.valueOf(yytext()) > 65535) {
                                                    throw new InvalidIntegerException("Integer out of range: " + yytext());
                                                }

                                                if(!SymbolTableManager.existsInTable(yytext())){
                                                      SymbolEntry entry = new SymbolEntry("_"+yytext(), DataType.INTEGER_CONS, yytext());
                                                      SymbolTableManager.insertInTable(entry);
                                                }

                                                return symbol(ParserSym.INTEGER_CONSTANT, yytext());
                                            }

  {FloatConstant}                          {
                                                String[] num = yytext().split("\\.");
                                                String exp = num[0];
                                                String mantissa = num[1];

                                                if(exp.length() > 0)
                                                    {
                                                       if(exp.length() > 3 || Integer.parseInt(exp) > 256 )
                                                           throw new InvalidFloatException("Exponent out of range: " + yytext());
                                                    }

                                                if(mantissa.length() > 0) {
                                                  if(mantissa.length() > 8 || Integer.parseInt(mantissa) > 16777216)
                                                      throw new InvalidFloatException("Mantissa out of range: " + yytext());
                                                }

                                                if(!SymbolTableManager.existsInTable(yytext())){
                                                    String val = yytext();
                                                    if(yytext().startsWith("."))
                                                          val = "0" + yytext();
                                                      SymbolEntry entry = new SymbolEntry("_"+val, DataType.FLOAT_CONS, val);
                                                      SymbolTableManager.insertInTable(entry);
                                                }

                                                if(mantissa.length() > 0) {
                                                  if(mantissa.length() > 8 || Integer.parseInt(mantissa) > 16777216)
                                                      throw new InvalidFloatException("Mantissa out of range");
                                                }
                                                return symbol(ParserSym.FLOAT_CONSTANT, yytext());
                                            }

  {StringConstant}                         {
                                                sb = new StringBuffer(yytext());
                                                if(sb.length() > 52) //quotes add 2 to max length
                                                    throw new InvalidLengthException("String out of range: " + yytext());

                                                sb.replace(0,1,"");
                                                sb.replace(sb.length()-1,sb.length(),""); //trim extra quotes

                                                if(!SymbolTableManager.existsInTable(yytext())){
                                                      SymbolEntry entry = new SymbolEntry("_"+sb.toString(), DataType.STRING_CONS, sb.toString(), Integer.toString(sb.length()));
                                                      SymbolTableManager.insertInTable(entry);
                                                }

                                                return symbol(ParserSym.STRING_CONSTANT, yytext());
                                            }


  /*Declaration*/
  {Init}                                    { return symbol(ParserSym.INIT); }


  /* Operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Rest}                                    { return symbol(ParserSym.REST); }
  {Assig}                                   { System.out.println("Token ASSIG encontrado" + yytext()); return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }
  {OpenCurlyBrace}                          { return symbol(ParserSym.OPEN_CURLY_BRACKET); }
  {CloseCurlyBrace}                         { return symbol(ParserSym.CLOSE_CURLY_BRACKET); }
  {OpenSquareBracket}                       { return symbol(ParserSym.OPEN_SQUARE_BRACKET); }
  {CloseSquareBracket}                      { return symbol(ParserSym.CLOSE_SQUARE_BRACKET); }


   /* Comparators */
   {Mayor}                                  { return symbol(ParserSym.MAYOR); }
   {Lower}                                  { return symbol(ParserSym.LOWER); }
   {MayorI}                                 { return symbol(ParserSym.MAYOR_I); }
   {LowerI}                                 { return symbol(ParserSym.LOWER_I); }
   {Equal}                                  { return symbol(ParserSym.EQUAL); }
   {NotEqual}                               { return symbol(ParserSym.NOT_EQUAL); }




   /* Misc */

   {Comma}                                  { return symbol(ParserSym.COMMA); }
   {SemiColon}                              { return symbol(ParserSym.SEMI_COLON); }
   {Dot}                                    { return symbol(ParserSym.DOT); }
   {DoubleDot}                              { return symbol(ParserSym.DOUBLE_DOT); }


   /* Whitespace */
   {WhiteSpace}                             { /* ignore */ }
}

   /* Comments */
   {Comment}                                { /* ignore */ }

   /* Error fallback */
   ^[]                                      { throw new UnknownCharacterException("Unknown character: " + yytext()); }
   {InvalidCharacter}                       { throw new UnknownCharacterException("Unknown character: " + yytext()); }

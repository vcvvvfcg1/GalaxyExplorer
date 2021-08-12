/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

%%

<YYINITIAL>{
"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  return new Symbol(TokenConstants.DARROW); }
/*COOL.MANUAL 10.1 identifiers*/

   {ObjectIdentifier}   {return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext()));}
   {TypeIdentifiers}    {return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext()));}
   {IntLiteral}         {return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext()));}   

/* COOL.MANUAL 10.4 keywords*/

   [cC][lL][aA][sS][sS]                {return new Symbol(TokenConstants.CLASS);}
   [eE][lL][sS][eE]                    {return new Symbol(TokenConstants.ELSE);}
   [fF][iI]                            {return new Symbol(TokenConstants.FI);}
   [iI][fF]                            {return new Symbol(TokenConstants.IF);}
   [iI][nN]                            {return new Symbol(TokenConstatns.IN);}
   [iI][nN][hH][eE][rR][iI][tT][sS]    {return new Symbol(TokenConstants.INHERITS);}
   [iI][sS][vV][oO][iI][dD]            {return new Symbol(TokenConstants.ISVOID);}
   [lL][eE][tT]                        {return new Symbol(TokenConstants.LET);}
   [lL][oO][oO][pP]                    {return new Symbol(TokenConstants.LOOP);}
   [pP][oO][oO][lL]                    {return new Symbol(TokenConstants.POOL);}
   [tT][hH][eE][nN]                    {return new Symbol(TokenConstants.THEN);}
   [wW][hH][iI][lL][eE]                {return new Symbol(TokenConstants.WHILE);}
   [cC][aA][sS][eE]                    {return new Symbol(TokenConstants.CASE);}
   [eE][sS][aA][cC]                    {return new Symbol(TokenConstants.ESAC);}
   [nN][eE][wW]                        {return new Symbol(TokenConstants.NEW);}
   [oO][fF]                            {return new Symbol(TokenConstants.OF);}
   [nN][oO][tT]                        {return new Symbol(TokenConstants.NOT);}

/* frist letter of true and false must be lowercase*/

   t[rR][uU][eE]                       {return new Symbol(TokenConstants.BOOL_CONST, java.lang.Boolean.TRUE); }
   f[aA][lL][sS][eE]                   {return new Symbol(TokenConstants.BOOL_CONST, java.lang.Boolean.FALSE); }

/* Tear, Double Dot, Dot Crying (Punctuation) */

   ","                                 {return new Symbol(TokenConstants.COMMA); }
   ":"                                 {return new Symbol(TokenConstants.COLON); }   
   ";"                                 {return new Symbol(TokenConstants.SEMI); } 

/*PEMDAS and Braces*/

   "("                                 {return new Symbol(TokenConstants.LPAREN); }
   ")"                                 {return new Symbol(TokenConstants.RPAREN); }
   "{"                                 {return new Symbol(TokenConstants.LBRACE); }
   "}"                                 {return new Symbol(TokenConstants.RBRACE); }
   "*"                                 {return new Symbol(TokenConstants.MULT); }
   "/"                                 {return new Symbol(TokenConstants.DIV); }
   "+"                                 {return new Symbol(TokenConstants.PLUS); }
   "-"                                 {return new Symbol(TokenConstants.MINUS); }

/* The other stuff (Relational Operators)*/

   "."                                 {return new Symbol(TokenConstants.DOT);}
   "@"                                 {return new Symbol(TokenConstants.AT);}
   "~"                                 {return new Symbol(TokenConstants.NEG);}
   "<"                                 {return new Symbol(TokenConstants.LT);}
   "="                                 {return new Symbol(TokenConstants.EQ);}
   "<="                                {return new Symbol(TokenConstants.LE);}
   "<-"                                {return new Symbol(TokenConstants.ASSIGN);}
   "=>"                                {return new Symbol(TokenConstants.DARROW);}

/*


}
.                               { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }

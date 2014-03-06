package org.pddl

import scala.util.parsing.combinator.JavaTokenParsers
import scala.io.Source

object Parser extends Parser with App {
  val help = "Usage: scala org.pddl.Parser <pddl-file>"
  if (args.length <= 0) Console.println(help)
  else println(parseFile(args.head).toString)
}

class Parser extends JavaTokenParsers {
  protected override val whiteSpace = """(\s|;.*|//.*|(?m)/\*(\*(?!/)|[^*])*\*/)+""".r
  override def ident: Parser[String] = """[a-zA-Z_](\w|-)*""".r
  
  def pddl: Parser[Expression] = expression
  
  def expression: Parser[Expression] =
    "(" ~> name ~ item.* <~ ")" ^^ { case label ~ items => new Expression(label, items) }
    
  def name: Parser[String] =
    (":" ~> ident ^^ (id => ":" + id)
    | ident
    )
    
  def item: Parser[Any] =
    ( parameters
    | expression
    | _object
    | parameter
    | variable
    | name
    )

  def _object: Parser[Object] =
    ident ~ "-" ~ ident ^^ { case id ~ _ ~ t => new Object(id, t) }
    
  def parameters: Parser[Compound] =
    "(" ~> parameter.+ <~ ")" ^^ (ps => new Compound(ps))
    
  def parameter: Parser[Parameter] =
    variable ~ "-" ~ ident ^^ { case v ~ _ ~ id => new Parameter(v, id) }
  
  def variable: Parser[String] = "?" ~> ident ^^ (id => "?" + id)
    
  def parse(s: String): Expression = {
    parseAll(pddl, s) match {
      case Success(root, _) => root
      case NoSuccess(msg, next) => throw new Exception("at " + next.pos)
    }
  }

  def parseFile(filePath: String) = parse(Source.fromFile(filePath).mkString)
}
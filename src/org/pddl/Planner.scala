package org.pddl

object Planner extends Planner with App {
  val and = "and"
  val or = "or"
  val imply = "imply"
  val always = "always"
  val sometime = "sometime"
  val sometimeBefore = "sometime-before"
  val sometimeAfter = "sometime-after"
  val atmostonce = "at-most-once"
  
  val help = "Usage: scala org.pddl.Planner <domain-file> <problem-file>"
  if (args.length < 2) Console.println(help)
  else println(plan(args.head, args.tail.head, args.tail.tail))
}

class Planner {
  import Planner._
  
  def plan(domainFile: String, problemFile: String, options: Array[String]): Any = {
    val domain = Parser.parseFile(domainFile)
    val problem = Parser.parseFile(problemFile)
    compileTrajectory(domain, problem)
  }
  
  def compileTrajectory(domain: Expression, problem: Expression) = {
    def compileAlways(e: Expression) =
      println(e)
    
    def compileAtMostOnce(e: Expression) = 
      println(e)
      
    def compileExpression(e: Expression) =
      if (e.label.equals(always)) compileAlways(e)
      else if (e.label.equals(atmostonce)) compileAtMostOnce(e)
      else ???
    
    ((e: Expression) =>
      if (e != null)
        e.find(and).params.foreach((item: Any) =>
          if (item.isInstanceOf[Expression]) compileExpression(item.asInstanceOf[Expression])
          else throw new Exception("invalid constraint: " + item)
        )
        //e.find("and").toString
      else throw new Exception("not found :constraint")
    )(problem.find(":constraints"))
    
    ""
  }
}
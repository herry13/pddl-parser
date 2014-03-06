import org.pddl._

object test {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  System.getProperty("user.dir")                  //> res0: String = /Users/admin/Documents/eclipse/Eclipse.app/Contents/MacOS
  
  val parser = new Parser                         //> parser  : org.pddl.Parser = org.pddl.Parser@6ee3572b
  //val pddl = "(define (domain test))"
  //val pddl = "(define)"
  //val pddl = "(define x)"
  //val pddl = "(:action navigate :parameters (?x - rover ?y - waypoint ?z - waypoint))"
  val pddl = "(:objects general - lander colour - mode high_res - mode low_res - mode)"
                                                  //> pddl  : String = (:objects general - lander colour - mode high_res - mode lo
                                                  //| w_res - mode)
  parser.parse(pddl)                              //> res1: org.pddl.Expression = (:objects general - lander colour - mode high_re
                                                  //| s - mode low_res - mode)
    
  val home = "/Users/admin/Documents/scala/pddl-parser"
                                                  //> home  : String = /Users/admin/Documents/scala/pddl-parser
  //val file1 = home + "/test/pddl/domain.pddl"
  //val dom1 = parser.parseFile(file1)
  //dom1.params.last
  val file2 = home + "/test/pddl/p01-11.pddl"     //> file2  : String = /Users/admin/Documents/scala/pddl-parser/test/pddl/p01-11.
                                                  //| pddl
  val dom2 = parser.parseFile(file2)              //> dom2  : org.pddl.Expression = (define (problem roverprob1234) (:domain rover
                                                  //| ) (:objects general - lander colour - mode high_res - mode low_res - mode ro
                                                  //| ver0 - rover rover0store - store waypoint0 - waypoint waypoint1 - waypoint w
                                                  //| aypoint2 - waypoint waypoint3 - waypoint camera0 - camera objective0 - objec
                                                  //| tive objective1 - objective) (:init (visible waypoint1 waypoint0) (visible w
                                                  //| aypoint0 waypoint1) (visible waypoint2 waypoint0) (visible waypoint0 waypoin
                                                  //| t2) (visible waypoint2 waypoint1) (visible waypoint1 waypoint2) (visible way
                                                  //| point3 waypoint0) (visible waypoint0 waypoint3) (visible waypoint3 waypoint1
                                                  //| ) (visible waypoint1 waypoint3) (visible waypoint3 waypoint2) (visible waypo
                                                  //| int2 waypoint3) (at_soil_sample waypoint0) (at_rock_sample waypoint1) (at_so
                                                  //| il_sample waypoint2) (at_rock_sample waypoint2) (at_soil_sample waypoint3) (
                                                  //| at_rock_sample waypoint3) (at_lander general waypoint0) (channel_free genera
                                                  //| l) (at rover0 waypoint3)
                                                  //| Output exceeds cutoff limit.
  dom2.params.last                                //> res2: Any = (:constraints (and (always (at_rock_sample waypoint1)) (at-most-
                                                  //| once (at rover0 waypoint1))))
  
}
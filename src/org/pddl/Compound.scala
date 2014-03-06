package org.pddl

class Compound(val items: List[Any]) {
  override def toString =
    items.foldLeft("(")(
      (s: String, item: Any) => s + item + " "
    ) + ")"
}
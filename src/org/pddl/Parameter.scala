package org.pddl

class Parameter(val name: String, val _type: String) {
  override def toString = name + " - " + _type
}
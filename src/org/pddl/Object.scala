package org.pddl

class Object(val name: String, val _type: String) {
  override def toString = name + " - " + _type
}
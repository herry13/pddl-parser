// PDDL Domain
(define (domain SystemA)
  (:requirements :strips :typing :adl)  
  (:types runnable - object
	cloud vm service - runnable
	loadbalancer appservice - service)
  (:predicates
	(running ?r - runnable)
	(in_cloud ?v - vm ?c - cloud)
	(installed ?s - service))
  (:action create-vm
   :parameters (?c - cloud ?v - vm)
   :precondition (and (not (exists (?cx - cloud)
                      (in_cloud ?v ?cx))))
   :effect (and (in_cloud ?v ?c)))
  (:action start-vm
   :parameters (?v - vm)
   :precondition (and (exists (?c - cloud) (in_cloud ?v ?c))
                      (not (running ?v)))
   :effect (and (running ?v)))
  (:action stop-vm
   :parameters (?v - vm)
   :precondition (and (exists (?c - cloud) (in_cloud ?v ?c))
                      (running ?v))
   :effect (and (not (running ?v))))
  (:action install-service
   :parameters (?s - service)
   :precondition (and (not (installed ?s)) (not (running ?s)))
   :effect (and (installed ?s)))
  (:action uninstall-service
   :parameters (?s - service)
   :precondition (and (installed ?s) (not (running ?s)))
   :effect (and (not (installed ?s))))
  (:action start-service
   :parameters (?s - service)
   :precondition (and (installed ?s) (not (running ?s)))
   :effect (and (running ?s)))
  (:action stop-service
   :parameters (?s - service)
   :precondition (and (installed ?s) (running ?s))
   :effect (and (not (running ?s))))
) 

;; PDDL task for 2 subsystems, each has 2 services
(define (problem p22)
  (:domain SystemA)
  (:objects
    cloud0 - cloud
    vm0 vm0_0_0 vm0_0_1 vm0_1_0 vm0_1_1 - vm
    vm0_lb - service
    vm0_0_0_app vm0_0_1_app vm0_1_0_app vm0_1_1_app - service )
  ;; current state
  (:init (running cloud0) )
  ;; desired state
  (:goal (and
    (in_cloud vm0 cloud0)     (running vm0)
    (installed vm0_lb)        (running vm0_lb)
    (in_cloud vm0_0_0 cloud0) (running vm0_0_0)
    (installed vm0_0_0_app)   (running vm0_0_0_app)
    (in_cloud vm0_0_1 cloud0) (running vm0_0_1)
    (installed vm0_0_1_app)   (running vm0_0_1_app)
    (in_cloud vm0_1_0 cloud0) (running vm0_1_0)
    (installed vm0_1_0_app)   (running vm0_1_0_app)
    (in_cloud vm0_1_1 cloud0) (running vm0_1_1)
    (installed vm0_1_1_app)   (running vm0_1_1_app) ))
  ;; global constraints
  (:constraints (and
    (always (imply (installed vm0_lb) (running vm0)))
    (always (imply (installed vm0_0_0_app) (running vm0_0_0)))
    (always (imply (running vm0_lb) (running vm0_0_0_app)))
    (always (imply (installed vm0_0_1_app) (running vm0_0_1)))
    (always (imply (running vm0_lb) (running vm0_0_1_app)))
    (always (imply (installed vm0_1_0_app) (running vm0_1_0)))
    (always (imply (running vm0_0_0_app) (running vm0_1_0_app)))
    (always (imply (installed vm0_1_1_app) (running vm0_1_1)))
    (always (imply (running vm0_0_1_app) (running vm0_1_1_app)))
  ))
)

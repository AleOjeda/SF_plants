trigger PlantWithProblemsEventTrigger on Plant_with_problem__e(after insert) {
  System.debug('Apex suscriber!');
  System.debug(Trigger.new);
}

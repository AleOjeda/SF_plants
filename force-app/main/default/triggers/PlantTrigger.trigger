trigger PlantTrigger on Plant__c(before insert, before update) {
  // Precargar informacion necesaria de objetos relacionados
  // ...List<Species__c> species = [SELECT Summer_Watering_frequency__c FROM Specie__c WHERE Id IN :specieIds]

  //Calculo sig fecha de riego

  if (Trigger.isInsert || Trigger.isUpdate) {
    Set<Id> specieIds = new Set<Id>();
    for (Plant__c newPlant : Trigger.new) {
      Plant__c oldPlant = (Trigger.isUpdate)
        ? Trigger.oldMap.get(newPlant.id)
        : null;
      if (
        oldPlant == null ||
        (oldPlant.Last_Watered__c != newPlant.Last_Watered__c)
      ) {
        specieIds.add(newPlant.Species__c);
      }
    }
    List<Species__c> species = [
      SELECT Summer_Watering_frequency__c, Winter_Watering_frequency__c
      FROM Species__c
      WHERE Id IN :specieIds
    ];
    Map<Id, Species__c> speciesById = new Map<Id, Species__c>(species);

    for (Plant__c newPlant : Trigger.new) {
      Plant__c oldPlant = (Trigger.isUpdate)
        ? Trigger.oldMap.get(newPlant.id)
        : null;
      if (
        oldPlant == null ||
        (oldPlant.Last_Watered__c != newPlant.Last_Watered__c)
      ) {
        //Calcular sig fecha de riego - Frec de riego según Especie + último riego
        Id specieId = newPlant.Species__c;
        Species__c specie = speciesById.get(specieId);
        Integer daysToAdd = FrequencyService.getWateringDays(specie);
        newPlant.Next_Water__c = newPlant.Last_Watered__c.addDays(daysToAdd);
      }
    }
  }

  //Calculo sig fecha de abonado

}

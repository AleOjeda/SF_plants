public with sharing class PlantTriggerHandler {
  public void beforeInsert(List<Plant__c> newSObjects) {
    // Precargar información necesaria de objetos relacionados
    Set<Id> specieIds = new Set<Id>();
    for (Plant__c newPlant : newSObjects) {
      specieIds.add(newPlant.Species__c);
    }

    // Query precarga objetos relacionados
    Map<Id, Species__c> speciesById = preloadRelatedSpecies(specieIds);

    //Prepulate Next Watering Date
    for (Plant__c newPlant : newSObjects) {
      populateNextWateringDate(newPlant, speciesById);
      populateNextFertilizingDate(newPlant, speciesById);
    }
  }
  public void beforeUpdate(
    List<Plant__c> oldSObjects,
    Map<ID, Plant__c> oldSObjectsMap,
    List<Plant__c> updatedSObjects,
    Map<ID, Plant__c> updatedSObjectsMap
  ) {
    //Cuando se crea o actualiza una planta (cambando su fecha de riego) --> calcular sig fecha de riego.

    //Precargar información necesaria de objetos relacionados
    Set<Id> specieIds = new Set<Id>();
    for (Plant__c newPlant : updatedSObjects) {
      Plant__c oldPlant = oldSObjectsMap.get(newPlant.id);
      if (
        (oldPlant.Last_Watered__c != newPlant.Last_Watered__c) ||
        (oldPlant.Last_Fertilized__c != newPlant.Last_Fertilized__c)
      ) {
        specieIds.add(newPlant.Species__c);
      }
    }

    // Query precarga objetos relacionados
    Map<Id, Species__c> speciesById = preloadRelatedSpecies(specieIds);

    for (Plant__c newPlant : updatedSObjects) {
      Plant__c oldPlant = oldSObjectsMap.get(newPlant.id);
      if (oldPlant.Last_Watered__c != newPlant.Last_Watered__c) {
        //Calcular sig fecha de riego - Frec de riego según Especie + último riego
        populateNextWateringDate(newPlant, speciesById);
      }
      if (oldPlant.Last_Fertilized__c != newPlant.Last_Fertilized__c) {
        //Calcular sig fecha de riego - Frec de riego según Especie + último riego
        populateNextFertilizingDate(newPlant, speciesById);
      }
    }
  }

  private static Map<Id, Species__c> preloadRelatedSpecies(Set<Id> specieIds) {
    List<Species__c> species = [
      SELECT
        Summer_Watering_frequency__c,
        Winter_Watering_frequency__c,
        Summer_Fertilization_Frequency__c,
        Winter_Fertilization_Frequency__c
      FROM Species__c
      WHERE Id IN :specieIds
    ];
    return new Map<Id, Species__c>(species);
  }

  private static void populateNextWateringDate(
    Plant__c newPlant,
    Map<Id, Species__c> speciesById
  ) {
    Id specieId = newPlant.Species__c;
    Species__c specie = speciesById.get(specieId);
    Integer daysToAdd = FrequencyService.getWateringDays(
      specie,
      new DateService()
    );
    newPlant.Next_Water__c = newPlant.Last_Watered__c.addDays(daysToAdd);
  }

  private static void populateNextFertilizingDate(
    Plant__c newPlant,
    Map<Id, Species__c> speciesById
  ) {
    Id specieId = newPlant.Species__c;
    Species__c specie = speciesById.get(specieId);
    Integer daysToAdd = FrequencyService.getFertilizationDays(
      specie,
      new DateService()
    );
    newPlant.Next_Fertilization__c = newPlant.Last_Fertilized__c.addDays(
      daysToAdd
    );
  }
}

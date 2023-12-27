@isTest
private with sharing class FrequencyServiceTest {
  @isTest
  // metodoTesteado_casoDeUso_ResultadoEsperado
  static void getWateringDays_wateringFreqDailyAndSummer_oneDay() {
    // GIVEN -- Creación de datos, escenario, etc...
    Species__c specie = new Species__c();
    specie.winter_Watering_Frequency__c = 'Daily';

    // WHEN -- Llamamos al método
    Integer days = FrequencyService.getWateringDays(specie);

    // THEN -- Chequear el resultado esperado
    Integer expectedDays = 1;
    System.assertEquals(expectedDays, days, '1 day returned');
  }

  //TODO agregar el resto de las pruebas unitarias. Weekly - Summer / Winter , twice per week etc etc
}

@isTest
private with sharing class FrequencyServiceTest {
  @isTest
  // metodoTesteado_casoDeUso_ResultadoEsperado
  static void getWateringDays_wateringFreqDailyAndSummer_oneDay() {
    // GIVEN -- Creación de datos, escenario, etc...
    //Mock
    DateServiceMock mock = new DateServiceMock();
    mock.monthToReturn = 1;

    DateService mockDateService = (DateService) Test.createStub(
      DateService.class,
      mock
    );

    Species__c specie = new Species__c();
    // specie.Winter_Watering_Frequency__c = 'Daily';
    specie.Summer_Watering_Frequency__c = 'Daily';

    // WHEN -- Llamamos al método
    Test.startTest();
    Integer days = FrequencyService.getWateringDays(specie, mockDateService);
    Test.stopTest();

    // THEN -- Chequear el resultado esperado
    Integer expectedDays = 1;
    System.assertEquals(expectedDays, days, '1 day returned');
  }

  public class DateServiceMock implements System.StubProvider {
    public Integer monthToReturn;

    public Object handleMethodCall(
      Object stubbedObject,
      String stubbedMethodName,
      Type returnType,
      List<Type> listOfParamTypes,
      List<String> listOfParamNames,
      List<Object> listOfArgs
    ) {
      // The following debug statements show an example of logging
      // the invocation of a mocked method.

      // You can use the method name and return type to determine which method was called.
      System.debug('Name of stubbed method: ' + stubbedMethodName);
      System.debug('Return type of stubbed method: ' + returnType.getName());

      // You can also use the parameter names and types to determine which method
      // was called.
      for (integer i = 0; i < listOfParamNames.size(); i++) {
        System.debug('parameter name: ' + listOfParamNames.get(i));
        System.debug('  parameter type: ' + listOfParamTypes.get(i).getName());
      }

      // This shows the actual parameter values passed into the stubbed method at runtime.
      System.debug(
        'number of parameters passed into the mocked call: ' + listOfArgs.size()
      );
      System.debug('parameter(s) sent into the mocked call: ' + listOfArgs);

      // This is a very simple mock provider that returns a hard-coded value
      // based on the return type of the invoked.
      // if (returnType.getName() == 'String')
      //   return '8/8/2016';
      // else
      //   return null;
      return monthToReturn;
    }
  }
  //TODO agregar el resto de las pruebas unitarias. Weekly - Summer / Winter , twice per week etc etc
}

public with sharing class CheckForecastJob implements Schedulable {
  public void execute(SchedulableContext SC) {
    postNotifications();
  }

  public static void postNotifications() {
    //public para usarlo desde afuera, consola ejemplo
    //Realizar tareas planificadas
    //1.Verificar temperaturas de hoy
    ForecastService.Forecast fc = ForecastService.getTodaysTemperatures();
    Integer maxTempToday = fc.temperaturas.max;
    Integer minTempToday = fc.temperaturas.min;
    //2.Existencia de alguna planta donde la temperatura no es la adecuada
    List<Plant__c> plantsWithProblems = [
      SELECT
        Name,
        Species__r.Name,
        Species__r.Max_Temperature__c,
        Species__r.Min_Temperature__c
      FROM Plant__c
      WHERE
        Species__c IN (
          SELECT Id
          FROM Species__c
          WHERE
            Max_Temperature__c < :maxTempToday
            OR Min_Temperature__c > :minTempToday
        )
    ];
    // 3.Si existe 2, enviar notificación

    // Get the Id for our custom notification type
    CustomNotificationType notificationType = [
      SELECT Id, DeveloperName
      FROM CustomNotificationType
      WHERE DeveloperName = 'Temperature_Alert'
    ];
    for (Plant__c plantWithProblems : plantsWithProblems) {
      // Create a new custom notification
      Messaging.CustomNotification notification = new Messaging.CustomNotification();

      //Seteo caso para notificar - calor o frio-
      setNotificationMessage(
        notification,
        maxTempToday,
        minTempToday,
        plantWithProblems
      );
      // Set the notification type and target
      notification.setNotificationTypeId(notificationType.Id);
      notification.setTargetId(plantWithProblems.Id);

      // Actually send the notification
      try {
        notification.send(new Set<String>{ UserInfo.getUserId() });
      } catch (Exception e) {
        System.debug('Problem sending notification: ' + e.getMessage());
      }
    }
  }

  private static void setNotificationMessage(
    Messaging.CustomNotification notification,
    Integer maxTempToday,
    Integer minTempToday,
    Plant__c plant
  ) {
    // Set the contents for the notification
    if (plant.Species__r.Max_Temperature__c < maxTempToday) {
      notification.setTitle('Alerta de calor');
      notification.setBody(
        'Hoy el termómetro alcanzará ' +
          maxTempToday +
          ' grados. \n' +
          'La temperatura máxima que ' +
          plant.Name +
          ' (' +
          plant.Species__r.Name +
          ' ) soporte es ' +
          plant.Species__r.Max_Temperature__c +
          ' grados.'
      );
    } else if (plant.Species__r.Min_Temperature__c < minTempToday) {
      notification.setTitle('Alerta de frío');
      notification.setBody(
        'Hoy el termómetro bajará de los ' +
          minTempToday +
          ' grados. \n' +
          'La temperatura mínima que ' +
          plant.Name +
          ' (' +
          plant.Species__r.Name +
          ' ) soporte es ' +
          plant.Species__r.Min_Temperature__c +
          ' grados.'
      );
    }
  }
}

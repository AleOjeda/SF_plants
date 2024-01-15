public with sharing class ForecastService {
  public static void postNotifications() {
    //public para usarlo desde afuera, consola ejemplo
    //Realizar tareas planificadas
    //1.Verificar temperaturas de hoy
    Forecast fc = getTodaysTemperatures();
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

  public static Forecast getTodaysTemperatures() {
    //   public static String getTodaysTemperatures() {
    ///https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_classes_restful_http_httprequest.htm
    HttpRequest req = new HttpRequest();
    //Estudiar API para setear cuidad deseada, es una api de España solamente
    req.setEndpoint(
      'https://www.el-tiempo.net/api/json/v2/provincias/18/municipios/18087'
    );
    req.setMethod('GET');
    //  // Specify the required user name and password to access the endpoint
    //  // As well as the header and header information

    //  String username = 'myname';
    //  String password = 'mypwd';

    //  Blob headerValue = Blob.valueOf(username + ':' + password);
    //  String authorizationHeader = 'Basic ' +
    //  EncodingUtil.base64Encode(headerValue);
    //  req.setHeader('Authorization', authorizationHeader);

    // Create a new http object to send the request object
    // A response object is generated as a result of the request

    Http http = new Http();
    HTTPResponse res = http.send(req);
    String body = res.getBody();
    Forecast todayForecast = (Forecast) JSON.deserialize(body, Forecast.class);
    // System.debug('hola');
    // return res.getBody();
    return todayForecast;
  }

  public class Forecast {
    public Temperatures temperaturas;
    // public String origin;
  }

  public class Temperatures {
    public Integer max;
    public Integer min;
  }
}

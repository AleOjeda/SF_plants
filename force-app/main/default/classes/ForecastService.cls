public with sharing class ForecastService {
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
    public String max;
    public String min;
  }
}

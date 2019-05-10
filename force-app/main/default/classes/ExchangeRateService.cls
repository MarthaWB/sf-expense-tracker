public with sharing class ExchangeRateService 
// implements HttpCalloutMock 
{
    public static final String BASE_RATE = 'USD';
    private List<String> fromCurrencies = new List<String>();
    private Date conversionDate;
    public ExchangeRateService(Date conversionDate, List<String> fromCurrencies) {
      this.fromCurrencies = fromCurrencies;
      this.conversionDate = conversionDate;

      if(this.conversionDate == null || this.fromCurrencies == null) {
           throw new ExchangeRateServiceException('Missing arguments');
      } 
    }

      private class ExchangeRateServiceException extends Exception {}
      private class SplashThatApiException extends Exception {}
      public string getFXRates(){
          String conversionDateString = String.valueOf(conversionDate);
          String fromCurrenciesString = String.join(this.fromCurrencies, ',');

          String endpoint = 'https://data.fixer.io/api/' + 
          conversionDateString + '?' + 
          'access_key='+ 'ebfa68700c1d71df623c3440b373fb65' + '&' + 
          'base=' + 'GBP' + '&' + 
          'symbols=' + fromCurrenciesString;
          HttpRequest req = new HttpRequest();
          // req.setTimeout(1200000); // optional
          req.setEndpoint(''); // must have
          req.setMethod('GET'); // must have
          Http http = new Http();
          HttpResponse res = http.send(req);
          Integer statusCode = res.getStatusCode();
          String responseBody = res.getBody();
          
          if (statusCode != 200){
              throw new SplashThatApiException(responseBody);
          }
          return responseBody;
      }
}


// {"success":true,"timestamp":1555269846,"historical":true,"base":"EUR","date":"2019-04-14","rates":{"GBP":0.86366,"CAD":1.507216}}
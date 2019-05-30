public with sharing class ExchangeRateService {
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

          String endpoint = 'https://api.exchangeratesapi.io/' + 
          conversionDateString + '?' +  
          'base=' + 'USD' + '&' + 
          'symbols=' + fromCurrenciesString;

          // start_at=2018-01-01&end_at=2018-09-01

          HttpRequest req = new HttpRequest();
          // req.setTimeout(1200000); // optional
          req.setEndpoint(endpoint); // must have
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

      public ExchangeRateResponse deserializeJson(){
        String resp = getFXRates();
        ExchangeRateResponse fxRate = (ExchangeRateResponse)JSON.deserialize(resp, ExchangeRateResponse.class);
        return fxRate;
      }

        public class ExchangeRateResponse {
            public Boolean success {get; set;}
            public Boolean historical {get; set;}
            public Date rateDate {get; set;}
            public String base {get; set;}
            Map<String, Decimal> rates {get; set;}
            
            List<Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();
            
            public List<Exchange_Rate__c> getExchangeRates(){
                for(String key:rates.keySet()){
                    
                    Decimal rate =  rates.get(key);
                    Exchange_Rate__c exchangeRateItem = new Exchange_Rate__c(
                        Currency__c = key,
                        Rate__c = rate,
                        Rate_date__c = rateDate
                    );
                    exchangeRates.add(exchangeRateItem);
                }
                return exchangeRates;
            }
        }
}


// {"success":true,"timestamp":1555269846,"historical":true,"base":"EUR","date":"2019-04-14","rates":{"GBP":0.86366,"CAD":1.507216}}
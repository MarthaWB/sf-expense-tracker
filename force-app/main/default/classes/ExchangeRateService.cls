public with sharing class ExchangeRateService implements HttpCalloutMock {
    
    
    // ** fixer.io API **
    //public static final String API_KEY = '6f05d14852aa1a759d633ef9553e5d6f';
    public static final String BASE_Rate = 'USD';    
    private List<String> fromCurrencies = new List<String>();
    private Date conversionDate;
  
    public ExchangeRateService(Date conversionDate, List<String> fromCurrencies) {
        this.conversionDate = conversionDate;
        this.fromCurrencies = fromCurrencies;
        if (this.conversionDate == null 
                    || this.fromCurrencies == null
                    || this.fromCurrencies.isEmpty()) {
            throw new ExchangeRateServiceException('Missing required arguments!');
        }
    }
    public List<Exchange_Rate__c> getFXRates() {
        String conversionDateString = String.valueOf(conversionDate);
        String fromCurrenciesString = String.join(this.fromCurrencies,',');
        /** fixer.io API **
        String endpoint = 'http://data.fixer.io/api/' +
                conversionDateString + '?' +
                'access_key=' + API_KEY + '&' +
                'base=' + BASE_Rate +
                '&symbols=' + fromCurrenciesString;
        */
        //** exchangeratesapi.io API **
        String endpoint = 'https://api.exchangeratesapi.io/' +
                conversionDateString + '?' +
                'base=' + BASE_Rate +
                '&symbols=' + fromCurrenciesString;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        String responseBody = res.getBody();
        
        ExchangeRateResponse exchangeRateResponse = (ExchangeRateResponse)JSON.deserialize(responseBody, ExchangeRateResponse.class);
        return exchangeRateResponse.getExchangeRates();
    }

    public HttpResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        // exchangeratesapi.io    
        res.setBody('{"base":"EUR","date":"2019-05-16","rates":{"USD":1.117335}');
        res.setStatusCode(200);
        return res;        
    }
    
    private class ExchangeRateServiceException extends Exception {}
    
    public class ExchangeRateResponse {
        public String base {get; set;}
        public Map<String, Decimal> rates {get; set;}
        public List<Exchange_Rate__c> getExchangeRates() {
            List<Exchange_Rate__c> exchangeRateList = new List<Exchange_Rate__c>();
            for (String key : this.rates.keySet()) {
                Exchange_Rate__c exchangeRate = new Exchange_Rate__c();
                exchangeRate.Currency__c =  key;
                exchangeRate.Rate__c = this.rates.get(key);
                exchangeRateList.add(exchangeRate);
            }
            return exchangeRateList;
        }       
    }
}

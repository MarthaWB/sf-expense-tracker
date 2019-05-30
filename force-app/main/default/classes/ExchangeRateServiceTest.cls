@isTest
public class ExchangeRateServiceTest {
    @isTest
    static void CalloutStaticClassTest() {
        // Use StaticResourceCalloutMock built-in class to
        // specify fake response and include response body 
        // in a static resource.
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('StaticResourceForExchangeRateServiceCallout');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, mock);
            
        Date conversionDate = '2019-05-28';
        List<String> fromCurrencies = new List<String>{'GBP', 'EUR'};
        ExchangeRateService fxService = new ExchangeRateService(conversionDate, fromCurrencies);
        String response = fxService.getFXRates();
        System.assertEquals('{"base":"USD","rates":{"GBP":0.789608649,"EUR":0.8934953538},"date":"2019-05-28"}', response);
        //System.assertEquals('ExchangeRateResponse:[base=USD, rates={EUR=0.8951750067, GBP=0.7902604959}]', responseDs);
    }
}

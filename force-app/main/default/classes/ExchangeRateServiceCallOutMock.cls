@isTest
global class ExchangeRateServiceCallOutMock implements HttpCalloutMock {

public HttpResponse respond(HttpRequest request){
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"base":"USD","date":"2019-05-15","rates":{"GBP":0.80300,"EUR":0.8834943830}}');
        res.setStatusCode(200);
        return res;
    }

}






@isTest
global class ExchangeRateServiceCallOutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api.exchangeratesapi.io/', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"base":"USD","date":"2019-06-01","rates":{"GBP":0.80300,"EUR":0.8834943830}}');
        res.setStatusCode(200);
        return res;
    }
}
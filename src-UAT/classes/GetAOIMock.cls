@isTest
public class GetAOIMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id": 2231}');
         res.setStatusCode(200);
        return res;
    }
}
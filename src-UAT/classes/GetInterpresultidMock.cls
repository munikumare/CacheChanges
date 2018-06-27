@isTest
public class GetInterpresultidMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"interpresultid": "1542"}');
         res.setStatusCode(200);
        return res;
    }
}
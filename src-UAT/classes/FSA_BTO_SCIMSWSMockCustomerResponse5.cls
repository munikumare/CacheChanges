@isTest
public class FSA_BTO_SCIMSWSMockCustomerResponse5 implements HttpCalloutMock {
    // response body contains invalid xml
    public HttpResponse respond(HttpRequest req) {
        //System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        res.setBody('<![CDATA[]]>');
        res.setStatusCode(400);
        return res;
    }
}
@isTest
public class FSA_BTO_CBSMockResponseError implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
       res.setBody('<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"> <env:Header/> <env:Body> <ns1:findFSAOfficesByStateFipsResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://service.cbs.citso.fsa.usda.gov"> <errorMessages><code>404</code><message>Page Not Found!</message></errorMessages> </ns1:findFSAOfficesByStateFipsResponse> </env:Body> </env:Envelope>');
          res.setStatusCode(200);
        return res;
    }
}
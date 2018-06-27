@isTest
public class FSA_BTO_SCIMSWSMockCustomerResponse4 implements HttpCalloutMock {
    // no response body returned, mock calloutexceptionn thrown
    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        throw e;
    }
}
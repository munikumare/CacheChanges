@isTest
public class FSA_BTO_SCIMSWSMockCustomerResponse6 implements HttpCalloutMock {
    // no response body returned, mock nullpointerexception thrown
    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());
        NullPointerException e = (NullPointerException)NullPointerException.class.newInstance();
        throw e;
    }
}
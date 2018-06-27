@isTest
public class FSA_BTO_SCIMSWSMockCustomerResponse3 implements HttpCalloutMock {
    // response body contains no last name
    public HttpResponse respond(HttpRequest req) {
        //System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        res.setBody('<env:Envelope xmlns:env=\'http://schemas.xmlsoap.org/soap/envelope/\' xmlns:soap11-enc=\'http://schemas.xmlsoap.org/soap/encoding/\'><env:Header></env:Header><env:Body><mes:GetCustomerResponse xmlns:mes=\'http://tempuri.org/message/\' env:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'><Result>&lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;SCIMSCustomerList&gt;&lt;NumberOfCustomersReturned&gt;1&lt;/NumberOfCustomersReturned&gt;&lt;SCIMSCustomer&gt;&lt;CustomerData&gt;&lt;CustomerID&gt;123456&lt;/CustomerID&gt;&lt;IndividualName&gt;&lt;First&gt;TESTFIRST_ABCDEFGHIJKLMNOPQRSTUVWXYZ01234&lt;/First&gt;&lt;Middle&gt;TESTMIDDLE_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123&lt;/Middle&gt;&lt;Prefix&gt;MS&lt;/Prefix&gt;&lt;Suffix&gt;TESTSUFFIX_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123&lt;/Suffix&gt;&lt;/IndividualName&gt;&lt;/CustomerData&gt;&lt;/SCIMSCustomer&gt;&lt;/SCIMSCustomerList&gt;</Result></mes:GetCustomerResponse></env:Body></env:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}
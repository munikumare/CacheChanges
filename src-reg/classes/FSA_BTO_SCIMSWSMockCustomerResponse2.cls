@isTest
public class FSA_BTO_SCIMSWSMockCustomerResponse2 implements HttpCalloutMock {
    // response body contains invalid email address to cover DmlException
    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        res.setBody('<env:Envelope xmlns:env=\'http://schemas.xmlsoap.org/soap/envelope/\' xmlns:soap11-enc=\'http://schemas.xmlsoap.org/soap/encoding/\'><env:Header></env:Header><env:Body><mes:GetCustomerResponse xmlns:mes=\'http://tempuri.org/message/\' env:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'><Result>&lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;SCIMSCustomerList&gt;&lt;NumberOfCustomersReturned&gt;1&lt;/NumberOfCustomersReturned&gt;&lt;SCIMSCustomer&gt;&lt;CustomerData&gt;&lt;CustomerID&gt;123456&lt;/CustomerID&gt;&lt;IndividualName&gt;&lt;Last&gt;TESTLAST_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789012345678901234567890123456789012345&lt;/Last&gt;&lt;First&gt;TESTFIRST_ABCDEFGHIJKLMNOPQRSTUVWXYZ012345&lt;/First&gt;&lt;Middle&gt;TESTMIDDLE_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123&lt;/Middle&gt;&lt;Prefix&gt;MR&lt;/Prefix&gt;&lt;Suffix&gt;TESTSUFFIX_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123&lt;/Suffix&gt;&lt;/IndividualName&gt;&lt;/CustomerData&gt;&lt;Phone&gt;&lt;PhonePrimary&gt;Y&lt;/PhonePrimary&gt;&lt;PhoneNumber&gt;222-222-2222&lt;/PhoneNumber&gt;&lt;PhoneExtension /&gt;&lt;PhoneUnlisted&gt;N&lt;/PhoneUnlisted&gt;&lt;Country&gt;&lt;Code&gt;US&lt;/Code&gt;&lt;/Country&gt;&lt;State&gt;&lt;Code /&gt;&lt;/State&gt;&lt;County&gt;&lt;Code /&gt;&lt;/County&gt;&lt;/Phone&gt;&lt;Email&gt;&lt;EmailAddress&gt;fake_3@emailcom&lt;/EmailAddress&gt;&lt;EmailType&gt;&lt;Code&gt;HM&lt;/Code&gt;&lt;Description&gt;Home&lt;/Description&gt;&lt;/EmailType&gt;&lt;EmailPrimary&gt;Y&lt;/EmailPrimary&gt;&lt;/Email&gt;&lt;/SCIMSCustomer&gt;&lt;/SCIMSCustomerList&gt;</Result></mes:GetCustomerResponse></env:Body></env:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}
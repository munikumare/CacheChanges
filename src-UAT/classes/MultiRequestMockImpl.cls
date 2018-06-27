@isTest
public class MultiRequestMockImpl implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public MultiRequestMockImpl(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
        String requestEndpoint = req.getEndpoint();
        HttpCalloutMock mock;

        for (String endpoint : requests.keySet()) {
            if (requestEndpoint.contains(endpoint)) {
                mock = requests.get(endpoint);
                break;
            }
        }

        if (mock != null) {
            return mock.respond(req);
        } else {
           throw new System.TypeException('HTTP callout not supported for test methods.');
        }
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}
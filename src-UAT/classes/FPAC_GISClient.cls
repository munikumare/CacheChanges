public with sharing class FPAC_GISClient {

    // Unique label corresponding to the continuation
    public static String requestLabel {get; set;}

    // Result of callout
    public static String cluResult {get; set;}
    public static String boundaryResult {get; set;}
    public static String wetlandsResult {get; set;}

    public static Object getCLUData(string farmNumber, string tractNumber) {

        String endpoint = 'callout:Mulesoft/gis/clu/getFeatures?farmNumber=' + farmNumber;
        if (!String.isEmpty(tractNumber)) {
            endpoint += '&tractNumber=' + tractNumber;
        }
        system.debug('getCLUData ' + endpoint);
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        // Add callout request to continuation
        con.state = con.addHttpRequest(req);

        return con;

    }

    public static Object getBoundaryInformation(string farmNumber, string tractNumber) {

        String endpoint = 'callout:Mulesoft/gis/geometry/union?farmNumber=' + farmNumber;
        if (!String.isEmpty(tractNumber)) {
            endpoint += '&tractNumber=' + tractNumber;
        }
        system.debug('getBoundaryInformationJSON ' + endpoint);
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        // Add callout request to continuation
        con.state = con.addHttpRequest(req);

        return con;

    }

    public static Object getWetlandsInformation(string farmNumber) {

        String endpoint = 'callout:Mulesoft/gis/wetlands?farmNumber=' + farmNumber;
        system.debug('getWetlandsInformationJSON ' + endpoint);
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        // Add callout request to continuation
        con.state = con.addHttpRequest(req);

        return con;

    }

    public static Object processResponse(Object state) {
        HttpResponse response = Continuation.getResponse((String)state);
        return response.getBody();
    }

    /*// Callback method 
    public String cluProcessResponse() {
            system.debug('cluProcessResponse');
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(requestLabel);
        // Set the result variable that is displayed on the Visualforce page
        cluResult = response.getBody();

        // Return null to re-render the original Visualforce page
        return null;
    }

    // Callback method 
    public String boundaryProcessResponse() {
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(requestLabel);
        // Set the result variable that is displayed on the Visualforce page
        boundaryResult = response.getBody();

        // Return null to re-render the original Visualforce page
        return null;
    }

    // Callback method 
    public String wetlandsProcessResponse() {
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(requestLabel);
        // Set the result variable that is displayed on the Visualforce page
        wetlandsResult = response.getBody();

        // Return null to re-render the original Visualforce page
        return null;
    }*/
}
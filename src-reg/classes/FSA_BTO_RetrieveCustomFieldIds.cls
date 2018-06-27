// callout to Tooling API requires all org urls saved in Remote Site Settings
global class FSA_BTO_RetrieveCustomFieldIds {
    webservice static String getCustomFieldId(String customFieldName, String objectName) {
        String customFieldId;
        String customFieldApiName = customFieldName.removeEndIgnoreCase('__c'); 
        String orgUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String endpoint = orgUrl + '/services/data/v34.0/tooling/query/?q=SELECT+Id,+DeveloperName+FROM+CustomField+WHERE+DeveloperName=\'' + customFieldApiName + '\'+AND+TableEnumOrId=\''+objectName+'\'';

        HttpResponse res = makeRequest(endpoint);
        
        if(res.getStatusCode() == 200) {
            FSA_BTO_RetrieveFieldParser retrieveFieldParser = (FSA_BTO_RetrieveFieldParser) System.JSON.deserialize(res.getBody(), FSA_BTO_RetrieveFieldParser.class);
            System.debug(retrieveFieldParser);
            for(FSA_BTO_RetrieveFieldParser.RetrieveFieldAttributes retrieveFieldAttributes : retrieveFieldParser.records) {
                customFieldId = String.valueOf(retrieveFieldAttributes.Id).substring(0,15);
            }
            return customFieldId;
        } else {
            return null;
        }
    }
    
    public static HttpResponse makeRequest(String endpoint) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type','application/json');
        req.setEndpoint(endpoint);
        req.setMethod('GET');  
        HttpResponse res = http.send(req);   
        
        return res;
    }
}
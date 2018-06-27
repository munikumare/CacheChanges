public class FSA_BTO_SCIMSWSCalloutController  {
    public FSA_BTO_SCIMSCustomer scimsCustomer { get; set; }
        
    public FSA_BTO_SCIMSCustomer getCustomer(String coreCustomerId) {
        Map<String,String> arguments = new Map<String,String>();

        if(!Test.isRunningTest()) {
            //Id recordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Bridges Customer Individual').RecordTypeId;  
            String orgUrl = System.URL.getSalesforceBaseUrl().getHost();
            String endpoint;
            String orgName;
            
            if(orgUrl.containsIgnoreCase('fsa--dev') || orgUrl.containsIgnoreCase('dev-fsa')) {
                endpoint = 'https://doe2.fsa.usda.gov/SCIMS/services/ScimsWebService';
                orgName = 'FSA BTO DEV SANDBOX';
            } else if(orgUrl.containsIgnoreCase('fsa--test') || orgUrl.containsIgnoreCase('test-fsa')) {
                endpoint = 'https://doe2.fsa.usda.gov/SCIMS/services/ScimsWebService';
                orgName = 'FSA BTO TEST SANDBOX';
            } else if(orgUrl.containsIgnoreCase('fsa--fsatest2') || orgUrl.containsIgnoreCase('fsatest2-fsa')) {
                endpoint = 'https://doe2.fsa.usda.gov/SCIMS/services/ScimsWebService';
                orgName = 'FSA BTO TEST2 SANDBOX';
            } else if(orgUrl.containsIgnoreCase('fsa--fsapreprod') || orgUrl.containsIgnoreCase('fsapreprod-fsa')) {
                endpoint = 'https://storm2.fsa.usda.gov/SCIMS/services/ScimsWebService';
                 // endpoint = 'https://cert1-services.fsa.usda.gov/SCIMS/services/ScimsWebService';
                orgName = 'FSA BTO PREPROD SANDBOX';
            } else if(orgUrl.containsIgnoreCase('fsa--c') || orgUrl.containsIgnoreCase('fsa.my') || orgUrl.containsIgnoreCase('fsa-usda')) {
              //  endpoint = 'https://artemis2.fsa.usda.gov/SCIMS/services/ScimsWebService';
                  endpoint = 'https://services.fsa.usda.gov/SCIMS/services/ScimsWebService';
                 orgName = 'FSA BTO PRODUCTION';
            }
            
            Id userId = UserInfo.getUserId();
            List<User> u = [SELECT FederationIdentifier, Username FROM User WHERE Id =: userId];
            String uniqueIdentifier;
            if(!String.isEmpty(u[0].FederationIdentifier)) {
                uniqueIdentifier = u[0].FederationIdentifier;
            } else {
                uniqueIdentifier = u[0].Username;
            }
            
            arguments.put('sQueryString', '&lt;SCIMSQuery&gt;&lt;SearchParameter CustomerStatus=\'both\' ParameterType=\'core_customer_identifier\'&gt;' + coreCustomerId + '&lt;/SearchParameter&gt;&lt;DataOptions CustomerAttributes=\'yes\' Address=\'all\' Phone=\'all\' Email=\'all\' Disability=\'all\' &gt;&lt;/DataOptions&gt;&lt;RequestInfo ApplicationID=\'Salesforce FSA Bridges to Opportunity\' UserID=\'' + uniqueIdentifier + '\' ProcessingNode=\'' + orgName + '\' RequestHost=\'' + orgUrl + '\' /&gt;&lt;/SCIMSQuery&gt;');
            /*
            if(contact.RecordTypeId == recordTypeId) {
                makeRequest(arguments, endpoint); 
            }
            */
            
            makeRequest(arguments, endpoint); 
        } else {
            arguments.put('sQueryString', '&lt;SCIMSQuery&gt;&lt;SearchParameter ParameterType=\'core_customer_identifier\'&gt;123456&lt;/SearchParameter&gt;&lt;DataOptions CustomerStatus=\'both\' CustomerAttributes=\'yes\' Address=\'all\' &gt;&lt;/DataOptions&gt;&lt;/SCIMSQuery&gt;');
            makeRequest(arguments, 'https://fake.fsa.usda.gov/SCIMS/services/ScimsWebService'); 
        }
        return scimsCustomer;
    }
    
    public void makeRequest(Map<String,String> argumentMap, String endpoint) {
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type','text/xml');
        //request.setClientCertificateName('bridges_to_opportunity');
        request.setClientCertificateName('bto_prod');
        FSA_BTO_SCIMSWSSoapPacketBuilder packetBuilder = new FSA_BTO_SCIMSWSSoapPacketBuilder();
        packetBuilder.argumentMap = argumentMap;
        String xmlReq = packetBuilder.toXmlString();
        //System.debug('Request: ' + xmlReq);
        request.setBody(xmlReq);
        Http http = new Http();
        HttpResponse response = http.send(request);
        parseSoapResponse(response.getBody());
        System.debug('Response: ' + response);
        //System.debug('Response: ' + response);   
        //System.debug('Response Body: ' + response.getBody());
    }

    public void parseSoapResponse(String soapResponse) {
        String envNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String msgNS = 'http://tempuri.org/message/';
        DOM.Document doc = new DOM.Document();
        doc.load(soapResponse);
        DOM.XMLNode envRoot = doc.getRootElement(); 
        DOM.XMLNode envBody = envRoot.getChildElement('Body', envNS);
        DOM.XMLNode envMsg = envBody.getChildElement('GetCustomerResponse', msgNS);
        DOM.XMLNode envResult = envMsg.getChildElement('Result', null);
        String xmlString = envResult.getText();
        System.debug('xmlString: ' + xmlString);
        scimsCustomer = new FSA_BTO_SCIMSCustomer(xmlString);
    }
}
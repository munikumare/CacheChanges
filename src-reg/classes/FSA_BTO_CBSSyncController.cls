global with sharing class FSA_BTO_CBSSyncController {

    public static FSA_BTO_CBSCounty cbsCounty { get; set; }
    //FSA_BTO_URLs__c endpoint = FSA_BTO_URLs__c.getInstance('FSA_BTO_CBS_Endpoint');
    //FSA_BTO_URLs__c certName = FSA_BTO_URLs__c.getInstance('FSA_BTO_Cert_Name');
    
    @future(callout=true)
    public static void getCounty(String fipsCode) {
        Map<String,String> arguments = new Map<String,String>();

            arguments.put('name','beanProperties');
            arguments.put('agencyOfficeType','beanProperties');
            arguments.put('agencyAbbr','beanProperties');
            arguments.put('locStreetAddr','beanProperties');
            arguments.put('locStateAbbrev','beanProperties');
            arguments.put('locCityName','beanProperties');
            arguments.put('officePhoneNbr','beanProperties');           
            arguments.put('mailingAddrLine','beanProperties');
            arguments.put('mailingCity','beanProperties');
            arguments.put('mailingStateAbbrev','beanProperties');
            arguments.put('mailingZipCode','beanProperties');
            arguments.put('stateName','beanProperties');
            arguments.put('stateAbbrev','beanProperties');
            arguments.put('officeCode','beanProperties');
            arguments.put('zipCode','beanProperties');
            arguments.put('sitePhoneNbr','beanProperties');
            arguments.put(fipsCode,'fipsCode');

            FSA_BTO_URLs__c endpoint = FSA_BTO_URLs__c.getInstance('FSA_BTO_CBS_Endpoint');

        if(!Test.isRunningTest()) {
            
            
                        
            makeRequest(arguments, endpoint.URL__c); 
        } else {
            makeRequest(arguments, 'https://fake.fsa.usda.gov/cbs-ejb/services/CommonBusinessDataServicePort'); 
        }
        //return cbsCounty.countyRecord;
    }
    
    public static void makeRequest(Map<String,String> argumentMap, String endpoint) {
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type','text/xml');
        FSA_BTO_URLs__c certName = FSA_BTO_URLs__c.getInstance('FSA_BTO_Cert_Name');
        request.setClientCertificateName(certName.URL__c);
        FSA_BTO_CBSSoapPacketBuilder packetBuilder = new FSA_BTO_CBSSoapPacketBuilder();
        packetBuilder.argumentMap = argumentMap;
        String xmlReq = packetBuilder.toXmlString();
        //System.debug('Request: ' + xmlReq);
        request.setBody(xmlReq);
        Http http = new Http();
        HttpResponse response = http.send(request);
        parseSoapResponse(response.getBody());
        //System.debug('Response: ' + response);
    }

    public static void parseSoapResponse(String soapResponse) {
        String envNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String msgNS = 'http://service.cbs.citso.fsa.usda.gov';
        DOM.Document doc = new DOM.Document();
        doc.load(soapResponse);
        DOM.XMLNode envRoot = doc.getRootElement();
        DOM.XMLNode envBody = envRoot.getChildElement('Body', envNS); 
        DOM.XMLNode envMsg = envBody.getChildElement('findFSAOfficesByStateFipsResponse',msgNS);
        cbsCounty = new  FSA_BTO_CBSCounty(envMsg);
    }




}
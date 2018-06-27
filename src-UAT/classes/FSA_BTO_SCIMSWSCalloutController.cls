public class FSA_BTO_SCIMSWSCalloutController {

	public FSA_BTO_SCIMSCustomer scimsCustomer { get; set; }
	@TestVisible private static final String NO_ACTIVE_SETTING_RECORD_ERROR = 'No SCIMS Setting record found. An active SCIMS Setting record is required for each environment.';

	public FSA_BTO_SCIMSCustomer getCustomer(String coreCustomerId) {
		Map<String,String> arguments = new Map<String,String>();

		if(!Test.isRunningTest()) {
			String orgUrl = System.URL.getSalesforceBaseUrl().getHost();
			String endpoint;
			String orgName;

			try {
				SCIMS_Setting__mdt setting = [
					SELECT Org_Name__c, Web_Service_URL__c
					FROM SCIMS_Setting__mdt
					WHERE Active__c = true
					LIMIT 1
				];
				endpoint = setting.Web_Service_URL__c;
				orgName = setting.Org_Name__c;
			} catch (Exception e) {
				throw new SettingNotFoundException(NO_ACTIVE_SETTING_RECORD_ERROR);
			}

			User u = [
				SELECT FederationIdentifier, Username
				FROM User
				WHERE Id = :UserInfo.getUserId()
				LIMIT 1
			];
			String uniqueIdentifier;
			if(!String.isEmpty(u.FederationIdentifier)) {
				uniqueIdentifier = u.FederationIdentifier;
			} else {
				uniqueIdentifier = u.Username;
			}

			arguments.put('sQueryString', '&lt;SCIMSQuery&gt;&lt;SearchParameter CustomerStatus=\'both\' ParameterType=\'core_customer_identifier\'&gt;' + coreCustomerId + '&lt;/SearchParameter&gt;&lt;DataOptions CustomerAttributes=\'yes\' Address=\'all\' Phone=\'all\' Email=\'all\' Disability=\'all\' &gt;&lt;/DataOptions&gt;&lt;RequestInfo ApplicationID=\'Salesforce FSA Bridges to Opportunity\' UserID=\'' + uniqueIdentifier + '\' ProcessingNode=\'' + orgName + '\' RequestHost=\'' + orgUrl + '\' /&gt;&lt;/SCIMSQuery&gt;');
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
		request.setClientCertificateName('bto_prod');
		FSA_BTO_SCIMSWSSoapPacketBuilder packetBuilder = new FSA_BTO_SCIMSWSSoapPacketBuilder();
		packetBuilder.argumentMap = argumentMap;
		String xmlReq = packetBuilder.toXmlString();
		request.setBody(xmlReq);
		Http http = new Http();
		HttpResponse response = http.send(request);
		parseSoapResponse(response.getBody());
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
		scimsCustomer = new FSA_BTO_SCIMSCustomer(xmlString);
	}

	public class SettingNotFoundException extends Exception {}
}
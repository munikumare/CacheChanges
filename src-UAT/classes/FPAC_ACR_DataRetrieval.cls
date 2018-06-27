public with sharing class FPAC_ACR_DataRetrieval {
    
    public FPAC_ACR_DataResponse GetCompilanceFarmData(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
	{
        FPAC_ACR_DataResponse response = new FPAC_ACR_DataResponse();

		System.debug(coreCustomerId);
		System.debug(programYear);
		System.debug(stateFsaCode);
		System.debug(countyFsaCode);
           
        String endpoint = ('callout:Mulesoft/retrieveComplianceFarmData?years=' + programYear +
            																 '&stateCode=' + stateFsaCode +
            																 '&countyCode=' + countyFsaCode +
            																 '&coreCustomerId=' + coreCustomerId +
            																 '&includeZeroAcreageData=true&includeProducerData=true&includeFields=true&includeProducerShares=true&includeAgriProdPlans=true');
       	Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(20000);
        HttpResponse res = h.send(req);
        String acrResponse = res.getBody();
     
        if(res.getStatusCode() == 200 && !string.isBlank(acrResponse))
             response = (FPAC_ACR_DataResponse) JSON.deserialize(acrResponse, FPAC_ACR_DataResponse.class);
             
       return response; 
	}
}
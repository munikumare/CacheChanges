public with sharing class FPAC_NCT_DataRetrieval {
	
    public FPAC_NCT_WhipInformationResponse GetApprovedWhipInformation(decimal programYear, 
    																	string stateFsaCode, 
    																	string countyFsaCode, 
    																	string cropCode,
    																	string cropType,
    																	string cropUse)
	{
        FPAC_NCT_WhipInformationResponse response = new FPAC_NCT_WhipInformationResponse();

           
        String endpoint = ('callout:Mulesoft/nct/retrieveApprovedWhipInformation?year=' + programYear +
            																 '&state=' + stateFsaCode +
            																 '&county=' + countyFsaCode +
            																 '&crop=' + cropCode + 
            																 '&type=' + cropType +
            																 '&use=' + cropUse);
            																 
        System.debug('endpoint - ' + endpoint);   
         																 
       	Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        String nctResponse = res.getBody();
        
        if(res.getStatusCode() == 200 && !string.isBlank(nctResponse))
             response = (FPAC_NCT_WhipInformationResponse) JSON.deserialize(nctResponse, FPAC_NCT_WhipInformationResponse.class);
             
        
       return response; 
	}
}
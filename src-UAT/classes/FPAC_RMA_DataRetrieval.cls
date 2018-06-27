public with sharing class FPAC_RMA_DataRetrieval {
    
    public List<FPAC_RMA_PolicyProducer> GetProducerPolicies(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
        List<FPAC_RMA_PolicyProducer> response = new List<FPAC_RMA_PolicyProducer>();
           
        String endpoint = ('callout:Mulesoft_PreProd/producers?year=' + programYear +
                                                                     '&ccid=' + coreCustomerId +
                                                                     '&stateCode=' + stateFsaCode +
                                                                     '&countyCode=' + countyFsaCode);
        //system.debug(endpoint);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60000);
        HttpResponse res = h.send(req);
        String rmaResponse = res.getBody();
     	
     	//System.debug('Producer Policies - ' + rmaResponse);
     	
         if(res.getStatusCode() == 200 && !string.isBlank(rmaResponse) && rmaResponse != '""')
             response = (List<FPAC_RMA_PolicyProducer>) JSON.deserialize(rmaResponse, List<FPAC_RMA_PolicyProducer>.class);
             
       return response; 
    }
    
    public List<FPAC_RMA_InsuranceOffer> GetInsuranceOffersAndPrices(string reinsuranceYear, 
    															string stateCode, 
    															string countyCode, 
    															string commodityYear, 
    															string commodityCode, 
    															string insurancePlanCode,
    															string typeCode,
    															string practiceCode)
    {
        List<FPAC_RMA_InsuranceOffer> response = new List<FPAC_RMA_InsuranceOffer>();
           
        String endpoint = ('callout:Mulesoft_PreProd/getInsuranceOffersAndPrices?reinsuranceYear=' + reinsuranceYear +
			                                                                     '&stateCode=' + stateCode +
			                                                                     '&countyCode=' + countyCode +
			                                                                     (String.isBlank(commodityYear) ? '' : ('&commodityYear=' + commodityYear)) + 
			                                                                     (String.isBlank(commodityCode) ? '' : ('&commodityCode=' + commodityCode)) + 
			                                                                     (String.isBlank(insurancePlanCode) ? '' : ('&insurancePlanCode=' + insurancePlanCode)) +
			                                                                     (String.isBlank(typeCode) ? '' : ('&typeCode=' + typeCode)) +
			                                                                     (String.isBlank(practiceCode) ? '' : ('&practiceCode=' + practiceCode)));
		System.Debug(endpoint);	                                                                     
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60000);
        HttpResponse res = h.send(req);
        String rmaResponse = res.getBody();
        System.debug(rmaResponse);
         if(res.getStatusCode() == 200 && !string.isBlank(rmaResponse) && rmaResponse != '""')
             response = (List<FPAC_RMA_InsuranceOffer>) JSON.deserialize(rmaResponse, List<FPAC_RMA_InsuranceOffer>.class);
             
       return response; 
    }
}
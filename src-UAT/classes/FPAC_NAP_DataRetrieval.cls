public with sharing class FPAC_NAP_DataRetrieval {
    
    public FPAC_NAP_CoverageByProducerResponse GetCoverageByProducer(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
        FPAC_NAP_CoverageByProducerResponse response = new FPAC_NAP_CoverageByProducerResponse();
           
        String endpoint = ('callout:Mulesoft/api/retrieveCoverageByProducer?coreCustomerId=' + coreCustomerId +
                                                                             '&programYear=' + programYear +
                                                                             '&stateFSACode=' + stateFsaCode +
                                                                             '&countyFSACode=' + countyFsaCode);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(20000);
        HttpResponse res = h.send(req);
        String napResponse = res.getBody();
        
        //System.debug('-- retrieve coverage by producer response - '  + napResponse);
        
        if(res.getStatusCode() == 200 && !string.isBlank(napResponse))
             response = (FPAC_NAP_CoverageByProducerResponse) JSON.deserialize(napResponse, FPAC_NAP_CoverageByProducerResponse.class);
        
       return response;
    }
     
    
    public FPAC_NAP_ApplicationByProducerResponse GetApplicationByProducer(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
        FPAC_NAP_ApplicationByProducerResponse response = new FPAC_NAP_ApplicationByProducerResponse();

        String endpoint = ('callout:Mulesoft/api/retrieveApplicationByProducer?coreCustomerId=' + coreCustomerId +
                                                                             '&programYear=' + programYear +
                                                                             '&stateFSACode=' + stateFsaCode +
                                                                             '&countyFSACode=' + countyFsaCode);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(20000);
        HttpResponse res = h.send(req);
        String napResponse = res.getBody();
        
        //System.debug('-- json retrieve application by producer response - ' + napResponse);
        
        if(res.getStatusCode() == 200 && !string.isBlank(napResponse))
             response = (FPAC_NAP_ApplicationByProducerResponse) JSON.deserialize(napResponse, FPAC_NAP_ApplicationByProducerResponse.class);
        
        System.debug('-- object retrieve application by producer response - ' + response);
       return response;
    }
    
}
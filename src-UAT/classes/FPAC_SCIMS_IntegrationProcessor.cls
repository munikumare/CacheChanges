public without sharing class FPAC_SCIMS_IntegrationProcessor {

    //THIS METHOD ALWAYS PROCESS 1 RECORD    
    public void LoadCustomerDetails(List<string> individualIds)
    {
        
        if (individualIds.size() > 0)
        {
            FPAC_SCIMS_AuthorityProcessor authorityProcessor = new FPAC_SCIMS_AuthorityProcessor();
            authorityProcessor.processCustomerandAuthority(individualIds[0]);
        }

            
    }
}
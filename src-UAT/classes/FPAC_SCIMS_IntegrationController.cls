public without sharing class FPAC_SCIMS_IntegrationController{
    
    public void LoadCustomerDetailsById(List<string> customerIds)
    {
        FPAC_SCIMS_IntegrationProcessor scimsIntegration = new FPAC_SCIMS_IntegrationProcessor();
        scimsIntegration.LoadCustomerDetails(customerIds);
    }
    
}
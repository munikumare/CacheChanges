public class ScimsAuraService {
    
	@AuraEnabled
    public static void refreshDetailsFromScims(List<string> individualIds)
    {
        FPAC_SCIMS_IntegrationController integrationController = new FPAC_SCIMS_IntegrationController();
        integrationController.LoadCustomerDetailsById(individualIds);
    }
}
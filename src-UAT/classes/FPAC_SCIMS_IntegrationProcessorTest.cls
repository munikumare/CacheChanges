@isTest
public class FPAC_SCIMS_IntegrationProcessorTest {
    
    static Contact getContact()
    {
        Contact individual = new Contact();
        individual.LastName = 'testLastName';
        individual.FirstName = 'test';
        individual.FSA_BTO_Core_Customer_ID__c = '9748672';
        
        individual.MailingStreet = '1660 Greensboro Dr.';
        individual.MailingCity = 'McLean';
        individual.MailingStateCode = 'VA';
        individual.MailingPostalCode = '22180';
        return individual;
    } 


    @isTest
	public static void ProcessIntegration_givenIndividualIds_shouldGetCustomerAndFarmDetailsAndUpdate() {
    	
    	Test.setMock(HttpCalloutMock.class, new ScimsServiceMockImpl());
     
        Contact individual = getContact();
        insert individual;
        
        List<string> individualIds = new List<string>();
        individualIds.add(individual.Id);
        
        FPAC_SCIMS_IntegrationProcessor integrationProcessor = new FPAC_SCIMS_IntegrationProcessor();
        
        Test.startTest();
        integrationProcessor.LoadCustomerDetails(individualIds);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Id = :individual.Id and FirstName != 'test'], 'Individual record should have been updated');
    }
    
}
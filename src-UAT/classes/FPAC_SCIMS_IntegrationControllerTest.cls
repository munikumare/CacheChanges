@isTest
public class FPAC_SCIMS_IntegrationControllerTest {
	
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
	public static void ProcessCustomer_givenId_shouldGetCustomerDetailsAndUpdate() {
    	Test.setMock(HttpCalloutMock.class, new ScimsServiceMockImpl());
    	
        Contact individual = getContact();
        insert individual;
        
        FPAC_SCIMS_IntegrationController integrationController = new FPAC_SCIMS_IntegrationController();
        
        List<string> customerIds = new List<string>();
        customerIds.add(individual.Id);
        
        Test.startTest();
        integrationController.LoadCustomerDetailsById(customerIds);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Id = :individual.Id AND LastName != 'testLastName'], 'An individual record with CCID 9748672 should have been updated');
    }
}
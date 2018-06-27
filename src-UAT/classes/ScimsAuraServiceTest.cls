@isTest
public class ScimsAuraServiceTest{
    
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

    static Land__c getFarm(Id individualId)
    {
        Land__c farm = new Land__c();
        farm.Farm_Number__c = '0000855';
        farm.Individual__c = individualId;
        farm.Admin_State_Code__c = '17';
        farm.Admin_County_Code__c = '039';
        farm.Description__c = 'RONALD AND JANICE SAMS';
        farm.Land_ID__c = farm.Farm_Number__c + farm.Admin_State_Code__c + farm.Admin_County_Code__c;
        return farm;
    }

    @isTest
	public static void RefreshDetailsFromScims_givenCoreCustomerId_shouldGetCustomerAndFarmDetailsAndCreateNew() {
    	
    	Test.setMock(HttpCalloutMock.class, new ScimsServiceMockImpl());
    	
        Contact individual = getContact();
        insert individual;

        List<string> individualIds = new List<string>();
        individualIds.Add(individual.Id); 
        
        Test.startTest();
        ScimsAuraService.refreshDetailsFromScims(individualIds);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Land__c WHERE Individual__c = :individual.Id], 'A farm record should have been created');
    }
    

}
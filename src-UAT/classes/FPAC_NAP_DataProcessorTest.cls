@isTest
public with sharing class FPAC_NAP_DataProcessorTest {
	  
    static decimal programYear = 2017; 
    static string countyCode = '015';
    static string stateCode = '19';
    static string coreCustomerId = '563753';
    
    static Contact getContact()
    {
        Contact individual = new Contact();
        individual.LastName = 'testLastName';
        individual.FirstName = 'test';
        individual.FSA_BTO_Core_Customer_ID__c = coreCustomerId;
        
        individual.MailingStreet = '1660 Greensboro Dr.';
        individual.MailingCity = 'McLean';
        individual.MailingStateCode = 'VA';
        individual.MailingPostalCode = '22180';
        return individual;
    } 
    
    @isTest
	public static void ProcessData_givenInput_shouldCreateNapData() {
    	
    	Test.setMock(HttpCalloutMock.class, new FPAC_NAP_ServiceMockImpl());
        
        Contact contact = getContact();
        insert contact; 
        
        FPAC_NAP_DataProcessor napDataProcessor = new FPAC_NAP_DataProcessor();
        
        Test.startTest();
        napDataProcessor.ProcessData(coreCustomerId, programYear, stateCode, countyCode);
        Test.stopTest(); 
        
        System.assertEquals(10, 
    						[SELECT count() FROM NAP_RMA_NCT_ACR_Data__c 
    							WHERE CCID__c = :coreCustomerId AND 
								NAP_Program_Year__c = :programYear AND
								State_Code__c = :stateCode AND
								County_Code__c = :countyCode], 
							'Records created successfully'); 
    }
}
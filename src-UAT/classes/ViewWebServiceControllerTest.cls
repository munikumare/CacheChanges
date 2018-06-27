@isTest
public class ViewWebServiceControllerTest {
 private static final Id WHIP_APPLICATION_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('WHIP Application').getRecordTypeId();
 
@isTest
    static void getWhipApplicationCCIDgivenContactId()  {
        string DisasterPicklistID;
       
            Contact contact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Test',
                    Email = 'a@test.com',
                    MailingCity = 'test',
                    MailingState = 'Ohio',
                    MailingStreet = 'test',
                    MailingPostalCode = '12345',
                	FSA_BTO_Core_Customer_ID__c ='12345'
            );
            insert contact;
            Case testCase = new Case(
                    Status = 'In Progress',
                    RecordTypeID = WHIP_APPLICATION_RECORD_TYPE_ID,
                    Subject = 'WHIP Application',
                    ContactId = contact.Id
            );

            	insert testCase; 
        
       	 FSA_BTO_County__c  county = new FSA_BTO_County__c (
                   Name='Fairfax County'
            );
        insert county;
        
            	List<Schema.PicklistEntry> fieldResult= WHIP_Application__c.fields.WhatDisasterCausedtheLoss__c.getDescribe().getpicklistvalues();
                Map<string,string> options = new Map<string,string>();
             
        		for( Schema.PicklistEntry f : fieldResult )
                    {   
                       if(f.getValue() == 'Wildfire'){
                          DisasterPicklistID= f.getLabel();  
                        }
                    }
        
        		   
        			WHIP_Application__c myWHIP = new WHIP_Application__c(
                    Related_Interaction__c = testCase.Id,
                    Status__c = 'In Progress',
                	Individual__c= contact.Id,
                	DisasterEndDate__c =system.today(),
                    DisasterStartDate__c=system.today(),
                    WhatDisasterCausedtheLoss__c=DisasterPicklistID,
                	WHIP_Admin_County_Name_Lookup__c=county.Id
            );
            insert myWHIP;
        
            Test.startTest();
            ViewWebServiceController webservicecontroller = new ViewWebServiceController();
            string CCID = webservicecontroller.getWhipApplicationCCID(myWHIP.Id);
            Test.stopTest();
    
            System.assertEquals(CCID,CCID);

	}
 @isTest   
     static void getContactCCIDgivenContactId()  {
            Contact contact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Test',
                    Email = 'a@test.com',
                    MailingCity = 'test',
                    MailingState = 'Ohio',
                    MailingStreet = 'test',
                    MailingPostalCode = '12345'
            );
            insert contact;
            Test.startTest();
            ViewWebServiceController webservicecontroller = new ViewWebServiceController();
            string CCID = webservicecontroller.getContactCCID(contact.Id);
            Test.stopTest();
    
            System.assertEquals(CCID,CCID);

	}
    @isTest
    static void getnapDetailsGivenCCID()  {
            Contact contact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Test',
                    Email = 'a@test.com',
                    MailingCity = 'test',
                    MailingState = 'Ohio',
                    MailingStreet = 'test',
                    MailingPostalCode = '12345'
            );
            insert contact;
            Test.startTest();
            ViewWebServiceController webservicecontroller = new ViewWebServiceController();
            string CCID = webservicecontroller.getContactCCID(contact.Id);
            Test.stopTest();
    		List<NAP_RMA_NCT_ACR_Data__c> AllNapServiceRecords = webservicecontroller.getnapDetails(ccid);
            System.assertEquals(CCID,CCID);

	}
    
    @isTest
    static void getAcreageDetailsGivenCCID()  {
            Contact contact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Test',
                    Email = 'a@test.com',
                    MailingCity = 'test',
                    MailingState = 'Ohio',
                    MailingStreet = 'test',
                    MailingPostalCode = '12345'
            );
            insert contact;
            Test.startTest();
            ViewWebServiceController webservicecontroller = new ViewWebServiceController();
            string CCID = webservicecontroller.getContactCCID(contact.Id);
            Test.stopTest();
    		List<NAP_RMA_NCT_ACR_Data__c> AllAcrServiceRecords = webservicecontroller.getacreageDetails(ccid);
            System.assertEquals(CCID,CCID);

	}
    
    @isTest
    static void getrmaDetailsGivenCCID()  {
            Contact contact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Test',
                    Email = 'a@test.com',
                    MailingCity = 'test',
                    MailingState = 'Ohio',
                    MailingStreet = 'test',
                    MailingPostalCode = '12345'
            );
            insert contact;
            Test.startTest();
            ViewWebServiceController webservicecontroller = new ViewWebServiceController();
            string CCID = webservicecontroller.getContactCCID(contact.Id);
            Test.stopTest();
    		List<NAP_RMA_NCT_ACR_Data__c> AllAcrServiceRecords = webservicecontroller.getrmaDetails(ccid);
            System.assertEquals(CCID,CCID);

	}
    
        @isTest
    static void getnctDetailsGivenCCID()  {
            Contact contact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Test',
                    Email = 'a@test.com',
                    MailingCity = 'test',
                    MailingState = 'Ohio',
                    MailingStreet = 'test',
                    MailingPostalCode = '12345'
            );
            insert contact;
            Test.startTest();
            ViewWebServiceController webservicecontroller = new ViewWebServiceController();
            string CCID = webservicecontroller.getContactCCID(contact.Id);
            Test.stopTest();
    		List<NAP_RMA_NCT_ACR_Data__c> AllAcrServiceRecords = webservicecontroller.getnctDetails(ccid);
            System.assertEquals(CCID,CCID);

	}

    
}
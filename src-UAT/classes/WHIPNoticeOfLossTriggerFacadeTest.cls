@isTest
public class WHIPNoticeOfLossTriggerFacadeTest {
  @isTest
	public static void ProcessData_givenInput_shouldCreateNctData() {   
        Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;       
         
       	WHIPNoticeOfLossTriggerFacade ntf = WHIPNoticeOfLossTriggerFacade.createWHIPNoticeOfLossTriggerFacade();
        WHIPNoticeofLoss__c wnol = new WHIPNoticeofLoss__c(CropYear__c='2018',            				
            												WHIP_Application__c=application1.Id
                                                          );
        insert wnol;
        
       	List<WHIPNoticeofLoss__c> whipnoticeoflosses = new List<WHIPNoticeofLoss__c>{ wnol };
        ntf.createNCTRecords(whipnoticeoflosses);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FPAC_NCT_ServiceMockImpl()); 
        WHIPNoticeOfLossTriggerFacade.createNCTRecordsCallout(2018, '38', '013', '0012',null,null);
        Test.stopTest(); 
        System.assert(true); 
    }
    
    private static Case createCustomerInteraction(Integer iteration) {
		Case customerInteraction = new Case();
		Contact contact = new Contact(
			FirstName = 'Test' + iteration,
			LastName = 'Test' + iteration,
			Email = 'a' + iteration + '@test.com',
			MailingCity = 'test',
			MailingState = 'Ohio',
			MailingStreet = 'test',
			MailingPostalCode = '12345'
		);
		insert contact;
		customerInteraction.Status = 'In Progress';
		customerInteraction.Subject = 'WHIP Application';
		customerInteraction.ContactId = contact.Id;
		return customerInteraction;
	}
    
    private static WHIP_Application__c createWHIPApplication(String customerInteractionId) {
        string DisasterPicklistID;
        List<Schema.PicklistEntry> fieldResult= WHIP_Application__c.fields.WhatDisasterCausedtheLoss__c.getDescribe().getpicklistvalues();
        for( Schema.PicklistEntry f : fieldResult )
            {   
                if(f.getValue() == 'Unrelated'){
                    DisasterPicklistID= f.getLabel();  
                }	
            }
        FSA_BTO_County__c  county = new FSA_BTO_County__c (
                   Name='Fairfax County'
            );
        insert county;
        
		WHIP_Application__c application = new WHIP_Application__c();
		application.Related_Interaction__c = customerInteractionId;
        application.WhatDisasterCausedtheLoss__c = DisasterPicklistID;
        application.WHIP_Admin_County_Name_Lookup__c =county.Id; 
        application.DisasterStartDate__c =System.Today();
        application.DisasterEndDate__c =System.Today();
		return application;
	}
}
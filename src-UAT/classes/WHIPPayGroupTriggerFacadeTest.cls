@isTest
public class WHIPPayGroupTriggerFacadeTest {
  @isTest
    
public static void UpdatePayGroup_givenNOLStatusDissapproved_shouldSetApprovalStatus() {  
       
        Case interaction1 = createCustomerInteraction(1);
		insert interaction1;
 		
        Test.setMock(HttpCalloutMock.class, WHIPCalloutMockFactory.getCalloutMock());
		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;

       
		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id,'Disapproved');
		insert notice1;
        
        WHIPNoticeofLoss__c notice2 = createWHIPNoticeofLoss(1, application1.Id,'Disapproved');
		insert notice2;
        
       	Id WHIPLossRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
        WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id,WHIPLossRecordType);
		insert lossInformation1;

	
	 	
        
		WHIPPayGroup__c payGroup1 = new WHIPPayGroup__c(   
            	Unit__c = 'test1' ,
				PayCropCode__c = 'test1' ,
				PayTypeCode__c = 'test1' ,
				PlantingPeriod__c = 'period1' ,
				WHIPApplicationPayGroup__c = application1.Id
        		);
		insert payGroup1;
        
        lossInformation1.WHIP_Pay_Group__c = payGroup1.id;
        update lossInformation1;
        
      
        
        payGroup1.PlantingPeriod__c='Updated period1';
        payGroup1.ApprovalStatus__c ='Approved';
       
        try
        {
        update payGroup1;
        }
        catch (Exception e){

        System.assert(e.getMessage().contains('This Pay Group cannot be approved'));
        }
        
    }
    
  @isTest       
public static void UpdatePayGroup_givenNOLStatusApproved_shouldSetApprovalStatus() {  
       
        Case interaction1 = createCustomerInteraction(1);
		insert interaction1;
		
    	Test.setMock(HttpCalloutMock.class, WHIPCalloutMockFactory.getCalloutMock());
		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;

       
		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id,'Approved');
		insert notice1;
        
        WHIPNoticeofLoss__c notice2 = createWHIPNoticeofLoss(1, application1.Id,'Disapproved');
		insert notice2;
        
       	Id WHIPLossRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
        WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id,WHIPLossRecordType);
		insert lossInformation1;

		        
		WHIPPayGroup__c payGroup1 = new WHIPPayGroup__c(   
            	Unit__c = 'test1' ,
				PayCropCode__c = 'test1' ,
				PayTypeCode__c = 'test1' ,
				PlantingPeriod__c = 'period1' ,
				WHIPApplicationPayGroup__c = application1.Id
        		);
		insert payGroup1;
        
        lossInformation1.WHIP_Pay_Group__c = payGroup1.id;
        update lossInformation1;
        
      
        
        payGroup1.PlantingPeriod__c='Updated period1';
        payGroup1.ApprovalStatus__c ='Approved';
       
        try
        {
        update payGroup1;
        }
        catch (Exception e){
        }
        
    }
   
    
@isTest       
public static void UpdatePayGroup_givenNOLStatusEmpty_shouldSetApprovalStatus() {  
       
        Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

    	Test.setMock(HttpCalloutMock.class, WHIPCalloutMockFactory.getCalloutMock());
		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;
       
		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id,'');
		insert notice1;
    
    
        WHIPNoticeofLoss__c notice2 = createWHIPNoticeofLoss(1, application1.Id,'Disapproved');
		insert notice2;
               
       	Id WHIPLossRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
        WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id,WHIPLossRecordType);
		insert lossInformation1;

		
        
		WHIPPayGroup__c payGroup1 = new WHIPPayGroup__c(   
            	Unit__c = 'test1' ,
				PayCropCode__c = 'test1' ,
				PayTypeCode__c = 'test1' ,
				PlantingPeriod__c = 'period1' ,
				WHIPApplicationPayGroup__c = application1.Id
        		);
		insert payGroup1;
        
        lossInformation1.WHIP_Pay_Group__c = payGroup1.id;
        update lossInformation1;
        
       
        
        payGroup1.PlantingPeriod__c='Updated period1';
        payGroup1.ApprovalStatus__c ='Approved';
       
        try
        {
        update payGroup1;
        }
        catch (Exception e){

        System.assert(e.getMessage().contains('This Pay Group cannot be approved'));
        }
        
    }
   
    
    private static WHIPLossInformation__c createWHIPLossInformation(Integer iteration, String noticeId, 
                                                                        Id WHIPLossRecordType) {
		WHIPLossInformation__c information = new WHIPLossInformation__c();
		information.Unit__c = 'test' + iteration;
		information.PayCropCode__c = '0012';
		information.PayTypeCode__c = 'COM';
        information.CropType__c = 'BLU';
		information.WHIPNoticeofLoss__c = noticeId;
        information.PhysicalStateNameCode__c='38';
        information.PhysicalCountyNameCode__c='013';
        information.WHIPNoticeofLoss__c = noticeId;
        information.RecordTypeId = WHIPLossRecordType;
		return information;
	}


	private static WHIPNoticeofLoss__c createWHIPNoticeofLoss(Integer iteration, String applicationId, string cosStatus) {
		WHIPNoticeofLoss__c notice = new WHIPNoticeofLoss__c();
		notice.PlantingPeriod__c = 'period' + iteration;
		notice.WHIP_Application__c = applicationId;     
		notice.COCStatus__c =cosStatus;
		return notice;
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
        application.DisasterEndDate__c= Date.newInstance(2017, 12, 1);
        application.DisasterStartDate__c= Date.newInstance(2017, 12, 9);
                
		return application;
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
    
}
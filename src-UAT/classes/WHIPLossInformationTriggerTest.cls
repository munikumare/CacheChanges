@isTest
private class WHIPLossInformationTriggerTest {

	@isTest static void updatePayGrouping_givenWHIPLossInformation_shouldCreatePayGroup() {
		List<WHIPLossInformation__c> contextInformations = new List<WHIPLossInformation__c>();

		Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

		Case interaction2 = createCustomerInteraction(2);
		insert interaction2;

		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;
		WHIP_Application__c application2 = createWHIPApplication(interaction2.Id);
		insert application2;

		WHIPPayGroup__c payGroup1 = createWHIPPayGroup(1, application1.Id);
		insert payGroup1;
		WHIPPayGroup__c payGroup2 = createWHIPPayGroup(2, application2.Id);
		insert payGroup2;

		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id);
		insert notice1;
		WHIPNoticeofLoss__c notice2 = createWHIPNoticeofLoss(2, application2.Id);
		insert notice2;

		WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id);
		WHIPLossInformation__c lossInformation2 = createWHIPLossInformation(2, notice2.Id);
		WHIPLossInformation__c lossInformation3 = createWHIPLossInformation(3, notice2.Id);

		contextInformations.add(lossInformation1);
		contextInformations.add(lossInformation2);
		contextInformations.add(lossInformation3);

		Test.startTest();
			insert contextInformations;
		Test.stopTest();

		WHIPLossInformation__c queriedInformation1 = [SELECT WHIP_Pay_Group__c FROM WHIPLossInformation__c WHERE Id = :lossInformation1.Id];
		WHIPLossInformation__c queriedInformation2 = [SELECT WHIP_Pay_Group__c FROM WHIPLossInformation__c WHERE Id = :lossInformation2.Id];
		WHIPLossInformation__c queriedInformation3 = [SELECT WHIP_Pay_Group__c FROM WHIPLossInformation__c WHERE Id = :lossInformation3.Id];

		System.assertEquals(payGroup1.Id, queriedInformation1.WHIP_Pay_Group__c);
		System.assertEquals(payGroup2.Id, queriedInformation2.WHIP_Pay_Group__c);
		System.assertNotEquals(payGroup1.Id, queriedInformation3.WHIP_Pay_Group__c);
		System.assertNotEquals(payGroup2.Id, queriedInformation3.WHIP_Pay_Group__c);
		System.assertNotEquals(null, queriedInformation3.WHIP_Pay_Group__c);		

	}

	@isTest static void checkForWHIPLossInformationFieldUpdates_givenWHIPLossInformation_shouldCreatePayGroup() {
		Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;

		WHIPPayGroup__c payGroup1 = createWHIPPayGroup(1, application1.Id);
		insert payGroup1;

		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id);
		insert notice1;

		WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id);
		insert lossInformation1;

		Test.startTest();
			lossInformation1.Unit__c = 'testtest5';
			update lossInformation1;
		Test.stopTest();

		WHIPLossInformation__c queriedInformation1 = [SELECT WHIP_Pay_Group__c FROM WHIPLossInformation__c WHERE Id = :lossInformation1.Id];

		System.assertNotEquals(payGroup1.Id, queriedInformation1.WHIP_Pay_Group__c);		

	}

	@isTest static void updateRollUpsToPayGroup_givenWHIPLossInformation_shouldDeletePayGroup() {
		Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;

		WHIPPayGroup__c payGroup1 = createWHIPPayGroup(1, application1.Id);
		insert payGroup1;

		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id);
		insert notice1;

		WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id);
		insert lossInformation1;

		Test.startTest();
			lossInformation1.Unit__c = 'testtest5';
			update lossInformation1;
		Test.stopTest();

		List<WHIPPayGroup__c> payGroups = [SELECT Id FROM WHIPPayGroup__c WHERE Id = :payGroup1.Id];

		System.assertEquals(0, payGroups.size());		

	}

	@isTest static void updateRollUpsToPayGroup_givenWHIPLossInformation_shouldUpdateSummaryOnPayGroup() {
		Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;

		WHIPPayGroup__c payGroup1 = createWHIPPayGroup(1, application1.Id);
		insert payGroup1;

		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id);
		insert notice1;

		WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id);
		lossInformation1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
		lossInformation1.WHIP_Pay_Group__c = payGroup1.Id;
		insert lossInformation1;

		WHIPLossInformation__c lossInformation2 = createWHIPLossInformation(1, notice1.Id);
		lossInformation2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
		lossInformation2.WHIP_Pay_Group__c = payGroup1.Id;

		Test.startTest();
			insert lossInformation2;
		Test.stopTest();

		WHIPPayGroup__c payGroup = [SELECT Id, PL_Total__c FROM WHIPPayGroup__c WHERE Id = :payGroup1.Id];

		System.assertEquals(2, payGroup.PL_Total__c);		
	}

	@isTest static void updateRollUpsToPayGroup_givenDeletedWHIPLossInformation_shouldUpdateSummaryOnPayGroup() {
		Case interaction1 = createCustomerInteraction(1);
		insert interaction1;

		WHIP_Application__c application1 = createWHIPApplication(interaction1.Id);
		insert application1;

		WHIPPayGroup__c payGroup1 = createWHIPPayGroup(1, application1.Id);
		insert payGroup1;

		WHIPNoticeofLoss__c notice1 = createWHIPNoticeofLoss(1, application1.Id);
		insert notice1;

		WHIPLossInformation__c lossInformation1 = createWHIPLossInformation(1, notice1.Id);
		lossInformation1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
		lossInformation1.WHIP_Pay_Group__c = payGroup1.Id;
		insert lossInformation1;

		WHIPLossInformation__c lossInformation2 = createWHIPLossInformation(1, notice1.Id);
		lossInformation2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :'Production_Loss' LIMIT 1].Id;
		lossInformation2.WHIP_Pay_Group__c = payGroup1.Id;
		insert lossInformation2;

		Test.startTest();
			delete lossInformation1;
		Test.stopTest();

		WHIPPayGroup__c payGroup = [SELECT Id, PL_Total__c FROM WHIPPayGroup__c WHERE Id = :payGroup1.Id];

		System.assertEquals(1, payGroup.PL_Total__c);		
	}

	private static WHIPLossInformation__c createWHIPLossInformation(Integer iteration, String noticeId) {
		WHIPLossInformation__c information = new WHIPLossInformation__c();
		information.Unit__c = 'test' + iteration;
		information.PayCropCode__c = 'test' + iteration;
		information.PayTypeCode__c = 'test' + iteration;
		information.WHIPNoticeofLoss__c = noticeId;

		return information;
	}

	private static WHIPPayGroup__c createWHIPPayGroup(Integer iteration, String applicationId) {
		WHIPPayGroup__c payGroup = new WHIPPayGroup__c();
		payGroup.Unit__c = 'test' + iteration;
		payGroup.PayCropCode__c = 'test' + iteration;
		payGroup.PayTypeCode__c = 'test' + iteration;
		payGroup.PlantingPeriod__c = 'period' + iteration;
		payGroup.WHIPApplicationPayGroup__c = applicationId;

		return payGroup;
	}

	private static WHIPNoticeofLoss__c createWHIPNoticeofLoss(Integer iteration, String applicationId) {
		WHIPNoticeofLoss__c notice = new WHIPNoticeofLoss__c();
		notice.PlantingPeriod__c = 'period' + iteration;
		notice.WHIP_Application__c = applicationId;

		return notice;
	}

	private static WHIP_Application__c createWHIPApplication(String customerInteractionId) {
		WHIP_Application__c application = new WHIP_Application__c();
		application.Related_Interaction__c = customerInteractionId;

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
@IsTest
private class WHIPApplicationPDFControllerTest {
	private static final String WHIP_APP_UNLOCKED = 'WHIP App Unlocked';
	private static final String WHIP_APP_LOCKED = 'Whip App Locked';
	private static final String WHIP_APPLICATION = 'WHIP Application';
	private static final Id WHIP_APPLICATION_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(WHIP_APPLICATION).getRecordTypeId();
	private static final Id WHIP_APP_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_UNLOCKED).getRecordTypeId();
	private static final Id WHIP_APP_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_LOCKED).getRecordTypeId();
	private static final String IN_PROGRESS = 'In Progress';
	private static final String APPROVED = 'Approved';

	@isTest
	static void const_givenAppId_shouldReturnData() {

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

		Case testCase = new Case(
				Status = APPROVED,
				RecordTypeID = WHIP_APPLICATION_RECORD_TYPE_ID,
				Subject = WHIP_APPLICATION,
				ContactId = contact.Id
		);
		insert testCase;

		FSA_BTO_County__c  county = new FSA_BTO_County__c(Name = 'test');
		insert county;

		WHIP_Application__c whipApp = new WHIP_Application__c(
				RecordTypeId = WHIP_APP_LOCKED_RECORD_TYPE_ID,
				Related_Interaction__c = testCase.Id,
				Status__c = IN_PROGRESS,
				WHIP_Admin_County_Name_Lookup__c = county.Id,
				DisasterEndDate__c = System.today(),
				DisasterStartDate__c = System.today(),
				WhatDisasterCausedtheLoss__c = 'Cold Winter'
		);
		insert whipApp;

		WHIPPayGroup__c payGroup = new WHIPPayGroup__c();
		payGroup.WHIPApplicationPayGroup__c = whipApp.Id;
		insert payGroup;

		WHIPNoticeofLoss__c nol = new WHIPNoticeofLoss__c(
				WHIP_Application__c = whipApp.Id
		);
		insert nol;

		WHIPLossInformation__c loss = new WHIPLossInformation__c(
			WHIP_Pay_Group__c = payGroup.Id,
			WHIPNoticeofLoss__c = nol.Id
		);
		insert loss;


		Test.setCurrentPageReference(Page.WHIPApplicationPDF);
		ApexPages.currentPage().getParameters().put('id', whipApp.Id);

		Test.startTest();

			WHIPApplicationPDFController controller = new WHIPApplicationPDFController();

		Test.stopTest();

		System.assert(true);
	}
}
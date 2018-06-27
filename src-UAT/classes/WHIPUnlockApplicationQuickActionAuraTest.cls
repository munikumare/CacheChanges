@isTest
public with sharing class WHIPUnlockApplicationQuickActionAuraTest {
	private static final String WHIP_APP_UNLOCKED = 'WHIP App Unlocked';
	private static final String WHIP_APP_LOCKED = 'Whip App Locked';
	private static final String WHIP_APPLICATION = 'WHIP Application';
	private static final Id WHIP_APPLICATION_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(WHIP_APPLICATION).getRecordTypeId();
	private static final Id WHIP_APP_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_UNLOCKED).getRecordTypeId();
	private static final Id WHIP_APP_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_LOCKED).getRecordTypeId();
	private static final String IN_PROGRESS = 'In Progress';
	private static final String APPROVED = 'Approved';
	
	private static final String WHIP_NOL_UNLOCKED = 'WHIP NOL Unlocked';	
	private static final Id WHIP_NOL_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get(WHIP_NOL_UNLOCKED).getRecordTypeId();
	
	private static final String WHIP_NOL_LOCKED = 'WHIP NOL Locked';	
	private static final Id WHIP_NOL_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get(WHIP_NOL_LOCKED).getRecordTypeId();
	private static final String WHIP_LI_PRODUCTIONLOSSLOCKED = 'Production Loss Locked';
    private static final String WHIP_LI_TREELOSSLOCKED = 'Tree Loss Locked';
    private static final String WHIP_LI_VALUELOSSLOCKED = 'Value Loss Locked';
    private static final String WHIP_LI_PRODUCTIONLOSSUNLOCKED = 'Production Loss';
    private static final String WHIP_LI_TREELOSSUNLOCKED = 'Tree Loss';
    private static final String WHIP_LI_VALUELOSSUNLOCKED = 'Value Loss';    
	private static final Id WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSUNLOCKED).getRecordTypeId();

    
	@isTest
	static void setRecordTypeUnlocked_givenAppId_shouldSetRecordTypeToUnlocked() {

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

		WHIP_Application__c wa = new WHIP_Application__c(
				RecordTypeId = WHIP_APP_LOCKED_RECORD_TYPE_ID,
				Related_Interaction__c = testCase.Id,
				Status__c = IN_PROGRESS
		);
		insert wa;

		WHIPNoticeofLoss__c nol = new WHIPNoticeofLoss__c(
				RecordTypeId = WHIP_NOL_LOCKED_RECORD_TYPE_ID,
				WHIP_Application__c = wa.Id

		);
		insert nol;

		WHIPLossInformation__c li = new WHIPLossInformation__c(
				RecordTypeId = WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID,
				WHIPNoticeofLoss__c = nol.Id
		);
		insert li;

		Test.startTest();

		WHIPUnlockApplicationQuickActionAura.setRecordTypeUnlocked(wa.Id);

		Test.stopTest();

		WHIP_Application__c updatedWa = [SELECT Id, RecordTypeId FROM WHIP_Application__c WHERE Id = :wa.Id];
		WHIPNoticeofLoss__c updatedNol = [SELECT Id, RecordTypeId FROM WHIPNoticeofLoss__c WHERE Id = :nol.Id];
		WHIPLossInformation__c updatedLoi = [SELECT Id, RecordTypeId FROM WHIPLossInformation__c WHERE Id = :li.Id];

		System.assertEquals(WHIP_APP_UNLOCKED_RECORD_TYPE_ID, updatedWa.RecordTypeId);
		System.assertEquals(WHIP_NOL_UNLOCKED_RECORD_TYPE_ID, updatedNol.RecordTypeId);
		System.assertEquals(WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID, updatedLoi.RecordTypeId);
	}
}
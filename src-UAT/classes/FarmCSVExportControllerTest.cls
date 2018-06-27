@isTest
private class FarmCSVExportControllerTest {

	private static final Integer FARMS_TO_INSERT = 2;
	private static final Integer TRACTS_TO_INSERT = 3;
	private static final Integer FIELDS_TO_INSERT = 2;
	private static final Id FARM_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();
	private static final Id TRACT_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();
	private static final Id FIELD_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();

	@testSetup static void insertLands() {
		List<Land__c> lands = new List<Land__c>();
		for(Integer i=0; i<FARMS_TO_INSERT; i++) {
			Land__c newFarm = new Land__c(
				Name = 'Farm' + i,
				RecordTypeId = FARM_RECORD_TYPE
			);
			lands.add(newFarm);
		}
		insert lands;
		for(Integer i=0; i<TRACTS_TO_INSERT; i++) {
			Land__c newTract = new Land__c(
				RecordTypeId = TRACT_RECORD_TYPE,
				Name = 'Tract' + i,
				Parent_ID__c = lands[0].Id
			);
			lands.add(newTract);
		}
		upsert lands;
		for(Integer i=0; i<FIELDS_TO_INSERT; i++) {
			Land__c newField = new Land__c(
				RecordTypeId = FIELD_RECORD_TYPE,
				Parent_ID__c = lands[FARMS_TO_INSERT].Id
			);
			lands.add(newField);
		}
		upsert lands;
	}

	@isTest static void getCsvName_givenFarmId_shouldReturnCsvName() {
		String farmId = [SELECT Id FROM Land__c WHERE Name = 'Farm0' LIMIT 1].Id;
		PageReference pageRef = Page.FarmCSVExport;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id',farmId);
		FarmCSVExportController controller = new FarmCSVExportController();

		Test.startTest();
			String result = controller.getCsvName();
		Test.stopTest();

		System.assertEquals(true, result.contains('.csv'), 'The csv name should have been returned correctly.');
	}

	@isTest static void getHeaderFields_shouldReturnHeader() {
		FarmCSVExportController controller = new FarmCSVExportController();

		Test.startTest();
			String result = controller.getHeaderFields();
		Test.stopTest();

		System.assertEquals(false, String.isEmpty(result), 'The header should have been returned.');
	}

	@isTest static void getLands_givenFarmId_shouldReturnRows() {
		String farmId = [SELECT Id FROM Land__c WHERE Name = 'Farm0' LIMIT 1].Id;
		PageReference pageRef = Page.FarmCSVExport;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id',farmId);
		FarmCSVExportController controller = new FarmCSVExportController();

		Test.startTest();
			List<String> result = controller.getLands();
		Test.stopTest();

		System.assertEquals(false, result.isEmpty(), 'The rows should have been returned correctly.');
	}

	@isTest static void getLandsAsCommunityUserOperator_givenFarmId_shouldReturnRows() {
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'FPAC Customer Login'].Id;
		Account account = new Account(Name ='testCSVaccount');
		insert account;
		Contact contact = new Contact(
			LastName ='testCon',
			AccountId = account.Id,
			MailingCity = 'TestCity',
			MailingState = 'Ohio',
			MailingStreet = 'test',
			MailingPostalCode = '44111'
		);
		insert contact;
		User user = new User(
			alias = 'test123',
			email = 'test123@noemail.com',
			emailencodingkey = 'UTF-8',
			lastname = 'Testing',
			languagelocalekey = 'en_US',
			localesidkey = 'en_US',
			profileid = profileId,
			country = 'United States',
			IsActive = true,
			ContactId = contact.Id,
			timezonesidkey = 'America/Los_Angeles',
			username = 'tester@noemail.com'
		);
		insert user;
		Land__c farm = [SELECT Id FROM Land__c WHERE Name = 'Farm0' LIMIT 1];
		insert new Authority__c(
			Associated_Land__c = farm.Id,
			Contact__c = contact.Id,
			Role__c = 'Owner'
		);
		List<String> result = new List<String>();
		system.runAs(user) {
			PageReference pageRef = Page.FarmCSVExport;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id',farm.Id);
			FarmCSVExportController controller = new FarmCSVExportController();

			Test.startTest();
				result = controller.getLands();
			Test.stopTest();
		}

		System.assertEquals(false, result.isEmpty(), 'The rows should have been returned correctly.');
	}

		@isTest static void getLandsAsCommunityUserOtherProducer_givenFarmId_shouldReturnRows() {
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'FPAC Customer Login'].Id;
		Account account = new Account(Name ='testCSVaccount');
		insert account;
		Contact contact = new Contact(
			LastName ='testCon',
			AccountId = account.Id,
			MailingCity = 'TestCity',
			MailingState = 'Ohio',
			MailingStreet = 'test',
			MailingPostalCode = '44111'
		);
		insert contact;
		User user = new User(
			alias = 'test123',
			email = 'test123@noemail.com',
			emailencodingkey = 'UTF-8',
			lastname = 'Testing',
			languagelocalekey = 'en_US',
			localesidkey = 'en_US',
			profileid = profileId,
			country = 'United States',
			IsActive = true,
			ContactId = contact.Id,
			timezonesidkey = 'America/Los_Angeles',
			username = 'tester@noemail.com'
		);
		insert user;
		Land__c farm = [SELECT Id FROM Land__c WHERE Name = 'Farm0' LIMIT 1];
		Land__c tract = [SELECT Id FROM Land__c WHERE Name = 'Tract0' LIMIT 1];
		insert new Authority__c(
			Associated_Land__c = farm.Id,
			Contact__c = contact.Id,
			Role__c = 'Other Producer'
		);
		insert new Authority__c(
			Associated_Land__c = tract.Id,
			Contact__c = contact.Id,
			Role__c = 'Other Producer'
		);
		List<String> result = new List<String>();
		system.runAs(user) {
			PageReference pageRef = Page.FarmCSVExport;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id',farm.Id);
			FarmCSVExportController controller = new FarmCSVExportController();

			Test.startTest();
				result = controller.getLands();
			Test.stopTest();
		}

		System.assertEquals(false, result.isEmpty(), 'The rows should have been returned correctly.');
	}
}
@isTest
private class LandSharingRecalculationTest {

	private static final Id FARM_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();

	@isTest static void testLandSharingRecalculation() {
		String contactId = insertContactAndUser();
		String landId = insertLand();
		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = landId,
			Contact__c = contactId
		);
		insert newAuthority;

		LandSharingRecalculation recalc = new LandSharingRecalculation();

		Test.startTest();
			String jobId = Database.executeBatch(recalc);
		Test.stopTest();

		AsyncApexJob aaj = [
			SELECT JobType, TotalJobItems, JobItemsProcessed, Status, CompletedDate, CreatedDate, NumberOfErrors
			FROM AsyncApexJob
			WHERE Id = :jobId
		];
		System.assertEquals(0, aaj.NumberOfErrors);

	}

	private static String insertContact() {
		Contact newContact = new Contact(
			LastName = 'Test',
			MailingCity = 'Test',
			MailingState = 'Ohio',
			MailingStreet = 'Test',
			MailingPostalCode = '44444'
		);
		insert newContact;
		return newContact.Id;
	}

	private static String insertContactAndUser() {

		String contactId = insertContact();

		Profile p = [SELECT Id FROM Profile WHERE Name='Community Login'];
		User u = new User(
			ContactId = contactId,
			Alias = 'standt',
			Email = 'standarduser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = 'standarduser@testorg.com'
		);
		insert u;

		return contactId;
	}
	private static String insertLand() {
		Land__c newFarm = new Land__c(
			RecordTypeId = FARM_RECORD_TYPE_ID
		);
		insert newFarm;
		return newFarm.Id;
	}

}
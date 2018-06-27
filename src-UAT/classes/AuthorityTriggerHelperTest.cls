@isTest
private class AuthorityTriggerHelperTest {

	private static final Id FARM_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();

	@isTest static void onInsert_ShouldCreateLandSharingRecord() {

		String landId = insertLand();
		String contactId = insertContactAndUser();

		Test.startTest();
			List<Authority__c> newAuthorities = new List<Authority__c>();
			Authority__c newAuthority1 = new Authority__c(
				Associated_Land__c = landId,
				Contact__c = contactId
			);
			newAuthorities.add(newAuthority1);
			Authority__c newAuthority2 = new Authority__c(
				Associated_Land__c = landId,
				Contact__c = contactId,
				Role__c = 'Owner'
			);
			newAuthorities.add(newAuthority2);
			Authority__c newAuthority3 = new Authority__c(
				Associated_Land__c = landId,
				Contact__c = contactId,
				Role__c = 'Operator'
			);
			newAuthorities.add(newAuthority3);
			Authority__c newAuthority4 = new Authority__c(
				Associated_Land__c = landId,
				Contact__c = contactId,
				Role__c = 'Other Producer'
			);
			newAuthorities.add(newAuthority4);
			insert newAuthorities;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		System.assertEquals(4, insertedAuthorities.size(), 'Four authority records should have been inserted');
		System.assertEquals(4, sharingRecords.size(), 'Four land__share records should have been inserted');
	}

	@isTest static void onInsert_givenNoUserForContact_ShouldCreateLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContact()
		);

		Test.startTest();
			insert newAuthority;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		System.assertEquals(1, insertedAuthorities.size(), 'One authority record should have been inserted');
		System.assertEquals(0, sharingRecords.size(), 'No land__share records should have been inserted');
	}

	@isTest static void onDelete_ShouldDeleteLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContactAndUser()
		);
		insert newAuthority;

		Test.startTest();
			delete newAuthority;
		Test.stopTest();

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		System.assertEquals(0, sharingRecords.size(), 'The land__share record should have been deleted.');
	}

	@isTest static void onDelete_givenNoContactForUser_ShouldDeleteLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContact()
		);
		insert newAuthority;

		Test.startTest();
			delete newAuthority;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		System.assertEquals(0, insertedAuthorities.size(), 'The authority record should have been deleted.');
	}

	@isTest static void onUpdate_givenChangedContactToContactWithoutUser_ShouldUpdateLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContactAndUser()
		);
		insert newAuthority;
		newAuthority.Contact__c = insertContact();

		Test.startTest();
			update newAuthority;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause, UserOrGroupId
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		System.assertEquals(1, insertedAuthorities.size(), 'One authority record should have been updated');
		System.assertEquals(0, sharingRecords.size(), 'No land__share records should be found because the new contact did not have a User record');
	}

	@isTest static void onUpdate_givenChangedContactToContactWithUser_ShouldUpdateLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContact()
		);
		insert newAuthority;
		String newContactId = insertContactAndUser();
		newAuthority.Contact__c = newContactId;

		Test.startTest();
			update newAuthority;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause, UserOrGroupId
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		String newUserId = [
			SELECT Id
			FROM User
			WHERE ContactId = :newContactId
			LIMIT 1
		].Id;

		System.assertEquals(1, insertedAuthorities.size(), 'One authority record should have been updated');
		System.assertEquals(1, sharingRecords.size(), 'One land__share records should be found.');
		System.assertEquals(newUserId, sharingRecords[0].UserOrGroupId, 'The land__share records should be for the new user.');
	}

	@isTest static void onUpdate_givenChangedLand_ShouldUpdateLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContactAndUser()
		);
		insert newAuthority;
		String newLandId = insertLand();
		newAuthority.Associated_Land__c = newLandId;

		Test.startTest();
			update newAuthority;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause, ParentId
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		System.assertEquals(1, insertedAuthorities.size(), 'One authority record should have been updated');
		System.assertEquals(1, sharingRecords.size(), 'One land__share records should be found.');
		System.assertEquals(newLandId, sharingRecords[0].ParentId, 'The land__share records should be for the new land.');
	}

	@isTest static void onUpdate_givenChangedRole_ShouldUpdateLandSharingRecord() {

		Authority__c newAuthority = new Authority__c(
			Associated_Land__c = insertLand(),
			Contact__c = insertContactAndUser()
		);
		insert newAuthority;

		Test.startTest();
			newAuthority.Role__c = 'Operator';
			update newAuthority;
			newAuthority.Role__c = 'Other Producer';
			update newAuthority;
			newAuthority.Role__c = 'Other Tenant';
			update newAuthority;
			newAuthority.Role__c = 'Owner';
			update newAuthority;
		Test.stopTest();

		List<Authority__c> insertedAuthorities = [
			SELECT Id
			FROM Authority__c
		];

		List<Land__Share> sharingRecords = [
			SELECT Id, RowCause, ParentId
			FROM Land__Share
			WHERE (
				RowCause = 'Owner__c'
				OR RowCause = 'Operator__c'
				OR RowCause = 'Other_Producer__c'
				OR RowCause = 'Other_Tenant__c'
			)
		];

		System.assertEquals(1, insertedAuthorities.size(), 'One authority record should have been updated');
		System.assertEquals(1, sharingRecords.size(), 'One land__share records should be found.');
		System.assertEquals('Owner__c', sharingRecords[0].RowCause, 'The land__share records should be for the new role.');
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

		Profile p = [SELECT Id FROM Profile WHERE Name='FPAC Customer'];
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
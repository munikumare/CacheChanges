@isTest
private class ARCGISMappingSidebarAuraServiceTest {

	private static final Integer FARMS_TO_INSERT = 1;
	private static final Integer TRACTS_TO_INSERT = 2;
	private static final Integer FIELDS_TO_INSERT = 2;
	private static final Id FARM_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();
	private static final Id TRACT_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();
	private static final Id FIELD_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();

	@testSetup static void insertTestRecords() {

		String newContactId = insertContact();
		List<Land__c> lands = new List<Land__c>();

		for(Integer i=0; i<FARMS_TO_INSERT; i++) {
			Land__c newFarm = new Land__c(
				Name = 'Farm' + i,
				RecordTypeId = FARM_RECORD_TYPE,
				Individual__c = newContactId
			);
			lands.add(newFarm);
		}
		insert lands;
		for(Integer i=0; i<TRACTS_TO_INSERT; i++) {
			Land__c newTract = new Land__c(
				Name = 'Tract' + i,
				RecordTypeId = TRACT_RECORD_TYPE,
				Parent_ID__c = lands[0].Id
			);
			lands.add(newTract);
		}
		upsert lands;
		for(Integer i=0; i<FIELDS_TO_INSERT; i++) {
			Land__c newField = new Land__c(
				Name = 'Field' + i,
				RecordTypeId = FIELD_RECORD_TYPE,
				Parent_ID__c = lands[FARMS_TO_INSERT].Id
			);
			lands.add(newField);
		}
		upsert lands;
	}

	@isTest static void getNumberOfPages_givenContactId_shouldReturn() {
		String contactId = [SELECT Id FROM Contact WHERE LastName = 'TestUser1234' LIMIT 1].Id;
		Test.startTest();
			Integer numPages = ARCGISMappingSidebarAuraService.getNumberOfPages(contactId);
		Test.stopTest();

		System.assertEquals(1, numPages);
	}

	@isTest static void getFarms_givenContactId_shouldReturnFarms() {
		String contactId = [SELECT Id FROM Contact WHERE LastName = 'TestUser1234' LIMIT 1].Id;
		Test.startTest();
			ARCGISMappingSidebarAuraService.getFarms(1, contactId);
		Test.stopTest();
	}

	@isTest static void getFarms_givenFarmId_shouldReturnLands() {
		String landId = [SELECT Id FROM Land__c WHERE NAme = 'Farm0' LIMIT 1].Id;
		Test.startTest();
			ARCGISMappingSidebarAuraService.getFarms(1, landId);
		Test.stopTest();
	}

	@isTest static void getFarms_givenTractId_shouldReturnLands() {
		String landId = [SELECT Id FROM Land__c WHERE NAme = 'Tract0' LIMIT 1].Id;
		Test.startTest();
			ARCGISMappingSidebarAuraService.getFarms(1, landId);
		Test.stopTest();
	}

	@isTest static void getFarms_givenFieldId_shouldReturnLands() {
		String landId = [SELECT Id FROM Land__c WHERE NAme = 'Field0' LIMIT 1].Id;
		Test.startTest();
			ARCGISMappingSidebarAuraService.getFarms(1, landId);
		Test.stopTest();
	}

	private static String insertContact() {
		Contact newContact = new Contact(
			LastName = 'TestUser1234',
			MailingCity = 'Test',
			MailingState = 'Ohio',
			MailingStreet = 'Test',
			MailingPostalCode = '44444'
		);
		insert newContact;
		return newContact.Id;
	}
}
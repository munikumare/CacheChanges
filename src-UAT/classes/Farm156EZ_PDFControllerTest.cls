@isTest
private class Farm156EZ_PDFControllerTest {

	private static final Integer FARMS_TO_INSERT = 1;
	private static final Integer TRACTS_TO_INSERT = 2;
	private static final Integer FIELDS_TO_INSERT = 2;
	private static final String AUTHORITY_OPERATOR_ROLE = 'Operator';
	private static final String USERNAME = 'standarduser@testorg.com';
	private static final Id FARM_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();
	private static final Id TRACT_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();
	private static final Id FIELD_RECORD_TYPE = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();

	@testSetup static void insertTestRecords() {
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

		String newContactId = insertContact();

		List<Land_View__c> landViews = new List<Land_View__c>();
		List<Authority__c> authorities = new List<Authority__c>();
		for (Land__c land : lands) {
			landViews.add(
				new Land_View__c(
					Land_ID__c = land.Id,
					Summary_User__c = newContactId
				)
			);
			authorities.add(
				new Authority__c(
					Associated_Land__c = land.Id,
					Role__c = AUTHORITY_OPERATOR_ROLE,
					Contact__c = newContactId
				)
			);
		}
		insert landViews;
		system.debug('landviews' + landViews);
		insert authorities;

		List<Base_Yield__c> crops = new List<Base_Yield__c>();
		Base_Yield__c crop1 = new Base_Yield__c(
			Name = 'crop1',
			Land__c = lands[0].Id
		);
		crops.add(crop1);
		Base_Yield__c crop2 = new Base_Yield__c(
			Name = 'crop2',
			Land__c = lands[FARMS_TO_INSERT].Id
		);
		crops.add(crop2);
		insert crops;

		List<Election_Hip__c> elections = new List<Election_Hip__c>();
		Election_Hip__c election = new Election_Hip__c(
			Name = 'test',
			Land__c = lands[0].Id,
			Election_Code__c = 'A'
		);
		elections.add(election);
		election = new Election_Hip__c(
			Name = 'test',
			Land__c = lands[0].Id,
			Election_Code__c = 'B'
		);
		elections.add(election);
		election = new Election_Hip__c(
			Name = 'test',
			Land__c = lands[0].Id,
			Election_Code__c = 'C'
		);
		elections.add(election);
		election = new Election_Hip__c(
			Name = 'test',
			Land__c = lands[0].Id,
			Election_Code__c = 'E'
		);
		elections.add(election);
		insert elections;
	}

	@isTest static void setUrlFarmId_givenFarmId_shouldInit() {

		String farmViewId = [SELECT Id FROM Land_View__c WHERE Land_ID__r.Name = 'Farm0' LIMIT 1].Id;
		Farm156EZ_PDFController controller = new Farm156EZ_PDFController();

		Test.startTest();
		controller.setUrlFarmId(farmViewId);
		Test.stopTest();

		System.assertNotEquals(null, controller.farm);
		System.assertNotEquals(null, controller.tracts);
		System.assertNotEquals(null, controller.fields);
		System.assertNotEquals(null, controller.crops);
		System.assertNotEquals(null, controller.farmCrops);
		System.assertEquals(System.now().format('M/d/yy h:m a'), controller.getDateTime());
		System.assertEquals(System.now().format('yyyy'), controller.getYear());
		System.assertEquals(controller.tracts.size(), controller.getTractsSize());
		System.assertEquals(controller.urlFarmId, controller.getUrlFarmId());
		System.assertEquals(null, controller.FarmsAssociatedWith);
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

}
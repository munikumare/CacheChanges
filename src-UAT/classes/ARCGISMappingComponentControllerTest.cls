@isTest
private class ARCGISMappingComponentControllerTest {

	private static final Integer FARMS_TO_INSERT = 14;
	private static final Integer TRACTS_TO_INSERT = 3;
	private static final Integer FIELDS_TO_INSERT = 1;
	private static final Id FARM_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();
	private static final Id TRACT_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();
	private static final Id FIELD_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();

	@isTest static void testFarmMappingLand() {
		Land__c land = [Select Id From Land__c WHERE RecordTypeId =: FARM_RECORD_TYPE_ID LIMIT 1];
		Mapping_Webservices__c web = [Select Id From Mapping_Webservices__c LIMIT 1];
		PageReference pageRef = Page.FarmMapping;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('Id', land.Id);
		ARCGISMappingController mappingController = new ARCGISMappingController();
		ARCGISMappingComponentController mappingComponentController = new ARCGISMappingComponentController();
		ARCGISMappingComponentController.toolbarCSSClass = null;
		ARCGISMappingComponentController.layersCSSClass = null;
		ARCGISMappingComponentController.showToolbar = true;
		ARCGISMappingComponentController.setCSSClasses('toolbar');
		ARCGISMappingComponentController.showLayers = true;
		ARCGISMappingComponentController.setCSSClasses('layer');
		ARCGISMappingComponentController.IsContact = false;
		ARCGISMappingComponentController.LandId = land.Id;
		ARCGISMappingComponentController.getLand();
		System.assertEquals(ARCGISMappingComponentController.Land.Id, land.Id);
		ARCGISMappingComponentController.webservices = null;
		ARCGISMappingComponentController.setWebservices();
		ARCGISMappingComponentController.toolbarCSSClass = null;
		ARCGISMappingComponentController.layersCSSClass = null;
		ARCGISMappingComponentController.showToolbar = false;
		ARCGISMappingComponentController.setCSSClasses('toolbar');
		ARCGISMappingComponentController.showLayers = false;
		ARCGISMappingComponentController.setCSSClasses('layer');
	}

	@isTest static void testFarmMappingContact() {
		Contact contact = [Select Id From Contact WHERE LastName = 'testLastName'
			LIMIT 1
		];
		PageReference pageRef = Page.FarmMapping;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('Id', contact.Id);
		ARCGISMappingController mappingController = new ARCGISMappingController();
		ARCGISMappingComponentController mappingComponentController = new ARCGISMappingComponentController();
		ARCGISMappingComponentController.ContactId = contact.Id;
		ARCGISMappingComponentController.IsContact = true;
		System.assertEquals(ARCGISMappingComponentController.Land, new Land__c());
	}

	@isTest static void testSoilsLayer() {
		Land__c land = [Select Id From Land__c WHERE RecordTypeId =: FARM_RECORD_TYPE_ID LIMIT 1];
		Mapping_Webservices__c web = [Select Id, Soil_XML_Webservice_Address__c From Mapping_Webservices__c LIMIT 1];
		PageReference pageRef = Page.FarmMapping;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('Id', land.Id);
		ARCGISMappingController mappingController = new ARCGISMappingController();
		Test.startTest();
			String aoiId;
			Test.setMock(HttpCalloutMock.class, new GetAOIMock());
			aoiId = ARCGISMappingComponentController.getAOIId('polygon((-102.665845 38.175251,-102.665845 38.198565,-102.632914 38.198565,-102.632914 38.175251,-102.665845 38.175251))');
			Test.setMock(HttpCalloutMock.class, new GetInterpresultidMock());
			String interpresultId = ARCGISMappingComponentController.getInterpresultid('polygon((-102.665845 38.175251,-102.665845 38.198565,-102.632914 38.198565,-102.632914 38.175251,-102.665845 38.175251))');
			Test.setMock(HttpCalloutMock.class, new GetColorData());
			ARCGISMappingComponentController.getColorData(web.Soil_XML_Webservice_Address__c, interpresultId);
		Test.stopTest();
	}

	@isTest static void testGetCLUData() {
		Land__c land = [Select Id, Farm_Number__c, Tract_Number__c From Land__c WHERE RecordTypeId =: FARM_RECORD_TYPE_ID LIMIT 1];
		Contact contact = [SELECT Id FROM Contact WHERE LastName = 'testLastName' LIMIT 1];
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, new FPAC_GISClientCLUMock());
			Continuation con1 = (Continuation)ARCGISMappingComponentController.getCLUData(land.Farm_Number__c, land.Tract_Number__c, '');
			Continuation con2 = (Continuation)ARCGISMappingComponentController.getCLUData(land.Farm_Number__c, land.Tract_Number__c, contact.Id);
			Continuation con3 = (Continuation)ARCGISMappingComponentController.getCLUData(land.Farm_Number__c, '', contact.Id);
			//Object stringCon=ARCGISMappingComponentController.processResponse('state');
			//system.debug(stringCon);
			//System.assertEquals(stringCon.toString(), FPAC_GISClientCLUMock.body);
		Test.stopTest();
	}

	@isTest static void testGetBoundaryTractData() {
		Land__c land = [Select Id, Farm_Number__c, Tract_Number__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s From Land__c WHERE RecordTypeId =: FARM_RECORD_TYPE_ID LIMIT 1];
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, new FPAC_GISClientBoundaryMock());
			Continuation con = (Continuation)ARCGISMappingComponentController.getBoundaryInformation(land.Farm_Number__c, land.Tract_Number__c);
			//Object stringCon=ARCGISMappingComponentController.processResponse('state');
			//System.assertEquals(stringCon.toString(), FPAC_GISClientBoundaryMock.body);
		Test.stopTest();
	}

	@isTest static void testGetWetlandsInformation() {
		Land__c land = [Select Id, Farm_Number__c, Tract_Number__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s From Land__c WHERE RecordTypeId =: FARM_RECORD_TYPE_ID LIMIT 1];
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, new FPAC_GISClientBoundaryMock());
			Continuation con = (Continuation)ARCGISMappingComponentController.getWetlandsInformation(land.Farm_Number__c);
			//Object stringCon=ARCGISMappingComponentController.processResponse('state');
			//System.assertEquals(stringCon.toString(), FPAC_GISClientBoundaryMock.body);
		Test.stopTest();
	}

	@isTest static void testUpdateLatLong() {
		Land__c land = [Select Id, Farm_Number__c, Tract_Number__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s From Land__c WHERE RecordTypeId =: FARM_RECORD_TYPE_ID LIMIT 1];
		Test.startTest();
			ARCGISMappingComponentController.setLatLong(land.Id, 41.405139, -81.664174);
			land = [Select Id, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s From Land__c WHERE Id =: land.Id];
			System.assertEquals(land.Latitude_Longitude__latitude__s, 41.405139);
			System.assertEquals(land.Latitude_Longitude__longitude__s, -81.664174);
		Test.stopTest();
	}

	@isTest static void testGetAllFarms() {
		Contact contact = [SELECT Id FROM Contact WHERE LastName = 'testLastName' LIMIT 1];
		Test.startTest();
			List<Land__c> result = ARCGISMappingComponentController.getAllFarms(contact.Id);
			System.assertNotEquals(null, result);
		Test.stopTest();
	}

	@isTest static void testgetFieldRecordId() {
		Test.startTest();
		Contact individual = new Contact();
		individual.LastName = 'testLastName';
		individual.FirstName = 'test';
		individual.FSA_BTO_Core_Customer_ID__c = '555555';

		individual.MailingStreet = '1660 Greensboro Dr.';
		individual.MailingCity = 'McLean';
		individual.MailingStateCode = 'VA';
		individual.MailingPostalCode = '22180';
		insert individual;


			Land__c newFarm = new Land__c(
					RecordTypeId = FARM_RECORD_TYPE_ID,
					Latitude_Longitude__latitude__s = 41.402817,
					Latitude_Longitude__longitude__s = -81.663356,
					Admin_State_Code__c='165',
					Admin_County_Code__c='29',
					Farm_Number__c = '0003340',
					Tract_Number__c = '7638'
			);
			insert newFarm;


			Land__c newTract = new Land__c(
					RecordTypeId = TRACT_RECORD_TYPE_ID,
					Parent_ID__c = newFarm.Id,
					Latitude_Longitude__latitude__s = 41.402817,
					Latitude_Longitude__longitude__s = -81.663356,
					Admin_State_Code__c='165',
					Admin_County_Code__c='29',
					Farm_Number__c = '0003340',
					Tract_Number__c = '7638'
			);

		insert  newTract;


			Land__c newField = new Land__c(
					RecordTypeId = FIELD_RECORD_TYPE_ID,
					Parent_ID__c = newTract.Id,
					Latitude_Longitude__latitude__s = 41.402817,
					Latitude_Longitude__longitude__s = -81.663356,
					Admin_State_Code__c='555',
					Admin_County_Code__c='55',
					Farm_Number__c = '55555555',
					Tract_Number__c = '555',
					Field_Number__c='55555555',
                	CLU_Alternative_Identifier__c='12345678-1234-1234-1234-123456789abc'
			);
			insert newField;

			Id landRecordId = ARCGISMappingComponentController.getFieldRecordId('12345678-1234-1234-1234-123456789abc');
			System.assertEquals(newField.Id, landRecordId);
			Test.stopTest();
		}


	@testSetup static void setupTestData() {
		Contact individual = new Contact();
		individual.LastName = 'testLastName';
		individual.FirstName = 'test';
		individual.FSA_BTO_Core_Customer_ID__c = '9748672';

		individual.MailingStreet = '1660 Greensboro Dr.';
		individual.MailingCity = 'McLean';
		individual.MailingStateCode = 'VA';
		individual.MailingPostalCode = '22180';
		insert individual;

		List < Land__c > lands = new List < Land__c > ();
		for (Integer i = 0; i < FARMS_TO_INSERT; i++) {
			Land__c newFarm = new Land__c(
				RecordTypeId = FARM_RECORD_TYPE_ID,
				Latitude_Longitude__latitude__s = 41.402817,
				Latitude_Longitude__longitude__s = -81.663356,
				Admin_State_Code__c='165',
				Admin_County_Code__c='29',
				Farm_Number__c = '0003340',
				Tract_Number__c = '7638'
			);
			lands.add(newFarm);
		}
		insert lands;
		for (Integer i = 0; i < TRACTS_TO_INSERT; i++) {
			Land__c newTract = new Land__c(
				RecordTypeId = TRACT_RECORD_TYPE_ID,
				Parent_ID__c = lands[0].Id,
				Latitude_Longitude__latitude__s = 41.402817,
				Latitude_Longitude__longitude__s = -81.663356,
				Admin_State_Code__c='165',
				Admin_County_Code__c='29',
				Farm_Number__c = '0003340',
				Tract_Number__c = '7638'
			);
			lands.add(newTract);
		}
		upsert lands;
		for (Integer i = 0; i < FIELDS_TO_INSERT; i++) {
			Land__c newField = new Land__c(
				RecordTypeId = FIELD_RECORD_TYPE_ID,
				Parent_ID__c = lands[FARMS_TO_INSERT].Id,
				Latitude_Longitude__latitude__s = 41.402817,
				Latitude_Longitude__longitude__s = -81.663356,
				Admin_State_Code__c='165',
				Admin_County_Code__c='29',
				Farm_Number__c = '0003340',
				Tract_Number__c = '7638',
				Field_Number__c='0000001'

			);
			lands.add(newField);
		}
		upsert lands;

		Mapping_Webservices__c web = new Mapping_Webservices__c();
		web.Congressional_Webservice_Address__c = 'http://ww.google.com';
		web.Tabular_Post_Rest__c = 'https://sdmdataaccess.sc.egov.usda.gov/Tabular/post.rest';
		web.Short_Form_Data__c = '{"ComponentPercentCutoff":"","aoiid":"[AOIID]","ruleid":"471","AggregationMethod":"Dominant Component","TiebreakRule":"-1"}';
		web.Soil_XML_Webservice_Address__c = 'https://sdmdataaccess.sc.egov.usda.gov/Tabular/SDMTabularService.asmx';
		insert web;
	}
}
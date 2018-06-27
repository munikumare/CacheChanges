@isTest
private class FarmGeoJSONExportControllerTest {
	
	@isTest static void getGeoJSON_givenFarm_shouldSetGeoJSON() {
		Land__c farm = new Land__c();
		farm.Farm_Number__c = '1234';
		farm.Hel_Code__c = 'A';

		insert farm;

		ApexPages.StandardController controller = new ApexPages.StandardController(farm);

		Test.startTest();
			FarmGeoJSONExportController exportController = new FarmGeoJSONExportController(controller);
			String jsonString = exportController.GeoJSON;
		Test.stopTest();

		System.assertEquals(true, jsonString.contains(farm.Farm_Number__c));
		System.assertEquals(true, jsonString.contains(farm.Hel_Code__c));
	}

}
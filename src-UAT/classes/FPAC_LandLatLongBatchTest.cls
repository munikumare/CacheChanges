@isTest
private class FPAC_LandLatLongBatchTest {

	private static final Integer FARMS_TO_INSERT = 1;
	private static final Id FARM_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();
	
	@isTest static void FPAC_LandLatLongBatchTestTract() {
		Test.setMock(HttpCalloutMock.class, new FPAC_GISClientBoundaryMock());
		Test.startTest();
		FPAC_Settings__c fpac=[Select Id, Run_Batch__c From FPAC_Settings__c LIMIT 1];
		fpac.Run_Batch__c=false;
		update fpac;
        FPAC_LandLatLongBatch landBatch= new FPAC_LandLatLongBatch();
        Database.executeBatch(landBatch,1);
		Test.stopTest();
	}

	@isTest static void FPAC_LandLatLongBatchTestNoTract() {
		Land__c land=[Select Id, Tract_Number__c, Calculate_LatLong__c From Land__c LIMIT 1];
		land.Tract_Number__c='';
		land.Calculate_LatLong__c=true;
		update land;
		FPAC_Settings__c fpac=[Select Id, Run_Batch__c From FPAC_Settings__c LIMIT 1];
		fpac.Run_Batch__c=false;
		update fpac;
		Test.setMock(HttpCalloutMock.class, new FPAC_GISClientBoundaryMock());
		Test.startTest();
        FPAC_LandLatLongBatch landBatch= new FPAC_LandLatLongBatch();
        Database.executeBatch(landBatch,1);
		Test.stopTest();
	}	

	@testSetup static void setupTestData() {
		List < Land__c > lands = new List < Land__c > ();
		for (Integer i = 0; i < FARMS_TO_INSERT; i++) {
			Land__c newFarm = new Land__c(
				RecordTypeId = FARM_RECORD_TYPE_ID,
				Latitude_Longitude__latitude__s = 41.402817,
				Latitude_Longitude__longitude__s = -81.663356,
				Admin_State_Code__c='165',
				Admin_County_Code__c='29',
				Farm_Number__c = '0003340',
				Tract_Number__c = '7638',
				Calculate_LatLong__c=true
			);
			lands.add(newFarm);
		}
		insert lands;

		FPAC_Settings__c fpacSettings = new FPAC_Settings__c();
		fpacSettings.Run_Batch__c=true;
		insert fpacSettings;
	}
}
@isTest
private class LandTriggerTest {
	
	@isTest static void setupLandDataForAggregation_givenTracts_shouldUpdateFarm() {

		LandDataAccessorMock accessorMock = new LandDataAccessorMock();
		LandTriggerFacade landFacade = new LandTriggerFacade(accessorMock);

		String tractRecordTypeId = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();
		String landPrefix = Land__c.SObjectType.getDescribe().getKeyPrefix();

		Land__c tractOne = new Land__c();
		tractOne.Parent_ID__c = landPrefix + '100000001111111';
		tractOne.Farmland_Acres__c = 10;
		tractOne.RecordTypeId = tractRecordTypeId;

		Test.startTest();
			landFacade.setupLandDataForAggregation(new List<Land__c>{tractOne});
		Test.stopTest();

		System.assertEquals(15, accessorMock.updatedLands[0].Farmland_Acres__c);
	}

	public class LandDataAccessorMock implements LandDAO {

		public List<Land__c> updatedLands;

		public Map<String, List<Land__c>> getTractsByParentFarm(Set<String> farmIds) {
			Map<String, List<Land__c>> tractToFarmMap = new Map<String, List<Land__c>>();
			String tractRecordTypeId = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();
			String landPrefix = Land__c.SObjectType.getDescribe().getKeyPrefix();

			Land__c tractOne = new Land__c();
			tractOne.Parent_ID__c = landPrefix + '100000001111111';
			tractOne.RecordTypeId = tractRecordTypeId;
			tractOne.Farmland_Acres__c = 10;
			tractOne.CRP_Contract_Number__c = '';
			tractOne.Cropland_Acres__c = 0;
			tractOne.DCP_Cropland_Acres__c = 0;
			tractOne.DCP_Effective_Cropland_Acres__c = 0;
			tractOne.DCP_Double_Crop_Acres__c = 0;
			tractOne.WBP_Acres__c = 0;
			tractOne.WRP_Acres__c = 0;
			tractOne.MPL_Acres__c = '';
			tractOne.CRP_Acres__c = 0;
			tractOne.Grp_Acres__c = 0;
			tractOne.State_Conserve_Acres__c = 0;
			tractOne.Other_Conserve_Acres__c = 0;
			tractOne.Sugarcane_Acres__c = 0;

			Land__c tractTwo = new Land__c();
			tractTwo.Parent_ID__c = landPrefix + '100000001111111';
			tractTwo.RecordTypeId = tractRecordTypeId;
			tractTwo.Farmland_Acres__c = 5;
			tractTwo.CRP_Contract_Number__c = '';
			tractTwo.Cropland_Acres__c = 0;
			tractTwo.DCP_Cropland_Acres__c = 0;
			tractTwo.DCP_Effective_Cropland_Acres__c = 0;
			tractTwo.DCP_Double_Crop_Acres__c = 0;
			tractTwo.WBP_Acres__c = 0;
			tractTwo.WRP_Acres__c = 0;
			tractTwo.MPL_Acres__c = '';
			tractTwo.CRP_Acres__c = 0;
			tractTwo.Grp_Acres__c = 0;
			tractTwo.State_Conserve_Acres__c = 0;
			tractTwo.Other_Conserve_Acres__c = 0;
			tractTwo.Sugarcane_Acres__c = 0;

			tractToFarmMap.put(landPrefix + '100000001111111', new List<Land__c>{tractOne, tractTwo});

			return tractToFarmMap;
		}

		public List<Land__c> getFarms(Set<String> farmIds) {
			String landPrefix = Land__c.SObjectType.getDescribe().getKeyPrefix();

			Land__c farmOne = new Land__c();
			farmOne.Id = landPrefix + '100000001111111';

			return new List<Land__c>{farmOne};
		}

		public void updateLands(List<Land__c> lands) {
			this.updatedLands = lands;
		}

	}

}
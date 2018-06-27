public with sharing class ElectionHipDA {
	public static List<Election_Hip__c> getElectionHips(String farmId) {
		return [
			SELECT
				Id,
				Abbreviation__c,
				ARC_CO_Crop_Name__c,
				ARC_IC_Crop_Name__c,
				Code__c,
				CreatedById,
				Election_Code__c,
				Name,
				Hip_Code__c,
				Land__c,
				LastModifiedById,
				Name__c,
				PLC_Crop_Name__c,
				PLC_Default_Crop_Name__c,
				Type__c,
				Type_Code__c,
				Type_Name__c
			FROM Election_Hip__c
			WHERE Land__c = :farmId
		];
	}
	public static List<Election_Hip__c> getElectionHipsByFarmId(Id farmId){
		return [
				SELECT Id, Election_Code__c, Abbreviation__c
				FROM Election_Hip__c
				WHERE Land__c =:farmId
				ORDER BY Abbreviation__c ASC
		];
	}
}
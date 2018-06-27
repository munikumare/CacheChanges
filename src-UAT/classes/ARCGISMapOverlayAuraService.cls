public with sharing class ARCGISMapOverlayAuraService {
	@auraEnabled
	public static Land__c getGeolocation(Id recordId){
		return [
				SELECT Id, Latitude_Longitude__Latitude__s,Latitude_Longitude__Longitude__s
				FROM Land__c
				WHERE Id=:recordId
		];
	}
}
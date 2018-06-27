@isTest
public with sharing class LandDAWithoutSharingMock implements LandDAWOSI {
	public Map<Id, Land__c> landsByIds = new Map<Id, Land__c>();
	public Set<Id> getAllTractsIdsByFarmId(Id farmId){
		return landsByIds.keySet();
	}
	public Set<Id> getAllFieldsIdsByFarmId(Id farmId){
		return landsByIds.keySet();
	}
	public Set<Id> getAllFieldsIdsByTractId(Id farmId){
		return landsByIds.keySet();
	}
	public List<Land__c> getNavigationalTracts(Id farmId, Set<Id> authorizedTractIds){
		return landsByIds.values();
	}
	public Land__c getLandById(Id landId){
		return landsByIds.values()[0];
	}
	public 	List<Land__c> getLandViewFarmsByIds(Set<Id> farmIds, String sortedBy, String sortedDirection, Integer totalRecords){
		return landsByIds.values();
	}
}
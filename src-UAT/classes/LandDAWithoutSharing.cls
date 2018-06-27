public without sharing class LandDAWithoutSharing implements LandDAWOSI{
	public Set<Id> getAllTractsIdsByFarmId(Id farmId){
		Map<Id, Land__c> tractsByIds = new Map<Id, Land__c>([
			SELECT Id
			FROM Land__c
			WHERE Parent_ID__c =:farmId
		]);
		return tractsByIds.keySet();
	}
	public Set<Id> getAllFieldsIdsByFarmId(Id farmId){
		Map<Id, Land__c> fieldsByIds = new Map<Id, Land__c>([
			SELECT Id
			FROM Land__c
			WHERE Parent_ID__r.Parent_ID__c =:farmId
		]);
		return fieldsByIds.keySet();
	}
	public Set<Id> getAllFieldsIdsByTractId(Id farmId){
		Map<Id, Land__c> fieldsByIds = new Map<Id, Land__c>([
				SELECT Id
				FROM Land__c
				WHERE Parent_ID__c =:farmId
		]);
		return fieldsByIds.keySet();
	}
	public List<Land__c> getNavigationalTracts(Id farmId, Set<Id> authorizedTractIds){
		return [
			SELECT Id,Name,Tract_Number__c,Description__c,
			(SELECT Id FROM Lands__r)
			FROM Land__c
			WHERE Id IN:authorizedTractIds
			AND Parent_ID__c=:farmId
		];
	}
	public Land__c getLandById(Id landId){
		return[
			SELECT Id, Admin_County_Code__c, Admin_State_Code__c,FarmOperator__c,
					Parent_ID__r.Admin_County_Code__c, Parent_ID__r.Admin_State_Code__c,Parent_ID__r.FarmOperator__c,
					Parent_ID__r.Parent_ID__r.Admin_County_Code__c, Parent_ID__r.Parent_ID__r.Admin_State_Code__c,Parent_ID__r.Parent_ID__r.FarmOperator__c
			FROM Land__c
			WHERE Id=:landId
		];
	}
	public List<Land__c> getLandViewFarmsByIds(Set<Id> farmIds, Integer totalRecords){
		String queryString = '' +
			'SELECT Id, Farm_Number__c, Admin_County_Code__c, Admin_State_Code__c, Cropland_Acres__c, FarmOperator__c ' +
			'FROM Land__c ' +
			'WHERE Id IN:farmIds ' +
			'ORDER BY Admin_State_Code__c NULLS LAST, Admin_County_Code__c NULLS LAST, Farm_Number__c NULLS LAST ' +
			'LIMIT ' + totalRecords;
		return database.query(queryString);
	}

	public List<Land__c> getLandViewFarmsByIdsSort(Set<Id> farmIds, String sortedBy, String sortedDirection, Integer totalRecords){
		String queryString = '' +
			'SELECT Id, Farm_Number__c, Admin_County_Code__c, Admin_State_Code__c, Cropland_Acres__c, FarmOperator__c ' +
			'FROM Land__c ' +
			'WHERE Id IN:farmIds ' +
			'ORDER BY ' + String.escapeSingleQuotes(sortedBy) + ' ' + String.escapeSingleQuotes(sortedDirection) + ' NULLS LAST ' +
			'LIMIT ' + totalRecords;
		return database.query(queryString);
	}
}
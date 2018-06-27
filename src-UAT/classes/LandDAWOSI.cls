public interface LandDAWOSI {
	Set<Id> getAllTractsIdsByFarmId(Id farmId);
	Set<Id> getAllFieldsIdsByFarmId(Id farmId);
	Set<Id> getAllFieldsIdsByTractId(Id farmId);
	List<Land__c> getNavigationalTracts(Id farmId, Set<Id> authorizedTractIds);
	Land__c getLandById(Id landId);
	List<Land__c> getLandViewFarmsByIds(Set<Id> farmIds, Integer totalRecords);
	List<Land__c> getLandViewFarmsByIdsSort(Set<Id> farmIds, String sortedBy, String sortedDirection, Integer totalRecords);
}
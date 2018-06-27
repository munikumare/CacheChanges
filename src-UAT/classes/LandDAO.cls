public interface LandDAO {

	Map<String, List<Land__c>> getTractsByParentFarm(Set<String> farmIds);

	List<Land__c> getFarms(Set<String> farmIds);
	
	void updateLands(List<Land__c> lands);

}
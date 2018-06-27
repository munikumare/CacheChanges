public interface PayGroupDAO {
	
	List<WHIPPayGroup__c> getPayGroupsFromKeyAndApplicationId(List<String> keys, List<String> applicationIds);
	Map<Id, WHIPNoticeofLoss__c> getNoticeOfLossMap(Set<String> noticeOfLossIds);
	List<WHIPLossInformation__c> getLossInformationsToRollUp(Set<Id> payGroupIds);
	Map<Id, WHIPPayGroup__c> getPayGroupsToUpdate(Set<Id> payGroupsToUpdate);
	void saveLossInformation(List<WHIPLossInformation__c> lossesToUpdate);
	void savePayGroups(List<WHIPPayGroup__c> payGroupsToSave);

}
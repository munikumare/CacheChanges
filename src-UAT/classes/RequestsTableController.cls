public with sharing class RequestsTableController {
	@AuraEnabled
	public static Requests getAllRequests() {
		Requests allRequests = new Requests();
		allRequests.assistanceRequests = getAssistanceRequests();
		allRequests.modificationRequests = getModificationRequests();
		return allRequests;
	}
	@AuraEnabled
	public static void deleteRequest(Id requestId) {
		sObject sObj;
		sObj= requestId.getSObjectType().newSObject();
		sObj.Id = requestId;
		delete sObj;
	}
	private static List<Conservation_Request__c> getAssistanceRequests() {
		return [
			SELECT Id, Name, RecordType.Name, CreatedDate
			FROM Conservation_Request__c
		];
	}
	private static List<Conservation_Modification__c> getModificationRequests() {
		return [
			SELECT Id, Name, Type__c, CreatedDate, Status__c
			FROM Conservation_Modification__c
		];
	}
	public class Requests{
		@auraEnabled
		public List<Conservation_Request__c> assistanceRequests = new List<Conservation_Request__c>();
		@auraEnabled
		public List<Conservation_Modification__c> modificationRequests = new List<Conservation_Modification__c>();
	}
}
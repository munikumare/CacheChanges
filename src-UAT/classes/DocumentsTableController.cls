public with sharing class DocumentsTableController {
	@AuraEnabled
	public static List<ContentVersion> getDocuments(Id linkedEntityId) {
		return [SELECT Id, Title, FileType, Description FROM ContentVersion];
	}
	@AuraEnabled
	public static void deleteDocument(Id documentId) {
		ContentVersion conVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :documentId];
		ContentDocument conDocument = [SELECT Id FROM ContentDocument WHERE Id = :conVersion.ContentDocumentId];
		delete conDocument;
	}
}
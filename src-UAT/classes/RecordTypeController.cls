public with sharing class RecordTypeController {

	@AuraEnabled
	public static Id getRecordTypeId(String objectName, String recordTypeName) {
		return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
	}
}
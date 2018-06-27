public with sharing class FACommunicationMethodController {
	@AuraEnabled
	public static Id getCurrentUserId() {
		return UserInfo.getUserId();
	}
}
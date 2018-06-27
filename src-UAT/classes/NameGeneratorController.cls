public with sharing class NameGeneratorController {
	@auraEnabled
	public static User getCurrentUser(){
		return [select Id,FirstName, LastName from User where id =: userInfo.getUserId()];
	}
}
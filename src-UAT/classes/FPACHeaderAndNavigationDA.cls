public with sharing class FPACHeaderAndNavigationDA implements FPACHeaderAndNavigationDAI {
	public List<Object> queryUserInformation() {
		List<Object> itemList = new List<Object>();
		User thisUser = [SELECT Id, Name, AccountId, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		List<Contact> userContacts = [SELECT Id, Preferred_Name__c FROM Contact WHERE Id = :thisUser.ContactId];
		if(userContacts.size() !=0 && !String.isEmpty(userContacts[0].Preferred_Name__c)) {
			itemList.add(userContacts[0].Preferred_Name__c);
		}
		else {
			itemList.add(thisUser.Name);
		}
		itemList.add(thisUser);
		return itemList;
	}
}
public with sharing class FPAC_NavigationBarDA implements FPAC_NavigationBarDAI {
	
	public List<Object>  queryNavigationBarMetadata() {
		List<Object> navBarItems = new List<Object>();
		List<FPAC_NavigationBarIcon__mdt> navItems = [SELECT Diplay_Position__c, Menu_Label__c, ParentId__c,
					   										 Menu_Link__c, StaticResourceImageURL__c, IsDropdown__c
			    									  FROM   FPAC_NavigationBarIcon__mdt
			    									  WHERE  ParentId__c = NULL
			    									  ORDER BY Diplay_Position__c];
		User thisUser = [SELECT Id, Name, AccountId, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		navBarItems.add(navItems);
		navBarItems.add(Url.getSalesforceBaseUrl().toExternalForm());
		navBarItems.add(thisUser);
		return navBarItems;
	}

	public List<FPAC_NavigationBarIcon__mdt> queryNavigationBarDropdownData(String parentName) {
		return [SELECT Diplay_Position__c, ParentId__c,
					   Menu_Label__c, Menu_Link__c
				FROM   FPAC_NavigationBarIcon__mdt
				WHERE  ParentId__c = :parentName
				ORDER BY Diplay_Position__c
				];
	}
}
public with sharing class BannerButtonContainerDA implements BannerButtonContainerDAI{
	
	public List<Object> queryBannerComponentDetails() {
		List<Object> bannerComponentDetails = new List<Object> ();
		List<BannnerButtonDetail__mdt> bannerButtonsDetail = [SELECT ButtonLabel__c, ButtonLink__c,
															  		ButtonText__c, StaticResourceImageURL__c,
															  		Showable__c, Display_Position__c 
													   		 FROM	BannnerButtonDetail__mdt
													   		 WHERE  Showable__c = true
													   		 ORDER BY Display_Position__c];

		BannerButtonContainer__mdt bannerButtonContainerDetails = [SELECT BackgroundImageStaticRescourceName__c,
																 		  NumberOfButtons__c
																   FROM	  BannerButtonContainer__mdt
																  ];
		User thisUser = [SELECT Id, Name, AccountId, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		List<Contact> userContacts = [SELECT Id, Preferred_Name__c FROM Contact WHERE Id = :thisUser.ContactId];

		bannerComponentDetails.add(bannerButtonsDetail);
		bannerComponentDetails.add(bannerButtonContainerDetails);
		if(userContacts.size() != 0 && !String.isEmpty(userContacts[0].Preferred_Name__c)) {
			bannerComponentDetails.add(userContacts[0].Preferred_Name__c);
		}
		else {
			bannerComponentDetails.add(thisUser.Name);
		}
		bannerComponentDetails.add(Url.getSalesforceBaseUrl().toExternalForm());
		bannerComponentDetails.add(thisUser);
		return bannerComponentDetails;
	}

}
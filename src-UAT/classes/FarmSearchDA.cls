public with sharing class FarmSearchDA implements FarmSearchDAI {
	public List<Object> queryStateAndCountyMetadata() {
		List<Object> stateAndCountyMetadata = new List<Object> ();
		List<FIPS_County_Code__mdt> userCountyMetadata = new List<FIPS_County_Code__mdt> ();
		List<FIPS_County_Code__mdt> countiesForUserState = new List<FIPS_County_Code__mdt> ();
		
		List<User> users = getCurrentUserFipsCode();

		String countyCode = users[0].FSA_BTO_FIPS_Code__c;
		if(!String.isEmpty(countyCode)) {
			userCountyMetadata = getUserCountyMetadata(countyCode);
		}

		if(userCountyMetadata.size() != 0) {											 
			String userState = userCountyMetadata[0].FIPS_State_Code__c;
			countiesForUserState = getCountiesForUserState(userState);
		}

		List<FIPS_State_Code__mdt> statesMetadata = getStatesMetadata();
	
		stateAndCountyMetadata.add(userCountyMetadata);
		stateAndCountyMetadata.add(statesMetadata);
		stateAndCountyMetadata.add(countiesForUserState);

		return stateAndCountyMetadata;
	}

	public List<FIPS_County_Code__mdt> queryCountyMetadataForSelectedState(String stateCode) {
		return [SELECT FIPS_County_Code__c, FIPS_State_Code__r.MasterLabel,
					   MasterLabel, DeveloperName
				FROM   FIPS_County_Code__mdt
				WHERE  FIPS_County_Code__c 
				LIKE :stateCode + '%'
				ORDER BY MasterLabel];
	}

	private List<FIPS_County_Code__mdt> getUserCountyMetadata(String countyCode) {
		return [SELECT FIPS_County_Code__c, FIPS_State_Code__r.MasterLabel,
					   MasterLabel, DeveloperName
				FROM   FIPS_County_Code__mdt
				WHERE  FIPS_County_Code__c = :countyCode
				ORDER BY MasterLabel];
	}

	private List<FIPS_County_Code__mdt> getCountiesForUserState(String userState) {
		return [SELECT FIPS_County_Code__c, FIPS_State_Code__c,
					   MasterLabel, DeveloperName
				FROM   FIPS_County_Code__mdt
				WHERE  FIPS_State_Code__c = :userState
				ORDER BY MasterLabel];
	}

	private List<User> getCurrentUserFipsCode() {
		return [SELECT Id, FSA_BTO_FIPS_Code__c
		 		FROM   User
		 	    WHERE  Id = :UserInfo.getUserId()];
	}

	private List<FIPS_State_Code__mdt> getStatesMetadata() {
		return [SELECT Id, FIPS_State_Code__c, State_Code__c,
					   MasterLabel, DeveloperName
				FROM   FIPS_State_Code__mdt
				ORDER BY MasterLabel];
	} 
}
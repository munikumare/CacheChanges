public with sharing class FPACCaseTriggerHelper {
	public static void populateCustomerEmail(List<Case> newCases) {
		for(Case currentCase : newCases) {
			if(String.isEmpty(currentCase.Customer_Email__c) && isCusInteractionRecordTypeId(currentCase)) {
				List<Contact> contacts = [SELECT Email FROM Contact WHERE Id = :currentCase.ContactId];
				if(!String.isEmpty(contacts[0].Email)){
					currentCase.Customer_Email__c = contacts[0].Email;
				}
			}
		}
	}

	public static void populateCustomerOfficeCountyIfEmpty(List<Case> newCases) {
		List<Case> casesToGetCountyAssigned = new List<Case> ();
		for(Case currentCase : newCases) {
			if(currentCase.FSA_BTO_Office_Lookup__c == null) {
				casesToGetCountyAssigned.add(currentCase);
			}
		}

		getOwnerCounty(casesToGetCountyAssigned);
	}

	public static void updateCustomerEmail(List<Case> newCases) {
		for(Case currentCase : newCases) {
			if(isCusInteractionRecordTypeId(currentCase)) {
				List<Contact> contacts = [SELECT Email FROM Contact WHERE Id = :currentCase.ContactId];
				if(!String.isEmpty(contacts[0].Email) && contacts[0].Email != currentCase.ContactEmail){
					currentCase.Customer_Email__c = contacts[0].Email;
				}
			}
		}
	}

	public static void updateCustomerOfficeCountyIfOwnerChanged(List<Case> newCases, Map<Id, Case> caseMap){
		List<Case> casesToBeUpdated = new List<Case> ();
		for(Case currentCase : newCases) {
			if(currentCase.OwnerId != caseMap.get(currentCase.Id).OwnerId) {
				casesToBeUpdated.add(currentCase);
			}
		}

		getOwnerCounty(casesToBeUpdated);
	}

	private static void getOwnerCounty(List<Case> cases) {
		Map<Id, Case> mapOfUserIdToCase = new Map<Id, Case> ();
		Map<Id, String> userIdToFipCodes = new Map<Id, String> ();
		Map<String, Id> fipsToCounty = new Map<String, Id> ();
		List<String> fipCodes = new List<String> ();
		List<Id> ownerIds = new List<Id> ();
		for(Case currentCase : cases) {
			ownerIds.add(currentCase.OwnerId);
			mapOfUserIdToCase.put(currentCase.OwnerId, CurrentCase);
		}

		List<User> users = getUserIdsForUpdatedCases(ownerIds);
		for(User u : users) {
			userIdToFipCodes.put(u.Id, u.FSA_BTO_FIPS_Code__c);
			fipCodes.add(u.FSA_BTO_FIPS_Code__c);
		}

		List<FSA_BTO_County__c> counties = getOfficeCounties(fipCodes);
		for(FSA_BTO_County__c county : counties) {
			fipsToCounty.put(county.FSA_BTO_FIPS_Code__c, county.Id);
		}

		for(Id userId : userIdToFipCodes.keySet()) {
			for(String fip : fipsToCounty.keySet()) {
				if(userIdToFipCodes.get(userId) == fip) {
					mapOfUserIdToCase.get(userId).FSA_BTO_Office_Lookup__c = fipsToCounty.get(fip);
				}
			}
		}
	}

	private static Boolean isCusInteractionRecordTypeId(Case currentCase) {
		Id cusRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Interaction').getRecordTypeId();
		if(currentCase.RecordTypeId == cusRecordTypeId) {
			return true;
		}

		return false;
	}

	private static List<User> getUserIdsForUpdatedCases(List<Id> ownerIds) {
		return [SELECT Id, FSA_BTO_FIPS_Code__c
				FROM User
				WHERE Id IN :ownerIds];
	}

	private static List<FSA_BTO_County__c> getOfficeCounties(List<String> fipCodes) {
		return  [
					SELECT Id, FSA_BTO_FIPS_Code__c
					FROM FSA_BTO_County__c
					WHERE FSA_BTO_FIPS_Code__c IN :fipCodes
					AND FSA_BTO_FIPS_Code__c != NULL
				];
	}
}
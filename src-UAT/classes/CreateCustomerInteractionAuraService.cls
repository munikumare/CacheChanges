public with sharing class CreateCustomerInteractionAuraService {

	@TestVisible private static String DEFAULT_SURVEY_ID = Label.FPAC_Customer_Interaction_Default_Survey_ID;
	public static Map<Id, String> recordtypemap { get; set; }

	@AuraEnabled
	public static List<String> getRecordTypeValues() {
		List<Schema.RecordTypeInfo> recordtypes = Case.SObjectType.getDescribe().getRecordTypeInfos();
		recordtypemap = new Map<Id, String>();
		for(RecordTypeInfo rt : recordtypes) {
			if(rt.getName() != 'Master' && rt.getName() != 'General Customer Service') {
				recordtypemap.put(rt.getRecordTypeId(), rt.getName());
			}
		}
		return recordtypemap.values();
	}

	@AuraEnabled
	public static Id getRecTypeId(String recordTypeLabel) {
		Id recid = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
		return recid;
	}

	@AuraEnabled
	public static String getSurveyId() {
		List<TIMBASURVEYS__Survey__c> survey = [
			SELECT Id, Name
			FROM TIMBASURVEYS__Survey__c
			WHERE Id = :DEFAULT_SURVEY_ID
			LIMIT 1
		];
		if (survey.isEmpty()) {
			return '';
		}
		return survey[0].Id;
	}

	@AuraEnabled
	public static String getCountyId() {
		String userFipsCode = [
			SELECT FSA_BTO_FIPS_Code__c
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		].FSA_BTO_FIPS_Code__c;

		List<FSA_BTO_County__c> county = [
			SELECT Id, FSA_BTO_FIPS_Code__c
			FROM FSA_BTO_County__c
			WHERE FSA_BTO_FIPS_Code__c = :userFipsCode
			AND FSA_BTO_FIPS_Code__c != NULL
			LIMIT 1
		];
		if (county.isEmpty()) {
			return '';
		}
		return county[0].Id;
	}

	@AuraEnabled
	public static String getStateCode() {
		String stateCode = [
			SELECT StateCode
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		].StateCode;
		return stateCode;
	}

}
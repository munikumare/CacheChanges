@isTest
private class CreateCustomerInteractionAuraServiceTest {

	@isTest
	public static void getSurveyId_givenSurveyExists_shouldReturnId() {

		TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c(Name='test survey');
		insert newSurvey;
		CreateCustomerInteractionAuraService.DEFAULT_SURVEY_ID = newSurvey.Id;

		String result, expectedResult;

		Test.startTest();
			result = CreateCustomerInteractionAuraService.getSurveyId();
		Test.stopTest();

		List<TIMBASURVEYS__Survey__c> survey = [
			SELECT Id, Name
			FROM TIMBASURVEYS__Survey__c
			WHERE Id = :CreateCustomerInteractionAuraService.DEFAULT_SURVEY_ID
			LIMIT 1
		];
		if (survey.isEmpty()) {
			expectedResult = '';
		} else {
			expectedResult = survey[0].Id;
		}

		System.assertEquals(expectedResult, result, 'Survey Id should have been returned if it was found');
	}

	@isTest
	public static void getSurveyId_givenNoSurveyExists_shouldNotReturnId() {

		String result, expectedResult;

		Test.startTest();
			result = CreateCustomerInteractionAuraService.getSurveyId();
		Test.stopTest();

		List<TIMBASURVEYS__Survey__c> survey = [
			SELECT Id, Name
			FROM TIMBASURVEYS__Survey__c
			WHERE Id = :CreateCustomerInteractionAuraService.DEFAULT_SURVEY_ID
			LIMIT 1
		];
		if (survey.isEmpty()) {
			expectedResult = '';
		} else {
			expectedResult = survey[0].Id;
		}

		System.assertEquals(expectedResult, result, 'Survey Id should have been returned if it was found');
	}

	@isTest
	public static void getCountyId_givenNoCountyExists_shouldReturnId() {

		String result, expectedResult;

		Test.startTest();
			result = CreateCustomerInteractionAuraService.getCountyId();
		Test.stopTest();

		String countyName = [
			SELECT FSA_BTO_Office_County__c
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		].FSA_BTO_Office_County__c;

		List<FSA_BTO_County__c> county = [
			SELECT Id, Name
			FROM FSA_BTO_County__c
			WHERE Name = :countyName
			LIMIT 1
		];
		if (county.isEmpty()) {
			expectedResult = '';
		} else {
			expectedResult = county[0].Id;
		}

		System.assertEquals(expectedResult, result, 'County Id should have been returned if it was found');
	}

	@isTest
	public static void getCountyId_givenCountyExists_shouldReturnId() {

		String result, expectedResult;

		String countyName = [
			SELECT FSA_BTO_Office_County__c
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		].FSA_BTO_Office_County__c;

		FSA_BTO_County__c newCounty = new FSA_BTO_County__c(Name = countyName);
		insert newCounty;

		List<FSA_BTO_County__c> county = [
			SELECT Id, Name
			FROM FSA_BTO_County__c
			WHERE Name = :countyName
			LIMIT 1
		];
		if (county.isEmpty()) {
			expectedResult = '';
		} else {
			expectedResult = county[0].Id;
		}

		Test.startTest();
			result = CreateCustomerInteractionAuraService.getCountyId();
		Test.stopTest();

		System.assertEquals(expectedResult, result, 'County Id should have been returned if it was found');
	}

	@isTest
	public static void getStateCode_shouldReturnStateCode() {

		String result, expectedResult;

		Test.startTest();
			result = CreateCustomerInteractionAuraService.getStateCode();
		Test.stopTest();

		expectedResult = [
			SELECT StateCode
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		].StateCode;

		System.assertEquals(expectedResult, result, 'State code should have been returned if it was found');
	}

	@isTest
	public static void getRecordTypeValues_shouldReturnList() {

		Test.startTest();
			List<String> result = CreateCustomerInteractionAuraService.getRecordTypeValues();
		Test.stopTest();

		System.assertNotEquals(null, result, 'At least one record type should have been returned.');
	}

	@isTest
	public static void getRecTypeId_shouldReturnId() {

		List<String> recordTypes = CreateCustomerInteractionAuraService.getRecordTypeValues();

		Test.startTest();
			String result = CreateCustomerInteractionAuraService.getRecTypeId(recordTypes[0]);
		Test.stopTest();

		System.assertNotEquals(null, result, 'At least one record type should have been returned.');
	}
}
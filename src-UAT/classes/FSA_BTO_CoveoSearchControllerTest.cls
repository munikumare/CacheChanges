@isTest
private class FSA_BTO_CoveoSearchControllerTest {

	@testSetup
	static void insertCountyAndURL() {
		FSA_BTO_Coveo_Secret__c coveoSecret = new FSA_BTO_Coveo_Secret__c(
			FSA_BTO_Environment_Specific_Query__c = 'testValue',
			FSA_BTO_CoveoOnPremise__c = true
		);
		insert coveoSecret;
	}

	@isTest
	static void testController() {
		Case testCase = new Case();
		ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
		
		Test.startTest();
			FSA_BTO_CoveoSearchController testController = new FSA_BTO_CoveoSearchController(sc);
		Test.stopTest();

		System.assertNotEquals(null, testController);
		System.assertEquals('testValue', testController.MainPageQuery, 'MainPageQuery should have been set.');
		System.assertEquals('true', testController.UsesOnPremise, 'UsesOnPremise should have been set.');
	}

	@isTest
	static void testGetContext() {
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		FSA_BTO_CoveoSearchController testController = new FSA_BTO_CoveoSearchController();
		
		Test.startTest();
			String testToken = testController.getContext();
		Test.stopTest();

		System.assertEquals('Test', testToken);
	}
}
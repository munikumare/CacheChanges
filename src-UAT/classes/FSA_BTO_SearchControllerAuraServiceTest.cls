@isTest
private class FSA_BTO_SearchControllerAuraServiceTest {

	private static String testStreet = '123 Sesame St';
    private static String testCity = 'Middleburg';
    private static String testState = 'Florida';
    private static String testZip = '32068-2701';
	
	@isTest static void testgetContentDistributionBySearch() {
		List<ContentDistribution> cds=FSA_BTO_SearchControllerAuraService.getContentDistributionBySearch('testCD');
		System.assertEquals(cds.size(),1);
	}
	
	@isTest static void testsaveNewBundle() {
		Case bundleCase=[Select Id FROM Case WHERE Subject='Test'];
		ContentDistribution cd=[Select Id FROM ContentDistribution Where Name='testCD Name'];
		FSA_BTO_SearchControllerAuraService.saveNewBundle(cd.Id, bundleCase.Id);
		List<FSA_BTO_Case_Content_Distribution__c> bundles=[Select Id From FSA_BTO_Case_Content_Distribution__c];
		System.assertEquals(bundles.size(),1);
	}

	@testSetup static void setupTestData(){
		Profile p = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User'];
        User testUser = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'unittest@fsa.dev');
        testUser.Street = testStreet;
        testUser.City = testCity;
        testUser.State = testState;
        testUser.PostalCode = testZip;
        testUser.LastName = 'Tester';
        insert testUser;

        TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c();
        insert newSurvey;
        List<TIMBASURVEYS__Survey__c> testSurvey = [Select Id from TIMBASURVEYS__Survey__c limit 1];
        Case testCase = new Case();
        testCase.Subject='Test';
        testCase.FSA_BTO_Survey__c = testSurvey[0].Id;
        insert testCase;

        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        ContentVersion testCV = new ContentVersion();
        testCV.Title = 'Test Title';
        testCV.PathOnClient = 'test.txt';
        testCV.VersionData = myBlob;
        insert testCV;
        ContentDistribution testCD = new ContentDistribution();
        testCD.ContentVersionId = testCV.id;
        testCD.Name = 'testCD Name';
        insert testCD;
	}
	
}
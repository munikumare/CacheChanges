@isTest
private class CaseCloseConstructorTest {
	
	@isTest static void testCaseClose() {
		TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c();
        insert newSurvey;
        List<TIMBASURVEYS__Survey__c> testSurvey = [Select Id from TIMBASURVEYS__Survey__c limit 1];
        Case testCase = new Case();
        testCase.FSA_BTO_Survey__c = testSurvey[0].Id;
        insert testCase;
        PageReference pageRef = Page.CaseClose;
        Test.setCurrentPage(pageRef);
        CaseCloseConstructor ccc = new CaseCloseConstructor();
        ApexPages.currentPage().getParameters().put('id', testCase.Id);
        ccc.closeAndRedirect();
	}
	
	
}
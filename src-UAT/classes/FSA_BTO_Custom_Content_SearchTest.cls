@isTest
private class FSA_BTO_Custom_Content_SearchTest {
    @isTest static void testCCS() {
        TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c();
        insert newSurvey;
        List < TIMBASURVEYS__Survey__c > testSurvey = [Select Id from TIMBASURVEYS__Survey__c limit 1];
        Case testCase = new Case();
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
        PageReference page = System.Page.FSA_BTO_Custom_Content_Search_Page;
        Test.setCurrentPage(page);
        ApexPages.currentPage().getParameters().put('lksrch', 'testCD Name');
        ApexPages.currentPage().getParameters().put('chosenName', 'testCD');
        ApexPages.currentPage().getParameters().put('chosenURL', 'http://www.google.com');
        ApexPages.currentPage().getParameters().put('case', testCase.Id);
        Test.startTest();
        FSA_BTO_Custom_Content_Search ccs = new FSA_BTO_Custom_Content_Search();
        ccs.newCaseLink();
        ccs.search();
        Test.stopTest();
    }
}
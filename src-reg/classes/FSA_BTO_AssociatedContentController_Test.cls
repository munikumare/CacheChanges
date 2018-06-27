@isTest
private class FSA_BTO_AssociatedContentController_Test {

    public static testMethod void testCreateNewAssociatedContent() {
        TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c();
        insert newSurvey;
        List<TIMBASURVEYS__Survey__c> testSurvey = [Select Id from TIMBASURVEYS__Survey__c limit 1];
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
        String contentName = 'Content Name';
        String caseId = String.valueOf(testCase.Id);
        System.Debug(testCase.id);
        String testCVID = String.valueOf(testCV.id);
        FSA_BTO_AssociatedContentController.CreateNewAssociatedContent(contentName, caseId, testCVID);
        
        List<FSA_BTO_Case_Content_Distribution__c> results = [Select Name, Id, Content_URL__c, Content_Name__c, Case__c From FSA_BTO_Case_Content_Distribution__c where Case__c=:testCase.id and Content_Name__c=:contentName];
        
        
        System.assertEquals(results.size(), 1);
    }

     public static testMethod void testCaseArticles() {
         FSA_BTO_Standard_Article__kav ka = new FSA_BTO_Standard_Article__kav();
         ka.Title = 'TestTitle';
         ka.UrlName = 'test-title';
         insert ka;
         TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c();
         insert newSurvey;
         List<TIMBASURVEYS__Survey__c> testSurvey = [Select Id from TIMBASURVEYS__Survey__c limit 1];
         Case testCase = new Case();
         testCase.FSA_BTO_Survey__c = testSurvey[0].Id;
         insert testCase;
         ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
         FSA_BTO_AssociatedContentController testController = new FSA_BTO_AssociatedContentController(sc);
         CaseArticle testCA = new CaseArticle();
         System.Debug(testCase.Id);
         testCA.CaseId = testCase.Id;
         List<FSA_BTO_Standard_Article__kav> test = [Select KnowledgeArticleId from FSA_BTO_Standard_Article__kav where Id =: ka.Id];
         System.Debug(test[0].KnowledgeArticleId);
         System.Debug(ka.KnowledgeArticleId);
         testCA.KnowledgeArticleId = test[0].KnowledgeArticleId;
         insert testCA;
         List<CaseArticle> results = testController.caseArticles;
         System.assertEquals(results.size(), 1);
     }

    public static testMethod void testCaseResources() {
        RecordType publicPartnerIndividualRT = [SELECT Id from RecordType WHERE DeveloperName='FSA_BTO_Public_Partner'];
        Contact test = new Contact(LastName='Tester', MailingStreet='Fake Street', MailingCity='Fake City', MailingState='Virginia', MailingPostalCode='11111', MailingCountry='United States', RecordTypeId=publicPartnerIndividualRT.Id);
        insert test;
        TIMBASURVEYS__Survey__c newSurvey = new TIMBASURVEYS__Survey__c();
        insert newSurvey;
        List<TIMBASURVEYS__Survey__c> testSurvey = [Select Id from TIMBASURVEYS__Survey__c limit 1];
        Case testCase = new Case();
        testCase.FSA_BTO_Survey__c = testSurvey[0].Id;
        insert testCase;
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        FSA_BTO_AssociatedContentController testController = new FSA_BTO_AssociatedContentController(sc);
        FSA_BTO_Case_Contact__c testContact = new  FSA_BTO_Case_Contact__c();
        testContact.FSA_BTO_Case__c = testCase.Id;
        testContact.FSA_BTO_Contact__c = test.Id;
        insert testContact;
        List<sObject> results = testController.caseResources;
        System.assertEquals(results.size(), 1);
    }
}
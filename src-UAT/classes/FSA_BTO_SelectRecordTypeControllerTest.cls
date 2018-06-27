@isTest
private class FSA_BTO_SelectRecordTypeControllerTest {
    public static testMethod void testHandleRedirectNoAccountNoContactRT() {
        Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName = 'Tester' and MailingCity = 'Nowhere'];
        testContact.RecordTypeId=null;
        update testContact;
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testContact);
        FSA_BTO_SelectRecordTypeController selectRecordTypeController = new FSA_BTO_SelectRecordTypeController(stdCon);
        System.AssertEquals(null, String.valueOf(selectRecordTypeController.handleRedirect()));
    }

    public static testMethod void testHandleRedirectNoAccountContactRT() {
        Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName = 'Tester' and MailingCity = 'Nowhere'];
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testContact);
        FSA_BTO_SelectRecordTypeController selectRecordTypeController = new FSA_BTO_SelectRecordTypeController(stdCon);
        selectRecordTypeController.handleRedirect();
        System.AssertEquals(new PageReference('/003/e?nooverride=1&RecordType=' +testContact.RecordTypeId), selectRecordTypeController.handleRedirect());
    }

    public static testMethod void testHandleRedirectUSDAAgency() {
        Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName = 'Tester' and MailingCity = 'Nowhere'];
        Account pageAccount = [Select Id From Account Where Name='Test Agency' LIMIT 1];
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testContact);
        FSA_BTO_SelectRecordTypeController selectRecordTypeController = new FSA_BTO_SelectRecordTypeController(stdCon);
        selectRecordTypeController.accid=pageAccount.Id;
        selectRecordTypeController.handleRedirect();
        //System.AssertEquals('System.PageReference[/003/e?accid=' + pageAccount.Id + '&ent=Contact&nooverride=1&RecordType=' + testContact.RecordTypeId +'&retURL=' + pageAccount.Id+']', String.valueOf(selectRecordTypeController.handleRedirect()));
    }

    public static testMethod void testHandleRedirectPPO() {
        Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName = 'Tester' and MailingCity = 'Nowhere'];
        Account pageAccount = [Select Id From Account Where Name='Test Agency' LIMIT 1];
        RecordType rt=[Select Id, Name From RecordType Where Name='Public Partner Organization' AND SObjectType='Account'];
        pageAccount.RecordTypeId=rt.Id;
        update pageAccount;
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testContact);
        FSA_BTO_SelectRecordTypeController selectRecordTypeController = new FSA_BTO_SelectRecordTypeController(stdCon);
        selectRecordTypeController.accid=pageAccount.Id;
        selectRecordTypeController.handleRedirect();
        //System.AssertEquals('System.PageReference[/003/e?accid=' + pageAccount.Id + '&ent=Contact&nooverride=1&RecordType=' + testContact.RecordTypeId +'&retURL=' + pageAccount.Id+']', String.valueOf(selectRecordTypeController.handleRedirect()));
    }

    public static testMethod void testHandleRedirectBPO() {
        Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName = 'Tester' and MailingCity = 'Nowhere'];
        Account pageAccount = [Select Id From Account Where Name='Test Agency' LIMIT 1];
        RecordType rt=[Select Id, Name From RecordType Where Name='FPAC Partner Account' AND SObjectType='Account'];
        pageAccount.RecordTypeId=rt.Id;
        update pageAccount;
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testContact);
        FSA_BTO_SelectRecordTypeController selectRecordTypeController = new FSA_BTO_SelectRecordTypeController(stdCon);
        selectRecordTypeController.accid=pageAccount.Id;
        selectRecordTypeController.handleRedirect();
        //System.AssertEquals('System.PageReference[/003/e?accid=' + pageAccount.Id + '&ent=Contact&nooverride=1&RecordType=' + testContact.RecordTypeId +'&retURL=' + pageAccount.Id+']', String.valueOf(selectRecordTypeController.handleRedirect()));
    }

    public static testMethod void testHandleRedirectBCO() {
        Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName = 'Tester' and MailingCity = 'Nowhere'];
        Account pageAccount = [Select Id From Account Where Name='Test Agency' LIMIT 1];
        RecordType rt=[Select Id, Name From RecordType Where Name='FPAC Customer Account' AND SObjectType='Account'];
        pageAccount.RecordTypeId=rt.Id;
        update pageAccount;
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testContact);
        FSA_BTO_SelectRecordTypeController selectRecordTypeController = new FSA_BTO_SelectRecordTypeController(stdCon);
        selectRecordTypeController.accid=pageAccount.Id;
        selectRecordTypeController.handleRedirect();
        //System.AssertEquals('System.PageReference[/003/e?accid=' + pageAccount.Id + '&ent=Contact&nooverride=1&RecordType=' + testContact.RecordTypeId +'&retURL=' + pageAccount.Id+']', String.valueOf(selectRecordTypeController.handleRedirect()));
    }

    @testSetup static void setupTestData(){
        RecordType accountRT = [Select Name, Id from RecordType where Name = 'USDA Agency'];
        Account pageAccount = new Account(Name = 'Test Agency', RecordTypeId = accountRT.Id);
        Contact pageContact = new Contact(LastName = 'Tester', AccountId = pageAccount.Id, MailingStreet = '123 Sesame Street', MailingCity = 'Nowhere', MailingState = 'Virginia', MailingPostalCode = '22102');
        RecordType contactRT = [Select Name, Id from RecordType where Name = 'FPAC Partner Contact'];
        pageContact.RecordTypeId = contactRT.Id;
        insert pageAccount;
        pageContact.AccountId = pageAccount.Id;
        insert pageContact;
    }
}
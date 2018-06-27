@isTest
private class FSA_BTO_SCIMSCustomerControllerTest {
    private static Id btoCustomerAccountRTId = Schema.SObjectType.Account.RecordTypeInfosByName.get('FPAC Customer Account').RecordTypeId;
    private static Account account = new Account(Name='Test Customer Account', RecordTypeId=btoCustomerAccountRTId);
    private static Id btoCustomerRTId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('FPAC Customer Contact').RecordTypeId;
    private static PageReference customerPage = Page.FSA_BTO_SCIMSCustomer;
    private static Contact initialContact = new Contact(AccountId=account.Id, RecordTypeId=btoCustomerRTId, FSA_BTO_Core_Customer_ID__c='123456', LastName='FAKELAST_1', FirstName='FAKEFIRST_1', MiddleName='FAKEMIDDLE_1', Suffix='FAKESUFFIX_1', Email='fake_1@email.com', Phone='111-111-1111', MobilePhone='888-888-8888', MailingStreet='123 FAKE ST', MailingCity='BOSTON', MailingStateCode='MA', MailingPostalCode='11111');        

    public static testMethod void testGetIndividualCustomer() {  
        insert account;
        insert initialContact;
        Test.setCurrentPageReference(customerPage);
        ApexPages.currentPage().getParameters().put('id',initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse());
        controller.getCustomer();
        
        Contact updatedContact = [SELECT LastName, FirstName, MiddleName, Salutation, Suffix, Phone, MobilePhone, Email, MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, FSA_BTO_Core_Customer_ID__c FROM Contact WHERE FSA_BTO_Core_Customer_ID__c='123456'];
        System.assertEquals('123456', updatedContact.FSA_BTO_Core_Customer_ID__c);
        System.assertEquals('TESTLAST_ABCDEFGHIJKLMNOPQRSTUVWXYZ012345678901234567890123456789012345678901234', updatedContact.LastName);
        System.assertEquals('TESTFIRST_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123', updatedContact.FirstName);
        System.assertEquals('TESTMIDDLE_ABCDEFGHIJKLMNOPQRSTUVWXYZ012', updatedContact.MiddleName);
        System.assertEquals('Dr.', updatedContact.Salutation);
        System.assertEquals('TESTSUFFIX_ABCDEFGHIJKLMNOPQRSTUVWXYZ012', updatedContact.Suffix);
        System.assertEquals('fake_2@email.com', updatedContact.Email);
        System.assertEquals('222-222-2222', updatedContact.Phone);
        System.assertEquals('999-999-9999', updatedContact.MobilePhone);
        System.assertEquals('234 FAKE AVE', updatedContact.MailingStreet);
        System.assertEquals('MCLEAN', updatedContact.MailingCity);
        System.assertEquals('VA', updatedContact.MailingStateCode);
        System.assertEquals('22222', updatedContact.MailingPostalCode);
        
        System.assertEquals('Active', controller.scimsCustomer.customerStatus);
        System.assertEquals('Individual', controller.scimsCustomer.customerType);
        System.assertEquals('Female', controller.scimsCustomer.gender);
        System.assertEquals('Widow(er)', controller.scimsCustomer.maritalStatus);
        System.assertEquals('01/01/1900', controller.scimsCustomer.birthDate);
        System.assertEquals('US', controller.scimsCustomer.citizenCountry);
        System.assertEquals('English', controller.scimsCustomer.languagePreference);
        System.assertEquals('No handicap', controller.scimsCustomer.disability);
        System.assertEquals('Y', controller.scimsCustomer.veteranStatus);
        System.assertEquals('FAKE COMMON', controller.scimsCustomer.commonName);

        System.assertNotEquals(null, controller.reload());

        Test.stopTest();
    }
    
    // invalid email throws dml exception
    public static testMethod void testThrowDmlException() {
        insert account;
        insert initialContact;    
        Test.setCurrentPageReference(customerPage);
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse2());
        controller.getCustomer();
        System.assertEquals('Error saving Bridges Customer: Invalid email address (fake_3@emailcom)', controller.errorMessage);      
    }
    
    // null last name throws dml exception 
    public static testMethod void testThrowDmlException2() {
        insert account;
        insert initialContact;    
        Test.setCurrentPageReference(customerPage);
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse3());
        controller.getCustomer();
        System.assertEquals('Error saving Bridges Customer: Please ensure that all contact information in the SCIMS customer record are valid.', controller.errorMessage);
    }
    
    // covering CalloutException
    public static testMethod void testThrowCalloutException() {
        insert account;
        insert initialContact;
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse4());
        controller.getCustomer();
        System.assertEquals('Error refreshing Bridges Customer data: The SCIMS Web Service is currently down. Please try again later.', controller.errorMessage);
    }
    
    // covering XmlException
    public static testMethod void testThrowXmlException() {
        insert account;
        insert initialContact;
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse5());
        controller.getCustomer();
        System.assertEquals('Error processing Bridges Customer data: Data retrieved from SCIMS is invalid. An administrator has been alerted. Please try again later', controller.errorMessage);
    }
    
    // covering other Exception
    public static testMethod void testThrowException() {
        insert account;
        insert initialContact;
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse6());
        controller.getCustomer();
        System.assertEquals('Error detected. An administrator has been alerted.', controller.errorMessage);
    }

    // covering QueryException
    public static testMethod void testThrowQueryException() {
        insert account;
        insert initialContact;
        ApexPages.currentPage().getParameters().put('id', 'invalidId1234');
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse());
        controller.getCustomer();
        System.assertEquals('Fatal error: Cannot retrieve contact record. A system administrator has been alerted. Please try again later.', controller.errorMessage);
    }
    
    // covering business customer with truncated business name (> 80 char), blank customer attributes
    public static testMethod void testGetBusinessCustomer() {
        insert account;
        insert initialContact;
        Test.setCurrentPageReference(customerPage);
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse7());
        controller.getCustomer();
        
        Contact updatedContact = [SELECT LastName, FirstName, MiddleName, Salutation, Suffix, Phone, MobilePhone, Email, MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, FSA_BTO_Core_Customer_ID__c FROM Contact WHERE FSA_BTO_Core_Customer_ID__c='123456'];
        System.assertEquals('FAKE BUSINESS NAME ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789012345678901234567890123', updatedContact.LastName);
        System.assertEquals(null, updatedContact.FirstName);
        System.assertEquals(null, updatedContact.MiddleName);
        System.assertEquals(null, updatedContact.Salutation);
        System.assertEquals(null, updatedContact.Suffix);
        System.assertEquals(null, updatedContact.Email);
        System.assertEquals(null, updatedContact.Phone);
        System.assertEquals(null, updatedContact.MobilePhone);
        System.assertEquals(null, updatedContact.MailingStreet);
        System.assertEquals(null, updatedContact.MailingCity);
        System.assertEquals(null, updatedContact.MailingStateCode);
        System.assertEquals(null, updatedContact.MailingPostalCode);
  
        System.assertEquals('Inactive', controller.scimsCustomer.customerStatus);
        System.assertEquals('Joint Venture', controller.scimsCustomer.businessType);
        Test.stopTest();
    }
    
    // only covering non-truncated business name (80 char or less)
    public static testMethod void testGetBusinessCustomer2() {
        insert account;
        insert initialContact;
        Test.setCurrentPageReference(customerPage);
        ApexPages.currentPage().getParameters().put('id', initialContact.Id);
        Test.startTest();
        FSA_BTO_SCIMSCustomerController controller = new FSA_BTO_SCIMSCustomerController();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_SCIMSWSMockCustomerResponse8());
        controller.getCustomer(); 
        
        System.assertEquals('FAKE BUSINESS NAME ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789012345678901234567890123', controller.scimsCustomer.businessName);
        Test.stopTest();
    }
}
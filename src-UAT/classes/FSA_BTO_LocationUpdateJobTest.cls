@isTest
private class FSA_BTO_LocationUpdateJobTest {
    private static String testStreet = '123 Sesame St';
    private static String testCity = 'Middleburg';
    private static String testState = 'Florida';
    private static String testZip = '32068-2701';
    private static Decimal resultLat = 30.0754911;
    private static Decimal resultLong = -81.89905700000001;

    private static testMethod void testLocationUpdateJobScheduler() {
        FSA_BTO_scheduledLocationJob slj= new FSA_BTO_scheduledLocationJob();
        String scheduledJobId = System.schedule('testScheduledApex', '0 0 0 3 9 ? 2022', slj);
    }

    private static testMethod void testLocationUpdateJob() {
        FSA_BTO_LocationUpdateJob rlu= new FSA_BTO_LocationUpdateJob();
        rlu.FSA_BTO_RunLocationUpdate();
    }

    @testSetup static void setupTestData(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'unittest@fsa.dev');
        testUser.Street = testStreet;
        testUser.City = testCity;
        testUser.State = testState;
        testUser.PostalCode = testZip;
        testUser.LastName = 'Tester';
        insert testUser;

        Contact testContact = new Contact();
        testContact.MailingStreet = testStreet;
        testContact.MailingCity = testCity;
        testContact.MailingState = testState;
        testContact.MailingPostalCode = testZip;
        testContact.LastName = 'Tester';
        insert testContact;

        Account testAccount = new Account();
        testAccount.BillingStreet = testStreet;
        testAccount.BillingCity = testCity;
        testAccount.BillingState = testState;
        testAccount.BillingPostalCode = testZip;
        testAccount.Name = 'Tester';
        insert testAccount;

    }
}
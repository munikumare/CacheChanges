@isTest
private class FSA_BTO_LocationCallouts_Test {
    public static String testStreet = '123 Sesame St';
    public static String testCity = 'Middleburg';
    public static String testState = 'Florida';
    public static String testZip = '32068-2701';
    public static Decimal resultLat = 30.0754911;
    public static Decimal resultLong = -81.89905700000001;
    public static String address = EncodingUtil.urlEncode(testStreet + ', ' + testCity + ', ' + testState + ' ' + testZip + ', ', 'UTF-8');

    public static testMethod void testGetUserLocation() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'unittest@fsa.dev');
        testUser.Street = testStreet;
        testUser.City = testCity;
        testUser.State = testState;
        testUser.PostalCode = testZip;
        testUser.LastName = 'Tester';
        insert testUser;
        Set < Id > userIds = new Set < Id > ();
        userIds.add(testUser.Id);
        Map < String, User > userMap = FSA_BTO_LocationCallouts.buildUserAddressMap(userIds);
        HttpResponse res = new HttpResponse();
        res.setBodyAsBlob(b);
        User u=FSA_BTO_LocationCallouts.handleUserWebServiceResponse(res, address, userMap);
        update u;
        List < User > results = [Select FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s from User where UserName = 'unittest@fsa.dev'];
        System.Debug(results[0].FSA_BTO_Location__Latitude__s);
        System.Assert(results[0] != null);
        System.Debug(String.ValueOf(resultLat));
        System.AssertEquals(results[0].FSA_BTO_Location__Latitude__s, resultLat);
        System.AssertEquals(results[0].FSA_BTO_Location__Longitude__s, resultLong);
    }

   public static testMethod void testGetIndividualLocation() {
        Contact testContact = new Contact();
        testContact.MailingStreet = testStreet;
        testContact.MailingCity = testCity;
        testContact.MailingState = testState;
        testContact.MailingPostalCode = testZip;
        testContact.LastName = 'Tester';
        insert testContact;
        Set < Id > contactIds = new Set < Id > ();
        contactIds.add(testContact.Id);
        Map < String, Contact > contactMap = FSA_BTO_LocationCallouts.buildContactAddressMap(contactIds);
        HttpResponse res = new HttpResponse();
        res.setBodyAsBlob(b);
        Contact c=FSA_BTO_LocationCallouts.handleContactWebServiceResponse(res, address, contactMap);
        update c;
        List < Contact > results = [Select FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s from Contact where LastName = 'Tester'];
        System.Debug(results[0].FSA_BTO_Location__Latitude__s);
        System.Assert(results[0] != null);
        System.Debug(String.ValueOf(resultLat));
        System.AssertEquals(results[0].FSA_BTO_Location__Latitude__s, resultLat);
        System.AssertEquals(results[0].FSA_BTO_Location__Longitude__s, resultLong);
    }

    public static testMethod void testGetAccountLocation() {
        Account testAccount = new Account();
        testAccount.BillingStreet = testStreet;
        testAccount.BillingCity = testCity;
        testAccount.BillingState = testState;
        testAccount.BillingPostalCode = testZip;
        testAccount.Name = 'Tester';
        insert testAccount;
        Set < Id > accountIds = new Set < Id > ();
        accountIds.add(testAccount.Id);
        Map<String, Account> accountMap = FSA_BTO_LocationCallouts.buildAccountAddressMap(accountIds);
        HttpResponse res = new HttpResponse();
        res.setBodyAsBlob(b);
        Account a=FSA_BTO_LocationCallouts.handleAccountWebServiceResponse(res, address, accountMap);
        update a;
        List < Account > results = [Select FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s from Account where Name = 'Tester'];
        System.Debug(results[0].FSA_BTO_Location__Latitude__s);
        System.Assert(results[0] != null);
        System.Debug(String.ValueOf(resultLat));
        System.AssertEquals(results[0].FSA_BTO_Location__Latitude__s, resultLat);
        System.AssertEquals(results[0].FSA_BTO_Location__Longitude__s, resultLong);
    }

    public static testMethod void testGetEventLocation() {
        Event testEvent = new Event();
        testEvent.DurationInMinutes = 60;
        testEvent.ActivityDateTime = Date.today();
        testEvent.FSA_BTO_EventStreet__c = testStreet;
        testEvent.FSA_BTO_EventCity__c = testCity;
        testEvent.FSA_BTO_EventState__c = testState;
        testEvent.FSA_BTO_EventZipCode__c = testZip;
        testEvent.Subject = 'Tester';
        insert testEvent;
        Set < Id > eventIds = new Set < Id > ();
        eventIds.add(testEvent.Id);
        Map<String, Event> eventMap = FSA_BTO_LocationCallouts.buildEventAddressMap(eventIds);
        HttpResponse res = new HttpResponse();
        res.setBodyAsBlob(b);
        Event e=FSA_BTO_LocationCallouts.handleEventWebServiceResponse(res, address, eventMap);
        update e;
        List < Event > results = [Select FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s from Event where Subject = 'Tester'];
        System.Debug(results[0].FSA_BTO_Location__Latitude__s);
        System.Assert(results[0] != null);
        System.Debug(String.ValueOf(resultLat));
        System.AssertEquals(results[0].FSA_BTO_Location__Latitude__s, resultLat);
        System.AssertEquals(results[0].FSA_BTO_Location__Longitude__s, resultLong);
    }

    public static Blob b = Blob.valueOf('{    "results" : [       {          "address_components" : [             {                "long_name" : "123",                "short_name" : "123",                "types" : [ "street_number" ]             },             {                "long_name" : "Sesame Street",                "short_name" : "Sesame St",                "types" : [ "route" ]             },             {                "long_name" : "Middleburg",                "short_name" : "Middleburg",                "types" : [ "locality", "political" ]             },             {                "long_name" : "Clay County",                "short_name" : "Clay County",                "types" : [ "administrative_area_level_2", "political" ]             },             {                "long_name" : "Florida",                "short_name" : "FL",                "types" : [ "administrative_area_level_1", "political" ]             },             {                "long_name" : "United States",                "short_name" : "US",                "types" : [ "country", "political" ]             },             {                "long_name" : "32068",                "short_name" : "32068",                "types" : [ "postal_code" ]             },             {                "long_name" : "2701",                "short_name" : "2701",                "types" : [ "postal_code_suffix" ]             }          ],          "formatted_address" : "123 Sesame St, Middleburg, FL 32068, USA",          "geometry" : {             "bounds" : {                "northeast" : {                   "lat" : 30.0755073,                   "lng" : -81.89905689999999                },                "southwest" : {                   "lat" : 30.0754911,                   "lng" : -81.89905700000001                }             },             "location" : {                "lat" : 30.0754911,                "lng" : -81.89905700000001             },             "location_type" : "RANGE_INTERPOLATED",             "viewport" : {                "northeast" : {                   "lat" : 30.0768481802915,                   "lng" : -81.89770796970851                },                "southwest" : {                   "lat" : 30.0741502197085,                   "lng" : -81.90040593029151                }             }          },          "place_id" : "EigxMjMgU2VzYW1lIFN0LCBNaWRkbGVidXJnLCBGTCAzMjA2OCwgVVNB",          "types" : [ "street_address" ]       }    ],    "status" : "OK" }');
}
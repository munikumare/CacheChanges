@isTest
public class FSA_BTO_LocationUpdateJobTest{
    public static String testStreet= '123 Sesame St';
    public static String testCity= 'Middleburg';
    public static String testState= 'Florida'; 
    public static String testZip= '32068-2701';
    public static Decimal resultLat= 30.0754911;
    public static Decimal resultLong= -81.89905700000001;

    
    public static testMethod void testLocationUpdateJob(){
    Contact testContact = new Contact();
    testContact.MailingStreet = testStreet;
    testContact.MailingCity = testCity;
    testContact.MailingState = testState;
    testContact.MailingPostalCode = testZip;
    testContact.LastName = 'Tester';
    insert testContact;
    
    FSA_BTO_LocationUpdateJob job = new FSA_BTO_LocationUpdateJob();
    job.FSA_BTO_RunLocationUpdate();
    String address = FSA_BTO_LocationCallouts.buildContactAddress(testContact.Id);
    HttpResponse res = new HttpResponse();
    res.setBodyAsBlob(b);
    FSA_BTO_LocationCallouts.handleContactWebServiceResponse(res, testContact.Id);
    Contact updatedContact = [Select FSA_BTO_Location__Longitude__s, FSA_BTO_Location__Latitude__s from Contact where Id =:testContact.Id];
    System.AssertEquals(resultLat, updatedContact.FSA_BTO_Location__Latitude__s);
    }
    
     public static Blob b = Blob.valueOf('{    "results" : [       {          "address_components" : [             {                "long_name" : "123",                "short_name" : "123",                "types" : [ "street_number" ]             },             {                "long_name" : "Sesame Street",                "short_name" : "Sesame St",                "types" : [ "route" ]             },             {                "long_name" : "Middleburg",                "short_name" : "Middleburg",                "types" : [ "locality", "political" ]             },             {                "long_name" : "Clay County",                "short_name" : "Clay County",                "types" : [ "administrative_area_level_2", "political" ]             },             {                "long_name" : "Florida",                "short_name" : "FL",                "types" : [ "administrative_area_level_1", "political" ]             },             {                "long_name" : "United States",                "short_name" : "US",                "types" : [ "country", "political" ]             },             {                "long_name" : "32068",                "short_name" : "32068",                "types" : [ "postal_code" ]             },             {                "long_name" : "2701",                "short_name" : "2701",                "types" : [ "postal_code_suffix" ]             }          ],          "formatted_address" : "123 Sesame St, Middleburg, FL 32068, USA",          "geometry" : {             "bounds" : {                "northeast" : {                   "lat" : 30.0755073,                   "lng" : -81.89905689999999                },                "southwest" : {                   "lat" : 30.0754911,                   "lng" : -81.89905700000001                }             },             "location" : {                "lat" : 30.0754911,                "lng" : -81.89905700000001             },             "location_type" : "RANGE_INTERPOLATED",             "viewport" : {                "northeast" : {                   "lat" : 30.0768481802915,                   "lng" : -81.89770796970851                },                "southwest" : {                   "lat" : 30.0741502197085,                   "lng" : -81.90040593029151                }             }          },          "place_id" : "EigxMjMgU2VzYW1lIFN0LCBNaWRkbGVidXJnLCBGTCAzMjA2OCwgVVNB",          "types" : [ "street_address" ]       }    ],    "status" : "OK" }');

}
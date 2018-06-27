@isTest (SeeAllData=true)
private class FSA_BTO_CBSSyncControllerTest {
    public static testMethod void testGetCounty(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSA_BTO_CBSMockResponse());
        FSA_BTO_CBSSyncController.getCounty('66');
        Test.stopTest();
        FSA_BTO_County__c updatedCounty = [Select Name, FSA_BTO_FIPS_Code__c, FSA_BTO_StreetAddress__c, FSA_BTO_City__c, FSA_BTO_State__c, FSA_BTO_Zip_Code__c from FSA_BTO_County__c where FSA_BTO_FIPS_Code__c = '14001'];
        System.assertEquals('GUAM FARM SERVICE AGENCY', updatedCounty.Name);

    }

    public static testMethod void testGetCodes(){
        FSA_BTO_CBS_SyncA synca = new FSA_BTO_CBS_SyncA();
        FSA_BTO_CBS_SyncB syncb = new FSA_BTO_CBS_SyncB();
        synca.getCodes();
        syncb.getCodes();
        System.assert(synca.codes.size() > 20);
        System.assert(syncb.codes.size() > 20);
    }
}
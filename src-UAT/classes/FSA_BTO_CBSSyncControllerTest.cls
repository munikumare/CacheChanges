@isTest
private class FSA_BTO_CBSSyncControllerTest {

	private static final String COUNTY_NAME = 'GUAM FARM SERVICE AGENCY';
	private static final String COUNTY_ZIP = '14001';

	@testSetup static void insertCountyAndURL() {
		FSA_BTO_County__c county = new FSA_BTO_County__c(
			Name = COUNTY_NAME,
			FSA_BTO_FIPS_Code__c = COUNTY_ZIP
		);
		insert county;

		FSA_BTO_URLs__c url = new FSA_BTO_URLs__c(
			Name = 'FSA_BTO_Cert_Name',
			URL__c = 'bridges_to_opportunity'
		);
		insert url;
	}

	public static testMethod void testGetCounty() {
		Test.startTest();
			Test.setMock(HttpCalloutMock.class, new FSA_BTO_CBSMockResponse());
			FSA_BTO_CBSSyncController.getCounty('66');
		Test.stopTest();

		FSA_BTO_County__c updatedCounty = [
			SELECT Name, FSA_BTO_FIPS_Code__c, FSA_BTO_StreetAddress__c, FSA_BTO_City__c, FSA_BTO_State__c, FSA_BTO_Zip_Code__c 
			FROM FSA_BTO_County__c 
			WHERE FSA_BTO_FIPS_Code__c = :COUNTY_ZIP
			LIMIT 1
		];

		System.assertEquals(COUNTY_NAME, updatedCounty.Name);
	}

	public static testMethod void testGetCodes() {
		FSA_BTO_CBS_SyncA synca = new FSA_BTO_CBS_SyncA();
		FSA_BTO_CBS_SyncB syncb = new FSA_BTO_CBS_SyncB();
		synca.getCodes();
		syncb.getCodes();
		System.assert(synca.codes.size() > 20);
		System.assert(syncb.codes.size() > 20);
	}
}
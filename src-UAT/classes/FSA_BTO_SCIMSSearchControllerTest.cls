@IsTest
public with sharing class FSA_BTO_SCIMSSearchControllerTest {

	public static testMethod void testSetSCIMSSearchLocationDefault() {
		Site site = [
			SELECT Subdomain 
			FROM Site 
			WHERE Name = 'FSA_BTO_SCIMSSearchResultsInbound'
		];

		FSA_BTO_SCIMSSearchController controller;

		Profile fsaUserProfile = [
			SELECT Id 
			FROM Profile 
			WHERE Name = 'FSA BTO User' 
			LIMIT 1
		];
		User fsaUser = new User(
			Alias='Test',
			Email='test@usda.gov',
			EmailEncodingKey='UTF-8',
			FSA_BTO_FIPS_Code__c = '51059',
			LanguageLocaleKey='en_US',
			LastName='McTest',
			LocaleSidKey='en_US',
			ProfileId=fsaUserProfile.Id,
			TimeZoneSidKey='America/New_York',
			UserName='test@fsa.prod'
		);
		insert fsaUser;

		System.runAs(fsaUser) {
			controller = new FSA_BTO_SCIMSSearchController();
			controller.init();

			SCIMS_Setting__mdt setting = [
				SELECT Org_Name__c, Return_URL__c, Search_URL__c
				FROM SCIMS_Setting__mdt
				WHERE Active__c = true
				LIMIT 1
			];
			String returnUrl = setting.Return_URL__c;
			String orgName = setting.Org_Name__c;
			String orgUrl = System.URL.getSalesforceBaseUrl().getHost();
			String endUrl = 'https://' + orgUrl;
			String fullOrgUrl = URL.getSalesforceBaseUrl().toExternalForm();

			System.assertEquals('<StateFIPSCode>51</StateFIPSCode>', controller.stateFIPSCode);
			System.assertEquals('<CountyFIPSCode>059</CountyFIPSCode>', controller.countyFIPSCode);
			System.assertEquals(returnUrl, controller.returnURL);
			System.assertEquals('test@fsa.prod', controller.uniqueIdentifier);
			System.assertEquals(orgName, controller.orgName);
			System.assertEquals(orgUrl, controller.orgHost);
			System.assertEquals(endUrl, controller.endurl);
			System.assertEquals(fullOrgUrl, controller.fullOrgUrl);
		}

		fsaUser.FederationIdentifier = '0123456789';
		update fsaUser;

		System.runAs(fsaUser) {
			controller = new FSA_BTO_SCIMSSearchController();
			controller.init();

			System.assertEquals(fsaUser.FederationIdentifier, controller.uniqueIdentifier);

			FSA_BTO_SCIMSSearchController.setTimeZone('America/Los_Angeles');
			User thisUser = [SELECT TimeZoneSidKey FROM User WHERE Id =: UserInfo.getUserId()];
			System.assertEquals('America/Los_Angeles', thisUser.TimeZoneSidKey);
		}
	}
}
@IsTest(SeeAllData=true)
public with sharing class FSA_BTO_SCIMSSearchControllerTest {
    public static testMethod void testSetSCIMSSearchLocationDefault() {
        Site site = [SELECT Subdomain FROM Site WHERE Name='FSA_BTO_SCIMSSearchResultsInbound'];
        FSA_BTO_SCIMSSearchController controller;

        Profile fsaUserProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User' LIMIT 1];
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
            controller.orgUrl = 'fsa--dev';
            controller.init();
            String returnUrl = 'https://dev-' + site.Subdomain + '.cs32.force.com/';

            System.assertEquals('<StateFIPSCode>51</StateFIPSCode>', controller.stateFIPSCode);
            System.assertEquals('<CountyFIPSCode>059</CountyFIPSCode>', controller.countyFIPSCode);
            System.assertEquals(returnUrl, controller.returnURL);
            System.assertEquals('test@fsa.prod', controller.uniqueIdentifier);          
            System.assertEquals('FSA BTO DEV SANDBOX', controller.orgName);
            System.assertEquals('fsa--dev', controller.orgHost);
            System.assertEquals('https://fsa--dev', controller.endURL);

            controller.orgUrl = 'fsa--test';
            controller.init();
            returnUrl = 'https://test-' + site.Subdomain + '.cs32.force.com/';
            System.assertEquals(returnUrl, controller.returnURL);
            System.assertEquals('FSA BTO TEST SANDBOX', controller.orgName);
            System.assertEquals('fsa--test', controller.orgHost);
            System.assertEquals('https://fsa--test', controller.endURL);

            controller.orgUrl = 'fsa--fsapreprod';
            controller.init();
            returnUrl = 'https://fsapreprod-' + site.Subdomain + '.cs33.force.com/';
            System.assertEquals(returnUrl, controller.returnURL);
            System.assertEquals('FSA BTO PREPROD SANDBOX', controller.orgName);
            System.assertEquals('fsa--fsapreprod', controller.orgHost.toLowerCase());
            System.assertEquals('https://fsa--fsapreprod', controller.endURL);
        }
        fsaUser.FederationIdentifier = '0123456789';
        update fsaUser;
        System.runAs(fsaUser) {  
            controller = new FSA_BTO_SCIMSSearchController();
            controller.orgUrl = 'fsa--c';
            controller.init();
            String returnUrl = 'https://' + site.Subdomain + '.secure.force.com/';
            System.assertEquals(returnUrl, controller.returnURL);
            System.assertEquals('0123456789', controller.uniqueIdentifier);         
            System.assertEquals('FSA BTO PRODUCTION', controller.orgName);
            System.assertEquals('fsa--c', controller.orgHost);
            System.assertEquals('https://fsa--c', controller.endURL);

            FSA_BTO_SCIMSSearchController.setTimeZone('America/Los_Angeles');
            User thisUser = [SELECT TimeZoneSidKey FROM User WHERE Id =: UserInfo.getUserId()];
            System.assertEquals('America/Los_Angeles', thisUser.TimeZoneSidKey);        
        }
    }
}
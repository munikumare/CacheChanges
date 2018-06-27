@IsTest
public with sharing class FSA_BTO_UserHandlerTest {
    public static testMethod void testHandleUser() {
        String orgUrl = System.URL.getSalesforceBaseUrl().getHost();
        String userNameAppend;
        if(orgUrl.containsIgnoreCase('fsa--dev')) {
            userNameAppend = '@fsa.dev';
        } else if(orgUrl.containsIgnoreCase('fsa--test')) {
            userNameAppend = '@fsa.test';
        } else if(orgUrl.containsIgnoreCase('fsa--fsapreprod')) {
            userNameAppend = '@fsa.preprod';
        } else if(orgUrl.containsIgnoreCase('fsa--c') || orgUrl.containsIgnoreCase('fsa.my')) {
            userNameAppend = '@fsa.prod';
        }

        Map<String,String> attributes = new Map<String,String>();
                
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User sysAdminUser = new User(Alias='Test', Email='TestAdmin@usda.gov', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LastName='SysAdmin', LocaleSidKey='en_US', ProfileId=sysAdminProfile.Id, TimeZoneSidKey='America/New_York', UserName='testadmin@usda.gov');
        insert sysAdminUser;

        Profile fsaBtoUserProfile = [SELECT Id FROM Profile WHERE Name='FSA BTO User'];
        UserRole fsaBtoUserRole = [SELECT Id FROM UserRole WHERE Name='FSA BTO'];
        
        Profile fsaBtoResourceManagerProfile = [SELECT Id FROM Profile WHERE Name='FSA BTO Resource Manager'];
        UserRole fsaBtoResourceManagerRole = [SELECT Id FROM UserRole WHERE Name='FSA BTO Resource Manager'];
        
        Profile fsaBtoPartnerProfile = [SELECT Id FROM Profile WHERE Name='Content Partner Community Login User'];

        System.runAs(sysAdminUser) {
            FSA_BTO_UserHandler handler = new FSA_BTO_UserHandler();

            attributes.put('USDAAPPROLES', 'FSA_BTO_USER');
            attributes.put('USDALASTNAME', 'Wong');
            attributes.put('USDAFIRSTNAME', 'James');
            attributes.put('USDAMIDDLENAME', 'P');
            attributes.put('USDAEAUTHID', '01234567898765432101234');
            // see ICAM DataCatalog spreadsheet for group type/agency code definitions
            attributes.put('USDAAGENCYCODE', 'E_EO:EO^E_FA:FA^E_18:18^E_CE:CE^E_11:11');

            /* 
             * USA GLC spreadsheet download: http://www.gsa.gov/portal/getMediaData?mediaId=214171
             * 27 = MN (State)
             * 0930 = St. Paul (City)
             * 123 = (County)
             */
            attributes.put('USDAFIPSCODE', 'E_EO:123454321^E_FA:276330123^E_18:543210123^E_CE:276330123^E_11:987654321');        
            attributes.put('USDAEMAIL', 'test12345@wdc.usda.gov');

            // change this
            SamlSsoConfig ssoConfig = [SELECT Id FROM SamlSsoConfig WHERE DeveloperName='USDA_SAML2_eAuth_CERT_IDP'];
            
            // test county data sample taken from FSA Offices spreadsheet provided by Glenn
            FSA_BTO_County__c testCounty1 = new FSA_BTO_County__c(Name='Ramsey County', FSA_BTO_FIPS_Code__c='27123', FSA_BTO_StreetAddress__c='PO BOX 129', FSA_BTO_City__c='FARMINGTON', FSA_BTO_State__c='MN', FSA_BTO_Zip_Code__c='55024-0129');
            FSA_BTO_County__c testCounty2 = new FSA_BTO_County__c(Name='Fairfax County ', FSA_BTO_FIPS_Code__c='51059', FSA_BTO_StreetAddress__c='98 ALEXANDRIA PIKE', FSA_BTO_City__c='WARRENTON', FSA_BTO_State__c='VA', FSA_BTO_Zip_Code__c='20186-2835');
            insert testCounty1;
            insert testCounty2;

            User returnedNewFsaUser = handler.createUser(ssoConfig.Id, null, null, '01234567898765432101234', attributes, 'blahblahblah');
            System.assertEquals('01234567898765432101234', returnedNewFsaUser.FederationIdentifier);
            System.assertEquals(fsaBtoUserProfile.Id, returnedNewFsaUser.ProfileId);
            System.assertEquals(fsaBtoUserRole.Id, returnedNewFsaUser.UserRoleId);
            System.assertEquals(true, returnedNewFsaUser.UserPermissionsSupportUser);
            System.assertEquals(true, returnedNewFsaUser.UserPermissionsSFContentUser);
            //System.assertEquals(true, returnedNewFsaUser.UserPermissionsKnowledgeUser);
            System.assertEquals('James', returnedNewFsaUser.FirstName);
            System.assertEquals('Wong', returnedNewFsaUser.LastName);
            System.assertEquals('JWong', returnedNewFsaUser.Alias);
            System.assertEquals('test12345@wdc.usda.gov', returnedNewFsaUser.Email);
            System.assertEquals('test12345', returnedNewFsaUser.CommunityNickname);
            System.assertEquals('UTF-8', returnedNewFsaUser.EmailEncodingKey);
            System.assertEquals('en_US', returnedNewFsaUser.LanguageLocaleKey);
            System.assertEquals('en_US', returnedNewFsaUser.LocaleSidKey);
            System.assertEquals('America/New_York', returnedNewFsaUser.TimeZoneSidKey);
            System.assertEquals('27123', returnedNewFsaUser.FSA_BTO_FIPS_Code__c);
            System.assertEquals('Ramsey County', returnedNewFsaUser.FSA_BTO_Office_County__c);
            System.assertEquals('PO BOX 129', returnedNewFsaUser.Street);
            System.assertEquals('FARMINGTON', returnedNewFsaUser.City);
            System.assertEquals('MN', returnedNewFsaUser.StateCode);
            System.assertEquals('55024-0129', returnedNewFsaUser.PostalCode);
            System.assertEquals(false, returnedNewFsaUser.isActive);
            
            // including both approles
            attributes.remove('USDAAPPROLES');
            attributes.put('USDAAPPROLES', 'FSA_BTO_USER^FSA_BTO_Resource-Manager');
            // removing E_FA:FA
            attributes.remove('USDAAGENCYCODE');
            attributes.put('USDAAGENCYCODE', 'E_EO:EO^E_18:18^E_CE:CE^E_11:11');
            User returnedNewFsaResourceManager = handler.createUser(ssoConfig.Id, null, null, '01234567898765432101234', attributes, 'blahblahblah');
            System.assertEquals(fsaBtoResourceManagerProfile.Id, returnedNewFsaResourceManager.ProfileId);
            System.assertEquals(fsaBtoResourceManagerRole.Id, returnedNewFsaResourceManager.UserRoleId);
            insert returnedNewFsaResourceManager;
            
            // removing bto_user approle, adding BTO Admin role, removing email
            User updatedResourceManager = [SELECT Id FROM User WHERE FederationIdentifier = '01234567898765432101234'];
            attributes.remove('USDAAPPROLES');
            attributes.remove('USDAEMAIL');
            attributes.put('USDAAPPROLES', 'FSA_BTO_Resource-Manager^FSA_BTO_TimbaSurveyAdmin');
            handler.updateUser(returnedNewFsaResourceManager.Id, ssoConfig.Id, null, null, '01234567898765432101234', attributes, 'blahblahblah');
            User updatedFsaResourceManager = [SELECT ProfileId, UserRoleId, Email, Username, CommunityNickname FROM User WHERE Id =: returnedNewFsaResourceManager.Id];
            System.assertEquals(fsaBtoResourceManagerProfile.Id, updatedFsaResourceManager.ProfileId);
            System.assertEquals(fsaBtoResourceManagerRole.Id, updatedFsaResourceManager.UserRoleId);
            System.assertEquals('no_email@usda.gov', updatedFsaResourceManager.Email);
            String userNameTest = '01234567898765432101234' + userNameAppend;
            System.assertEquals(userNameTest, updatedFsaResourceManager.Username);
            List<PermissionSetAssignment> newPSA = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: returnedNewFsaResourceManager.Id];
            System.assertNotEquals(null, newPSA);         
            //insert returnedNewFsaResourceManager;
        
            // removing resource-manager approle, adding knowledgeuser approle
            User updatedUser = [SELECT Id FROM User WHERE FederationIdentifier='01234567898765432101234'];
            attributes.remove('USDAAPPROLES');
            attributes.put('USDAAPPROLES', 'FSA_BTO_Resource-Manager^FSA_BTO_KnowledgeUser');
            attributes.remove('USDAFIPSCODE');
            handler.updateUser(updatedUser.Id, ssoConfig.Id, null, null, '01234567898765432101234', attributes, 'blahblahblah');
            updatedUser = [SELECT FirstName, FSA_BTO_FIPS_Code__c, Title, Division, UserPermissionsKnowledgeUser FROM User WHERE FederationIdentifier='01234567898765432101234'];
            System.assertEquals(true, updatedUser.UserPermissionsKnowledgeUser);
            
            Network partnerCommunity = [SELECT Id FROM Network WHERE Name='USDA FSA BTO Partner Community'];
            attributes.remove('USDAAPPROLES');
            attributes.remove('USDALASTNAME');
            attributes.put('USDALASTNAME', 'Agamemnon');
            attributes.put('USDAAPPROLES', 'FSA_BTO_PARTNER');
            User returnedNewFsaPartner = handler.createUser(ssoConfig.Id, partnerCommunity.Id, null, '28702015101602212632180', attributes, 'blahblahblah');
            System.assertEquals(fsaBtoPartnerProfile.Id, returnedNewFsaPartner.ProfileId);
            System.assertEquals('JAgamemn', returnedNewFsaPartner.Alias);
        }
    }
}
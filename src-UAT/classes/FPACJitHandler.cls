global class FPACJitHandler implements Auth.SamlJitHandler {
    private class JitException extends Exception{}

    private void handleUser(Boolean create, User handledUser, Map<String, String> attributes, String federationIdentifier, boolean isStandard) {
        String orgUrl = System.URL.getSalesforceBaseUrl().getHost();
        String userNameAppend;

        if(orgUrl.containsIgnoreCase('fsa--dev') || orgUrl.containsIgnoreCase('dev-fsa')) {
            userNameAppend = '@fsa.dev';
        } else if(orgUrl.containsIgnoreCase('fsa--test') || orgUrl.containsIgnoreCase('test-fsa')) {
            userNameAppend = '@fsa.test';
        } else if(orgUrl.containsIgnoreCase('fsa--fsapreprod') || orgUrl.containsIgnoreCase('fsapreprod-fsa')) {
            userNameAppend = '@fsa.preprod';
        } else if(orgUrl.containsIgnoreCase('fsa--c') || orgUrl.containsIgnoreCase('fsa.my') || orgUrl.containsIgnoreCase('fsa-usda.force')) {
            userNameAppend = '@fsa.prod';
        }else{
            userNameAppend='@fsatest.gov';
        }
		System.debug('attributes: ' + attributes);
        if(create) {
            if(attributes.containsKey('USDAEAUTHID')) {
                handledUser.FederationIdentifier = attributes.get('USDAEAUTHID');
            } else {
                handledUser.FederationIdentifier = federationIdentifier;
            }
            if(attributes.containsKey('USDAFIRSTNAME') && attributes.containsKey('USDALASTNAME')) {
                handledUser.FirstName = attributes.get('USDAFIRSTNAME');
                handledUser.LastName = attributes.get('USDALASTNAME'); 
                
                if(handledUser.LastName.length() >= 7) {
                    handledUser.Alias = handledUser.FirstName.substring(0,1) + handledUser.LastName.substring(0,7);
                } else {
                    handledUser.Alias = handledUser.FirstName.substring(0,1) + handledUser.LastName;
                }
            }
        }
        for (String key : attributes.keySet()) {
            System.debug(key + ': ' + attributes.get(key));
        }
        System.debug('BEFORE PROLES');
        if(attributes.containsKey('USDAAPPROLES')) {
            System.debug('IN PROLES');
            Profile fpaceProfile = new Profile();
            UserRole fpacUserRole = new UserRole();
            String role = attributes.get('USDAAPPROLES');
            String employeeStatus = attributes.get('USDAEMPLOYEESTATUS');
            
            if (isStandard) {
            // if(!role.contains('FSA_BTO_PARTNER') && !role.contains('FSA_BTO_Super-Partner-User') && isStandard && String.isNotBlank(employeeStatus)) {
                handledUser.Username = attributes.get('USDAEAUTHID') + userNameAppend;
                
                if(attributes.containsKey('USDAEMAIL')) {
                    handledUser.Email = attributes.get('USDAEMAIL');
                    
                    if(create) {
                        String nickname = handledUser.Email.substringBefore('@');
                        
                        String query = 'SELECT Id, CommunityNickname FROM User WHERE CommunityNickname LIKE \'' + nickname + '%\'';
                        
                        List<User> users = Database.query(query);

                        if(!users.isEmpty()) {
                            Integer i = users.size() + 1;
                            handledUser.CommunityNickname = handledUser.Email.substringBefore('@') + i;
                        } else {
                            handledUser.CommunityNickname = nickname;
                        }
                    }
                } else {
                    handledUser.Email = 'no_email@usda.gov';
                    if(create) {
                        handledUser.CommunityNickname = handledUser.Username.substringBefore('@');
                    }
                }

                handledUser.UserPermissionsSupportUser = true;
                handledUser.UserPermissionsSFContentUser = true;
                handledUser.FSA_BTO_Agreed_to_Terms_and_Conditions__c = true;
                
                if (role.contains('FSA_BTO_Resource-Manager') && role.contains('FSA_BTO_USER')) { 
                    fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'FPAC Manager Base'];
                    fpacUserRole = [SELECT Id from UserRole WHERE Name = 'FPAC Manager'];
                } else if(role.contains('FSA_BTO_Resource-Manager')) {
                    fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'FPAC Manager Base'];
                    fpacUserRole = [SELECT Id from UserRole WHERE Name = 'FPAC Manager'];
                } else if(role.contains('FSA_BTO_USER')) {
                    fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'FPAC Employee Base'];
                    fpacUserRole = [SELECT Id from UserRole WHERE Name = 'FPAC Employee'];
                }  else {
                    fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'FPAC Employee Base'];
                    fpacUserRole = [SELECT Id from UserRole WHERE Name = 'FPAC Employee'];
                }

                handledUser.UserRoleId = fpacUserRole.Id;
                
                if(role.contains('FSA_BTO_KnowledgeUser')) {
                    handledUser.UserPermissionsKnowledgeUser = true;
                } else {
                    handledUser.UserPermissionsKnowledgeUser = false;
                }
                
                if(role.contains('FSA_BTO_BridgesAdmin')) {
                    Boolean hasAdminPermissions = false;
                    List<PermissionSetAssignment> existingPSA = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId()];
                    PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'FSA_BTO_BridgesAdmin'];  
                    
                    if(!existingPSA.isEmpty()) {
                        for(PermissionSetAssignment psa: existingPSA) {
                            if(psa.PermissionSetId == ps.Id) {
                                hasAdminPermissions = true;
                            }
                        }
                    }
                    
                    if(existingPSA.isEmpty() || hasAdminPermissions == false) {
                        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId=UserInfo.getUserId(), PermissionSetId=ps.Id);
                        insert psa;
                    }
                }

                handledUser.CompanyName = 'USDA';
                
                if(attributes.containsKey('USDAAGENCYCODE')) {
                    System.debug('NOT PARTNER');
                    String usdaAgencyCode = attributes.get('USDAAGENCYCODE');
                    String parsedAgencyCode;
                    if(usdaAgencyCode.contains('FA')) {
                        parsedAgencyCode = usdaAgencyCode.substringBefore(':FA');
                    }
                    if(String.isEmpty(parsedAgencyCode) && usdaAgencyCode.contains('CE')) {
                        parsedAgencyCode = usdaAgencyCode.substringBefore(':CE');
                    }
                    if(!String.isEmpty(parsedAgencyCode) && parsedAgencyCode.contains('^')) {
                        parsedAgencyCode = parsedAgencyCode.substringAfterLast('^');
                    }
                    if(!String.isEmpty(parsedAgencyCode)) {
                        String agencyCode = parsedAgencyCode.substring(2,4);

                        if(agencyCode == 'FA') {
                            handledUser.Division = 'FSA';
                        } else if(agencyCode == 'CE') {
                            handledUser.Division = 'FSA County Office';
                        }
                    } else {
                        handledUser.Division = 'Non-FSA';     
                    }
                }
                
                if(create && attributes.containsKey('USDAFIPSCODE')) {
                    String usdaFipsCode = attributes.get('USDAFIPSCODE');
                    String parsedFipsCode;
                    
                    
                    if(usdaFipsCode.contains('FA')) {
                        parsedFipsCode = usdaFipsCode.substringAfter('_FA:');
                    }
                    if(String.isEmpty(parsedFipsCode) && usdaFipsCode.contains('CE')) {
                        parsedFipsCode = usdaFipsCode.substringAfter('_CE:');
                    }
                    if(!String.isEmpty(parsedFipsCode) && parsedFipsCode.contains('^')) {
                        parsedFipsCode = parsedFipsCode.substringBefore('^');
                    }
                    if(!String.isEmpty(parsedFipsCode)) {
                        if(parsedFipsCode.length() == 9) {
                            handledUser.FSA_BTO_FIPS_Code__c = parsedFipsCode.substring(0,2) + parsedFipsCode.substring(6,9);
                        } else if(parsedFipsCode.length() == 5) {
                            handledUser.FSA_BTO_FIPS_Code__c = parsedFipsCode;
                        }
                        if(handledUser.FSA_BTO_FIPS_Code__c != null) {
                            List<FSA_BTO_County__c> counties = [SELECT Name, FSA_BTO_StreetAddress__c, FSA_BTO_City__c, FSA_BTO_State__c, FSA_BTO_Zip_Code__c, FSA_BTO_Phone__c FROM FSA_BTO_County__c WHERE FSA_BTO_FIPS_Code__c =: handledUser.FSA_BTO_FIPS_Code__c LIMIT 1];
                            if(!counties.isEmpty()) {
                                handledUser.Street = counties[0].FSA_BTO_StreetAddress__c;
                                handledUser.City = counties[0].FSA_BTO_City__c;
                                handledUser.StateCode = counties[0].FSA_BTO_State__c;
                                handledUser.PostalCode = counties[0].FSA_BTO_Zip_Code__c;
                                handledUser.FSA_BTO_Office_County__c = counties[0].Name;
                                handledUser.Phone = counties[0].FSA_BTO_Phone__c;
                            }
                        }
                    }
                }  
            } else {
                //partner
                System.debug('PARTNER');
                List<Contact> queriedContactList = new List<Contact>();

                handledUser.Username = attributes.get('USDAEAUTHID') + userNameAppend;
                
                if(attributes.containsKey('USDAEMAIL')) {
                    handledUser.Email = attributes.get('USDAEMAIL');
                    
                    if(create) {
                        String nickname = handledUser.Email.substringBefore('@');
                        
                        String query = 'SELECT Id, CommunityNickname FROM User WHERE CommunityNickname LIKE \'' + nickname + '%\'';
                        
                        List<User> users = Database.query(query);

                        if(!users.isEmpty()) {
                            Integer i = users.size() + 1;
                            handledUser.CommunityNickname = handledUser.Email.substringBefore('@') + i;
                        } else {
                            handledUser.CommunityNickname = nickname;
                        }
                    }
                } else {
                    handledUser.Email = 'no_email@usda.gov';
                    if(create) {
                        handledUser.CommunityNickname = handledUser.Username.substringBefore('@');
                    }
                }
                
                String scims = attributes.get('USDASCIMS');
                System.debug(scims);
                if(!Test.isRunningTest()) {
                    queriedContactList = [SELECT Id, Account.Name, RecordType.Id, MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, FSA_BTO_Accepts_Referrals__c, FSA_BTO_Specializes_In__c, FSA_BTO_Title__c, Phone, MobilePhone FROM Contact WHERE FSA_BTO_Core_Customer_ID__c != null AND FSA_BTO_Core_Customer_ID__c =: scims];
                } else {
                    Account partnerAccount = new Account(Name='Test Partner Account');
                    insert partnerAccount;
                    Contact partnerContact = new Contact(LastName='PartnerTest', Email='fake@email.com', AccountId=partnerAccount.Id, MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States', FSA_BTO_Accepts_Referrals__c = true, FSA_BTO_Specializes_In__c = 'beef', FSA_BTO_Title__c = 'Manager', Phone='1111111111', MobilePhone='2222222222');
                    insert partnerContact;
                    queriedContactList.add(partnerContact);
                }
                if(!queriedContactList.isEmpty()) {
                    System.debug(queriedContactList);
                    System.debug('QUERIED');
                    if(create) {
                        handledUser.ContactId = queriedContactList[0].Id;
                    }
                    if(!String.isEmpty(queriedContactList[0].Account.Name)) handledUser.CompanyName = queriedContactList[0].Account.Name;
                    if(!String.isEmpty(queriedContactList[0].FSA_BTO_Title__c)) handledUser.Title = queriedContactList[0].FSA_BTO_Title__c;
                    if(!String.isEmpty(queriedContactList[0].Phone)) handledUser.Phone = queriedContactList[0].Phone;
                    if(!String.isEmpty(queriedContactList[0].MobilePhone)) handledUser.MobilePhone = queriedContactList[0].MobilePhone;
                    if(!String.isEmpty(queriedContactList[0].MailingStreet)) handledUser.Street = queriedContactList[0].MailingStreet;
                    if(!String.isEmpty(queriedContactList[0].MailingCity)) handledUser.City = queriedContactList[0].MailingCity;
                    if(!String.isEmpty(queriedContactList[0].MailingStateCode)) handledUser.StateCode = queriedContactList[0].MailingStateCode;
                    if(!String.isEmpty(queriedContactList[0].MailingPostalCode)) handledUser.PostalCode = queriedContactList[0].MailingPostalCode; 
                    if(!String.isEmpty(queriedContactList[0].FSA_BTO_Specializes_In__c)) handledUser.FSA_BTO_Specializes_In__c = queriedContactList[0].FSA_BTO_Specializes_In__c;
                } else {
                    System.debug('NOT QUERIED');
                    if (create) {
                        Contact newContact = new Contact();
                        newContact.FSA_BTO_Core_Customer_ID__c = scims;
                        if(!String.isEmpty(handledUser.LastName)) newContact.LastName = handledUser.LastName;
                        if(!String.isEmpty(handledUser.FirstName)) newContact.FirstName = handledUser.FirstName;
                        if(!String.isEmpty(handledUser.Email)) newContact.Email = handledUser.Email;

                        String street = attributes.get('USDASTREETADDRESS');
                        String state = attributes.get('USDASTATE');
                        String zip = attributes.get('USDAZIP');
                        String city = attributes.get('USDACITY');
                        String country = attributes.get('USDACOUNTRY');

                        //newContact.MailingCity = city;
                        //newContact.MailingState = state;
                        //newContact.MailingStreet = street;
                        //newContact.MailingPostalCode = zip;
                        //newContact.MailingCountry = country;

                        newContact.MailingCity = 'Cleveland';
                        newContact.MailingState = 'Ohio';
                        newContact.MailingStreet = '1234 Placeholder';
                        newContact.MailingPostalCode = '44134';
                        //newContact.MailingCountry = 'US';

                        insert newContact;

                        Contact queryTest = [SELECT AccountId FROM Contact WHERE Id = :newContact.Id];
                        System.debug('TEST');
                        System.debug(queryTest);

                        handledUser.ContactId = newContact.Id;
                    } else {
                        System.debug('NOT CREATE');
                    }

                }
                //if(role.contains('FSA_BTO_Super-Partner-User')) {
                //    handledUser.UserPermissionsSFContentUser = true;
                //    handledUser.Username = attributes.get('USDAEAUTHID') + userNameAppend + '.superpartner';
                //    fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Super Partner'];                   
                //} else if(role.contains('FSA_BTO_PARTNER')) {
                //    handledUser.Username = attributes.get('USDAEAUTHID') + userNameAppend + '.partner';
                //    fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'Content Partner Community Login User'];                   
                //}

                fpaceProfile = [SELECT Id FROM Profile WHERE Name = 'FPAC Customer'];                
            } 

            System.debug('profile: ' + fpaceProfile);
            handledUser.ProfileId = fpaceProfile.Id;
        }
        
        handledUser.EmailEncodingKey = 'UTF-8';
        handledUser.LanguageLocaleKey = 'en_US';
        handledUser.LocaleSidKey = 'en_US';
        handledUser.TimeZoneSidKey = 'America/New_York';
        
        System.debug('PRE CREATE');
        if(!create) {
            System.debug('UPDATE USER 2');
            update(handledUser);
        }
    }

    private void handleJit(boolean create, User handledUser, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        System.debug('Handle JIT');
        if(communityId != null || portalId != null) {
            handleUser(create, handledUser, attributes, federationIdentifier, false);
        } else {
            handleUser(create, handledUser, attributes, federationIdentifier, true);
        }
    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        System.debug('CREATE USER');
        User handledUser = new User();
        handleJit(true, handledUser, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
        return handledUser;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        System.debug('UPDATE USER');
        User handledUser = [SELECT Id FROM User WHERE Id=:userId];
        handleJit(false, handledUser, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
    }
}
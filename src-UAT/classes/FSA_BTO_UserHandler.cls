global class FSA_BTO_UserHandler implements Auth.SamlJitHandler {
    private class JitException extends Exception{}
    
    private void handleUser(boolean create, User u, Map<String, String> attributes, String federationIdentifier, boolean isStandard) {
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
        if(create) {
            if(attributes.containsKey('USDAEAUTHID')) {
                u.FederationIdentifier = attributes.get('USDAEAUTHID');
            } else {
                u.FederationIdentifier = federationIdentifier;
            }
            if(attributes.containsKey('USDAFIRSTNAME') && attributes.containsKey('USDALASTNAME')) {
                u.FirstName = attributes.get('USDAFIRSTNAME');
                u.LastName = attributes.get('USDALASTNAME'); // required
                // required, max length 8, non-unique
                if(u.LastName.length() >= 7) {
                    u.Alias = u.FirstName.substring(0,1) + u.LastName.substring(0,7);
                } else {
                    u.Alias = u.FirstName.substring(0,1) + u.LastName;
                }
            }
        }
        if(attributes.containsKey('USDAAPPROLES')) {
            Profile p = new Profile();
            UserRole ur = new UserRole();
            String role = attributes.get('USDAAPPROLES');
            
            // FSA BTO Users, Resource Managers
            if(!role.contains('FSA_BTO_PARTNER') && !role.contains('FSA_BTO_Super-Partner-User') && isStandard) {
                u.Username = attributes.get('USDAEAUTHID') + userNameAppend;
                // some employees might not have emails in eauth...
                if(attributes.containsKey('USDAEMAIL')) {
                    u.Email = attributes.get('USDAEMAIL');
                    
                    if(create) {
                        String nickname = u.Email.substringBefore('@');
                        
                        String query = 'SELECT Id, CommunityNickname FROM User WHERE CommunityNickname LIKE \'' + nickname + '%\'';
                        // check for existing nickname
                        List<User> users = Database.query(query);

                        if(!users.isEmpty()) {
                            Integer i = users.size() + 1;
                            u.CommunityNickname = u.Email.substringBefore('@') + i;
                        } else {
                            u.CommunityNickname = nickname;
                        }
                    }
                } else {
                    u.Email = 'no_email@usda.gov';
                    if(create) u.CommunityNickname = u.Username.substringBefore('@');
                }

                // assign feature licenses to FSA BTO RMs and Users
                u.UserPermissionsSupportUser = true;
                u.UserPermissionsSFContentUser = true;
                
                // custom fields
                u.FSA_BTO_Agreed_to_Terms_and_Conditions__c = true;
                
                
                if(role.contains('FSA_BTO_Resource-Manager') && role.contains('FSA_BTO_USER')) {
                    p = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Resource Manager'];
                    ur = [SELECT Id from UserRole WHERE Name = 'FSA BTO Resource Manager'];
                } else if(role.contains('FSA_BTO_Resource-Manager')) {
                    p = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Resource Manager'];
                    ur = [SELECT Id from UserRole WHERE Name = 'FSA BTO Resource Manager'];
                } else if(role.contains('FSA_BTO_USER')) {
                    p = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User'];
                    ur = [SELECT Id from UserRole WHERE Name = 'FSA BTO'];
                } // else throw exception - not a valid usdaapprole
                u.UserRoleId = ur.Id;
                
                // assign/remove knowledge permissions due to limited licenses
                if(role.contains('FSA_BTO_KnowledgeUser')) {
                    u.UserPermissionsKnowledgeUser = true;
                } else {
                    u.UserPermissionsKnowledgeUser = false;
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

                u.CompanyName = 'USDA';
                
                if(attributes.containsKey('USDAAGENCYCODE')) {
                    String usdaAgencyCode = attributes.get('USDAAGENCYCODE');
                    String parsedAgencyCode;
                    if(usdaAgencyCode.contains('FA')) {
                        parsedAgencyCode = usdaAgencyCode.substringBefore(':FA');
                        System.debug('FSA Agency Code: ' + parsedAgencyCode);
                    }
                    if(String.isEmpty(parsedAgencyCode) && usdaAgencyCode.contains('CE')) {
                        parsedAgencyCode = usdaAgencyCode.substringBefore(':CE');
                        System.debug('FSA CO Agency Code: ' + parsedAgencyCode);
                    }
                    if(!String.isEmpty(parsedAgencyCode) && parsedAgencyCode.contains('^')) {
                        parsedAgencyCode = parsedAgencyCode.substringAfterLast('^');
                    }
                    if(!String.isEmpty(parsedAgencyCode)) {
                        /*
                        Map<String,String> groupTypeMap = new Map<String,String>();
                        //Map<String,String> agencyMap = new Map<String,String>();
                        groupTypeMap.put('E', 'Employee');
                        groupTypeMap.put('C', 'Contractor');
                        groupTypeMap.put('A', 'Affiliate');
                        groupTypeMap.put('V', 'Volunteer');
                        groupTypeMap.put('I', 'Intern');
                        groupTypeMap.put('F', 'Fellow');
                        */
                        
                        //String groupTypeCode = parsedAgencyCode.substring(0,1);
                        String agencyCode = parsedAgencyCode.substring(2,4);
                        
                        //u.Title = groupTypeMap.get(groupTypeCode);
                        
                        if(agencyCode == 'FA') {
                            u.Division = 'FSA';
                        } else if(agencyCode == 'CE') {
                            u.Division = 'FSA County Office';
                        }
                    } else {
                        //u.Title = 'Unknown FSA';        
                        u.Division = 'Non-FSA';     
                    }
                }
                
                if(create && attributes.containsKey('USDAFIPSCODE')) {
                    String usdaFipsCode = attributes.get('USDAFIPSCODE');
                    String parsedFipsCode;
                    
                    // can possibly have multiple FIPS Code in eAuth profile, use one that's prepended with FA (FSA) or CE (FSACO), using FA if there's both...
                    if(usdaFipsCode.contains('FA')) {
                        parsedFipsCode = usdaFipsCode.substringAfter('_FA:');
                        System.debug('FSA FIPS Code: ' + parsedFipsCode);
                    }
                    if(String.isEmpty(parsedFipsCode) && usdaFipsCode.contains('CE')) {
                        parsedFipsCode = usdaFipsCode.substringAfter('_CE:');
                        System.debug('FSA CO FIPS Code: ' + parsedFipsCode);
                    }
                    if(!String.isEmpty(parsedFipsCode) && parsedFipsCode.contains('^')) {
                        parsedFipsCode = parsedFipsCode.substringBefore('^');
                    }
                    if(!String.isEmpty(parsedFipsCode)) {
                        if(parsedFipsCode.length() == 9) {
                            u.FSA_BTO_FIPS_Code__c = parsedFipsCode.substring(0,2) + parsedFipsCode.substring(6,9);
                        } else if(parsedFipsCode.length() == 5) {
                            u.FSA_BTO_FIPS_Code__c = parsedFipsCode;
                        }
                        System.debug('FIPS Code 5: ' + u.FSA_BTO_FIPS_Code__c);
                        if(u.FSA_BTO_FIPS_Code__c != null) {
                            List<FSA_BTO_County__c> counties = [SELECT Name, FSA_BTO_StreetAddress__c, FSA_BTO_City__c, FSA_BTO_State__c, FSA_BTO_Zip_Code__c, FSA_BTO_Phone__c FROM FSA_BTO_County__c WHERE FSA_BTO_FIPS_Code__c =: u.FSA_BTO_FIPS_Code__c LIMIT 1];
                            if(!counties.isEmpty()) {
                                u.Street = counties[0].FSA_BTO_StreetAddress__c;
                                u.City = counties[0].FSA_BTO_City__c;
                                u.StateCode = counties[0].FSA_BTO_State__c;
                                u.PostalCode = counties[0].FSA_BTO_Zip_Code__c;
                                u.FSA_BTO_Office_County__c = counties[0].Name;
                                u.Phone = counties[0].FSA_BTO_Phone__c;
                            }
                        }
                    }
                }
                            
                /*
                // deactivate inactive employees
                if(attributes.containsKey('USDAEMPLOYEESTATUS')) {
                    String employeeStatus = attributes.get('USDAEMPLOYEESTATUS');
                    System.debug('Employee status: ' + employeeStatus);
                    String fsaEmployeeStatus;
                    String fsaCOEmployeeStatus;
                    if(employeeStatus.contains('FA:')) {
                        fsaEmployeeStatus = employeeStatus.substringAfter('_FA:');
                        if(!String.isEmpty(fsaEmployeeStatus) && fsaEmployeeStatus.contains('^')) {
                            fsaEmployeeStatus = fsaEmployeeStatus.substringBefore('^');
                        }
                        System.debug('fsaEmployeeStatus: ' + fsaEmployeeStatus);
                    }
                    if(employeeStatus.contains('CE:')) {
                        fsaCOEmployeeStatus = employeeStatus.substringAfter('_CE:');
                        if(!String.isEmpty(fsaCOEmployeeStatus) && fsaCOEmployeeStatus.contains('^')) {
                            fsaCOEmployeeStatus = fsaCOEmployeeStatus.substringBefore('^');
                        }
                        System.debug('fsaCOEmployeeStatus: ' + fsaCOEmployeeStatus);
                    }
                    if(fsaEmployeeStatus == 'A' || fsaCOEmployeeStatus == 'A') {
                        u.isActive = true;
                    }
                }
                */
            // partner users
            } else {
                List<Contact> c = new List<Contact>();
                // all partner users are external eauth users who should ALWAYS have an email address (according to ICAM_DataCatalog spreadsheet)
                u.Email = attributes.get('USDAEMAIL');
                if(!Test.isRunningTest()) {
                    c = [SELECT Id, Account.Name, MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, FSA_BTO_Accepts_Referrals__c, FSA_BTO_Specializes_In__c, FSA_BTO_Title__c, Phone, MobilePhone FROM Contact WHERE FSA_BTO_EnforceUniqueEmail__c =: u.Email];
                } else {
                    Account partnerAccount = new Account(Name='Test Partner Account');
                    insert partnerAccount;
                    Contact partnerContact = new Contact(LastName='PartnerTest', Email='fake@email.com', AccountId=partnerAccount.Id, MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States', FSA_BTO_Accepts_Referrals__c = true, FSA_BTO_Specializes_In__c = 'beef', FSA_BTO_Title__c = 'Manager', Phone='1111111111', MobilePhone='2222222222');
                    insert partnerContact;
                    c.add(partnerContact);
                }
                if(!c.isEmpty()) {
                    System.debug('Existing Partner Contact Id: ' + c[0].Id);
                    if(create) {
                        u.ContactId = c[0].Id;
                    }
                    if(!String.isEmpty(c[0].Account.Name)) u.CompanyName = c[0].Account.Name;
                    if(!String.isEmpty(c[0].FSA_BTO_Title__c)) u.Title = c[0].FSA_BTO_Title__c;
                    if(!String.isEmpty(c[0].Phone)) u.Phone = c[0].Phone;
                    if(!String.isEmpty(c[0].MobilePhone)) u.MobilePhone = c[0].MobilePhone;
                    if(!String.isEmpty(c[0].MailingStreet)) u.Street = c[0].MailingStreet;
                    if(!String.isEmpty(c[0].MailingCity)) u.City = c[0].MailingCity;
                    if(!String.isEmpty(c[0].MailingStateCode)) u.StateCode = c[0].MailingStateCode;
                    if(!String.isEmpty(c[0].MailingPostalCode)) u.PostalCode = c[0].MailingPostalCode; 
                    if(!String.isEmpty(c[0].FSA_BTO_Specializes_In__c)) u.FSA_BTO_Specializes_In__c = c[0].FSA_BTO_Specializes_In__c;
                }
                if(role.contains('FSA_BTO_Super-Partner-User')) {
                    u.UserPermissionsSFContentUser = true;
                    u.Username = attributes.get('USDAEAUTHID') + userNameAppend + '.superpartner';
                    p = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Super Partner'];                   
                } else if(role.contains('FSA_BTO_PARTNER')) {
                    u.Username = attributes.get('USDAEAUTHID') + userNameAppend + '.partner';
                    p = [SELECT Id FROM Profile WHERE Name = 'Content Partner Community Login User'];                   
                }
            } 
            u.ProfileId = p.Id;
        }
        
        // other required User fields
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'America/New_York';
        
        if(!create) {
            System.debug('updated user');
            update(u);
        }
    }

    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        if(communityId != null || portalId != null) {
            //String account = handleAccount(create, u, attributes);
            //handleContact(create, account, u, attributes);
            handleUser(create, u, attributes, federationIdentifier, false);
            System.debug('communityId: ' + communityId);
            System.debug('portalId: ' + portalId);
            System.debug('federationIdentifier: ' + federationIdentifier);
            System.debug('attributes: ' + attributes);
            System.debug('assertion: ' + assertion);
            System.debug('samlSsoProviderId: ' + samlSsoProviderId);
        } else {
            handleUser(create, u, attributes, federationIdentifier, true);
        }
    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        User u = new User();
        handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
        System.debug('communityId: ' + communityId);
        System.debug('portalId: ' + portalId);
        System.debug('federationIdentifier: ' + federationIdentifier);
        System.debug('attributes: ' + attributes);
        System.debug('assertion: ' + assertion);
        System.debug('samlSsoProviderId: ' + samlSsoProviderId);
        return u;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        User u = [SELECT Id FROM User WHERE Id=:userId];
        handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
    }
}
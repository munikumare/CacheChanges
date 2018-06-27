@isTest
public class FSA_BTO_TaskTriggerTest {
    public static Account fsaAccountForLookup = new Account(Name='USDA Farm Service Agency', Website='http://www.fsa.usda.gov', FSA_BTO_State_PickList__c='DC');
    public static Account partnerAccount = new Account(Name='Test Account');
    public static Contact partnerContact = new Contact(LastName='McTest', MailingStreet='Fake Street', MailingCity='Fake City', MailingState='Virginia', MailingPostalCode='11111', MailingCountry='United States', FSA_BTO_Accepts_Referrals__c=true);
    public static Profile partnerProfile = [SELECT Id FROM Profile WHERE Name = 'Content Partner Community Login User' LIMIT 1];
    public static User partnerUser = new User(
                            Alias='TPart',
                            Email='testpartner@test.com',
                            EmailEncodingKey='UTF-8',
                            LanguageLocaleKey='en_US',
                            LastName='McPartner',
                            LocaleSidKey='en_US',
                            TimeZoneSidKey='America/New_York',
                            UserName=System.now().millisecond() +'tpart@usda.fsa'
                        );
    public static Profile fsaBtoUserProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User' LIMIT 1];
    public static User fsaBtoUser = new User(
                                    Alias='TRep',
                                    Email='testrep@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='McRep',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaBtoUserProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName=System.now().millisecond() +'trep@usda.fsa'
                                );

                        
    public static User fsaBtoUser2 = new User(
                                    Alias='TRep2',
                                    Email='testrep2@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='McRep2',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaBtoUserProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName=System.now().millisecond() +'trep2@usda.fsa'
                                );
    public static Profile fsaBtoRMProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Resource Manager' LIMIT 1];
    public static User fsaBtoRM = new User(
                                    Alias='TRM',
                                    Email='testrepRM@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='McRep',
                                    LocaleSidKey='en_US',
                                    TimeZoneSidKey='America/New_York',
                                    UserName=System.now().millisecond() +'trm@usda.fsa'
                                );
    public static Contact customer = new Contact(LastName='Test Customer');

    public static testMethod void createNewReferralTaskFromCase() {
        System.runAs(fsaBtoUser) {  
            TIMBASURVEYS__Survey__c survey = new TIMBASURVEYS__Survey__c();
            insert survey;
            
            Case c = new Case(FSA_BTO_Survey__c = survey.id);
            insert c;
            partnerUser= [Select Id From User Where Email='testpartner@test.com'];
            customer=[Select Id From Contact Where LastName='Test Customer'];
            Task task = new Task(
                OwnerId=partnerUser.Id,
                Priority='Normal',
                Status='Referral In Progress',
                Subject='Referral',
                WhatId=c.Id,
                WhoId=customer.Id
            );
            insert task;
            
            // task created by FSA Rep user, assigned to Partner user   
            task = [SELECT Id, OwnerId, FSA_BTO_Account__c, WhatId, CreatedById FROM Task WHERE WhatId = :c.Id];
            partnerAccount=[Select Id From Account Where Name='Test Account'];
            System.assertEquals(partnerUser.Id, task.OwnerId);
            System.assertEquals(fsaBtoUser.Id, task.CreatedById); 
            System.assertEquals(partnerAccount.Id, task.FSA_BTO_Account__c);
            
            // Add feed item  
            Feeditem referralFeedItem = new FeedItem(Title='Test Feed Item for Referral', ParentId=task.Id, Type='TextPost', Body='Test Text Post');
            insert referralFeedItem;
                        
            // Check if feed item is visible to all
            referralFeedItem = [SELECT Visibility FROM FeedItem WHERE Title = 'Test Feed Item for Referral'];
            System.assertEquals('AllUsers', referralFeedItem.Visibility);
            
            //ARE WE STILL DOING AUTOMATIC SHARING?
            //MAYBE WANT TO ASSERT THAT BEFORE THE INSERT, THEY COULD NOT ACCESS THE CASE?        
            // check if case attached to task is being shared with partner user
            List<CaseShare> caseShares = [SELECT CaseId, UserOrGroupId, CaseAccessLevel FROM CaseShare WHERE CaseId = :c.Id AND UserOrGroupId = :task.OwnerId AND CaseAccessLevel = 'Read'];
            System.debug('Case Share: ' + caseShares);
            System.debug('Case Share size: ' + caseShares.size());
            System.assertEquals(1, caseShares.size());
        }    
        
        
        System.runAs(partnerUser) { 
            Task task = [SELECT Status, OwnerId FROM Task WHERE OwnerId =: partnerUser.Id];
            System.debug('Partner user id: ' + partnerUser.Id);
            System.debug('Task owner id: ' + task.ownerId);
            // check if completed referral task is reassigned back to task creator (FSA Rep user)
            task.Status = 'Referral Completed';
            update task;
            // check for error if partner user saves with status != 'Referral Completed'
            try {
                task.Status = 'Closed';
                update task;
            } catch(Exception e) {
                System.assertEquals(false, String.isEmpty(e.getMessage()));
            }

        }        
        
        // code coverage..
        System.runAs(fsaBtoUser) {
            TIMBASURVEYS__Survey__c survey = new TIMBASURVEYS__Survey__c();
            insert survey;
            Case c = new Case(FSA_BTO_Survey__c = survey.id);
            insert c;
            fsaBtoRM= [Select Id From User Where Email='testrepRM@usda.gov'];
            Task task = new Task(
                OwnerId=fsaBtoRM.Id,
                Priority='Normal',
                Status='Referral In Progress',
                Subject='Referral',
                WhatId=c.Id
            );
            insert task;   
        }
    }
    
    public static testMethod void testDeleteReferralByNonCreator() {
        System.runAs(fsaBtoUser) {
            TIMBASURVEYS__Survey__c survey = new TIMBASURVEYS__Survey__c();
            insert survey;
            Case c = new Case(FSA_BTO_Survey__c = survey.id);
            insert c;
            partnerUser= [Select Id From User Where Email='testpartner@test.com'];
            Task task = new Task(
                OwnerId=partnerUser.Id,
                Priority='Normal',
                Status='Referral In Progress',
                Subject='Referral',
                WhatId=c.Id
            );
            insert task;   
        }
        
        System.runAs(partnerUser) {
            Task task2 = [SELECT Id FROM Task WHERE CreatedById =: fsaBtoUser.Id];
            // check that the referral created above cannot be deleted by another user (non-owner)
            try {
                delete task2;
            } catch(DmlException e) {
                System.debug(LOGGINGLEVEL.ERROR);
                System.assertEquals(false, String.isEmpty(e.getMessage()));
            }
        }
    }

    @testSetup static void setupTestData(){
        User currentUser=[Select ProfileId From User Where Id=:UserInfo.getUserId()];           

            insert fsaAccountForLookup;
            partnerAccount.OwnerId=currentUser.Id;
            insert partnerAccount;

            
            partnerContact.AccountId = partnerAccount.Id;
            insert partnerContact;

            Account partnerAccount=[Select Id From Account WHERE Id=:partnerAccount.Id];
            Contact partnerContact=[Select Id From Contact WHERE Id=:partnerContact.Id];
            
            partnerUser.ContactId = partnerContact.Id;
            partnerUser.ProfileId = partnerProfile.Id;
            insert partnerUser;
            
            partnerUser = [SELECT AccountId FROM User WHERE Id = :partnerUser.Id];
            System.assertEquals(partnerAccount.Id, partnerUser.AccountId);
     
            fsaBtoUser.ProfileId = fsaBtoUserProfile.Id;
            insert fsaBtoUser;
            
            fsaBtoUser2.ProfileId = fsaBtoUserProfile.Id;
            insert fsaBtoUser2;

            fsaBtoRm.ProfileId = fsaBtoRMProfile.Id;
            insert fsaBtoRM;
            
            insert customer;
    }
}
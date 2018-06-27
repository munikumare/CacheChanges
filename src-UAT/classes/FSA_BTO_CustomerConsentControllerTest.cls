@isTest
public class FSA_BTO_CustomerConsentControllerTest {
    public static testMethod void testCustomerConsent() {
        User fsaRepUser;
        User partnerUser;
        User currentUser=[Select Id From User Where Id=:UserInfo.getUserId()];
        system.runAs(currentUser){
        Account customerAccount = new Account(Name='Test Customer Account');
        insert customerAccount;
        
        Contact customerContact = new Contact(LastName='CustomerTest', AccountId = customerAccount.Id,  MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States');
        insert customerContact;
        
        
        Account partnerAccount = new Account(Name='Test Partner Account');
        insert partnerAccount;
        
        Contact partnerContact = new Contact(LastName='PartnerTest', AccountId=partnerAccount.Id, MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States');
        insert partnerContact;
        
        Profile partnerProfile = [SELECT Id FROM Profile WHERE Name = 'Content Partner Community Login User' LIMIT 1];
        
        partnerUser = new User(
                            Alias='Partner',
                            ContactId=partnerContact.Id,
                            Email='testpartner@test.com',
                            EmailEncodingKey='UTF-8',
                            LanguageLocaleKey='en_US',
                            LastName='McPartner',
                            LocaleSidKey='en_US',
                            ProfileId=partnerProfile.Id,
                            TimeZoneSidKey='America/New_York',
                            UserName=System.now().millisecond() + 'testpartner@test.com'
                        );
        insert partnerUser;
        
        Profile fsaRepProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User' LIMIT 1];
        fsaRepUser = new User(
                                    Alias='Rep',
                                    Email='testrep@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='McRep',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaRepProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName=System.now().millisecond() + 'testrep@usda.gov'
                                );
        insert fsaRepUser;
    }
        
        System.runAs(fsaRepUser) {
            Contact c = [SELECT Id FROM Contact WHERE LastName='CustomerTest']; 
            TIMBASURVEYS__Survey__c survey = new TIMBASURVEYS__Survey__c();
            insert survey;
            Case newCase = new Case(FSA_BTO_Survey__c = survey.id, Description='test', ContactId=c.Id);
            insert newCase;
            
            FSA_BTO_CustomerConsentController controller = new FSA_BTO_CustomerConsentController();
            Test.setCurrentPage(Page.FSA_BTO_CustomerConsent);
            ApexPages.currentPage().getParameters().put('caseId', newCase.Id);
            System.assertEquals(controller.urlCaseId, newCase.Id);
            controller.task.OwnerId = fsaRepUser.Id;
            System.assertEquals(controller.addPartnerToForm(), null);
            System.assertNotEquals(controller.partnerLookupErrorMessage, null);
            controller.task.OwnerId = partnerUser.Id;
            Test.setCurrentPage(controller.addPartnerToForm());
            System.assertEquals(controller.urlCaseId, newCase.Id);
            System.assertEquals(controller.urlPartnerUserId, partnerUser.Id);
            controller.fsaUserInitials = null;
            System.assertEquals(controller.createReferral(), null);
            // for code coverage...
            System.assertNotEquals(controller.cancel(), null); 
            System.assertNotEquals(controller.backToPartnerUserLookup(), null); 
            controller.fsaUserInitials = 'asdf';
            Test.setCurrentPage(controller.createReferral());
            //System.assertNotEquals(controller.createReferral(), null);
        }
    }
}
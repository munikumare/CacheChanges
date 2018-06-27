@isTest
public class FSA_BTO_ReferralControllerTest {
    private static Account customerAccount = new Account(Name='Test Customer Account');
    private static Contact customerContact = new Contact(LastName='CustomerTest',  MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States');
    private static Account partnerAccount = new Account(Name='Test Partner Account');
    private static Contact partnerContact = new Contact(LastName='PartnerTest', MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States');
    private static Profile partnerProfile = [SELECT Id FROM Profile WHERE Name = 'Content Partner Community Login User' LIMIT 1];
    private static Profile fsaBtoUserProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User' LIMIT 1];
    private static User fsaBtoUser = new User(Alias='TRep', Email='testrep@usda.gov', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LastName='TestRep', LocaleSidKey='en_US', TimeZoneSidKey='America/New_York', UserName='trep@fsa.usda');
    private static User newPartnerUser = new User(Alias='TPart', Email='testpartner@test.com', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LastName='TestPartner', LocaleSidKey='en_US', TimeZoneSidKey='America/New_York', UserName='tpartner@fsa.usda');
    private static TIMBASURVEYS__Survey__c survey = new TIMBASURVEYS__Survey__c();
    private static Profile fsaBtoRMProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Resource Manager' LIMIT 1];
    private static User fsaBtoRM = new User(Alias='TRep2', Email='testrep2@usda.gov', EmailEncodingKey='UTF-8', FSA_BTO_Accepts_Referrals__c=true,LanguageLocaleKey='en_US', LastName='TestRep2', LocaleSidKey='en_US', TimeZoneSidKey='America/New_York', UserName='trep2@fsa.usda');
    private static Case newCase = new Case(Description='test');

    public static testMethod void testNewNotAcceptingReferralsPartner() {               
        insert customerAccount;
        
        customerContact.AccountId = customerAccount.Id;
        //customerContact.FSA_BTO_Customer_Consent_Form_Completed__c = false;
        insert customerContact;
        
        Contact c = [SELECT Id FROM Contact WHERE LastName='CustomerTest'];
                
        insert partnerAccount;
        
        partnerContact.FSA_BTO_Accepts_Referrals__c = false;
        partnerContact.AccountId = partnerAccount.Id;
        insert partnerContact;
        
        fsaBtoUser.ProfileId = fsaBtoUserProfile.Id;
        insert fsaBtoUser;
        
        newPartnerUser.ContactId = partnerContact.Id;
        newPartnerUser.ProfileId = partnerProfile.Id;
        insert newPartnerUser;
        
        insert survey;
        
        newCase.FSA_BTO_Survey__c = survey.Id;
        newCase.ContactId = c.Id;
        insert newCase;

        System.runAs(fsaBtoUser) { 
            Task task = new Task();
            ApexPages.StandardController sc = new ApexPages.StandardController(task);       
            Test.setCurrentPage(Page.FSA_BTO_ReferralUserLookup);
            ApexPages.currentPage().getParameters().put('caseId', newCase.Id);
            FSA_BTO_ReferralController controller = new FSA_BTO_ReferralController(sc);
            System.assertEquals(newCase.Id, controller.urlCaseId);
            controller.task.OwnerId = newPartnerUser.Id;
            System.assertEquals(null, controller.checkUser());
        }
    }
    
    public static testMethod void testNewPartnerReferralUrl() {
        insert customerAccount;
        
        customerContact.AccountId = customerAccount.Id;
        customerContact.FSA_BTO_Customer_Consent_Form_Completed__c = true;
        insert customerContact;
        
        Contact c = [SELECT Id FROM Contact WHERE LastName='CustomerTest'];
                
        insert partnerAccount;
        
        partnerContact.FSA_BTO_Accepts_Referrals__c = true;
        partnerContact.AccountId = partnerAccount.Id;
        insert partnerContact;
        
        newPartnerUser.ContactId = partnerContact.Id;
        newPartnerUser.ProfileId = partnerProfile.Id;
        insert newPartnerUser;
        
        fsaBtoRm.ProfileId = fsaBtoRMProfile.Id;
        insert fsaBtoRM;
        
        insert survey;
        
        newCase.FSA_BTO_Survey__c = survey.Id;
        newCase.ContactId = c.Id;
        insert newCase;
        
        System.runAs(fsaBtoRM) {  
            Task task = new Task();
            ApexPages.StandardController sc = new ApexPages.StandardController(task);       
            Test.setCurrentPage(Page.FSA_BTO_ReferralUserLookup);
            ApexPages.currentPage().getParameters().put('caseId', newCase.Id);
            FSA_BTO_ReferralController controller = new FSA_BTO_ReferralController(sc);

            controller.task.OwnerId = newPartnerUser.Id;
            System.assertNotEquals(null, controller.checkUser());
            Test.setCurrentPage(controller.checkUser());
            //System.assertEquals(controller.urlCaseId, newCase.Id);
            //System.assertEquals(controller.urlUserId, newPartnerUser.Id);
            controller.fsaUserInitials = null;
            System.assertEquals(null, controller.goToNewReferral());
            controller.fsaUserInitials = 'asdf';
            System.assertNotEquals(null, controller.goToNewReferral());
            
            // code coverage...
            System.assertNotEquals(null, controller.cancelReferral()); 
            System.assertNotEquals(null, controller.backToUserLookup());           
        }
    }
}
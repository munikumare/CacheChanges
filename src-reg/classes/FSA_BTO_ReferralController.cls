public class FSA_BTO_ReferralController {
    public Task task { get; set; }
    public String fsaUserInitials { get; set; }
    public String availErrorMessage { get; set; }
    public String consentAgreementErrorMessage { get; set; }
    public Case currentCase { get; set; }
    private User referralUser;
    
    public FSA_BTO_ReferralController(ApexPages.StandardController controller) {
        task = (Task)controller.getRecord();
        
        currentCase = 
            [SELECT 
                ContactId,
                Contact.Name,
                Contact.Phone,
                Contact.Email,
                Contact.MailingStreet,
                Contact.MailingCity,
                Contact.MailingState,
                Contact.MailingPostalCode,
                Contact.MailingCountry,
                Contact.FSA_BTO_Customer_Consent_Form_Completed__c
            FROM 
                Case 
            WHERE 
                Id =: urlCaseId];
    }
    
    public Id urlCaseId {
        get {
            return ApexPages.currentPage().getParameters().get('caseId');
        }
        set;
    }
            
    public PageReference checkUser() {
        String taskUrl;
        referralUser = [SELECT Id, ProfileId, Name, ContactId FROM User WHERE Id =: task.OwnerId];    

        Profile profile = [SELECT Name FROM Profile WHERE Id =: referralUser.ProfileId LIMIT 1];
        if(profile.Name.equals('Content Partner Community Login User') || profile.Name.equals('TEST - TCO/UAT BTO Partner')) {
            // check if the partner is accepting referrals 
            // checking the partner's CONTACT record!
            Contact referralContactPartner = [SELECT FSA_BTO_Accepts_Referrals__c FROM Contact WHERE Id =: referralUser.ContactId LIMIT 1];
            if(referralContactPartner.FSA_BTO_Accepts_Referrals__c == false) {
                availErrorMessage = 'Error: This partner is not accepting referrals.';
                return null;
            }
            if(currentCase.Contact.FSA_BTO_Customer_Consent_Form_Completed__c == true) {
                taskUrl = buildTaskUrl('partner');
            } else {
                taskUrl = '/apex/FSA_BTO_CustomerConsentAgreement?caseId=' + urlCaseId + '&userId=' + task.OwnerId; 
            }
        } else {
            taskUrl = buildTaskUrl('internal');
        }
        System.debug('taskUrl: ' + taskUrl);
        return new PageReference(taskUrl);
    }
    
    private String buildTaskUrl(String userType) {
        String url = '/00T/e?&tsk1=' + referralUser.Name + '&tsk1_lkid=' + referralUser.Id + '&tsk1_mod=1&tsk12=Referral In Progress&ent=task';
        if(currentCase.Id != null) {
            url += '&what_id=' + currentCase.Id + '&retURL=/' + currentCase.Id + '&cancelURL=/' + currentCase.Id;
        }
        if(currentCase.Contact.Name != null) {
            url += '&who_id=' + currentCase.ContactId;
        }
        if(userType.equals('internal')) {
            Id recordTypeId = Schema.SObjectType.Task.RecordTypeInfosByName.get('FSA BTO Referral Task for Internal User').RecordTypeId;
            url += '&tsk5=Internal Referral&RecordType=' + recordTypeId;
        } else if(userType.equals('partner')) {
            Id recordTypeId = Schema.SObjectType.Task.RecordTypeInfosByName.get('FSA BTO Referral Task for Partner User').RecordTypeId;
            url += '&tsk5=Partner Referral&tsk1_mlktp=PartnerUserLookup&RecordType=' + recordTypeId;
        }
        return url;
    }
    
    public PageReference goToNewReferral() {
        if(fsaUserInitials == '' || fsaUserInitials == null) {
            consentAgreementErrorMessage = 'Error: You must enter your initials to continue.';
            return null;
        } else {
            currentCase.Contact.FSA_BTO_Customer_Consent_Form_Completed__c = true;
            update currentCase.Contact;
        }
        return new PageReference(buildTaskUrl('partner'));
    }
    
    public PageReference cancelReferral() {
        return new PageReference('/' + urlCaseId); 
    }
    
    public PageReference backToUserLookup() {
        return new PageReference('/apex/FSA_BTO_ReferralUserLookup?caseId=' + urlCaseId); 
    }
}
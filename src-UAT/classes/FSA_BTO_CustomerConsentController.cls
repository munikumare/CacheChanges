public with sharing class FSA_BTO_CustomerConsentController {
    //public Case caseRecord;
    //public User userRecord;
    public Task task { get; set; }
    public String fsaUserInitials { get; set; }
    public String partnerLookupErrorMessage { get; set; }
    public String consentAgreementErrorMessage { get; set; }
    
    
    public FSA_BTO_CustomerConsentController() {
        // for now, using instance to hold the AssignedTo (partner)
        task = new Task();
    }
    
    public Id urlCaseId {
        get {
            return ApexPages.currentPage().getParameters().get('caseId');
        }
        set;
    }
    
    public Id urlPartnerUserId {
        get {
            return ApexPages.currentPage().getParameters().get('partnerUserId');
        }
        set;
    }
    
    public PageReference addPartnerToForm() {
        User user = [SELECT ProfileId FROM User WHERE Id =: task.OwnerId LIMIT 1];
        Profile profile = [SELECT Name FROM Profile WHERE id =: user.ProfileId LIMIT 1];
        if(task.OwnerId == UserInfo.getUserId() || profile.Name == 'System Administrator' || profile.Name == 'FSA BTO User') {
            partnerLookupErrorMessage = 'Error: You cannot assign Referrals to yourself or other BTO Users.';
            return null;
        }
        return new PageReference('/apex/FSA_BTO_CustomerConsentAgreement?caseId=' + urlCaseId + '&partnerUserId=' + task.OwnerId);
    }

    public PageReference createReferral() {
        if(fsaUserInitials == '' || fsaUserInitials == null) {
            consentAgreementErrorMessage = 'Error: You must enter your initials to continue.';
            return null;
        } else {
            Id referralRecordTypeId = Schema.SObjectType.Task.RecordTypeInfosByName.get('FSA BTO Referral Task for Partner User').RecordTypeId;
            String standardTaskUrl = '/00T/e?tsk5=Referral&tsk12=Referral In Progress&RecordType=' + referralRecordTypeId + '&ent=task';
            if(partnerUser.Id != null) {
                standardTaskUrl += '&tsk1_mlktp=PartnerUserLookup&tsk1=' + partnerUser.Name + '&tsk1_lkid=' + partnerUser.Id;
            }
            if(currentCase.Id != null) {
                standardTaskUrl += '&what_id=' + currentCase.Id + '&retURL=/' + currentCase.Id + '&cancelURL=/' + currentCase.Id;
            }
            if(currentCase.Contact.Name != null) {
                standardTaskUrl += '&tsk2=' + currentCase.Contact.Name;
            }
            if(currentCase.Description != null) {
                standardTaskUrl += '&tsk6=' + currentCase.Description;
            }
            return new PageReference(standardTaskUrl);
        }
    }

    
    public PageReference cancel() {
        return new PageReference('/' + urlCaseId); 
    }
    
    public PageReference backToPartnerUserLookup() {
        return new PageReference('/apex/FSA_BTO_CustomerConsent?caseId=' + urlCaseId); 
    }
    
    // temporary, prob should cache the first query
    public Case currentCase {
        get {
            Case caseQuery = [
                                  SELECT 
                                         Id,
                                         CaseNumber,
                                         ContactId,
                                         Contact.Name,
                                         Contact.Phone,
                                         Contact.Email,
                                         Contact.MailingStreet,
                                         Contact.MailingCity,
                                         Contact.MailingState,
                                         Contact.MailingPostalCode,
                                         Contact.MailingCountry,
                                         Description,
                                         OwnerId,
                                         FSA_BTO_Date_Of_Service__c
                                  FROM 
                                         Case 
                                  WHERE 
                                         Id =: urlCaseId 
                                  LIMIT 1
            ];
            return caseQuery;
        }
    }

    public User partnerUser {
        get {
            User userQuery = [
                                  SELECT 
                                         Id, 
                                         Name,
                                         AccountId,
                                         Contact.Account.Name
                                  FROM 
                                         User 
                                  WHERE 
                                         id =: urlPartnerUserId 
                                  LIMIT 1
            ];
            return userQuery;
        }
    }
}
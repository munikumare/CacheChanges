public class FSA_BTO_TaskTriggerHelper 
{
    public static void preventDeleteReferralByNonCreators(List<Task> tasks){
        for(Task t: tasks) {
            if(UserInfo.getUserId()!=t.CreatedById) {
                t.addError('Error: You cannot delete referrals that you did not originally create.');
            }
        }
    }

    public static void populateAccountLookup(List<Task> tasks){
        Set<Id> userIds = new Set<Id>();
        Map<Id,Id> userToAccountMap = new Map<Id,Id>();
        Account a = [SELECT Id FROM Account WHERE Name='USDA Farm Service Agency' AND Website='http://www.fsa.usda.gov' AND FSA_BTO_State_PickList__c='DC'];

        for(Task t: tasks) { 
            userIds.add(t.OwnerId);
        }
        for(User u :[SELECT Id, AccountId FROM User WHERE id IN: userIds]) {
           userToAccountMap.put(u.Id, u.AccountId);
        }
        for(Task t: tasks) {
            if(t.Subject.containsIgnoreCase('Referral') && t.Status.equals('Referral In Progress')) {
                if(userToAccountMap.get(t.OwnerId) == null) {
                    t.FSA_BTO_Account__c = a.Id;
                } else {
                    t.FSA_BTO_Account__c = userToAccountMap.get(t.OwnerId);
                }
            }
        }
    }

    public static void populateContactLookup(List<Task> tasks){
        Set<Id> userIds = new Set<Id>();
        Map<Id,Id> userToContactMap = new Map<Id,Id>();
        
        for(Task t: tasks) { 
            userIds.add(t.OwnerId);
        }
        for(User u :[SELECT Id, ContactId FROM User WHERE id IN: userIds]) {
            userToContactMap.put(u.Id, u.ContactId);
        }
        for(Task t: tasks) {
            if(t.Status.equals('Referral In Progress')) {
                t.FSA_BTO_Contact__c = userToContactMap.get(t.OwnerId);
            }
        }    
    }

    public static void populateUserLookup(List<Task> tasks){
        for(Task t: tasks) {
            if(t.Subject.containsIgnoreCase('Referral') && t.Status.equals('Referral In Progress')) {
                t.FSA_BTO_User__c = t.OwnerId;
            }
        }
    }

    public static void shareRelatedCaseAndContact(List < Task > tasks) {
        List < CaseShare > caseShares = new List < CaseShare > ();
        List < ContactShare > contactShares = new List < ContactShare > ();
        List < Id > userIds = new List < Id > ();

        for (Task t: tasks) {
            userIds.add(t.OwnerId);
        }

        Map < Id, Id > userProfileIdMap = new Map < Id, Id > ();
        Set<Id> userProfileIds = new Set<Id>();
        for (User u: [SELECT Id, ProfileId, FSA_BTO_Agreed_to_Terms_and_Conditions__c FROM User WHERE Id IN: userIds]) {
            userProfileIdMap.put(u.Id, u.ProfileId);
            userProfileIds.add(u.ProfileId);
        }

        for (Profile p: [SELECT Id, Name FROM Profile WHERE id IN: userProfileIds]) {
            if (p.Name=='Content Partner Community Login User' || p.Name=='TEST - TCO/UAT BTO Partner') {
                for (Task t: tasks) {
                    if ((t.Subject.containsIgnoreCase('Referral') || t.Status.equals('Referral In Progress'))) {
                        if (t.WhoId != null && String.valueOf(t.WhoId).substring(0,3)==Contact.SObjectType.getDescribe().getKeyPrefix()) {
                            if (userProfileIdMap.containsKey(t.OwnerId)) {
                                if (userProfileIdMap.get(t.OwnerId) == p.Id) {
                                    ContactShare contactShare = new ContactShare(ContactId = t.WhoId, ContactAccessLevel = 'Read', UserOrGroupId = t.OwnerId);
                                    contactShares.add(contactShare);
                                }
                            }
                        }
                        if (t.WhatId != null && String.valueOf(t.WhatId).substring(0,3)==Case.SObjectType.getDescribe().getKeyPrefix()) {
                            if (userProfileIdMap.containsKey(t.OwnerId)) {
                                if (userProfileIdMap.get(t.OwnerId) == p.Id) {
                                    CaseShare caseShare = new CaseShare(CaseId = t.WhatId, CaseAccessLevel = 'Read', UserOrGroupId = t.OwnerId);
                                    caseShares.add(caseShare);
                                }
                            }
                        }
                    }
                }
            }
        }
        if (caseShares.size() > 0){
            insert caseShares;
        }
        if (contactShares.size() > 0){
            insert contactShares;
        }
    }
}
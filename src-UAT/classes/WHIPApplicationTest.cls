@isTest
public class WHIPApplicationTest{
    private static final Id WHIP_APPLICATION_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('WHIP Application').getRecordTypeId();
    private static final Id WHIP_APP_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get('WHIP App Unlocked').getRecordTypeId();
    private static final Id WHIP_APP_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get('Whip App Locked').getRecordTypeId();

    private static final String PENDING_PRODUCER_SIGNATURE = 'Pending Producer Signature';
    private static final String PENDING_COC_DETERMINATION = 'Pending COC Determination';
    private static final String APPROVED = 'Approved';
    private static final String DISAPPROVED = 'Disapproved';
    private static final String PARTIALLY_DISAPPROVED = 'Partially Disapproved';
    private static final String PARTIALLY_APPROVED = 'Partially Approved';
    private static final String ADVANCE_PAID = 'Advance Processed';
    private static final String FINAL_PAID = 'Final Processed';
    private static final String IN_PROGRESS = 'In Progress';
    private static final String WHIP_LI_PRODUCTIONLOSSLOCKED = 'Production Loss Locked';
    private static final String WHIP_LI_TREELOSSLOCKED = 'Tree Loss Locked';
    private static final String WHIP_LI_VALUELOSSLOCKED = 'Value Loss Locked';
    private static final String WHIP_LI_PRODUCTIONLOSSUNLOCKED = 'Production Loss';
    private static final String WHIP_LI_TREELOSSUNLOCKED = 'Tree Loss';
    private static final String WHIP_LI_VALUELOSSUNLOCKED = 'Value Loss';    
    private static final String WHIP_NOL_LOCKED = 'WHIP NOL Locked';
    private static final Id WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_NOL_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get(WHIP_NOL_LOCKED).getRecordTypeId();
    private static final Id WHIP_NOL_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get('WHIP NOL Unlocked').getRecordTypeId();


    static testMethod void createCaseRecord()  {
        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Test',
                Email = 'a@test.com',
                MailingCity = 'test',
                MailingState = 'Ohio',
                MailingStreet = 'test',
                MailingPostalCode = '12345'
        );
        insert contact;

        Case testCase = new Case(
                Status = IN_PROGRESS,
                RecordTypeID = WHIP_APPLICATION_RECORD_TYPE_ID,
                Subject = 'WHIP Application',
                ContactId = contact.Id
        );

        insert testCase;
        FSA_BTO_County__c  county = new FSA_BTO_County__c (
                  Name='Fairfax County'
           );
       insert county;

        WHIP_Application__c myWHIP = new WHIP_Application__c(
                Related_Interaction__c = testCase.Id,
                Status__c = IN_PROGRESS,
                DisasterEndDate__c= Date.newInstance(2017, 12, 1),
                DisasterStartDate__c= Date.newInstance(2017, 12, 9),
                WhatDisasterCausedtheLoss__c = 'other',
                WHIP_Admin_County_Name_Lookup__c = county.Id

        );
        insert myWHIP;

        Test.startTest();
        myWHIP.Status__c = PENDING_PRODUCER_SIGNATURE;
        myWHIP.SubmitApplication__c = true;

        update myWHIP;
        Test.stopTest();

        Case updatedCase = [SELECT Id, Status FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(PENDING_PRODUCER_SIGNATURE, updatedCase.Status);

    }

    @isTest
    static void unlockApplication_givenAppsOnUpdate_shouldUnlockAppsAndResetValues() {

        WHIP_Application__c oldApp = new WHIP_Application__c(
                Id = TestUtility.getFakeId(WHIP_Application__c.SObjectType),
                RecordTypeId = WHIP_APP_LOCKED_RECORD_TYPE_ID
        );
        WHIP_Application__c newApp = new WHIP_Application__c(
                Id = oldApp.Id,
                RecordTypeId = WHIP_APP_UNLOCKED_RECORD_TYPE_ID,
                Status__c = FINAL_PAID,
                ProducerSignedDate__c = System.Today(),
                Approved__c = true,
                Disapproved__c = true,
                PartiallyApproved__c = true,
                ApprovedDisapprovedDate__c = System.Today()
        );
        Map<Id,WHIP_Application__c> oldMap = new Map<Id,WHIP_Application__c>();
        oldMap.put(oldApp.Id, oldApp);
        Map<Id,WHIP_Application__c> newMap = new Map<Id,WHIP_Application__c>();
        newMap.put(newApp.Id, newApp);

        Test.startTest();
        WHIPApplicationTriggerFacade tf = new WHIPApplicationTriggerFacade();
        tf.unlockApplication(oldMap,newMap);
        Test.stopTest();

        newApp = newMap.get(newApp.Id);

        System.assertEquals(IN_PROGRESS, newApp.Status__c, 'Status should be in progress.');
        System.assertEquals(null, newApp.ProducerSignedDate__c);
        System.assertEquals(null, newApp.ApprovedDisapprovedDate__c);
    }

    @isTest
    static void updateRecordTypeOnStatusChange_givenStatusNotInProgress_shouldSetRecordTypeToLocked() {
        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Test',
                Email = 'a@test.com',
                MailingCity = 'test',
                MailingState = 'Ohio',
                MailingStreet = 'test',
                MailingPostalCode = '12345'
        );
        insert contact;

        Case testCase = new Case(
                Status = IN_PROGRESS,
                RecordTypeID = WHIP_APPLICATION_RECORD_TYPE_ID,
                Subject = 'WHIP Application',
                ContactId = contact.Id
        );

        insert testCase;
        FSA_BTO_County__c  county = new FSA_BTO_County__c (
                  Name='Fairfax County'
           );
       insert county;

        WHIP_Application__c myWHIP = new WHIP_Application__c(
                Related_Interaction__c = testCase.Id,
                Status__c =PENDING_PRODUCER_SIGNATURE,
                DisasterEndDate__c= Date.newInstance(2017, 12, 1),
                DisasterStartDate__c= Date.newInstance(2017, 12, 9),
                WhatDisasterCausedtheLoss__c = 'other',
                WHIP_Admin_County_Name_Lookup__c = county.Id

        );
        insert myWHIP;


        List<WHIP_Application__c> apps = new List<WHIP_Application__c>{myWHIP};
        WHIPNoticeofLoss__c nol = new WHIPNoticeofLoss__c(
                RecordTypeId = WHIP_NOL_UNLOCKED_RECORD_TYPE_ID,
                WHIP_Application__c = myWHIP.Id

        );
        insert nol;

        WHIPLossInformation__c li = new WHIPLossInformation__c(
                RecordTypeId = WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID,
                WHIPNoticeofLoss__c = nol.Id
        );
        insert li;

        Test.startTest();
        WHIPApplicationTriggerFacade tf = new WHIPApplicationTriggerFacade();
        tf.updateRecordTypeOnStatusChange(apps);
        Test.stopTest();

        System.assertEquals(WHIP_APP_LOCKED_RECORD_TYPE_ID, apps[0].RecordTypeId);
        WHIPNoticeofLoss__c noticofloss = [SELECT RecordTypeId FROM WHIPNoticeofLoss__c WHERE Id = :nol.Id];
        System.assertEquals(WHIP_NOL_LOCKED_RECORD_TYPE_ID, noticofloss.RecordTypeId);
        WHIPLossInformation__c lossofinformation = [SELECT RecordTypeId FROM WHIPLossInformation__c WHERE Id = :li.Id];
        System.assertEquals(WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID, lossofinformation.RecordTypeId);
    }


    @isTest
    static void updateRecordTypeOnStatusChange_givenStatusInProgress_shouldSetRecordTypeToUnlocked() {

        WHIP_Application__c newApp = new WHIP_Application__c(
                Id = TestUtility.getFakeId(WHIP_Application__c.SObjectType),
                RecordTypeId = WHIP_APP_LOCKED_RECORD_TYPE_ID,
                Status__c = IN_PROGRESS
        );
        List<WHIP_Application__c> apps = new List<WHIP_Application__c>{ newApp };

        Test.startTest();
        WHIPApplicationTriggerFacade tf = new WHIPApplicationTriggerFacade();
        tf.updateRecordTypeOnStatusChange(apps);
        Test.stopTest();

        System.assertEquals(WHIP_APP_UNLOCKED_RECORD_TYPE_ID, apps[0].RecordTypeId);
    }

}
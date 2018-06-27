public class WHIPApplicationTriggerFacade {
    private static final String WHIP_APP_LOCKED = 'Whip App Locked';
    private static final String WHIP_APP_UNLOCKED = 'WHIP App Unlocked';
    private static final String WHIP_LI_PRODUCTIONLOSSLOCKED = 'Production Loss Locked';
    private static final String WHIP_LI_TREELOSSLOCKED = 'Tree Loss Locked';
    private static final String WHIP_LI_VALUELOSSLOCKED = 'Value Loss Locked';
    private static final String WHIP_LI_PRODUCTIONLOSSUNLOCKED = 'Production Loss';
    private static final String WHIP_LI_TREELOSSUNLOCKED = 'Tree Loss';
    private static final String WHIP_LI_VALUELOSSUNLOCKED = 'Value Loss';    
    private static final String WHIP_NOL_LOCKED = 'WHIP NOL Locked';
    private static final Id WHIP_APP_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_LOCKED).getRecordTypeId();
    private static final Id WHIP_APP_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_UNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_NOL_LOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get(WHIP_NOL_LOCKED).getRecordTypeId();
    private static final Id WHIP_NOL_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get('WHIP NOL Unlocked').getRecordTypeId();

    private static final String IN_PROGRESS = 'In Progress';

    public void updateCaseStatus(List<WHIP_Application__c> newWhipApps){
        Map<ID, string> AppIds = New Map<ID, string>();
        for(WHIP_Application__c wa : newWhipApps){
            if((wa.Status__c== 'Pending Producer Signature' ||
                    wa.Status__c == 'Pending COC Determination' ||
                    wa.Status__c =='Approved' ||
                    wa.Status__c == 'Disapproved' ||
                    wa.Status__c == 'Partially Approved' ||
                	wa.Status__c == 'Partially Disapproved'||
                    wa.Status__c =='Advance Processed' ||
                    wa.Status__c =='Final Processed')
                    && wa.Related_Interaction__c != null){
                AppIds.put(wa.Related_Interaction__c, wa.Status__c);
            }
        }
        List<Case> caseList = [SELECT id, status, CaseNumber FROM Case WHERE id in :AppIds.keySet()];
        for(Case queriedCase: caseList){
            queriedCase.Status = AppIds.get(queriedCase.id);
        }
        update caseList;
    }
    Public void updateWhipStatus(Map<Id,WHIP_Application__c> oldAppsByIds, Map<Id,WHIP_Application__c> newAppsByIds)
    {
        for(WHIP_Application__c newWhipApp : newAppsByIds.values())
        {
            if(oldAppsByIds.get(newWhipApp.Id).Status__c == newAppsByIds.get(newWhipApp.Id).Status__c)
            {
                if (newAppsByIds.get(newWhipApp.Id).SubmitApplication__c == true && newAppsByIds.get(newWhipApp.Id).Status__c == 'In Progress' && newAppsByIds.get(newWhipApp.Id).ProducerSignedDate__c == null){
                    newAppsByIds.get(newWhipApp.Id).Status__c = 'Pending Producer Signature';
                }
                else if (newAppsByIds.get(newWhipApp.Id).SubmitApplication__c == true && (newAppsByIds.get(newWhipApp.Id).Status__c == 'In Progress' || newAppsByIds.get(newWhipApp.Id).Status__c == 'Pending Producer Signature') && newAppsByIds.get(newWhipApp.Id).ProducerSignedDate__c != null) {
                    newAppsByIds.get(newWhipApp.Id).Status__c = 'Pending COC Determination';
                }
            }
        }
    }
    Public void unlockApplication(Map<Id,WHIP_Application__c> oldAppsByIds, Map<Id,WHIP_Application__c> newAppsByIds){
        for(WHIP_Application__c newApp :newAppsByIds.values()){
            //reset values when record type changes from locked to unlocked.
            if( oldAppsByIds.get(newApp.Id).RecordTypeId == WHIP_APP_LOCKED_RECORD_TYPE_ID &&
                    oldAppsByIds.get(newApp.Id).RecordTypeId != newApp.RecordTypeId &&
                    newApp.RecordTypeId == WHIP_APP_UNLOCKED_RECORD_TYPE_ID) {
                newApp.Status__c = IN_PROGRESS;
                newApp.SubmitApplication__c = false;
                newApp.ProducerSignedDate__c = null;
                newApp.FinishApprovals__c = false;       
                newApp.ApprovedDisapprovedDate__c = null;
            }
        }
    }

    Public void updateRecordTypeOnStatusChange(List<WHIP_Application__c> apps)
    {
        Set<Id> NoticeOfLossids=new Set<Id>();
        Set<Id> WhipAppids=new Set<Id>();
        System.debug('start');
        for(WHIP_Application__c newApp :apps)
        {   newApp.RecordTypeId = WHIP_APP_UNLOCKED_RECORD_TYPE_ID;
            if(newApp.Status__c != IN_PROGRESS)
            {
                WhipAppids.add(newApp.Id);
                newApp.RecordTypeId = WHIP_APP_LOCKED_RECORD_TYPE_ID;
            }
        }

        if(!WhipAppids.isEmpty()) {
            List<WHIPNoticeofLoss__c> whipNoticeOfLossList = [SELECT id,RecordTypeID FROM WHIPNoticeofLoss__c WHERE WHIP_Application__c = :WhipAppids];
            if (whipNoticeOfLossList != null && !whipNoticeOfLossList.isEmpty()) {
               
                for (WHIPNoticeofLoss__c queriedWHIPNoticeOfLoss : whipNoticeOfLossList) {
                    queriedWHIPNoticeOfLoss.RecordTypeId = WHIP_NOL_LOCKED_RECORD_TYPE_ID;
                    NoticeOfLossids.add(queriedWHIPNoticeOfLoss.Id);
                }
                update whipNoticeOfLossList;
            }
        }
        if(!NoticeOfLossids.isEmpty()) {
            List<WHIPLossInformation__c> whipLossofInformationList = [SELECT id, RecordTypeID FROM WHIPLossInformation__c WHERE WHIPNoticeofLoss__c in :NoticeOfLossids];
            if (whipLossofInformationList != null && !whipLossofInformationList.isEmpty() ) {
                for (WHIPLossInformation__c queriedLossofInformation : whipLossofInformationList) {
                    if(queriedLossofInformation.RecordTypeID == WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID) 
                    {   
                        queriedLossofInformation.RecordTypeID = WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID;
                    }
                    else if(queriedLossofInformation.RecordTypeID == WHIP_LI_UNLOCKED_TREELOSS_RECORD_TYPE_ID)
                    {
                        queriedLossofInformation.RecordTypeID = WHIP_LI_LOCKED_TREELOSS_RECORD_TYPE_ID;
                    }
                    else if(queriedLossofInformation.RecordTypeID == WHIP_LI_UNLOCKED_VALUELOSS_RECORD_TYPE_ID)
                    {
                        queriedLossofInformation.RecordTypeID = WHIP_LI_LOCKED_VALUELOSS_RECORD_TYPE_ID; 
                    }
                }

                WHIPLossInformationTriggerFacade.shouldUpdatePayGroup = false;
                update whipLossofInformationList;
            }
        }
    }

    public void retrieveProducerData(Map<Id, WHIP_Application__c> newAppsByIds) {
        if (!System.isFuture() && !System.isBatch()) {
            WHIPProducerDataRetriever.retrieveProducerDataByAppId_Future(newAppsByIds.keySet());
        }
    }
}
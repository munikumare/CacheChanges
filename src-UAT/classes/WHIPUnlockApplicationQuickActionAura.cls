public with sharing class WHIPUnlockApplicationQuickActionAura {
	private static final String WHIP_APP_UNLOCKED = 'WHIP App Unlocked';
	private static final Id WHIP_APP_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIP_Application__c.getRecordTypeInfosByName().get(WHIP_APP_UNLOCKED).getRecordTypeId();
	private static final String WHIP_NOL_UNLOCKED = 'WHIP NOL Unlocked';	
	private static final Id WHIP_NOL_UNLOCKED_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get(WHIP_NOL_UNLOCKED).getRecordTypeId();
	private static final String WHIP_LI_PRODUCTIONLOSSLOCKED = 'Production Loss Locked';
    private static final String WHIP_LI_TREELOSSLOCKED = 'Tree Loss Locked';
    private static final String WHIP_LI_VALUELOSSLOCKED = 'Value Loss Locked';
    private static final String WHIP_LI_PRODUCTIONLOSSUNLOCKED = 'Production Loss';
    private static final String WHIP_LI_TREELOSSUNLOCKED = 'Tree Loss';
    private static final String WHIP_LI_VALUELOSSUNLOCKED = 'Value Loss';
    private static final Id WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_LOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_PRODUCTIONLOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_TREELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_TREELOSSUNLOCKED).getRecordTypeId();
    private static final Id WHIP_LI_UNLOCKED_VALUELOSS_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get(WHIP_LI_VALUELOSSUNLOCKED).getRecordTypeId();
	
	@auraEnabled
	public static void setRecordTypeUnlocked(String appId){
		try {
			Set<Id> NoticeOfLossids=new Set<Id>();
			WHIP_Application__c wa = [SELECT RecordTypeId FROM WHIP_Application__c WHERE Id=:appId];
			wa.RecordTypeId = WHIP_APP_UNLOCKED_RECORD_TYPE_ID;
			update wa;

			List<WHIPNoticeofLoss__c> whipNoticeOfLossList = [SELECT id FROM WHIPNoticeofLoss__c WHERE WHIP_Application__c = :appId];
			if (whipNoticeOfLossList != null && !whipNoticeOfLossList.isEmpty()) {
				for (WHIPNoticeofLoss__c queriedWHIPNoticeOfLoss : whipNoticeOfLossList) {
					queriedWHIPNoticeOfLoss.RecordTypeID = WHIP_NOL_UNLOCKED_RECORD_TYPE_ID;
					NoticeOfLossids.add(queriedWHIPNoticeOfLoss.Id);
				}
				update whipNoticeOfLossList;

				if (NoticeOfLossids != null && !NoticeOfLossids.isEmpty()) {
					List<WHIPLossInformation__c> whipLossofInformationList = [SELECT id, RecordTypeID FROM WHIPLossInformation__c WHERE WHIPNoticeofLoss__c = :NoticeOfLossids];
					if (whipLossofInformationList != null && !whipLossofInformationList.isEmpty()) {
						for (WHIPLossInformation__c queriedLossofInformation : whipLossofInformationList) {
							if(queriedLossofInformation.RecordTypeID == WHIP_LI_LOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID) 
                            {	
                                queriedLossofInformation.RecordTypeID = WHIP_LI_UNLOCKED_PRODUCTIONLOSS_RECORD_TYPE_ID;
                            }
                            else if(queriedLossofInformation.RecordTypeID == WHIP_LI_LOCKED_TREELOSS_RECORD_TYPE_ID)
                            {
                                queriedLossofInformation.RecordTypeID = WHIP_LI_UNLOCKED_TREELOSS_RECORD_TYPE_ID;
                            }
                            else if(queriedLossofInformation.RecordTypeID == WHIP_LI_LOCKED_VALUELOSS_RECORD_TYPE_ID)
                            {
                                queriedLossofInformation.RecordTypeID = WHIP_LI_UNLOCKED_VALUELOSS_RECORD_TYPE_ID; 
                            }

						}
						update whipLossofInformationList;
					}
				}
			}
		}
		catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}
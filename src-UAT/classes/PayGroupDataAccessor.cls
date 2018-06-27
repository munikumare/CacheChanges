public with sharing class PayGroupDataAccessor implements PayGroupDAO {
    
    public List<WHIPPayGroup__c> getPayGroupsFromKeyAndApplicationId(List<String> keys, List<String> applicationIds) {
        return [
            SELECT Id, PayGroupKey__c, WHIPApplicationPayGroup__c
            FROM WHIPPayGroup__c
            WHERE PayGroupKey__c IN :keys
                AND WHIPApplicationPayGroup__c IN :applicationIds
        ];

    }

    public Map<Id, WHIPNoticeofLoss__c> getNoticeOfLossMap(Set<String> noticeOfLossIds) {
        return new Map<Id, WHIPNoticeofLoss__c>([
            SELECT Id, WHIP_Application__c, CoverageType__c
            FROM WHIPNoticeofLoss__c
            WHERE Id IN :noticeOfLossIds
        ]);
    }

    public List<WHIPLossInformation__c> getLossInformationsToRollUp(Set<Id> payGroupIds) {
        return [
            SELECT Id, RecordType.DeveloperName, WHIP_Pay_Group__c, PLCalculatedPayment__c, 
                   TreeLossTotalCalculatedPayment__c, VLCalculatedPayment__c
            FROM WHIPLossInformation__c
            WHERE WHIP_Pay_Group__c IN :payGroupIds
                AND (RecordType.DeveloperName = :'Production_Loss'
                    OR RecordType.DeveloperName = :'Tree_Loss'
                    OR RecordType.DeveloperName = :'Value_Loss'
                    OR RecordType.DeveloperName = : 'Production_Loss_Locked'
                    OR RecordType.DeveloperName = : 'Tree_Loss_Locked'
                    OR RecordType.DeveloperName = : 'Value_Loss_Locked')
        ];
    }

    public Map<Id, WHIPPayGroup__c> getPayGroupsToUpdate(Set<Id> payGroupIds) {
        return new Map<Id, WHIPPayGroup__c>([
            SELECT Id, PL_Total__c, VL_Total__c, TL_Total__c, Value_Loss_Neg_Total__c,
                   PayGroup_Production_Loss_Total__c, Tree_Loss_Neg_Total__c,
                   PayGroup_Tree_Loss_Total__c, PayGroup_Value_Loss_Total__c
            FROM WHIPPayGroup__c
            WHERE Id IN :payGroupIds
        ]);
    }

    public void saveLossInformation(List<WHIPLossInformation__c> lossesToSave) {
        upsert lossesToSave;
    }

    public void savePayGroups(List<WHIPPayGroup__c> payGroupsToSave) {
        upsert payGroupsToSave;
    }

}
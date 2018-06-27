public class FPAC_RefreshLandRecords {
    
    @AuraEnabled 
    public static void getRefreshedLandDetails(String recID){
        
        Land__c land = [Select id,Farm_Number__c,Admin_State_Code__c,Admin_County_Code__c from Land__c where id=:recID limit 1];
        
        FPAC_SCIMS_FarmProcessor fpacFarmProc = new FPAC_SCIMS_FarmProcessor();
        fpacFarmProc.SaveFarmData(fpacFarmProc.getFarmData(land.Admin_State_Code__c+'-'+land.Admin_County_Code__c+'-'+land.Farm_Number__c));
    }
}
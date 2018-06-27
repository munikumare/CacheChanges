public with sharing class WHIP_NOL_Crop_Controller {
	private static NAP_RMA_NCT_ACR_DataAccessor napRmaNctAcrDataAccessor = new NAP_RMA_NCT_ACR_DataAccessor();

	@auraEnabled
	public static List<NAP_RMA_NCT_ACR_Data__c> getWhipNolCrops(Id whipAppId){
		WHIP_Application__c whipApp = getWhipAppById(whipAppId);
		return napRmaNctAcrDataAccessor.getAllAcrRecordsByCoreCustomerId(whipApp.Individual__r.FSA_BTO_Core_Customer_ID__c);
	}
	private static WHIP_Application__c getWhipAppById(Id recordId){
		return [
				SELECT Individual__r.FSA_BTO_Core_Customer_ID__c
				FROM WHIP_Application__c
				WHERE Id = :recordId
		];
	}
}
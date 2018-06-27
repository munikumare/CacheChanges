public with sharing class WHIP_NOL_Controller {
	private static final String WHIP_NOL_UNLOCK_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get('WHIP NOL Unlocked').getRecordTypeId();
	private static NAP_RMA_NCT_ACR_DataAccessor napRmaNctAcrDataAccessor = new NAP_RMA_NCT_ACR_DataAccessor();

	@auraEnabled
	public static WHIPNoticeofLoss__c getWhipNolRecord(Id whipAppId, Id selectedCropId ,Id selectedCropTypeId, boolean seedFertilizer, string seedFertilizerComment, boolean landPrepCheckBox, string landPrepComment,
                                                       string preventionComment, string cultivationPracticesComment, date finalPlantingDate){
		NAP_RMA_NCT_ACR_Data__c selectedCropData = napRmaNctAcrDataAccessor.getDataById(selectedCropId);
		NAP_RMA_NCT_ACR_Data__c selectedCropTypeData = napRmaNctAcrDataAccessor.getDataById(selectedCropTypeId);
		WHIPNoticeofLoss__c whipNol = (WHIPNoticeofLoss__c)Schema.getGlobalDescribe().get('WHIPNoticeofLoss__c').newSObject(WHIP_NOL_UNLOCK_RECORD_TYPE_ID, true);
		whipNol.WHIP_Application__c = whipAppId;
		whipNol.RecordTypeId = WHIP_NOL_UNLOCK_RECORD_TYPE_ID;
		whipNol.Crop__c = selectedCropData.ACR_Crop_Name__c;
		whipNol.CoverageType__c = selectedCropTypeData.RecordType.Name;
        //PORTCONS-372
        whipNol.PurchDelivArrangSdChemFert__c = seedFertilizer;
        whipNol.SeedChemicalandFertilizerComment__c =seedFertilizerComment;
        whipNol.PurchDelivArrangLandPrepMeas__c = landPrepCheckBox;
        whipNol.LandPreparationMeasuresComment__c= landPrepComment;
        whipNol.PreventionComment__c = preventionComment;
        whipNol.CultivationPraticesComment__c = cultivationPracticesComment;   
        whipNol.Final_Planting_Date__c = finalPlantingDate;
                                                        
		if(selectedCropTypeData.RecordType.Name == napRmaNctAcrDataAccessor.NAP_DATA){
			whipNol.CropType__c = selectedCropTypeData.NAP_Crop_Type_Code__c;
			whipNol.IntendedUse__c = selectedCropTypeData.NAP_Intended_Use_Code__c;
			whipNol.Practice__c = selectedCropTypeData.NAP_Irrigation_Practice_Code__c;
			whipNol.PlantingPeriod__c = selectedCropTypeData.NAP_Planting_Period_Code__c;
            whipNol.CropYear__c=String.valueOf(selectedCropTypeData.NAP_Program_Year__c);            
            whipNol.Crop_Code__c=selectedCropTypeData.NAP_Crop_Code__c;
            whipNol.Crop_Intended_Use_Code__c=selectedCropTypeData.NAP_Intended_Use_Code__c;
		} else if(selectedCropTypeData.RecordType.Name == napRmaNctAcrDataAccessor.RMA_DATA){
			whipNol.CropType__c = selectedCropTypeData.RMA_Type_Code__c;
			whipNol.IntendedUse__c = selectedCropTypeData.RMA_Intended_Use_Code__c;
			whipNol.Practice__c = selectedCropTypeData.RMA_Practice_Code__c;
			whipNol.PlantingPeriod__c = selectedCropTypeData.RMA_Planting_Period_Code__c;
            whipNol.CropYear__c=String.valueOf(selectedCropTypeData.RMA_Program_Year__c);
            whipNol.Crop_Code__c=selectedCropData.ACR_Crop_Code__c;
            whipNol.Crop_Intended_Use_Code__c=selectedCropTypeData.RMA_Intended_Use_Code__c;
		} else if(selectedCropTypeData.RecordType.Name == napRmaNctAcrDataAccessor.ACR_DATA){
			whipNol.Crop__c = selectedCropTypeData.ACR_Crop_Name__c;
			whipNol.CropType__c = selectedCropTypeData.ACR_Crop_Type_Code__c;
			whipNol.IntendedUse__c = selectedCropTypeData.ACR_Crop_Intended_Use__c;
			whipNol.Practice__c = selectedCropTypeData.ACR_Irrigation_Practice_Code__c;
			whipNol.PlantingPeriod__c = selectedCropTypeData.ACR_Planting_Period_Code__c;
            whipNol.CropYear__c=String.valueOf(selectedCropTypeData.ACR_Program_Year__c);
            whipNol.Crop_Code__c=selectedCropTypeData.ACR_Crop_Code__c;
            whipNol.Crop_Intended_Use_Code__c=selectedCropTypeData.ACR_Crop_Intended_Use_Code__c;
        }
		return whipNol;
	}
	@auraEnabled
	public static Id insertWhipNol(WHIPNoticeofLoss__c whipNol){
		upsert whipNol;
		return whipNol.Id;
	}
}
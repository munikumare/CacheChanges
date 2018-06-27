public with sharing class NAP_RMA_NCT_ACR_DataAccessor {
	public final String ACR_DATA = 'ACR Data';
	public final String NAP_DATA = 'NAP Data';
	public final String RMA_DATA = 'RMA Data';

	public List<NAP_RMA_NCT_ACR_Data__c> getAllRecordsByCoreCustomerIdAndAcrType(String coreCustomerId, String acrCropTypeCode){
		return [
			SELECT Id,RecordType.Name,RecordTypeId,
					NAP_Crop_Type_Code__c,NAP_Crop_Code__c,RMA_Type_Code__c,ACR_Crop_Type_Code__c,
					NAP_Intended_Use_Code__c,RMA_Intended_Use_Code__c, ACR_Crop_Intended_Use__c,
					NAP_Irrigation_Practice_Code__c, RMA_Practice_Code__c, ACR_Irrigation_Practice_Code__c,
					NAP_Planting_Period_Code__c,RMA_Planting_Period_Code__c,ACR_Planting_Period_Code__c,
            		NAP_Program_Year__c,ACR_Program_Year__c,RMA_Program_Year__c,ACR_Crop_Code__c,
            		ACR_Crop_Intended_Use_Code__c
			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE CCID__c = :coreCustomerId
			AND (ACR_Crop_Type_Code__c = :acrCropTypeCode
			OR NAP_Crop_Type_Code__c = :acrCropTypeCode)
		];
	}
	public List<NAP_RMA_NCT_ACR_Data__c> getAllRecordsByCoreCustomerIdAndAcrTypeAndRmaTypeCodes(String coreCustomerId, String acrCropCode, Set<String> rmaTypeCodes){
        return [
			SELECT Id,RecordType.Name,RecordTypeId,
					NAP_Crop_Type_Code__c,NAP_Crop_Code__c,RMA_Type_Code__c,ACR_Crop_Type_Code__c,
					NAP_Intended_Use_Code__c,RMA_Intended_Use_Code__c, ACR_Crop_Intended_Use__c,
					NAP_Irrigation_Practice_Code__c, RMA_Practice_Code__c, ACR_Irrigation_Practice_Code__c,
					NAP_Planting_Period_Code__c,RMA_Planting_Period_Code__c,ACR_Planting_Period_Code__c,
            		NAP_Program_Year__c,ACR_Program_Year__c,RMA_Program_Year__c,ACR_Crop_Code__c,
            		ACR_Crop_Intended_Use_Code__c
			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE CCID__c = :coreCustomerId
			AND (ACR_Crop_Code__c = :acrCropCode
			OR NAP_Crop_Code__c = :acrCropCode
			OR RMA_Type_Code__c IN :rmaTypeCodes)
		];
	}
    public NAP_RMA_NCT_ACR_Data__c getDataById(Id recordId){
        return [
                SELECT Id,RecordType.Name, RecordTypeId,ACR_Crop_Name__c,
                NAP_Crop_Type_Code__c,RMA_Type_Code__c,ACR_Crop_Type_Code__c,NAP_Crop_Code__c,
                NAP_Intended_Use_Code__c,RMA_Intended_Use_Code__c, ACR_Crop_Intended_Use__c,
                NAP_Irrigation_Practice_Code__c, RMA_Practice_Code__c, ACR_Irrigation_Practice_Code__c,
                NAP_Planting_Period_Code__c,RMA_Planting_Period_Code__c,ACR_Planting_Period_Code__c,
                ACR_Program_Year__c,NAP_Program_Year__c,RMA_Program_Year__c,ACR_Crop_Code__c,
            	ACR_Crop_Intended_Use_Code__c
                FROM NAP_RMA_NCT_ACR_Data__c
                WHERE Id =:recordId
            ];
    }
	public List<NAP_RMA_NCT_ACR_Data__c> getAllAcrRecordsByCoreCustomerId(String coreCustomerId){
		return [
			SELECT Id,RecordType.Name,RecordTypeId,ACR_Crop_Name__c, ACR_Crop_Type_Code__c, 
           	ACR_Crop_Intended_Use__c, ACR_Irrigation_Practice_Code__c, ACR_Planting_Period_Code__c,
            ACR_Program_Year__c,ACR_Crop_Code__c,ACR_Crop_Intended_Use_Code__c
			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE CCID__c = :coreCustomerId
			AND RecordType.Name = :ACR_DATA
		];
	}
}
public with sharing class FPAC_ACR_DataConverter {
    private static string ACR_RECORD_TYPE = 'ACR Data';
	private static final String NATIVE_SOD_INDICATOR = 'Y';

    public List<NAP_RMA_NCT_ACR_Data__c> ToNapRmaNctAcrData (FPAC_ACR_DataResponse acrDataResponse, string coreCustomerId)
    {
        List<NAP_RMA_NCT_ACR_Data__c> acrDataList = new List<NAP_RMA_NCT_ACR_Data__c>();
       
        if (acrDataResponse != null && 
            acrDataResponse.Farms != null) 
        {
        	 
        	Id acrRecordTypeId = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c
            								.getRecordTypeInfosByName()
                  							.get(ACR_RECORD_TYPE)
            								.getRecordTypeId();
        	
        	
            for(FPAC_ACR_Farm farm : acrDataResponse.Farms)
            {
            	String StateCode = farm.StateCode;
            	String countyCode = farm.CountyCode;
            	
            	if (farm.FarmYears != null)
            	{
            		for(FPAC_ACR_FarmYear farmYear : farm.FarmYears)
            		{
            			if (farmYear.Tracts != null)
            			{
            				for(FPAC_ACR_Tract tract : farmYear.Tracts)
            				{
            					if (tract.AgriculturalProductionPlans != null)
            					{
            						for (FPAC_ACR_AgriculturalProductionPlan agriculturalProductionPlan : tract.AgriculturalProductionPlans)
            						{ 
            							String status =  agriculturalProductionPlan.CropStatusCode +
            											agriculturalProductionPlan.SupplementalCropStatusCode + 
            											agriculturalProductionPlan.ConcurrentPlantingCode;
            											
            							boolean recordAddedToList = false;
            							
            							if (agriculturalProductionPlan.ProducerShares != null)
            							{
            								for (FPAC_ACR_ProducerShare producerShare : agriculturalProductionPlan.ProducerShares)
		            						{
		            							if (producerShare.CoreCustomerId == coreCustomerId)
		            							{
		            								
			            							NAP_RMA_NCT_ACR_Data__c acrData = new NAP_RMA_NCT_ACR_Data__c();
									                acrData.RecordTypeId = acrRecordTypeId;
									                acrData.CCID__c = coreCustomerId;
									                acrData.State_Code__c = stateCode;
									                acrData.County_Code__c = countyCode;
									                acrData.ACR_Farm_Number__c = farm.FarmNumber;
									                acrData.ACR_Tract_Number__c = tract.TractNumber;
									                acrData.ACR_Share__c = producerShare.Share;
									                
									                if (!String.IsBlank(agriculturalProductionPlan.ReportedAcres))
									                	acrData.ACR_Reported_Acres__c = Decimal.ValueOf(agriculturalProductionPlan.ReportedAcres);
									                
									                if (!String.IsBlank(farmYear.ProgramYear))
									                	acrData.ACR_Program_Year__c = Decimal.ValueOf(farmYear.ProgramYear);
									                
									                acrData.ACR_Planting_Period_Code__c = agriculturalProductionPlan.PlantingPeriodCode;
									                acrData.ACR_Organic_Status_Code__c = agriculturalProductionPlan.OrganicStatusCode;
									                acrData.ACR_Native_Sod_Indicator__c = agriculturalProductionPlan.NativeSodIndicator == NATIVE_SOD_INDICATOR;
									                acrData.ACR_NAP_Unit_Number__c = agriculturalProductionPlan.NAPUnitNumber;
									                acrData.ACR_Irrigation_Practice_Code__c = agriculturalProductionPlan.IrrigationPracticeCode;
									                
									                acrData.ACR_Status__c = status;
									                acrData.ACR_FIELD__c = agriculturalProductionPlan.FieldNumber;
									                
									                if (!String.IsBlank(agriculturalProductionPlan.CertificationDate))
									                	acrData.ACR_CERTIFIED__c = Date.ValueOf(agriculturalProductionPlan.CertificationDate);
									                	
									                if (!String.IsBlank(agriculturalProductionPlan.CropPlantedDate))
									                	acrData.ACR_Plant_Date__c = Date.ValueOf(agriculturalProductionPlan.CropPlantedDate);
									                
									                acrData.ACR_Crop_Code__c = agriculturalProductionPlan.CropCode;
									                acrData.ACR_Crop_Intended_Use_Code__c = agriculturalProductionPlan.IntendedUseCode;
									                
									                
									               // if (!String.IsBlank(agriculturalProductionPlan.DeterminedAcresPresent))
									                //	acrData.ACR_Determined_Acres__c = Decimal.ValueOf(agriculturalProductionPlan.DeterminedAcresPresent);
									                
									                acrData.ACR_Crop_Type_Code__c = agriculturalProductionPlan.CropTypeCode;
									                acrData.ACR_Crop_Name__c = agriculturalProductionPlan.CropName;
									                acrData.ACR_Crop_Intended_Use__c = agriculturalProductionPlan.IntendedUseName;
			            							acrDataList.Add(acrData);
			            							recordAddedToList = true;
		            							}
		            						}
            							}
            							
            							if(recordAddedToList == false)
            							{
            								
            								NAP_RMA_NCT_ACR_Data__c acrData = new NAP_RMA_NCT_ACR_Data__c();
							                acrData.RecordTypeId = acrRecordTypeId;
							                acrData.CCID__c = coreCustomerId;
							                acrData.State_Code__c = stateCode;
								            acrData.County_Code__c = countyCode;
								            acrData.ACR_Farm_Number__c = farm.FarmNumber;
									        acrData.ACR_Tract_Number__c = tract.TractNumber;
									            
							                if (!String.IsBlank(agriculturalProductionPlan.ReportedAcres))
								                	acrData.ACR_Reported_Acres__c = Decimal.ValueOf(agriculturalProductionPlan.ReportedAcres);
								                
							                if (!String.IsBlank(farmYear.ProgramYear))
							                	acrData.ACR_Program_Year__c = Decimal.ValueOf(farmYear.ProgramYear);
							                
							                acrData.ACR_Planting_Period_Code__c = agriculturalProductionPlan.PlantingPeriodCode;
							                acrData.ACR_Organic_Status_Code__c = agriculturalProductionPlan.OrganicStatusCode;
							                acrData.ACR_Native_Sod_Indicator__c = agriculturalProductionPlan.NativeSodIndicator == NATIVE_SOD_INDICATOR;
							                acrData.ACR_NAP_Unit_Number__c = agriculturalProductionPlan.NAPUnitNumber;
							                acrData.ACR_Irrigation_Practice_Code__c = agriculturalProductionPlan.IrrigationPracticeCode;
							                
							                acrData.ACR_Status__c = status;
							                acrData.ACR_FIELD__c = agriculturalProductionPlan.FieldNumber;
							                
							                if (!String.IsBlank(agriculturalProductionPlan.CertificationDate))
							                	acrData.ACR_CERTIFIED__c = Date.ValueOf(agriculturalProductionPlan.CertificationDate);
							                	
							                if (!String.IsBlank(agriculturalProductionPlan.CropPlantedDate))
							                	acrData.ACR_Plant_Date__c = Date.ValueOf(agriculturalProductionPlan.CropPlantedDate);
							                
							                acrData.ACR_Crop_Code__c = agriculturalProductionPlan.CropCode;
							                acrData.ACR_Crop_Intended_Use_Code__c = agriculturalProductionPlan.IntendedUseCode;
									                
							                
							                //if (!String.IsBlank(agriculturalProductionPlan.DeterminedAcresPresent))
							                //	acrData.ACR_Determined_Acres__c = Decimal.ValueOf(agriculturalProductionPlan.DeterminedAcresPresent);
							                
							                acrData.ACR_Crop_Type_Code__c = agriculturalProductionPlan.CropTypeCode;
							                acrData.ACR_Crop_Name__c = agriculturalProductionPlan.CropName;
							                acrData.ACR_Crop_Intended_Use__c = agriculturalProductionPlan.IntendedUseName;
	            							acrDataList.Add(acrData);
            							}
            						}
            					}
            				}
            			}
            		}
            	}
               
            }
        }
        return acrDataList;  
    } 
}
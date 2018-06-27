public with sharing class FPAC_NCT_DataProcessor {
	
	public void ProcessData(decimal year, string stateFsaCode, string countyFsaCode, string cropCode, string cropType, string cropUse)
    {
    	Integer nctDataCount = [SELECT count() FROM NAP_RMA_NCT_ACR_Data__c 
    								WHERE NCT_Program_Year__c = :year AND
										State_Code__c = :stateFsaCode AND
										County_Code__c = :countyFsaCode AND
										NCT_Crop_Code__c = :cropCode AND
										NCT_Crop_Type__c = :cropType AND
										NCT_Crop_Intended_Use__c = :cropUse];
    	 
    	System.Debug('nctDataCount - ' + nctDataCount); 
    	if (nctDataCount == 0)
    	{
	    	FPAC_NCT_DataResponse nctDataResponse = GetData(year, stateFsaCode, countyFsaCode, cropCode, cropType, cropUse);
	    	system.debug(nctDataResponse);
            SaveData(year, stateFsaCode, countyFsaCode, cropCode, cropType, cropUse, nctDataResponse);
    	}
    }
	
    public FPAC_NCT_DataResponse GetData(decimal year, string stateFsaCode, string countyFsaCode, string cropCode, string cropType, string cropUse)
    {
    	FPAC_NCT_DataResponse nctDataResponse = new FPAC_NCT_DataResponse();
    	FPAC_NCT_DataRetrieval nctDataRetrieval = new FPAC_NCT_DataRetrieval();
   
		FPAC_NCT_WhipInformationResponse whipInformationResponse = nctDataRetrieval.GetApprovedWhipInformation(year, stateFsaCode, countyFsaCode, cropCode, cropType, cropUse);
		nctDataResponse.WhipInformationResponse = whipInformationResponse;
    
    	System.Debug('WhipInformationResponse - ' + whipInformationResponse); 
    
    	return nctDataResponse;  
    }
    
    public List<NAP_RMA_NCT_ACR_Data__c> ConvertToNapRmaNctAcrData(FPAC_NCT_DataResponse nctDataResponse)
    {
    	FPAC_NCT_DataConverter converter = new FPAC_NCT_DataConverter();
    	return converter.ToNapRmaNctAcrData(nctDataResponse);
    }
     
    
    private void SaveData(decimal year, string stateFsaCode, string countyFsaCode, 
    						string cropCode, string cropType, string cropUse, FPAC_NCT_DataResponse nctDataResponse)
    {
    		 
    	List<NAP_RMA_NCT_ACR_Data__c> nctDataToDelete = [SELECT id FROM NAP_RMA_NCT_ACR_Data__c 
															WHERE NCT_Crop_Code__c = :cropCode AND 
																NCT_Program_Year__c = :year AND
																State_Code__c = :stateFsaCode AND
																County_Code__c = :countyFsaCode AND
																NCT_Crop_Type__c = :cropType AND
																NCT_Crop_Intended_Use__c = :cropUse];
    	delete nctDataToDelete;
    	
    	System.Debug('nctDataToDelete - ' + nctDataToDelete.size()); 

    	List<NAP_RMA_NCT_ACR_Data__c> nctDataList = ConvertToNapRmaNctAcrData(nctDataResponse);
    	System.Debug('nctDataList - ' + nctDataList.size()); 
    	System.Debug(nctDataList); 
    	insert nctDataList;
    	System.debug ('-- created nct data');
    }
}
public with sharing class FPAC_ACR_DataProcessor {
    
    public void ProcessData(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
    	FPAC_ACR_DataResponse acrDataResponse = GetData(coreCustomerId, programYear, stateFsaCode, countyFsaCode);
    	SaveData(coreCustomerId, programYear, stateFsaCode, countyFsaCode, acrDataResponse);
    }
    
    public FPAC_ACR_DataResponse GetData(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
    	FPAC_ACR_DataRetrieval acrDataRetrieval = new FPAC_ACR_DataRetrieval();
    	
    	return acrDataRetrieval.GetCompilanceFarmData(coreCustomerId, programYear, stateFsaCode, countyFsaCode);
    }
    
    public List<NAP_RMA_NCT_ACR_Data__c> ConvertToNapRmaNctAcrData(FPAC_ACR_DataResponse acrDataResponse, string coreCustomerId)
    {
    	FPAC_ACR_DataConverter converter = new FPAC_ACR_DataConverter();
    	return converter.ToNapRmaNctAcrData(acrDataResponse, coreCustomerId);
    }
     
    
    private void SaveData(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode, FPAC_ACR_DataResponse acrDataResponse)
    {
    		 
    	List<NAP_RMA_NCT_ACR_Data__c> acrDataToDelete = [SELECT id FROM NAP_RMA_NCT_ACR_Data__c 
																WHERE CCID__c = :coreCustomerId AND 
																	ACR_Program_Year__c = :programYear AND
																	State_Code__c = :stateFsaCode AND
																	County_Code__c = :countyFsaCode];
    	delete acrDataToDelete;
            		 
    	List<NAP_RMA_NCT_ACR_Data__c> acrDataList = ConvertToNapRmaNctAcrData(acrDataResponse, coreCustomerId);
    	  											 
    	insert acrDataList;
    }
}
public with sharing class FPAC_NAP_DataProcessor { 
    
    public void ProcessData(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
    	FPAC_NAP_DataResponse napDataResponse = GetData(coreCustomerId, programYear, stateFsaCode, countyFsaCode);
    	SaveData(coreCustomerId, programYear, stateFsaCode, countyFsaCode, napDataResponse);
    }
    
    public FPAC_NAP_DataResponse GetData(string coreCustomerId, decimal programYear, string stateFsaCode, string countyFsaCode)
    {
    	FPAC_NAP_DataResponse napDataResponse = new FPAC_NAP_DataResponse();
    	FPAC_NAP_DataRetrieval napDataRetrieval = new FPAC_NAP_DataRetrieval();
    	 
    	FPAC_NAP_CoverageByProducerResponse coverageByProducerResponse = napDataRetrieval.GetCoverageByProducer(coreCustomerId, programYear, stateFsaCode, countyFsaCode);
    	//FPAC_NAP_NoticeOfLossByProducerResponse noticeOfLossByProducerResponse = napDataRetrieval.GetNoticeOfLossByProducer(coreCustomerId, programYear, stateFsaCode, countyFsaCode);
    	FPAC_NAP_ApplicationByProducerResponse applicationByProducerResponse = napDataRetrieval.GetApplicationByProducer(coreCustomerId, programYear, stateFsaCode, countyFsaCode);
    	
    	napDataResponse.CoverageByProducerResponse = coverageByProducerResponse;
    	//napDataResponse.NoticeOfLossByProducerResponse = noticeOfLossByProducerResponse;
    	napDataResponse.ApplicationByProducerResponse = applicationByProducerResponse;
     
    	return napDataResponse;
    }
     
    public List<NAP_RMA_NCT_ACR_Data__c> ConvertToNapRmaNctAcrData(FPAC_NAP_DataResponse napDataResponse)
    {
    	FPAC_NAP_DataConverter converter = new FPAC_NAP_DataConverter();
    	return converter.ToNapRmaNctAcrData(napDataResponse);
    }
    
    
    private void SaveData(string coreCustomerId, decimal year, string stateFsaCode, string countyFsaCode, FPAC_NAP_DataResponse napDataResponse)
    {
    	//decimal year = null;
            	
    	//if (!String.IsBlank(programYear))
    	//	 year = Decimal.ValueOf(programYear);
    		 
    	List<NAP_RMA_NCT_ACR_Data__c> napDataToDelete = [SELECT id FROM NAP_RMA_NCT_ACR_Data__c 
																WHERE CCID__c = :coreCustomerId AND 
																	NAP_Program_Year__c = :year AND
																	State_Code__c = :stateFsaCode AND
																	County_Code__c = :countyFsaCode];
    	delete napDataToDelete;
            		 
    	List<NAP_RMA_NCT_ACR_Data__c> napDataList = ConvertToNapRmaNctAcrData(napDataResponse);
    	  											 
    	insert napDataList;
    }
   
}
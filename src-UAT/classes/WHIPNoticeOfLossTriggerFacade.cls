public class WHIPNoticeOfLossTriggerFacade {
   
     public static WHIPNoticeOfLossTriggerFacade createWHIPNoticeOfLossTriggerFacade() {
        return new WHIPNoticeOfLossTriggerFacade(           
            );
   	 }
    
    public void createNCTRecords(List<WHIPNoticeofLoss__c> whipnoticeoflosses) {
           decimal cropYear;
           string stateCode;
           string countyCode; 
           string cropTypeCode;
           string cropCode; 
           string intendedUseCode;
           for (WHIPNoticeofLoss__c nol : whipnoticeoflosses) {   
                 if(nol.CropYear__c != null)  
                 {
                    stateCode = [SELECT AdminStateCode__c FROM WHIP_Application__c WHERE ID=:nol.WHIP_Application__c LIMIT 1].AdminStateCode__c;
                    countyCode= [SELECT AdminCountyCode__c FROM WHIP_Application__c WHERE ID=:nol.WHIP_Application__c LIMIT 1].AdminCountyCode__c;
                    cropCode = nol.Crop_Code__c; 
                    cropYear =  Decimal.ValueOf(nol.CropYear__c); 
                    cropTypeCode =nol.CropType__c; 
           			intendedUseCode =nol.Crop_Intended_Use_Code__c;
                     
                    if (cropTypeCode == null)
                    {
                      cropTypeCode ='';  
                    }
                     if (intendedUseCode == null)
                    {
                      intendedUseCode ='';  
                    }   
                    createNCTRecordsCallout(cropYear,stateCode,countyCode,cropCode,cropTypeCode,intendedUseCode);   
                 }
           } 
     }
    
    @future (callout=true)
    public static void createNCTRecordsCallout(decimal programYear, string stateFsaCode, string countyFsaCode, string cropCode, string cropTypeCode, string intendedUseCode)
    {
        	FPAC_NCT_DataResponse nctDataResponse = new FPAC_NCT_DataResponse();  
            FPAC_NCT_DataProcessor fnp = new FPAC_NCT_DataProcessor();
            fnp.ProcessData(programYear, stateFsaCode, countyFsaCode, cropCode,cropTypeCode,intendedUseCode); 
    }
}
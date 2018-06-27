public without sharing class FPAC_SCIMS_Tract {
    public string ScimsNumber {get; set;}
    
    //********** POTDATA-128 ****************
    public string FarmNumber {get; set;}
    public string TractNumberDisplayValue {get{
    	return ScimsNumber.replaceFirst('^0+','');
    }}
    public string AdminStateCode {get; set;}
    public string AdminCountyCode {get; set;}
    public string StateCountyAnsiCode {get{
    	return AdminStateCode + AdminCountyCode;
    }}
    public string Operator {get; set;}
    //***************************************
    
    public decimal CroplandAcres {get; set;}	
    public decimal CrpAcres	{get; set;}	
    public decimal FarmlandAcres {get; set;}	
    public string HelCode {get; set;}		
    public string InactiveIndicator {get; set;}	
    public List<FPAC_SCIMS_OtherProducer> Owners {get; set;}
    public List<FPAC_SCIMS_OtherProducer> OtherProducers {get; set;}    
    public decimal MplAcres	{get; set;}	
    public decimal NapCropAcres	{get; set;}	
    public decimal OtherConsrvAcres	{get; set;}	
    public decimal StateConsrvAcres	{get; set;}	
    public decimal SugarcaneAcres {get; set;}	
    public decimal WbpAcres	{get; set;}	
    public string WetlandCode {get; set;}	
    public string WetlandViolation {get; set;}
    public decimal WrpAcres	{get; set;}	
    public List<FPAC_SCIMS_Crop> Crops {get; set;}
    public List<FPAC_SCIMS_CommonLandUnitYear> CommonLandUnitYears {get; set;}
    public string Description {get; set;}    
    public string StateCountyCode {get; set;}		
    public decimal DcpCroplandAcres	{get; set;}	
    public decimal DcpDoubleCropAcres {get; set;}	
    public decimal DcpEffectiveCroplandAcres {get; set;}		
    public string FavWRHistoryIndicator	{get; set;}	
    public decimal GrpAcres	{get; set;}	
    public string SodAcres	{get; set;}	
    public string NumberBIA	{get; set;}	
    public string WetlandCertCode {get; set;}	
    public Integer WetlandCertYear {get; set;}	
    
    public string FarmId {get; set;}
    public string TractId {get; set;}

    public string ParentExternalId {get; set;}
    public string CalculatedId{get{
        return ParentExternalId + ScimsNumber;
    }}

    public List<Land__c> Save(List<Land__c> tracts)
    {
        List<Land__c> finalLandList = new List<Land__c>();
        Database.UpsertResult[] resultsForTract = Database.upsert(tracts, Land__c.Land_ID__c.getDescribe().getSObjectField(), false);  
           
        System.Debug('Saved tracts');
        for(Integer index = 0, size = resultsForTract.size(); index < size; index ++) {
            if(resultsForTract[index].isSuccess()) {
                    System.debug(tracts[index].Land_ID__c + ' was created/updated');
                    finalLandList.add(tracts[index]);
            }
            else
            {
                for(Database.Error error : resultsForTract[index].getErrors())
                {
                    System.debug('Error with tract ' + tracts[index].Land_ID__c + ' - ' + error.getMessage());
                    //finalLandList.add(lands[index]);
                }
            }
        }
        return finalLandList;
    }
}
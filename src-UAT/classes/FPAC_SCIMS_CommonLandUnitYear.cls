public without sharing class FPAC_SCIMS_CommonLandUnitYear {
	
	//********** POTDATA-128 ****************
	public string FieldNumberDisplayValue {get{
    	return FieldNumber.replaceFirst('^0+','');
    }}
	public string FarmNumber {get; set;}
	public string TractNumber {get; set;}
    public string AdminStateCode {get; set;}
    public string AdminCountyCode {get; set;}
    public string Operator {get; set;}
	//***************************************
	
    public string AlternateId {get; set;}
    public string InactiveIndicator {get; set;}	
    public string StateCountyFsaCode {get; set;}	
    public string StateCountyAnsiCode	 {get; set;}
    public string LandClassificationId {get; set;}	
    public string CongressionalDistrictCode {get; set;}	
    public string FieldNumber {get; set;}
    public decimal CluAcreage {get; set;}	
    public List<FPAC_SCIMS_OtherProducer> OtherProducers {get; set;}
    public string HelStatusIdentifier {get; set;}	
    public string CroplandIndicator3cm {get; set;}
    public string CrpContractNumber {get; set;}
    public string CrpContractExpirationDate {get; set;}
    public string NativeSodConversionDate {get; set;}
    public string ConservationPracticeId {get; set;}
    public string SodConversionCropYears1 {get; set;}
    public string SodConversionCropYears2 {get; set;}
    public string SodConversionCropYears3 {get; set;}
    public string SodConversionCropYears4 {get; set;}
    
    public string TractId {get; set;}
    public string ParentExternalId{get; set;}
    public string CalculatedId {get{
        return ParentExternalId + AlternateId;
    }}

    public List<Land__c> Save(List<Land__c> fields)
    {
        List<Land__c> finalLandList = new List<Land__c>();
        Database.UpsertResult[] resultsForField = Database.upsert(fields, Land__c.Land_ID__c.getDescribe().getSObjectField(), false);  
                
        System.Debug('Saved fields');
        for(Integer index = 0, size = resultsForField.size(); index < size; index++) {
            if(resultsForField[index].isSuccess()) {
                    System.debug(fields[index].Land_ID__c +' was created/updated');
                    finalLandList.add(fields[index]);
            }
            else
            {
                for(Database.Error error : resultsForField[index].getErrors())
                {
                    System.debug('Error with base yield ' + fields[index].Land_ID__c + ' - ' + error.getMessage());
                }
            }
        }
        return finalLandList;
    }
}
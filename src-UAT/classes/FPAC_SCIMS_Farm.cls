public without sharing class FPAC_SCIMS_Farm {
    public string ScimsNumber {get; set;}
    
    public string FarmNumberDisplayValue {get{
    	return ScimsNumber.replaceFirst('^0+','');
    }}
    
    public string StateCountyAnsiCode {get{
    	return AdminStateCode + AdminCountyCode;
    }}
    
    public string Id {get; set;}
    public string AdminStateCode {get; set;}
    public string AdminCountyCode {get; set;}
    public List<FPAC_SCIMS_FarmYear> FarmYears {get; set;}
    public string Description {get; set;}
    public string ReconPendingCode {get; set;}
    
    
    public string CoreCustomerId {get; set;}
    public string IndividualId {get; set;}
    public string FarmId {get; set;}
    public string CalculatedId{
        get{
            return ScimsNumber + AdminStateCode + AdminCountyCode;
        }
    }

    public List<Land__c> Save(List<Land__c> lands)
    {
        List<Land__c> finalLandList = new List<Land__c>();
        Database.UpsertResult[] resultsForLand = Database.upsert(lands, Land__c.Land_ID__c.getDescribe().getSObjectField(), false);  

        System.Debug('Saved lands');
        for(Integer index = 0, size = resultsForLand.size(); index < size; index++) {
            if(resultsForLand[index].isSuccess()) {
                    System.debug(lands[index].Land_ID__c +' was created/updated');
                    finalLandList.add(lands[index]);
            }
            else
            {
                for(Database.Error error : resultsForLand[index].getErrors())
                {
                    System.debug('Error with land ' + lands[index].Land_ID__c + ' - ' + error.getMessage());
                    //finalLandList.add(lands[index]);
                }
            }
        }
        return finalLandList;
    }
}
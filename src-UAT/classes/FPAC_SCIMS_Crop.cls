public without sharing class FPAC_SCIMS_Crop {
    public string Abbr {get; set;}
    public string CcYield {get; set;}
    public string Code {get; set;}
    public string TypeCode {get; set;}
    public string TypeName {get; set;}
    public decimal CrpReductionAcres {get; set;}
    public decimal CrpReleasedAcres {get; set;}
    public Integer CrpYield {get; set;}
    public string DcpBaseAcres {get; set;}
    public string FavReductionAcres {get; set;}
    public Integer DirectYield {get; set;}
    public string Name {get; set;}

    public string LandId {get; set;}
    public string ParentExternalId{get; set;}
    public string CalculatedId {
        get{
            return ParentExternalId + Code;
    }}

    public void Save(List<Base_Yield__c> baseYields)
    {
        Database.UpsertResult[] resultsForBaseYield = Database.upsert(baseYields, Base_Yield__c.Crop_ID__c.getDescribe().getSObjectField(), false);  
                
        System.Debug('Saved base yields');
        for(Integer index = 0, size = resultsForBaseYield.size(); index < size; index++) {
            if(resultsForBaseYield[index].isSuccess()) {
                    System.debug(baseYields[index].Crop_ID__c +' was created/updated');
            }
            else
            {
                for(Database.Error error : resultsForBaseYield[index].getErrors())
                {
                    System.debug('Error with base yield ' + baseYields[index].Crop_ID__c + ' - ' + error.getMessage());
                }
            }
        }
    }
}
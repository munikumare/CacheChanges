public without sharing class FPAC_SCIMS_Election_Hip {
    public string Abbr {get; set;}
    public string Code {get; set;}
    public string TypeCode {get; set;}
    public string TypeName {get; set;}
    public string Name {get; set;}
    public string ElectionCode {get; set;}

    public string FarmId {get; set;}
    public string ParentExternalId{get; set;}
    public string CalculatedId {
        get{
            if (!String.isBlank(TypeCode))
            	return ParentExternalId + Code + TypeCode;
            else
                return ParentExternalId + Code;
    }}

    public void Save(List<Election_Hip__c> electionsAndHips)
    {
        Database.UpsertResult[] resultsForElection = Database.upsert(electionsAndHips, Election_Hip__c.Election_Hip_ID__c.getDescribe().getSObjectField(), false);  
           
            System.Debug('Saved elections and hips');
            
            for(Integer index = 0, size = resultsForElection.size(); index < size; index ++) {
                if(resultsForElection[index].isSuccess()) {
                        System.debug(electionsAndHips[index].Election_Hip_ID__c + ' was created/updated');
                }
                else
                {
                    for(Database.Error error : resultsForElection[index].getErrors())
                    {
                        System.debug('Error with election/hip ' + electionsAndHips[index].Election_Hip_ID__c + ' - ' + error.getMessage());
                    }
                }
            }
    }
}
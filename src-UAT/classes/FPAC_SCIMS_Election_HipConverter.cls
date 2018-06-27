public class FPAC_SCIMS_Election_HipConverter{
    public static List<Election_Hip__c> ConvertToElectionHips(List<FPAC_SCIMS_Election_Hip> scimsElectionsHips)
    {
        List<Election_Hip__c> electionHipList = new List<Election_Hip__c>();
        if(scimsElectionsHips != null)
        {
            for(FPAC_SCIMS_Election_Hip scimsElectionHip : scimsElectionsHips)
            {
                Election_Hip__c electionHip = new Election_Hip__c();
                //land.Farm_Number__c = scimsFarm.Number;
                electionHip.Abbreviation__c = scimsElectionHip.Abbr;
                electionHip.Code__c = scimsElectionHip.Code;
                electionHip.Type_Code__c = scimsElectionHip.TypeCode;
                electionHip.Type_Name__c = scimsElectionHip.TypeName;
                electionHip.Name__c = scimsElectionHip.Name;
                electionHip.Name = scimsElectionHip.Name;
                electionHip.Election_Code__c = scimsElectionHip.ElectionCode;

                electionHip.Land__c = scimsElectionHip.FarmId;
                electionHip.Election_Hip_ID__c = scimsElectionHip.CalculatedId;
                electionHipList.Add(electionHip);
            }
        }
        return electionHipList;
    }
}
public with sharing class FPAC_SCIMS_FarmYearConverter{

    public static List<Land__c> ConvertToLands(List<FPAC_SCIMS_Farm> scimsFarms)
    {
        List<Land__c> lands = new List<Land__c>();
        Id landRecordTypeId = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();

        for(FPAC_SCIMS_Farm scimsFarm : scimsFarms)
        {
            Land__c land = new Land__c();
            
            land.Name = scimsFarm.FarmNumberDisplayValue;
            land.RecordTypeId = landRecordTypeId;
            land.Updated_From_SCIMS__c = Date.today();
            land.Farm_Number__c = scimsFarm.ScimsNumber;
            //land.Individual__c = scimsFarm.IndividualId;
           

            if (!string.isBlank(scimsFarm.Id))
                land.Identifier__c = Integer.valueOf(scimsFarm.Id);

			land.State_County_ANSI_Code__c = scimsFarm.StateCountyAnsiCode;
            land.Admin_State_Code__c = scimsFarm.AdminStateCode;
            land.Admin_County_Code__c = scimsFarm.AdminCountyCode;
            land.Description__c = scimsFarm.Description;
            land.Recon_Pending_Code__c = scimsFarm.ReconPendingCode;
            land.Land_ID__c = scimsFarm.CalculatedId;

            if (scimsFarm.FarmYears != null && scimsFarm.FarmYears.size() > 0)
            {
                FPAC_SCIMS_FarmYear farmYear = scimsFarm.FarmYears[0];
                land.CRP_Acres__c = farmYear.CrpAcres;

                if (!string.isBlank(farmYear.InactiveIndicator))
                    land.Inactive_Indicator__c = Boolean.valueOf(farmYear.InactiveIndicator);

				if (farmYear.Operator != null)
				{
					land.FarmOperator__c = farmYear.Operator.CommonName; 
				}

                land.MPL_Acres__c = String.Valueof(farmYear.MplAcres);
                land.Current_Year__c = String.Valueof(farmYear.Year);
                land.DCP_Base_Exceeds_Cropland_Indicator__c = Boolean.Valueof(farmYear.DcpBaseExceedsCroplandIndicator);
                land.DCP_Double_Crop_Acres__c = farmYear.DcpDoubleCropAcres;
                land.FSA_540_Indicator__c = Boolean.Valueof(farmYear.Fsa540Indicator);
            }

            lands.add(land);
        }
        return lands;
    }
    
}
public with sharing class FPAC_SCIMS_TractConverter{
    public static List<Land__c> ConvertToLands(List<FPAC_SCIMS_Tract> scimsTracts)
    {
        List<Land__c> tracts = new List<Land__c>();
        Id tractRecordTypeId = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('TRACT').getRecordTypeId();

        for(FPAC_SCIMS_Tract scimsTract : scimsTracts)
        {
            Land__c tract = new Land__c();
            
            tract.Name = scimsTract.TractNumberDisplayValue;
            tract.RecordTypeId = tractRecordTypeId;
            
            tract.Tract_Number__c = scimsTract.ScimsNumber;
            tract.Farm_Number__c = scimsTract.FarmNumber;
            tract.Admin_State_Code__c = scimsTract.AdminStateCode;
            tract.Admin_County_Code__c = scimsTract.AdminCountyCode;
            tract.FarmOperator__c = scimsTract.Operator; 
            
            tract.Cropland_Acres__c = scimsTract.CroplandAcres;
            tract.CRP_Acres__c = scimsTract.CrpAcres;
            tract.Farmland_Acres__c = scimsTract.FarmlandAcres;
            tract.HEL_Code__c = scimsTract.HelCode;
            tract.Inactive_Indicator__c = Boolean.Valueof(scimsTract.InactiveIndicator);
            tract.MPL_Acres__c = String.Valueof(scimsTract.MplAcres);
            tract.NAP_Crop_Number__c = scimsTract.NapCropAcres;
            tract.Other_Conserve_Acres__c = scimsTract.OtherConsrvAcres;
            tract.State_Conserve_Acres__c = scimsTract.StateConsrvAcres;
            tract.Sugarcane_Acres__c = scimsTract.SugarcaneAcres;
            tract.WBP_Acres__c = scimsTract.WbpAcres;
            tract.Wetland_Code__c = scimsTract.WetlandCode;
            tract.Wetland_Violation__c = scimsTract.WetlandViolation;
            tract.WRP_Acres__c = scimsTract.WrpAcres;
            tract.Description__c = scimsTract.Description;
            tract.State_County_ANSI_Code__c = scimsTract.StateCountyAnsiCode;
            tract.DCP_Cropland_Acres__c = scimsTract.DcpCroplandAcres;
            tract.DCP_Double_Crop_Acres__c = scimsTract.DcpDoubleCropAcres;
            tract.DCP_Effective_Cropland_Acres__c = scimsTract.DcpEffectiveCroplandAcres;
            
            if (scimsTract.FavWRHistoryIndicator != null)
            	tract.Fav_WR_History_Indicator__c = Boolean.Valueof(scimsTract.FavWRHistoryIndicator);
            
            tract.Grp_Acres__c = scimsTract.GrpAcres;
            
            if(!string.isBlank(scimsTract.SodAcres))
            	tract.SOD_Acres__c = Decimal.ValueOf(scimsTract.SodAcres);
            
            tract.BIA_Number__c = scimsTract.NumberBIA;
            tract.Wetland_Cert_Code__c = scimsTract.WetlandCertCode;
            
            tract.Land_ID__c = scimsTract.CalculatedId;
            tract.Parent_ID__c = scimsTract.FarmId;

            tracts.Add(tract);
            
        }
        return tracts;
    }
    
}
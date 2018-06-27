public with sharing class FPAC_SCIMS_CropConverter{

    public static List<Base_Yield__c> ConvertToBaseYields(List<FPAC_SCIMS_Crop> scimsCrops)
    {
        List<Base_Yield__c> baseYields = new List<Base_Yield__c>();
       
        for(FPAC_SCIMS_Crop scimsCrop : scimsCrops)
        {
            Base_Yield__c baseYield = new Base_Yield__c();

            baseYield.Name = scimsCrop.Name;
            baseYield.Abbreviation__c = scimsCrop.Abbr;

            if (!string.isBlank(scimsCrop.CcYield))
                baseYield.CC_Yield__c = Decimal.Valueof(scimsCrop.CcYield);

            baseYield.Code__c = scimsCrop.Code;
            baseYield.Type_Code__c = scimsCrop.TypeCode;
            baseYield.Type_Name__c = scimsCrop.TypeName;
            baseYield.Crop_Reduction_Acres__c = scimsCrop.CrpReductionAcres;
            baseYield.Crop_Released_Acres__c = scimsCrop.CrpReleasedAcres;
            baseYield.Crop_Yield__c = scimsCrop.CrpYield;

            if (!string.isBlank(scimsCrop.DcpBaseAcres))
                baseYield.DCP_Base_Acres__c = Decimal.Valueof(scimsCrop.DcpBaseAcres);

            if (!string.isBlank(scimsCrop.FavReductionAcres))
                baseYield.Fav_Reduction_Acreages__c = Decimal.Valueof(scimsCrop.FavReductionAcres);
            
            baseYield.Direct_Yield__c = scimsCrop.DirectYield;
            baseYield.Name__c = scimsCrop.Name;
            
            baseYield.Crop_ID__c = scimsCrop.CalculatedId;
            baseYield.Land__c = scimsCrop.LandId;

            baseYields.Add(baseYield);
        }
        return baseYields;
    }

}
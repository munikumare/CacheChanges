public class FPAC_SCIMS_CommonLandUnitYearConverter {
     public static List<Land__c> ConvertToLands(List<FPAC_SCIMS_CommonLandUnitYear> scimsCommonLandUnitYears)
    {
        List<Land__c> fields = new List<Land__c>();
        Id fieldRecordTypeId = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();

        for(FPAC_SCIMS_CommonLandUnitYear scimsCommonLandUnitYear : scimsCommonLandUnitYears)
        {
            Land__c field = new Land__c();
            
            field.Name = scimsCommonLandUnitYear.FieldNumberDisplayValue;
            field.Field_Number__c = scimsCommonLandUnitYear.FieldNumber;
            
            field.RecordTypeId = fieldRecordTypeId;
            
            field.Tract_Number__c = scimsCommonLandUnitYear.TractNumber;
            field.Farm_Number__c = scimsCommonLandUnitYear.FarmNumber;
            field.Admin_State_Code__c = scimsCommonLandUnitYear.AdminStateCode;
            field.Admin_County_Code__c = scimsCommonLandUnitYear.AdminCountyCode;
            field.FarmOperator__c = scimsCommonLandUnitYear.Operator; 
            
            field.CLU_Alternative_Identifier__c = scimsCommonLandUnitYear.AlternateId;

            if (scimsCommonLandUnitYear.InactiveIndicator != null)
                field.Inactive_Indicator__c = Boolean.valueOf(scimsCommonLandUnitYear.InactiveIndicator);

            field.Location_State_County_Code_FSA__c = scimsCommonLandUnitYear.StateCountyFsaCode;
            field.State_County_ANSI_Code__c = scimsCommonLandUnitYear.StateCountyAnsiCode;
            field.Land_Classification_Identifier__c = scimsCommonLandUnitYear.LandClassificationId;
            field.Congressional_District_Code__c = scimsCommonLandUnitYear.CongressionalDistrictCode;
            field.Field_Number__c = scimsCommonLandUnitYear.FieldNumber;
            field.CLU_Acreage__c = scimsCommonLandUnitYear.CluAcreage;
            field.Hel_Status_Indicator__c = scimsCommonLandUnitYear.HelStatusIdentifier;
            field.Cropland_Inidcator_3CM__c = scimsCommonLandUnitYear.CroplandIndicator3cm;
            field.CRP_Contract_Number__c = scimsCommonLandUnitYear.CrpContractNumber;

            if (!String.isBlank(scimsCommonLandUnitYear.CrpContractExpirationDate))
                field.Crop_Contract_Expiry_Date__c = Date.ValueOf(scimsCommonLandUnitYear.CrpContractExpirationDate);
            
            if (!String.isBlank(scimsCommonLandUnitYear.NativeSodConversionDate))
                field.Native_SOD_Conservation_Date__c = Date.ValueOf(scimsCommonLandUnitYear.NativeSodConversionDate);

            field.Conservation_Practice_Identifier__c = scimsCommonLandUnitYear.ConservationPracticeId;
            field.SOD_Conservation_Crop_Yr1__c = scimsCommonLandUnitYear.SodConversionCropYears1;
            field.SOD_Conservation_Crop_Yr2__c = scimsCommonLandUnitYear.SodConversionCropYears2;
            field.SOD_Conservation_Crop_Yr3__c = scimsCommonLandUnitYear.SodConversionCropYears3;
            field.SOD_Conservation_Crop_Yr4__c = scimsCommonLandUnitYear.SodConversionCropYears4;
            
            field.Land_ID__c = scimsCommonLandUnitYear.CalculatedId;
            
            field.Parent_ID__c = scimsCommonLandUnitYear.TractId;
            
            fields.Add(field);
        }
        return fields;
    }
}
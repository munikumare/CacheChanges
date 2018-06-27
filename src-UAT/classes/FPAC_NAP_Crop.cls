public with sharing class FPAC_NAP_Crop {
            
            public string CropTypeCode {get; set;}
            public string IntendedUseCode {get; set;}
            public string PlantingPeriodCode {get; set;}
            public string PayCropCode {get; set;}
            public string PayCropTypeCode {get; set;}

            public string CropCode {get; set;}

            public string CoveragePercentage {get; set;}
            public string ApprovedYield {get; set;}
            public string YieldAdjustment {get; set;}

           // public string OrganicProductionPriceCoverage {get; set;}

           // public string DirectMarketPriceCoverage {get; set;}

           // public string HistoricalMarketingPercentageCoverage {get; set;}

           // public string CoverageValueAmount {get; set;}
            
            public string IrrigationPracticeCode {get; set;}
            
            public string PlantedIneligibleAcreage {get; set;}
            public string OrganicTypeCode {get; set;}
            public string NativeSodIndicator {get; set;}
            public string DeterminedPreventedAcreage {get; set;}
            public string UnitNumber {get; set;}
            public string ReportedPlantedAcreage {get; set;}
            public string ReportedPreventedAcreage {get; set;}
            public string PreventedIneligibleAcreage {get; set;}
            public string DeterminedPlantedAcreage {get; set;}
            public string Share {get; set;} 
            public List<FPAC_NAP_YieldBasedLoss> YieldBasedLosses {get; set;}
            public List<FPAC_NAP_ValueMultiGraduatedLoss> ValueMultiGraduatedLosses {get; set;}
            public List<FPAC_NAP_ValueNonGraduatedLoss> ValueNonGraduatedLosses {get; set;}
}
public with sharing class FPAC_ACR_AgriculturalProductionPlan {
		
		//public string Id {get; set;}
		//public string AcreageOfficialMeasurementCode {get; set;}
		//public string CarryingCapacity {get; set;}
		//public string CertifiedIndicator {get; set;}
		//public string CropAbbreviation {get; set;}
		//public string CropName {get; set;}
		//public string CropTypeName {get; set;}
		//public string NAPUnitOverride {get; set;}
		//public string CropReportingUnitCode {get; set;}
		//public string CropRowCount {get; set;}
		//public string CropRowWidth {get; set;}
		///public string CropUseCode {get; set;}
		//public string CroplandIndicator {get; set;}
		//public string DerivedFieldNumber {get; set;}
		//public string DerivedSubfieldNumber {get; set;}
		//public string FieldIdentification {get; set;}
		//public string LandUseCode {get; set;}
		//public string PerennialCropExpirationYear {get; set;}
		//public string PlantingPatternTypeCode {get; set;}
		//public string SkipRowCount {get; set;}
		//public string SkipRowWidth {get; set;}
		//public string TreeAge {get; set;}
		//public string TreeSeparationLength {get; set;}
		//public string TreeUnitCount {get; set;}
		
		
		public string CropStatusCode {get; set;}
		public string SupplementalCropStatusCode {get; set;}
		public string ConcurrentPlantingCode {get; set;}
		public string FieldNumber {get; set;}
		public string CertificationDate {get; set;}
		public string CropPlantedDate {get; set;}
		public string CropCode {get; set;}
		public string IntendedUseCode {get; set;}
		
		
		public string ReportedAcres {get; set;}
		public string PlantingPeriodCode {get; set;}
		public string OrganicStatusCode {get; set;}
		public string NativeSodIndicator {get; set;}
		public string NAPUnitNumber {get; set;}
		public string IrrigationPracticeCode {get; set;}
		public string DeterminedAcresPresent {get; set;}
		public string CropTypeCode {get; set;}
		public string CropName {get; set;}
		public string IntendedUseName {get; set;}
		public List<FPAC_ACR_ProducerShare> ProducerShares {get; set;}
}
public with sharing class FPAC_RMA_Acreage {
	public string AipAcreageKey {get; set;}
    public string BasicUnitNumber {get; set;}
    public string OptionalUnitNumber {get; set;}
    public string SubCountyCode {get; set;}
    public string NativeSodSubsidyAmount {get; set;}
    public string ReportedAcreage {get; set;}
    public string InsuredSharePercent {get; set;}
    public string ReportedTons {get; set;}
    public string ReportedColonies {get; set;}
    public string ApprovedYield {get; set;}
    public string UnitStructureCode {get; set;}
    public string SkipRowCode {get; set;}
    public string ReportedTreeCount {get; set;}
    public string ReportedPounds {get; set;}
    public string RangeClassCode {get; set;}
    public string PlantedDate {get; set;}
    public string NonPremiumAcreageCode {get; set;}
    public string GuaranteeAdjustmentTypeCode {get; set;}
    public string GuaranteeAdjustmentFactor {get; set;}
    public string AipCode {get; set;}
    public string CoverageRange {get; set;}
    
    public string CommodityCode {get; set;}
    public string CalculatedAcres{
    	get{
    		if (CommodityCode == '1191')
    			return ReportedColonies;
    			
    		if (CommodityCode == '0115')
    			return ReportedPounds;
    			
    		if (CommodityCode == '0037')
    			return ReportedTons;	
    			
    		return ReportedAcreage;
    	}
    }
    
	public string PracticeCode {get; set;} 
	public string TypeCode {get; set;} 
	public string IntendedUseCode {get; set;}
	public string OrganicPracticeCode {get; set;}
	public string PriceElectionPercent {get; set;}
	public string InsuranceOptionCodeList {get; set;}
	
	public List<FPAC_RMA_InsuranceOffer> InsuranceOffers {get; set;}
	
	//public string UnitofMeasureAbbreviation {
	//	get{
	//		List<string> values = new List<string>();
	//		for (FPAC_RMA_InsuranceOffer offer : InsuranceOffers)
	//			values.Add(offer.UnitofMeasureAbbreviation);
	//		return String.Join(values, ';');
	//	}
	//}
	
	
	//public string Price {
	//	get{
	//		List<string> values = new List<string>();
	//		for (FPAC_RMA_InsuranceOffer offer : InsuranceOffers)
	//			values.Add(offer.ConcatenatedPriceValues);
	//		return String.Join(values, ';');
	//	}
	//}
     
	
	public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
		rmaFieldValueMap.put('PracticeCode', PracticeCode);
		rmaFieldValueMap.put('TypeCode', TypeCode);
		rmaFieldValueMap.put('IntendedUseCode', IntendedUseCode);
		rmaFieldValueMap.put('OrganicPracticeCode', OrganicPracticeCode);
		rmaFieldValueMap.put('PriceElectionPercent', PriceElectionPercent);
		rmaFieldValueMap.put('BasicUnitNumber', BasicUnitNumber);
		rmaFieldValueMap.put('OptionalUnitNumber', OptionalUnitNumber);
		rmaFieldValueMap.put('SubCountyCode', SubCountyCode);
		rmaFieldValueMap.put('NativeSodSubsidyAmount', NativeSodSubsidyAmount);
		rmaFieldValueMap.put('ReportedAcreage', ReportedAcreage);
		rmaFieldValueMap.put('InsuredSharePercent', InsuredSharePercent);
		rmaFieldValueMap.put('ReportedTons', ReportedTons);
		rmaFieldValueMap.put('ReportedColonies', ReportedColonies);
		rmaFieldValueMap.put('ApprovedYield', ApprovedYield);
		rmaFieldValueMap.put('UnitStructureCode', UnitStructureCode);
		rmaFieldValueMap.put('SkipRowCode', SkipRowCode);
		rmaFieldValueMap.put('ReportedTreeCount', ReportedTreeCount);
		rmaFieldValueMap.put('ReportedPounds', ReportedPounds);
		rmaFieldValueMap.put('RangeClassCode', RangeClassCode);
		rmaFieldValueMap.put('PlantedDate', PlantedDate);
		rmaFieldValueMap.put('NonPremiumAcreageCode', NonPremiumAcreageCode);
		rmaFieldValueMap.put('GuaranteeAdjustmentTypeCode', GuaranteeAdjustmentTypeCode);
		rmaFieldValueMap.put('GuaranteeAdjustmentFactor', GuaranteeAdjustmentFactor);
		rmaFieldValueMap.put('AipCode', AipCode);
		rmaFieldValueMap.put('CoverageRange', CoverageRange);
		rmaFieldValueMap.put('CalculatedAcres', CalculatedAcres);
		//rmaFieldValueMap.put('Price', Price);
		//rmaFieldValueMap.put('UOM', UnitofMeasureAbbreviation);
	 }
}
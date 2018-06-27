public with sharing class FPAC_RMA_InventoryValue {
    public string AipInventoryValueKey {get; set;}
    public string TypeCode {get; set;}
    public string PracticeCode {get; set;}
    public string InsuredSharePercent {get; set;}
    public string BasicUnitNumber {get; set;}
    public string OptionalUnitNumber {get; set;}
    public string UnitStructureCode {get; set;}
    public string UnitDivisionCode {get; set;}
    public string NonPremiumAcreageCode {get; set;}
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
		rmaFieldValueMap.put('InsuredSharePercent', InsuredSharePercent);
		rmaFieldValueMap.put('BasicUnitNumber', BasicUnitNumber);
		rmaFieldValueMap.put('OptionalUnitNumber', OptionalUnitNumber);
		rmaFieldValueMap.put('UnitStructureCode', UnitStructureCode);
		rmaFieldValueMap.put('UnitDivisionCode', UnitDivisionCode);
		rmaFieldValueMap.put('NonPremiumAcreageCode', NonPremiumAcreageCode);
		rmaFieldValueMap.put('InsuranceOptionCodeList', InsuranceOptionCodeList);
		//rmaFieldValueMap.put('Price', Price);
		//rmaFieldValueMap.put('UOM', UnitofMeasureAbbreviation);
	 }
}
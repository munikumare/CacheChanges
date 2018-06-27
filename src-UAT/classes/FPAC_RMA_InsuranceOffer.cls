public with sharing class FPAC_RMA_InsuranceOffer {
	public string UnitOfMeasureAbbreviation {get; set;}
	
    public List<FPAC_RMA_InsuranceOfferPrice> Prices {get; set;}
    
    //public string ConcatenatedPriceValues {
	//	get{
	//		List<string> values = new List<string>();
	//		for (FPAC_RMA_InsuranceOfferPrice price : Prices)
	//			values.Add(price.Price);
	//		return String.Join(values, ',');
	//	}
	//}
	
	public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
	    rmaFieldValueMap.put('UOM', UnitOfMeasureAbbreviation);
	}
}
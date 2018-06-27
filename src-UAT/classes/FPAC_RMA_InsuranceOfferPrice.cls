public with sharing class FPAC_RMA_InsuranceOfferPrice {
    public string Price {get; set;}
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
	    rmaFieldValueMap.put('Price', Price);
	}
}
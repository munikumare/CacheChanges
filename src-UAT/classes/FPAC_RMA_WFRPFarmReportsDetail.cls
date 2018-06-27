public with sharing class FPAC_RMA_WFRPFarmReportsDetail {
	
    public string InsuredSharePercent {get; set;}
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
	   	rmaFieldValueMap.put('InsuredSharePercent', InsuredSharePercent);
	}
}
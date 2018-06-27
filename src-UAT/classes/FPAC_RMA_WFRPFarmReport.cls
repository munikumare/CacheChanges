public with sharing class FPAC_RMA_WFRPFarmReport {
	public string AipWFRPFarmReportsKey {get; set;}
    public string TypeCode {get; set;}
    public string PracticeCode {get; set;}
    public List<FPAC_RMA_WFRPFarmReportsDetail> WFRPFarmReportDetails {get; set;}
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
	   	rmaFieldValueMap.put('TypeCode', TypeCode);
	    rmaFieldValueMap.put('PracticeCode', PracticeCode);
	}
}
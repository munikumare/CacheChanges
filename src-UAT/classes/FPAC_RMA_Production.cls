public with sharing class FPAC_RMA_Production {
    
    public string TotalProductionAmount {get; set;}
    public string ReportedAcreageAmount {get; set;}
    
     public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	 {
	   	rmaFieldValueMap.put('SYProduction', TotalProductionAmount);
	    rmaFieldValueMap.put('SYAcre', ReportedAcreageAmount);
	 }
}
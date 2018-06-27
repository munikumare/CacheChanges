public with sharing class FPAC_RMA_InsuranceInForce {
     
     public string TypeCode {get; set;} 
     public string LocationCountyCode {get; set;} 
     public string CoverageTypeCode {get; set;}
     public string CoverageLevelPercent {get; set;}
     public string InsurancePlanCode {get; set;}
     public string InsuranceOptionCodeList {get; set;}
     public string IneligibleSBISharePercent {get; set;}
     public string CommodityCode {get; set;}
     public string CommodityYear {get; set;}
     public string ReinsuranceYear {get; set;}
     public string PriceIndicatorCode {get; set;}
     
     public string CalculatedCommodityType {
     	get {
     		if (CommodityCode == '0073' || CommodityCode == '0116')
     			return 'Nursery And Clams';
     			
     		if (CommodityCode == '0076')
     			return 'WFRP';
     			
     		return 'Other';		 
     	}
     }
      
    
     public List<FPAC_RMA_ProductionLossDetail> ProductionLossDetails {get; set;}
     public List<FPAC_RMA_Acreage> Acreages {get; set;}
     
     public List<FPAC_RMA_InventoryLossDetail> InventoryLossDetails {get; set;}
     public List<FPAC_RMA_InventoryValue> InventoryValues {get; set;}
     
     public List<FPAC_RMA_WFRPFarmReport> WFRPFarmReports {get; set;}
     public List<FPAC_RMA_WFRPIndemnity> WFRPIndemnities {get; set;}
     
     public List<FPAC_RMA_Land> Lands {get; set;} 
     public List<FPAC_RMA_Yield> Yields {get; set;} 
     public List<FPAC_RMA_Production> Productions {get; set;} 
     
     public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	 {
	    rmaFieldValueMap.put('LocationCountyCode', LocationCountyCode);
	    rmaFieldValueMap.put('CoverageTypeCode', CoverageTypeCode);
	    rmaFieldValueMap.put('CoverageLevelPercent', CoverageLevelPercent);
	    rmaFieldValueMap.put('CommodityCode', CommodityCode);
	    rmaFieldValueMap.put('InsurancePlanCode', InsurancePlanCode);
		
	 }
       

}
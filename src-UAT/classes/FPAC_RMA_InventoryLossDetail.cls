public with sharing class FPAC_RMA_InventoryLossDetail {
	
    public string AipInventoryValueKey {get; set;}
    public string FieldMarketValueA {get; set;}
    public string UnitValueBeforeLoss {get; set;}
    public string FieldMarketValueB {get; set;}
    public string UnitValueAfterLoss {get; set;}
    public string FirstDamageCauseCode {get; set;}
    public string FirstDamageDate {get; set;}
    public string SecondDamageCauseCode {get; set;}
    public string SecondDamageDate {get; set;}
    public string ThirdDamageCauseCode {get; set;}
    public string ThirdDamageDate {get; set;}
    public string IndemnityAmount {get; set;}
    
    public string CommodityCode {get; set;}
    public string CalculatedFieldMarketValueA {
    	get{
    		if (CommodityCode == '0073')
    			return FieldMarketValueA;
    			
    		if (CommodityCode == '0116')
    			return UnitValueBeforeLoss;
    			
    		return null;	
    	}
    }
    
    public string CalculatedFieldMarketValueB {
    	get{
    		if (CommodityCode == '0073')
    			return FieldMarketValueB;
    			
    		if (CommodityCode == '0116')
    			return UnitValueAfterLoss;
    			
    		return null;	
    	}
    }
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
		 rmaFieldValueMap.put('FieldMarketValueA', FieldMarketValueA);
		 rmaFieldValueMap.put('UnitValueBeforeLoss', UnitValueBeforeLoss);
		 rmaFieldValueMap.put('FieldMarketValueB', FieldMarketValueB);
		 rmaFieldValueMap.put('UnitValueAfterLoss', UnitValueAfterLoss);
		 rmaFieldValueMap.put('FirstDamageCauseCode', FirstDamageCauseCode);
		 rmaFieldValueMap.put('FirstDamageDate', FirstDamageDate);
		 rmaFieldValueMap.put('SecondDamageCauseCode', SecondDamageCauseCode);
		 rmaFieldValueMap.put('SecondDamageDate', SecondDamageDate);
		 rmaFieldValueMap.put('ThirdDamageCauseCode', ThirdDamageCauseCode);
		 rmaFieldValueMap.put('ThirdDamageDate', ThirdDamageDate);
		 rmaFieldValueMap.put('IndemnityAmount', IndemnityAmount);
		 
		 rmaFieldValueMap.put('CalculatedFieldMarketValueA', FieldMarketValueA);
		 rmaFieldValueMap.put('CalculatedFieldMarketValueB', UnitValueBeforeLoss);
	 }
}
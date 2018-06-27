public with sharing class FPAC_RMA_WFRPIndemnity {
    public string AipWFRPFarmReportsKey {get; set;}
    public string StageCode {get; set;}
    public string IndemnityAmount {get; set;}
    public string FirstDamageCauseCode {get; set;}
    public string FirstDamageDate {get; set;}
    public string SecondDamageCauseCode {get; set;}
    public string SecondDamageDate {get; set;}
    public string ThirdDamageCauseCode {get; set;}
    public string ThirdDamageDate {get; set;}
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
   		rmaFieldValueMap.put('StageCode', StageCode);
   		rmaFieldValueMap.put('IndemnityAmount', IndemnityAmount);
   		rmaFieldValueMap.put('FirstDamageCauseCode', FirstDamageCauseCode);
   		rmaFieldValueMap.put('FirstDamageDate', FirstDamageDate);
   		rmaFieldValueMap.put('SecondDamageCauseCode', SecondDamageCauseCode);
   		rmaFieldValueMap.put('SecondDamageDate', SecondDamageDate);
   		rmaFieldValueMap.put('ThirdDamageCauseCode', ThirdDamageCauseCode);
   		rmaFieldValueMap.put('ThirdDamageDate', ThirdDamageDate);
	}
}
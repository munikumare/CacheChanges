public with sharing class FPAC_RMA_ProductionLossDetail {
	public string AipAcreageKey {get; set;}
    public string DeterminedAcreage {get; set;}
    public string StageCode {get; set;}
    public string ProductionToCountQuantity {get; set;}
    public string IndemnityAmount {get; set;}
    public string LossMultipleCroppingCode {get; set;}
    public string GleanedAcreageCode {get; set;}
    public string FirstDamageDate {get; set;}
    public string FirstDamageCauseCode {get; set;}
    public string DeterminedTreeCount {get; set;}
    public string DeterminedTons {get; set;}
    public string DeterminedPounds {get; set;}
    public string DeterminedColonies {get; set;}
    public string ThirdDamageDate {get; set;}
    public string ThirdDamageCauseCode {get; set;}
    public string StagePercentFactor {get; set;}
    public string SecondDamageDate {get; set;}
    public string SecondDamageCauseCode {get; set;}
    
	public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
		 rmaFieldValueMap.put('DeterminedAcreage', DeterminedAcreage);
		 rmaFieldValueMap.put('StageCode', StageCode);
		 rmaFieldValueMap.put('ProductionToCountQuantity', ProductionToCountQuantity);
		 rmaFieldValueMap.put('IndemnityAmount', IndemnityAmount);
		 rmaFieldValueMap.put('ThirdDamageDate', ThirdDamageDate);
		 rmaFieldValueMap.put('ThirdDamageCauseCode', ThirdDamageCauseCode);
		 rmaFieldValueMap.put('StagePercentFactor', StagePercentFactor);
		 rmaFieldValueMap.put('SecondDamageCauseCode', SecondDamageCauseCode);
		 rmaFieldValueMap.put('SecondDamageDate', SecondDamageDate);
		 rmaFieldValueMap.put('LossMultipleCroppingCode', LossMultipleCroppingCode);
		 rmaFieldValueMap.put('GleanedAcreageCode', GleanedAcreageCode);
		 rmaFieldValueMap.put('FirstDamageDate', FirstDamageDate);
		 rmaFieldValueMap.put('FirstDamageCauseCode', FirstDamageCauseCode);
		 rmaFieldValueMap.put('DeterminedTreeCount', DeterminedTreeCount);
		 rmaFieldValueMap.put('DeterminedTons', DeterminedTons);
		 rmaFieldValueMap.put('DeterminedPounds', DeterminedPounds);
		 rmaFieldValueMap.put('DeterminedColonies', DeterminedColonies);
	 }
}
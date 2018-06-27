public with sharing class FPAC_RMA_YieldHistory {
	public string InsurancePlanCode {get; set;}
	public string ReinsuranceYear {get; set;}
	public string Year10AnnualYield {get; set;}
	public string Year10AnnualProduction {get; set;}
	public string Year10YieldAcreage {get; set;}
	public string Year10AverageAcreProduction {get; set;}
	public string Year10SkipRowCode {get; set;}
	
	public decimal CalculatedSYProductionValue {
		get
		{
			decimal year10AnnualYieldVal, 
							year10AnnualProductionVal, 
							year10YieldAcreageVal, 
							year10AverageAcreProductionVal;
							
			if (String.IsNotBlank(Year10AnnualYield))
				year10AnnualYieldVal = decimal.ValueOf(Year10AnnualYield);
				
			if (String.IsNotBlank(Year10AnnualProduction))
				year10AnnualProductionVal = decimal.ValueOf(Year10AnnualProduction);
				
			if (String.IsNotBlank(Year10YieldAcreage))
				year10YieldAcreageVal = decimal.ValueOf(Year10YieldAcreage);
				
			if (String.IsNotBlank(Year10AverageAcreProduction))
				year10AverageAcreProductionVal = decimal.ValueOf(Year10AverageAcreProduction);
				
			if (InsurancePlanCode == '01' ||
				InsurancePlanCode == '02' ||
				InsurancePlanCode == '03' ||
				InsurancePlanCode == '90')
			{

				if (year10AnnualYieldVal != null &&
					year10AnnualYieldVal > 0 &&
					year10YieldAcreageVal != null &&
					(year10AnnualProductionVal == null || year10AnnualProductionVal == 0))
					return (year10YieldAcreageVal * year10AnnualYieldVal);

				if (year10YieldAcreageVal != null && 
					year10AnnualYieldVal != null)
					return (year10YieldAcreageVal * year10AnnualYieldVal);
					
				return year10AnnualProductionVal;
			} 
				
			if (InsurancePlanCode == '41' ||
				InsurancePlanCode == '47')
			{
				if (year10YieldAcreageVal != null && 
					year10AverageAcreProductionVal != null)
					return (year10YieldAcreageVal * year10AverageAcreProductionVal);
			} 	
				
			return null;
		}
	}   
	
	public string CalculatedSYAcreValue {
		get
		{
			
			if (InsurancePlanCode == '01' ||
				InsurancePlanCode == '02' ||
				InsurancePlanCode == '03' ||
				InsurancePlanCode == '90' ||
				InsurancePlanCode == '41' ||
				InsurancePlanCode == '47')
			{
				return Year10YieldAcreage;
			} 	
				
			return null;
		}
	}   
	
	public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
		 string strCalculatedProductionValue;
		 
		 if (CalculatedSYProductionValue != null)
		 	strCalculatedProductionValue = String.ValueOf(CalculatedSYProductionValue);
		 	
		 rmaFieldValueMap.put('SYProduction', strCalculatedProductionValue);
		 rmaFieldValueMap.put('SYAcre', CalculatedSYAcreValue);
		 rmaFieldValueMap.put('SkipRowCode', Year10SkipRowCode);
	}         
}
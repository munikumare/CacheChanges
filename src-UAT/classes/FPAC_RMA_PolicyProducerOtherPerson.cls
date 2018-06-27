public with sharing class FPAC_RMA_PolicyProducerOtherPerson {
    public string IneligibleSBIFlag {get; set;}
    public string IneligibleSBISharePercent {get; set;}
    public string BusinessName {get; set;}
    public string LastName {get; set;}
    public string FirstName {get; set;}
    public string MiddleName {get; set;}
    public string Suffix {get; set;}
    public string Title {get; set;}
    public string AipCode {get; set;}
    
    public string Name{
    	get{
    		if (String.IsBlank(BusinessName))
    		{
    			List<string> nameValues = new List<string>();
    			nameValues.Add(LastName);
    			nameValues.Add(FirstName);
    			nameValues.Add(MiddleName);
    			nameValues.Add(Suffix);
    			nameValues.Add(Title);
    			
    			return String.Join(nameValues, ' '); 
    		}
    		
    		return BusinessName;
    	}
    }
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
		 rmaFieldValueMap.put('IneligibleSBIFlag', IneligibleSBIFlag);
		 rmaFieldValueMap.put('IneligibleSBISharePercent', IneligibleSBISharePercent);
		 rmaFieldValueMap.put('OtherPersonName', Name);
		 rmaFieldValueMap.put('AipCode', AipCode);
	}
}
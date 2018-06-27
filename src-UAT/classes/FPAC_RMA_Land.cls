public with sharing class FPAC_RMA_Land {
	public string AipAcreageKey {get; set;}
    public string FsaTractNumber {get; set;}
    public string FsaSubFieldIdentifier {get; set;}
    public string FsaFieldNumber {get; set;}
    public string FsaFarmNumber {get; set;}
    
    public string FieldNumber {
    	get{
    		if (FsaFieldNumber != null && FsaSubFieldIdentifier != null)
    			return FsaFieldNumber + FsaSubFieldIdentifier;
    			
    		return FsaFieldNumber;	
    	}
    }
    
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
	{
		 rmaFieldValueMap.put('FsaFarmNumber', FsaFarmNumber);
		 rmaFieldValueMap.put('FsaTractNumber', FsaTractNumber);
		 rmaFieldValueMap.put('FieldNumber', FieldNumber);
	}
}
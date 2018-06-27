public with sharing class FPAC_ACR_Farm {
	public string StateCode {get; set;}
	public string CountyCode {get; set;}
	public string FarmNumber {get; set;}
    public List<FPAC_ACR_FarmYear> FarmYears {get; set;}
}
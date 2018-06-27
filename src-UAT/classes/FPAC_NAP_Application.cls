public with sharing class FPAC_NAP_Application {
	public string ProgramYear {get; set;}
	public string StateFSACode {get; set;}
	public string CountyFSACode {get; set;}
	public string PayCropCode {get; set;}
    public string PayCropTypeCode {get; set;}
    public string PlantingPeriodCode {get; set;}
    public string UnitNumber {get; set;}
   
    public List<FPAC_NAP_Crop> Crops {get; set;}
}
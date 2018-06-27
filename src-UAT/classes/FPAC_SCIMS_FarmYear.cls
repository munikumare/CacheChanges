public class FPAC_SCIMS_FarmYear {
    public decimal CrpAcres	{get; set;}
	public string InactiveIndicator {get; set;}
    public decimal MplAcres	{get; set;}
  	public FPAC_SCIMS_Operator Operator	{get; set;}
    public integer Year	{get; set;}
    public string DcpBaseExceedsCroplandIndicator {get; set;}	
    public decimal DcpDoubleCropAcres {get; set;}	
    public string Fsa540Indicator {get; set;}
    public List<FPAC_SCIMS_OtherProducer> OtherProducers {get; set;}
    public List<FPAC_SCIMS_Tract> Tracts {get; set;}
    public List<FPAC_SCIMS_Crop> Crops	{get; set;}
    public List<FPAC_SCIMS_Election_Hip> Elections	{get; set;}
    public List<FPAC_SCIMS_Election_Hip> Hips {get; set;}
    public List<FPAC_SCIMS_OtherProducer> PriorActiveOperators {get; set;}
}
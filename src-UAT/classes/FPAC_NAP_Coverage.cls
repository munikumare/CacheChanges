public with sharing class FPAC_NAP_Coverage {
        public string CoverageStatus {get; set;}
		public string CoreCustomerId  {get; set;}
		public string ProgramYear   {get; set;}
		public string StateFSACode   {get; set;}
		public string CountyFSACode   {get; set;}
		public List<FPAC_NAP_Crop> Crops {get; set;}
}
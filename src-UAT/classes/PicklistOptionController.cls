public with sharing class PicklistOptionController {

	private final static String CONSERVATION_REQUEST_API = 'Conservation_Request__c';
	private final static String CONSERVATION_REQUEST_FINANCIAL_PROGRAM_API = 'Financial_Programs__c';
	private final static String EVIP = 'Environmental Quality Incentives Program (EQIP)';
	private final static String CSP = 'Conservation Stewardship Program (CSP)';
	private final static String CSRP = 'Conservation Stewardship Renewal Program (CSP Renewal)';
	private final static String ACEP = 'Agricultural Conservation Easement Program (ACEP) - Wetland Reserve Easements (WRE)';
	private final static String RCPPEQIP = 'Regional Conservation Partnership Program (RCPP) - EQIP';
	private final static String RCPPCSP = 'Regional Conservation Partnership Program (RCPP) - CSP';
	private final static String RCPPACEP = 'Regional Conservation Partnership Program (RCPP) - ACEP (WRE)';
	private final static String RCPPHFRP = 'Regional Conservation Partnership Program (RCPP) - Healthy Forests Reserve Program (HFRP)';
	private final static String EVIP_URL = 'https://www.nrcs.usda.gov/wps/portal/nrcs/main/national/programs/financial/eqip/';
	private final static String CSP_URL = 'https://www.nrcs.usda.gov/wps/portal/nrcs/main/national/programs/financial/csp/';
	private final static String ACEP_URL = 'https://www.nrcs.usda.gov/wps/portal/nrcs/detail/national/programs/easements/acep/?cid=stelprdb1242695';
	private final static String RCPP_URL = 'https://www.nrcs.usda.gov/wps/portal/nrcs/detail/national/programs/farmbill/rcpp/?cid=stelprdb1242732';
	
	@AuraEnabled
	public static List<PicklistOption> getPicklistOptions(String objectName, String fieldName) {
		List<PicklistOption> options = new List<PicklistOption>();

		if (objectName.equals(CONSERVATION_REQUEST_API) && fieldName.equals(CONSERVATION_REQUEST_FINANCIAL_PROGRAM_API)) {
			for ( PicklistEntry entry : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
				options.add(new PicklistOption(entry.getLabel(), entry.getValue(), getURLMapping(entry.getLabel())));
			}

			return options;
		}

		for (PicklistEntry entry : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
			options.add(new PicklistOption(entry.getLabel(), entry.getValue()));
		}

		System.debug('Options: ' + options);
		return options;
	}

	private static String getURLMapping(String label) {
		if (label.equals(EVIP)) {
			return EVIP_URL;
		}
		if (label.equals(CSP)) {
			return CSP_URL;
		}
		if (label.equals(CSRP)) {
			return CSP_URL;
		}
		if (label.equals(ACEP)) {
			return ACEP_URL;
		}
		if (label.equals(RCPPEQIP)) {
			return RCPP_URL;
		}
		if (label.equals(RCPPCSP)) {
			return RCPP_URL;
		}
		if (label.equals(RCPPACEP)) {
			return RCPP_URL;
		}
		if (label.equals(RCPPHFRP)) {
			return RCPP_URL;
		} 

		return '';
	}

	public class PicklistOption {

		@AuraEnabled
		public String label {get; set;}

		@AuraEnabled
		public String value {get; set;}

		@AuraEnabled 
		public String url {get; set;}

		public PicklistOption(String label, String value) {
			this.label = label;
			this.value = value;
			this.url = '';
		}

		public PicklistOption(String label, String value, String url) {
			this.label = label;
			this.value = value;
			this.url = url;
		}

	}

}
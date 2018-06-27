public with sharing class FarmSearchAuraService {
	private static FarmSearchDAI farmSearchdataAccessor = new FarmSearchDA();
	public static FarmSearchDAI FarmSearchDI {private get; set{
		farmSearchdataAccessor = value;
	}}

	@AuraEnabled
	public static List<Object> getStateAndCountyMetadata() {
		return farmSearchdataAccessor.queryStateAndCountyMetadata();
	}

	@AuraEnabled
	public static List<FIPS_County_Code__mdt> getCountiesForStateSelected(String stateCode) {
		return farmSearchdataAccessor.queryCountyMetadataForSelectedState(stateCode);
	}

	@AuraEnabled
	public static List<Land__c> callMulesoftService(String farmSearchString) {
		
		FPAC_SCIMS_FarmProcessor searchProcessor = new FPAC_SCIMS_FarmProcessor();
		List<FPAC_SCIMS_Farm> scimFarms = searchProcessor.GetFarmData(farmSearchString);
	
		List<Land__c> createdLands = searchProcessor.SaveFarmData(scimFarms);
		
		return createdLands;
	}
}
public with sharing class LandFarmViewController {
	private static final String HOME = 'Home';
	private static final String RELATED_LIST = 'Related_List';
	@testVisible private static AuthorityDAI authorityDA = new AuthorityDA();
	@testVisible private static LandDAWOSI landDAWS = new LandDAWithoutSharing();
	@testVisible private static UserDAI userDA = new UserDA();

	@auraEnabled
	public static List<Land__c> getData(String customerId, String viewType, Integer offset, Integer rowsToLoad, Integer initialRows){
		Integer totalRecords = Integer.valueOf(initialRows) + (Integer.valueOf(offset) * Integer.valueOf(rowsToLoad));
		Id contactId = getContactId(viewType, customerId);
		Map<Id, String> rolesByFarmIds = authorityDA.getRolesByFarmIdsMapByContactId(contactId);
		Set<Id> farmIds = rolesByFarmIds.keySet();
		List<Land__c> farmRecords = landDAWS.getLandViewFarmsByIds(farmIds, totalRecords);
		Map<String, String> labelsByStateCodes = constructMap([SELECT FIPS_State_Code__c,Label FROM FIPS_State_Code__mdt], 'FIPS_State_Code__c', 'Label');
		Map<String, String> labelsByCountyCodes = constructMap([SELECT FIPS_County_Code__c,Label FROM FIPS_County_Code__mdt], 'FIPS_County_Code__c', 'Label');

		for(Land__c farm : farmRecords){
			String role = rolesByFarmIds.get(farm.Id);
			if(!AuthorityDA.isRoleOperatorOrOwnerOrOperatorOwner(role)){
				//other producers and tenants should not be able to see crop acres value.
				farm.Cropland_Acres__c = null;
			}
			//reinitialize values from corresponding metadata records.
			String fiveDigitCountyCode = farm.Admin_State_Code__c + farm.Admin_County_Code__c;
			farm.Admin_State_Code__c = labelsByStateCodes.containsKey(farm.Admin_State_Code__c) ? labelsByStateCodes.get(farm.Admin_State_Code__c) : '';
			farm.Admin_County_Code__c = labelsByCountyCodes.containsKey(fiveDigitCountyCode) ? labelsByCountyCodes.get(fiveDigitCountyCode):'';
		}
		return farmRecords;
	}
	@auraEnabled
	public static List<Land__c> getDataSort(String customerId, String viewType, String sortedBy, String sortedDirection, Integer offset, Integer rowsToLoad, Integer initialRows){
		Integer totalRecords = Integer.valueOf(initialRows) + (Integer.valueOf(offset) * Integer.valueOf(rowsToLoad));
		Id contactId = getContactId(viewType, customerId);
		Map<Id, String> rolesByFarmIds = authorityDA.getRolesByFarmIdsMapByContactId(contactId);
		Set<Id> farmIds = rolesByFarmIds.keySet();
		List<Land__c> farmRecords = landDAWS.getLandViewFarmsByIdsSort(farmIds, sortedBy, sortedDirection, totalRecords);
		Map<String, String> labelsByStateCodes = constructMap([SELECT FIPS_State_Code__c,Label FROM FIPS_State_Code__mdt], 'FIPS_State_Code__c', 'Label');
		Map<String, String> labelsByCountyCodes = constructMap([SELECT FIPS_County_Code__c,Label FROM FIPS_County_Code__mdt], 'FIPS_County_Code__c', 'Label');

		for(Land__c farm : farmRecords){
			String role = rolesByFarmIds.get(farm.Id);
			if(!AuthorityDA.isRoleOperatorOrOwnerOrOperatorOwner(role)){
				//other producers and tenants should not be able to see crop acres value.
				farm.Cropland_Acres__c = null;
			}
			//reinitialize values from corresponding metadata records.
			String fiveDigitCountyCode = farm.Admin_State_Code__c + farm.Admin_County_Code__c;
			farm.Admin_State_Code__c = labelsByStateCodes.containsKey(farm.Admin_State_Code__c) ? labelsByStateCodes.get(farm.Admin_State_Code__c) : '';
			farm.Admin_County_Code__c = labelsByCountyCodes.containsKey(fiveDigitCountyCode) ? labelsByCountyCodes.get(fiveDigitCountyCode):'';
		}
		return farmRecords;
	}
	private static Id getContactId(String viewType, String customerId){
		//only external user can see home view.
		if(viewType == HOME && !Auth.CommunitiesUtil.isInternalUser()){
			return userDA.getCurrentUserContactId();
			//only internal user can see related view.
		} else if(viewType == RELATED_LIST && Auth.CommunitiesUtil.isInternalUser()){
			return (Id)customerId;
		} else {
			return null;
		}
	}
	private static Map<String, String> constructMap(List<sObject> objects, String key, String value){
		Map<String, String> valuesByKeys = new Map<String, String>();
		for(sObject obj: objects){
			if(!valuesByKeys.containsKey((String)obj.get(key)))
				valuesByKeys.put((String)obj.get(key),(String)obj.get(value));
		}
		return valuesByKeys;
	}
}
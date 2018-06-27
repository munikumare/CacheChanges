public with sharing class FPAC_NavigationBarAuraService {
	private static FPAC_NavigationBarDAI FPAC_NavigationBarDataAccessor = new FPAC_NavigationBarDA();
	public static FPAC_NavigationBarDAI FPAC_NavigationBarDI {private get; set{
		FPAC_NavigationBarDataAccessor = value;
	}}

	@AuraEnabled
	public static List<Object> getNavigationBarMetadata() {
		return FPAC_NavigationBarDataAccessor.queryNavigationBarMetadata();
	}

	@AuraEnabled
	public static List<FPAC_NavigationBarIcon__mdt> getNavigationBarDropdownData(String parentName) {
		return FPAC_NavigationBarDataAccessor.queryNavigationBarDropdownData(parentName);
	}
}
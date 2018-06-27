public with sharing class FPACHeaderAndNavigationAuraService {
	private static FPACHeaderAndNavigationDAI fpacHeaderAndNavigationDAI = new FPACHeaderAndNavigationDA();
	public static FPACHeaderAndNavigationDAI FPACHeaderAndNavigationDI {private get; set{
		fpacHeaderAndNavigationDAI = value;
	}}

	@AuraEnabled
	public static List<Object> getUserInformation() {
		return fpacHeaderAndNavigationDAI.queryUserInformation();
	}
}
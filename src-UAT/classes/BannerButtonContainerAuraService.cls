public with sharing class BannerButtonContainerAuraService {
	private static BannerButtonContainerDAI bannerButtonContainerDataAccessor = new BannerButtonContainerDA();
	public static BannerButtonContainerDAI BannerButtonContainerDI {private get; set{
		bannerButtonContainerDataAccessor = value;
	}}

	@AuraEnabled
	public static List<Object> getBannerComponentDetails() {
		return bannerButtonContainerDataAccessor.queryBannerComponentDetails();
	}
}
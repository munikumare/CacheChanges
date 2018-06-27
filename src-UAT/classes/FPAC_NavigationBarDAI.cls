public interface FPAC_NavigationBarDAI {
	List<Object> queryNavigationBarMetadata();
	List<FPAC_NavigationBarIcon__mdt> queryNavigationBarDropdownData(String parentName);
}
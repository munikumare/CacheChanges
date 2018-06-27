public interface FarmSearchDAI {
	List<Object> queryStateAndCountyMetadata();
	List<FIPS_County_Code__mdt> queryCountyMetadataForSelectedState(String stateCode);
}
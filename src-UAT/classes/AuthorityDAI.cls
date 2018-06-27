public interface AuthorityDAI {
	Map<Id, String> getRolesByFarmIdsMapByContactId(Id contactId);
	String getRoleByLandAndContact(String landId, String contactId) ;
	Set<Id> getAuthorizedLandIdsByLandsAndContactAndRecordTypeForOwnersAndOperators(Set<Id> landIds, Id contactId, Id landRecordTypeId);
	Set<Id> getAuthorizedLandIdsByLandsAndContactAndRecordTypeForOtherProducersAndTenants(Set<Id> landIds, Id contactId, Id landRecordTypeId);
	Boolean isRoleOperatorOrOwnerOrOperatorOwner(String role);
	Boolean isRoleOtherProducerOrOtherTenant(String role);
}
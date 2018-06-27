@IsTest
public with sharing class AuthorityDAMock implements AuthorityDAI{

	public Map<Id, Authority__c> authorities = new Map<Id, Authority__c>();
	public Map<Id, String> rolesByFarmIds = new Map<Id, String>();
	public String role;
	public Set<Id> authorizedIds;
	public Boolean isRoleOperatorOrOwnerOrOperatorOwner;
	public Boolean isRoleOtherProducerOrOtherTenant;

	public List<Authority__c> queryContactsById(Set<Id> contactIds) {
		return authorities.values();
	}
	public Map<Id, String> getRolesByFarmIdsMapByContactId(Id contactId){
		return rolesByFarmIds;
	}
	public String getRoleByLandAndContact(String landId, String contactId){
		return role;
	}
	public Set<Id> getAuthorizedLandIdsByLandsAndContactAndRecordTypeForOwnersAndOperators(Set<Id> landIds, Id contactId, Id landRecordTypeId){
		return authorizedIds;
	}
	public Set<Id> getAuthorizedLandIdsByLandsAndContactAndRecordTypeForOtherProducersAndTenants(Set<Id> landIds, Id contactId, Id landRecordTypeId){
		return authorizedIds;
	}
	public Boolean isRoleOperatorOrOwnerOrOperatorOwner(String role){
		return isRoleOperatorOrOwnerOrOperatorOwner;
	}
	public Boolean isRoleOtherProducerOrOtherTenant(String role){
		return isRoleOtherProducerOrOtherTenant;
	}
}
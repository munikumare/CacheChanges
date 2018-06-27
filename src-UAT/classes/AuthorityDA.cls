public without sharing class AuthorityDA implements AuthorityDAI{
	public final String OPERATOR_ROLE = 'Operator';
	public final String OWNER_OPERATOR_ROLE = 'Owner-Operator';
	public final String OPERATOR_OWNER_ROLE = 'Operator-Owner';
	public final String OWNER_ROLE = 'Owner';
	public final Set<String> OwnerOperatorRoles = new Set<String>{OPERATOR_ROLE,OWNER_OPERATOR_ROLE,OPERATOR_OWNER_ROLE,OWNER_ROLE};

	public final String OTHER_PRODUCER_ROLE = 'Other Producer';
	public final String OTHER_TENANT_ROLE = 'Other Tenant';
	public final String OTHER_TENANT_TRACT_ROLE = 'Other Tenant - Tract';
	public final String OTHER_PRODUCER_TRACT_ROLE = 'Other Producer - Tract';
	public final String OTHER_TENANT_FIELD_ROLE = 'Other Tenant - Field';
	public final String OTHER_PRODUCER_FIELD_ROLE = 'Other Producer - Field';
	public final Set<String> OtherProducerTenantRoles = new Set<String>{OTHER_PRODUCER_ROLE,OTHER_TENANT_ROLE,OTHER_TENANT_TRACT_ROLE,OTHER_TENANT_FIELD_ROLE,OTHER_PRODUCER_TRACT_ROLE,OTHER_PRODUCER_FIELD_ROLE};

	private final Id FARM_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();

	public Map<Id, String> getRolesByFarmIdsMapByContactId(Id contactId){
		List<Authority__c> authorities = [
			SELECT Associated_Land__c, Role__c
			FROM Authority__c
			WHERE Contact__c =:contactId
			AND Contact__c != null
			AND Associated_Land__r.RecordTypeId =:FARM_RECORD_TYPE_ID
		];
		Map<Id, String> rolesByFarmIds = new Map<Id, String>();
		for(Authority__c auth: authorities){
			rolesByFarmIds.put(auth.Associated_Land__c, auth.Role__c);
		}
		return rolesByFarmIds;
	}
	public String getRoleByLandAndContact(String landId, String contactId) {
		List<Authority__c> authorities = [
			SELECT Role__c
			FROM Authority__c
			WHERE Contact__c = : contactId
			AND Contact__c != null
			AND Associated_Land__c = : landId
		];
		if(authorities.isEmpty()){
			return null;
		} else {
			if(authorities[0].Role__c != null){
				return authorities[0].Role__c;
			} else {
				return null;
			}
		}
	}
	public Set<Id> getAuthorizedLandIdsByLandsAndContactAndRecordTypeForOwnersAndOperators(Set<Id> landIds, Id contactId, Id landRecordTypeId){
		List<Authority__c> fieldAuthorities = [
			SELECT Associated_Land__c
			FROM Authority__c
			WHERE Contact__c =:contactId
			AND Associated_Land__c IN:landIds
			AND Associated_Land__r.RecordTypeId =:landRecordTypeId
			AND Role__c IN:OwnerOperatorRoles
		];
		Set<Id> authorizedLandIds = new Set<Id>();
		for(Authority__c authority : fieldAuthorities){
			authorizedLandIds.add(authority.Associated_Land__c);
		}
		return authorizedLandIds;
	}
	public Set<Id> getAuthorizedLandIdsByLandsAndContactAndRecordTypeForOtherProducersAndTenants(Set<Id> landIds, Id contactId, Id landRecordTypeId){
		List<Authority__c> fieldAuthorities = [
			SELECT Associated_Land__c
			FROM Authority__c
			WHERE Contact__c =:contactId
			AND Associated_Land__c IN:landIds
			AND Associated_Land__r.RecordTypeId =:landRecordTypeId
			AND Role__c IN:OtherProducerTenantRoles
		];
		Set<Id> authorizedLandIds = new Set<Id>();
		for(Authority__c authority : fieldAuthorities){
			authorizedLandIds.add(authority.Associated_Land__c);//add field Ids
		}
		return authorizedLandIds;
	}
	public Boolean isRoleOperatorOrOwnerOrOperatorOwner(String role){
		return (OPERATOR_ROLE == role || OWNER_ROLE == role || OWNER_OPERATOR_ROLE == role || OPERATOR_OWNER_ROLE == role)? true : false;
	}
	public Boolean isRoleOtherProducerOrOtherTenant(String role){
		if(OTHER_TENANT_TRACT_ROLE.toLowerCase() == role.toLowerCase() || OTHER_TENANT_FIELD_ROLE.toLowerCase() == role.toLowerCase() || OTHER_PRODUCER_TRACT_ROLE.toLowerCase() == role.toLowerCase() ||
		   OTHER_PRODUCER_FIELD_ROLE.toLowerCase() == role.toLowerCase() || OTHER_PRODUCER_ROLE.toLowerCase() == role.toLowerCase() || OTHER_TENANT_ROLE.toLowerCase() == role.toLowerCase()){
			return true;
		} else {
			return false;
		}
	}
}
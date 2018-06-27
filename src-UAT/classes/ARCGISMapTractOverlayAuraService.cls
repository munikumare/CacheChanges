public with sharing class ARCGISMapTractOverlayAuraService extends ARCGISMapOverlayExtension{
	private static final String OPERATOR_ROLE = 'Operator';
	private static final String OPERATOR_OWNER_ROLE = 'Operator-Owner';
	private static final String OWNER_ROLE = 'Owner';
	private static final String OTHER_PRODUCER_ROLE = 'Other Producer';
	private static final String OTHER_TENANT_ROLE = 'Other Tenant';
	private static final String SYSTEM_ADMIN = 'System Administrator';
	private static final String EMPLOYEE_PROFILE = 'FPAC Employee Base';//TODO determine the right profile.

	@auraEnabled
	public static Data getData(Id tractId, String contactId){
		if(String.isEmpty(contactId)){
			 User u = [select id, contactId, IsPortalEnabled from User where id = : UserInfo.getUserId()];         
            if(u.IsPortalEnabled=true)
            {
                contactId=u.contactId;
            }
		}
		Data data = new Data();
		/*Boolean isUserAdminOrEmployee = checkUserIsAdminOrEmployee();
		if(isUserAdminOrEmployee){*/
			data.header = setHeaderValues(tractId,'tract');
			data.helpTexts = getHelpText();
			data.canViewSummary = true;
			//can see all fields associated with the tract record.
			Set<Id> authorizedFieldIds = getAllFieldsIdsByTractId(tractId, contactId);
			data.tract = getTractWithRelatedFields(tractId, authorizedFieldIds);
			data.baseYield.records = getBaseYieldsByTractId(tractId);
			calculateBaseYieldTotal(data.baseYield);
			groupProducers(data);
			return data;
		/*} else {
			String tractAuthRole = getTractAuthorityRole(tractId);
			Boolean hasTractAuth = tractAuthRole != null ? true : false;
			if(hasTractAuth){
				data.header = setHeaderValues(tractId,'tract');
				if(tractAuthRole == OPERATOR_ROLE || tractAuthRole == OPERATOR_OWNER_ROLE || tractAuthRole == OWNER_ROLE) {
					data.canViewSummary = true;
					data.helpTexts = getHelpTexts();
					//can see all fields associated with the tract record.
					Set<Id> authorizedFieldIds = getAuthorizedFieldIdsByRole(tractId, new set<String>{OPERATOR_ROLE,OPERATOR_OWNER_ROLE,OWNER_ROLE});
					data.tract = getTractWithRelatedFields(tractId, authorizedFieldIds);
					data.baseYield.records = getBaseYieldsByTractId(tractId);
					calculateBaseYieldTotal(data.baseYield);
					groupProducers(data);
				} else if(tractAuthRole == OTHER_PRODUCER_ROLE || tractAuthRole == OTHER_TENANT_ROLE){
					//no summary for others.
					data.canViewSummary = false;
					Set<Id> authorizedFieldIds = getAuthorizedFieldIdsByRole(tractId, new set<String>{OTHER_PRODUCER_ROLE,OTHER_TENANT_ROLE});
					data.tract = getReadOnlyTractWithRelatedFields(tractId, authorizedFieldIds);
				}
			}
			else {//has no tract authority
				data.canViewSummary = false;
				data.header = setHeaderValues(tractId,'tract');
				List<Authority__c> fieldAuthorities = getFieldAuthoritiesByTractId(tractId);
				if(!fieldAuthorities.isEmpty()){
					Set<Id> authorizedFieldIds = getAuthorizedFieldIdsByRole(tractId, new set<String>{OPERATOR_ROLE,OPERATOR_OWNER_ROLE,OWNER_ROLE,OTHER_PRODUCER_ROLE,OTHER_TENANT_ROLE});
					data.tract = getReadOnlyTractWithRelatedFields(tractId, authorizedFieldIds);
				} else {
					throw new AuraHandledException('No authority record was found.');
				}
			}*/
			//return data;
		//}
	}
	private static void groupProducers(Data data){

		Integer Owner_Index = 0;
		Integer Producer_Index = 0;
		Integer TotalOwners = 0;
		Integer TotalOtherProducers = 0;

		List<Producer> producers = new List<Producer>();
		if(!data.tract.Authorities__r.isEmpty()){
			producers.add(new Producer());
		}
		for(Authority__c auth : data.tract.Authorities__r){
			if(auth.Role__c == OWNER_ROLE){
				if(String.isNotEmpty(producers[Owner_Index].Owner)){
					Producer p = new Producer();
					p.Owner = auth.Contact__r.Name;
					producers.add(p);
					Owner_Index++;
				} else {
					producers[Owner_Index].Owner = auth.Contact__r.Name;
				}
				TotalOwners++;
			} else if (auth.Role__c == OTHER_PRODUCER_ROLE) {
				if (String.isNotEmpty(producers[Producer_Index].OtherProducer)) {
					Producer p = new Producer();
					p.OtherProducer = auth.Contact__r.Name;
					producers.add(p);
					Producer_Index++;
				} else {
					producers[Producer_Index].OtherProducer = auth.Contact__r.Name;
				}
				TotalOtherProducers++;
			}
		}
		data.summary.TotalOwners = TotalOwners;
		data.summary.TotalOtherProducers = TotalOtherProducers;
		data.producers = producers;
	}

	private static List<Authority__c> getFieldAuthoritiesByTractId(Id tractId){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> authorities = [
			SELECT Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Contact__c != null
			AND Associated_Land__r.Parent_ID__c=:tractId
		];
		if(authorities.isEmpty()){
			return null;
		} else {
			return authorities;
		}
	}
	private static void calculateBaseYieldTotal(BaseYield b){
		for(Base_Yield__c baseYield : b.records){
			b.TotalBaseAcres += baseYield.DCP_Base_Acres__c != null ? baseYield.DCP_Base_Acres__c : 0.00;
			b.TotalBaseReductionAcres += baseYield.Crop_Reduction_Acres__c != null ? baseYield.Crop_Reduction_Acres__c  : 0.00;
		}
	}
	private static List<Base_Yield__c> getBaseYieldsByTractId(Id tractId){
		return [
			SELECT Id, Name, DCP_Base_Acres__c, Crop_Reduction_Acres__c,CTAP_Yield__c,PLC_Yield__c
			FROM Base_Yield__c
			WHERE Land__c=:tractId
		];
	}
	private static String getTractAuthorityRole(Id tractId){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> authorities = [
			SELECT Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Contact__c != null
			AND Associated_Land__c=:tractId
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
	private static Set<Id> getAuthorizedFieldIdsByRole(Id tractId, Set<String> role){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> fieldAuthorities = [
				SELECT Associated_Land__c,Role__c
				FROM Authority__c
				WHERE Contact__c =:user.ContactId
				AND Role__c IN:role
				AND Associated_Land__r.Parent_ID__c =:tractId
		];
		Set<Id> authorizedFieldIds = new Set<Id>();
		for(Authority__c authority : fieldAuthorities){
			authorizedFieldIds.add(authority.Associated_Land__c);//add field Ids
		}
		return authorizedFieldIds;
	}
	private static Set<Id> getAllAuthorizedFieldIdsByTractId(Id tractId){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> fieldAuthorities = [
			SELECT Associated_Land__c,Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Associated_Land__r.Parent_ID__c =:tractId
		];
		Set<Id> authorizedFieldIds = new Set<Id>();
		for(Authority__c authority : fieldAuthorities){
			authorizedFieldIds.add(authority.Associated_Land__c);//add field Ids
		}
		return authorizedFieldIds;
	}
	private static Land__c getTractWithRelatedFields(Id tractId,Set<Id> authorizedFieldIds){
		return [
			SELECT 	Id,Name, Tract_Number__c, Parent_ID__r.Id, Parent_ID__r.Name, Parent_ID__r.Farm_Number__c,
					BIA_Number__c, toLabel(HEL_Code__c), toLabel(Wetland_Code__c), Wetland_Violation__c,
					Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, DCP_Effective_Cropland_Acres__c,DCP_Double_Crop_Acres__c,
					WBP_Acres__c,WRP_Acres__c,MPL_Acres__c,CRP_Acres__c,Grp_Acres__c,State_Conserve_Acres__c,Other_Conserve_Acres__c,Sugarcane_Acres__c,
			    (SELECT Id,Role__c,Contact__r.Name FROM Authorities__r WHERE Role__c =:OWNER_ROLE OR Role__c =:OTHER_PRODUCER_ROLE),
				(SELECT Id, Field_Number__c, CLU_Acreage__c
				 FROM Lands__r
				 WHERE Id IN:authorizedFieldIds ORDER BY State_County_ANSI_Code__c, Field_Number__c)//fields
			FROM Land__c
			WHERE Id=:tractId
			ORDER BY State_County_ANSI_Code__c, Tract_Number__c
		];
	}
	private static Land__c getReadOnlyTractWithRelatedFields(Id tractId,Set<Id> authorizedFieldIds){
		return [
			SELECT 	Id,Name,Tract_Number__c,Parent_ID__r.Id, Parent_ID__r.Name,Parent_ID__r.Farm_Number__c,
				(SELECT Id, Field_Number__c
				 FROM Lands__r
				 WHERE Id IN:authorizedFieldIds ORDER BY State_County_ANSI_Code__c, Field_Number__c)//fields
			FROM Land__c
			WHERE Id=:tractId
			ORDER BY State_County_ANSI_Code__c, Tract_Number__c
		];
	}

	public class Data {
		@auraEnabled
		public Land__c tract;
		@auraEnabled
		public Help_Text__c helpTexts;
		@auraEnabled
		public Boolean canViewSummary = false;
		@auraEnabled
		public Header header = new Header();
		@auraEnabled
		public BaseYield baseYield = new BaseYield();
		@auraEnabled
		public Summary summary = new Summary();
		@auraEnabled
		public List<Producer> producers;
	}
	public class Summary {
		@auraEnabled
		public Integer TotalOwners;
		@auraEnabled
		public Integer TotalOtherProducers;
	}
	public class BaseYield {
		@auraEnabled
		public List<Base_Yield__c> records;
		@auraEnabled
		public Decimal TotalBaseAcres = 0.00;
		@auraEnabled
		public Decimal TotalBaseReductionAcres = 0.00;
	}
	public Class Producer {
		@auraEnabled
		public String Owner;
		@auraEnabled
		public String OtherProducer;
	}
}
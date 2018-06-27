public with sharing class ARCGISMapFarmOverlayAuraService extends ARCGISMapOverlayExtension{

	private static final String OPERATOR_ROLE = 'Operator';
	private static final String OPERATOR_OWNER_ROLE = 'Operator-Owner';
	private static final String OWNER_ROLE = 'Owner';
	private static final String OTHER_PRODUCER_ROLE = 'Other Producer';
	private static final String OTHER_TENANT_ROLE = 'Other Tenant';

	private static final String ELECTION_CODE_A = 'A';
	private static final String ELECTION_CODE_B = 'B';
	private static final String ELECTION_CODE_C = 'C';
	private static final String ELECTION_CODE_E = 'E';

	@auraEnabled
	public static Data getData(Id farmId, String contactId){
		system.debug(contactId);
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
			data.canViewSummary = true;
			data.helpTexts = getHelpText();
			data.header = setHeaderValues(farmId, 'farm');
			Set<Id> authorizedTractIds = getAllTractsIdsByFarmId(farmId,contactId);
			Set<Id> authorizedFieldIds = getAllFieldsIdsByFarmId(farmId,contactId);
			Land__c farmWithTracts = getFarmWithRelatedTracts(farmId, authorizedTractIds);
			Map<Id, Land__c> tractsByIdsWithFields = getTractsByIdsWithRelatedFields(farmId, authorizedFieldIds);
			data.farm = bindObjects(farmWithTracts, tractsByIdsWithFields);
			data.elections.records = getElectionHipsByFarmId(farmId);
			data.baseYield.records = getBaseYieldsByFarmId(farmId);
			setSummaryValues(data);
			setLandUseValues(data);
			calculateBaseYieldTotal(data.baseYield);
			setElectionsValues(data.elections);
			//calculateTractsTotalValues(data);
			return data;
		/*} else {
			String farmAuthRole = getLandAuthorityRoleByLandId(farmId);
			Boolean hasFarmAuthority = farmAuthRole != null ? true : false;
			if (hasFarmAuthority) {
				data.header = setHeaderValues(farmId, 'farm');
				if (farmAuthRole == OPERATOR_ROLE || farmAuthRole == OPERATOR_OWNER_ROLE || farmAuthRole == OWNER_ROLE) {
					data.canViewSummary = true;
					data.helpTexts = getHelpTexts();
					Set<Id> authorizedTractIds, authorizedFieldIds;
					if (farmAuthRole == OPERATOR_ROLE || farmAuthRole == OPERATOR_OWNER_ROLE) {
						//can see all tracts and fields associated with the farm record.
						authorizedTractIds = getAuthorizedTractIdsByRole(farmId, new set<String>{
								OPERATOR_ROLE, OPERATOR_OWNER_ROLE, OWNER_ROLE, OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
						});
						authorizedFieldIds = getAuthorizedFieldIdsByRole(farmId, new set<String>{
								OPERATOR_ROLE, OPERATOR_OWNER_ROLE, OWNER_ROLE, OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
						});
					} else if (farmAuthRole == OWNER_ROLE) {
						//can only see authorized tracts and fields associated with the farm record.
						authorizedTractIds = getAuthorizedTractIdsByRole(farmId, new set<String>{
								OWNER_ROLE
						});
						authorizedFieldIds = getAuthorizedFieldIdsByRole(farmId, new set<String>{
								OWNER_ROLE
						});
					}
					Land__c farmWithTracts = getFarmWithRelatedTracts(farmId, authorizedTractIds);
					Map<Id, Land__c> tractsByIdsWithFields = getTractsByIdsWithRelatedFields(farmId, authorizedFieldIds);
					data.farm = bindObjects(farmWithTracts, tractsByIdsWithFields);
					data.elections.records = getElectionHipsByFarmId(farmId);
					data.baseYield.records = getBaseYieldsByFarmId(farmId);

					setSummaryValues(data);
					setLandUseValues(data);
					calculateBaseYieldTotal(data.baseYield);
					setElectionsValues(data.elections);
					//calculateTractsTotalValues(data);

				} else if (farmAuthRole == OTHER_PRODUCER_ROLE || farmAuthRole == OTHER_TENANT_ROLE) {
					data.canViewSummary = false;
					//can only see authorized tracts and fields associated with the farm record.
					Set<Id> authorizedTractIds = getAuthorizedTractIdsByRole(farmId, new set<String>{
							OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
					});
					Set<Id> authorizedFieldIds = getAuthorizedFieldIdsByRole(farmId, new set<String>{
							OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
					});
					Land__c farmWithTracts = getFarmWithRelatedTracts(farmId, authorizedTractIds);
					Map<Id, Land__c> tractsByIdsWithFields = getTractsByIdsWithRelatedFields(farmId, authorizedFieldIds);
					data.farm = bindObjects(farmWithTracts, tractsByIdsWithFields);
				}
				return data;
			} else { //has no farm authority on farm level
				data.canViewSummary = false;
				data.header = setHeaderValues(farmId, 'farm');
				List<Authority__c> tractAuthorities = getTractAuthoritiesByFarmId(farmId);
				if (!tractAuthorities.isEmpty()) {
					Set<Id> authorizedTractIds = getAuthorizedTractIdsByRole(farmId, new set<String>{
							OPERATOR_ROLE, OPERATOR_OWNER_ROLE, OWNER_ROLE, OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
					});
					Set<Id> authorizedFieldIds = getAuthorizedFieldIdsByRole(farmId, new set<String>{
							OPERATOR_ROLE, OPERATOR_OWNER_ROLE, OWNER_ROLE, OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
					});
					Land__c farmWithTracts = getFarmWithRelatedTracts(farmId, authorizedTractIds);
					Map<Id, Land__c> tractsByIdsWithFields = getTractsByIdsWithRelatedFields(farmId, authorizedFieldIds);
					data.farm = bindObjects(farmWithTracts, tractsByIdsWithFields);
					//calculateTractsTotalValues(data);
					return data;
				} else {//has no tract authorities on tract level. Show tract shell. navigation user.
					//cannot see tracts but can see tracts without fields tab to navigate.
					List<Authority__c> fieldAuthorities = getFieldAuthoritiesByFarmId(farmId);
					if (!fieldAuthorities.isEmpty()) {
						Set<Id> authorizedFieldIds = getAuthorizedFieldIdsByRole(farmId, new set<String>{
								OPERATOR_ROLE, OPERATOR_OWNER_ROLE, OWNER_ROLE, OTHER_PRODUCER_ROLE, OTHER_TENANT_ROLE
						});
						Set<Id> tractIds = getNavigationalFieldsTractIds(farmId, authorizedFieldIds);
						List<Land__c> tracts = getNavigationalTracts(farmId, tractIds);
						setNavigationalTracts(data, tracts);
						return data;
					} else {
						throw new AuraHandledException('No authority record was found.');
					}
				}
			}
		}*/
	}
	private static void setSummaryValues(Data d){
		setContractNumbers(d);
		for(Tract tract : d.farm.tracts){
			d.summary.FarmLandAcres += tract.record.Farmland_Acres__c != null ? tract.record.Farmland_Acres__c : 0.00;
			d.summary.CroplandAcres += tract.record.Cropland_Acres__c != null ? tract.record.Cropland_Acres__c : 0.00;
			d.summary.DCPCroplandAcres += tract.record.DCP_Cropland_Acres__c != null ? tract.record.DCP_Cropland_Acres__c : 0.00;
			d.summary.DCPEffectiveCroplandAcres += tract.record.DCP_Effective_Cropland_Acres__c != null ? tract.record.DCP_Effective_Cropland_Acres__c : 0.00;
			d.summary.DCPDoubleCroplandAcres += tract.record.DCP_Double_Crop_Acres__c != null ? tract.record.DCP_Double_Crop_Acres__c : 0.00;
		}
		d.summary.FarmStatus = d.farm.record.Inactive_Indicator__c != null ? (d.farm.record.Inactive_Indicator__c ? 'Inactive':'Active') :'';
	}
	private static void setLandUseValues(Data d){
		for(Tract tract : d.farm.tracts){
			d.landUse.WBPAcres += tract.record.WBP_Acres__c != null ? tract.record.WBP_Acres__c : 0.00;
			d.landUse.WRPAcres += tract.record.WRP_Acres__c != null ? tract.record.WRP_Acres__c : 0.00;
			d.landUse.MPLAcres += String.isEmpty(tract.record.MPL_Acres__c)? 0.00 : Decimal.valueOf(tract.record.MPL_Acres__c);
			d.landUse.CRPAcres += tract.record.CRP_Acres__c != null ? tract.record.CRP_Acres__c : 0.00;
			d.landUse.GRPAcres += tract.record.Grp_Acres__c != null ? tract.record.Grp_Acres__c : 0.00;
			d.landUse.StateConserveAcres += tract.record.State_Conserve_Acres__c != null ? tract.record.State_Conserve_Acres__c : 0.00;
			d.landUse.OtherConserveAcres += tract.record.Other_Conserve_Acres__c != null ? tract.record.Other_Conserve_Acres__c : 0.00;
			d.landUse.SugarcaneAcres += tract.record.Sugarcane_Acres__c != null ? tract.record.Sugarcane_Acres__c : 0.00;
		}
	}
	private static void calculateBaseYieldTotal(BaseYield b){
		for(Base_Yield__c baseYield : b.records){
			b.BaseAcresTotal += baseYield.DCP_Base_Acres__c != null ? baseYield.DCP_Base_Acres__c : 0.00;
			b.BaseReductionAcresTotal += baseYield.Crop_Reduction_Acres__c != null ? baseYield.Crop_Reduction_Acres__c  : 0.00;
		}
	}
	private static void setElectionsValues(Elections e){
		e.values = groupElections(e.records);
	}
	private static void calculateTractsTotalValues(Data d){
		//TODO It will be deprecated
		for(Tract tract : d.farm.tracts){
			for(Field field : tract.fields){
				if(field.record.CRP_Contract_Number__c != null){
					tract.FarmlandTotal += tract.record.Farmland_Acres__c !=null ? tract.record.Farmland_Acres__c : 0.00;
					tract.CroplandTotal += tract.record.Cropland_Acres__c !=null ? tract.record.Cropland_Acres__c : 0.00;
				}
			}
		}
	}
	private static List<Election> groupElections(List<Election_Hip__c> records){

		Integer ARC_IC_Index = 0;
		Integer ARC_CO_Index = 0;
		Integer PLC_Index = 0;
		Integer PLC_Default_Index = 0;

		List<Election> elections = new List<Election>();
		if(!records.isEmpty()){
			elections.add(new Election());
		}

		for(Election_Hip__c election : records){
			if(election.Election_Code__c == ELECTION_CODE_A){
				if(String.isNotEmpty(elections[ARC_IC_Index].ARC_IC)){
					Election e = new Election();
					e.ARC_IC = election.Abbreviation__c;
					elections.add(e);
					ARC_IC_Index++;
				} else {
					elections[ARC_IC_Index].ARC_IC = election.Abbreviation__c;
				}
			} else if (election.Election_Code__c == ELECTION_CODE_B){
				if(String.isNotEmpty(elections[ARC_CO_Index].ARC_CO)){
					Election e = new Election();
					e.ARC_CO = election.Abbreviation__c;
					elections.add(e);
					ARC_CO_Index++;
				} else {
					elections[ARC_IC_Index].ARC_CO = election.Abbreviation__c;
				}
			} else if (election.Election_Code__c == ELECTION_CODE_C){
				if(String.isNotEmpty(elections[PLC_Index].PLC)){
					Election e = new Election();
					e.PLC = election.Abbreviation__c;
					elections.add(e);
					PLC_Index++;
				} else {
					elections[PLC_Index].PLC = election.Abbreviation__c;
				}
			} else if (election.Election_Code__c == ELECTION_CODE_E){
				if(String.isNotEmpty(elections[PLC_Default_Index].PLC_Default)){
					Election e = new Election();
					e.PLC_Default = election.Abbreviation__c;
					elections.add(e);
					PLC_Default_Index++;
				} else {
					elections[PLC_Default_Index].PLC_Default = election.Abbreviation__c;
				}
			}
		}
		return elections;
	}
	private static void setContractNumbers(Data d){
		List<String> contractNumbers = new List<String>();
		for(Tract tract : d.farm.tracts){
			for(Field field : tract.fields){
				if(field.record.CRP_Contract_Number__c != null){
					contractNumbers.add('\''+field.record.CRP_Contract_Number__c+'\'');
				}
			}
		}
		d.summary.CRPContractNumbers = String.join(contractNumbers, ',');
	}
	private static void setNavigationalTracts(Data d, List<Land__c> tracts){
		Farm farm = new Farm();
		for(Land__c tract : tracts){
			Tract t = new Tract();
			t.TotalFields = tract.Lands__r.size();
			for(Land__c field : tract.Lands__r){
				Field f = new Field();
				f.record = field;
				t.fields.add(f);
			}
			farm.tracts.add(t);
		}
		d.farm = farm;
	}
	private static Farm bindObjects(Land__c farmWithTracts, Map<Id, Land__c>  tractsByIdsWithFields){
		Farm farmWrapper = new Farm();
		farmWrapper.record = farmWithTracts;
		for(Land__c tract: farmWithTracts.Lands__r){
			tract = tractsByIdsWithFields.get(tract.Id);
			Tract tractWrapper = new Tract();
			tractWrapper.record = tract;
			for(Land__c field : tract.Lands__r){
				Field fieldWrapper = new Field();
				fieldWrapper.record = field;
				tractWrapper.fields.add(fieldWrapper);
			}
			farmWrapper.tracts.add(tractWrapper);
		}
		return farmWrapper;
	}
	//data accessors.
	private static Set<Id> getAuthorizedTractIdsByRole(Id farmId, Set<String> role){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> tractAuthorities = [
			SELECT Associated_Land__c,Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Role__c IN :role
			AND Associated_Land__r.Parent_ID__c =:farmId
		];
		Set<Id> authorizedTractIds = new Set<Id>();
		for(Authority__c authority : tractAuthorities){
			authorizedTractIds.add(authority.Associated_Land__c);//add tract Ids
		}
		return authorizedTractIds;

	}
	private static Set<Id> getAuthorizedFieldIdsByRole(Id farmId, Set<String> role){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> fieldAuthorities = [
			SELECT Associated_Land__c,Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Role__c IN:role
			AND Associated_Land__r.Parent_ID__r.Parent_ID__c =:farmId
		];
		Set<Id> authorizedFieldIds = new Set<Id>();
		for(Authority__c authority : fieldAuthorities){
			authorizedFieldIds.add(authority.Associated_Land__c);//add field Ids
		}
		return authorizedFieldIds;
	}

	private static Land__c getFarmWithRelatedTracts(Id farmId,Set<Id> authorizedTractsIds){
		system.debug(authorizedTractsIds);
		return[
			SELECT Id,Name,Farm_Number__c,Inactive_Indicator__c,
			(SELECT Id FROM Lands__r WHERE Id IN:authorizedTractsIds ORDER BY State_County_ANSI_Code__c, Tract_Number__c)//tracts
			FROM Land__c
			WHERE Id=:farmId
			ORDER BY State_County_ANSI_Code__c, Farm_Number__c
		];
	}
	private static Map<Id, Land__c> getTractsByIdsWithRelatedFields(Id farmId,Set<Id> authorizedFieldIds){
		system.debug(authorizedFieldIds);
		return new Map<Id, Land__c>([
			SELECT Id,Name,Tract_Number__c, Farmland_Acres__c, Cropland_Acres__c, Fields__c, Description__c,
					DCP_Cropland_Acres__c,DCP_Effective_Cropland_Acres__c,DCP_Double_Crop_Acres__c,
					WBP_Acres__c,WRP_Acres__c,MPL_Acres__c,CRP_Acres__c,Grp_Acres__c,State_Conserve_Acres__c,Other_Conserve_Acres__c,Sugarcane_Acres__c,
					Parent_ID__r.Id,Parent_ID__r.Name,Parent_ID__r.Farm_Number__c,
			(SELECT Id, CLU_Acreage__c, CRP_Contract_Number__c,Parent_ID__r.Id,Parent_ID__r.Name,Parent_ID__r.Farm_Number__c,Parent_ID__r.Parent_ID__r.Id,Parent_ID__r.Parent_ID__r.Name,Parent_ID__r.Parent_ID__r.Farm_Number__c FROM Lands__r WHERE Id IN:authorizedFieldIds ORDER BY State_County_ANSI_Code__c, Field_Number__c)//fields
			FROM Land__c
			WHERE Parent_ID__c=:farmId
			ORDER BY State_County_ANSI_Code__c, Tract_Number__c
		]);
	}
	private static Set<Id> getNavigationalFieldsTractIds(Id farmId, Set<Id> authorizedFieldIds){
		List<Land__c> fields = [
			SELECT Id,Parent_ID__r.Name, Parent_ID__r.Tract_Number__c, Parent_ID__r.Description__c
			FROM Land__c
			WHERE Id IN:authorizedFieldIds
			AND Parent_ID__r.Parent_ID__c=:farmId
			ORDER BY State_County_ANSI_Code__c, Field_Number__c
		];
		if(!fields.isEmpty()){
			Set<Id> ids = new Set<Id>();
			for(Land__c field : fields){
				ids.add(field.Parent_ID__c);
			}
			return ids;
		}
		return new Set<ID>();
	}
	private static List<Land__c> getNavigationalTracts(Id farmId, Set<Id> authorizedTractIds){
		return [
			SELECT Id,Name,Tract_Number__c,Description__c,
				(SELECT Id FROM Lands__r)
			FROM Land__c
			WHERE Id IN:authorizedTractIds
			AND Parent_ID__c=:farmId
			ORDER BY State_County_ANSI_Code__c, Tract_Number__c
		];
	}
	private static List<Base_Yield__c> getBaseYieldsByFarmId(Id farmId){
		return [
			SELECT Id, Name, DCP_Base_Acres__c, Crop_Reduction_Acres__c,Fav_Reduction_Acreages__c,CC_Yield__c,Direct_Yield__c
			FROM Base_Yield__c
			WHERE Land__c=:farmId
		];
	}
	private static List<Election_Hip__c> getElectionHipsByFarmId(Id farmId){
		return [
			SELECT Id, Election_Code__c, Abbreviation__c
			FROM Election_Hip__c
			WHERE Land__c =:farmId
			ORDER BY Abbreviation__c ASC
		];
	}
	private static String getLandAuthorityRoleByLandId(Id landId){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> authorities = [
				SELECT Role__c
				FROM Authority__c
				WHERE Contact__c =:user.ContactId
				AND Contact__c != null
				AND Associated_Land__c=:landId
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
	private static List<Authority__c> getTractAuthoritiesByFarmId(Id farmId){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> authorities = [
			SELECT Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Contact__c != null
			AND Associated_Land__r.Parent_ID__c=:farmId
		];
		if(authorities.isEmpty()){
			return null;
		} else {
			return authorities;
		}
	}
	private static List<Authority__c> getFieldAuthoritiesByFarmId(Id farmId){
		Id userId = UserInfo.getUserId();
		User user = [SELECT Id, ContactId FROM User WHERE Id = :userId];
		List<Authority__c> authorities = [
			SELECT Role__c
			FROM Authority__c
			WHERE Contact__c =:user.ContactId
			AND Contact__c != null
			AND Associated_Land__r.Parent_ID__r.Parent_ID__c=:farmId
		];
		if(authorities.isEmpty()){
			return null;
		} else {
			return authorities;
		}
	}


	public class Data {
		@auraEnabled
		public Farm farm;
		@auraEnabled
		public Help_Text__c helpTexts;
		//tabs
		@auraEnabled
		public Header header = new Header();
		@auraEnabled
		public Summary summary = new Summary();
		@auraEnabled
		public LandUse landUse = new LandUse();
		@auraEnabled
		public BaseYield baseYield = new BaseYield();
		@auraEnabled
		public Elections elections = new Elections();
		@auraEnabled
		public Boolean canViewSummary = false;
	}
	public class Summary {
		@auraEnabled
		public String CRPContractNumbers;
		@auraEnabled
		public Decimal FarmLandAcres = 0.00;
		@auraEnabled
		public Decimal CroplandAcres = 0.00;
		@auraEnabled
		public Decimal DCPCroplandAcres = 0.00;
		@auraEnabled
		public Decimal DCPEffectiveCroplandAcres = 0.00;
		@auraEnabled
		public Decimal DCPDoubleCroplandAcres = 0.00;
		@auraEnabled
		public String FarmStatus;
	}
	public class LandUse {
		@auraEnabled
		public Decimal WBPAcres = 0.00;
		@auraEnabled
		public Decimal WRPAcres = 0.00;
		@auraEnabled
		public Decimal MPLAcres = 0.00;
		@auraEnabled
		public Decimal CRPAcres = 0.00;
		@auraEnabled
		public Decimal GRPAcres = 0.00;
		@auraEnabled
		public Decimal StateConserveAcres = 0.00;
		@auraEnabled
		public Decimal OtherConserveAcres = 0.00;
		@auraEnabled
		public Decimal SugarcaneAcres = 0.00;
	}
	public class BaseYield {
		@auraEnabled
		public List<Base_Yield__c> records;
		@auraEnabled
		public Decimal BaseAcresTotal = 0.00;
		@auraEnabled
		public Decimal BaseReductionAcresTotal = 0.00;
	}
	public class Elections {
		//for grouping
		private List<Election_Hip__c> records;
		@auraEnabled
		public List<Election> values = new List<Election>();
	}
	public Class Election{
		@auraEnabled
		public String ARC_IC;
		@auraEnabled
		public String ARC_CO;
		@auraEnabled
		public String PLC;
		@auraEnabled
		public String PLC_Default;
	}
	public class Farm{
		@auraEnabled
		public Land__c record;
		@auraEnabled
		public List<Tract> tracts = new List<Tract>();
	}
	public class Tract{
		@auraEnabled
		public Land__c record;
		@auraEnabled
		public Integer TotalFields = 0;
		@auraEnabled
		public Decimal FarmlandTotal = 0.00;
		@auraEnabled
		public Decimal CroplandTotal = 0.00;
		@auraEnabled
		public List<Field> fields = new List<Field>();
	}
	public class Field{
		@auraEnabled
		public Land__c record;
	}
}
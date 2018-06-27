public with sharing class Farm156EZ_PDFController {

	public Land_View__c farm { get; set; }
	public List<Land_View__c> tracts { get; set; }
	public Map<Id, List<Land_View__c>> fields { get; set; }
	public String operator { get; set; }
	public Map<Id, String> owners { get; set; }
	public Map<Id, String> otherProducers { get; set; }
	public Map<Id, List<Base_Yield__c>> crops { get; set; }
	public List<Base_Yield__c> farmCrops { get; set; }
	public String farmsAssociatedWith {get; set; }
	public String electionHipsArcIc { get; set; }
	public String electionHipsArcCo { get; set; }
	public String electionHipsPlc { get; set; }
	public String electionHipsPlcDefault { get; set; }

	private final String ELECTION_TYPE_ARC_IC = 'C';
	private final String ELECTION_TYPE_ARC_CO = 'B';
	private final String ELECTION_TYPE_PLC = 'A';
	private final String ELECTION_TYPE_PLC_DEFAULT = 'E';
	private final String AUTHORITY_OPERATOR_ROLE = 'Operator';
	private final String AUTHORITY_OWNER_ROLE = 'Owner';
	private final String AUTHORITY_OTHER_PRODUCER_ROLE = 'Other Producer';

	public String getDateTime() {
		return System.now().format('M/d/yy hh:mm a');
	}

	public String getYear() {
		return System.now().format('yyyy');
	}

	public Integer getTractsSize() {
		return tracts.size();
	}

	public String urlFarmId;
	public void setUrlFarmId(String newValue) {
		urlFarmId = newValue;
		if(urlFarmId != null) {
			init();
		}
	}
	public String getUrlFarmId() {
		return urlFarmId;
	}

	private void init() {
		farm = LandViewDA.getLand(urlFarmId);
		tracts = LandViewDA.getChildrenLands(urlFarmId);
		fields = new Map<Id, List<Land_View__c>>();
		crops = new Map<Id, List<Base_Yield__c>>();
		farmCrops = BaseYieldDA.getCropsForLand(farm.Land_ID__c);
		setElectionHipValues();
		setOperator();

		List<String> tractIds = new List<String>();
		for (Land_View__c tract : tracts) {
			tractIds.add(tract.Land_ID__c);
		}
		List<Land_View__c> allFields = LandViewDA.getChildrenLands(tractIds);
		List<Base_Yield__c> allCrops = BaseYieldDA.getCropsForLand(tractIds);

		setOwners();
		setOtherProducers();
		setFarmsAssociateWith();

		for (Land_View__c tract : tracts) {
			List<Land_View__c> thisTractsFields = new List<Land_View__c>();
			List<Base_Yield__c> thisTractsCrops = new List<Base_Yield__c>();
			for (Land_View__c field : allFields) {
				if (tract.Land_ID__c == field.Land_ID__r.Parent_ID__c) {
					thisTractsFields.add(field);
				}
			}
			for (Base_Yield__c crop : allCrops) {
				if (tract.Land_ID__c == crop.Land__c) {
					thisTractsCrops.add(crop);
				}
			}
			fields.put(tract.Id, thisTractsFields);
			crops.put(tract.Id, thisTractsCrops);
		}
	}

	private void setFarmsAssociateWith() {
		String operatorId = [
			SELECT Contact__c
			FROM Authority__c
			WHERE Role__c = :AUTHORITY_OPERATOR_ROLE
				AND Associated_Land__c != :farm.Land_ID__c
			LIMIT 1
		].Contact__c;

		List<Authority__c> authorities = [
			SELECT Id, Associated_Land__r.Admin_State_Code__c, Associated_Land__r.Admin_County_Code__c, Associated_Land__r.Farm_Number__c
			FROM Authority__c
			WHERE Role__c = :AUTHORITY_OPERATOR_ROLE
				AND Associated_Land__c != :farm.Land_ID__c
				AND Contact__c = :operatorId
				AND Associated_Land__r.RecordType.Name = 'Farm'
		];
		for (Authority__c authority : authorities) {
			farmsAssociatedWith += (String.isEmpty(farmsAssociatedWith) ? '' : ', ' ) + authority.Associated_Land__r.Admin_State_Code__c + '-' + authority.Associated_Land__r.Admin_County_Code__c + '-' + authority.Associated_Land__r.Farm_Number__c;
		}
	}

	private void setOtherProducers() {
		otherProducers = getAssociatedContacts(AUTHORITY_OTHER_PRODUCER_ROLE);
	}

	private void setOwners() {
		owners = getAssociatedContacts(AUTHORITY_OWNER_ROLE);
	}

	private Map<Id, String> getAssociatedContacts(String role) {
		Map<Id, String> owners2 = new Map<Id, String>();
		List<String> tractIds = new List<String>();
		for (Land_View__c tractView : tracts) {
			tractIds.add(tractView.Land_ID__c);
			owners2.put(tractView.Id, '');
		}

		if (!tractIds.isEmpty()) {
			List<String> landIds = new List<String>();
			for (Land_View__c tract : tracts) {
				landIds.add(tract.Land_ID__c);
			}

			List<Authority__c> authorities = [
				SELECT Contact__r.Name, Associated_Land__c
				FROM Authority__c
				WHERE Role__c = :role
					AND Associated_Land__c IN :landIds
			];

			if (!authorities.isEmpty()) {
				for (Authority__c authority : authorities) {
					for (Land_View__c tract : tracts) {
						if (authority.Associated_Land__c == tract.Land_ID__c) {
							if (owners2.get(tract.Id) != '') {
								owners2.put(tract.Id, owners2.get(tract.Id) + ', ');
							}
							owners2.put(tract.Id, owners2.get(tract.Id) + authority.Contact__r.Name);
						}
					}
				}
			}
		}
		return owners2;
	}

	private void setElectionHipValues() {
		List<Election_Hip__c> electionHips = ElectionHipDA.getElectionHips(farm.Land_ID__c);

		electionHipsArcIc = '';
		electionHipsArcCo = '';
		electionHipsPlc = '';
		electionHipsPlcDefault = '';

		for (Election_Hip__c electionHip : electionHips) {
			if (electionHip.Election_Code__c == ELECTION_TYPE_ARC_IC) {
				if (String.isNotEmpty(electionHipsArcIc)) {
					electionHipsArcIc += ', ';
				}
				electionHipsArcIc += electionHip.Abbreviation__c;
			} else if (electionHip.Election_Code__c == ELECTION_TYPE_ARC_CO) {
				if (String.isNotEmpty(electionHipsArcCo)) {
					electionHipsArcCo += ', ';
				}
				electionHipsArcCo += electionHip.Abbreviation__c;
			} else if (electionHip.Election_Code__c == ELECTION_TYPE_PLC) {
				if (String.isNotEmpty(electionHipsPlc)) {
					electionHipsPlc += ', ';
				}
				electionHipsPlc += electionHip.Abbreviation__c;
			} else if (electionHip.Election_Code__c == ELECTION_TYPE_PLC_DEFAULT) {
				if (String.isNotEmpty(electionHipsPlcDefault)) {
					electionHipsPlcDefault += ', ';
				}
				electionHipsPlcDefault += electionHip.Abbreviation__c;
			}
		}

		if (String.isEmpty(electionHipsArcIc)) {
			electionHipsArcIc = 'NONE';
		}
		if (String.isEmpty(electionHipsArcCo)) {
			electionHipsArcCo = 'NONE';
		}
		if (String.isEmpty(electionHipsPlc)) {
			electionHipsPlc = 'NONE';
		}
		if (String.isEmpty(electionHipsPlcDefault)) {
			electionHipsPlcDefault = 'NONE';
		}
	}

	private void setOperator() {
		try {
			operator = [
				SELECT Contact__r.Name
				FROM Authority__c
				WHERE Associated_Land__c = :farm.Land_ID__c
					AND Role__c = :AUTHORITY_OPERATOR_ROLE
				LIMIT 1
			].Contact__r.Name;
		} catch (Exception e) {
			operator = '';
		}
	}

}
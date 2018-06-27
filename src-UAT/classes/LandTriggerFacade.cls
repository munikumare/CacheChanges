public without sharing class LandTriggerFacade {

	private final String TRACT_RECORD_TYPE_NAME = 'TRACT';
	private LandDAO landAccessor;
	
	public LandTriggerFacade(LandDAO landAccessor) {
		this.landAccessor = landAccessor;
	}

	public void setupLandDataForAggregation(List<Land__c> lands) {
		Set<String> farmIds = new Set<String>();
		Map<Id, Schema.RecordTypeInfo> recordTypeMap = Land__c.sObjectType.getDescribe().getRecordTypeInfosById();

		for (Land__c land : lands) {
			if (recordTypeMap.containsKey(land.RecordTypeId)) {
				if (recordTypeMap.get(land.RecordTypeId).getName().containsIgnoreCase(TRACT_RECORD_TYPE_NAME)) {
					farmIds.add(land.Parent_ID__c);
				}
			}
		}

		Map<String, List<Land__c>> tractsByParentFarm = this.landAccessor.getTractsByParentFarm(farmIds);
		List<Land__c> farms = this.landAccessor.getFarms(farmIds);

		aggregateTractDataForFarm(tractsByParentFarm, farms);
		this.landAccessor.updateLands(farms);

	}

	private void aggregateTractDataForFarm(Map<String, List<Land__c>> tractsByParentFarm, List<Land__c> farms) {
		for (Land__c farm : farms) {
			if (tractsByParentFarm.containsKey(farm.Id)) {
				clearLandValues(farm);
				for (Land__c tract : tractsByParentFarm.get(farm.Id)) {
					if (tract.CRP_Contract_Number__c != null) {
						farm.CRP_Contract_Number__c += tract.CRP_Contract_Number__c + ', ';
					}
					if (tract.Farmland_Acres__c != null) {
						farm.Farmland_Acres__c += tract.Farmland_Acres__c;
					}
					if (tract.Cropland_Acres__c != null) {
						farm.Cropland_Acres__c += tract.Cropland_Acres__c;
					}
					if (tract.DCP_Cropland_Acres__c != null) {
						farm.DCP_Cropland_Acres__c += tract.DCP_Cropland_Acres__c;
					}
			   		if (tract.DCP_Effective_Cropland_Acres__c != null) {
			   			farm.DCP_Effective_Cropland_Acres__c += tract.DCP_Effective_Cropland_Acres__c;
			   		}
			   		if (tract.DCP_Double_Crop_Acres__c != null) {
			   			farm.DCP_Double_Crop_Acres__c += tract.DCP_Double_Crop_Acres__c;
			   		}
			   		if (tract.WBP_Acres__c != null) {
			   			farm.WBP_Acres__c += tract.WBP_Acres__c;
			   		}
			   		if (tract.WRP_Acres__c != null) {
			   			farm.WRP_Acres__c += tract.WRP_Acres__c;
			   		}
			   		if (tract.MPL_Acres__c != null) {
			   			farm.MPL_Acres__c += tract.MPL_Acres__c;
			   		}
			   		if (tract.CRP_Acres__c != null) {
			   			farm.CRP_Acres__c += tract.CRP_Acres__c;
			   		}
			   		if (tract.Grp_Acres__c != null) {
			   			farm.Grp_Acres__c += tract.Grp_Acres__c;
			   		}
			   		if (tract.State_Conserve_Acres__c != null) {
			   			farm.State_Conserve_Acres__c += tract.State_Conserve_Acres__c;
			   		}
			   		if (tract.Other_Conserve_Acres__c != null) {
			   			farm.Other_Conserve_Acres__c += tract.Other_Conserve_Acres__c;
			   		}
			    	if (tract.Sugarcane_Acres__c != null) {
			    		farm.Sugarcane_Acres__c += tract.Sugarcane_Acres__c;
			    	}
			    }
			}
		}
	}

	private void clearLandValues(Land__c land) {
		land.CRP_Contract_Number__c = '';
		land.Farmland_Acres__c = 0;
		land.Cropland_Acres__c = 0;
		land.DCP_Cropland_Acres__c = 0;
		land.DCP_Effective_Cropland_Acres__c = 0;
		land.DCP_Double_Crop_Acres__c = 0;
		land.WBP_Acres__c = 0;
		land.WRP_Acres__c = 0;
		land.MPL_Acres__c = '';
		land.CRP_Acres__c = 0;
		land.Grp_Acres__c = 0;
		land.State_Conserve_Acres__c = 0;
		land.Other_Conserve_Acres__c = 0;
		land.Sugarcane_Acres__c = 0;
	}

	public static LandTriggerFacade createLandTriggerFacade() {
		return new LandTriggerFacade(
			new LandDataAccessor()
			);
	}
}
public without sharing class LandDataAccessor implements LandDAO {
	
	public Map<String, List<Land__c>> getTractsByParentFarm(Set<String> farmIds) {
		Map<String, List<Land__c>> farmToTractMap = new Map<String, List<Land__c>>();

		List<Land__c> tracts = [
			SELECT Id, Parent_ID__c, CRP_Contract_Number__c, Farmland_Acres__c, Cropland_Acres__c, 
				   DCP_Cropland_Acres__c, DCP_Effective_Cropland_Acres__c, DCP_Double_Crop_Acres__c,
				   WBP_Acres__c, WRP_Acres__c,  MPL_Acres__c, CRP_Acres__c, Grp_Acres__c,
				   State_Conserve_Acres__c, Other_Conserve_Acres__c, Sugarcane_Acres__c	
			FROM Land__c
			WHERE Parent_ID__c IN :farmIds
		];

		for (Land__c tract : tracts) {
			if (farmToTractMap.containsKey(tract.Parent_ID__c)) {
				farmToTractMap.get(tract.Parent_ID__c).add(tract);
			} else {
				farmToTractMap.put(tract.Parent_ID__c, new List<Land__c>{tract});
			}
		}

		return farmToTractMap;
	}

	public List<Land__c> getFarms(Set<String> farmIds) {
		return [
			SELECT Id, CRP_Contract_Number__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, 
				   DCP_Effective_Cropland_Acres__c, DCP_Double_Crop_Acres__c, WBP_Acres__c, WRP_Acres__c, 
				   MPL_Acres__c, CRP_Acres__c, Grp_Acres__c, State_Conserve_Acres__c, Other_Conserve_Acres__c,
				   Sugarcane_Acres__c	
			FROM Land__c
			WHERE Id IN :farmIds
		];
	}

	public void updateLands(List<Land__c> lands) {
		update lands;
	}

}
public with sharing class BaseYieldDA {
	public static List<Base_Yield__c> getCropsForLand(List<String> landIds) {
		return [
			SELECT
				Id,
				Abbreviation__c,
				CC_Yield__c,
				CCC_505_CRP_Reduction_Acres__c,
				Code__c,
				Crop_ID__c,
				Crop_Reduction_Acres__c,
				Crop_Released_Acres__c,
				Crop_Yield__c,
				CTAP_Yield__c,
				DCP_Base_Acres__c,
				Direct_Yield__c,
				Fav_Reduction_Acreages__c,
				Fav_Rotational_Indicator__c,
				HIP__c,
				Land__c,
				Land_ID__c,
				Name,
				Name__c,
				PLC_Yield__c,
				Total_Base_Acres__c,
				Total_CCC_505_CRP_Reduction_Acres__c,
				Type_Code__c,
				Type_Name__c
			FROM Base_Yield__c
			WHERE Land__c IN :landIds
		];
	}

	public static List<Base_Yield__c> getCropsForLand(String landId) {
		return [
			SELECT
				Id,
				Abbreviation__c,
				CC_Yield__c,
				CCC_505_CRP_Reduction_Acres__c,
				Code__c,
				Crop_ID__c,
				Crop_Reduction_Acres__c,
				Crop_Released_Acres__c,
				Crop_Yield__c,
				CTAP_Yield__c,
				DCP_Base_Acres__c,
				Direct_Yield__c,
				Fav_Reduction_Acreages__c,
				Fav_Rotational_Indicator__c,
				HIP__c,
				Land__c,
				Land_ID__c,
				Name,
				Name__c,
				PLC_Yield__c,
				Total_Base_Acres__c,
				Total_CCC_505_CRP_Reduction_Acres__c,
				Type_Code__c,
				Type_Name__c
			FROM Base_Yield__c
			WHERE Land__c = :landId
		];
	}
}
public with sharing class WHIPLITreeLossAuraService {
	private static final String WLI_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get('Tree Loss').getRecordTypeId();

	@auraEnabled
	public static WHIPLossInformation__c getWLI(String dataId, String parentId) {
		WHIPLossInformation__c wli = (WHIPLossInformation__c)Schema.getGlobalDescribe().get('WHIPLossInformation__c').newSObject(WLI_RECORD_TYPE_ID, true);
		wli.WHIPNoticeOfLoss__c = parentId;
		wli.RecordTypeId = WLI_RECORD_TYPE_ID;

		NAP_RMA_NCT_ACR_Data__c data = [
			SELECT Id, RecordType.Name, NAP_Share__c, NAP_Pay_Crop_Type_Code__c, NAP_Pay_Crop_Code__c, 
				   NCT_Tree_Bush_Vine_Damager_Factor_I__c, NCT_Tree_Bush_Vine_Damager_Factor_II__c, 
				   NCT_Tree_Bush_Vine_Damager_Factor_III__c, NCT_Tree_Bush_Vine_Price_I__c, 
				   NCT_Tree_Bush_Vine_Price_II__c, NCT_Tree_Bush_Vine_Price_III__c, RMA_Location_State_Code__c, 
				   RMA_Location_County_Code__c, ACR_Share__c, NCT_Pay_Type__c, NCT_Pay_Crop__c, NAP_Crop_Type_Code__c,
				   RMA_Type_Code__c, ACR_Crop_Type_Code__c
			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE Id = :dataId
		];

		if (data.RecordType.Name == 'NAP Data') {
			if (!isNull(data.NAP_Crop_Type_Code__c)) {
				wli.CropType__c = data.NAP_Crop_Type_Code__c;
			}
			if (!isNull(data.NAP_Share__c)) {
				wli.Share__c = data.NAP_Share__c;
			}
			if (!isNull(data.NAP_Pay_Crop_Type_Code__c)) {
				wli.PayTypeCode__c = data.NAP_Pay_Crop_Type_Code__c;
			}
			if (!isNull(data.NAP_Pay_Crop_Code__c)) {
				wli.PayCropCode__c = data.NAP_Pay_Crop_Code__c;
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Damager_Factor_I__c)) {
				wli.PartialDamageFactor1__c = Decimal.valueOf(data.NCT_Tree_Bush_Vine_Damager_Factor_I__c);
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Damager_Factor_II__c)) {
				wli.PartialDamageFactor2__c = Decimal.valueOf(data.NCT_Tree_Bush_Vine_Damager_Factor_II__c);
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Damager_Factor_III__c)) {
				wli.PartialDamageFactor3__c = Decimal.valueOf(data.NCT_Tree_Bush_Vine_Damager_Factor_III__c);
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Price_I__c)) {
				wli.Reference_Price1__c = data.NCT_Tree_Bush_Vine_Price_I__c;
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Price_II__c)) {
				wli.Reference_Price2__c = data.NCT_Tree_Bush_Vine_Price_II__c;
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Price_III__c)) {
				wli.Reference_Price3__c = data.NCT_Tree_Bush_Vine_Price_III__c;
			}


		} else if (data.RecordType.Name == 'RMA Data') {
			if (!isNull(data.RMA_Type_Code__c)) {
				wli.CropType__c = data.RMA_Type_Code__c;
			}
			if (!isNull(data.NAP_Share__c)) {
				wli.Share__c = data.RMA_Insured_Share_Percent__c;
			}
			if (!isNull(data.RMA_Location_State_Code__c)) {
				wli.PhysicalStateNameCode__c = data.RMA_Location_State_Code__c;
			}
			if (!isNull(data.RMA_Location_County_Code__c)) {
				wli.PhysicalCountyNameCode__c = data.RMA_Location_County_Code__c;
			}
			
		} else if (data.RecordType.Name == 'ACR Data') {
			if (!isNull(data.ACR_Crop_Type_Code__c)) {
				wli.CropType__c = data.ACR_Crop_Type_Code__c;
			}
			if (!isNull(data.ACR_Share__c)) {
				wli.Share__c = Decimal.valueOf(data.ACR_Share__c);
			}
			if (!isNull(data.NCT_Pay_Type__c)) {
				wli.PayTypeCode__c = data.NCT_Pay_Type__c;
			}
			if (!isNull(data.NCT_Pay_Crop__c)) {
				wli.PayCropCode__c = data.NCT_Pay_Crop__c;
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Damager_Factor_I__c)) {
				wli.PartialDamageFactor1__c = Decimal.valueOf(data.NCT_Tree_Bush_Vine_Damager_Factor_I__c);
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Damager_Factor_II__c)) {
				wli.PartialDamageFactor2__c = Decimal.valueOf(data.NCT_Tree_Bush_Vine_Damager_Factor_II__c);
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Damager_Factor_III__c)) {
				wli.PartialDamageFactor3__c = Decimal.valueOf(data.NCT_Tree_Bush_Vine_Damager_Factor_III__c);
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Price_I__c)) {
				wli.Reference_Price1__c = data.NCT_Tree_Bush_Vine_Price_I__c;
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Price_II__c)) {
				wli.Reference_Price2__c = data.NCT_Tree_Bush_Vine_Price_II__c;
			}
			if (!isNull(data.NCT_Tree_Bush_Vine_Price_III__c)) {
				wli.Reference_Price3__c = data.NCT_Tree_Bush_Vine_Price_III__c;
			}
		}

		return wli;
	}

	private static boolean isNull(Object field) {
		return field == null;
	}

	@auraEnabled
	public static void saveWHIPLI(WHIPLossInformation__c loss) {
		upsert loss;
	}
}
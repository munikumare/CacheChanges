public with sharing class WHIPLIValueLossAuraService {
	private static final String WLI_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get('Value Loss').getRecordTypeId();

	@auraEnabled
	public static WHIPLossInformation__c getWLI(String dataId, String parentId) {
		WHIPLossInformation__c wli = (WHIPLossInformation__c)Schema.getGlobalDescribe().get('WHIPLossInformation__c').newSObject(WLI_RECORD_TYPE_ID, true);
		wli.WHIPNoticeOfLoss__c = parentId;
		wli.RecordTypeId = WLI_RECORD_TYPE_ID;

		NAP_RMA_NCT_ACR_Data__c data = [
			SELECT Id, RecordType.Name, NAP_Share__c, NAP_Coverage_Percentage__c, NAP_Pay_Crop_Type_Code__c, 
				   NAP_Pay_Crop_Code__c, RMA_Insured_Share_Percent__c, RMA_Coverage_Level_Percent__c, 
				   RMA_Coverage_Type_Code__c, RMA_Price_Election_Percent__c, RMA_Indemnity_Amount__c, 
				   RMA_Location_State_Code__c, RMA_Location_County_Code__c, NCT_Pay_Crop__c, NAP_Crop_Type_Code__c,
				   NCT_Pay_Type__c, ACR_Share__c, RMA_Type_Code__c, ACR_Crop_Type_Code__c

			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE Id = :dataId
		];

		if (data.RecordType.Name == 'NAP Data') {
			if (!isNull(data.NAP_Crop_Type_Code__c)) {
				wli.CropType__c = data.NAP_Crop_Type_Code__c;
			}
			if (!isNull(data.NAP_Share__c)) {
				wli.ShareVL__c = data.NAP_Share__c;
			}
			if (!isNull(data.NAP_Coverage_Percentage__c)) {
				wli.CoverageLevel__c = data.NAP_Coverage_Percentage__c;
			} else {
				wli.CoverageLevel__c = 50;
			}
			if (!isNull(data.NAP_Coverage_Percentage__c)) {
				wli.PriceElection__c = 100;
			} else {
				wli.PriceElection__c = 55;
			}
			if (!isNull(data.NAP_Pay_Crop_Type_Code__c)) {
				wli.PayTypeCode__c = data.NAP_Pay_Crop_Type_Code__c;
			}
			if (!isNull(data.NAP_Pay_Crop_Code__c)) {
				wli.PayCropCode__c = data.NAP_Pay_Crop_Code__c;
			}

		} else if (data.RecordType.Name == 'RMA Data') {
			if (!isNull(data.RMA_Type_Code__c)) {
				wli.CropType__c = data.RMA_Type_Code__c;
			}
			if (!isNull(data.NAP_Share__c)) {
				wli.ShareVL__c = data.RMA_Insured_Share_Percent__c;
			}
			if (!isNull(data.RMA_Coverage_Type_Code__c) && data.RMA_Coverage_Type_Code__c == 'A') {
				wli.CoverageLevel__c = data.RMA_Coverage_Level_Percent__c;
			} 
			if (!isNull(data.RMA_Price_Election_Percent__c)) {
				wli.PriceElection__c = data.RMA_Price_Election_Percent__c;
			} 
			if (!isNull(data.RMA_Indemnity_Amount__c)) {
				wli.Indemnity_Or_NAP_Payment__c = data.RMA_Indemnity_Amount__c;
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
				wli.ShareVL__c = Decimal.valueOf(data.ACR_Share__c);
			}
			if (!isNull(data.NCT_Pay_Type__c)) {
				wli.PayTypeCode__c = data.NCT_Pay_Type__c;
			}
			if (!isNull(data.NCT_Pay_Crop__c)) {
				wli.PayCropCode__c = data.NCT_Pay_Crop__c;
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
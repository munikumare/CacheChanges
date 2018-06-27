public with sharing class WHIPLIProductionLossAuraService {
	private static final String WLI_RECORD_TYPE_ID = Schema.SObjectType.WHIPLossInformation__c.getRecordTypeInfosByName().get('Production Loss').getRecordTypeId();

	@auraEnabled
	public static WHIPLossInformation__c getWLI(String dataId, String parentId) {
		WHIPLossInformation__c wli = (WHIPLossInformation__c)Schema.getGlobalDescribe().get('WHIPLossInformation__c').newSObject(WLI_RECORD_TYPE_ID, true);
		system.debug(parentId);
        WHIPNoticeOfLoss__c whipNol = [
			SELECT Id, WHIP_Application__r.WHIP_Admin_County_Name_Lookup__r.FSA_BTO_State_Physical__c
			FROM WHIPNoticeOfLoss__c
			WHERE Id = :parentId
		];
		wli.WHIPNoticeOfLoss__c = parentId;
		wli.RecordTypeId = WLI_RECORD_TYPE_ID;

		NAP_RMA_NCT_ACR_Data__c data = [
			SELECT Id, RecordType.Name, NAP_Crop_Type_Code__c, NAP_Crushing_District__c, NAP_Organic_Type_Code__c,
					NAP_Native_Sod_Indicator__c, NAP_Share__c, NAP_Stage_Code__c, NAP_Unit_Number__c, NCT_Market_Price__c,
					NAP_Pay_Crop_Code__c, NAP_Pay_Crop_Type_Code__c, NAP_Production_To_Count__c, NAP_Assigned_Or_Adjusted_Production__c,
					NAP_Yield__c, NCT_Organic_Market_Price__c, RMA_Stage_Code__c, RMA_Approved_Yield__c, RMA_Coverage_Level_Percent__c,
					RMA_Price_Election_Percent__c, RMA_Location_County_Code__c, RMA_Organic_Practice_Code__c, RMA_Type_Code__c, RMA_Share__c,
					RMA_Location_State_Code__c, RMA_Production_To_Count_Quantity__c, RMA_Indemnity_Amount__c, ACR_Crop_Type_Code__c,
					ACR_Native_Sod_Indicator__c, ACR_Organic_Status_Code__c, ACR_Share__c, NCT_Whip_Pay_Crop__c, NCT_Whip_Pay_Type__c,
					NCT_Calculated_Yield__c,NCT_Organic_Certified_Factor__c,NCT_Organic_Transitional_Factor__c, NAP_Coverage_Percentage__c
			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE Id = :dataId
		];

		if (data.RecordType.Name == 'NAP Data') {
			if (!isNull(data.NAP_Crop_Type_Code__c)) {
				wli.CropType__c = data.NAP_Crop_Type_Code__c;
			}
			if (!isNull(data.NAP_Crushing_District__c)) {
				wli.CrushingDistrict__c = data.NAP_Crushing_District__c;
			}
			if (!isNull(data.NAP_Organic_Type_Code__c)) {
				wli.OrganicStatus__c = data.NAP_Organic_Type_Code__c;
			}
			if (!isNull(data.NAP_Native_Sod_Indicator__c)) {
				wli.NativeSod__c = data.NAP_Native_Sod_Indicator__c;
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
			if (!isNull(data.NAP_Share__c)) {
				wli.Share__c = data.NAP_Share__c;
			}
			if (!isNull(data.NAP_Stage_Code__c)) {
				wli.Stage__c = data.NAP_Stage_Code__c;
			}
			if (!isNull(data.NAP_Unit_Number__c)) {
				wli.Unit__c = data.NAP_Unit_Number__c;
			}
			if (!isNull(data.NAP_Production_To_Count__c)) {
				wli.ProductiontoCount__c = data.NAP_Production_To_Count__c;
			}
			if (!isNull(data.NAP_Assigned_Or_Adjusted_Production__c)) {
				wli.AssignedAdjustedProduction__c = data.NAP_Assigned_Or_Adjusted_Production__c;
			}
			if(whipNol.WHIP_Application__r.WHIP_Admin_County_Name_Lookup__r.FSA_BTO_State_Physical__c == 'PR'){
				if(!isNull(data.NCT_Calculated_Yield__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c;
				}
			} else {
				if(!isNull(data.NCT_Calculated_Yield__c)){
					wli.Yield__c = data.NAP_Yield__c;
				}
			}
			if (data.NAP_Organic_Type_Code__c == null || data.NAP_Organic_Type_Code__c == 'C' ||
					data.NAP_Organic_Type_Code__c == 'T') {
				if (!isNull(data.NCT_Market_Price__c)) {
					wli.Price__c = data.NCT_Market_Price__c;
				}
			} else if (data.NAP_Organic_Type_Code__c != null && data.NAP_Organic_Type_Code__c == 'O') {
				if (!isNull(data.NCT_Organic_Market_Price__c)) {
					wli.Price__c = data.NCT_Organic_Market_Price__c;
				}

			}
			if (!isNull(data.NAP_Pay_Crop_Code__c)) {
				wli.PayCropCode__c = data.NAP_Pay_Crop_Code__c;
			}
			if (!isNull(data.NAP_Pay_Crop_Type_Code__c)) {
				wli.PayTypeCode__c = data.NAP_Pay_Crop_Type_Code__c;
			}
		} else if (data.RecordType.Name == 'RMA Data') {
			if (!isNull(data.RMA_Type_Code__c)) {
				wli.CropType__c = data.RMA_Type_Code__c;
			}
			if (!isNull(data.RMA_Organic_Practice_Code__c)) {
				wli.OrganicStatus__c = data.RMA_Organic_Practice_Code__c;
			}
			if (!isNull(data.RMA_Share__c)) {
				wli.Share__c = data.RMA_Share__c;
			}
			if (!isNull(data.RMA_Stage_Code__c)) {
				wli.Stage__c = data.RMA_Stage_Code__c;
			}
			wli.ProductiontoCount__c = Decimal.valueOf(data.RMA_Production_To_Count_Quantity__c);
			if (!isNull(data.RMA_Indemnity_Amount__c)) {
				wli.IndemnityPL__c = data.RMA_Indemnity_Amount__c;
			}
			if (!isNull(data.RMA_Approved_Yield__c)) {
				wli.Yield__c = Decimal.valueOf(data.RMA_Approved_Yield__c);
			}
			if (data.RMA_Coverage_Type_Code__c == 'A') {
				if (!isNull(data.RMA_Coverage_Level_Percent__c)) {
					wli.CoverageLevel__c = data.RMA_Coverage_Level_Percent__c;
				}
			}
			if (!isNull(data.RMA_Price_Election_Percent__c)) {
				wli.PriceElection__c = data.RMA_Price_Election_Percent__c;
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
			if (!isNull(data.ACR_Organic_Status_Code__c)) {
				wli.OrganicStatus__c = data.ACR_Organic_Status_Code__c;
			}
			if (!isNull(data.ACR_Native_Sod_Indicator__c)) {
				wli.NativeSod__c = data.ACR_Native_Sod_Indicator__c ? 'True' : 'False';
			}
			if (!isNull(data.ACR_Share__c)) {
				wli.SharePL__c = Decimal.valueOf(data.ACR_Share__c);
			}
			if (data.NAP_Organic_Type_Code__c == null || data.NAP_Organic_Type_Code__c == 'C' ||
					data.NAP_Organic_Type_Code__c == 'T') {
				if (!isNull(data.NCT_Market_Price__c)) {
					wli.Price__c = data.NCT_Market_Price__c;
				}

			} else if (data.NAP_Organic_Type_Code__c != null && data.NAP_Organic_Type_Code__c == 'O') {
				if (!isNull(data.NCT_Organic_Market_Price__c)) {
					wli.Price__c = data.NCT_Organic_Market_Price__c;
				}

			}
			if (!isNull(data.NCT_Whip_Pay_Crop__c)) {
				wli.PayCropCode__c = data.NCT_Whip_Pay_Crop__c;
			}
			if (!isNull(data.NCT_Whip_Pay_Type__c)) {
				wli.PayTypeCode__c = data.NCT_Whip_Pay_Type__c;
			}
			if(whipNol.WHIP_Application__r.WHIP_Admin_County_Name_Lookup__r.FSA_BTO_State_Physical__c == 'PR'){
				if(!isNull(data.NCT_Calculated_Yield__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c;
				}
			}
			if(data.ACR_Native_Sod_Indicator__c == false && data.ACR_Organic_Status_Code__c == 'C'){
				if(!isNull(data.NCT_Calculated_Yield__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c;
				}
			}
			if(data.ACR_Native_Sod_Indicator__c == false && data.ACR_Organic_Status_Code__c == 'O'){
				if(!isNull(data.NCT_Calculated_Yield__c) && !isNull(data.NCT_Organic_Certified_Factor__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c * data.NCT_Organic_Certified_Factor__c;
				}
			}
			if(data.ACR_Native_Sod_Indicator__c == false && data.ACR_Organic_Status_Code__c == 'T'){
				if(!isNull(data.NCT_Calculated_Yield__c) && !isNull(data.NCT_Organic_Transitional_Factor__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c * data.NCT_Organic_Transitional_Factor__c;
				}
			}
			if(data.ACR_Native_Sod_Indicator__c == true && data.ACR_Organic_Status_Code__c == 'C'){
				if(!isNull(data.NCT_Calculated_Yield__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c * 0.65;
				}
			}
			if(data.ACR_Native_Sod_Indicator__c == true && data.ACR_Organic_Status_Code__c == 'O'){
				if(!isNull(data.NCT_Calculated_Yield__c) && !isNull(data.NCT_Organic_Certified_Factor__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c * data.NCT_Organic_Certified_Factor__c * 0.65;
				}
			}
			if(data.ACR_Native_Sod_Indicator__c == true && data.ACR_Organic_Status_Code__c == 'T'){
				if(!isNull(data.NCT_Calculated_Yield__c) && !isNull(data.NCT_Organic_Transitional_Factor__c)){
					wli.Yield__c = data.NCT_Calculated_Yield__c * data.NCT_Organic_Transitional_Factor__c * 0.65;
				}
			}

		}


		System.debug(wli);

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
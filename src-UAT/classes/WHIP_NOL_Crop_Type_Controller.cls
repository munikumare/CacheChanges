public with sharing class WHIP_NOL_Crop_Type_Controller {
	private static final String WHIP_NOL_UNLOCK_RECORD_TYPE_ID = Schema.SObjectType.WHIPNoticeofLoss__c.getRecordTypeInfosByName().get('WHIP NOL Unlocked').getRecordTypeId();
	private static NAP_RMA_NCT_ACR_DataAccessor napRmaNctAcrDataAccessor = new NAP_RMA_NCT_ACR_DataAccessor();

	@auraEnabled
	public static List<Row> getWhipNolCropTypes(Id whipAppId, Id selectedCropId){
		WHIP_Application__c whipApp = getWhipAppById(whipAppId);
		NAP_RMA_NCT_ACR_Data__c selectedAcrData = napRmaNctAcrDataAccessor.getDataById(selectedCropId);
		Boolean isRMADataTurnedOff = isRMADataTurnedOff();
		List<NAP_RMA_NCT_ACR_Data__c> records;
        system.debug(isRMADataTurnedOff);
		if(isRMADataTurnedOff) {
			records = napRmaNctAcrDataAccessor.getAllRecordsByCoreCustomerIdAndAcrType(whipApp.Individual__r.FSA_BTO_Core_Customer_ID__c, selectedAcrData.ACR_Crop_Type_Code__c);
		} else {
			Set<String> rmaCommodityCodes = getRmaCommodityCodesByFSACrop(selectedAcrData.ACR_Crop_Code__c);
			Set<String> rmaTypeCodes = getRmaTypeCodesByCommodityCodes(rmaCommodityCodes);
			records = napRmaNctAcrDataAccessor.getAllRecordsByCoreCustomerIdAndAcrTypeAndRmaTypeCodes(whipApp.Individual__r.FSA_BTO_Core_Customer_ID__c, selectedAcrData.ACR_Crop_Code__c, rmaTypeCodes);
        }
		return initTableRows(records);
	}
	private static WHIP_Application__c getWhipAppById(Id recordId){
		return [
				SELECT Individual__r.FSA_BTO_Core_Customer_ID__c
				FROM WHIP_Application__c
				WHERE Id = :recordId
		];
	}
	private static Boolean isRMADataTurnedOff(){
		Map<String,WHIP_Settings__c> whipSettings = WHIP_Settings__c.getAll();
		if(whipSettings.isEmpty())
			return true;
		else
				return whipSettings.values()[0].Turn_Off_RMA_Data__c;
	}
	private static Set<String> getRmaCommodityCodesByFSACrop(String acrCropCode){
		List<WHIP_FSA_RMA_Crop_Mapping__c> cropMappingRecords = [
				SELECT RMA_Commodity_Code__c
				FROM WHIP_FSA_RMA_Crop_Mapping__c
				WHERE FSA_Crop__c = :acrCropCode
		];
		Set<String> rmaCommodityCodes = new Set<String>();
		for(WHIP_FSA_RMA_Crop_Mapping__c record : cropMappingRecords){
			if(!rmaCommodityCodes.contains(record.RMA_Commodity_Code__c))
				rmaCommodityCodes.add(record.RMA_Commodity_Code__c);
		}
		return rmaCommodityCodes;
	}
	private static Set<String> getRmaTypeCodesByCommodityCodes(Set<String> rmaCommodityCodes){
		List<WHIP_RMA_Commodity_Code_Mapping__c> commodityMappingRecords = [
				SELECT Type_Code__c
				FROM WHIP_RMA_Commodity_Code_Mapping__c
				WHERE RMA_Commodity_Code__c IN :rmaCommodityCodes
		];
		Set<String> rmaTypeCodes = new Set<String>();
		for(WHIP_RMA_Commodity_Code_Mapping__c record : commodityMappingRecords){
			if(!rmaTypeCodes.contains(record.Type_Code__c))
				rmaTypeCodes.add(record.Type_Code__c);
		}
		return rmaTypeCodes;
	}
	private static List<Row> initTableRows(List<NAP_RMA_NCT_ACR_Data__c> records){
		List<Row> rows = new List<Row>();
		for(NAP_RMA_NCT_ACR_Data__c record : records){
			Row r = new Row();
			r.Id = record.Id;
			r.CoverageType = record.RecordType.Name;
			if(record.RecordType.Name == napRmaNctAcrDataAccessor.NAP_DATA){
				r.CropType = record.NAP_Crop_Type_Code__c;
				r.IntendedUse = record.NAP_Intended_Use_Code__c;
				r.Practice = record.NAP_Irrigation_Practice_Code__c;
				r.PlantingPeriod = record.NAP_Planting_Period_Code__c;
                r.Year=record.NAP_Program_Year__c;
                
			} else if(record.RecordType.Name == napRmaNctAcrDataAccessor.RMA_DATA){
				r.CropType = record.RMA_Type_Code__c;
				r.IntendedUse = record.RMA_Intended_Use_Code__c;
				r.Practice = record.RMA_Practice_Code__c;
				r.PlantingPeriod = record.RMA_Planting_Period_Code__c;
                
                r.Year=record.RMA_Program_Year__c;

			} else if(record.RecordType.Name == napRmaNctAcrDataAccessor.ACR_DATA){
				r.CropType = record.ACR_Crop_Type_Code__c;
				r.IntendedUse = record.ACR_Crop_Intended_Use__c;
				r.Practice = record.ACR_Irrigation_Practice_Code__c;
				r.PlantingPeriod = record.ACR_Planting_Period_Code__c;
                r.Year=record.ACR_Program_Year__c;
				system.debug('acr program year is:'+r.Year);   
			}
			rows.add(r);
		}
		return rows;
	}
	public class Row {
		@auraEnabled
		public String Id { get; set; }
		@auraEnabled
		public String CropType { get; set; }
		@auraEnabled
		public String CoverageType { get; set; }
		@auraEnabled
		public String IntendedUse { get; set; }
		@auraEnabled
		public String Practice { get; set; }
		@auraEnabled
		public String PlantingPeriod { get; set; }
         @auraEnabled
        public Decimal Year{get;set;}
	}
}
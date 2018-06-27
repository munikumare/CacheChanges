public with sharing class WHIPPDFController {

	public List<WHIPWrapper> ACRWrapperList2017 {get; set;}
	public List<WHIPWrapper> GZGMLSCropList2017 {get; set;}
	public List<WHIPWrapper> NAPWrapperList2017 {get; set;}
	public List<WHIPWrapper> RMAWrapperList2017 {get; set;}
	public List<WHIPWrapper> ACRWrapperList2018 {get; set;}
	public List<WHIPWrapper> GZGMLSCropList2018 {get; set;}
	public List<WHIPWrapper> NAPWrapperList2018 {get; set;}
	public List<WHIPWrapper> RMAWrapperList2018 {get; set;}

	public String ProducerName {get; set;}
	public String PreparedDate {get; set;}
	public String StateField {get; set;}
	public String CountyField {get; set;}

	private final Set<String> EXCLUDED_CROP_CODES = new Set<String>{'97','99','3025','98','101','773','772','1250','837','105','1218','378','2015','2011','2017','715','790','7506','7320','776','93','9011','2006','777','2007','7508','2016','8888'};
	private final Set<String> EXCLUDED_COMMODITY_CODES = new Set<String>{'32'};
	private final Set<String> EXCLUDED_INSURANCE_PLANS = new Set<String>{'16','17','81','82'};
	private final String RMA_RECORD_TYPE = 'RMA Data';
	private final String ACR_RECORD_TYPE = 'ACR Data';
	private final String NAP_RECORD_TYPE = 'NAP Data';

	public WHIPPDFController() {
		String applicationId = ApexPages.currentPage().getParameters().get('id');
		PreparedDate = Date.today().format();

		WHIP_Application__c application = [SELECT Related_Interaction__c, AdminStateName__c,AdminStateCode__c, AdminCountyName__c,AdminCountyCode__c FROM WHIP_Application__c WHERE Id =: applicationId];

		Case customerInteraction = [SELECT ContactId FROM Case WHERE Id = :application.Related_Interaction__c];
		Contact customer = [SELECT Name, FSA_BTO_Core_Customer_ID__c FROM Contact WHERE Id = :customerInteraction.ContactId];
		
		ProducerName = customer.Name;
		StateField = application.AdminStateName__c + '/' + application.AdminStateCode__c;
		CountyField = application.AdminCountyName__c + '/' + application.AdminCountyCode__c;

		List<NAP_RMA_NCT_ACR_Data__c> dataList = getData(customer.FSA_BTO_Core_Customer_ID__c);

		ACRWrapperList2017 = new List<WHIPWrapper>();
		GZGMLSCropList2017 = new List<WHIPWrapper>();
		NAPWrapperList2017 = new List<WHIPWrapper>();
		RMAWrapperList2017 = new List<WHIPWrapper>();

		ACRWrapperList2018 = new List<WHIPWrapper>();
		GZGMLSCropList2018 = new List<WHIPWrapper>();
		NAPWrapperList2018 = new List<WHIPWrapper>();
		RMAWrapperList2018 = new List<WHIPWrapper>();

		for (NAP_RMA_NCT_ACR_Data__c data : dataList) {
			if (data.RecordType.Name == ACR_RECORD_TYPE) {
				if (!EXCLUDED_CROP_CODES.contains(data.ACR_Crop_Type_Code__c)) {
					if (data.ACR_Program_Year__c == 2017) {
						if(isGZGMLSCrop(data)){
							GZGMLSCropList2017.add(new WHIPWrapper(data));
						} else {
							ACRWrapperList2017.add(new WHIPWrapper(data));
						}
					} else if (data.ACR_Program_Year__c == 2018) {
						if(isGZGMLSCrop(data)){
							GZGMLSCropList2018.add(new WHIPWrapper(data));
						} else {
							ACRWrapperList2018.add(new WHIPWrapper(data));
						}
					}
				}
			} else if (data.RecordType.Name == NAP_RECORD_TYPE) {
				if (data.NAP_Program_Year__c == 2017) {
					NAPWrapperList2017.add(new WHIPWrapper(data));
				} else if (data.NAP_Program_Year__c == 2018) {
					NAPWrapperList2018.add(new WHIPWrapper(data));
				}
			} else if (data.RecordType.Name == RMA_RECORD_TYPE) {
				if (data.RMA_Program_Year__c == 2017) {
					if (!EXCLUDED_COMMODITY_CODES.contains(data.RMA_Commodity_Code__c) &&
						!EXCLUDED_INSURANCE_PLANS.contains(data.RMA_Insurance_Plan_Code__c)) {
						RMAWrapperList2017.add(new WHIPWrapper(data));
					}
				} else if (data.RMA_Program_Year__c == 2018) {
					if (!EXCLUDED_COMMODITY_CODES.contains(data.RMA_Commodity_Code__c) &&
						!EXCLUDED_INSURANCE_PLANS.contains(data.RMA_Insurance_Plan_Code__c)) {
						RMAWrapperList2018.add(new WHIPWrapper(data));
					}
				}
			}
		}
	}
	private Boolean isGZGMLSCrop(NAP_RMA_NCT_ACR_Data__c data){
		return data.ACR_Crop_Intended_Use_Code__c != null &&
				(data.ACR_Crop_Intended_Use_Code__c.trim() == 'GZ' || data.ACR_Crop_Intended_Use_Code__c.trim() == 'GM' || data.ACR_Crop_Intended_Use_Code__c.trim() == 'LS CROPS');
	}
	private List<WHIP_Application__c> getApplications() {
		return [
			SELECT Id
			FROM WHIP_Application__c
		];
	}

	private List<NAP_RMA_NCT_ACR_Data__c> getData(String ccid) {
		return [
			SELECT Id, RecordType.Name,  County_Code__c, State_Code__c, ACR_Crop_Name__c, ACR_Crop_Type_Code__c, 
				   ACR_Crop_Intended_Use_Code__c, ACR_Status__c, ACR_Irrigation_Practice_Code__c, ACR_Reported_Acres__c, 
				   ACR_Determined_Acres__c, ACR_Share__c, ACR_Plant_Date__c, ACR_Native_Sod_Indicator__c, 
				   ACR_Planting_Period_Code__c, ACR_Organic_Status_Code__c, ACR_NAP_Unit_Number__c, ACR_Farm_Number__c, 
				   ACR_Tract_Number__c, ACR_FIELD__c, ACR_CERTIFIED__c, NAP_Crop_Type_Code__c, NAP_Intended_Use_Code__c, 
				   NAP_Planting_Period_Code__c, NAP_Price_Election__c, NAP_Coverage_Percentage__c, NAP_DIRCT_MKT__c, 
				   NAP_Practice__c, NAP_Approved_Yield__c, NAP_Crop_Code__c, NAP_Disaster_Beginning_Date__c, 
				   NAP_Disaster_Ending_Date__c, NAP_Disaster_Apparent_Date__c, NAP_Approval_Date__c, NAP_Disapproval_Date__c, 
				   NAP_Disaster_Spelled_Out__c, NAP_Organic_Type_Code__c, NAP_Native_Sod_Indicator__c, NAP_Unit_Number__c, 
				   NAP_Share__c, NAP_Crushing_District__c, NAP_Stage_Code__c, NAP_Production_To_Count__c, ACR_Crop_Intended_Use__c,
				   NAP_Actual_Production_for_FH_PR__c, NAP_Unit_Of_Measure_Code__c, RMA_Approved_Yield__c, 
				   NAP_Historical_Marketing_Percentage__c, NAP_Direct_Marketing_Percentage__c, NAP_Yield_Adjustment__c, 
				   RMA_Crop__c, NAP_COC_Salvage_Value_Yield_Tab__c, NAP_Assigned_Or_Adjusted_Production__c,
				   NAP_Type_of_COC_Adjustment__c, RMA_Price__c, NAP_Inventory_Dollar_Val_Before_Disaster__c, 
				   NAP_Inventory_Dollar_Val_After_Disaster__c, NAP_Graduated_Price_Code__c, NAP_Graduated_Price__c, 
				   NAP_COC_Inel_Inv_or_Dollar_Value__c, NAP_COC_Salvage_Value_Crop_Tab__c, RMA_Commodity_Code__c,
				   RMA_Crush_District_Number__c, RMA_Practice_Name__c, RMA_Insurance_Plan_Code__c, RMA_Insured_Share_Percent__c, 
				   RMA_Unit_Structure_Code__c, RMA_Unit_Division_Code__c, RMA_Coverage_Type_Code__c, RMA_Coverage_Level_Percent__c, 
				   RMA_Price_Election_Percent__c, RMA_Coverage_Range__c, RMA_Reported_Acreage__c, RMA_Reported_Colonies__c, 
				   RMA_Reported_Pounds__c, RMA_Reported_Tons__c, RMA_Total_Insured_Acreage_PRF_only__c, RMA_Non_Premium_Acreage_Code__c, 
				   RMA_Guarantee_Adjustment_Type_Code__c, RMA_Guarantee_Adjustment_Factor__c, RMA_Grid_ID__c, NAP_Determined_Salvage_Amount__c,
				   RMA_Insurance_Option_Code_List__c, RMA_Option_Code_Factor__c, RMA_Planted_Date__c, RMA_Range_Class_Code__c, 
				   RMA_Reported_Tree_Count__c, RMA_Update_Date__c, RMA_Location_State_Code__c, RMA_Location_County_Code__c, 
				   RMA_Farm_Number__c, RMA_FSA_Tract_Number__c, RMA_FSA_Field_Number__c, RMA_FSA_Sub_Field_Identifier__c, RMA_Stage_Code__c, 
				   RMA_Stage_Percent_Factor__c, RMA_Unit_of_Measure_from_ADM__c, RMA_Determined_Acreage__c, RMA_Determined_Colonies__c, 
				   RMA_Determined_Pounds__c, RMA_Determined_Tons__c, RMA_NAME__c, RMA_Production_To_Count_Quantity__c, 
				   RMA_Indemnity_Amount__c, RMA_Gleaned_Acreage_Code__c, RMA_Loss_Multiple_Cropping_Code__c, RMA_Field_Market_Value_A__c, 
				   RMA_Field_Market_Value_B__c, RMA_First_Damage_Cause_Code__c, RMA_First_Damage_Date__c, RMA_Second_Damage_Cause_Code__c, 
				   RMA_Second_Damage_Date__c, RMA_Third_Damage_Cause_Code__c, RMA_Third_Damage_Date__c, RMA_Determined_Tree_Count__c, 
				   RMA_Type_Name__c, RMA_SY_PRODUCTION__c, RMA_Yield_Acreage__c, RMA_Individual_or_Business_Name__c, RMA_Skip_Row_Code__c, 
				   RMA_AIP_Code__c, RMA_Ineligible_SBI_Flag__c, RMA_Ineligible_SBI_Share_Percent__c, RMA_Intended_Use_Code__c, 
				   NAP_Reported_Salvage_Amount__c, NAP_Uncounted_Quantity__c, NAP_Quantity__c, NAP_Irrigation_Practice_Code__c, ACR_Program_Year__c,
				   NAP_Program_Year__c, RMA_Program_Year__c
			FROM NAP_RMA_NCT_ACR_Data__c
			WHERE CCID__c = :ccid			
			ORDER BY ACR_Crop_Name__c, RMA_Crop__c, NAP_Crop_Code__c, ACR_Program_Year__c, NAP_Program_Year__c DESC

		];
	}

//	public class WHIPWrapper {
//		private final String RMA_RECORD_TYPE = 'RMA Data';
//		private final String ACR_RECORD_TYPE = 'ACR Data';
//		private final String NAP_RECORD_TYPE = 'NAP Data';
//		private final String UNAVAILABLE_MESSAGE = 'No Information on File';
//
//		public String Acres {get; set;}
//		public String Location {get; set;}
//		public String Crop {get; set;}
//		public String Type {get; set;}
//		public String IntendedUse {get; set;}
//		public String Status {get; set;}
//		public String Practice {get; set;}
//		public String ReportedAcres {get; set;}
//		public String DeterminedAcres {get; set;}
//		public String Share {get; set;}
//		public String Stage {get; set;}
//		public String Salvage {get; set;}
//		public String PlantingDate {get; set;}
//		public String NativeSod {get; set;}
//		public String Production {get; set;}
//		public String AdjustmentProduction {get; set;}
//		public String PlantingPeriod {get; set;}
//		public String OrganicOption {get; set;}
//		public String OrganicStatus {get; set;}
//		public String OrganicCode {get; set;}
//		public String ApprovedYield {get; set;}
//		public String AdjustmentPercent {get; set;}
//		public String AdjustmentYield {get; set;}
//		public String UnitOfMeasure {get; set;}
//		public String CrushingDistrict {get; set;}
//		public String Unit {get; set;}
//		public String CoverageLevel {get; set;}
//		public String Farm {get; set;}
//		public String Tract {get; set;}
//		public String Field {get; set;}
//		public String CertificationDate {get; set;}
//		public String DirectMarket {get; set;}
//		public String PriceElection {get; set;}
//		public String DisasterBegin {get; set;}
//		public String DisasterEnd {get; set;}
//		public String DisasterApparent {get; set;}
//		public String Approval {get; set;}
//		public String Disapproval {get; set;}
//		public String DisasterEvent {get; set;}
//		public String ActualProduction {get; set;}
//		public String HistoricalMarketing {get; set;}
//		public String DirectMarketPercent {get; set;}
//		public String SalvageValueYeild {get; set;}
//		public String COCAdjustment {get; set;}
//		public String DollarValueBeforeDisaster {get; set;}
//		public String DollarValueAfterDisaster {get; set;}
//		public String GraduatedPriceCode {get; set;}
//		public String GraduatedPrice {get; set;}
//		public String COCDollarValue {get; set;}
//		public String SalvageValueCrop {get; set;}
//		public String Payment {get; set;}
//		public String UpdateDate {get; set;}
//		public String SYProduction {get; set;}
//		public String Plan {get; set;}
//		public String StructureCode {get; set;}
//		public String DivisionCode {get; set;}
//		public String CoverageType {get; set;}
//		public String CoverageRange {get; set;}
//		public String TotalInsuredAcreage {get; set;}
//		public String ZeroAcres {get; set;}
//		public String Price {get; set;}
//		public String Yield	{get; set;}
//		public String GuaranteeAdjustmentType {get; set;}
//		public String GuaranteeAdjustmentFactor {get; set;}
//		public String GridId {get; set;}
//		public String OptionCodeList {get; set;}
//		public String OptionCodeFactor {get; set;}
//		public String RangeClass {get; set;}
//		public String LocationStateCode {get; set;}
//		public String LocationCountyCode {get; set;}
//		public String StagePercentFactor {get; set;}
//		public String ProductionToCount {get; set;}
//		public String Indemnity	{get; set;}
//		public String GleanedAcreage {get; set;}
//		public String MultipleCropping {get; set;}
//		public String FieldMarketValueA {get; set;}
//		public String FieldMarketValueB {get; set;}
//		public String FirstDamageCause {get; set;}
//		public String FirstDamageDate {get; set;}
//		public String SecondDamageCause {get; set;}
//		public String SecondDamageDate {get; set;}
//		public String ThirdDamageCause {get; set;}
//		public String ThirdDamageDate {get; set;}
//		public String TreeCount {get; set;}
//		public String SkipRoad {get; set;}
//		public String AIPCode {get; set;}
//		public String Name {get; set;}
//		public String Flag {get; set;}
//		public String IneligibleSBIFlag {get; set;}
//		public String IneligibleSBIShare {get; set;}
//
//
//
//		public WHIPWrapper(NAP_RMA_NCT_ACR_Data__c data) {
//			if (data.RecordType.Name == NAP_RECORD_TYPE) {
//				LocationStateCode = data.State_Code__c;
//				LocationCountyCode = data.County_Code__c;
//				Location = data.State_Code__c + '/' + data.County_Code__c;
//				Crop = data.NAP_Crop_Code__c;
//				Type = data.NAP_Crop_Type_Code__c;
//				IntendedUse = data.NAP_Intended_Use_Code__c;
//				PlantingPeriod = data.NAP_Planting_Period_Code__c;
//				Unit = data.NAP_Unit_Number__c;
//				OrganicOption = data.NAP_Organic_Type_Code__c;
//				if (data.NAP_Native_Sod_Indicator__c != null) {
//					NativeSod = 'Yes';
//				}
//				ApprovedYield = String.valueOf(data.NAP_Approved_Yield__c);
//				UnitOfMeasure = data.NAP_Unit_Of_Measure_Code__c;
//				Share = String.valueOf(data.NAP_Share__c);
//				CrushingDistrict = data.NAP_Crushing_District__c;
//				Stage = data.NAP_Stage_Code__c;
//
//				if (data.NAP_Quantity__c != null && data.NAP_Uncounted_Quantity__c != null) {
//					Production = String.valueOf(data.NAP_Quantity__c - data.NAP_Uncounted_Quantity__c);
//				}
//
//				AdjustmentProduction = String.valueOf(data.NAP_Assigned_Or_Adjusted_Production__c);
//				AdjustmentPercent = String.valueOf(data.NAP_Yield_Adjustment__c);
//
//				if (data.NAP_Determined_Salvage_Amount__c != null) {
//					Salvage = String.valueOf(data.NAP_Determined_Salvage_Amount__c);
//				} else {
//					Salvage = String.valueOf(data.NAP_Reported_Salvage_Amount__c);
//				}
//
//				if (data.NAP_Coverage_Percentage__c == null) {
//					PriceElection = '55';
//				} else  {
//					PriceElection = '100';
//				}
//
//				if (data.NAP_Coverage_Percentage__c == null) {
//					CoverageLevel = '50';
//				} else {
//					CoverageLevel = String.valueOf(data.NAP_Coverage_Percentage__c);
//				}
//
//				DirectMarket = data.NAP_DIRCT_MKT__c;
//				Practice = data.NAP_Irrigation_Practice_Code__c;
//				DisasterBegin = String.valueOf(data.NAP_Disaster_Beginning_Date__c);
//				DisasterEnd = String.valueOf(data.NAP_Disaster_Ending_Date__c);
//				DisasterApparent = String.valueOf(data.NAP_Disaster_Apparent_Date__c);
//				Approval = String.valueOf(data.NAP_Approval_Date__c);
//				Disapproval = String.valueOf(data.NAP_Disapproval_Date__c);
//				DisasterEvent = data.NAP_Disaster_Spelled_Out__c;
//				ActualProduction = data.NAP_Actual_Production_for_FH_PR__c;
//				HistoricalMarketing = String.valueOf(data.NAP_Historical_Marketing_Percentage__c);
//				DirectMarketPercent = String.valueOf(data.NAP_Direct_Marketing_Percentage__c);
//				SalvageValueYeild = String.valueOf(data.NAP_COC_Salvage_Value_Yield_Tab__c);
//				COCAdjustment = data.NAP_Type_of_COC_Adjustment__c;
//				DollarValueBeforeDisaster = String.valueOf(data.NAP_Inventory_Dollar_Val_Before_Disaster__c);
//				DollarValueAfterDisaster = String.valueOf(data.NAP_Inventory_Dollar_Val_After_Disaster__c);
//				GraduatedPriceCode = data.NAP_Graduated_Price_Code__c;
//				GraduatedPrice = String.valueOf(data.NAP_Graduated_Price__c);
//				COCDollarValue = String.valueOf(data.NAP_COC_Inel_Inv_or_Dollar_Value__c);
//				SalvageValueCrop = String.valueOf(data.NAP_COC_Salvage_Value_Crop_Tab__c);
//
//				if (data.NAP_Approved_Yield__c != null && data.NAP_Yield_Adjustment__c != null) {
//					AdjustmentYield = String.valueOf(data.NAP_Approved_Yield__c * data.NAP_Yield_Adjustment__c);
//				}
//
//			} else if (data.RecordType.Name == ACR_RECORD_TYPE) {
//				Crop = data.ACR_Crop_Name__c;
//				Type = data.ACR_Crop_Type_Code__c;
//				IntendedUse = data.ACR_Crop_Intended_Use_Code__c;
//				Status = data.ACR_Status__c;
//				Practice = data.ACR_Irrigation_Practice_Code__c;
//				ReportedAcres = String.valueOf(data.ACR_Reported_Acres__c);
//				DeterminedAcres = String.valueOf(data.ACR_Determined_Acres__c);
//				Share = data.ACR_Share__c;
//				if (data.ACR_Native_Sod_Indicator__c) {
//					NativeSod = 'Yes';
//				}
//				PlantingPeriod = data.ACR_Planting_Period_Code__c;
//				PlantingDate = String.valueOf(data.ACR_Plant_Date__c);
//				Farm = data.ACR_Farm_Number__c;
//				Tract = data.ACR_Tract_Number__c;
//				Field = data.ACR_FIELD__c;
//				CertificationDate = String.valueOf(data.ACR_CERTIFIED__c);
//				OrganicStatus = data.ACR_Organic_Status_Code__c;
//				Unit = data.ACR_NAP_Unit_Number__c;
//				LocationStateCode = data.State_Code__c;
//				LocationCountyCode = data.County_Code__c;
//				Location = data.State_Code__c + '/' + data.County_Code__c;
//
//			} else if (data.RecordType.Name == RMA_RECORD_TYPE) {
//				Crop = data.RMA_Crop__c;
//				CrushingDistrict = String.valueOf(data.RMA_Crush_District_Number__c);
//				Type = data.RMA_Type_Name__c;
//				Practice = data.RMA_Practice_Name__c;
//				Share = String.valueOf(data.RMA_Insured_Share_Percent__c);
//				Plan = data.RMA_Insurance_Plan_Code__c;
//				IntendedUse = data.RMA_Intended_Use_Code__c;
//				ReportedAcres = String.valueOf(data.RMA_Reported_Acreage__c);
//				DeterminedAcres = String.valueOf(data.RMA_Determined_Acreage__c);
//				UpdateDate = String.valueOf(data.RMA_Update_Date__c);
//				SYProduction = data.RMA_SY_PRODUCTION__c;
//				PriceElection = String.valueOf(data.RMA_Price_Election_Percent__c);
//				StructureCode = data.RMA_Unit_Structure_Code__c;
//				DivisionCode = data.RMA_Unit_Division_Code__c;
//				CoverageType = data.RMA_Coverage_Type_Code__c;
//				CoverageLevel = String.valueOf(data.RMA_Coverage_Level_Percent__c);
//				CoverageRange = data.RMA_Coverage_Range__c;
//
//				if (data.RMA_Commodity_Code__c == '1191') {
//					Acres = String.valueOf(data.RMA_Reported_Colonies__c);
//				} else if (data.RMA_Commodity_Code__c == '0115') {
//					Acres = String.valueOf(data.RMA_Reported_Pounds__c);
//				} else if (data.RMA_Commodity_Code__c == '0037') {
//					Acres = String.valueOf(data.RMA_Reported_Tons__c);
//				} else {
//					Acres = String.valueOf(data.RMA_Reported_Acreage__c);
//				}
//				TotalInsuredAcreage = String.valueOf(data.RMA_Total_Insured_Acreage_PRF_only__c);
//				ZeroAcres = data.RMA_Non_Premium_Acreage_Code__c;
//				Price = String.valueOf(data.RMA_Price__c);
//				ApprovedYield = data.RMA_Approved_Yield__c;
//				GuaranteeAdjustmentType = data.RMA_Guarantee_Adjustment_Type_Code__c;
//				GuaranteeAdjustmentFactor = data.RMA_Guarantee_Adjustment_Factor__c;
//				GridId = data.RMA_Grid_ID__c;
//				OptionCodeList = data.RMA_Insurance_Option_Code_List__c;
//				OptionCodeFactor = data.RMA_Option_Code_Factor__c;
//				PlantingDate = String.valueOf(data.RMA_Planted_Date__c);
//				RangeClass = data.RMA_Range_Class_Code__c;
//				TreeCount = data.RMA_Reported_Tree_Count__c;
//				Updatedate = String.valueOf(data.RMA_Update_Date__c);
//				if (data.RMA_Location_State_Code__c != null && data.RMA_Location_County_Code__c != null) {
//					LocationStateCode = data.RMA_Location_State_Code__c;
//					LocationCountyCode = data.RMA_Location_County_Code__c;
//					Location = data.RMA_Location_State_Code__c + '/' + data.RMA_Location_County_Code__c;
//				} else {
//					LocationStateCode = data.State_Code__c;
//					LocationCountyCode = data.County_Code__c;
//					Location = data.State_Code__c + '/' + data.County_Code__c;
//				}
//
//				Farm = data.RMA_Farm_Number__c;
//				Tract = data.RMA_FSA_Tract_Number__c;
//				Field = data.RMA_FSA_Field_Number__c;
//				Stage = data.RMA_Stage_Code__c;
//				StagePercentFactor = String.valueOf(data.RMA_Stage_Percent_Factor__c);
//				UnitOfMeasure = data.RMA_Unit_of_Measure_from_ADM__c;
//				ProductionToCount = data.RMA_Production_To_Count_Quantity__c;
//				Indemnity = String.valueOf(data.RMA_Indemnity_Amount__c);
//				GleanedAcreage = data.RMA_Gleaned_Acreage_Code__c;
//				MultipleCropping = data.RMA_Loss_Multiple_Cropping_Code__c;
//				FieldMarketValueA = String.valueOf(data.RMA_Field_Market_Value_A__c);
//				FieldMarketValueB = String.valueOf(data.RMA_Field_Market_Value_B__c);
//				FirstDamageCause = data.RMA_First_Damage_Cause_Code__c;
//				FirstDamageDate = String.valueOf(data.RMA_First_Damage_Date__c);
//				SecondDamageCause = data.RMA_Second_Damage_Cause_Code__c;
//				SecondDamageDate = String.valueOf(data.RMA_Second_Damage_Date__c);
//				ThirdDamageCause = data.RMA_Third_Damage_Cause_Code__c;
//				ThirdDamageDate = String.valueOf(data.RMA_Third_Damage_Date__c);
//				SkipRoad = data.RMA_Skip_Row_Code__c;
//				AIPCode = data.RMA_AIP_Code__c;
//				Name = data.RMA_NAME__c;
//				IneligibleSBIFlag = data.RMA_Ineligible_SBI_Flag__c;
//				IneligibleSBIShare = String.valueOf(data.RMA_Ineligible_SBI_Share_Percent__c);
//			}
//		}
//	}
}
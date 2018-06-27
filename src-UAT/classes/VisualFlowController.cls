public with sharing class VisualFlowController {
	@auraEnabled
	public static Conservation_Request__c getNewRequestObject(String recordTypeName){
		Id recordTypeId = Schema.SObjectType.Conservation_Request__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
		Conservation_Request__c request = (Conservation_Request__c)Schema.getGlobalDescribe().get('Conservation_Request__c').newSObject(recordTypeId, true);
		request.Sign_Application_Electronically__c = null;
		request.Status__c = 'Unsubmitted';
		request.Additional_Comments__c = '';
		request.Current_Stage__c = 'Locate_Area';
		request.FA_Application_Participation__c = 'Agricultural Management Assistance (AMA)';
		request.FA_Applying_As__c = 'Individual';
		request.FA_Certification_Of_Control__c = 'Deed or other evidence of land ownership';
		request.FA_Land_Enrollment__c = 'Crop Production';
		request.FA_Offered_Enrollment__c = 'Certified Organic by the National Organic Program (NOP)';
		request.FA_Has_Farm_Records_Established__c = null;
		request.FA_Is_Land_In_Other_Program__c = null;
		request.FA_Has_Appropriate_Documents__c = null;

		return request;
	}
	@auraEnabled
	public static Conservation_Request__c getExistingRequestObject(Id requestId){
		return [
			SELECT Id,Current_Stage__c, Financial_Programs__c, Received_Copy_Of_Appendix__c,Complete_Application_Online__c,Sign_Application_Electronically__c, FA_Application_Participation__c, FA_Applying_As__c, FA_Certification_Of_Control__c, FA_Crop_Type__c, FA_DUNS_Number__c, 
					FA_EQIP_Engaged_In_Production__c, FA_EQIP_Land_Irrigated__c, FA_Has_Appropriate_Documents__c, FA_Has_Farm_Records_Established__c, FA_Is_Land_In_Other_Program__c, FA_Land_Enrollment__c, FA_Land_Offered__c, FA_Livestock_Type__c, FA_Other_Program_Details__c, 
					FA_Participant_Name__c, //FA_Participant_Type__c, FA_Tax_Identification_Number__c, FA_Years_Of_Control_From__c, FA_Years_Of_Control_To__c, FA_Offered_Enrollment__c, FA_DUNS_Date__c, FA_Land_Control_Description__c,
					Add_New_Land_Use_TA__c,Additional_Comments__c,Answer_1_TA__c,Answer_2_TA__c,Answer_3_TA__c,Answer_4_TA__c,Answer_5_TA__c,Answer_6_TA__c,Classic_Gully_Erosion__c,Communication_Method__c,Compaction__c,Concentration_of_Salt_or_Other_Chemicals__c,
					Customer_Name__c,Drifted_Snow__c,Elevated_Water_Temperature__c,Emissions_of_Ozone_Precursors__c,Emissions_of_Particulate_Matter__c,Ephemeral_Gull_Erosion__c,Equipment_and_Facilities__c,Excess_Pathogens_Groundwater__c,Excess_Pathogens_Surface_Water__c,
					Excessive_Plant_Pest_Pressure__c,Excessive_Sediment_in_Surface_Water__c,Gases__c,Inefficient_Feed_and_Forage__c,Inefficient_Habitat_Continuity_Spa__c,Inefficient_Habitat_Cover_Shelter__c,Nutrients_in_Surface_Water__c,Objectionable_Odors__c,Organic_Matter_Depletion__c,
					Inefficient_Habitat_Food__c,Inefficient_Habitat_Water__c,Inefficient_Shelter__c,Inefficient_Structure_and_Composition__c,Inefficient_Water__c,Ineffiecient_Moisture_Management__c,Ineffiient_Use_of_Irrigation_Water__c,Is_this_land__c,Name,Nutrients_in_Groundwater__c,
					Other_Business_Objective__c,Other_Business_Objective_textbox__c,Other_Communication_Method__c,Pesticides_in_Groundwater__c,Pesticides_in_Surface_Water__c,Pollutants_transported_to_Groundwater__c,Pollutants_transported_to_Surface_Water__c,Practices_and_Field_Operations__c,
					Record_Successfully_Submitted__c,Runoff_Flooding_or_Ponding__c,Salts_in_Groundwater__c,Salts_in_Surface_Water__c,Seasonal_High_Water_Table__c,Seeps__c,Sheet_and_Rill_Erosion__c,Streambank_Shoreline_Water_Conveyance__c,Subsidence__c,Type_of_Request__c,
					Undesirable_Plant_Productivity_Health__c,Wildlife_Hazard_Excessive_Biomass__c,Wind_Erosion__c
			FROM Conservation_Request__c
			WHERE Id=:requestId
		];
	}
	@auraEnabled
	public static Conservation_Request__c upsertRequestObject(Conservation_Request__c request){
		upsert request;
		return request;
	}
	@auraEnabled
	public static void postToChatter(Id requestId, String recordTypeName){
		ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), requestId, ConnectApi.FeedElementType.FeedItem, 'A new '+recordTypeName+' Record was created.');
	}
	@AuraEnabled
	public static List<Conservation_Request__c> getFlows() {
		return [
			SELECT Id, Name
			FROM Conservation_Request__c
		];
	}
}
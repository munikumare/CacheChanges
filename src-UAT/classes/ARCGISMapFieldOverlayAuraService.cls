public with sharing class ARCGISMapFieldOverlayAuraService extends ARCGISMapOverlayExtension{
	private static final String OPERATOR_ROLE = 'Operator';
	private static final String OPERATOR_OWNER_ROLE = 'Operator-Owner';
	private static final String OWNER_ROLE = 'Owner';
	private static final String OTHER_PRODUCER_ROLE = 'Other Producer';
	private static final String OTHER_TENANT_ROLE = 'Other Tenant';

	@auraEnabled
	public static Data getData(Id fieldId, String contactId){
		system.debug(contactId);
		if(String.isEmpty(contactId)){
			 User u = [select id, contactId, IsPortalEnabled from User where id = : UserInfo.getUserId()];         
            if(u.IsPortalEnabled=true)
            {
                contactId=u.contactId;
            }
		}
		Data data = new Data();
			data.header = setHeaderValues(fieldId,'field');
			data.helpTexts = getHelpText();
			data.field = getFieldById(fieldId);
			return data;
	}
	private static Land__c getFieldById(Id fieldId){
		return [
			SELECT 	Id,Name, Field_Number__c,Parent_ID__r.Id,Parent_ID__r.Name,Parent_ID__r.Tract_Number__c,Parent_ID__r.Parent_ID__r.Id, Parent_ID__r.Parent_ID__r.Name,Parent_ID__r.Parent_ID__r.Farm_Number__c,
					CLU_Acreage__c,Congressional_District_Code__c,Cropland_Inidcator_3CM__c,
					CRP_Contract_Number__c,Conservation_Practice_Identifier__c,Crop_Contract_Expiry_Date__c
			FROM Land__c
			WHERE Id=:fieldId
			ORDER BY State_County_ANSI_Code__c, Field_Number__c
		];
	}

	public class Data {
		@auraEnabled
		public Land__c field;
		@auraEnabled
		public Help_Text__c helpTexts;
		@auraEnabled
		public Header header = new Header();
	}
}
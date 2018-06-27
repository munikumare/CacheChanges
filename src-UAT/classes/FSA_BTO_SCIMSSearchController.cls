global with sharing class FSA_BTO_SCIMSSearchController {
	public String uniqueIdentifier { get; set; }
	public String orgName { get; set; }
	public String orgHost { get; set; }
	public String stateFIPSCode { get; set; }
	public String countyFIPSCode { get; set; }
	public String searchURL { get; set; }
	public String returnURL { get; set; }
	public String endURL { get; set; }
	public String orgURL = System.URL.getSalesforceBaseUrl().getHost();
	public String fullOrgURL {
		get {
			return URL.getSalesforceBaseUrl().toExternalForm();
		}
		set;
	}
	@TestVisible private static final String NO_ACTIVE_SETTING_RECORD_ERROR = 'No SCIMS Setting record found. An active SCIMS Setting record is required for each environment.';

	public void init() {

		User u = [
			SELECT FederationIdentifier, Username, FSA_BTO_FIPS_Code__c
			FROM User
			WHERE Id = :UserInfo.getUserId()
			LIMIT 1
		];
		if(!String.isEmpty(u.FederationIdentifier)) {
			uniqueIdentifier = u.FederationIdentifier;
		} else {
			uniqueIdentifier = u.Username;
		}
		if(u.FSA_BTO_FIPS_Code__c != null) {
			stateFIPSCode = '<StateFIPSCode>' + u.FSA_BTO_FIPS_Code__c.substring(0,2) + '</StateFIPSCode>';
			countyFIPSCode = '<CountyFIPSCode>' + u.FSA_BTO_FIPS_Code__c.substring(2,5) + '</CountyFIPSCode>';
		}

		orgHost = orgURL;
		endURL = 'https://' + orgURL;

		try {
			SCIMS_Setting__mdt setting = [
				SELECT Org_Name__c, Return_URL__c, Search_URL__c
				FROM SCIMS_Setting__mdt
				WHERE Active__c = true
				LIMIT 1
			];
			searchURL = setting.Search_URL__c;
			returnURL = setting.Return_URL__c;
			orgName = setting.Org_Name__c;
		} catch (Exception e) {
			throw new SettingNotFoundException(NO_ACTIVE_SETTING_RECORD_ERROR);
		}
	}


	@RemoteAction
	global static String setTimeZone(String userTimeZone) {
		ReturnStatus returnStatus = new ReturnStatus();
		try {
			if(userTimeZone != UserInfo.getTimeZone().getID()) {
				User u = [
					SELECT Id, TimeZoneSidKey
					FROM User
					WHERE ID =: UserInfo.getUserId()
				];
				u.TimeZoneSidKey = userTimeZone;
				update u;
				returnStatus.success = true;
				returnStatus.message = 'Successfully changed the time zone to ' + userTimeZone;
			}
		} catch(Exception e) {
			returnStatus.success = false;
			returnStatus.message = e.getMessage();
		}
		return JSON.serialize(returnStatus);
	}


	public class ReturnStatus {
		boolean success;
		String message;
	}

	public class SettingNotFoundException extends Exception {}
}
public with sharing class LandViewDA {

	private static final String SYSTEM_ADMIN_PROFILE = 'System Administrator';
	private static final String EMPLOYEE_BASE_PROFILE = 'FPAC Employee Base';
	private static final String EMPLOYEE_MANAGER_PROFILE = 'FPAC Manager Base';
	private static final String QUERY_FIELDS = 'Id, Admin_County_Code__c, Admin_State_Code__c, BIA_Number__c, CLU_Acreage__c, CLU_Number__c, Congressional_District_Code__c, Conservation_Practice_Identifier__c, Cropland_Acres__c, Cropland_Indicator_3CM__c, CRP_Acres__c, Crp_Contract_Expiry_Date__c, CRP_Contract_Number__c, Current_Year__c, DCP_Cropland_Acres__c, DCP_Double_Crop_Acres__c, DCP_Effective_Cropland_Acres__c, Description__c, Election_Details__c, Farm_Number__c, Farmland_Acres__c, GRP_Acres__c, HEL_Status__c, Inactive_Indicator__c, Land_ID__c, Land_ID__r.Parent_ID__c, Name, MPL_Acres__c, Other_Conserve_Acres__c, Other_Producers__c, Other_Producers_Count__c, OwnerId, Owners__c, Owners_Count__c, SOD_Acres__c, SOD_Conservation_Crop_Yr1__c, SOD_Conservation_Crop_Yr2__c, SOD_Conservation_Crop_Yr3__c, SOD_Conservation_Crop_Yr4__c, State_Conserve_Acres__c, Sugarcane_Acres__c, Summary_User__c, Summary_User__r.Name, Tract_Number__c, Visible_Field_Count__c, WBP_Acres__c, Wetland_Status__c, Wetland_Violation__c, WRP_Acres__c';
	private static final String AUTHORITY_OPERATOR_ROLE = 'Operator';

	private Id getContactId() {
		List<User> user = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		if (user.isEmpty()) {
			return null;
		} else {
			return user[0].ContactId;
		}
	}

	private static Boolean userIsAdminOrEmployee() {
		User user = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		return ( user.Profile.Name == SYSTEM_ADMIN_PROFILE || user.Profile.Name == EMPLOYEE_BASE_PROFILE || user.Profile.Name == EMPLOYEE_MANAGER_PROFILE );
	}

	private static string getWhereClause(String recordId) {
		String returnValue = '';

		String parentId = [
			SELECT Land_ID__c
			FROM Land_View__c
			WHERE Id = :recordId
			LIMIT 1
		].Land_ID__c;

		List<Land__c> childrenLands = [
			SELECT Id
			FROM Land__c
			WHERE Parent_ID__c = :parentId
		];

		returnValue += ' WHERE Land_ID__r.Parent_ID__c = \'' + parentId + '\'';

		if (userIsAdminOrEmployee()) {
			List<String> landIds = new List<String>();
			for (Land__c child : childrenLands) {
				landIds.add(child.Id);
			}

			List<Authority__c> authorities = [
				SELECT Contact__c
				FROM Authority__c
				WHERE Associated_Land__c = :landIds
					AND Role__c = :AUTHORITY_OPERATOR_ROLE
				LIMIT 1
			];
			List<String> operatorIds = new List<String>();
			Boolean first = true;
			for (Authority__c authority : authorities) {
				returnValue += (first ? ' AND Summary_User__c IN (\'' + authority.Contact__c + '\'' : ', \'' + authority.Contact__c + '\'' );
				first = false;
			}
			if(!authorities.isEmpty()) {
				returnValue += ')';
			}
		} else {
			String contactId = [
				SELECT ContactId
				FROM User
				WHERE Id = :UserInfo.getUserId()
			].ContactId;
			returnValue += ' AND Summary_User__c = \'' + contactId + '\'';
		}
		return returnValue;
	}

	private static string getWhereClause(List<String> recordIds) {
		String returnValue = '';
		List<Land_View__c> landViews = [
			SELECT Land_ID__c
			FROM Land_View__c
			WHERE Id IN :recordIds
		];

		List<String> parentIds = new List<String>();
		for (Land_View__c landView : landViews) {
			parentIds.add(landView.Land_ID__c);
		}

		List<Land__c> childrenLands = [
			SELECT Id
			FROM Land__c
			WHERE Parent_ID__c IN :parentIds
		];

		for (Land__c child : childrenLands) {
			returnValue += (String.isEmpty(returnValue) ? ' WHERE Land_ID__c IN (\'' + child.Id + '\'' : ', \'' + child.Id + '\'' );
		}
		if (!childrenLands.isEmpty()) {
			returnValue += ')';
		}

		if (userIsAdminOrEmployee()) {

			List<String> landIds = new List<String>();
			for (Land__c child : childrenLands) {
				landIds.add(child.Id);
			}

			List<Authority__c> authorities = [
				SELECT Contact__c
				FROM Authority__c
				WHERE Associated_Land__c = :landIds
					AND Role__c = :AUTHORITY_OPERATOR_ROLE
			];
			List<String> operatorIds = new List<String>();
			Boolean first = true;
			for (Authority__c authority : authorities) {
				returnValue += (first ? ' AND Summary_User__c IN (\'' + authority.Contact__c + '\'' : ', \'' + authority.Contact__c + '\'' );
				first = false;
			}
			if(!authorities.isEmpty()) {
				returnValue += ')';
			}
		} else {
			String contactId = [
				SELECT ContactId
				FROM User
				WHERE Id = :UserInfo.getUserId()
			].ContactId;
			returnValue += ' AND Summary_User__c = \'' + contactId + '\'';
		}
		return returnValue;
	}

	private static String getContactId(String landViewId) {
		if (userIsAdminOrEmployee()) {
			String landId = [
				SELECT Land_ID__c
				FROM Land_View__c
				WHERE Id = :landViewId
				LIMIT 1
			].Land_ID__c;
			return [
				SELECT Contact__c
				FROM Authority__c
				WHERE Associated_Land__c = :landId
					AND Role__c = :AUTHORITY_OPERATOR_ROLE
				LIMIT 1
			].Contact__c;
		} else {
			return [
				SELECT ContactId
				FROM User
				WHERE Id = :UserInfo.getUserId()
			].ContactId;
		}
	}

	public static Land_View__c getLand(String recordId) {
		return Database.query(
			'SELECT ' + QUERY_FIELDS +
			' FROM Land_View__c ' +
			' WHERE Id = :recordId' +
			' AND Summary_User__c = \'' + getContactId(recordId) + '\'' +
			' LIMIT 1'
		);
	}

	public static List<Land_View__c> getChildrenLands(String parentId) {
		return Database.query(
			'SELECT ' + QUERY_FIELDS +
			' FROM Land_View__c ' +
			getWhereClause(parentId)
		);
	}

	public static List<Land_View__c> getChildrenLands(List<String> parentIds) {
		return Database.query(
			'SELECT ' + QUERY_FIELDS +
			' FROM Land_View__c ' +
			getWhereClause(parentIds)
		);
	}

}
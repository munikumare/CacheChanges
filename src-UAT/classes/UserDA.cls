public with sharing class UserDA implements UserDAI{
	private static final String SYSTEM_ADMIN = 'System Administrator';
	private static final String EMPLOYEE_BASE_PROFILE = 'FPAC Employee Base';
	private static final String EMPLOYEE_MANAGER_PROFILE = 'FPAC Manager Base';

	public Boolean isUserAdminOrEmployee(){
		User user = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		if(user.Profile.Name == SYSTEM_ADMIN || user.Profile.Name == EMPLOYEE_BASE_PROFILE || user.Profile.Name == EMPLOYEE_MANAGER_PROFILE){
			return true;
		} else {
			return false;
		}
	}
	public Id getCurrentUserContactId(){
		return [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
	}
}
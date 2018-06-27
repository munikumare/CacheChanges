@isTest
public with sharing class UserDAMock implements UserDAI {
	public Boolean isUserAdminOrEmployee;
	public Id contactId;

	public Boolean isUserAdminOrEmployee(){
		return isUserAdminOrEmployee;
	}
	public Id getCurrentUserContactId(){
		return contactId;
	}
}
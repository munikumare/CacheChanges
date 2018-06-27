@IsTest
private class UserDATest {
	@isTest
	static void isUserAdminOrEmployee() {
		UserDA da = new UserDA();
		Test.startTest();
			Boolean isUserAdmin = da.isUserAdminOrEmployee();
		Test.stopTest();

		System.assert(isUserAdmin);
	}
	@isTest
	static void getCurrentUserContactId() {
		Id p = [select id from profile where name='FPAC Customer'].id;

		Account ac = new Account(name ='Grazitti') ;
		insert ac;

		Contact contact = new Contact(
				FirstName = 'Test',
				LastName = 'Test',
				Email = 'a@test.com',
				MailingCity = 'test',
				MailingState = 'Ohio',
				MailingStreet = 'test',
				MailingPostalCode = '12345',
				AccountId = ac.Id
		);
		insert contact;

		User user = new User(
				alias = 'test123',
				email='test123@noemail.com',
				emailencodingkey='UTF-8',
				lastname='Testing',
				languagelocalekey='en_US',
				localesidkey='en_US',
				profileid = p,
				country='United States',
				IsActive =true,
				ContactId = contact.Id,
				timezonesidkey='America/Los_Angeles',
				username='tester@noemail.com'
		);

		insert user;

		UserDA da = new UserDA();

		Id currentUserId;

		Test.startTest();
			system.runAs(user) {
				currentUserId = da.getCurrentUserContactId();
			}
		Test.stopTest();

		System.assertNotEquals(currentUserId, null);
	}
}
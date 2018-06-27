@IsTest
private class LandFarmViewControllerTest {
	private static final String OTHER_PRODUCER_ROLE = 'Other Producer';
	private static final Id FARM_RECORD_TYPE_ID = Schema.SObjectType.Land__c.getRecordTypeInfosByName().get('Farm').getRecordTypeId();

	@isTest
	static void getData_given_should() {

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

		Land__c farm = new Land__c(
			RecordTypeId = FARM_RECORD_TYPE_ID,
			Farm_Number__c = '123'
		);
		insert farm;

		Authority__c authority = new Authority__c(
			Associated_Land__c = farm.Id ,
			Role__c = 'Operator',
			Contact__c = contact.Id
		);
		insert authority;

		List<Land__c> lands;

		AuthorityDA da = new AuthorityDA();

		Test.startTest();

		system.runAs(user) {
			lands = LandFarmViewController.getData(null,'Home','Farm_Number__c', 'desc',0,10,10);
		}

		Test.stopTest();

		System.assertEquals(lands[0].Id, farm.Id);
	}
}
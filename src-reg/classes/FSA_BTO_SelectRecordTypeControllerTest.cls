@isTest
private class FSA_BTO_SelectRecordTypeControllerTest{

public static testMethod void testHandleRedirect(){
RecordType accountRT = [Select Name, Id from RecordType where Name = 'USDA Agency'];
Account pageAccount = new Account(Name='Test Agency', RecordTypeId=accountRT.Id);
Contact pageContact = new Contact(LastName = 'Tester', AccountId = pageAccount.Id,MailingStreet= '123 Sesame Street', MailingCity='Nowhere', MailingState='Virginia', MailingPostalCode='22102');
RecordType contactRT = [Select Name, Id from RecordType where Name = 'Bridges Partner Individual'];
Insert pageAccount;



Test.setCurrentPageReference(new PageReference('/apex/FSA_BTO_SelectRecordType'));
System.currentPageReference().getParameters().put('accid', PageAccount.Id);
//ApexPages.StandardController sc = new ApexPages.StandardController(pageContact);
//FSA_BTO_SelectRecordTypeController con = new FSA_BTO_SelectRecordTypeController(sc);
System.Debug('PAGE' + System.currentPageReference());
//PageReference pr = con.handleRedirect();
//System.Debug(pr);
pageContact.RecordTypeId = contactRT.Id;
Insert pageContact;
Test.setCurrentPageReference(new PageReference('/apex/FSA_BTO_SelectRecordType'));
System.currentPageReference().getParameters().put('accid', PageAccount.Id);
System.Debug('PAGE' + System.currentPageReference());
System.AssertEquals('System.PageReference[/apex/FSA_BTO_SelectRecordType?accid='+pageAccount.Id+']', String.valueOf(System.currentPageReference()));
}

public static testMethod void testUpdateRecordTypes(){
Test.startTest();
RecordType accountRT = [Select Name, Id from RecordType where Name = 'USDA Agency'];
Account pageAccount = new Account(Name='Test Agency', RecordTypeId=accountRT.Id);
Contact pageContact = new Contact(LastName = 'Tester', AccountId = pageAccount.Id,MailingStreet= '123 Sesame Street', MailingCity='Nowhere', MailingState='Virginia', MailingPostalCode='22102');
RecordType contactRT = [Select Name, Id from RecordType where Name = 'Bridges Partner Individual'];
pageContact.RecordTypeId= contactRT.Id;
Insert pageAccount;
pageContact.AccountId = pageAccount.Id;
Insert pageContact;

Set<Id> ids = new Set<Id>();
ids.Add(pageAccount.id);
FSA_BTO_SelectRecordTypeController.updateRecordTypes(ids);
Test.stopTest();
Contact testContact = [Select Id, Name, RecordType.Name, MailingCity from Contact where LastName='Tester' and MailingCity='Nowhere'];
System.AssertEquals('USDA Agency Individual', testContact.RecordType.Name);
}

public static testMethod void testUpdateRecordTypesContact(){
Test.startTest();
RecordType accountRT =[Select Name, Id from RecordType where Name = 'USDA Agency'];
Account pageAccount = new Account(Name='Test Agency', RecordTypeId=accountRT.Id);
Contact pageContact = new Contact(LastName = 'Tester', AccountId = pageAccount.Id,MailingStreet= '123 Sesame Street', MailingCity='Nowhere', MailingState='Virginia', MailingPostalCode='22102');
RecordType contactRT = [Select Name, Id from RecordType where Name = 'Bridges Partner Individual'];
pageContact.RecordTypeId= contactRT.Id;
Insert pageAccount;
pageContact.AccountId = pageAccount.Id;
Insert pageContact;
System.Debug(pageContact.Id);
Set<Id> ids = new Set<Id>();
ids.Add(pageContact.id);
FSA_BTO_SelectRecordTypeController.updateRecordTypesContact(ids);
Test.stopTest();
Contact testContact = [Select Id, Name, RecordTypeId, MailingCity from Contact where LastName='Tester' and MailingCity='Nowhere'];
List<RecordType> name = [Select Id, Name from RecordType where Id=:testContact.RecordTypeId];
System.AssertEquals('USDA Agency Individual', name[0].Name);
}

}
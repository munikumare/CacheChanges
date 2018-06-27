@isTest
public class FSA_BTO_Copy_EmailTest {

    public static testMethod void testCopyEmail(){
        Contact testPartner = new Contact(LastName='Partner', FSA_BTO_EnforceUniqueEmail__c='noreply@fake.server');
        insert testPartner;

        Contact getPartner = [Select Id, Email, FSA_BTO_EnforceUniqueEmail__c from Contact where FSA_BTO_EnforceUniqueEmail__c='noreply@fake.server'];

        System.AssertEquals('noreply@fake.server', getPartner.Email);    
    }
}
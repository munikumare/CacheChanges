@isTest
public class FSA_BTO_Copy_EmailTest {

    public static testMethod void testCopyEmail(){
        RecordType contactNonBCI=[Select Id From RecordType Where SObjectType='Contact' AND Name!='FPAC Customer Contact' LIMIT 1];
        Contact testPartner = new Contact(LastName='Partner', FSA_BTO_EnforceUniqueEmail__c='noreply@fake.server', RecordTypeId=contactNonBCI.Id,  MailingStreet = 'Fake Street', MailingCity = 'Fake City', MailingState = 'Virginia', MailingPostalCode = '11111', MailingCountry = 'United States');
        insert testPartner;

        Contact getPartner = [Select Id, Email, FSA_BTO_EnforceUniqueEmail__c from Contact where FSA_BTO_EnforceUniqueEmail__c='noreply@fake.server'];

        System.AssertEquals('noreply@fake.server', getPartner.Email);    
    }
}
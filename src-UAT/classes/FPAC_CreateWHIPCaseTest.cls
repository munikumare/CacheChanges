/**
 * Created by Sabitha on 04/30/2018
 * Test class for 'FPAC_CreateWHIPCase'  
 */

@isTest
private class FPAC_CreateWHIPCaseTest {
    
    @testSetup static void testSetUpData(){
        Contact con = new Contact();
        con.FirstName='FPAC Application';
        con.LastName='Customer';
        con.Email='test@gmail.com';
        con.MailingStreet='sunrise valley drive';
        con.MailingCity='herndon';
        con.MailingState='Virginia';
        con.MailingCountry='United States';
        con.MailingPostalCode='20191';
        con.System_Contact__c=true;
        insert con;
    }
    
    @isTest static void testCreateWHIPCase()
    {
        ID caseID  = FPAC_CreateWHIPCase.createCase('vTest','def@gmail.com', '1231231234','9879879876');
        System.assert(caseID!=null);
        
        Case c = [select Id,Status from Case where ID=:caseID];
        system.assert(c!=null);
        system.assertEquals('Initiated', c.Status);
        
    }
    
    @isTest static void testCreateWHIPCaseFail()
    {
        RestResponse res = new RestResponse();
        RestContext.response= res;

        String error  = FPAC_CreateWHIPCase.createCase('','', '','');
        System.assert(error!=null);
        
        error  = FPAC_CreateWHIPCase.createCase('vTest','defgmailom', '1231231234','9879879876');
        System.assert(error!=null);
        
        Contact con= [select Id,Name from Contact where System_Contact__c=true limit 1];
        delete con;
        error  = FPAC_CreateWHIPCase.createCase('','', 'aaa33','bbb344');
        System.assert(error!=null);
    }
    
}
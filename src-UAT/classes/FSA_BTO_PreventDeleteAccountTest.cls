@isTest
public class FSA_BTO_PreventDeleteAccountTest {
    public static testMethod void testDeleteAccounts() {
        Account fsaAgencyAccount = new Account(Name='USDA Farm Service Agency', Website='http://www.fsa.usda.gov', FSA_BTO_State_PickList__c='DC');
        insert fsaAgencyAccount;
        Account scimsCustomerAccount = new Account(Name='SCIMS Customer');
        insert scimsCustomerAccount;
        
        Profile fsaBtoRMProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Resource Manager' LIMIT 1];
        User fsaBtoRM = new User(
                                    Alias='TRM',
                                    Email='testrep@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='McRep',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaBtoRMProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName='trm@usda.fsa'
                                );
        insert fsaBtoRM;

        System.runAs(fsaBtoRM) {  
            fsaAgencyAccount = [SELECT Id FROM Account WHERE Name = 'USDA Farm Service Agency'];
            scimsCustomerAccount = [SELECT Id FROM Account WHERE Name = 'SCIMS Customer'];
            try {
                delete fsaAgencyAccount;
            } catch(Exception e) {
                System.assertEquals(false, String.isEmpty(e.getMessage()));
            }
            try {
                delete scimsCustomerAccount;
            } catch(Exception e) {
                System.assertEquals(false, String.isEmpty(e.getMessage()));
            }
        }
    }
}
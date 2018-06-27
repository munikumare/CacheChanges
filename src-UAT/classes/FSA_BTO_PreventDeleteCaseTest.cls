@isTest
public class FSA_BTO_PreventDeleteCaseTest {
    public static testMethod void testDeleteCase() {
        Case testCase1 = new Case(Subject='Test Case 1', Origin='Mail');
        insert testCase1;
        
        Profile fsaBtoUserProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User' LIMIT 1];
        User fsaBtoUser = new User(
                                    Alias='TRM',
                                    Email='testrep@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='McRep',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaBtoUserProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName='trm@usda.fsa'
                                );
        insert fsaBtoUser;

        System.runAs(fsaBtoUser) {  
            Case resultCase = [SELECT Id FROM Case WHERE Subject = 'Test Case 1'];
            try {
                delete testCase1;
            } catch(Exception e) {
                System.assertEquals(false, String.isEmpty(e.getMessage()));
            }
        }
    }
}
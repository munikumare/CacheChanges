@isTest
public class FSA_BTO_PreventDeleteCountyTest {
    public static testMethod void testDeleteCounty() {
        Profile fsaBtoRMProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO Resource Manager' LIMIT 1];
        User fsaBtoRMUser = new User(
                                    Alias='TRep',
                                    Email='testrep@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='TestRep',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaBtoRMProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName='trep@fsa.usda'
                                );
        insert fsaBtoRMUser;
        
        FSA_BTO_County__c testCounty = new FSA_BTO_County__c(Name='Test County');
        insert testCounty;
        
        System.runAs(fsaBtoRMUser) {  
            testCounty = [SELECT Id FROM FSA_BTO_County__c WHERE Name='Test County'];
            try {
                delete testCounty;
            } catch(Exception e) {
                System.assertEquals(false, String.isEmpty(e.getMessage()));
            }
        }
    }
}
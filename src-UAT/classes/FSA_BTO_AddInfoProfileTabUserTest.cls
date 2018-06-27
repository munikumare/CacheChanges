@isTest
public class FSA_BTO_AddInfoProfileTabUserTest {
    public static testMethod void testViewAdditionalInfoTab() {
        Profile fsaBtoUserProfile = [SELECT Id FROM Profile WHERE Name = 'FSA BTO User' LIMIT 1];
        User fsaBtoUser = new User(
                                    Alias='TRep',
                                    Email='testrep@usda.gov',
                                    EmailEncodingKey='UTF-8',
                                    LanguageLocaleKey='en_US',
                                    LastName='TestRep',
                                    LocaleSidKey='en_US',
                                    ProfileId=fsaBtoUserProfile.Id,
                                    TimeZoneSidKey='America/New_York',
                                    UserName='trep@fsa.usda'
                                );
        insert fsaBtoUser;
        
        System.runAs(fsaBtoUser) {  
            Test.setCurrentPage(Page.FSA_BTO_AddInfoProfileTabUser);
            ApexPages.currentPage().getParameters().put('sfdc.userId', fsaBtoUser.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(fsaBtoUser);
            FSA_BTO_AddInfoProfileTabUserController controller = new FSA_BTO_AddInfoProfileTabUserController(sc);
            Test.setCurrentPage(controller.editUserCustomFields());
            controller.fsaOffice = 'Fairfax County';
            controller.specializesIn = 'Lorem ipsum dolor sit amet, nonummy ligula volutpat hac integer nonummy. Suspendisse ultricies, congue etiam tellus, erat libero, nulla eleifend, mauris pellentesque. Suspendisse integer praesent vel, integer gravida mauris, fringilla vehicula lacinia none';
            System.assertEquals(null, controller.saveUserCustomFields());
            Test.setCurrentPage(controller.editUserCustomFields());
            controller.specializesIn = 'Dairy';
            System.assertNotEquals(null, controller.saveUserCustomFields());
            Test.setCurrentPage(controller.editUserCustomFields());
            Test.setCurrentPage(controller.cancel());
        }
    }
}
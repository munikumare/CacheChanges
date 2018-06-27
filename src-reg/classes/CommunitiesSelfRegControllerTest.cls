/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    // modified for higher code coverage
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();

        controller.firstName = 'Bob';
        controller.lastName = 'Jones';
        controller.email = 'bob@jones.com';
        controller.password = 'hunter2';
        controller.confirmPassword = 'hunter2';
        controller.communityNickname = 'bob-jones-testing';

        PageReference pageRef = controller.registerUser();
    }

    @IsTest(SeeAllData=true) 
    public static void testInvalidPassword() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'Bob';
        controller.lastName = 'Jones';
        controller.email = 'bob@jones.com';
        controller.password = 'hunter2';
        controller.confirmPassword = 'hunter3';
        controller.communityNickname = 'bob-jones-testing';

        PageReference pageRef = controller.registerUser();
        System.assert(pageRef == null, 'The returned page reference should be null');
    }

    @IsTest(SeeAllData=true) 
    public static void testNullPassword() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'Bob';
        controller.lastName = 'Jones';
        controller.email = 'bob@jones.com';
        controller.password = null;
        controller.confirmPassword = null;
        controller.communityNickname = 'bob-jones-testing';

        PageReference pageRef = controller.registerUser();
        System.assert(pageRef == null, 'The returned page reference should be null');
    }
}
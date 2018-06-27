/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesSelfRegConfirmControllerTest {
    @IsTest public static void testCommunitiesSelfRegConfirmController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesSelfRegConfirmController controller = new CommunitiesSelfRegConfirmController();
      } 

    @testSetup static void setupTestData(){
        Account fsaAgencyAccount = new Account(Name='USDA Farm Service Agency', Website='http://www.fsa.usda.gov', FSA_BTO_State_PickList__c='DC'); 
        insert fsaAgencyAccount;
    }  
}
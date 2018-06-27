@isTest
private class FSA_BTO_ContactSearchControllerTest {
    //test migration tool
    public static testMethod void ourTestMethod()
    {
        // Make a user - insert
        Profile fsaBtoProfile = [SELECT Id FROM Profile WHERE Name='FSA BTO User']; 
        User testUser = new User
                                (
                                    Alias = 'standt', 
                                    Email='standarduser@testorg.com', 
                                    EmailEncodingKey='UTF-8', 
                                    LastName='Testing', 
                                    LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', 
                                    ProfileId = fsaBtoProfile.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='testuser@fsa.bto'
                                );
         insert testUser;

         System.runAs(testUser) 
         { 
             //Set the page
             PageReference pageRef = Page.FSA_BTO_Contact_Search;
             Test.setCurrentPage(pageRef);
             
             //Define the controller
             FSA_BTO_ContactSearchController contactSearchController = new FSA_BTO_ContactSearchController();
             ApexPages.currentPage().getParameters().put('searchString', 'searchString');
             
             PageReference runSearchPageReference = contactSearchController.runSearch();
             System.assertEquals(runSearchPageReference, null);
             
             System.assertEquals(contactSearchController.sortDir, 'asc');
             contactSearchController.toggleSort();
             System.assertEquals(contactSearchController.sortDir, 'desc');
             
         }
    }
}
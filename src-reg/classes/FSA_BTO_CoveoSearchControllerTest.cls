@isTest
private class FSA_BTO_CoveoSearchControllerTest {

@isTest
static void testController(){
Case testCase = new Case();
ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
FSA_BTO_CoveoSearchController testController = new FSA_BTO_CoveoSearchController(sc);
System.assertNotEquals(null, testController);
}

@isTest (SeeAllData=true)
static void testGetContext(){
Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
FSA_BTO_CoveoSearchController testController = new FSA_BTO_CoveoSearchController();
String testToken = testController.getContext();
System.assertEquals('Test', testToken);
}


}
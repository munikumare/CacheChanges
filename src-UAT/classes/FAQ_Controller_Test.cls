@isTest
private class FAQ_Controller_Test {
    
    @isTest static void test_FAQ() {
        // Implement test code
        list<FPAC_FAQ__c> fqList = new list<FPAC_FAQ__c>();
        for(integer i=0;i<9;i++){
            FPAC_FAQ__c f = new FPAC_FAQ__c();
            f.Answer__c = 'test ANS';
            f.Question__c = 'Test Que';
            f.Category__c = 'Uncategorized';  
            f.Active__c = true;
            fqList.add(f);
        }

        FPAC_FAQ__c f = new FPAC_FAQ__c();
        f.Answer__c = 'test ANS';
        f.Question__c = 'Test Que';
        f.Category__c = 'Uncategorized'; //Add Different category from picklist  
        f.Active__c = true;
        fqList.add(f);

        insert fqList;

        test.startTest();
        FAQ_Controller.getFAQList();
        test.stopTest();
    }
        
}
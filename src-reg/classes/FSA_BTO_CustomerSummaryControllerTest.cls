@isTest
private class FSA_BTO_CustomerSummaryControllerTest {
    @isTest(SeeAllData=true) // true for this method only, to see default Account 'Farm Service Agency' that's assigned for internal referrals (see FSA_BTO_PopulateAccountLookup)
    public static void testCustomerSummaryController() {  
        // Make a user - insert
        Profile fsaBtoProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User (
                                    Alias = 'standt',
                                    Email='standarduser@testorg.com', 
                                    EmailEncodingKey='UTF-8', 
                                    IsActive=true,
                                    CommunityNickname = 'test123',
                                    LastName='Testing', 
                                    LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', 
                                    ProfileId = fsaBtoProfile.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='testuser@fsa.bto',
                                    UserPermissionsKnowledgeUser=true
                                );
        insert testUser;
        
        //Add a user to own the referral
        Account partnerAccount = new Account(Name='testAccount');
        insert partnerAccount;
        RecordType bridgesPartnerIndividualRT = [SELECT Id from RecordType WHERE DeveloperName='FSA_BTO_Partner'];
        Contact partnerContact = new Contact(LastName='testLastName', AccountId=partnerAccount.Id, MailingStreet='123 Fake St', MailingCity='Fakesville', MailingState='Virginia', MailingPostalCode='12345', RecordTypeId=bridgesPartnerIndividualRT.Id);
        insert partnerContact;
        Profile partnerProfile = [SELECT Id FROM Profile WHERE Name='Content Partner Community Login User' LIMIT 1]; 
        User testPartner = new User(
                                    Alias = 'part',
                                    ContactId = partnerContact.Id,
                                    Email='partneruser@testorg.com', 
                                    EmailEncodingKey='UTF-8',
                                    FSA_BTO_Accepts_Referrals__c=true,
                                    FSA_BTO_Specializes_In__c='Beef',
                                    IsActive=true,
                                    CommunityNickname = 'test234',
                                    LastName='Partner', 
                                    LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', 
                                    ProfileId = partnerProfile.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='testpartner@fsa.bto'
                                );                     
        insert testPartner;
        
        System.runAs(testUser) {
            //Set current page to the Customer Summary VisualForce Page
            PageReference pageRef = Page.FSA_BTO_CustomerSummary;
            Test.setCurrentPage(pageRef);
            
            //Create the Customary Summary to be presented by the VisualForce Page
            TIMBASURVEYS__Survey__c testSurvey = new TIMBASURVEYS__Survey__c();
            insert testSurvey;
            Case testCase = new Case(fsa_bto_survey__c = testSurvey.id);
            insert testCase;
            
            // Add the id to the URL parameters
            ApexPages.currentPage().getParameters().put('id', testCase.id);
            
            //Create the controller for the VisualForce Page
            FSA_BTO_CustomerSummaryController customerSummaryCtrl = new FSA_BTO_CustomerSummaryController();
            
            //Ensure the controller has the right id from the URL
            System.assertEquals(testCase.id, customerSummaryCtrl.urlCaseId);
            
            //Ensure the controller has the right Customer Summary
            System.assertEquals(testCase.id, customerSummaryCtrl.currentCase.id);
            
            testBaseCase(customerSummaryCtrl, testCase);
            
            testPopulateCase(customerSummaryCtrl, testCase, testPartner);
        }      
    }
    
    static void testBaseCase(FSA_BTO_CustomerSummaryController customerSummaryCtrl, Case testCase) {
        System.assertEquals('Testing', customerSummaryCtrl.userName);

        System.assertEquals(true, customerSummaryCtrl.articles.isEmpty());
        System.assertEquals(0, customerSummaryCtrl.articlesSize);
        System.assertEquals(false, customerSummaryCtrl.containsArticles);

        System.assertEquals(true, customerSummaryCtrl.contacts.isEmpty());
        System.assertEquals(0, customerSummaryCtrl.contactsSize);
        System.assertEquals(false, customerSummaryCtrl.containsOrganizations);
        
        System.assertEquals(true, customerSummaryCtrl.organizations.isEmpty());
        System.assertEquals(0, customerSummaryCtrl.organizationsSize);
        System.assertEquals(false, customerSummaryCtrl.containsContacts);

        System.assertEquals(true, customerSummaryCtrl.links.isEmpty()); 
        System.assertEquals(0, customerSummaryCtrl.linksSize);
        System.assertEquals(false, customerSummaryCtrl.containsLinks);
        
        System.assertEquals(true, customerSummaryCtrl.events.isEmpty());
        System.assertEquals(0, customerSummaryCtrl.eventsSize);
        System.assertEquals(false, customerSummaryCtrl.containsEvents);

        System.assertEquals(true, customerSummaryCtrl.contents.isEmpty());
        System.assertEquals(0, customerSummaryCtrl.contentsSize);
        System.assertEquals(false, customerSummaryCtrl.containsContents);
        
        System.assertEquals(null, customerSummaryCtrl.servicesRequested);
                
        System.assertEquals(null, customerSummaryCtrl.itemsProvided);
        
        System.assertEquals(null, customerSummaryCtrl.itemsReceived);
                
        //System.assertEquals(false, customerSummaryCtrl.containsAttachments);
        
        System.assertEquals(false, customerSummaryCtrl.containsReferrals);
    }
    
    static void testPopulateCase(FSA_BTO_CustomerSummaryController customerSummaryCtrl, Case testCase, User testPartner) {
        // TO-DO: Add a article
        
        // Add a contact
        RecordType publicPartnerIndividualRT = [SELECT Id from RecordType WHERE DeveloperName='FSA_BTO_Public_Partner'];
        Contact testContact = new Contact(LastName = 'testLastName', MailingStreet='123 Fake St', MailingCity='Fakesville', MailingState='Virginia', MailingPostalCode='12345', RecordTypeId=publicPartnerIndividualRT.Id);
        insert testContact;
        FSA_BTO_Case_Contact__c testAssociatedContact = new FSA_BTO_Case_Contact__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Contact__c = testContact.id);
        insert testAssociatedContact;

        // Add a organization
        Account testAccount = new Account(Name = 'testOrganization', BillingStreet='234 Fake Ave', BillingCity='McLean', BillingState='Virginia', BillingPostalCode='54321');
        insert testAccount;
        FSA_BTO_Case_Organization__c testAssociatedOrganization = new FSA_BTO_Case_Organization__c(FSA_BTO_Customer_Interaction__c = testCase.id, FSA_BTO_Organization__c = testAccount.id);
        insert testAssociatedOrganization;

        // Add a link
        FSA_BTO_Case_Link__c testAssociatedLink = new FSA_BTO_Case_Link__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Link_Name__c = 'testLinkName', FSA_BTO_Link_URL__c = 'www.testURL.com');
        insert testAssociatedLink;
        
        // Add an event for attachments
        Event testEventForAttachment = new Event(Subject='Test Event 123', DurationInMinutes=60, StartDateTime=DateTime.newInstance(2016,03,22), FSA_BTO_Phone_Number__c='1112223333', FSA_BTO_EventStreet__c='123 Fake St', FSA_BTO_EventCity__c='Fairfax', FSA_BTO_EventState__c='VA', FSA_BTO_EventZipCode__c='11111');
        insert testEventForAttachment;

        // Add an associated event
        FSA_BTO_Event_Info__c testEventInfo = new FSA_BTO_Event_Info__c(FSA_BTO_Subject__c = 'testSubject', FSA_BTO_Event_Id__c=testEventForAttachment.Id);
        insert testEventInfo;
        FSA_BTO_Case_Event_Info__c testAssociatedEvent = new FSA_BTO_Case_Event_Info__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Event_Info__c = testEventInfo.id, FSA_BTO_Event_Id__c=testEventForAttachment.Id);
        insert testAssociatedEvent;
        
        
        // Add content
        FSA_BTO_Case_Content_Distribution__c testAssociatedContent = new FSA_BTO_Case_Content_Distribution__c(Case__c = testCase.id, Content_Name__c = 'testName', Content_URL__c = 'www.testurl.com');
        insert testAssociatedContent;
        
        // Add service requested
        testCase.FSA_BTO_Service_Requested__c = 'Farm Program - FSFL Application Rec;';
        update testCase;

        // Add additional info requested
        testCase.FSA_BTO_Additional_Info_Requested__c = 'RD;';
        update testCase;

        // Add additional items provided
        testCase.FSA_BTO_Additional_Items_Provided__c = 'FSA-578;';
        update testCase;

        // Add additional items received
        testCase.FSA_BTO_Additional_Items_Received__c = 'Cash-rent documentation;';
        update testCase;
        
        // Add feed item attachments
        Feeditem caseFeedItem = new FeedItem(ContentFileName='Test File Name for Case', ContentData=Blob.valueOf('hello'), Title='Test Feed Item for Case', ParentId=testCase.Id, Type='ContentPost');
        insert caseFeedItem;
                
        Feeditem eventFeedItem = new FeedItem(ContentFileName='Test File Name for Event', ContentData=Blob.valueOf('hello'), Title='Test Feed Item for Event', ParentId=testEventForAttachment.Id, Type='ContentPost');
        insert eventFeedItem;
        //FeedAttachment feedAttachment = new FeedAttachment(FeedEntityId=feedItem.Id, Title='Test Feed Attachment', Type='Content');
        //insert feedAttachment;

        // Add referral
        Task testTask = new Task(OwnerId=testPartner.Id, WhatId=testCase.Id, Subject='Referral', Status='Referral In Progress');
        insert testTask;
        
        customerSummaryCtrl = new FSA_BTO_CustomerSummaryController();
        
        System.assertEquals('testLastName', customerSummaryCtrl.contacts[0].FSA_BTO_Contact_Name__c);
        System.assertEquals(1, customerSummaryCtrl.contactsSize);
        System.assertEquals(true, customerSummaryCtrl.containsContacts);
        
        System.assertEquals('testOrganization', customerSummaryCtrl.organizations[0].FSA_BTO_Organization_Name__c);
        System.assertEquals(1, customerSummaryCtrl.organizationsSize);
        System.assertEquals(true, customerSummaryCtrl.containsOrganizations);

        System.assertEquals('testLinkName', customerSummaryCtrl.links[0].FSA_BTO_Display_Link_Name__c);
        System.assertEquals('www.testURL.com', customerSummaryCtrl.links[0].FSA_BTO_Display_Link_URL__c);
        System.assertEquals(1, customerSummaryCtrl.linksSize);
        System.assertEquals(true, customerSummaryCtrl.containsLinks);

        //System.assertEquals('testSubject', customerSummaryCtrl.events[0].FSA_BTO_Event_Name__c);
        System.assertEquals(1, customerSummaryCtrl.eventsSize);
        System.assertEquals(true, customerSummaryCtrl.containsEvents);

        System.assertEquals('testName', customerSummaryCtrl.contents[0].Content_Name__c);
        System.assertEquals(1, customerSummaryCtrl.contentsSize);
        System.assertEquals(true, customerSummaryCtrl.containsContents);

        System.assertEquals(true, customerSummaryCtrl.servicesRequested.size() > 0);

        System.assertEquals(true, customerSummaryCtrl.itemsProvided.size() > 0);

        System.assertEquals(true, customerSummaryCtrl.itemsReceived.size() > 0);
                                                                                        
        System.assertEquals(true, customerSummaryCtrl.containsAttachments);
        
        System.assertEquals(true, customerSummaryCtrl.containsReferrals);
    }
                
    public static testMethod void testSeparateUrlForPrinting() {
        TIMBASURVEYS__Survey__c testSurvey = new TIMBASURVEYS__Survey__c();
        insert testSurvey;
        Case testCase = new Case(fsa_bto_survey__c = testSurvey.id);
        insert testCase;

        // Add the id to the URL parameters
        ApexPages.currentPage().getParameters().put('id', testCase.id);
        
        //FSA_BTO_CustomerSummaryController customerSummaryCtrl = new FSA_BTO_CustomerSummaryController();
        
        FSA_BTO_Case_Link__c testLink = new FSA_BTO_Case_Link__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Link_Name__c = 'Test Name', FSA_BTO_Link_URL__c='https://cloudapps-usda-gov--fsa.cs33.my.salesforce.com/sfc/p/350000000Nok/a/350000004Doq/TxZBEVVGlWhCMOA3WPSFmZug0o2FBsvkAR.hMLIkMHA');
        FSA_BTO_Case_Link__c testLinkTwo = new FSA_BTO_Case_Link__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Link_Name__c = 'Test Name Two', FSA_BTO_Link_URL__c='https://www.test.com');
        List<FSA_BTO_Case_Link__c> urls = new List<FSA_BTO_Case_Link__c>();
        urls.add(testLink);
        urls.add(testLinkTwo);
        insert urls;
        
        FSA_BTO_CustomerSummaryController customerSummaryCtrl = new FSA_BTO_CustomerSummaryController();
        
        List<Id> linkIds = new List<Id>();
        linkIds.add(testLink.id);
        linkIds.add(testLinkTwo.id);
        
        List<FSA_BTO_Case_Link__c> associatedLinks = [SELECT FSA_BTO_Display_Link_Name__c, FSA_BTO_Display_Link_URL__c FROM FSA_BTO_Case_Link__c WHERE id IN: linkIds];
        Map<Id,List<String>> results = customerSummaryCtrl.separateUrlForPrinting(associatedLinks);
        System.assertEquals(customerSummaryCtrl.splitUrlMap, results);
        
        Integer maxCharacterWidth = customerSummaryCtrl.maxCharacterWidth;
        if (customerSummaryCtrl.maxCharacterWidth > testLink.FSA_BTO_Link_URL__c.length()) {
            maxCharacterWidth = testLink.FSA_BTO_Link_URL__c.length();
        }
        List<String> actual = results.get(testLink.Id);
        String expected = testLink.FSA_BTO_Link_URL__c.substring(0, maxCharacterWidth);
        System.assertEquals(expected, actual[0]);
        
        maxCharacterWidth = customerSummaryCtrl.maxCharacterWidth;
        if (customerSummaryCtrl.maxCharacterWidth > testLinkTwo.FSA_BTO_Link_URL__c.length()) {
            maxCharacterWidth = testLinkTwo.FSA_BTO_Link_URL__c.length();
        }
        actual = results.get(testLinkTwo.Id);
        expected = testLinkTwo.FSA_BTO_Link_URL__c.substring(0, maxCharacterWidth);
        System.assertEquals(expected, actual[0]);
    }
    
    public static testMethod void testSeparateUrlForPrintingContent() {
        TIMBASURVEYS__Survey__c testSurvey = new TIMBASURVEYS__Survey__c();
        insert testSurvey;
        Case testCase = new Case(fsa_bto_survey__c = testSurvey.id);
        insert testCase;
        
        // Add the id to the URL parameters
        ApexPages.currentPage().getParameters().put('id', testCase.id);
        
        //FSA_BTO_CustomerSummaryController customerSummaryCtrl = new FSA_BTO_CustomerSummaryController();      
        
        FSA_BTO_Case_Content_Distribution__c testContent = new FSA_BTO_Case_Content_Distribution__c(Case__c = testCase.id, Content_Name__c = 'Test Name', Content_URL__c='https://cloudapps-usda-gov--fsa.cs33.my.salesforce.com/sfc/p/350000000Nok/a/350000004Doq/TxZBEVVGlWhCMOA3WPSFmZug0o2FBsvkAR.hMLIkMHA');
        FSA_BTO_Case_Content_Distribution__c testContentTwo = new FSA_BTO_Case_Content_Distribution__c(Case__c = testCase.id, Content_Name__c = 'Test Name Two', Content_URL__c='https://www.test.com');
        List<FSA_BTO_Case_Content_Distribution__c> urls = new List<FSA_BTO_Case_Content_Distribution__c>();
        urls.add(testContent);
        urls.add(testContentTwo);
        insert urls;
        
        FSA_BTO_CustomerSummaryController customerSummaryCtrl = new FSA_BTO_CustomerSummaryController();      
        
        List<Id> associatedContentIds = new List<Id>();
        associatedContentIds.add(testContent.id);
        associatedContentIds.add(testContentTwo.id);
        
        List<FSA_BTO_Case_Content_Distribution__c> associatedContent = [SELECT Content_Name__c, Content_URL__c FROM FSA_BTO_Case_Content_Distribution__c WHERE id IN: associatedContentIds];
        Map<Id,List<String>> results = customerSummaryCtrl.separateUrlForPrintingContent(associatedContent);
        System.assertEquals(customerSummaryCtrl.splitUrlMapContent, results);
        
        Integer maxCharacterWidth = customerSummaryCtrl.maxCharacterWidth;
        if (customerSummaryCtrl.maxCharacterWidth > testContent.Content_URL__c.length()) {
            maxCharacterWidth = testContent.Content_URL__c.length();
        }
        List<String> actual = results.get(testContent.Id);
        String expected = testContent.Content_URL__c.substring(0, maxCharacterWidth);
        System.assertEquals(expected, actual[0]);
        
        maxCharacterWidth = customerSummaryCtrl.maxCharacterWidth;
        if (customerSummaryCtrl.maxCharacterWidth > testContentTwo.Content_URL__c.length()) {
            maxCharacterWidth = testContentTwo.Content_URL__c.length();
        }
        actual = results.get(testContentTwo.Id);
        expected = testContentTwo.Content_URL__c.substring(0, maxCharacterWidth);
        System.assertEquals(expected, actual[0]);
    }    
    
    public static testMethod void testEmailSummaryAsPDF() {
        RecordType bridgesCustomerIndividualRT = [SELECT Id from RecordType WHERE DeveloperName='FSA_BTO_Customer'];
        Contact testContact = new Contact(LastName='Tester', MailingStreet='123 Fake St', MailingCity='Fakesville', MailingState='Virginia', MailingPostalCode='12345', RecordTypeId=bridgesCustomerIndividualRT.Id);
        insert testContact;
        TIMBASURVEYS__Survey__c testSurvey = new TIMBASURVEYS__Survey__c();
        insert testSurvey;
        Case testCase = new Case(ContactId=testContact.Id, fsa_bto_survey__c = testSurvey.id);
        insert testCase;
        //SHOULD WE SET THE CURRENT PAGE TO BE THE VISUALFORCE PAGE?        
        ApexPages.currentPage().getParameters().put('id', testCase.Id);
        FSA_BTO_CustomerSummaryController summaryController = new FSA_BTO_CustomerSummaryController();
        PageReference emailPage = summaryController.emailSummaryAsPDF();
        Document doc = [SELECT id FROM Document LIMIT 1];
        //Beginning of System Asserts, verify pageRef and URL First
        System.assertNotEquals(null, emailPage);   
        
        String expected = '/_ui/core/email/author/EmailAuthor?doc_id=' +doc.id + '&new_template=true&p2_lkid=' + testContact.id
           + '&p3_lkid=' + testCase.id  + '&p6='+ 'USDA+-+Farm+Service+Agency+Customer+Summary' + '&retURL=%2F' + testCase.id + '&template_id=' + summaryController.customerSummaryEmailTemplate.Id;
        System.assertEquals(expected, emailPage.getUrl());
    }
    
    public static testmethod void testSaveSummaryAsPDF() {
        RecordType bridgesCustomerIndividualRT = [SELECT Id from RecordType WHERE DeveloperName='FSA_BTO_Customer'];
        Contact testContact = new Contact(LastName='Tester', MailingStreet='123 Fake St', MailingCity='Fakesville', MailingState='Virginia', MailingPostalCode='12345', RecordTypeId=bridgesCustomerIndividualRT.Id);
        insert testContact;
        TIMBASURVEYS__Survey__c testSurvey = new TIMBASURVEYS__Survey__c();
        insert testSurvey;
        Case testCase = new Case(ContactId=testContact.Id, fsa_bto_survey__c = testSurvey.id);
        insert testCase;
        //SHOULD WE SET THE CURRENT PAGE TO THE VISUALFORCE PAGE?        
        ApexPages.currentPage().getParameters().put('id', testCase.Id); 
        FSA_BTO_CustomerSummaryController summaryController = new FSA_BTO_CustomerSummaryController();
        summaryController.saveSummaryAsPDF();
        Attachment att = [SELECT Name FROM Attachment WHERE ParentId =: testCase.Id];
        System.assertNotEquals(null, att);
    }
  }
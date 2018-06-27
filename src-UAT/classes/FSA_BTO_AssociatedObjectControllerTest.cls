@isTest
private class FSA_BTO_AssociatedObjectControllerTest
{
    public static testMethod void testAssociatedObjectController()
    {
        // Make a user - insert
        Profile fsaBtoProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
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
            //Create the Customary Summary to be presented by the VisualForce Page
            TIMBASURVEYS__Survey__c testSurvey = new TIMBASURVEYS__Survey__c();
            insert testSurvey;
            Case testCase = new Case(fsa_bto_survey__c = testSurvey.id);
            insert testCase;
            
            testAssociatedContact(testCase);
            testAssociatedExternalLink(testCase);
            testAssociatedEvent(testCase);
        }
    }
    
    public static void testAssociatedContact(Case testCase)
    {
        //Set current page to the New Associated Contact Page
        PageReference newAssociatedContactPage = Page.FSA_BTO_NewAssociatedContact;
        Test.setCurrentPage(newAssociatedContactPage);
            
        //Add an Associated Contact
        RecordType publicPartnerIndividualRT = [SELECT Id from RecordType WHERE DeveloperName='FSA_BTO_Public_Partner'];
        Contact testContact = new Contact(LastName = 'testLastName', MailingStreet='Fake Street', MailingCity='Fake City', MailingState='Virginia', MailingPostalCode='11111', MailingCountry='United States', RecordTypeId=publicPartnerIndividualRT.Id);
        insert testContact;
        FSA_BTO_Case_Contact__c testAssociatedContact = new FSA_BTO_Case_Contact__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Contact__c = testContact.id);
        insert testAssociatedContact;
            
        //Create controller for the VisualForce Page
        FSA_BTO_AssociatedObjectController newAssociatedContactController = new FSA_BTO_AssociatedObjectController(new ApexPages.StandardController(testAssociatedContact));
            
        //Test that there do not exist Associated Contacts
        //List<FSA_BTO_Case_Contact__c> returnedAssociatedContacts = [SELECT id FROM FSA_BTO_Case_Contact__c];
        //System.assertEquals(returnedAssociatedContacts.size(), 0);
            
        //Test saveAndNew saves properly
        newAssociatedContactController.saveAndNew();
        List<FSA_BTO_Case_Contact__c> returnedAssociatedContacts = [SELECT id FROM FSA_BTO_Case_Contact__c];
        System.assertEquals(returnedAssociatedContacts.size(), 1);
            
        //Test that the contact field has been emptied
        System.assertEquals(testAssociatedContact.FSA_BTO_Contact__c, null);
            
        //Test that the Case field is correct
        System.assertEquals(testAssociatedContact.FSA_BTO_Case__c, testCase.id); 
            
        //Set the contact field
        testAssociatedContact.FSA_BTO_Contact__c = testContact.id;
            
        //Test saveRecord redirects properly
        String nextPageUrl = newAssociatedContactController.saveRecord().getUrl();
        System.assertEquals('/' + testCase.id, nextPageUrl);
            
        //Test saveRecord saves properly
        returnedAssociatedContacts = [SELECT id FROM FSA_BTO_Case_Contact__c];
        System.assertEquals(returnedAssociatedContacts.size(), 2);
    }
    
    public static void testAssociatedExternalLink(Case testCase)
    {
        //Set current page to the New Associated Contact Page
        PageReference newAssociatedExternalLinkPage = Page.FSA_BTO_NewAssociatedExternalLink;
        Test.setCurrentPage(newAssociatedExternalLinkPage);
            
        //Add an External Link
        FSA_BTO_External_Link__c testExternalLink = new FSA_BTO_External_Link__c(Name = 'Test Name', FSA_BTO_Link_URL__c = 'www.testurl.com');
        insert testExternalLink;
            
        //Add an Associated External Link
        FSA_BTO_Case_Link__c testAssociatedExternalLink = new FSA_BTO_Case_Link__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_External_Link__c = testExternalLink.id);
            
        //Create controller for the VisualForce Page
        FSA_BTO_AssociatedObjectController newAssociatedExternalLinkController = new FSA_BTO_AssociatedObjectController(new ApexPages.StandardController(testAssociatedExternalLink));
                
        //Test that there do not exist Associated External Links
        List<FSA_BTO_Case_Link__c> returnedAssociatedExternalLinks = [SELECT id FROM FSA_BTO_Case_Link__c];
        System.assertEquals(returnedAssociatedExternalLinks.size(), 0);
            
        //Test saveAndNew saves properly
        newAssociatedExternalLinkController.saveAndNew();
        returnedAssociatedExternalLinks = [SELECT id FROM FSA_BTO_Case_Link__c];
        System.assertEquals(returnedAssociatedExternalLinks.size(), 1);
            
        //Test that the Link Name, URL, and Description fields have been emptied
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_Name__c, null);
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_URL__c, null);
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_Description__c, null);
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_External_Link__c, null);
            
        //Test that the Case field is correct
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Case__c, testCase.id); 
            
        //Set the Link Name and URL fields
        testAssociatedExternalLink.FSA_BTO_Link_Name__c = 'secondTestLinkName';
        testAssociatedExternalLink.FSA_BTO_Link_URL__c = 'www.secondTestURL.com';
        
        //Test saveRecord breaks properly
        testAssociatedExternalLink.FSA_BTO_External_Link__c = testExternalLink.id;
        PageReference nextPage = newAssociatedExternalLinkController.saveRecord();
        System.assertEquals(null, nextPage);
        
        //Test that the fields did not change
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_Name__c, 'secondTestLinkName');
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_URL__c, 'www.secondTestURL.com');
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_External_Link__c, testExternalLink.id);
        
        //test saveandNew breaks properly
        newAssociatedExternalLinkController.saveAndNew();
        
        //Test that the fields did not change
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_Name__c, 'secondTestLinkName');
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_Link_URL__c, 'www.secondTestURL.com');
        System.assertEquals(testAssociatedExternalLink.FSA_BTO_External_Link__c, testExternalLink.id);
        
        //Fix the record
        testAssociatedExternalLink.FSA_BTO_External_Link__c = null;
            
        //Test saveRecord redirects properly
        String nextPageUrl = newAssociatedExternalLinkController.saveRecord().getUrl();
        System.assertEquals('/' + testCase.id, nextPageUrl);
            
        //Test saveRecord saves properly
        returnedAssociatedExternalLinks = [SELECT id FROM FSA_BTO_Case_Link__c];
        System.assertEquals(returnedAssociatedExternalLinks.size(), 2);
    }    
    
    public static void testAssociatedEvent(Case testCase)
    {
        //Set current page to the New Associated Event Page
        PageReference newAssociatedEventPage = Page.FSA_BTO_NewAssociatedEvent;
        Test.setCurrentPage(newAssociatedEventPage);
            
        //Add an Associated Event
        Event testEvent = new Event(Subject='testSubject', DurationInMinutes=60, ActivityDateTime=Datetime.now());
        insert testEvent;
        FSA_BTO_Event_Info__c testEventInfo = [SELECT id from FSA_BTO_Event_Info__c];
        //insert testEventInfo;
        FSA_BTO_Case_Event_Info__c testAssociatedEvent = new FSA_BTO_Case_Event_Info__c(FSA_BTO_Case__c = testCase.id, FSA_BTO_Event_Info__c = testEventInfo.id);
            
        //Create controller for the VisualForce Page
        FSA_BTO_AssociatedObjectController newAssociatedEventController = new FSA_BTO_AssociatedObjectController(new ApexPages.StandardController(testAssociatedEvent));
                
        //Test that there do not exist Associated Events
        List<FSA_BTO_Case_Event_Info__c> returnedAssociatedEvents = [SELECT id FROM FSA_BTO_Case_Event_Info__c];
        System.assertEquals(returnedAssociatedEvents.size(), 0);
            
        //Test saveAndNew saves properly
        newAssociatedEventController.saveAndNewEvent();
        returnedAssociatedEvents = [SELECT id FROM FSA_BTO_Case_Event_Info__c];
        System.assertEquals(returnedAssociatedEvents.size(), 1);
            
        //Test that the Event Info field has been emptied
        //System.assertEquals(testAssociatedEvent.FSA_BTO_Event_Info__c, null);
            
        //Test that the Case field is correct
        System.assertEquals(testAssociatedEvent.FSA_BTO_Case__c, testCase.id); 
            
        //Set the Event Info field
        testAssociatedEvent.FSA_BTO_Event_Info__c = testEventInfo.id;
            
        //Test saveRecord redirects properly
        String nextPageUrl = newAssociatedEventController.saveRecord().getUrl();
        System.assertEquals('/' + testCase.id, nextPageUrl);
            
        //Test saveRecord saves properly
        returnedAssociatedEvents = [SELECT id FROM FSA_BTO_Case_Event_Info__c];
        System.assertEquals(returnedAssociatedEvents.size(), 2);
    }      
}
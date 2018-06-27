global without sharing class FSA_BTO_CustomerSummaryController {
        public EmailTemplate customerSummaryEmailTemplate { get; set; }
        public Case currentCase { get; set; }
        public User caseOwner { get; set; }
        public List<KnowledgeArticleVersion> articles { get; set; }
        public List<Task> referrals { get; set; }
        public List<FSA_BTO_Case_Contact__c> contacts { get; set; }
        public List<FSA_BTO_Case_Event_Info__c> events { get; set; }
        public List<FSA_BTO_Case_Link__c> links { get; set; }
        public List<FSA_BTO_Case_Content_Distribution__c> contents { get; set; }
        public List<FSA_BTO_Case_Organization__c> organizations { get; set; }
        public List<ContentDistribution> contentDistributions { get; set; }
        
        public FSA_BTO_CustomerSummaryController() {
            customerSummaryEmailTemplate = [SELECT e.Id, e.Subject FROM EmailTemplate e WHERE e.Name = 'FSA BTO Customer Summary'];
            
            currentCase = [SELECT 
                                Id, 
                                Subject,
                                CaseNumber,
                                ContactId,
                                Contact.Name,
                                Contact.MailingStreet,
                                Contact.MailingCity,
                                Contact.MailingStateCode,
                                Contact.MailingPostalCode,
                                Description,
                                Origin,
                                FSA_BTO_Non_SCIMS_Customer_Name__c,
                                FSA_BTO_Service_Requested__c, 
                                FSA_BTO_Service_Request_Description__c, 
                                FSA_BTO_Additional_Items_Provided__c,
                                FSA_BTO_Additional_Items_Provided_Detail__c,
                                FSA_BTO_Additional_Items_Received__c,
                                FSA_BTO_Additional_Items_Received_Detail__c,
                                FSA_BTO_Date_Of_Service__c, 
                                FSA_BTO_Agency__c,
                                OwnerId,
                                FSA_BTO_Customer_Summary_Attached__c,
                                FSA_BTO_Office_Lookup__r.Name,
                                FSA_BTO_Office_Lookup__r.FSA_BTO_StreetAddress__c,
                                FSA_BTO_Office_Lookup__r.FSA_BTO_City__c,
                                FSA_BTO_Office_Lookup__r.FSA_BTO_State__c,
                                FSA_BTO_Office_Lookup__r.FSA_BTO_Zip_Code__c,
                                FSA_BTO_Office_Lookup__r.FSA_BTO_Phone__c
                            FROM 
                                Case 
                            WHERE 
                                id =: urlCaseId 
                            LIMIT 1];
            
            caseOwner = [SELECT
                            Name,
                            Street,
                            City,
                            StateCode,
                            PostalCode,
                            Phone,
                            Email,
                            Title
                        FROM
                            User
                        WHERE
                            Id =: currentCase.OwnerId
                        LIMIT 1];
                                                
            List<CaseArticle> ca = new List<CaseArticle>();
            ca = [SELECT Id, KnowledgeArticleId from CaseArticle where CaseId =: currentCase.id];
            Set<id> ka = new Set<id>();
            for(CaseArticle c : ca) {
                ka.add(c.KnowledgeArticleId);
            }
            articles = [Select kav.Title, kav.Summary from KnowledgeArticleVersion kav where kav.KnowledgeArticleId =: ka and kav.IsLatestVersion=true and PublishStatus='Online' and Language='en_US'];
            
            // using custom lookup field FSA_BTO_User__c until SOQL Polymorphism feature is enabled
            referrals = [SELECT 
                            Status,
                            FSA_BTO_User__r.Id,
                            FSA_BTO_User__r.Name,
                            FSA_BTO_Account__r.Name,
                            FSA_BTO_User__r.Title,
                            FSA_BTO_User__r.FSA_BTO_Specializes_In__c,
                            FSA_BTO_User__r.FSA_BTO_Office_County__c,
                            FSA_BTO_User__r.Phone,                           
                            FSA_BTO_User__r.Email,                           
                            FSA_BTO_User__r.Street,                           
                            FSA_BTO_User__r.City,
                            FSA_BTO_User__r.StateCode,
                            FSA_BTO_User__r.PostalCode                            
                        FROM 
                            Task 
                        WHERE 
                            WhatId =: urlCaseId
                        AND
                            FSA_BTO_User__c != null
                        AND
                            Subject LIKE '%Referral%'
                        AND
                            (Status='Referral In Progress'
                        OR
                            Status='Referral Completed'
                        OR
                            Status='Closed')];
                    
            contacts = [SELECT 
                            FSA_BTO_Contact_Name__c, 
                            FSA_BTO_Contact_Phone__c, 
                            FSA_BTO_Contact_Email__c, 
                            FSA_BTO_Contact_Mobile__c, 
                            FSA_BTO_Contact_Account__c,
                            FSA_BTO_Contact_Title__c, 
                            FSA_BTO_Contact__r.FSA_BTO_Specializes_In__c, 
                            FSA_BTO_Contact_Address__c 
                        FROM 
                            FSA_BTO_Case_Contact__c 
                        WHERE 
                            FSA_BTO_Case__r.id =: urlCaseId];
                            
            organizations = [SELECT
                                FSA_BTO_Organization__c, 
                                FSA_BTO_Organization_Address__c, 
                                //FSA_BTO_Organization_Description__c, 
                                FSA_BTO_Organization__r.Description,
                                FSA_BTO_Organization_Email__c,   
                                FSA_BTO_Organization_Name__c,    
                                FSA_BTO_Organization_Phone__c,   
                                FSA_BTO_Organization_Website__c,
                                FSA_BTO_Organization__r.FSA_BTO_Services_offered__c
                            FROM
                                FSA_BTO_Case_Organization__c
                            WHERE
                                FSA_BTO_Customer_Interaction__r.id =: urlCaseId];
    
                                            
            events = [SELECT 
                        FSA_BTO_Event_Name__c,
                        FSA_BTO_Event_Type__c,
                        FSA_BTO_Event_Start__c, 
                        FSA_BTO_Event_End__c, 
                        FSA_BTO_Event_Venue__c,
                        FSA_BTO_Event_Location__c, 
                        FSA_BTO_Event_Description__c,
                        FSA_BTO_POC__c,
                        FSA_BTO_POC_Email__c,
                        FSA_BTO_POC_Phone__c,
                        FSA_BTO_Event_Id__c,
                        FSA_BTO_Event_RSVP_Date__c,
                        FSA_BTO_Event_URL__c,
                        FSA_BTO_Event_Fee__c
                    FROM 
                        FSA_BTO_Case_Event_Info__c 
                    WHERE 
                        FSA_BTO_Case__r.id =: urlCaseId];
            links = [SELECT  
                        FSA_BTO_Display_Link_Description__c, 
                        FSA_BTO_Display_Link_Name__c, 
                        FSA_BTO_Display_Link_URL__c 
                    FROM 
                        FSA_BTO_Case_Link__c 
                    WHERE 
                        FSA_BTO_Case__r.id =: urlCaseId];
                                        
            contents = [SELECT 
                            Content_Name__c, 
                            Content_URL__c,
                            FSA_BTO_Description__c,
                            FSA_BTO_Expiration_Date__c
                        FROM 
                            FSA_BTO_Case_Content_Distribution__c 
                        WHERE 
                            Case__r.id =: urlCaseId]; 
            
            List<FeedItem> caseFeedItems = [SELECT
                                                RelatedRecordId,
                                                Visibility,
                                                NetworkScope,
                                                Title,
                                                Type
                                            FROM 
                                                FeedItem
                                            WHERE
                                                ParentId =: urlCaseId];
            List<FeedItem> eventFeedItems = new List<FeedItem>();
            for(FSA_BTO_Case_Event_Info__c e: events) {
                List<FeedItem> feedItems = [SELECT
                                                RelatedRecordId
                                            FROM 
                                                FeedItem
                                            WHERE
                                                ParentId =: e.FSA_BTO_Event_Id__c];
                for(FeedItem fi: feedItems) {
                    eventFeedItems.add(fi);
                }
            }
            
            List<ContentWorkspace> officialBridgesDocumentsLibrary = [SELECT
                                                                        Id
                                                                    FROM
                                                                        ContentWorkspace
                                                                    WHERE
                                                                        Name = 'Bridges to Opportunity Official Documents'];
            
            List<ContentDocument> promoContentDocuments = new List<ContentDocument>();
            if(!officialBridgesDocumentsLibrary.isEmpty()) {
                promoContentDocuments = [SELECT
                                            Id
                                        FROM
                                            ContentDocument
                                        WHERE
                                            ParentId =: officialBridgesDocumentsLibrary[0].Id
                                        AND
                                            Title LIKE '%Latest Bridges Promotion%'
                                        AND
                                            PublishStatus = 'P'];
            }
                                                        
            //if(!caseFeedItems.isEmpty() || !eventFeedItems.isEmpty() || !promoContentDocuments.isEmpty()) {
                contentDistributions = new List<ContentDistribution>();
            //}
    
            if(!caseFeedItems.isEmpty()) {
                getAttachmentLinks(caseFeedItems);
            }
            
            if(!eventFeedItems.isEmpty()) {
                getAttachmentLinks(eventFeedItems);
            }
    
            if(!promoContentDocuments.isEmpty()) {
                List<ContentDistribution> promoContentDistributions = new List<ContentDistribution>();
                for(ContentDocument conDoc: promoContentDocuments) {
                    promoContentDistributions = [SELECT Name, DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId =: conDoc.Id];
                    if(!promoContentDistributions.isEmpty()) contentDistributions.add(promoContentDistributions[0]);
                }
            }  
        }
        
        public String userName {
            get {
                return UserInfo.getName();
            }
            set;
        }
        
        public Integer maxCharacterWidth {
            get { 
                return 60; 
            }
        }
        
        public Id urlCaseId {
            get {
                return ApexPages.currentPage().getParameters().get('id');
            }
            set;
        }
        
        public Id customerSummaryFolderId {
            get {
                Folder summaryFolder  = [SELECT Id
                                FROM Folder
                                WHERE Name = 'CustomerSummaries'
                                LIMIT 1];
                return summaryFolder.Id; 
            }
        }
        
        public List<String> servicesRequested {
            get { 
                if(currentCase.FSA_BTO_Service_Requested__c != null) {
                    return currentCase.FSA_BTO_Service_Requested__c.split(';'); 
                } else {
                    return null;
                }
            }
            set;
        }
            
        public List<String> itemsProvided {
            get { 
                if(currentCase.FSA_BTO_Additional_Items_Provided__c != null) {
                    return currentCase.FSA_BTO_Additional_Items_Provided__c.split(';'); 
                } else {
                    return null;
                }
            }
            set;
        }
    
        public List<String> itemsReceived {
            get { 
                if(currentCase.FSA_BTO_Additional_Items_Received__c != null) {
                    return currentCase.FSA_BTO_Additional_Items_Received__c.split(';'); 
                } else {
                    return null;
                }
            }
            set;
        }
        
        /*
        public List<String> actionsTaken {
            get { 
                if(currentCase.FSA_BTO_Action_Taken__c != null) {
                    return currentCase.FSA_BTO_Action_Taken__c.split(';'); 
                } else {
                    return null;
                }
            }
            set;
        }
        */
        
        public Integer articlesSize {
            get {
                return articles.size();
            }
            set;
        }
        
        public Boolean containsArticles {
            get {
                if (articlesSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
            
        public Boolean containsReferrals {
            get {
                if (referralsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
        
        public Integer referralsSize {
            get {
                return referrals.size();
            }
            set;
        }
                
        public Integer contactsSize {
            get {
                return contacts.size();
            }
            set;
        }
        
        public Boolean containsContacts {
            get {
                if (contactsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
        
        public Integer organizationsSize {
            get {
                return organizations.size();
            }
            set;
        }
        
        public Boolean containsOrganizations {
            get {
                if (organizationsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
            
        public Integer eventsSize {
            get {
                return events.size();
            }
            set;
        }
        
        public Boolean containsEvents {
            get {
                if (eventsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }    
    
        public Map<Id,List<String>> splitUrlMap {
            get {
                return separateUrlForPrinting(links);
            }
            set;
        }
        
        public Map<Id,List<String>> splitUrlMapContent {
            get {
                return separateUrlForPrintingContent(contents);
            }
            set;
        }
        
        public Map<Id,List<String>> splitUrlMapAttachment {
            get {
                return separateUrlForPrintingAttachment(contentDistributions);
            }
            set;
        }
        
        public Integer linksSize {
            get {
                return links.size();
            }
            set;
        }
        
        public Boolean containsLinks {
            get {
                if (linksSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
            
        public Integer contentsSize {
            get {
                return contents.size();
            }
            set;
        }
        
        public Boolean containsContents {
            get {
                if (contentsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
            
        public Integer attachmentsSize {
            get {
                return contentDistributions.size();
            }
            set;
        }
        
        public Boolean containsAttachments {
            get {
                if (attachmentsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
        
        /*
        public Integer promotionUrlsSize {
            get {
                return promotionUrls.size();
            }
            set;
        }
        
        public Boolean promotionExists {
            get {
                if (promotionUrlsSize != 0) {
                    return true;
                } else {
                    return false;
                }
            }
            set;
        }
        */
        
        public void getAttachmentLinks(List<FeedItem> feedItems) {
            for(FeedItem fi: feedItems) {
                if(fi.RelatedRecordId != null) {
                    List<ContentDistribution> cds = [SELECT
                                                        Name,
                                                        DistributionPublicUrl
                                                    FROM
                                                        ContentDistribution
                                                    WHERE
                                                        ContentVersionId =: fi.RelatedRecordId];
                    contentDistributions.addAll(cds);
                }
            }
        }
    
        public PageReference emailSummaryAsPDF() {              
            PageReference pr = Page.FSA_BTO_CustomerSummary;
            pr.getParameters().put('id', urlCaseId);
            Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pr.getContentAsPDF();
            if(!String.isBlank(currentCase.Subject)){
            Document doc = new Document(Body=content, Name = currentCase.Subject + '- USDA FSA Bridges Customer Summary-' + currentCase.CaseNumber + '.pdf', FolderId=customerSummaryFolderId);
            Database.insert(doc);
            String emailURL = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + currentCase.id 
            + '&doc_id=' + doc.id + '&p6='+ customerSummaryEmailTemplate.Subject + '&retURL=%2F' + urlCaseId + '&template_id=' + customerSummaryEmailTemplate.Id + '&new_template=true';
            if (currentCase.ContactId != null) {
              emailURL += '&p2_lkid=' + currentCase.ContactId;
            }
            PageReference emailPage = new PageReference(emailURL);
            emailPage.setRedirect(true);
            return emailPage;       
            } else {
            Document doc = new Document(Body=content, Name = 'USDA FSA Bridges Customer Summary-' + currentCase.CaseNumber + '.pdf', FolderId=customerSummaryFolderId);
            Database.insert(doc);
            String emailURL = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + currentCase.id 
            + '&doc_id=' + doc.id + '&p6='+ customerSummaryEmailTemplate.Subject + '&retURL=%2F' + urlCaseId + '&template_id=' + customerSummaryEmailTemplate.Id + '&new_template=true';
            if (currentCase.ContactId != null) {
              emailURL += '&p2_lkid=' + currentCase.ContactId;
            }
            PageReference emailPage = new PageReference(emailURL);
            emailPage.setRedirect(true);
            return emailPage;       
            }

            //Attachment att = new Attachment(Body = content, Name = 'Summary_'+ currentCase.CaseNumber +'.pdf', ParentId = currentCase.id);
            //insert att;
          
        }
    
        public void saveSummaryAsPDF() {      
            currentCase.FSA_BTO_Customer_Summary_Attached__c = true;
            update currentCase;
            PageReference pr = Page.FSA_BTO_CustomerSummary;
            pr.getParameters().put('id', urlCaseId);
            Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pr.getContentAsPDF();
            //PERHAPS CONTACT NAME + DATE FOR NAME?
            
            if(!String.isBlank(currentCase.Subject)){
            Attachment att = new Attachment(Body = content, Name = currentCase.Subject + '- USDA FSA Bridges Customer Summary-' + currentCase.CaseNumber +'.pdf', ParentId = currentCase.id);
            insert att;  
            } else {
            Attachment att = new Attachment(Body = content, Name = 'USDA FSA Bridges Customer Summary-' + currentCase.CaseNumber +'.pdf', ParentId = currentCase.id);
            insert att;  
            }
        }
        
        webservice static void unshareCustomerSummaryAttachment(String caseId) {
            List<FeedItem> caseCustomerSummaryFeedItems = [SELECT Id, Visibility FROM FeedItem WHERE ParentId =: caseId AND Type = 'CreateRecordEvent' AND Visibility = 'AllUsers'];
            System.debug(caseCustomerSummaryFeedItems);
            for(FeedItem fi: caseCustomerSummaryFeedItems) {
                fi.Visibility = 'InternalUsers';
                update fi;
            }
        }
        
        public PageReference cancelSummaryPreview() {
            return new PageReference('/' + urlCaseId); 
        }
        
        public Map<Id,List<String>> separateUrlForPrinting(List<FSA_BTO_Case_Link__c> links) {
            Map<Id,List<String>> separatedUrl = new Map<Id, List<String>>();
            for(FSA_BTO_Case_Link__c l: links){
                List<String> toInsert = new List<String>();
                if (l.FSA_BTO_Display_Link_URL__c.length() > maxCharacterWidth){
                Integer temp = 0;
                    for(Integer i=0; i < l.FSA_BTO_Display_Link_URL__c.length()-maxCharacterWidth; i += maxCharacterWidth){
                        toInsert.add(l.FSA_BTO_Display_Link_URL__c.substring(i, i+maxCharacterWidth));
                        temp = i;
                    }
                    toInsert.add(l.FSA_BTO_Display_Link_URL__c.substring(temp + maxCharacterWidth));
                } else {
                    toInsert.add(l.FSA_BTO_Display_Link_URL__c);
                }
                separatedUrl.put(l.Id,toInsert);  
            }
            return separatedUrl;
        }
        
        public Map<Id,List<String>> separateUrlForPrintingContent(List<FSA_BTO_Case_Content_Distribution__c> links) {
            Map<Id,List<String>> separatedUrl = new Map<Id, List<String>>();
            for(FSA_BTO_Case_Content_Distribution__c l: links){
                List<String> toInsert = new List<String>();
                if (l.Content_URL__C.length() > maxCharacterWidth){
                Integer temp = 0;
                    for(Integer i=0; i < l.Content_URL__C.length()-maxCharacterWidth; i += maxCharacterWidth){
                        toInsert.add(l.Content_URL__C.substring(i, i+maxCharacterWidth));
                        temp = i;
                    }
                    toInsert.add(l.Content_URL__C.substring(temp + maxCharacterWidth));
                } else {
                    toInsert.add(l.Content_URL__C);
                }
                separatedUrl.put(l.Id,toInsert);  
            }
            return separatedUrl;
        }
        
        public Map<Id,List<String>> separateUrlForPrintingAttachment(List<ContentDistribution> links) {
            Map<Id,List<String>> separatedUrl = new Map<Id, List<String>>();
            for(ContentDistribution l: links){
                List<String> toInsert = new List<String>();
                if (l.DistributionPublicUrl.length() > maxCharacterWidth){
                Integer temp = 0;
                    for(Integer i=0; i < l.DistributionPublicUrl.length()-maxCharacterWidth; i += maxCharacterWidth){
                        toInsert.add(l.DistributionPublicUrl.substring(i, i+maxCharacterWidth));
                        temp = i;
                    }
                    toInsert.add(l.DistributionPublicUrl.substring(temp + maxCharacterWidth));
                } else {
                    toInsert.add(l.DistributionPublicUrl);
                }
                separatedUrl.put(l.Id,toInsert);  
            }
            return separatedUrl;
        }
    }
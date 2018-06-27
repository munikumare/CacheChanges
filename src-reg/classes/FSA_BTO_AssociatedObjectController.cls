public class FSA_BTO_AssociatedObjectController{
    public sObject record { get; set; }
    
    public FSA_BTO_AssociatedObjectController(ApexPages.StandardController standardCtrl) {
        System.Debug('Enter FSA_BTO_AssociatedObjectController');
        record = standardCtrl.getRecord();
        System.debug(record);
        System.Debug('Exit FSA_BTO_AssociatedObjectController');
    }
    
    public PageReference saveEvent() {
        Id thisCase = (Id)record.get('FSA_BTO_Case__c');
        PageReference casePage = new PageReference('/' + thisCase);
        casePage.setRedirect(true);
        String fromInfo = (String)record.get('FSA_BTO_Event_Info__c');
        List<FSA_BTO_Event_Info__c> eventId = [SELECT FSA_BTO_Event_Id__c FROM FSA_BTO_Event_Info__c WHERE Id = :fromInfo LIMIT 1];
        List<Event> toCopy = [SELECT Id, Subject, FSA_BTO_Venue_Name__c, FSA_BTO_Phone_Number__c, FSA_BTO_Location__c, FSA_BTO_Event_Type__c, FSA_BTO_EventZipCode__c, FSA_BTO_EventStreet__c, FSA_BTO_EventState__c, FSA_BTO_EventCountry__c, FSA_BTO_EventCity__c, FSA_BTO_Email_Address__c, FSA_BTO_Event_Point_of_Contact__c, EndDateTime, Description, StartDateTime FROM Event WHERE Id = :eventId[0].FSA_BTO_Event_Id__c LIMIT 1];
        FSA_BTO_Case_Event_Info__c toInsert = new FSA_BTO_Case_Event_Info__c();
        toInsert.FSA_BTO_Case__c = thisCase;
        //toInsert.FSA_BTO_Event_Info__c 
        toInsert.FSA_BTO_Event_Name__c = toCopy[0].Subject;
        toInsert.FSA_BTO_Event_Type__c = toCopy[0].FSA_BTO_Event_Type__c;
        toInsert.FSA_BTO_Event_Description__c = toCopy[0].Description;
        toInsert.FSA_BTO_Event_Start__c = toCopy[0].StartDateTime;
        toInsert.FSA_BTO_Event_End__c = toCopy[0].EndDateTime;
        toInsert.FSA_BTO_Event_Venue__c = toCopy[0].FSA_BTO_Venue_Name__c;
        toInsert.FSA_BTO_Event_Location__c = toCopy[0].FSA_BTO_EventStreet__c + ' ' + toCopy[0].FSA_BTO_EventCity__c+ ' ' + toCopy[0].FSA_BTO_EventState__c + ' ' + toCopy[0].FSA_BTO_EventZipCode__c + '\r\n' + toCopy[0].FSA_BTO_EventCountry__c;
        toInsert.FSA_BTO_POC__c = toCopy[0].FSA_BTO_Event_Point_of_Contact__c;
        toInsert.FSA_BTO_POC_Email__c = toCopy[0].FSA_BTO_Email_Address__c;
        toInsert.FSA_BTO_POC_Phone__c = toCopy[0].FSA_BTO_Phone_Number__c;
        toInsert.FSA_BTO_Event_Id__c = toCopy[0].Id;
    
        try {
            upsert toInsert;
            return casePage;
        } catch(exception e) {
            ApexPages.addMessages(e);
            System.debug('SaveEventException');
            return null;
        }
    }
    
    public PageReference saveAndNewEvent() {
        try {
            saveEvent();
            PageReference pageRef = ApexPages.currentPage();
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(exception e) {
            ApexPages.addMessages(e);
            System.debug('SaveAndNewEventException');
        }
       PageReference pageRef = ApexPages.currentPage();
       pageRef.setRedirect(true);
       return pageRef;
    }
    
    public PageReference saveRecord() {
        PageReference casePage = new PageReference('/' + record.get('FSA_BTO_Case__c'));
        casePage.setRedirect(true);
        try {
            upsert record;
            return casePage;
        }
        catch(exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    public void saveAndNew() {
        try {
            upsert record;
            Id caseId = String.valueOf(record.get('FSA_BTO_Case__c'));
            record.clear();
            record.put('FSA_BTO_Case__c', caseId);
        } catch(exception e) {
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference cancel() {
        return new PageReference('/' + String.valueOf(record.get('FSA_BTO_Case__c'))); 
    }
}
@isTest
private class FSA_BTO_EventTriggerTest 
{    
    static testMethod void testSingleEventInfo()
    {
        // Make an event and insert, check for event info
        Event singleEvent = new Event();
        singleEvent.Subject = 'Meeting';
        singleEvent.FSA_BTO_Venue_Name__c = 'Conference Room';
        singleEvent.DurationInMinutes = 30;
        singleEvent.StartDateTime = DateTime.newInstance(2015,11,11);
        insert singleEvent;
        String eventIdString = String.valueOf(singleEvent.Id);   
        List<FSA_BTO_Event_Info__c> newInfo = [Select f.Id, f.FSA_BTO_Subject__c From FSA_BTO_Event_Info__c f where f.FSA_BTO_Event_Id__c = :eventIdString];
        System.assertEquals(newInfo.size(), 1);
        System.assertEquals(newInfo[0].FSA_BTO_Subject__c, singleEvent.Subject);
    
        // Change the event and make sure the change happened
        singleEvent.FSA_BTO_Venue_Name__c = 'Disneyland';
        update singleEvent;       
        newInfo = [Select f.Id, f.FSA_BTO_Venue__c From FSA_BTO_Event_Info__c f where f.FSA_BTO_Event_Id__c = :eventIdString];
        System.assertEquals(newInfo.size(), 1);
        System.assertEquals(newInfo[0].FSA_BTO_Venue__c, singleEvent.FSA_BTO_Venue_Name__c );
        
        delete singleEvent;      
        List<FSA_BTO_Event_Info__c> eventInfos = [Select f.Id from FSA_BTO_Event_Info__c f where f.FSA_BTO_Event_Id__c = :eventIdString];
        System.assert(eventInfos.isEmpty());
    }
    
    static testMethod void testBulkEventInfo()
    {
        // Make 200 events and insert, check for event info
        List<Event> bulkEvents = new List<Event>();
        
        for(Integer i=0; i<200; i++){
            Event temp = new Event();
            temp.Subject = 'Meeting' + String.valueOf(i);
            temp.FSA_BTO_Venue_Name__c  = 'Conference Room';
            temp.DurationInMinutes = 30;
            temp.StartDateTime = DateTime.newInstance(2015,11,11);
            bulkEvents.add(temp);
        }
        insert bulkEvents;
        Set<String> eventIds = new Set<String>();
        for(Event e : bulkEvents)
        {
            eventIds.add(e.Id);
        }
        
           
        System.AssertEquals(eventIds.size(), 200);
        List< FSA_BTO_Event_Info__c> newEventInfos = [Select Id,FSA_BTO_Venue__c from FSA_BTO_Event_Info__c f where f.FSA_BTO_Event_Id__c in :eventIds];
        System.AssertEquals(newEventInfos.size(), 200);
        // Change 200 events and make sure change happened
        
        List< FSA_BTO_Event_Info__c> updatedEventInfos = [Select Id,FSA_BTO_Venue__c from FSA_BTO_Event_Info__c f where f.FSA_BTO_Venue__c = 'Here'];
        System.Assert(updatedEventInfos.isEmpty());
        
        for(Event e : bulkEvents){
            e.FSA_BTO_Venue_Name__c  = 'Here';
        }
        update bulkEvents;
                  
        updatedEventInfos = [Select Id,FSA_BTO_Venue__c from FSA_BTO_Event_Info__c f where f.FSA_BTO_Venue__c = 'Here'];
        System.AssertEquals(UpdatedEventInfos.size(), 200);
        
        delete bulkEvents;     
        List<FSA_BTO_Event_Info__c> eventInfos = [Select f.Id from FSA_BTO_Event_Info__c f where f.FSA_BTO_Event_Id__c in :eventIds];
        System.assertEquals(true, eventInfos.isEmpty());
    }
}
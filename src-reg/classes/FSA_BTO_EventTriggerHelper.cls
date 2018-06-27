public class FSA_BTO_EventTriggerHelper {
    public static void CreateEventInfoRecord(List<Event> newEvents) {
        List<FSA_BTO_Event_Info__c> toInsert = new List<FSA_BTO_Event_Info__c>();        
        for(Event e: newEvents) {    
            FSA_BTO_Event_Info__c temp = new FSA_BTO_Event_Info__c ();     
            temp.FSA_BTO_Event_Id__c = e.id;
            temp.FSA_BTO_Subject__c = e.Subject;            
            temp.FSA_BTO_Type__c = e.FSA_BTO_Event_Type__c;
            temp.FSA_BTO_Description__c = e.Description;
            temp.FSA_BTO_StartDateTime__c = e.StartDateTime;
            temp.FSA_BTO_EndDateTime__c = e.EndDateTime;
            temp.FSA_BTO_Venue__c = e.FSA_BTO_Venue_Name__c;
            temp.FSA_BTO_Location__c = e.FSA_BTO_EventStreet__c + ' ' + e.FSA_BTO_EventCity__c+ ' ' + e.FSA_BTO_EventState__c + ' ' + e.FSA_BTO_EventZipCode__c + ' ' + e.FSA_BTO_EventCountry__c;
            temp.FSA_BTO_POC__c = e.FSA_BTO_Event_Point_of_Contact__c;
            temp.FSA_BTO_Phone__c = e.FSA_BTO_Phone_Number__c;
            temp.FSA_BTO_Email__c = e.FSA_BTO_Email_Address__c;
            toInsert.add(temp);
        }
        try{ 
            insert toInsert;
        } catch(system.Dmlexception ex) {
            //WE SHOULD DO SOMETHING MORE GRACEFUL. ATTACH THE ERROR TO THE RECORD OR SOMETHING?       
            system.debug(ex);
        }
    }
        
    public static void UpdateEventInfoRecord(List<Event> changedEvents) {
        Set<String> eventIds = new Set<String>();
        for(Event c: changedEvents) {
            eventIds.add(String.valueOf(c.Id));
        }
             
        List<FSA_BTO_Event_Info__c> toUpdate = [SELECT f.Id, 
                                                    f.FSA_BTO_Event_Id__c, 
                                                    f.FSA_BTO_Subject__c, 
                                                    f.FSA_BTO_Type__c,
                                                    f.FSA_BTO_Description__c,
                                                    f.FSA_BTO_StartDateTime__c,  
                                                    f.FSA_BTO_EndDateTime__c,
                                                    f.FSA_BTO_Venue__c,
                                                    f.FSA_BTO_Location__c,
                                                    f.FSA_BTO_POC__c,
                                                    f.FSA_BTO_Phone__c,
                                                    f.FSA_BTO_Email__c
                                                FROM 
                                                    FSA_BTO_Event_Info__c f 
                                                WHERE 
                                                    f.FSA_BTO_Event_Id__c IN :eventIds                                        
                                               ];
    
        Map<ID,Event> changedEventsMap = new Map<ID,Event>(changedEvents);
            
        for(FSA_BTO_Event_Info__c temp: toUpdate) {    
            Event e = changedEventsMap.get(temp.FSA_BTO_Event_Id__c);
            temp.FSA_BTO_Subject__c = e.Subject;
            temp.FSA_BTO_Type__c = e.FSA_BTO_Event_Type__c;
            temp.FSA_BTO_Description__c = e.Description;
            temp.FSA_BTO_StartDateTime__c = e.StartDateTime;
            temp.FSA_BTO_EndDateTime__c = e.EndDateTime;
            temp.FSA_BTO_Venue__c = e.FSA_BTO_Venue_Name__c;
            temp.FSA_BTO_Location__c = e.FSA_BTO_EventStreet__c + ' ' + e.FSA_BTO_EventCity__c+ ' ' + e.FSA_BTO_EventState__c + ' ' + e.FSA_BTO_EventZipCode__c + ' ' + e.FSA_BTO_EventCountry__c;
            temp.FSA_BTO_POC__c = e.FSA_BTO_Event_Point_of_Contact__c;
            temp.FSA_BTO_Phone__c = e.FSA_BTO_Phone_Number__c;
            temp.FSA_BTO_Email__c = e.FSA_BTO_Email_Address__c;
        }
        try { 
            update toUpdate;
        } catch(system.Dmlexception ex) {
            //WE SHOULD DO SOMETHING MORE GRACEFUL. ATTACH THE ERROR TO THE RECORD OR SOMETHING?
            system.debug(ex);
        }
    }
    
    public static void DeleteEventInfoRecord(List<Event> deletedEvents){
        Set<String> eventIds = new Set<String>();
        for(Event d: deletedEvents){eventIds.add(String.valueOf(d.Id));}
        List<FSA_BTO_Event_Info__c> toDelete = [Select e.Id from FSA_BTO_Event_Info__c e where e.FSA_BTO_Event_Id__c in :eventIds];
        try {
            delete toDelete;
        } catch(system.Dmlexception ex) {
            system.debug(ex);
        }
    }
}
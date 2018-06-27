public class FSA_BTO_LocationCallouts {
     
     @future (callout=true)  // future method needed to run callouts from Triggers
     static public void getUserLocation(Set<Id> users){
         for(Id userId : users){
             String address = buildUserAddress(userId);
             Http h = new Http();
             HttpRequest req = buildWebServiceRequest(address);
             try{
                 HttpResponse res;
                 res = h.send(req);
                 handleUserWebServiceResponse(res, userId);            
             } catch (Exception e) {
             }
        }    
    }
    
    @future (callout=true)  // future method needed to run callouts from Triggers
    static public void getIndividualLocation(Set<Id> contacts){
        for(Id contactId : contacts){
            // create an address string
            String address = buildContactAddress(contactId);
            // build callout
            Http h = new Http();
            HttpRequest req = buildWebServiceRequest(address);
            try{
                // callout
                HttpResponse res;
                res = h.send(req);
                handleContactWebServiceResponse(res, contactId);      
            } catch (Exception e) {
            }
        }
    }
    
    @future (callout=true)  // future method needed to run callouts from Triggers
    static public void getAccountLocation(Set<Id> accounts){
        for(Id accountId : accounts){           
            // create an address string
            String address = buildAccountAddress(accountId);
            // build callout
            Http h = new Http();
            HttpRequest req = buildWebServiceRequest(address);
            try{
                HttpResponse res;
                res = h.send(req);
                // parse coordinates from response
                handleAccountWebServiceResponse(res, accountId);
            } catch (Exception e) {
            }
        }
    }
    
    @future (callout=true)  // future method needed to run callouts from Triggers
    static public void getEventLocation(Set<Id> events){
        for(Id eventId : events){
            // create an address string
            String address = buildEventAddress(eventId);
            // build callout
            Http h = new Http();
            HttpRequest req = buildWebServiceRequest(address);
            try{
                // callout
                HttpResponse res;
                res = h.send(req);
                handleEventWebServiceResponse(res, eventId);
            } catch (Exception ex) {
            }
        }
    }
    
    public static HttpRequest buildWebServiceRequest(String address){       
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
        return req;
    }
    
    public static String buildUserAddress(Id userId){
     // gather account info
        User u = [SELECT Street, State, PostalCode, City From User WHERE id =: userId];
        // create an address string
        String address = '';
        if (u.Street != null)
            address += u.Street +', ';
        if (u.City != null)
            address += u.City +', ';
        if (u.State != null)
            address += u.State +' ';
        if (u.PostalCode != null)
            address += u.PostalCode +', ';
        //if (a.BillingCountry != null)
            //address += a.BillingCountry;
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        return address;
    }
    
        public static String buildContactAddress(Id contactId){
        Contact c = [SELECT MailingStreet, MailingState, MailingPostalCode, MailingCity From Contact WHERE id =: contactId];
        // create an address string
        String address = '';
        if (c.MailingStreet != null)
            address += c.MailingStreet +', ';
        if (c.MailingCity != null)
            address += c.MailingCity +', ';
        if (c.MailingState != null)
            address += c.MailingState +' ';
        if (c.MailingPostalCode != null)
            address += c.MailingPostalCode +', ';
        //if (a.BillingCountry != null)
            //address += a.BillingCountry;
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        return address;
    }
    
        public static String buildEventAddress(Id EventId){
        Event e = [SELECT FSA_BTO_EventStreet__c, FSA_BTO_EventState__c, FSA_BTO_EventZipCode__c, FSA_BTO_EventCity__c From Event WHERE id =: eventId];
        // create an address string
        String address = '';
        if (e.FSA_BTO_EventStreet__c != null)
            address += e.FSA_BTO_EventStreet__c +', ';
        if (e.FSA_BTO_EventCity__c != null)
            address += e.FSA_BTO_EventCity__c +', ';
        if (e.FSA_BTO_EventState__c != null)
            address += e.FSA_BTO_EventState__c +' ';
        if (e.FSA_BTO_EventZipCode__c != null)
            address += e.FSA_BTO_EventZipCode__c +', ';
        //if (a.BillingCountry != null)
            //address += a.BillingCountry;
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        return address;
    }
    
        public static String buildAccountAddress(Id accountId){
        Account a = [SELECT BillingStreet, BillingState, BillingPostalCode, BillingCity From Account WHERE id =: accountId];
        // create an address string
        String address = '';
        if (a.BillingStreet != null)
            address += a.BillingStreet +', ';
        if (a.BillingCity != null)
            address += a.BillingCity +', ';
        if (a.BillingState != null)
            address += a.BillingState +' ';
        if (a.BillingPostalCode != null)
            address += a.BillingPostalCode +', ';
        //if (a.BillingCountry != null)
            //address += a.BillingCountry;
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        return address;
    }
    
    
    public static void handleUserWebServiceResponse(HttpResponse res, Id userId){
            User u = [SELECT Id From User WHERE id =: userId];
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
                }
            }

            // update coordinates if we get back
            if (lat != null){
                System.Debug('Lat:');
                u.FSA_BTO_Location__Latitude__s = lat;
                u.FSA_BTO_Location__Longitude__s = lon;
                update u;
            }
    }
    
    public static void handleEventWebServiceResponse(HttpResponse res, Id eventId){
            Event e = [SELECT Id from Event where Id =: eventId];
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
                }
            }

            // update coordinates if we get back
            if (lat != null){
                e.FSA_BTO_Location__Latitude__s = lat;
                e.FSA_BTO_Location__Longitude__s = lon;
                update e;
            }
    }
    
    public static void handleContactWebServiceResponse(HttpResponse res, Id contactId){
            Contact c = [Select Id from Contact where Id =: contactId];
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
                }
            }

            // update coordinates if we get back
            if (lat != null){
                c.FSA_BTO_Location__Latitude__s = lat;
                c.FSA_BTO_Location__Longitude__s = lon;
                update c;
            }
    }
    
    public static void handleAccountWebServiceResponse(HttpResponse res, Id accountId){
            Account a = [SELECT Id from Account where Id =: accountId];
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
                }
            }

            // update coordinates if we get back
            if (lat != null){
                a.FSA_BTO_Location__Latitude__s = lat;
                a.FSA_BTO_Location__Longitude__s = lon;
                update a;
            }
    }
}
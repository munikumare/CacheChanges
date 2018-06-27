public without sharing class FSA_BTO_LocationCallouts {

    @future(callout = true) // future method needed to run callouts from Triggers
    public static void getUserLocation(Set < Id > userIds) {
        List < String > addresses = buildUserAddresses(userIds);
        Map < String, User > userMap = buildUserAddressMap(userIds);
        List < User > updateLatLongUsers = new List < User > ();
        Http h = new Http();
        system.debug(addresses);
        system.debug(userMap);
        for (String address: addresses) {
            HttpRequest req = buildWebServiceRequest(address);
            try {
                HttpResponse res;
                res = h.send(req);
                User u = handleUserWebServiceResponse(res, address, userMap);
                if (u != null) {
                    updateLatLongUsers.add(u);
                }
            } catch (Exception e) {}
        }
        if (!updateLatLongUsers.isEmpty()) {
            update updateLatLongUsers;
        }
    }

    @future(callout = true) // future method needed to run callouts from Triggers
    public static void getIndividualLocation(Set < Id > contactIds) {
        
        system.debug('contactIds Size>>****'+contactIds.size());
        // create an address string
        List < String > addresses = buildContactAddresses(contactIds);
		system.debug('addresses Size>>****'+addresses.size());
        Map < String, Contact > contactMap = buildContactAddressMap(contactIds);
        system.debug('contactMap Size>>****'+contactMap.size());
        
        for (String Key: contactMap.keyset()) {
            system.debug('Key: >>>>'+Key); 
            system.debug('Map val: >>>>'+contactMap.get(Key));
        }
       
        List < Contact > updateLatLongContacts = new List < Contact > ();
        
        // build callout
        Http h = new Http();
        for (String address: addresses) {
            system.debug('Address Loop>>****'+address);
            HttpRequest req = buildWebServiceRequest(address);
            try {
                // callout
                HttpResponse res;
                res = h.send(req);
                Contact c = handleContactWebServiceResponse(res, address, contactMap);
                if (c != null) {
                    system.debug('&&&&&'+c.id);
                    updateLatLongContacts.add(c);
                }
            } catch (Exception e) {}
        }
        if (!updateLatLongContacts.isEmpty()) {
            update updateLatLongContacts;
        }
    }

    @future(callout = true) // future method needed to run callouts from Triggers
    public static void getAccountLocation(Set < Id > accountIds) {
        // create an address string
        List < String > addresses = buildAccountAddresses(accountIds);
        Map < String, Account > accountMap = buildAccountAddressMap(accountIds);
        List < Account > updateLatLongAccounts = new List < Account > ();
        // build callout
        Http h = new Http();
        for (String address: addresses) {
            HttpRequest req = buildWebServiceRequest(address);
            try {
                HttpResponse res;
                res = h.send(req);
                // parse coordinates from response
                Account a = handleAccountWebServiceResponse(res, address, accountMap);
                if (a != null) {
                    updateLatLongAccounts.add(a);
                }
            } catch (Exception e) {}
        }
        if (!updateLatLongAccounts.isEmpty()) {
            update updateLatLongAccounts;
        }
    }

    @future(callout = true) // future method needed to run callouts from Triggers
    public static void getEventLocation(Set < Id > eventIds) {
        // create an address string
        List < String > addresses = buildEventAddresses(eventIds);
        Map < String, Event > eventMap = buildEventAddressMap(eventIds);
        List < Event > updateLatLongEvents = new List < Event > ();
        // build callout
        Http h = new Http();
        for (String address: addresses) {
            HttpRequest req = buildWebServiceRequest(address);
            try {
                // callout
                HttpResponse res;
                res = h.send(req);
                Event e = handleEventWebServiceResponse(res, address, eventMap);
                if (e != null) {
                    updateLatLongEvents.add(e);
                }
            } catch (Exception ex) {}
        }
        if (!updateLatLongEvents.isEmpty()) {
            update updateLatLongEvents;
        }
    }

    private static HttpRequest buildWebServiceRequest(String address) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
        return req;
    }

    private static List < String > buildUserAddresses(Set < Id > userIds) {
        List < String > addresses = new List < String > ();
        // gather account info
        List < User > users = [SELECT Id, Street, State, PostalCode, City From User WHERE id IN: userIds];
        // create an address string
        String address;
        for (User u: users) {
            address = '';
            if (u.Street != null) {
                address += u.Street + ', ';
            }
            if (u.City != null) {
                address += u.City + ', ';
            }
            if (u.State != null) {
                address += u.State + ' ';
            }
            if (u.PostalCode != null) {
                address += u.PostalCode + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            addresses.add(address);
        }
        return addresses;
    }

    public static Map < String, User > buildUserAddressMap(Set < Id > userIds) {
        Map < String, User > userAddressMap = new Map < String, User > ();
        // gather account info
        List < User > users = [SELECT Id, Street, State, PostalCode, City, FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s From User WHERE id IN: userIds];
        // create an address string
        String address;
        for (User u: users) {
            address = '';
            if (u.Street != null) {
                address += u.Street + ', ';
            }
            if (u.City != null) {
                address += u.City + ', ';
            }
            if (u.State != null) {
                address += u.State + ' ';
            }
            if (u.PostalCode != null) {
                address += u.PostalCode + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            system.debug(address);
            system.debug(u);
            userAddressMap.put(address, u);
        }
        return userAddressMap;
    }

    private static List < String > buildContactAddresses(Set < Id > contactIds) {
        List < String > addresses = new List < String > ();
        List < Contact > contacts = [SELECT Id, MailingStreet, MailingState, MailingPostalCode, MailingCity From Contact WHERE id IN: contactIds];
        // create an address string
        String address;
        for (Contact c: contacts) {
            address = '';
            if (c.MailingStreet != null) {
                address += c.MailingStreet + ', ';
            }
            if (c.MailingCity != null) {
                address += c.MailingCity + ', ';
            }
            if (c.MailingState != null) {
                address += c.MailingState + ' ';
            }
            if (c.MailingPostalCode != null) {
                address += c.MailingPostalCode + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            addresses.add(address);
        }
        return addresses;
    }

    public static Map < String, Contact > buildContactAddressMap(Set < Id > contactIds) {
        Map < String, Contact > contactAddressMap = new Map < String, Contact > ();
        // gather account info
        List < Contact > contacts = [SELECT Id, MailingStreet, MailingState, MailingPostalCode, MailingCity, FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s From Contact WHERE id IN: contactIds];
        // create an address string
        String address;
        for (Contact c: contacts) {
            address = '';
            if (c.MailingStreet != null) {
                address += c.MailingStreet + ', ';
            }
            if (c.MailingCity != null) {
                address += c.MailingCity + ', ';
            }
            if (c.MailingState != null) {
                address += c.MailingState + ' ';
            }
            if (c.MailingPostalCode != null) {
                address += c.MailingPostalCode + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            contactAddressMap.put(address, c);
        }
        return contactAddressMap;
    }

    private static List < String > buildEventAddresses(Set < Id > eventIds) {
        List < String > addresses = new List < String > ();
        List < Event > events = [SELECT Id, FSA_BTO_EventStreet__c, FSA_BTO_EventState__c, FSA_BTO_EventZipCode__c, FSA_BTO_EventCity__c From Event WHERE id IN: eventIds];
        // create an address string
        String address = '';
        for (Event e: events) {
            address = '';
            if (e.FSA_BTO_EventStreet__c != null) {
                address += e.FSA_BTO_EventStreet__c + ', ';
            }
            if (e.FSA_BTO_EventCity__c != null) {
                address += e.FSA_BTO_EventCity__c + ', ';
            }
            if (e.FSA_BTO_EventState__c != null) {
                address += e.FSA_BTO_EventState__c + ' ';
            }
            if (e.FSA_BTO_EventZipCode__c != null) {
                address += e.FSA_BTO_EventZipCode__c + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            addresses.add(address);
        }
        return addresses;
    }

    public static Map < String, Event > buildEventAddressMap(Set < Id > eventIds) {
        Map < String, Event > eventAddressMap = new Map < String, Event > ();
        // gather account info
        List < Event > events = [SELECT Id, FSA_BTO_EventStreet__c, FSA_BTO_EventState__c, FSA_BTO_EventZipCode__c, FSA_BTO_EventCity__c, FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s From Event WHERE id IN: eventIds];
        // create an address string
        String address = '';
        for (Event e: events) {
            address = '';
            if (e.FSA_BTO_EventStreet__c != null) {
                address += e.FSA_BTO_EventStreet__c + ', ';
            }
            if (e.FSA_BTO_EventCity__c != null) {
                address += e.FSA_BTO_EventCity__c + ', ';
            }
            if (e.FSA_BTO_EventState__c != null) {
                address += e.FSA_BTO_EventState__c + ' ';
            }
            if (e.FSA_BTO_EventZipCode__c != null) {
                address += e.FSA_BTO_EventZipCode__c + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            eventAddressMap.put(address, e);
        }
        return eventAddressMap;
    }

    private static List < String > buildAccountAddresses(Set < Id > accountIds) {
        List < String > addresses = new List < String > ();
        List < Account > accounts = [SELECT Id, BillingStreet, BillingState, BillingPostalCode, BillingCity From Account WHERE id IN: accountIds];
        // create an address string
        String address = '';
        for (Account a: accounts) {
            address = '';
            if (a.BillingStreet != null) {
                address += a.BillingStreet + ', ';
            }
            if (a.BillingCity != null) {
                address += a.BillingCity + ', ';
            }
            if (a.BillingState != null) {
                address += a.BillingState + ' ';
            }
            if (a.BillingPostalCode != null) {
                address += a.BillingPostalCode + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            addresses.add(address);
        }
        return addresses;
    }

    public static Map < String, Account > buildAccountAddressMap(Set < Id > accountIds) {
        Map < String, Account > accountAddressMap = new Map < String, Account > ();
        // gather account info
        List < Account > accounts = [SELECT Id, BillingStreet, BillingState, BillingPostalCode, BillingCity, FSA_BTO_Location__Latitude__s, FSA_BTO_Location__Longitude__s From Account WHERE id IN: accountIds];
        // create an address string
        String address = '';
        for (Account a: accounts) {
            address = '';
            if (a.BillingStreet != null) {
                address += a.BillingStreet + ', ';
            }
            if (a.BillingCity != null) {
                address += a.BillingCity + ', ';
            }
            if (a.BillingState != null) {
                address += a.BillingState + ' ';
            }
            if (a.BillingPostalCode != null) {
                address += a.BillingPostalCode + ', ';
            }
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            accountAddressMap.put(address, a);
        }
        return accountAddressMap;
    }

    public static User handleUserWebServiceResponse(HttpResponse res, String address, Map < String, User > userMap) {
        system.debug(userMap);
        system.debug(address);
        system.debug(userMap.get(address));
        User u = userMap.get(address);
        JSONParser parser = JSON.createParser(res.getBody());
        double lat = null;
        double lon = null;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
                parser.nextToken(); // object start
                while (parser.nextToken() != JSONToken.END_OBJECT) {
                    String txt = parser.getText();
                    parser.nextToken();
                    if (txt == 'lat') lat = parser.getDoubleValue();
                    else if (txt == 'lng') lon = parser.getDoubleValue();
                }
            }
        }
        // update coordinates if we get back
        if (lat != null) {
            System.Debug('Lat:' +lat);
            System.debug(u);
            u.FSA_BTO_Location__Latitude__s = lat;
            u.FSA_BTO_Location__Longitude__s = lon;
            return u;
            //update u;
        }
        return null;
    }

    public static Event handleEventWebServiceResponse(HttpResponse res, String address, Map < String, Event > eventMap) {
        Event e = eventMap.get(address);
        JSONParser parser = JSON.createParser(res.getBody());
        double lat = null;
        double lon = null;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
                parser.nextToken(); // object start
                while (parser.nextToken() != JSONToken.END_OBJECT) {
                    String txt = parser.getText();
                    parser.nextToken();
                    if (txt == 'lat') lat = parser.getDoubleValue();
                    else if (txt == 'lng') lon = parser.getDoubleValue();
                }
            }
        }
        // update coordinates if we get back
        if (lat != null) {
            e.FSA_BTO_Location__Latitude__s = lat;
            e.FSA_BTO_Location__Longitude__s = lon;
            return e;
            //update e;
        }
        return null;
    }

    public static Contact handleContactWebServiceResponse(HttpResponse res, String address, Map < String, Contact > contactMap) {
        Contact c = contactMap.get(address);
        JSONParser parser = JSON.createParser(res.getBody());
        double lat = null;
        double lon = null;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
                parser.nextToken(); // object start
                while (parser.nextToken() != JSONToken.END_OBJECT) {
                    String txt = parser.getText();
                    parser.nextToken();
                    if (txt == 'lat') lat = parser.getDoubleValue();
                    else if (txt == 'lng') lon = parser.getDoubleValue();
                }
            }
        }
        // update coordinates if we get back
        if (lat != null) {
            c.FSA_BTO_Location__Latitude__s = lat;
            c.FSA_BTO_Location__Longitude__s = lon;
            return c;
            //update c;
        }
        return null;
    }

    public static Account handleAccountWebServiceResponse(HttpResponse res, String address, Map < String, Account > accountMap) {
        Account a = accountMap.get(address);
        JSONParser parser = JSON.createParser(res.getBody());
        double lat = null;
        double lon = null;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
                parser.nextToken(); // object start
                while (parser.nextToken() != JSONToken.END_OBJECT) {
                    String txt = parser.getText();
                    parser.nextToken();
                    if (txt == 'lat') lat = parser.getDoubleValue();
                    else if (txt == 'lng') lon = parser.getDoubleValue();
                }
            }
        }
        // update coordinates if we get back
        if (lat != null) {
            a.FSA_BTO_Location__Latitude__s = lat;
            a.FSA_BTO_Location__Longitude__s = lon;
            return a;
            //update a;
        }
        return null;
    }
}
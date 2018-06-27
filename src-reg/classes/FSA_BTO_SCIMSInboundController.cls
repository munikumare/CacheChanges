global without sharing class FSA_BTO_SCIMSInboundController {
    global static String response { get; set; }
    
    webservice static String parse(String xmlString) {
        try {
            FSA_BTO_SCIMSCustomer scimsCustomer = new FSA_BTO_SCIMSCustomer(xmlString);
            List<Contact> c = [SELECT Id FROM Contact WHERE FSA_BTO_Core_Customer_ID__c =: scimsCustomer.coreCustomerId];
            if(!c.isEmpty()) {
                System.debug('existing contact Id: ' + c[0].Id);
                response = String.valueOf(c[0].Id);
            } else {
                Id recordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Bridges Customer Individual').RecordTypeId;
                
                // there needs to be a valid 'SCIMS Customer' Account record prior to deployment
                Account account = [SELECT Id FROM Account WHERE Name = 'SCIMS Customer' LIMIT 1];
                
                Contact contact = new Contact(AccountId=account.Id, RecordTypeId=recordTypeId, FSA_BTO_Core_Customer_ID__c=scimsCustomer.coreCustomerId);
                
                if(!String.isEmpty(scimsCustomer.lastName)) {
                    contact.LastName = scimsCustomer.lastName;
                } else {
                    // assign business name as last name if no individual name exists
                    if(!String.isEmpty(scimsCustomer.businessName)) {
                        contact.LastName = scimsCustomer.businessName;
                    } else {
                        //will throw DmlException
                        contact.LastName = null;
                    }
                }
                if(!String.isEmpty(scimsCustomer.firstName)) contact.FirstName = scimsCustomer.firstName;
                if(!String.isEmpty(scimsCustomer.middleName)) contact.MiddleName = scimsCustomer.middleName;
                if(!String.isEmpty(scimsCustomer.prefixName)) contact.Salutation = scimsCustomer.prefixName;
                if(!String.isEmpty(scimsCustomer.suffixName)) contact.Suffix = scimsCustomer.suffixName;
                if(!String.isEmpty(scimsCustomer.email)) contact.Email = scimsCustomer.email;
                if(!String.isEmpty(scimsCustomer.phone)) contact.Phone = scimsCustomer.phone;
                if(!String.isEmpty(scimsCustomer.mobile)) contact.MobilePhone = scimsCustomer.mobile;
                if(!String.isEmpty(scimsCustomer.mailingStreet)) contact.MailingStreet = scimsCustomer.mailingStreet; 
                if(!String.isEmpty(scimsCustomer.mailingCity)) contact.MailingCity = scimsCustomer.mailingCity;
                if(!String.isEmpty(scimsCustomer.mailingState)) contact.MailingStateCode = scimsCustomer.mailingState;
                if(!String.isEmpty(scimsCustomer.mailingZip)) contact.MailingPostalCode = scimsCustomer.mailingZip;
                
                insert contact;
                System.debug('new contact Id: ' + contact.Id);
                response = String.valueOf(contact.Id);
            }
        } catch(System.QueryException e) {
            response = 'Fatal error: Cannot retrieve Account or Contact record. A system administrator has been alerted. Please try again later.';
        } catch(System.XmlException e) {
            response = 'Error processing Bridges Customer data: Data retrieved from SCIMS is invalid. An administrator has been alerted. Please try again later'; 
        } catch(System.DmlException e) {
            // check for invalid email address
            // to-do: check for invalid phone numbers?
            // also using response field for errors
            if(e.getDmlType(0) == StatusCode.INVALID_EMAIL_ADDRESS) {
                response = 'Error saving Bridges Customer: Invalid email address (' + e.getDmlMessage(0).substringAfterLast(': ') + ')';
            } else {
                response = 'Error saving Bridges Customer: Please ensure that all contact information in the SCIMS customer record are valid.';                    
            }
        } catch(Exception e) {
            response = 'Unknown error detected. An administrator has been alerted.';
        }
        return response;
    }
    
    /*
    public static Boolean validateEmail(String email) {
        Boolean isValid = true;
        String regex = '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))';
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);

        if (!MyMatcher.matches()) isValid = false;
        return isValid; 
    }
    */
}
public class FSA_BTO_SCIMSCustomerController {
    public String recordTypeName { get; set; }
    public FSA_BTO_SCIMSCustomer scimsCustomer { get; set; }
    public Contact contact { get; set; }
    public String errorMessage { get; set; }
        
    public void getCustomer() {
        try {
            // this should always fetch a record if the ID isn't altered for some reason else throw QueryException
            contact = [SELECT Id, Name, FSA_BTO_Core_Customer_ID__c, FirstName, LastName, MiddleName, Salutation, Suffix, Email, Phone, MobilePhone, MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, RecordTypeId FROM Contact WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            
            Map<ID, Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Contact.getRecordTypeInfosById();
            recordTypeName = recordTypeMap.get(contact.RecordTypeId).getName();
            Id recordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Bridges Customer Individual').RecordTypeId;       

            if(contact.RecordTypeId == recordTypeId) {
                try {
                    FSA_BTO_SCIMSWSCalloutController callout = new FSA_BTO_SCIMSWSCalloutController();
                    scimsCustomer = callout.getCustomer(contact.FSA_BTO_Core_Customer_ID__c);
                    if(!String.isEmpty(scimsCustomer.coreCustomerId)) {
                        contact.FSA_BTO_Core_Customer_ID__c = scimsCustomer.coreCustomerId;
                    }
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
                    if(!String.isEmpty(scimsCustomer.firstName)) {
                        contact.FirstName = scimsCustomer.firstName;
                    } else {
                        contact.FirstName = null;
                    } 
                    if(!String.isEmpty(scimsCustomer.middleName)) {
                        contact.MiddleName = scimsCustomer.middleName;
                    } else {
                        contact.MiddleName = null;
                    }
                    if(!String.isEmpty(scimsCustomer.prefixName)) {
                        contact.Salutation = scimsCustomer.prefixName;
                    } else {
                        contact.Salutation = null;
                    }
                    if(!String.isEmpty(scimsCustomer.suffixName)) {
                        contact.Suffix = scimsCustomer.suffixName;
                    } else {
                        contact.Suffix = null;
                    }
                    if(!String.isEmpty(scimsCustomer.email)) {
                        contact.Email = scimsCustomer.email;
                    } else {
                        contact.Email = null;
                    }
                    if(!String.isEmpty(scimsCustomer.phone)) {
                        contact.Phone = scimsCustomer.phone;
                    } else {
                        contact.Phone = null;
                    }
                    if(!String.isEmpty(scimsCustomer.mobile)) {
                        contact.MobilePhone = scimsCustomer.mobile;
                    } else {
                        contact.MobilePhone = null;
                    }
                    if(!String.isEmpty(scimsCustomer.mailingStreet)) {
                        contact.MailingStreet = scimsCustomer.mailingStreet; 
                    } else {
                        contact.MailingStreet = null; 
                    }
                    if(!String.isEmpty(scimsCustomer.mailingCity)) {
                        contact.MailingCity = scimsCustomer.mailingCity;
                    } else {
                        contact.MailingCity = null;
                    }
                    if(!String.isEmpty(scimsCustomer.mailingState)) {
                        contact.MailingStateCode = scimsCustomer.mailingState;
                    } else {
                        contact.MailingStateCode = null;
                    }
                    if(!String.isEmpty(scimsCustomer.mailingZip)) {
                        contact.MailingPostalCode = scimsCustomer.mailingZip;
                    } else {
                        contact.MailingPostalCode = null;
                    }
                    
                    update contact;
                } catch(System.DmlException e) {
                    // check for invalid email address
                    // to-do: check for invalid phone numbers?
                    if(e.getDmlType(0) == StatusCode.INVALID_EMAIL_ADDRESS) {
                        errorMessage = 'Error saving Bridges Customer: Invalid email address (' + e.getDmlMessage(0).substringAfterLast(': ') + ')';
                    } else {
                        errorMessage = 'Error saving Bridges Customer: Please ensure that all contact information in the SCIMS customer record are valid.';                    
                    }
                    System.debug('e.getDmlFieldNames(0): ' + e.getDmlFieldNames(0));
                    System.debug('e.getDmlFields(0): ' + e.getDmlFields(0));
                    System.debug('e.getDmlId(0): ' + e.getDmlId(0));
                    System.debug('e.getDmlIndex(0): ' + e.getDmlIndex(0));
                    System.debug('e.getDmlMessage(0): ' + e.getDmlMessage(0));
                    System.debug('e.getDmlStatusCode(0): ' + e.getDmlStatusCode(0));
                    System.debug('e.getDmlType(0): ' + e.getDmlType(0));
                    System.debug('e.getNumDml(): ' + e.getNumDml());
                } catch(System.CalloutException e) {
                    errorMessage = 'Error refreshing Bridges Customer data: The SCIMS Web Service is currently down. Please try again later.';
                    System.debug('e.getCause(): ' + e.getCause());
                    System.debug('e.getLineNumber(): ' + e.getLineNumber());
                    System.debug('e.getMessage(): ' + e.getMessage());
                    System.debug('e.getStackTraceString(): ' + e.getStackTraceString());
                    System.debug('e.getTypeName(): ' + e.getTypeName());
                } catch(System.XmlException e) {
                    errorMessage = 'Error processing Bridges Customer data: Data retrieved from SCIMS is invalid. An administrator has been alerted. Please try again later'; 
                    System.debug('e.getCause(): ' + e.getCause());
                    System.debug('e.getLineNumber(): ' + e.getLineNumber());
                    System.debug('e.getMessage(): ' + e.getMessage());
                    System.debug('e.getStackTraceString(): ' + e.getStackTraceString());
                    System.debug('e.getTypeName(): ' + e.getTypeName());
                } catch(Exception e) {
                    errorMessage = 'Error detected. An administrator has been alerted.';
                    System.debug('e.getCause(): ' + e.getCause());
                    System.debug('e.getLineNumber(): ' + e.getLineNumber());
                    System.debug('e.getMessage(): ' + e.getMessage());
                    System.debug('e.getStackTraceString(): ' + e.getStackTraceString());
                    System.debug('e.getTypeName(): ' + e.getTypeName());
                }
            }
        } catch(QueryException e) {
            errorMessage = 'Fatal error: Cannot retrieve contact record. A system administrator has been alerted. Please try again later.';
        }

    }
    
    public PageReference reload() {
        PageReference pr = new PageReference(ApexPages.currentPage().getUrl());
        pr.setRedirect(true);
        return pr;
    }
}
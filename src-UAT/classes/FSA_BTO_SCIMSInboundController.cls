global without sharing class FSA_BTO_SCIMSInboundController {

    @TestVisible private static final String CONTACT_RECORD_TYPE_NAME = 'FPAC Customer Contact';
    global static String response { get; set; }

    webservice static String getOrgUrl() {
        return [
            SELECT Org_URL__c
            FROM SCIMS_Setting__mdt
            WHERE Active__c = true
            LIMIT 1
        ].Org_URL__c;
    }

    webservice static String parse(String xmlString) {
        try {
            FSA_BTO_SCIMSCustomer scimsCustomer = new FSA_BTO_SCIMSCustomer(xmlString);
            List<Contact> c = [
                SELECT Id
                FROM Contact
                WHERE FSA_BTO_Core_Customer_ID__c = :scimsCustomer.coreCustomerId
            ];

            if(!c.isEmpty()) response = String.valueOf(c[0].Id);
            else {
                Id recordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get(CONTACT_RECORD_TYPE_NAME).RecordTypeId;

                Contact contact = new Contact(
                    RecordTypeId = recordTypeId,
                    FSA_BTO_Core_Customer_ID__c = scimsCustomer.coreCustomerId
                );

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
                response = String.valueOf(contact.Id);
            }
        } catch(System.XmlException e) {
            response = 'Error processing Bridges Customer data: Data retrieved from SCIMS is invalid. An administrator has been alerted. Please try again later';
        } catch(System.DmlException e) {
            if(e.getDmlType(0) == StatusCode.INVALID_EMAIL_ADDRESS) response = 'Error saving Bridges Customer: Invalid email address (' + e.getDmlMessage(0).substringAfterLast(': ') + ')';
            else response = 'Error saving Bridges Customer: Please ensure that all contact information in the SCIMS customer record are valid.';
        } catch(Exception e) {
            response = 'Unknown error detected. An administrator has been alerted.';
        }
        return response;
    }
}
public without sharing class FPAC_SCIMS_CustomerConverter {

    private static string MAILING_ADDRESS_TYPE = 'mailing';
   	private static string FPAC_CUSTOMER_INDIVIDUAL = 'FPAC Customer Contact';
    private static string Separator = '; ';
    private static string ActiveStatus = 'active';
    
    public static List<Contact> ConvertToContact(List<FPAC_SCIMS_Customer> scimsCustomers)
    {
        Id fpacCustomerRecordTypeId = Schema.SObjectType.Contact
            								.getRecordTypeInfosByName()
                  							.get(FPAC_CUSTOMER_INDIVIDUAL)
            								.getRecordTypeId();
        
        List<Contact> contacts = new List<Contact>();
        
        for(FPAC_SCIMS_Customer scimsCustomer : scimsCustomers)
        {
            Contact contact = new Contact();
             
            contact.LastName = String.isNotBlank(scimsCustomer.LastName) ? scimsCustomer.LastName : scimsCustomer.CommonName;
            contact.FirstName = scimsCustomer.FirstName;
            contact.MiddleName = scimsCustomer.MiddleName; 
            contact.Salutation = scimsCustomer.Prefix;
            contact.Suffix = scimsCustomer.Suffix;
            contact.FSA_BTO_Gender__c = scimsCustomer.Gender;
            contact.Ethnicity__c = scimsCustomer.Ethnicity;
            if (scimsCustomer.Race != null)
            	contact.FSA_BTO_Race_or_Origin__c = string.join(scimsCustomer.Race, Separator);
            
            //contact.MobilePhone = scimsCustomer.PrimaryPhone;
            contact.Phone = scimsCustomer.PrimaryPhone;
            
            contact.Email = scimsCustomer.PrimaryEmail;
            
            if(scimsCustomer.Addresses != null)
            {
                for(FPAC_SCIMS_Address scimsAddress : scimsCustomer.Addresses)
                {
                    if(scimsAddress.Current == true)
                    {
                        /*if (scimsAddress.Country == 'US')
                            contact.MailingCountry = 'United States';
                        else
                            contact.MailingCountry = scimsAddress.Country;*/
                        
                        contact.MailingStreet = scimsAddress.DeliveryAddressLine;
                        contact.MailingCity = scimsAddress.City;
                        contact.MailingStateCode = scimsAddress.State;
                        if (String.isBlank(scimsAddress.ZipCodePlus4))
                            contact.MailingPostalCode = scimsAddress.ZipCode;
                        else
                            contact.MailingPostalCode = scimsAddress.ZipCode + '-'+ scimsAddress.ZipCodePlus4;
                    }
                }
            }
            
            contact.FSA_BTO_Common_Customer_Name__c = scimsCustomer.CommonName;
            if(scimsCustomer.Status != ActiveStatus)
            	contact.Non_Active_Customer__c = true;
            
            if (scimsCustomer.CitizenCountry != null)
            	contact.FSA_BTO_Citizen_Country__c = string.join(scimsCustomer.CitizenCountry, Separator);
            
            contact.FSA_BTO_Core_Customer_ID__c = scimsCustomer.CoreCustomerId;
            contact.RecordTypeId = fpacCustomerRecordTypeId;
	           
    		contact.FSA_BTO_Marital_Status__c = scimsCustomer.MaritalStatus;
            contact.FSA_BTO_Language_Preference__c  = scimsCustomer.LanguagePreference;
            contact.Veteran_Status__c = scimsCustomer.VeteranStatus;
           
            contact.Updated_From_SCIMS__c = Date.today();
            contacts.Add(contact);
            
        }
        
        return contacts;
    }
}
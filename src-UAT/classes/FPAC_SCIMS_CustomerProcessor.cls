public without sharing class FPAC_SCIMS_CustomerProcessor{
    
    public Map<Id, String> GetCoreCustomerIds(List<string> individualIds)
    {
        Map<Id, String> coreCustomerIds = new Map<Id, String>();
        for(Contact customer : [SELECT FSA_BTO_Core_Customer_ID__c 
                                    	FROM Contact
                                    	WHERE Id IN :individualIds])

            coreCustomerIds.put(customer.Id, customer.FSA_BTO_Core_Customer_ID__c);
        
        return coreCustomerIds;
    }

    public List<FPAC_SCIMS_Customer> GetCustomerDetails(List<String> coreCustomerIds)
    {    
        string commaSeparatedCoreCustomerIds = String.join(coreCustomerIds, ',');
        List<FPAC_SCIMS_Customer> scimsCustomerList = new List<FPAC_SCIMS_Customer>();

        if (!String.isBlank(commaSeparatedCoreCustomerIds))
        {
            System.debug('commaSeparatedCoreCustomerIds==>>>'+commaSeparatedCoreCustomerIds);
            String endpoint = ('callout:Mulesoft_PreProd/getCustomerByCCID?customerId=' + commaSeparatedCoreCustomerIds);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            String scimsCustomerJson = res.getBody();
            //System.debug('JSON Response==>>>'+scimsCustomerJson);
            if(res.getStatusCode()==200 && !string.isBlank(scimsCustomerJson)){
                scimsCustomerList = (List<FPAC_SCIMS_Customer>) JSON.deserialize(scimsCustomerJson, List<FPAC_SCIMS_Customer>.class);
                //System.debug('JSON Response==>>>'+scimsCustomerList);
            }
                 
            return scimsCustomerList;
        }
        else 
            return new List<FPAC_SCIMS_Customer>();
    }

    private List<Contact> ConvertScimsCustomerToContact(List<FPAC_SCIMS_Customer> customers)
    {
        return FPAC_SCIMS_CustomerConverter.ConvertToContact(customers);
    }

    public List<Contact> SaveContacts(List<FPAC_SCIMS_Customer> customers)
    {
        List<Contact> finalConList = new List<Contact>();
       	List<Contact> contacts = ConvertScimsCustomerToContact(customers);
        System.debug('Converted SCIMS customer to Salesforce contact');
        
        Database.UpsertResult[] results = Database.upsert(contacts, Contact.FSA_BTO_Core_Customer_ID__c.getDescribe().getSObjectField(), false);  
        
        for(Integer index = 0, size = results.size(); index < size; index++) {
            if(results[index].isSuccess()) {
                System.debug(contacts[index].FSA_BTO_Core_Customer_ID__c +' was created/updated');
                finalConList.add(contacts[index]);
            }
            else
            {
                for(Database.Error error : results[index].getErrors())
                {
                    System.debug('Error with contact ' + contacts[index].FSA_BTO_Core_Customer_ID__c +'of length= '+contacts[index].FSA_BTO_Core_Customer_ID__c.length()+ ' - ' + error.getMessage());
                }
            }
        }
        
        return finalConList;
        
    }

    
}
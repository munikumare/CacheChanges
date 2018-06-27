public without sharing class FSA_BTO_ContactTriggerHelper {
    
    public static void syncRecordType(Map<Id,Contact> contactMap){
        if(!System.IsFuture()){
            List<Contact> contactAccounts=[Select Id, AccountId From Contact WHERE Id IN: contactMap.keySet()];
            Set<Id> accountIds=new Set<Id>();
            for(Contact c : contactAccounts){
                accountIds.add(c.AccountId);
            }
            FSA_BTO_RecordTypeHelper.updateRecordTypesAccount(accountIds);
        }
    }
    
    public static void syncAccountName(List<Contact> contacts){
        
        if(!System.IsFuture()){
            
            Id customerRTId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('FPAC Customer Contact').RecordTypeId;
            
            List<Account> accountsToUpdate = new List<Account>();
            
            for(Contact c : contacts){
                if(c.RecordTypeId == customerRTId)
                {
                    Account accountToUpdate = new Account();
                    system.Debug('c.ID>>>>'+c.Id);
                    system.Debug('c.AccountId>>>>'+c.AccountId);
                    //if(c.AccountId!=null){
                        accountToUpdate.Id = c.AccountId;
                        accountToUpdate.Name = CalculateAccountName(c.FirstName, c.LastName);
                        accountsToUpdate.add(accountToUpdate);
                    //}
                    
                }
            }
            update(accountsToUpdate);
        }
    }

    public static void getIndividualCoordinates(List<Contact> contacts){
        if(!System.IsFuture()){
            Set<ID> ids = new Set<Id>();
            for(Contact c : contacts){
                if( c.FSA_BTO_Location__latitude__s == null && String.isNotBlank(c.MailingStreet)){
                    ids.add(c.Id);
                }
            }
            
            if(!ids.isEmpty()){
                
                FSA_BTO_LocationCallouts.getIndividualLocation(ids);
            }
        }
    }

    public static void createOrganizationForCustomer(List<Contact> newContacts){
        Id customerRTId=Schema.SObjectType.Contact.RecordTypeInfosByName.get('FPAC Customer Contact').RecordTypeId;
        List<Account> insertCustomerAccounts= new List<Account>();
        for(Contact c:newContacts){
            if(customerRTId==c.RecordTypeId && c.AccountId==null){
                Account a= new Account();
                a.Name=CalculateAccountName(c.FirstName, c.LastName);
                insertCustomerAccounts.add(a);
            }
        }
        if(!insertCustomerAccounts.isEmpty()){
            insert insertCustomerAccounts;
        }
        system.debug(insertCustomerAccounts);
        for(Account a:insertCustomerAccounts){
            for(Contact c:newContacts){
                if(CalculateAccountName(c.FirstName, c.LastName)==a.Name){
                    c.AccountId=a.Id;
                }
            }
        }
    }

    private static string CalculateAccountName(string firstName, string lastName)
    {
        string fName = firstName != null ? firstName : '';
        string lName = lastName != null ? lastName : '';
        return fName + ' ' + lName;
    }
}
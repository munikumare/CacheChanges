public class FSA_BTO_SelectRecordTypeController{

    public Id accId {get;set;}
    public String savenewurl; 
    private final Contact contact;

    public FSA_BTO_SelectRecordTypeController(ApexPages.StandardController controller) {
    this.contact = (Contact)controller.getRecord();
    accId = System.currentPageReference().getParameters().get('accId');
    savenewurl = System.currentPageReference().getParameters().get('save_new_url');
    System.debug(savenewurl);
    System.debug(contact.Id);
    }


    public PageReference handleRedirect(){
        if(accId == null & contact.RecordTypeId == null){
            return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Contact&save_new_url=%2F003%2Fe');
        }
        else if(accId == null & contact.RecordTypeID != null){
            return new PageReference('/003/e?nooverride=1&RecordType='+contact.RecordTypeId);
        }
        else{
            Account thisAccount = [Select Name, Id, RecordType.Name from Account where id = :accId];
            if(thisAccount.RecordType.Name == 'USDA Agency'){
                RecordType rt = [Select Name, Id from RecordType where Name = 'USDA Agency Individual'];
                contact.RecordType = rt;
                return new PageReference('/003/e?retURL='+accid+'&accid='+accid+'&RecordType='+rt.Id+'&ent=Contact&nooverride=1');
            } else if(thisAccount.RecordType.Name == 'Public Partner Organization') {
                RecordType rt = [Select Name, Id from RecordType where Name = 'Public Partner Individual'];
                contact.RecordType = rt;
                return new PageReference('/003/e?retURL='+accid+'&accid='+accid+'&RecordType='+rt.Id+'&ent=Contact&nooverride=1');
            } else if(thisAccount.RecordType.Name == 'Bridges Partner Organization') {
                RecordType rt = [Select Name, Id from RecordType where Name = 'Bridges Partner Individual'];
                contact.RecordType = rt;
                return new PageReference('/003/e?retURL='+accid+'&accid='+accid+'&RecordType='+rt.Id+'&ent=Contact&nooverride=1');  
            } else if (thisAccount.RecordType.Name == 'Bridges Customer Organization') {
                RecordType rt = [Select Name, Id from RecordType where Name = 'Bridges Customer Individual'];
                contact.RecordType = rt;
                return new PageReference('/003/e?retURL='+accid+'&accid='+accid+'&RecordType='+rt.Id+'&ent=Contact&nooverride=1');
            } else {
            return null;
            }
        }
    return null;
    }
    
     @future
     static public void updateRecordTypes(Set<Id> Accounts){
     List<Account> toUpdate = [select Id, RecordType.Name from Account where Id in :Accounts];
     RecordType rt = new RecordType(); 
     for(Account a: toUpdate){
         System.Debug('Account Record Type:'+ a.RecordType.Name);
         if(a.RecordType.Name == 'USDA Agency'){
             rt = [Select Name, Id from RecordType where Name = 'USDA Agency Individual'];
         } else if(a.RecordType.Name == 'Public Partner Organization') {
             rt = [Select Name, Id from RecordType where Name = 'Public Partner Individual'];
         } else if(a.RecordType.Name == 'Bridges Partner Organization') {
             rt = [Select Name, Id from RecordType where Name = 'Bridges Partner Individual'];
         } else if (a.RecordType.Name == 'Bridges Customer Organization') {
             rt = [Select Name, Id from RecordType where Name = 'Bridges Customer Individual'];
         }
         List<Contact> contacts = [Select Id, RecordTypeId, RecordType.Name, AccountId from Contact where accountId =:a.Id];
         for(Contact c : contacts){
             c.RecordTypeId = rt.Id;
         }
         upsert contacts;     
      }            
    }
    
    @future
    static public void updateRecordTypesContact(Set<Id> Contacts){
        List<Contact> toUpdate = [select Id, RecordType.Name, Account.RecordType.Name from Contact where AccountId != null and Id in :Contacts];
         RecordType rt = new RecordType(); 
         for(Contact c: toUpdate){
             if(c.Account.RecordType.Name == 'USDA Agency'){
                 rt = [Select Name, Id from RecordType where Name = 'USDA Agency Individual'];
             } else if(c.Account.RecordType.Name == 'Public Partner Organization') {
                 rt = [Select Name, Id from RecordType where Name = 'Public Partner Individual'];
             } else if(c.Account.RecordType.Name == 'Bridges Partner Organization') {
                 rt = [Select Name, Id from RecordType where Name = 'Bridges Partner Individual'];
             } else if (c.Account.RecordType.Name == 'Bridges Customer Organization') {
                 rt = [Select Name, Id from RecordType where Name = 'Bridges Customer Individual'];
             }
             c.RecordTypeId = rt.Id;
             }
         upsert toUpdate;                 
    }
}
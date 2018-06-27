public class FSA_BTO_LocationUpdateJob{
   
   Integer count = 2500;
   
   public void FSA_BTO_RunLocationUpdate(){
   // User Update
   List<User> existingUsers = new List<User>();
   if(!Test.isRunningTest()){
   existingUsers = [Select Id, FSA_BTO_Location__latitude__s, Street from User where FSA_BTO_Location__latitude__s = NULL];
   } else {
   existingUsers = [Select Id, FSA_BTO_Location__latitude__s, Street from User where LastName = 'Tester'];
   }
   Set<ID> uIds = new Set<Id>();
   for(User u : existingUsers){
        if(count > 0 && String.isNotBlank(u.Street))
        {
        uIds.add(u.Id);
        count--;
        }
    }
    FSA_BTO_LocationCallouts.getuserLocation(uIds);
    
    // Individual Update
    
    List<Contact> existingIndividuals = [Select Id, FSA_BTO_Location__latitude__s, MailingStreet from Contact where FSA_BTO_Location__latitude__s = NULL]; 
    Set<ID> cIds = new Set<Id>();
    for(Contact c : existingIndividuals){
        if(count > 0 && String.isNotBlank(c.MailingStreet))
        {
        cIds.add(c.Id);
        count --;
        }
    }
    FSA_BTO_LocationCallouts.getIndividualLocation(cIds);
    
    // Organization Update
    List<Account> existingAccounts = [Select Id, FSA_BTO_Location__latitude__s, BillingStreet from Account where FSA_BTO_Location__latitude__s = NULL]; 
    Set<ID> aIds = new Set<Id>();
    for(Account a : existingAccounts){
        if(count > 0 && String.isNotBlank(a.BillingStreet))
        {
        aIds.add(a.Id);
        count--;
        }
    }
    FSA_BTO_LocationCallouts.getAccountLocation(aIds);
    
    }
}
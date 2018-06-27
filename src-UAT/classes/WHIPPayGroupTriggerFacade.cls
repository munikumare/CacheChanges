public class WHIPPayGroupTriggerFacade {
static final String STATUS_DISSAPPROVED= 'Disapproved';
static final String STATUS_APPROVED= 'Approved';
static final String STATUS_PENDING= 'Pending';
    
public static WHIPPayGroupTriggerFacade createWHIPPayGroupTriggerFacade() {
        return new WHIPPayGroupTriggerFacade(           
            );
   	 }
    
     public void SetPayGroupApprovalStatus(Map<Id, WHIPPayGroup__c> newWHIPPayGroups,  List<WHIPPayGroup__c> oldWHIPPayGroups) {
        List<WHIPPayGroup__c> informationsToUpdate = new List<WHIPPayGroup__c>();
        Set<Id> allUpdatedpayGroupIds = newWHIPPayGroups.keySet();
 		List<WHIPLossInformation__c> losses = [SELECT Id, Name,WHIP_Pay_Group__c,WHIP_NOL_Status__c FROM WHIPLossInformation__c WHERE WHIP_Pay_Group__c IN :allUpdatedpayGroupIds];
    	string approvalStatus ='';
        for (WHIPPayGroup__c payGroup : newWHIPPayGroups.Values()) {
             approvalStatus ='';
             if (losses.size() != 0)
             {
             for (WHIPLossInformation__c loss : losses) {
                 if (loss.WHIP_Pay_Group__c == payGroup.Id && payGroup.ApprovalStatus__c == STATUS_APPROVED){ 
                    approvalStatus =STATUS_DISSAPPROVED;
                    if (loss.WHIP_NOL_Status__c =='' || loss.WHIP_NOL_Status__c== null){
                        payGroup.addError('This Pay Group cannot be approved because at least one associated WHIP Notice of Loss record(s) has not been approved or disapproved');
                        approvalStatus =STATUS_PENDING;
                        break;
                    }else if(loss.WHIP_NOL_Status__c == STATUS_APPROVED){
                        approvalStatus =STATUS_APPROVED; 
                        break; 
                    }
                 }
             }
                 if (approvalStatus == STATUS_DISSAPPROVED){ 
                    payGroup.addError('This Pay Group cannot be approved because all associated WHIP Notice of Loss records are disapproved');
                 }
             }else
             {
               payGroup.addError('This Pay Group cannot be approved because at least one associated WHIP Notice of Loss record(s) has not been approved or disapproved');   
             }
        }       
     }
}
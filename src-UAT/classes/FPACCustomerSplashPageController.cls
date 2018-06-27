public with sharing class FPACCustomerSplashPageController {

    public String statusMessage {get; private set;}
    public Boolean showSpinner {get; private set;}
    public FPACCustomerSplashPageController() {
    }

    public PageReference redirect() {
        Map<String, string> messageLabelToMessage = new Map<String, string> ();
        User thisUser = [SELECT Id, Name, AccountId, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        List<Contact> contacts = [SELECT Id, FSA_BTO_Core_Customer_ID__c 
                                  FROM Contact 
                                  WHERE Id = :thisUser.ContactId];

        List<CustomerLoginFlowErrorMessages__mdt> statusMessages = [SELECT MasterLabel, Message_Text__c
                                                                    FROM CustomerLoginFlowErrorMessages__mdt];

        for(CustomerLoginFlowErrorMessages__mdt statusMessage : statusMessages) {
            messageLabelToMessage.put(statusMessage.MasterLabel, statusMessage.Message_Text__c);
        }
        if(contacts[0].FSA_BTO_Core_Customer_ID__c == null) {
            showSpinner = false;
            statusMessage = messageLabelToMessage.get('CCID');
            return null;
        }
        else {
            showSpinner = true;
            statusMessage = messageLabelToMessage.get('DataAvailable');
            PageReference page = new PageReference('/s/');
            FPAC_SCIMS_AuthorityProcessor authorityProcessor = new FPAC_SCIMS_AuthorityProcessor();
            String callOutReturnMessage = authorityProcessor.processCustomerandAuthority(thisUser.ContactId);
            if(callOutReturnMessage == 'Records exist') {
                page.setRedirect(true);
                Auth.SessionManagement.finishLoginFlow();
                return page;
            }
            else if(callOutReturnMessage == 'No records') {
                showSpinner = false;
                statusMessage = messageLabelToMessage.get('DataNotAvailable');
                return null;
            } 
            else{
                showSpinner = false;
                statusMessage = messageLabelToMessage.get('Error');
                return null;
            }
        }
    }

    public void spin() {
        while(true) {
            
        } 
    }
}
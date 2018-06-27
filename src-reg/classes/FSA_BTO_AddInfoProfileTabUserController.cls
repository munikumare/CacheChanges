public with sharing class FSA_BTO_AddInfoProfileTabUserController {
    private ApexPages.StandardController c;
    public User subjectUser { get; set; }
    public boolean viewingMyProfile { get; set; } 
    public boolean isEditing { get; set; } 
    public String viewerID { get; set; } 
    public String subjectID { get; set; } 
    public String fsaOffice { get; set; } 
    public String specializesIn { get; set; } 
    public String charExceededErrorMsg { get; set; }
    
    public FSA_BTO_AddInfoProfileTabUserController(ApexPages.StandardController stdController) {
        c = stdController;
        subjectID = getTargetSFDCUID();
        if (subjectID != null) {
            ApexPages.currentPage().getParameters().put('id', subjectID);
        }
        this.subjectUser = (User)stdController.getRecord();
        System.debug(subjectUser);
        Id viewer = Id.valueOf(UserInfo.getUserId());
        Id subject = Id.valueOf(subjectID);
        viewingMyProfile = (viewer == subject);
        viewerID = UserInfo.getUserId();
        fsaOffice = subjectUser.FSA_BTO_Office_County__c;
        specializesIn = subjectUser.FSA_BTO_Specializes_In__c;
    }
    
    private String getTargetSFDCUID() {
        return ApexPages.currentPage().getParameters().get('sfdc.userId');
    }

    public PageReference cancel() {
        c.cancel();
        isEditing = false;
        return ApexPages.currentPage();
    }
    
    public PageReference editUserCustomFields() {
        isEditing = true;
        return ApexPages.currentPage();
    }

    public PageReference saveUserCustomFields() {
        if(fsaOffice.length() > 255 || specializesIn.length() > 255) {
            charExceededErrorMsg = 'Error: Field value cannot exceed 255 characters.';
            return null;
        }
        subjectUser.FSA_BTO_Office_County__c = fsaOffice;
        subjectUser.FSA_BTO_Specializes_In__c = specializesIn;
        c.save();
        isEditing = false;
        // force reload to update displayed values
        PageReference pr = ApexPages.currentPage();
        pr.setRedirect(true);
        return pr;
    }
}
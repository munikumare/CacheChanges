public class FSA_BTO_CaseTriggerHelper {
	public static void preventDeleteCaseByNonCreators(List<Case> oldCases){
	    Profile currentUserProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId()];
	    for(Case c: oldCases) {
	        if(currentUserProfile.Name == 'FSA BTO User' && UserInfo.getUserId()!=c.CreatedById) {
	            c.addError('Error: You cannot delete Customer Interactions that you did not originally create.');
	        }
	    }
	}

/*	public static void copyInternalCommentsOnClose(List<Case> updatedCases, Map<Id, Case> oldCases){
	    List<CaseComment> caseComments=new List<CaseComment>();
	    for(Case c: updatedCases) {
	    	if(oldCases.get(c.Id).Status!=c.Status && c.Status=='Closed'){
		        if(c.Internal_Comments__c!=null) {
		        	CaseComment caseCommentNew= new CaseComment();
		            caseCommentNew.CommentBody=c.Internal_Comments__c;
		            caseCommentNew.ParentId=c.Id;
		            caseComments.add(caseCommentNew);
		    	}
			}
		}

		if(!caseComments.isEmpty()){
			insert caseComments;		
		}
	}*/
}
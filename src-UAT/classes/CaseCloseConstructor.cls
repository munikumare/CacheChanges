public class CaseCloseConstructor {

	public CaseCloseConstructor() {
	}

	public PageReference closeAndRedirect(){

	String caseId=ApexPages.currentPage().getParameters().get('id');
	Case closeCase=[Select Id, Status From Case Where Id=:caseId];
	closeCase.Status='Closed';
	update closeCase;
      //Write your logic here and redirect
      PageReference retURL = new PageReference('/one/one.app#/sObject/'+caseId+'/view');
      retURL.setRedirect(true);
      return retURL;

 }

}
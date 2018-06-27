public class FSA_BTO_SearchControllerAuraService {
    @AuraEnabled
	public static List<ContentDistribution> getContentDistributionBySearch(String searchString) {
	    String soql = 'Select Id, Name, DistributionPublicUrl, ContentVersion.Description From ContentDistribution';
	    if(searchString != '' && searchString != null){
	      soql = soql +  ' where Name LIKE \'%' + searchString +'%\'';
	    }
	    soql = soql + ' limit 25';
	    System.debug(soql);
	    return database.query(soql); 
	}

	@AuraEnabled
	public static void saveNewBundle(Id cdId, Id caseId) {
	    ContentDistribution cd=[Select Id, DistributionPublicUrl, Name From ContentDistribution Where Id=:cdId];
	    FSA_BTO_Case_Content_Distribution__c bundle = new FSA_BTO_Case_Content_Distribution__c();
	    System.debug(cd);
	    bundle.Case__c=caseId;
	    bundle.Content_Name__c = cd.Name;
        bundle.Content_URL__c = cd.DistributionPublicUrl;
        insert bundle;
	}
}
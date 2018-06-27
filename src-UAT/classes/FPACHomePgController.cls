public with sharing class FPACHomePgController {
	
    //For section Top
	@auraEnabled
	public static list<HomePageFooter__mdt> getURLlist(){
		return [SELECT Id, Column__c, isHeaderFont__c, Section_Name__c, URL__c, MasterLabel,Sequence__c  FROM HomePageFooter__mdt where Section_Name__c='top' order by Sequence__c];
	}
    
    //For section Middle
	@auraEnabled
	public static list<HomePageFooter__mdt> gethyperlinks(){
		return [SELECT Id, Column__c, isHeaderFont__c, Section_Name__c, URL__c, MasterLabel,Sequence__c  FROM HomePageFooter__mdt where Section_Name__c='Middle' OR Section_Name__c='middle' order by Sequence__c ASC];
	}
    
    //To get number of middle columns
    @auraEnabled
	public static List<Integer> getColumns(){
        Set<Integer> cols = new Set<Integer>();
        List<Integer> colLst = new List<Integer>();
		List<HomePageFooter__mdt> hpfLst = [SELECT Column__c FROM HomePageFooter__mdt where Column__c!=null AND (Section_Name__c='Middle' OR Section_Name__c='middle') order by Column__c ASC];
        for(HomePageFooter__mdt hp: hpfLst){
            cols.add(Integer.valueOf(hp.Column__c));
            //system.debug('>>>>hp.Column__c'+hp.Column__c);
        }
        colLst.addAll(cols);
        //system.debug('>>>>'+colLst);
        return colLst;
	}
    //For Logo Urls
	@auraEnabled
	public static list<FPAC_FooterLogo__mdt> getLogolist(){
		return [SELECT Id, RedirectURL__c, ResourceURL__c, MasterLabel,Sequence__c  FROM FPAC_FooterLogo__mdt where Sequence__c!=null order by Sequence__c];
	}
    //For Base Urls
	@auraEnabled
	public static String getBaseUrl(){
		String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return baseURL;
	}
    //For Base Urls
	@auraEnabled
	public static String getContactId(){
		User thisUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('>>>>thisUser'+thisUser);
        return string.ValueOf(thisUser.ContactId);
	}
}
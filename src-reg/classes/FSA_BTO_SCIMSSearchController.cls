global with sharing class FSA_BTO_SCIMSSearchController {
    public String uniqueIdentifier { get; set; }
    public String orgName { get; set; }
    public String orgHost { get; set; }
    public String stateFIPSCode { get; set; }
    public String countyFIPSCode { get; set; }
    public String searchURL { get; set; }
    public String returnURL { get; set; }
    public String endURL { get; set; }
    public String orgURL = System.URL.getSalesforceBaseUrl().getHost();
    
    public void init() {
        // site.Subdomain returns 'fsa-usda-gov' there also seems to be no way to query for the force.com instance url (cs32.force.com)
        Site site = [SELECT Subdomain FROM Site WHERE Name='FSA_BTO_SCIMSSearchResultsInbound'];
        
        Id userId = UserInfo.getUserId();
        List<User> u = [SELECT FederationIdentifier, Username, FSA_BTO_FIPS_Code__c FROM User WHERE Id =: userId];
        if(!String.isEmpty(u[0].FederationIdentifier)) {
            uniqueIdentifier = u[0].FederationIdentifier;
        } else {
            uniqueIdentifier = u[0].Username;
        }
        String fipsCode = u[0].FSA_BTO_FIPS_Code__c;
        if(fipsCode != null) {
            stateFIPSCode = '<StateFIPSCode>' + fipsCode.substring(0,2) + '</StateFIPSCode>';
            countyFIPSCode = '<CountyFIPSCode>' + fipsCode.substring(2,5) + '</CountyFIPSCode>';
        }
        
        if(orgURL.containsIgnoreCase('fsa--dev')) {
            searchURL = 'https://cert1-intranet-apps.fsa.usda.gov/SCIMSCustSearch/SearchOption.do';
            returnURL = 'https://dev-' + site.Subdomain + '.cs32.force.com/';
            orgName = 'FSA BTO DEV SANDBOX';
            orgHost = orgURL;
            endURL = 'https://' + orgURL;
        } else if(orgURL.containsIgnoreCase('fsa--test')) {
            searchURL = 'https://int1-intranet-apps.fsa.usda.gov/SCIMSCustSearch/SearchOption.do';
            returnURL = 'https://test-' + site.Subdomain + '.cs32.force.com/';
            orgName = 'FSA BTO TEST SANDBOX';
            orgHost = orgURL;
            endURL = 'https://' + orgURL;
        } else if(orgURL.containsIgnoreCase('fsa--fsapreprod')) {
            searchURL = 'https://cert1-intranet-apps.fsa.usda.gov/SCIMSCustSearch/SearchOption.do';
            returnURL = 'https://fsapreprod-' + site.Subdomain + '.cs33.force.com/';
            orgName = 'FSA BTO PREPROD SANDBOX';
            orgHost = orgURL;
            endURL = 'https://' + orgURL;
        } else if(orgURL.containsIgnoreCase('fsa--c') || orgURL.containsIgnoreCase('fsa.my')){
            searchURL = 'https://intranet-apps.fsa.usda.gov/SCIMSCustSearch/SearchOption.do';
            returnURL = 'https://fsa-usda-gov.secure.force.com/';
            orgName = 'FSA BTO PRODUCTION';
            orgHost = orgURL;
            endURL = 'https://' + orgURL;
        }
        System.debug(returnURL);
    }
    
    @RemoteAction
    global static String setTimeZone(String userTimeZone) {
        ReturnStatus returnStatus = new ReturnStatus();
        try {
            if(userTimeZone != UserInfo.getTimeZone().getID()){
                User u = [SELECT Id, TimeZoneSidKey FROM User WHERE ID =: UserInfo.getUserId()];
                System.debug('current timezone: ' + UserInfo.getTimeZone().getID());
                System.debug('new timezone: ' + userTimeZone);
                u.TimeZoneSidKey = userTimeZone;
                update u;
                returnStatus.success = true;
                returnStatus.message = 'Successfully changed the time zone to ' + userTimeZone;
            }
        } catch(Exception e) {
            returnStatus.success = false;
            returnStatus.message = e.getMessage();
        }
        return JSON.serialize(returnStatus);
    }
    
    public class ReturnStatus{
        boolean success;
        String message;    
    }

}
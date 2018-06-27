public class FSA_BTO_CountyTriggerHelper {

	public static void preventDeleteCounty(List<FSA_BTO_County__c> oldCounties){
	    Profile profile = [SELECT Name from Profile where Id = :UserInfo.getProfileId()];

	    if(profile.Name!='System Administrator') {
	        for(FSA_BTO_County__c county: oldCounties) {
	            county.addError('Error: You are not allowed to delete county records.');
	        }
	    }
	}

}
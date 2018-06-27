public class FSA_BTO_UserTriggerHelper {

	public static void getUserCoordinates(List<User> users){
		if(!System.isFuture()){
			Set<ID> ids = new Set<Id>();
		    for(User u : users){
		        if( u.FSA_BTO_Location__latitude__s == null && String.isNotBlank(u.Street))
		        {
		        	ids.add(u.Id);
		        }
		    }
		    FSA_BTO_LocationCallouts.getuserLocation(ids);
		}
	}

}
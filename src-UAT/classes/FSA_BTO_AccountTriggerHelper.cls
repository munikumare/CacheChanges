public without sharing class FSA_BTO_AccountTriggerHelper {

	public static void preventDeleteAccount(List<Account> oldAccounts){
		Account scimsCustomer = [SELECT Id FROM Account WHERE Name = 'SCIMS Customer'];
	    Account usdaAgency = [SELECT Id FROM Account WHERE Name = 'USDA Farm Service Agency'];
	    Profile profile = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
	    
	    for(Account a: oldAccounts) {
	        if(profile.Name != 'System Administrator' && a.Id == scimsCustomer.Id || a.Id == usdaAgency.Id) {
	            a.addError('You are not allowed to delete this specific record.');
	        }
	    }
	}

	public static void syncRecordTypes(List<Account> newAccounts, Map<Id, Account> oldAccountMap){
		if(!System.IsFuture()){
			Set<Id> accountRecordTypeChangeIds=new Set<Id>();
			for(Account a: newAccounts){
				if(oldAccountMap.get(a.Id).RecordTypeId!=a.RecordTypeId){
					accountRecordTypeChangeIds.add(a.Id);
				}
			}
			if(!accountRecordTypeChangeIds.isEmpty()){
    			FSA_BTO_RecordTypeHelper.updateRecordTypesAccount(accountRecordTypeChangeIds);
    		}
    	}
	}

	public static void getAccountCoordinates(List<Account> accounts){
		if(!System.IsFuture()){
			Set<ID> ids = new Set<Id>();
		    for(Account a : accounts){
		        if( a.FSA_BTO_Location__latitude__s == null && String.isNotBlank(a.BillingStreet)){
		        	ids.add(a.Id);
		        }
		    }
		    if(!ids.isEmpty()){
		    	FSA_BTO_LocationCallouts.getAccountLocation(ids);
		    }
		}
	}

}
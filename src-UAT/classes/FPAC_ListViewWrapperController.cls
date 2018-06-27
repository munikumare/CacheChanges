public with sharing class FPAC_ListViewWrapperController {
	//For loading the list views of specific container type
	@auraEnabled
	public static list<FPAC_ListViewWrapper__mdt> getListViewlist(String whereCls){
		return [SELECT Id, DeveloperName ,
                        Object_Name__c, 
                        Fields__c, 
                        Number_of_Records__c, 
                        Action_Label__c,
                        View_More_Count__c,Default_SortBy__c ,
                        MasterLabel,Container_Name__c,
                        Sequence__c  FROM FPAC_ListViewWrapper__mdt 
                		where Container_Name__c=:whereCls 
                		order by Sequence__c ASC];
	}
}
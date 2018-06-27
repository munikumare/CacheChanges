public with sharing class FPAC_LightningTableController {
    
    @AuraEnabled public static lightningTableWraper getsObjectRecords(String objectName, String fieldstoget, String sortBy, String sortDir, Integer recLimit,String whrClass){     
        
        integer recordCount=0;
        Id recTypeId;
        String queryString;
        Id loggedUser = UserInfo.getUserId();
        String recCntStr = '';
        String sortByStr = ' ';

        List<String> lstfieldstoget = fieldstoget.split(',');
        
        List<lightningTableColumnWrapper> lstTableColumn = new list<lightningTableColumnWrapper> ();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(ObjectName).getDescribe();
         
        for(String field : lstfieldstoget){
            lightningTableColumnWrapper colWrapper = new lightningTableColumnWrapper();
            DescribeFieldResult fieldResult = objResult.fields.getMap().get(field).getDescribe();
            colWrapper.label = fieldResult.getLabel();
            colWrapper.fieldName = fieldResult.getName();
            colWrapper.type = String.valueof(fieldResult.getType()).toLowerCase();
            colWrapper.sortable = true; 
            lstTableColumn.add(colWrapper);
        }
        
        system.debug('>>>'+whrClass);
        system.debug('>>>'+ObjectName);
        system.debug('loggedUser>>>'+loggedUser);
        system.debug('sortByStr>>>'+sortByStr);
        
        if(sortBy!=null && String.escapeSingleQuotes(sortBy)!='CONST_NullValue' && String.escapeSingleQuotes(sortBy)!=''){
            sortByStr = 'Order By '+sortBy+ ' ' + sortDir;
            //sortByStr = 'Order By '+sortBy+ ' desc ';
        }
        
        queryString = recCntStr = 'Select '+ String.escapeSingleQuotes(String.join(lstfieldstoget,','))+
                                    ' from '+ String.escapeSingleQuotes(ObjectName);

        //Applies only for Additional Resources Object
        if(ObjectName=='Additional_Resource__c'){
            recTypeId = Schema.SObjectType.Additional_Resource__c.getRecordTypeInfosByName().get(whrClass).getRecordTypeId();
            queryString = queryString + ' where RecordTypeId=:recTypeId limit ' +recLimit;
            system.debug('queryString>>>'+queryString);
        }
        //Applies only for Land Object
        else if(ObjectName=='Land_View__c'){
            queryString = queryString + ' ' + sortByStr + ' limit ' +recLimit;
            system.debug('queryString>>>'+queryString);
        } 

        else{
            queryString = queryString + ' ' + sortByStr +' Limit ' +recLimit;
            system.debug('queryString>>>'+queryString);
        }
        
        /***** Logic for manipulating date in Lightning:Datatabe date fields*****/
        //LIST<sObject> objLst =  database.query(queryString);
        /**********/

        LightningTableWraper ltngTableWrapper = new LightningTableWraper();
        ltngTableWrapper.tableRecord = database.query(queryString);
        ltngTableWrapper.tableColumn = lstTableColumn;
        ltngTableWrapper.fieldNames = lstfieldstoget;
        system.debug('ltngTableWrapper.tableRecord>>>'+ltngTableWrapper.tableRecord);
        return ltngTableWrapper;
    }
     
    
    public class lightningTableColumnWrapper {
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public String fieldName {get;set;}
        @AuraEnabled
        public string type {get;set;}
        @AuraEnabled
        public boolean sortable {get;set;}
    }
    
    public class lightningTableWraper{
        @AuraEnabled
        public List<sObject> tableRecord {get;Set;}
        @AuraEnabled
        public List<String> fieldNames {get;Set;}
        @AuraEnabled
        public List<lightningTableColumnWrapper> tableColumn {get;set;}
        @AuraEnabled
        public Integer recCount {get;set;}
    }
    
}
public class ViewWebServiceController {
    public List<NAP_RMA_NCT_ACR_Data__c> napDetails {get; set;}   
    public List<NAP_RMA_NCT_ACR_Data__c> acreageDetails {get; set;}  
    public List<NAP_RMA_NCT_ACR_Data__c> rmaDetails {get; set;}  
    public List<NAP_RMA_NCT_ACR_Data__c> nctDetails {get; set;}  
    private static final Id NAP_RECORD_TYPE_ID = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.getRecordTypeInfosByName().get('NAP Data').getRecordTypeId();
    private static final Id ACR_RECORD_TYPE_ID = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.getRecordTypeInfosByName().get('ACR Data').getRecordTypeId();
    private static final Id RMA_RECORD_TYPE_ID = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.getRecordTypeInfosByName().get('RMA Data').getRecordTypeId();
    private static final Id NCT_RECORD_TYPE_ID = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.getRecordTypeInfosByName().get('NCT Data').getRecordTypeId();
    public ViewWebServiceController()
        {
            string searchId = ApexPages.currentPage().getParameters().get('Id');
            string pageName = ApexPages.currentPage().getParameters().get('pageName');
            string ccid ='';
            
            if(pageName=='WHIP')
            {
            	ccid = getWhipApplicationCCID(searchId);
            }else if(pageName=='Contact')
            {
                ccid = getContactCCID(searchId);
            }
          
            if(ccid !=null && ccid !='')
            {
                system.debug(ccid);
                napDetails = getnapDetails(ccid);
                acreageDetails= getacreageDetails(ccid);
                rmaDetails= getrmaDetails(ccid);
                nctDetails =getnctDetails(ccid);
            }
       }
    
    public string  getWhipApplicationCCID(string searchId)
    {
        string ccid ='';
        string IndividualId =[SELECT Individual__c FROM WHIP_Application__c WHERE ID=:searchId LIMIT 1].Individual__c;
        if (IndividualId !=null && IndividualId !='')
        {
        	ccid =[SELECT FSA_BTO_Core_Customer_ID__c FROM Contact WHERE ID=:IndividualId LIMIT 1].FSA_BTO_Core_Customer_ID__c;
        }
        return ccid;
    }
    
   public string  getContactCCID(string searchId)
    {
        string ccid =[SELECT FSA_BTO_Core_Customer_ID__c FROM Contact where ID=:searchId LIMIT 1].FSA_BTO_Core_Customer_ID__c;
        return ccid;
    }
    
    
    public  List<NAP_RMA_NCT_ACR_Data__c> getnapDetails(string ccid)
    { 
            System.debug('ccid=' + ccid);
        	String query = 'SELECT ';             
            List<Schema.FieldSetMember> tempSchema = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.fieldSets.getMap().get('NAPFieldSet').getFields();
            for (Schema.FieldSetMember f : tempSchema) {
                    query += f.getFieldPath() + ', ';
                }
                query += 'Id FROM NAP_RMA_NCT_ACR_Data__c WHERE CCID__c =:ccid AND RecordTypeId =:NAP_RECORD_TYPE_ID ORDER BY NAME';
                List<NAP_RMA_NCT_ACR_Data__c> AllNapServiceRecords  = database.query(query);
                return AllNapServiceRecords; 
    }
    
     public  List<NAP_RMA_NCT_ACR_Data__c> getacreageDetails(string ccid)
    {
            String query = 'SELECT '; 
            List<Schema.FieldSetMember> tempSchema = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.fieldSets.getMap().get('AcreageFieldSet').getFields();
            for (Schema.FieldSetMember f : tempSchema) {
                    query += f.getFieldPath() + ', ';
                }
        		
                query += 'Id FROM NAP_RMA_NCT_ACR_Data__c WHERE CCID__c =:ccid AND RecordTypeId =:ACR_RECORD_TYPE_ID ORDER BY NAME';
        		system.debug(query);
                List<NAP_RMA_NCT_ACR_Data__c> AllAcrServiceRecords  = database.query(query);
                return AllAcrServiceRecords;
    }
    
  public  List<NAP_RMA_NCT_ACR_Data__c> getrmaDetails(string ccid)
    {
            String query = 'SELECT '; 
            List<Schema.FieldSetMember> tempSchema = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.fieldSets.getMap().get('RMAFieldSet').getFields();
            for (Schema.FieldSetMember f : tempSchema) {
                    query += f.getFieldPath() + ', ';
                }
                query += 'Id FROM NAP_RMA_NCT_ACR_Data__c WHERE CCID__c =:ccid AND RecordTypeId =:RMA_RECORD_TYPE_ID ORDER BY NAME';
                List<NAP_RMA_NCT_ACR_Data__c> AllRMAServiceRecords  = database.query(query);
                return AllRMAServiceRecords;
    }
    
    public  List<NAP_RMA_NCT_ACR_Data__c> getnctDetails(string ccid)
    {
        	String query = 'SELECT '; 
            List<Schema.FieldSetMember> tempSchema = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c.fieldSets.getMap().get('NCTFieldSet').getFields();
            for (Schema.FieldSetMember f : tempSchema) {
                    query += f.getFieldPath() + ', ';
                }
                query += 'Id FROM NAP_RMA_NCT_ACR_Data__c WHERE CCID__c =:ccid AND RecordTypeId =:NCT_RECORD_TYPE_ID ORDER BY NAME';
                List<NAP_RMA_NCT_ACR_Data__c> AllNCTServiceRecords  = database.query(query);
                return AllNCTServiceRecords; 
    }
}
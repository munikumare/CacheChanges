public without sharing class FPAC_SCIMS_AuthorityProcessor {
    public final String ROLE_OPERATOR = 'Operator';
    public final String ROLE_OWNER = 'Owner';
    public final String ROLE_OTHERPROD_TRACT = 'Other Tenant - Tract';
    public final String ROLE_OTHERPROD_FIELD = 'Other Tenant - Field';
    
    FPAC_SCIMS_FarmProcessor farmProcessor = new FPAC_SCIMS_FarmProcessor();

    //Based on loginflow execute the below method
    public String processCustomerandAuthority(String contactID){
        try{
            if(contactID!=null && contactID!=''){
                List<string> coreCustomerIds = new List<string>();
                Map<String, Id> custCoreIdMap = new Map<String,Id>();
                String loggedInCCID = '';
                List<FPAC_SCIMS_Farm> scimsFarmList = new List<FPAC_SCIMS_Farm> ();
                List<FPAC_SCIMS_ProducerAuth> producerAuthList = new List<FPAC_SCIMS_ProducerAuth> ();
                
                //AS PER CLARIFICATION EMAIL FROM WES - Pointer 8
                contact loggedInCustomer = [Select id, FSA_BTO_Core_Customer_ID__c from Contact where id=:contactID];
                coreCustomerIds.add(loggedInCustomer.FSA_BTO_Core_Customer_ID__c);
                loggedInCCID = loggedInCustomer.FSA_BTO_Core_Customer_ID__c;

                //ADDING LOGGED IN USER-CONTACT TO THE CORE CUSTOMER MAP. 
                custCoreIdMap.put(loggedInCustomer.FSA_BTO_Core_Customer_ID__c,loggedInCustomer.id);

                /************** FARMS PROCESSOR ****************/
                FPAC_SCIMS_ProducerFarmDataResponse prodFarmResponse = farmProcessor.getProducerFarmData(coreCustomerIds);
                scimsFarmList = prodFarmResponse.farms;
                producerAuthList = prodFarmResponse.producerAuths;
                
                /******** KEEPING THIS AS BACKUP FIX ****/
                //List<FPAC_SCIMS_Farm> scimsFarmList = farmProcessor.getProducerFarmData(coreCustomerIds);
                
                /************** CUSTOMER PROCESSOR - Process contact records and upsert ****************/
                FPAC_SCIMS_CustomerProcessor custProcessor = new FPAC_SCIMS_CustomerProcessor();
				Set<String> tempCoreCustSet = new Set<String>();
        		tempCoreCustSet.addAll(farmProcessor.GetCoreCustIds(scimsFarmList));
        		for(FPAC_SCIMS_ProducerAuth pa: producerAuthList){
                    tempCoreCustSet.add(pa.ccid);
                }
                List<String> tempCoreCustList = new List<String>();
        		tempCoreCustList.addAll(tempCoreCustSet);
                system.debug('>>>'+tempCoreCustList);
                
                
                List<FPAC_SCIMS_Customer> scimsCustList = custProcessor.GetCustomerDetails(tempCoreCustList);
                List<Contact> conList = custProcessor.SaveContacts(scimsCustList);
                system.debug('>>>conList>>>'+conList);
                

                /************** GENERATE CORE CUSTOMER ID MAP ****************/
                for(contact con: conList){
                    custCoreIdMap.put(con.FSA_BTO_Core_Customer_ID__c,con.id);
                    system.debug('>>>con.FSA_BTO_Core_Customer_ID__c>>>'+con.FSA_BTO_Core_Customer_ID__c);
                    system.debug('>>>con.id>>>'+con.id);
                }
                
                
                /************* MAP CONTACT IDS TO SCIMS FARM LIST ********************/
                //mapIndividualIds(custCoreIdMap, scimsFarmList);
                for(String key : custCoreIdMap.keySet())
                { 
                    if(scimsFarmList != null)
                    {
                        for(FPAC_SCIMS_Farm scimsFarm : scimsFarmList)
                        {
                            scimsFarm.CoreCustomerId = key; 
                            scimsFarm.IndividualId = custCoreIdMap.get(key); 
                        }    
                    }
                }
				system.debug('>>>>'+custCoreIdMap.values());
                /************** UPDATE LAND DATA WITH UPDATED scimsFarmList ****************/
                List<Land__c> upsertedLandList = farmProcessor.SaveFarmData(scimsFarmList);

                
                /************** GENERATE LAND EXTERNAL ID MAP ****************/
                Map<String,Id> landExtIdMap = new Map<String,Id>();
                for(Land__c lnd: upsertedLandList){
                    landExtIdMap.put(lnd.Land_Id__c,lnd.id);
                }

                /************** CONSTRUCT CONTACT USER MAP ****************/
                Map<Id,Id> contactUserMap = new Map<Id,Id>();
                List<user> userList = [Select id,contactId from user where contactId in:custCoreIdMap.values()];
                for(user usr: userList){
                    contactUserMap.put(usr.contactId,usr.Id);
                }

                /************** DELETE AND RE-CREATE AUTHORITY RECORDS ****************/
                system.debug('>>>scimsFarmList.size()>>'+scimsFarmList.size());
                system.debug('>>>scimsFarmList>>'+scimsFarmList);
                system.debug('>>>prodFarmResponse>>'+prodFarmResponse);
                if(scimsFarmList.size()>0 && prodFarmResponse != null){
                    DeleteAndCreateAuthority(loggedInCustomer.Id,custCoreIdMap, landExtIdMap, contactUserMap,scimsFarmList);
                    processProducerAuthRecords(loggedInCustomer.Id, loggedInCCID, producerAuthList, custCoreIdMap);
                    return 'Records exist';
                }
                else {
                    return 'No records';  
                }
            }
            else{
                //Logic to display ERROR message.
                return 'error';
            }
        } catch(Exception ex) {
            return 'error';
        }
            
    }


    public List<String> generateCoreCustIds(List<FPAC_SCIMS_Farm> scimsFarmList){
        Set<String> tempCoreCustSet = new Set<String>();
        tempCoreCustSet.addAll(farmProcessor.GetCoreCustIds(scimsFarmList));
        List<String> tempCoreCustList = new List<String>();
        tempCoreCustList.addAll(tempCoreCustSet);
        return tempCoreCustList;
    }

    public void mapIndividualIds(Map<String,Id> custCoreIdMap, List<FPAC_SCIMS_Farm> scimsFarmList){
        for(String key : custCoreIdMap.keySet())
        { 
            if(scimsFarmList != null)
            {
                for(FPAC_SCIMS_Farm scimsFarm : scimsFarmList)
                {
                    scimsFarm.CoreCustomerId = key; 
                    scimsFarm.IndividualId = custCoreIdMap.get(key); 
                }    
            }
        }
    }
	
    public void DeleteAndCreateAuthority(Id loggedInCustomerID,  Map<String,Id> custCoreIdMap, Map<String,Id> landExtIdMap,Map<Id,Id> contactUserMap, List<FPAC_SCIMS_Farm> scimsFarmList){
        /************** DELETE AND CREATE AUTHORITY RECORDS ****************/
        DeleteAuthority(custCoreIdMap,landExtIdMap);
        CreateAuthority(loggedInCustomerID, custCoreIdMap, landExtIdMap, contactUserMap, scimsFarmList);

    }


    public void DeleteAuthority(Map<String,Id> custCoreIdMap, Map<String,Id> landExtIdMap)
    {
        List<Authority__c> authorityToDelete = [Select id from Authority__c where Associated_Land__c in:landExtIdMap.values() OR Contact__c in:custCoreIdMap.values()];
        if(authorityToDelete.size()>0){
            Database.DeleteResult[] delAuthList = Database.delete(authorityToDelete, false);
            System.Debug('Deleted Authorities' +delAuthList.size());
        }
            
    }
    
    public void DeleteEntityRelationhip(List<String> CCIDlist)
    {
        List<Entity_Relationship__c> entitiesToDelete = [Select id from Entity_Relationship__c where Entity_CCID__c in:CCIDlist];
        if(entitiesToDelete.size()>0){
            Database.DeleteResult[] delEntityList = Database.delete(entitiesToDelete, false);
            System.Debug('Deleted Entity Relationships of size: ' +delEntityList.size());
        }
            
    }

    public void CreateAuthority(Id loggedInCustomer, Map<String, Id> custCoreIdMap, Map<String, Id> landExtIdMap, Map<Id,Id> contactUserMap, List<FPAC_SCIMS_Farm> scimsFarmList)
    {
        List<Authority__c> authorityToInsertList = new List<Authority__c>();
        Authority__c authRec;
        Map<String,Authority__c> contactLandMap = new Map<String,Authority__c>();
        for(FPAC_SCIMS_FARM farmRec : scimsFarmList) {
            if(farmRec.farmYears != null) {
                for(FPAC_SCIMS_FarmYear frmYr : farmRec.FarmYears){
                    
                    // creating Operator at farm level
                    authRec = new Authority__c();
                    authRec.Contact__c = custCoreIdMap.get(frmYr.Operator.coreCustomerId);
                    authRec.Associated_Land__c = landExtIdMap.get(farmRec.CalculatedId);
                    authRec.Role__c = ROLE_OPERATOR;
                    authRec.User__c = contactUserMap.get(custCoreIdMap.get(frmYr.Operator.coreCustomerId));
                    if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                        authorityToInsertList.add(authRec);
                        contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                    }
                    else {
                        system.debug('Duplicate Found Auth existing ' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' +authRec);
                    }

                    for(FPAC_SCIMS_Tract trct: frmYr.Tracts) {
                        //creating Operator at Tract Level
                        boolean isOwnerOnTract = false;
                        if(trct.Owners!=null){
                            for(FPAC_SCIMS_OtherProducer tractOwner: trct.Owners){
                                if(custCoreIdMap.get(frmYr.Operator.coreCustomerId) == custCoreIdMap.get(tractOwner.coreCustomerId)) {
                                    isOwnerOnTract = true;
                                }
                            }
                        }
                        
                        authRec = new Authority__c();
                        authRec.Contact__c = custCoreIdMap.get(frmYr.Operator.coreCustomerId);
                        authRec.Associated_Land__c = landExtIdMap.get(trct.CalculatedId);
                        authRec.Role__c = isOwnerOnTract ? ROLE_OWNER : ROLE_OPERATOR;
                        authRec.User__c = contactUserMap.get(custCoreIdMap.get(frmYr.Operator.coreCustomerId));
                        if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                            authorityToInsertList.add(authRec);
                            contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                        }
                        else {
                            system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' + authRec);
                        }
                        if(trct.commonLandUnitYears != null) {
                            for(FPAC_SCIMS_CommonLandUnitYear fld: trct.commonLandUnitYears){
                                //creating Operator at field Level
                                authRec = new Authority__c();
                                authRec.Contact__c = custCoreIdMap.get(frmYr.Operator.coreCustomerId);
                                authRec.Associated_Land__c = landExtIdMap.get(fld.CalculatedId);
                                authRec.Role__c = isOwnerOnTract ? ROLE_OWNER : ROLE_OPERATOR;
                                authRec.User__c = contactUserMap.get(custCoreIdMap.get(frmYr.Operator.coreCustomerId));
                                if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                    authorityToInsertList.add(authRec);
                                    contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                }
                                else {
                                    system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' + authRec);
                                }
                            }
                        }
                    }

                    //creating Other Tenant Farm
                    if(frmYr.Tracts!=null){
                        for(FPAC_SCIMS_Tract trct: frmYr.Tracts){
                            if(trct.Owners!=null){
                                for(FPAC_SCIMS_OtherProducer tractOwner: trct.Owners){
                                    
                                    //owner at tract
                                    authRec = new Authority__c();
                                    authRec.Contact__c = custCoreIdMap.get(tractOwner.coreCustomerId);
                                    authRec.Associated_Land__c = landExtIdMap.get(trct.CalculatedId);
                                    authRec.Role__c = ROLE_OWNER;
                                    authRec.User__c = contactUserMap.get(custCoreIdMap.get(tractOwner.coreCustomerId));
                                    if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c) ){
                                        authorityToInsertList.add(authRec);
                                        contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                    }
                                    else {
                                        system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' +authRec);
                                    }
                                    
                                    //owner at tract is owner at farm
                                    authRec = new Authority__c();
                                    authRec.Contact__c = custCoreIdMap.get(tractOwner.coreCustomerId);
                                    authRec.Associated_Land__c = landExtIdMap.get(farmRec.CalculatedId);
                                    authRec.Role__c = ROLE_OWNER;
                                    authRec.User__c = contactUserMap.get(custCoreIdMap.get(tractOwner.coreCustomerId));
                                    if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                        authorityToInsertList.add(authRec);
                                        contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                    }
                                    
                                    //else not applicable here, because only 1 record is created even if the owner is on 2 different tracts
                                    if(trct.commonLandUnitYears != null) {
                                        for(FPAC_SCIMS_CommonLandUnitYear fld: trct.commonLandUnitYears){
                                            //creating Owner at field Level
                                            authRec = new Authority__c();
                                            authRec.Contact__c = custCoreIdMap.get(tractOwner.coreCustomerId);
                                            authRec.Associated_Land__c = landExtIdMap.get(fld.CalculatedId);
                                            authRec.Role__c = ROLE_OWNER;
                                            authRec.User__c = contactUserMap.get(custCoreIdMap.get(tractOwner.coreCustomerId));
                                            if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                                authorityToInsertList.add(authRec);
                                                contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                            }
                                            else {
                                                system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' + authRec);
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if(trct.OtherProducers != null){
                                for(FPAC_SCIMS_OtherProducer tractOthrProd: trct.OtherProducers){
                                    //Other producer at tract
                                    authRec = new Authority__c();
                                    authRec.Contact__c = custCoreIdMap.get(tractOthrProd.coreCustomerId);
                                    authRec.Associated_Land__c = landExtIdMap.get(trct.CalculatedId);
                                    authRec.Role__c = ROLE_OTHERPROD_TRACT;
                                    authRec.User__c = contactUserMap.get(custCoreIdMap.get(tractOthrProd.coreCustomerId));
                                    if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                        authorityToInsertList.add(authRec);
                                        contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                    }
                                    else {
                                        system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' +authRec);
                                    }
                                    
                                    //Other Producer at tract is Other Producer at farm
                                    authRec = new Authority__c();
                                    authRec.Contact__c = custCoreIdMap.get(tractOthrProd.coreCustomerId);
                                    authRec.Associated_Land__c = landExtIdMap.get(farmRec.CalculatedId);
                                    authRec.Role__c = ROLE_OTHERPROD_TRACT;
                                    authRec.User__c = contactUserMap.get(custCoreIdMap.get(tractOthrProd.coreCustomerId));
                                    if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                        authorityToInsertList.add(authRec);
                                        contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                    }
                                    
                                    //else not applicable here, because only 1 record is created even the owner is on 2 different tracts
                                    if(trct.commonLandUnitYears != null) {
                                        for(FPAC_SCIMS_CommonLandUnitYear fld: trct.commonLandUnitYears){
                                            //creating Owner at field Level
                                            authRec = new Authority__c();
                                            authRec.Contact__c = custCoreIdMap.get(tractOthrProd.coreCustomerId);
                                            authRec.Associated_Land__c = landExtIdMap.get(fld.CalculatedId);
                                            authRec.Role__c = ROLE_OTHERPROD_TRACT;
                                            authRec.User__c = contactUserMap.get(custCoreIdMap.get(tractOthrProd.coreCustomerId));
                                            if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                                authorityToInsertList.add(authRec);
                                                contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                            }
                                            else {
                                                system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' + authRec);
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if(trct.commonLandUnitYears != null) {
                                for(FPAC_SCIMS_CommonLandUnitYear fld: trct.commonLandUnitYears){
                                    if(fld.otherProducers != null) {
                                        for(FPAC_SCIMS_OtherProducer fldOthrProd: fld.OtherProducers){
                                            
                                            //Other producer at field
                                            authRec = new Authority__c();
                                            authRec.Contact__c = custCoreIdMap.get(fldOthrProd.coreCustomerId);
                                            authRec.Associated_Land__c = landExtIdMap.get(fld.CalculatedId);
                                            authRec.Role__c = ROLE_OTHERPROD_FIELD;
                                            authRec.User__c = contactUserMap.get(custCoreIdMap.get(fldOthrProd.coreCustomerId));
                                            if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                                authorityToInsertList.add(authRec);
                                                contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                            }
                                            else {
                                                system.debug('Duplicate Found Auth existing' + contactLandMap.get('' + authRec.Contact__c + authRec.Associated_Land__c) + ' with ' + authRec);
                                            }
                                            
                                            //Other producer at field is other producer at tract
                                            authRec = new Authority__c();
                                            authRec.Contact__c = custCoreIdMap.get(fldOthrProd.coreCustomerId);
                                            authRec.Associated_Land__c = landExtIdMap.get(trct.CalculatedId);
                                            authRec.Role__c = ROLE_OTHERPROD_FIELD;
                                            authRec.User__c = contactUserMap.get(custCoreIdMap.get(fldOthrProd.coreCustomerId));
                                            if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                                authorityToInsertList.add(authRec);
                                                contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
                                            }
                                            
                                            //Other producer at field is other producer at farm
                                            authRec = new Authority__c();
                                            authRec.Contact__c = custCoreIdMap.get(fldOthrProd.coreCustomerId);
                                            authRec.Associated_Land__c = landExtIdMap.get(farmRec.CalculatedId);
                                            authRec.Role__c = ROLE_OTHERPROD_FIELD;
                                            authRec.User__c = contactUserMap.get(custCoreIdMap.get(fldOthrProd.coreCustomerId));
                                            if(!contactLandMap.containsKey('' + authRec.Contact__c + authRec.Associated_Land__c)) {
                                                authorityToInsertList.add(authRec);
                                                contactLandMap.put('' + authRec.Contact__c + authRec.Associated_Land__c, authRec);
   
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        //Insert Authority Records
        Database.SaveResult[] resultsForAuthority = Database.insert(authorityToInsertList, false);  
        Map<String,Authority__c > keySet = new Map<String,Authority__c >();
        for(Authority__c auth : authorityToInsertList ) {
            if( auth.Contact__c != null) {
                if(keySet.containsKey('' + auth.Contact__c + auth.Associated_Land__c)) {
                    system.debug('auth ' + auth + ' is duplicate with ' + keySet.get('' + auth.Contact__c + auth.Associated_Land__c));
                }
                else {
                    keySet.put('' + auth.Contact__c + auth.Associated_Land__c,auth);
                }
            }
        }
        system.debug('authorityToInsertList is ' + authorityToInsertList);
        for(Integer index = 0, size = resultsForAuthority.size(); index < size; index ++) {
            if(resultsForAuthority[index].isSuccess()) {
                    //System.debug(authorityToInsertList[index] + ' was created/updated');
            }
            else
            {
                for(Database.Error error : resultsForAuthority[index].getErrors())
                {
                    System.debug('Error with Authority Record ' + authorityToInsertList[index] + ' - ' + error.getMessage());
                }
            }
        }
        //System.debug('*****>'+generateCoreCustIds(scimsFarmList));
    }

    public void processProducerAuthRecords(Id loggedInContact, String loggedInCCID, List<FPAC_SCIMS_ProducerAuth> producerAuthList, Map<String, Id> custCoreIdMap){
        List<Entity_Relationship__c> entityRelationList = new List<Entity_Relationship__c>();
        List<String> CCIDlistToDelete = new List<String>();
        System.debug('&&&&&producerAuthList>'+producerAuthList);
        for(FPAC_SCIMS_ProducerAuth PA :producerAuthList){
            System.debug('&&&&&PA.ccid>'+PA.ccid);
            if(PA.ccid!=loggedInCCID){
                Entity_Relationship__c erRecord = new Entity_Relationship__c(
                                                        CCID__c = loggedInCCID,
                                                        Contact_Name__c = loggedInContact, 
                                                        Entity_CCID__c = PA.ccid,
                                                        Entity_Contact_Std__c = custCoreIdMap.get(PA.ccid),
                                                        Percentage_Share__c = Double.valueOf(PA.producerShare) * 100);
                entityRelationList.add(erRecord);
                CCIDlistToDelete.add(PA.ccid);
            }
            System.debug('&&&&&CCIDlistToDelete>'+CCIDlistToDelete);
        }

        if(CCIDlistToDelete.size()>0){
            System.debug('&&&&&CCIDlistToDelete2>'+CCIDlistToDelete);
            DeleteEntityRelationhip(CCIDlistToDelete);
        }
        
        for ( String key : custCoreIdMap.keySet() ) {
           System.debug('&&&&&custCoreIdMap>'+key);
        }
        System.debug('&&&&&custCoreIdMap>'+custCoreIdMap.values());

        Database.SaveResult[] resultsForEntityRealtionship = Database.insert(entityRelationList, false);  
        for(Integer index = 0, size = resultsForEntityRealtionship.size(); index < size; index ++) {
            if(resultsForEntityRealtionship[index].isSuccess()) {
                    //System.debug(resultsForEntityRealtionship[index] + ' was created/updated');
            }
            else
            {
                for(Database.Error error : resultsForEntityRealtionship[index].getErrors())
                {
                    System.debug('Error with Authority Record ' + entityRelationList[index] + ' - ' + error.getMessage());
                }
            }
        }

    }
}
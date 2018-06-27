public without sharing class FPAC_SCIMS_FarmProcessor {
    
  	public FPAC_SCIMS_ProducerFarmDataResponse getProducerFarmData(List<String> coreCustomerIds)
    {
        
        FPAC_SCIMS_ProducerFarmDataResponse scimsProducerFarm;

        string commaSeparatedCoreCustomerIds = String.join(coreCustomerIds, ',');

        if (!String.isBlank(commaSeparatedCoreCustomerIds))
        { 
            String endpoint = ('callout:Mulesoft_PreProd/getProducerFarmRecords?includeCustomer=true&includeTract=true&includeCrop=true&includeClu=true&includeHip=true&includeElection=true&coreCustomerId=' + commaSeparatedCoreCustomerIds + '&year=' + System.Today().year());
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setTimeout(40000);
            HttpResponse res = h.send(req);
            String scimsProducerFarmJson = res.getBody();
            //System.debug('>>>>Debug scimsProducerFarmJson: '+scimsProducerFarmJson);
            scimsProducerFarmJson = scimsProducerFarmJson.replace('"number":', '"ScimsNumber":');
            
            if(res.getStatusCode()==200 && !string.isBlank(scimsProducerFarmJson))
            {    
                scimsProducerFarm = (FPAC_SCIMS_ProducerFarmDataResponse) JSON.deserialize(scimsProducerFarmJson, FPAC_SCIMS_ProducerFarmDataResponse.class);
            }    
        }
        return scimsProducerFarm;
    }
    
    public List<String> GetCoreCustIds(List<FPAC_SCIMS_Farm> farmsList)
    {
        List<String> coreCustIds = new List<String>();
        Map<String,String> coreCustTypeMap = new Map<String,String>();
        
        for(FPAC_SCIMS_FARM farmRec : farmsList)
        {   
            if(farmRec.FarmYears!=null){
                //Inside list of Farm
                for(FPAC_SCIMS_FarmYear frmYr : farmRec.FarmYears)
                {
                    
                    //System.debug('>>>>>>>>frmYr.Operator: '+frmYr.Operator.coreCustomerId);
                    coreCustIds.add(frmYr.Operator.coreCustomerId);
                    
                    if(frmYr.OtherProducers!=null)
                    {
                        for(FPAC_SCIMS_OtherProducer farmOtherProd: frmYr.OtherProducers)
                        {
                            coreCustIds.add(farmOtherProd.coreCustomerId);
                        }

                    }

                    if(frmYr.Tracts!=null){
                        //Inside list of Tracts
                        for(FPAC_SCIMS_Tract trct: frmYr.Tracts){
                            
                            if(trct.Owners!=null)
                            {
                                for(FPAC_SCIMS_OtherProducer ownr: trct.Owners){
                                    //System.debug('>>>>>>>>trct Owner: '+ownr.coreCustomerId);
                                    coreCustIds.add(ownr.coreCustomerId);
                                }
                            }
                            
                            if(trct.OtherProducers != null)
                            {
                                for(FPAC_SCIMS_OtherProducer othrProd: trct.OtherProducers){
                                    //System.debug('>>>>>>>>Other Prod: '+othrProd.coreCustomerId);
                                    coreCustIds.add(othrProd.coreCustomerId);
                                }
                            }

                            if(trct.CommonLandUnitYears!=null)
                            {
                                for(FPAC_SCIMS_CommonLandUnitYear CLU: trct.CommonLandUnitYears)
                                {
                                    if(CLU.OtherProducers!=null)
                                    {
                                        for(FPAC_SCIMS_OtherProducer cluOtherProd: CLU.OtherProducers)
                                        {
                                            coreCustIds.add(cluOtherProd.coreCustomerId);
                                        }
                                    }
                                }

                            }

                        }
                    }
                    
                }
            }
            
        }
        return coreCustIds;
    }
    
    public List<FPAC_SCIMS_Farm> GetFarmData(Map<Id, String> coreCustomerIds)
    {
        string commaSeparatedCoreCustomerIds = String.join(coreCustomerIds.values(), ',');
        List<FPAC_SCIMS_Farm> scimsFarmList = new List<FPAC_SCIMS_Farm>();

        if (!String.isBlank(commaSeparatedCoreCustomerIds))
        {
            String endpoint = ('callout:Mulesoft_PreProd/getFarmRecords?includeCustomer=true&includeTract=true&includeCrop=true&includeClu=true&includeHip=true&includeElection=true&coreCustomerId=' + commaSeparatedCoreCustomerIds + '&year=' + System.Today().year());
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            String scimsFarmJson = res.getBody();
            System.debug(scimsFarmJson);
            scimsFarmJson = scimsFarmJson.replace('"number":', '"ScimsNumber":');
            
            if(res.getStatusCode()==200 && !string.isBlank(scimsFarmJson))
            { 
                scimsFarmList = (List<FPAC_SCIMS_Farm>) JSON.deserialize(scimsFarmJson, List<FPAC_SCIMS_Farm>.class);
                
				//get the customer names for  all farm operators based on ccid
		 		scimsFarmList = LoadFarmOperatorNames(scimsFarmList);
            }
            
        }
        return scimsFarmList;  
    }
    
    
    private List<FPAC_SCIMS_Farm> LoadFarmOperatorNames(List<FPAC_SCIMS_Farm> scimsFarmList)
    {
    	List<String> operatorCcids = new List<String>();
        Map<String, String> operatorCoreCustomerIdNameMap = new Map<String,String>();
        
        for(FPAC_SCIMS_Farm scimsFarm : scimsFarmList)
        {   
            if(scimsFarm.FarmYears != null){
              
                for(FPAC_SCIMS_FarmYear farmYear : scimsFarm.FarmYears){
                    
                    if (farmYear.Operator != null)
                    	operatorCcids.add(farmYear.Operator.CoreCustomerId);
                    
                }
            }
        }
                
        if (operatorCcids.size() > 0)
        {
        	FPAC_SCIMS_CustomerProcessor custProcessor = new FPAC_SCIMS_CustomerProcessor();
			List<FPAC_SCIMS_Customer> scimsCustomerList = custProcessor.GetCustomerDetails(operatorCcids);
			
			for(FPAC_SCIMS_Customer customer: scimsCustomerList)
	            operatorCoreCustomerIdNameMap.put(customer.CoreCustomerId, customer.CommonName);	
        }
            
        for(FPAC_SCIMS_Farm scimsFarm : scimsFarmList)
        {   
            if(scimsFarm.FarmYears != null){
              
                for(FPAC_SCIMS_FarmYear farmYear : scimsFarm.FarmYears){
                    
                    if (farmYear.Operator != null)
                    	farmYear.Operator.CommonName = operatorCoreCustomerIdNameMap.get(farmYear.Operator.CoreCustomerId);
                }
            }
        }
        
        return scimsFarmList;
    }
    
    
    public List<FPAC_SCIMS_Farm> GetFarmData(String stateCountyFarmNumber) {
       List<FPAC_SCIMS_Farm> scimsFarmList = new List<FPAC_SCIMS_Farm>();
       String endpoint = ('callout:Mulesoft_PreProd/getFarmRecords?includeTract=true&includeCrop=true&includeClu=true&farmNumbers=' + stateCountyFarmNumber + '&year=' + System.Today().year());
       endpoint = endpoint.deleteWhitespace();
       
       Http h = new Http();
       HttpRequest req = new HttpRequest();
       req.setEndpoint(endpoint);
       req.setMethod('GET');
       HttpResponse res = h.send(req);
       String scimsFarmJson = res.getBody();
       
       scimsFarmJson = scimsFarmJson.replace('"number":', '"ScimsNumber":');
       if(res.getStatusCode()==200 && !string.isBlank(scimsFarmJson))
       {
              scimsFarmList = (List<FPAC_SCIMS_Farm>) JSON.deserialize(scimsFarmJson, List<FPAC_SCIMS_Farm>.class);
              //get the customer names for  all farm operators based on ccid
             scimsFarmList = LoadFarmOperatorNames(scimsFarmList);
       }
       else {
           return null;
       }
       
       return scimsFarmList;
   }
    
    
    public List<Land__c> SaveFarmData(List<FPAC_SCIMS_Farm> scimsFarmList)
    {
        List<Land__c> finalLandList = new List<Land__c>();
        if(scimsFarmList != null && scimsFarmList.size() > 0)
        {
            
            List<Land__c> lands = FPAC_SCIMS_FarmYearConverter.ConvertToLands(scimsFarmList);
            FPAC_SCIMS_Farm farm = new FPAC_SCIMS_Farm();
            
            finalLandList.addAll(farm.Save(lands));
            
            List<FPAC_SCIMS_Tract> scimsTractsToBeSaved = new List<FPAC_SCIMS_Tract>();
            List<FPAC_SCIMS_Crop> scimsCropsToBeSaved = new List<FPAC_SCIMS_Crop>();
            List<FPAC_SCIMS_Election_Hip> scimsElectionsHipsToBeSaved = new List<FPAC_SCIMS_Election_Hip>();
            List<FPAC_SCIMS_CommonLandUnitYear> scimsCluToBeSaved = new List<FPAC_SCIMS_CommonLandUnitYear>();
            
            for(Integer i = 0; i < scimsFarmList.size(); i++)
            {
                Id farmId = lands[i].Id;
                
                if (scimsFarmList[i].FarmYears != null && scimsFarmList[i].FarmYears.size() > 0)
                {
                    FPAC_SCIMS_FarmYear scimsFarm = scimsFarmList[i].FarmYears[0];
                    string scimsFarmNumber = scimsFarmList[i].ScimsNumber;
                    string adminStateCode = scimsFarmList[i].AdminStateCode;
                    string adminCountyCode = scimsFarmList[i].AdminCountyCode;
                    string operator = null;
                    if (scimsFarm != null && scimsFarm.Operator!=null)
                    	operator = scimsFarm.Operator.CommonName;
                     
                    //tracts
                    if(scimsFarm.Tracts != null)
                    {
                        for(FPAC_SCIMS_Tract fpacScimsTract : scimsFarm.Tracts)
                        {
                            fpacScimsTract.FarmId = farmId;
                            fpacScimsTract.ParentExternalId = scimsFarmNumber;
                            
                            fpacScimsTract.FarmNumber = scimsFarmNumber;
                            fpacScimsTract.AdminStateCode = adminStateCode;
                            fpacScimsTract.AdminCountyCode = adminCountyCode;
                            fpacScimsTract.Operator = operator;
                        }
                        scimsTractsToBeSaved.AddAll(scimsFarm.Tracts);  
                    }
                    
                    //crops
                    if(scimsFarm.Crops != null)
                    {
                        for(FPAC_SCIMS_Crop scimsCrop : scimsFarm.Crops)
                        {  
                            scimsCrop.LandId = farmId;
                            scimsCrop.ParentExternalId = scimsFarmNumber;
                        }
                        scimsCropsToBeSaved.AddAll(scimsFarm.Crops);
                    }
                    
                    //elections
                    if(scimsFarm.Elections != null)
                    {
                        for(FPAC_SCIMS_Election_Hip scimsElection : scimsFarm.Elections)
                        {
                            scimsElection.FarmId = farmId;
                            scimsElection.ParentExternalId = scimsFarmNumber;
                        }  
                        scimsElectionsHipsToBeSaved.AddAll(scimsFarm.Elections);
                    }
                    
                    //hips
                    if(scimsFarm.Hips != null)
                    {
                        for(FPAC_SCIMS_Election_Hip scimsHip : scimsFarm.Hips)
                        {
                            scimsHip.FarmId = farmId;
                            scimsHip.ParentExternalId = scimsFarmNumber;
                        }  
                        scimsElectionsHipsToBeSaved.AddAll(scimsFarm.Hips);  
                    }  
                }
            }
            
            List<Land__c> tracts = FPAC_SCIMS_TractConverter.ConvertToLands(scimsTractsToBeSaved);
            FPAC_SCIMS_Tract scimsTract = new FPAC_SCIMS_Tract();
            finalLandList.addAll(scimsTract.Save(tracts));
            
            
            for(Integer i = 0; i < scimsTractsToBeSaved.size(); i++)
            {
                Id tractId = tracts[i].Id;
                
                FPAC_SCIMS_Tract savedScimsTract = scimsTractsToBeSaved[i];
                savedScimsTract.TractId = tractId;
                
                //crops
                if(savedScimsTract.Crops != null)
                {
                    for(FPAC_SCIMS_Crop scimsCrop : savedScimsTract.Crops)
                    {
                        scimsCrop.LandId = tractId;
                        scimsCrop.ParentExternalId = savedScimsTract.CalculatedId;
                    }
                    scimsCropsToBeSaved.AddAll(savedScimsTract.Crops);  
                }
                 
                //fields
                if(savedScimsTract.CommonLandUnitYears != null)
                {
                    for(FPAC_SCIMS_CommonLandUnitYear scimsClu : savedScimsTract.CommonLandUnitYears)
                    {
                        scimsClu.TractId = tractId;
                        scimsClu.ParentExternalId = savedScimsTract.CalculatedId;
                        
                        scimsClu.FarmNumber = savedScimsTract.FarmNumber;
						scimsClu.TractNumber = savedScimsTract.ScimsNumber;
					    scimsClu.AdminStateCode = savedScimsTract.AdminStateCode;
					    scimsClu.AdminCountyCode = savedScimsTract.AdminCountyCode;
					    scimsClu.Operator = savedScimsTract.Operator;
                    }
                    scimsCluToBeSaved.AddAll(savedScimsTract.CommonLandUnitYears);
                }
            }
            
            List<Base_Yield__c> crops = FPAC_SCIMS_CropConverter.ConvertToBaseYields(scimsCropsToBeSaved);
            FPAC_SCIMS_Crop scimsCrop = new FPAC_SCIMS_Crop();
            scimsCrop.Save(crops);
            
            List<Land__c> fields = FPAC_SCIMS_CommonLandUnitYearConverter.ConvertToLands(scimsCluToBeSaved);
            FPAC_SCIMS_CommonLandUnitYear scimsClu = new FPAC_SCIMS_CommonLandUnitYear();
            scimsClu.Save(fields);
            finalLandList.addAll(scimsClu.Save(fields));
            
            List<Election_Hip__c> electionsAndHips = FPAC_SCIMS_Election_HipConverter.ConvertToElectionHips(scimsElectionsHipsToBeSaved);
            System.debug('Election and Hips - ' + electionsAndHips);
            FPAC_SCIMS_Election_Hip scimsElectionHip = new FPAC_SCIMS_Election_Hip();
            scimsElectionHip.Save(electionsAndHips);
        }
        return finalLandList;
    }
}
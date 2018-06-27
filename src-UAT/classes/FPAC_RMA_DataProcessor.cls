public with sharing class FPAC_RMA_DataProcessor {
	
	public void ProcessData(string coreCustomerId, decimal year, string stateFsaCode, string countyFsaCode)
    {
    	FPAC_RMA_DataResponse rmaDataResponse = GetData(coreCustomerId, year, stateFsaCode, countyFsaCode);
    	SaveData(coreCustomerId, year, stateFsaCode, countyFsaCode, rmaDataResponse);
    }
	
	
 	public FPAC_RMA_DataResponse GetData(string coreCustomerId, decimal year, string stateFsaCode, string countyFsaCode)
    {
    	FPAC_RMA_DataRetrieval rmaDataRetrieval = new FPAC_RMA_DataRetrieval();
   
		FPAC_RMA_DataResponse rmaDataResponse = new FPAc_RMA_DataResponse();
		
		rmaDataResponse.PolicyProducers = rmaDataRetrieval.GetProducerPolicies(coreCustomerId, year, stateFsaCode, countyFsaCode);
		
		System.Debug('Policy Producers = ' + rmaDataResponse.PolicyProducers.size());
		
		//get insurance offer and price information
		for(FPAC_RMA_PolicyProducer producer : rmaDataResponse.PolicyProducers)
		{
			if (producer.InsuranceInForces != null && producer.InsuranceInForces.size() > 0)
			{
				for(FPAC_RMA_InsuranceInForce insuranceInForce : producer.InsuranceInForces)
				{
					if (insuranceInForce.Acreages != null && insuranceInForce.Acreages.size() > 0)
					{
						Map<string, List<FPAC_RMA_InsuranceOffer>> acreageInsuranceOffersMap = new Map<string, List<FPAC_RMA_InsuranceOffer>>();
						
						for(FPAC_RMA_Acreage acreage : insuranceInForce.Acreages)
						{
							string key = insuranceInForce.ReinsuranceYear +
											producer.LocationStateCode +
											insuranceInForce.LocationCountyCode +
											insuranceInForce.CommodityYear +
											insuranceInForce.CommodityCode +
											insuranceInForce.InsurancePlanCode +
											acreage.TypeCode +
											acreage.PracticeCode;
										
							List<FPAC_RMA_InsuranceOffer> existingAcreageInsuranceOffers = acreageInsuranceOffersMap.get (key);
							
							if (existingAcreageInsuranceOffers == null)		
							{
								acreage.InsuranceOffers = rmaDataRetrieval.GetInsuranceOffersAndPrices(insuranceInForce.ReinsuranceYear, 
											    															producer.LocationStateCode, 
											    															insuranceInForce.LocationCountyCode, 
										    																insuranceInForce.CommodityYear, 
										    																insuranceInForce.CommodityCode, 
										    																insuranceInForce.InsurancePlanCode,
										    																acreage.TypeCode,
								    																		acreage.PracticeCode);
								    																		
								acreageInsuranceOffersMap.put(key, acreage.InsuranceOffers);    		
																								
								//System.Debug('Acreage Insurance Offers = ' + acreage.InsuranceOffers.size());	
							}  
							else
								acreage.InsuranceOffers = existingAcreageInsuranceOffers;  																		
						}
					}
					
					if (insuranceInForce.InventoryValues != null && insuranceInForce.InventoryValues.size() > 0)
					{
						Map<string, List<FPAC_RMA_InsuranceOffer>> inventoryValueInsuranceOffersMap = new Map<string, List<FPAC_RMA_InsuranceOffer>>();
						
						for(FPAC_RMA_InventoryValue inventoryValue : insuranceInForce.InventoryValues)
						{
							string key = insuranceInForce.ReinsuranceYear +
											producer.LocationStateCode +
											insuranceInForce.LocationCountyCode +
											insuranceInForce.CommodityYear +
											insuranceInForce.CommodityCode +
											insuranceInForce.InsurancePlanCode +
											inventoryValue.TypeCode +
											inventoryValue.PracticeCode;
										
							List<FPAC_RMA_InsuranceOffer> existingInventoryValueInsuranceOffers = inventoryValueInsuranceOffersMap.get(key);
							
							if (existingInventoryValueInsuranceOffers == null)		
							{
								inventoryValue.InsuranceOffers = rmaDataRetrieval.GetInsuranceOffersAndPrices(insuranceInForce.ReinsuranceYear, 
											    															producer.LocationStateCode, 
											    															insuranceInForce.LocationCountyCode, 
										    																insuranceInForce.CommodityYear, 
										    																insuranceInForce.CommodityCode, 
										    																insuranceInForce.InsurancePlanCode,
										    																inventoryValue.TypeCode,
								    																		inventoryValue.PracticeCode);
								    																		
								inventoryValueInsuranceOffersMap.put(key, inventoryValue.InsuranceOffers);     		
																								
								//System.Debug('Inventory Value Insurance Offers = ' + inventoryValue.InsuranceOffers.size());	
							}  
							else
								inventoryValue.InsuranceOffers = existingInventoryValueInsuranceOffers; 	    																		
						} 
					}
				}
			} 
		}
		
    	return rmaDataResponse;  
    }
     

    public List<NAP_RMA_NCT_ACR_Data__c> ConvertToNapRmaNctAcrData (string coreCustomerId, decimal year, string stateFsaCode, string countyFsaCode, FPAC_RMA_DataResponse rmaDataResponse)
    {
    	FPAC_RMA_DataConverter converter = new FPAC_RMA_DataConverter();
    	return converter.ToNapRmaNctAcrData(coreCustomerId, 
											year, 
											stateFsaCode, 
											countyFsaCode,
											rmaDataResponse);
    }
  

    public void SaveData (string coreCustomerId, decimal year, string stateFsaCode, string countyFsaCode, FPAC_RMA_DataResponse rmaDataResponse)
    {
    		 
    	List<NAP_RMA_NCT_ACR_Data__c> rmaDataToDelete = [SELECT id FROM NAP_RMA_NCT_ACR_Data__c 
																WHERE CCID__c = :coreCustomerId AND 
																	RMA_Program_Year__c = :year AND
																	State_Code__c = :stateFsaCode AND
																	County_Code__c = :countyFsaCode];
    	delete rmaDataToDelete;

    	List<NAP_RMA_NCT_ACR_Data__c> rmaDataList = ConvertToNapRmaNctAcrData(coreCustomerId, 
    																			year, 
    																			stateFsaCode, 
    																			countyFsaCode, 
    																			rmaDataResponse);
    	System.debug(rmaDataList.size());
    	insert rmaDataList;
    	System.debug ('-- created rma data');
    }
}
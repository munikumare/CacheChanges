public with sharing class FPAC_RMA_DataConverter {
	
	 private string RMA_RECORD_TYPE = 'RMA Data';
	 private Integer RMA_TYPE_CODE_MAX_LENGTH = 4;
	 private string ZERO = '0';
	 
	 private Id rmaRecordTypeId = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c
            								.getRecordTypeInfosByName()
                  							.get(RMA_RECORD_TYPE)
            								.getRecordTypeId();
	
    public List<NAP_RMA_NCT_ACR_Data__c> ToNapRmaNctAcrData (string coreCustomerId, decimal year, string stateFsaCode, string countyFsaCode, FPAC_RMA_DataResponse rmaDataResponse)
    {
        List<NAP_RMA_NCT_ACR_Data__c> rmaDataList = new List<NAP_RMA_NCT_ACR_Data__c>();
       
        if (rmaDataResponse != null && 
            rmaDataResponse.PolicyProducers != null)  
        {
        	 
        	Id rmaRecordTypeId = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c
            								.getRecordTypeInfosByName()
                  							.get(RMA_RECORD_TYPE)
            								.getRecordTypeId();
            								
        	Map<string, string> rmaFieldValueMap = new Map<string, string>();
        	
        	
            for(FPAC_RMA_PolicyProducer policyProducer : rmaDataResponse.PolicyProducers)
            {
            	rmaFieldValueMap.put('StateCode', stateFsaCode);
            	rmaFieldValueMap.put('CountyCode', countyFsaCode);
            	rmaFieldValueMap.put('CCID', coreCustomerId);
            	rmaFieldValueMap.put('Year', String.ValueOf(year));
            	
            	policyProducer.AddFieldsToMap(rmaFieldValueMap);
            	
            	if (policyProducer.PolicyProducerOtherPersons != null)
            	{
            		for(FPAC_RMA_PolicyProducerOtherPerson person : policyProducer.PolicyProducerOtherPersons)
            		{
            			person.AddFieldsToMap(rmaFieldValueMap);
            			rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
            			System.Debug('Adding person');
            			ClearPolicyProducerOtherPersonData(rmaFieldValueMap);
            		}
            	}
            	
            	
            	
            	if (policyProducer.InsuranceInForces != null)
            	{
            		for(FPAC_RMA_InsuranceInForce insuranceInForce : policyProducer.InsuranceInForces)
            		{
            			//Boolean isExistsProductionLossDetails = insuranceInForce.ProductionLossDetails != null && insuranceInForce.ProductionLossDetails.size() > 0;
		        		//Boolean isExistsAcreages = insuranceInForce.Acreages != null && insuranceInForce.Acreages.size() > 0;
		        		Boolean isExistsLands = insuranceInForce.Lands != null && insuranceInForce.Lands.size() > 0;
        	   
        	   			insuranceInForce.AddFieldsToMap(rmaFieldValueMap);
					   
					    
					    //**********************************************************************
					    if (insuranceInForce.CalculatedCommodityType == 'Other')
					    {
					    	
					    	Map<string, FPAC_RMA_Acreage> acreageMap = new Map<string, FPAC_RMA_Acreage>(); 
					    	Boolean isExistsProductionLossDetails = insuranceInForce.ProductionLossDetails != null && insuranceInForce.ProductionLossDetails.size() > 0;
		        			Boolean isExistsAcreages = insuranceInForce.Acreages != null && insuranceInForce.Acreages.size() > 0;
		        			
						    if (!isExistsProductionLossDetails && !isExistsAcreages && !isExistsLands)
						    {
						     	rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
						     	System.Debug('no production loss details, acreages, lands');
						     	continue;
						    }
		        			
		        			if (isExistsAcreages)
            				{
            					for(FPAC_RMA_Acreage acreage : insuranceInForce.Acreages)
            					{
            						acreage.CommodityCode = insuranceInForce.CommodityCode;
            						acreageMap.put(acreage.AipAcreageKey, acreage);
            						
            						if (acreage.insuranceOffers != null && acreage.insuranceOffers.size() > 0)
            						{
            							for (FPAC_RMA_InsuranceOffer offer : acreage.insuranceOffers)
            							{
            								offer.AddFieldsToMap(rmaFieldValueMap);
            								if (offer.Prices != null && offer.Prices.size() > 0)
            								{
            									for (FPAC_RMA_InsuranceOfferPrice price : offer.Prices)
            									{
            										price.AddFieldsToMap(rmaFieldValueMap);
            										GetAcreageData(rmaFieldValueMap, acreage);
            										rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
            										System.Debug('adding insurance offer for acreage - ' + rmaFieldValueMap.get('PracticeCode'));
            										
            										ClearAcreageData(rmaFieldValueMap);
            										ClearInsuranceOfferData(rmaFieldValueMap);
            										ClearInsuranceOfferPriceData(rmaFieldValueMap);
            									}
            								}
            							}
            						}
            					}
            				}
					    
	            			if (isExistsProductionLossDetails)
	            			{
	            				for(FPAC_RMA_ProductionLossDetail productionLossDetail : insuranceInForce.ProductionLossDetails)
	            				{	
	            					 productionLossDetail.AddFieldsToMap(rmaFieldValueMap);
	            					
								     GetAcreageData(rmaFieldValueMap, acreageMap.get(productionLossDetail.AipAcreageKey));
								     
								     rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
								     System.Debug('adding production loss detail for acreage - ' + rmaFieldValueMap.get('PracticeCode'));
            										
								     ClearAcreageData(rmaFieldValueMap);
								     ClearProductionLossDetailData(rmaFieldValueMap);
	            				}
	            			}
	            			
	            			if (isExistsLands)
	            			{
	            				for(FPAC_RMA_Land land : insuranceInForce.Lands)
	            				{
	            					land.AddFieldsToMap(rmaFieldValueMap);
	            					GetAcreageData(rmaFieldValueMap, acreageMap.get(land.AipAcreageKey));
	            					
									rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
									System.Debug('adding land for acreage - ' + rmaFieldValueMap.get('PracticeCode'));
            						
									
									ClearAcreageData(rmaFieldValueMap);
									ClearLandData(rmaFieldValueMap);
	            				}
	            			}
	            			
	            			if(insuranceInForce.InsurancePlanCode == '04' ||
	            			 	insuranceInForce.InsurancePlanCode == '05' ||
	            			 	insuranceInForce.InsurancePlanCode == '06' ||
	            			 	insuranceInForce.InsurancePlanCode == '35' ||
	            			 	insuranceInForce.InsurancePlanCode == '36')
	            			 	{
	            			 		if (insuranceInForce.Productions != null && insuranceInForce.Productions.size() > 0)
	            			 		{
	            			 			for (FPAC_RMA_Production production : insuranceInForce.Productions)
	            			 			{
	            			 				production.AddFieldsToMap(rmaFieldValueMap);
	            			 				rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
									
											ClearProductionData(rmaFieldValueMap);
	            			 			}
	            			 		}
	            			 	}
	            			 	else
	            			 	{
	            			 		if (insuranceInForce.Yields != null && insuranceInForce.Yields.size() > 0)
	            			 		{
	            			 			for (FPAC_RMA_Yield yield : insuranceInForce.Yields)
	            			 			{
	            			 				yield.InsurancePlanCode = insuranceInForce.InsurancePlanCode; 
	            			 				if (yield.YieldHistories != null && yield.YieldHistories.size() > 0)
			            			 		{
			            			 			for (FPAC_RMA_YieldHistory yieldHistory : yield.YieldHistories)
			            			 			{
			            			 				yieldHistory.AddFieldsToMap(rmaFieldValueMap);
			            			 				rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
			            			 				
			            			 				System.Debug('adding land for yield history - ' + rmaFieldValueMap.get('PracticeCode'));
											
													ClearYieldHistoryData(rmaFieldValueMap);
			            			 			}
			            			 		}
	            			 			}
	            			 		}
	            			 	}
	            			 	
	            			 	
	            			 	
	            			
		        			acreageMap.clear();	
					    }
					    //**********************************************************************
					    
					    //**********************************************************************
					    
					    if (insuranceInForce.CalculatedCommodityType == 'Nursery And Clams')
					    {
					    	Map<string, FPAC_RMA_InventoryValue> inventoryValueMap = new Map<string, FPAC_RMA_InventoryValue>(); 
					    	Boolean isExistsInventoryLossDetails = insuranceInForce.InventoryLossDetails != null && insuranceInForce.InventoryLossDetails.size() > 0;
		        			Boolean isExistsInventoryValues = insuranceInForce.InventoryValues != null && insuranceInForce.InventoryValues.size() > 0;
		        			
		        			
						    if (!isExistsInventoryLossDetails && !isExistsInventoryValues && !isExistsLands)
						    {
						     	rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
						     	continue;
						    }
						    
		        			 
		        			if (isExistsInventoryValues)
            				{
            					for(FPAC_RMA_InventoryValue inventoryValue : insuranceInForce.InventoryValues)
            						inventoryValueMap.put(inventoryValue.AipInventoryValueKey, inventoryValue);
            				} 
					    
	            			if (isExistsInventoryLossDetails)
	            			{ 
	            				for(FPAC_RMA_InventoryLossDetail inventoryLossDetail : insuranceInForce.InventoryLossDetails)
	            				{	
	            					 inventoryLossDetail.CommodityCode = insuranceInForce.CommodityCode;
	            					 inventoryLossDetail.AddFieldsToMap(rmaFieldValueMap);
	            					 
								     GetInventoryValueData(rmaFieldValueMap, inventoryValueMap.get(inventoryLossDetail.AipInventoryValueKey));
								     
								     rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
								     
								     ClearInventoryValueData(rmaFieldValueMap);
								     ClearInventoryLossDetailData(rmaFieldValueMap);
	            				}
	            			}
	            		
		        			inventoryValueMap.clear();	
					    }
					     
					    //**********************************************************************
					   
					   //**********************************************************************
					    
					    if (insuranceInForce.CalculatedCommodityType == 'WFRP')
					    {
					    	Map<string, FPAC_RMA_WFRPFarmReport> farmReportMap = new Map<string, FPAC_RMA_WFRPFarmReport>(); 
	            				
	            			if (insuranceInForce.WFRPFarmReports != null)
	            			{ 
	            				
	            				for(FPAC_RMA_WFRPFarmReport wfrpFarmReport : insuranceInForce.WFRPFarmReports)
	            				{	
	            					 farmReportMap.put(wfrpFarmReport.AipWFRPFarmReportsKey, wfrpFarmReport);
	            					 
	            					 wfrpFarmReport.AddFieldsToMap(rmaFieldValueMap);
	            					 
	            					 if(wfrpFarmReport.WFRPFarmReportDetails != null && 
	            					 	wfrpFarmReport.WFRPFarmReportDetails.size() > 0)
	            					 {
	            					 	for(FPAC_RMA_WFRPFarmReportsDetail wfrpFarmReportDetail : wfrpFarmReport.WFRPFarmReportDetails)
	            						{
	            							wfrpFarmReportDetail.AddFieldsToMap(rmaFieldValueMap);
	            							rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
	            							ClearWFRPFarmReportDetailData(rmaFieldValueMap);
	            						}
	            					 }
	            					
								     ClearWFRPFarmReportData(rmaFieldValueMap);
	            				}
	            			}
	            			
	            			if (insuranceInForce.WFRPIndemnities != null && insuranceInForce.WFRPIndemnities.size() > 0)
	            			{
	            				for(FPAC_RMA_WFRPIndemnity wfrpIndemnity : insuranceInForce.WFRPIndemnities)
	            				{	
	            					 wfrpIndemnity.AddFieldsToMap(rmaFieldValueMap);
	            					
								     GetWFRPFarmReportData(rmaFieldValueMap, farmReportMap.get(wfrpIndemnity.AipWFRPFarmReportsKey));
								     
								     rmaDataList.Add(GetRmaObject(rmaFieldValueMap));
								     
								     ClearWFRPFarmReportData(rmaFieldValueMap);
								     ClearWFRPIndemnityData(rmaFieldValueMap);
	            				}
	            			}
	            			
	            			farmReportMap.clear();	
					    }
					     
					    //**********************************************************************
					   
					 
            			
            			ClearInsuranceInForceData(rmaFieldValueMap);	
            			
            		}
            	}
            	
            	ClearPolicyProducerData(rmaFieldValueMap);
            }
        }
        
        return rmaDataList;  
    } 
    
    private void ClearPolicyProducerOtherPersonData(Map<string, string> rmaFieldValueMap)
    {
    	 rmaFieldValueMap.put('IneligibleSBIFlag', null);
		 rmaFieldValueMap.put('IneligibleSBISharePercent', null);
		 rmaFieldValueMap.put('OtherPersonName', null);
		 rmaFieldValueMap.put('AipCode', null);
    }
    
    private void ClearPolicyProducerData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('LocationStateCode', null);
    }
    
    private void ClearInsuranceInForceData(Map<string, string> rmaFieldValueMap)
    {
	    rmaFieldValueMap.put('LocationCountyCode', null);
	    rmaFieldValueMap.put('CoverageTypeCode', null);
	    rmaFieldValueMap.put('CoverageLevelPercent', null);
	    rmaFieldValueMap.put('IneligibleSBISharePercent', null);
	    rmaFieldValueMap.put('CommodityCode', null);
	    rmaFieldValueMap.put('InsurancePlanCode', null);
    }
    
    private void ClearProductionLossDetailData(Map<string, string> rmaFieldValueMap)
    {
    	 rmaFieldValueMap.put('DeterminedAcreage', null);
	     rmaFieldValueMap.put('StageCode', null);
	     rmaFieldValueMap.put('ProductionToCountQuantity', null);
	     rmaFieldValueMap.put('IndemnityAmount', null);
	     rmaFieldValueMap.put('ThirdDamageDate', null);
	     rmaFieldValueMap.put('ThirdDamageCauseCode', null);
	     rmaFieldValueMap.put('StagePercentFactor', null);
	     rmaFieldValueMap.put('SecondDamageCauseCode', null);
	     rmaFieldValueMap.put('SecondDamageDate', null);
	     rmaFieldValueMap.put('LossMultipleCroppingCode', null);
	     rmaFieldValueMap.put('GleanedAcreageCode', null);
	     rmaFieldValueMap.put('FirstDamageDate', null);
	     rmaFieldValueMap.put('FirstDamageCauseCode', null);
	     rmaFieldValueMap.put('DeterminedTreeCount', null);
	     rmaFieldValueMap.put('DeterminedTons', null);
	     rmaFieldValueMap.put('DeterminedPounds', null);
	     rmaFieldValueMap.put('DeterminedColonies', null);					     
    }
    
    
    private void ClearAcreageData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('PracticeCode', null);
		rmaFieldValueMap.put('TypeCode', null);
		rmaFieldValueMap.put('IntendedUseCode', null);
		rmaFieldValueMap.put('OrganicPracticeCode', null);
		rmaFieldValueMap.put('PriceElectionPercent', null);
    	rmaFieldValueMap.put('BasicUnitNumber', null);
		rmaFieldValueMap.put('OptionalUnitNumber', null);
		rmaFieldValueMap.put('SubCountyCode', null);
		rmaFieldValueMap.put('NativeSodSubsidyAmount', null);
		rmaFieldValueMap.put('ReportedAcreage', null);
		rmaFieldValueMap.put('InsuredSharePercent', null);
		rmaFieldValueMap.put('ReportedTons', null);
		rmaFieldValueMap.put('ReportedColonies', null);
		rmaFieldValueMap.put('ApprovedYield', null);
		rmaFieldValueMap.put('UnitStructureCode', null);
		rmaFieldValueMap.put('SkipRowCode', null);
		rmaFieldValueMap.put('ReportedTreeCount', null);
		rmaFieldValueMap.put('ReportedPounds', null);
		rmaFieldValueMap.put('RangeClassCode', null);
		rmaFieldValueMap.put('PlantedDate', null);
		rmaFieldValueMap.put('NonPremiumAcreageCode', null);
		rmaFieldValueMap.put('GuaranteeAdjustmentTypeCode', null);
		rmaFieldValueMap.put('GuaranteeAdjustmentFactor', null);
		rmaFieldValueMap.put('AipCode', null);	
		rmaFieldValueMap.put('CoverageRange', null);
		rmaFieldValueMap.put('CalculatedAcres', null);
    }
    
    private void ClearInsuranceOfferData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('UOM', null);
    }
    
    private void ClearInsuranceOfferPriceData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('Price', null);
    }
    
    
    
    private void ClearInventoryValueData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('PracticeCode', null);
		rmaFieldValueMap.put('TypeCode', null);
		rmaFieldValueMap.put('InsuredSharePercent', null);
		rmaFieldValueMap.put('BasicUnitNumber', null);
		rmaFieldValueMap.put('OptionalUnitNumber', null);
		rmaFieldValueMap.put('UnitStructureCode', null);
		rmaFieldValueMap.put('UnitDivisionCode', null);
		rmaFieldValueMap.put('NonPremiumAcreageCode', null);
		rmaFieldValueMap.put('InsuranceOptionCodeList', null);
    }
    
    private void ClearInventoryLossDetailData(Map<string, string> rmaFieldValueMap)
    {
    	 rmaFieldValueMap.put('FieldMarketValueA', null);
		 rmaFieldValueMap.put('UnitValueBeforeLoss', null);
		 rmaFieldValueMap.put('FieldMarketValueB', null);
		 rmaFieldValueMap.put('UnitValueAfterLoss', null);
		 rmaFieldValueMap.put('FirstDamageCauseCode', null);
		 rmaFieldValueMap.put('FirstDamageDate', null);
		 rmaFieldValueMap.put('SecondDamageCauseCode', null);
		 rmaFieldValueMap.put('SecondDamageDate', null);
		 rmaFieldValueMap.put('ThirdDamageCauseCode', null);
		 rmaFieldValueMap.put('ThirdDamageDate', null);
		 rmaFieldValueMap.put('IndemnityAmount', null);	
		 
		 rmaFieldValueMap.put('CalculatedFieldMarketValueA', null);
		 rmaFieldValueMap.put('CalculatedFieldMarketValueB', null);		     
    }
    
    private void ClearYieldHistoryData(Map<string, string> rmaFieldValueMap)
    {  
    	 rmaFieldValueMap.put('SYProduction', null);
		 rmaFieldValueMap.put('SYAcre', null);
		 rmaFieldValueMap.put('SkipRowCode', null);   
    }
    
    private void ClearProductionData(Map<string, string> rmaFieldValueMap)
    {  
    	 rmaFieldValueMap.put('SYProduction', null);
		 rmaFieldValueMap.put('SYAcre', null); 
    }
    
    private void ClearLandData(Map<string, string> rmaFieldValueMap)
    {
    	 rmaFieldValueMap.put('FsaFarmNumber', null);
		 rmaFieldValueMap.put('FsaTractNumber', null);
		 rmaFieldValueMap.put('FieldNumber', null);
    }
    
    private void GetAcreageData(Map<string, string> rmaFieldValueMap, FPAC_RMA_Acreage acreage)
    {
    	acreage.AddFieldsToMap(rmaFieldValueMap);
    }
    
    private void GetInventoryValueData(Map<string, string> rmaFieldValueMap, FPAC_RMA_InventoryValue inventoryValue)
    {
    	inventoryValue.AddFieldsToMap(rmaFieldValueMap);
    }
    
    private void GetWFRPFarmReportData(Map<string, string> rmaFieldValueMap, FPAC_RMA_WFRPFarmReport wfrpFarmReport)
    {
    	wfrpFarmReport.AddFieldsToMap(rmaFieldValueMap);
    }
    
    private void ClearWFRPIndemnityData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('StageCode', null);
   		rmaFieldValueMap.put('IndemnityAmount', null);
   		rmaFieldValueMap.put('FirstDamageCauseCode', null);
   		rmaFieldValueMap.put('FirstDamageDate', null);
   		rmaFieldValueMap.put('SecondDamageCauseCode', null);
   		rmaFieldValueMap.put('SecondDamageDate', null);
   		rmaFieldValueMap.put('ThirdDamageCauseCode', null);
   		rmaFieldValueMap.put('ThirdDamageDate', null);
    }
    
    private void ClearWFRPFarmReportDetailData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('InsuredSharePercent', null);
    }
    
    private void ClearWFRPFarmReportData(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('TypeCode', null);
	    rmaFieldValueMap.put('PracticeCode', null);
    }
    
    private NAP_RMA_NCT_ACR_Data__c GetRmaObject (Map<string, string> source)
    {
    	NAP_RMA_NCT_ACR_Data__c rmaObject = new NAP_RMA_NCT_ACR_Data__c();
    	rmaObject.RecordTypeId = rmaRecordTypeId;
    	
    	//State_Code__c
		//** rmaObject.RMA_Yield_Acreage__c = 
		//** rmaObject.RMA_Unit_Value_Before_Loss__c
		//** rmaObject.RMA_Unit_Value_After_Loss__c
		//** rmaObject.RMA_Practice_Name__c = 
		//** rmaObject.RMA_Planting_Period_Code__c
		//** rmaObject.RMA_Insurance_Plan_Name__c
		//** rmaObject.RMA_NAME__c	
		//** rmaObject.RMA_Grid_ID__c = source.get('');
		//** rmaObject.RMA_Field_Market_Value_B__c = source.get('');
		//** rmaObject.RMA_Field_Market_Value_A__c = source.get('');
		//** rmaObject.RMA_Crush_District_Number__c = source.get('');
		//** rmaObject.RMA_Crop__c = source.get('');
		//** rmaObject.RMA_Tax_ID__c
		//** rmaObject.RMA_Unit_Division_Code__c
		//** rmaObject.RMA_Type_Name__c
		//** rmaObject.RMA_Total_Insured_Acreage_PRF_only__c
		
		if (!String.isBlank(source.get('Year'))) 
			rmaObject.RMA_Program_Year__c = Decimal.ValueOf(source.get('Year'));
		
		rmaObject.CCID__c = source.get('CCID');
		rmaObject.State_Code__c = source.get('StateCode');
		rmaObject.County_Code__c = source.get('CountyCode');
		
		rmaObject.RMA_Commodity_Code__c	= source.get('CommodityCode');

		rmaObject.RMA_Type_Code__c = getTypeCode(source.get('TypeCode'));
		rmaObject.RMA_Practice_Code__c = source.get('PracticeCode');
		rmaObject.RMA_Practice_Name__c = source.get('PracticeCode'); //>>>
		rmaObject.RMA_Insurance_Plan_Code__c = source.get('InsurancePlanCode');
		
		if (!String.isBlank(source.get('InsuredSharePercent')))
			rmaObject.RMA_Insured_Share_Percent__c = Decimal.valueOf(source.get('InsuredSharePercent'));
		
		if (!String.isBlank(source.get('BasicUnitNumber')))	
			rmaObject.RMA_Basic_Unit_Number__c = Decimal.ValueOf(source.get('BasicUnitNumber'));
		
		if (!String.isBlank(source.get('OptionalUnitNumber')))	
			rmaObject.RMA_Optional_Unit_Number__c = Decimal.ValueOf(source.get('OptionalUnitNumber'));
		
		rmaObject.RMA_Unit_Structure_Code__c = source.get('UnitStructureCode');
		rmaObject.RMA_Unit_Division_Code__c = source.get('UnitDivisionCode');
		rmaObject.RMA_Coverage_Type_Code__c	= source.get('CoverageTypeCode');
		
		if (!String.isBlank(source.get('CoverageLevelPercent')))	
			rmaObject.RMA_Coverage_Level_Percent__c	= Decimal.ValueOf(source.get('CoverageLevelPercent'));	
		
		if (!String.isBlank(source.get('PriceElectionPercent')))
			rmaObject.RMA_Price_Election_Percent__c = Decimal.ValueOf(source.get('PriceElectionPercent'));
		
		rmaObject.RMA_Coverage_Range__c = source.get('CoverageRange');
		
		if (!String.isBlank(source.get('CalculatedAcres')))	
			rmaObject.RMA_Determined_Acreage__c = Decimal.ValueOf(source.get('CalculatedAcres'));
		
		rmaObject.RMA_Non_Premium_Acreage_Code__c = source.get('NonPremiumAcreageCode');
		
		if (!String.isBlank(source.get('Price')))
			rmaObject.RMA_Price__c = Decimal.ValueOf(source.get('Price'));
		
		rmaObject.RMA_Unit_of_Measure_from_ADM__c = source.get('UOM');
		
		rmaObject.RMA_Approved_Yield__c	 = source.get('ApprovedYield');	 
		rmaObject.RMA_Guarantee_Adjustment_Type_Code__c = source.get('GuaranteeAdjustmentTypeCode');
		rmaObject.RMA_Guarantee_Adjustment_Factor__c = source.get('GuaranteeAdjustmentFactor');
		rmaObject.RMA_Sub_County_Code__c = source.get('SubCountyCode');
		rmaObject.RMA_Insurance_Option_Code_List__c = source.get('InsuranceOptionCodeList');
		
		if (!String.isBlank(source.get('PlantedDate')))
			rmaObject.RMA_Planted_Date__c = Date.ValueOf(source.get('PlantedDate')); 
			
		rmaObject.RMA_Range_Class_Code__c = source.get('RangeClassCode');
		rmaObject.RMA_Reported_Tree_Count__c = source.get('ReportedTreeCount');
		rmaObject.RMA_Determined_Tree_Count__c = source.get('DeterminedTreeCount');
		rmaObject.RMA_Location_State_Code__c = source.get('LocationStateCode');
		rmaObject.RMA_Location_County_Code__c = source.get('LocationCountyCode');
		rmaObject.RMA_Farm_Number__c = source.get('FsaFarmNumber');
		rmaObject.RMA_FSA_Tract_Number__c	 = source.get('FsaTractNumber');
		rmaObject.RMA_FSA_Field_Number__c	 = source.get('FieldNumber');	
		rmaObject.RMA_Stage_Code__c = source.get('StageCode');
		
		if (!String.isBlank(source.get('StagePercentFactor')))
			rmaObject.RMA_Stage_Percent_Factor__c = Decimal.ValueOf(source.get('StagePercentFactor'));
		
		rmaObject.RMA_Production_To_Count_Quantity__c = source.get('ProductionToCountQuantity');	
		
		if (!String.isBlank(source.get('IndemnityAmount')))
			rmaObject.RMA_Indemnity_Amount__c = Decimal.ValueOf(source.get('IndemnityAmount'));
		
		rmaObject.RMA_Gleaned_Acreage_Code__c = source.get('GleanedAcreageCode');
		rmaObject.RMA_Loss_Multiple_Cropping_Code__c = source.get('LossMultipleCroppingCode');
		
		if (!String.isBlank(source.get('CalculatedFieldMarketValueA')))
			rmaObject.RMA_Field_Market_Value_A__c = Decimal.ValueOf(source.get('CalculatedFieldMarketValueA'));
			
		if (!String.isBlank(source.get('CalculatedFieldMarketValueB')))
			rmaObject.RMA_Field_Market_Value_B__c = Decimal.ValueOf(source.get('CalculatedFieldMarketValueB'));
				
		rmaObject.RMA_First_Damage_Cause_Code__c = source.get('FirstDamageCauseCode');
		
		if (!String.isBlank(source.get('FirstDamageDate')))
			rmaObject.RMA_First_Damage_Date__c = Date.ValueOf(source.get('FirstDamageDate'));
		
		rmaObject.RMA_Second_Damage_Cause_Code__c = source.get('SecondDamageCauseCode');
		
		if (!String.isBlank(source.get('SecondDamageDate')))
			rmaObject.RMA_Second_Damage_Date__c = Date.ValueOf(source.get('SecondDamageDate'));
		
		rmaObject.RMA_Third_Damage_Cause_Code__c = source.get('ThirdDamageCauseCode');
		
		if (!String.isBlank(source.get('ThirdDamageDate')))
			rmaObject.RMA_Third_Damage_Date__c = Date.ValueOf(source.get('ThirdDamageDate'));
			
		rmaObject.RMA_SY_PRODUCTION__c = source.get('SYProduction');
		
		
		rmaObject.RMA_AIP_Code__c = source.get('AipCode');
		rmaObject.RMA_Ineligible_SBI_Flag__c = source.get('IneligibleSBIFlag');
		
		if (!String.isBlank(source.get('IneligibleSBISharePercent')))
			rmaObject.RMA_Ineligible_SBI_Share_Percent__c = Decimal.ValueOf(source.get('IneligibleSBISharePercent'));
		
		rmaObject.RMA_NAME__c = source.get('OtherPersonName');
		
		
		
		
		
		
		
		
		
		
		rmaObject.RMA_Skip_Row_Code__c = source.get('SkipRowCode');
		
		if (!String.isBlank(source.get('ReportedTons')))
			rmaObject.RMA_Reported_Tons__c = Decimal.ValueOf(source.get('ReportedTons'));
		
		if (!String.isBlank(source.get('ReportedPounds')))
			rmaObject.RMA_Reported_Pounds__c = Decimal.ValueOf(source.get('ReportedPounds'));
		
		if (!String.isBlank(source.get('ReportedColonies')))
			rmaObject.RMA_Reported_Colonies__c = Decimal.ValueOf(source.get('ReportedColonies'));
		
		if (!String.isBlank(source.get('ReportedAcreage')))
			rmaObject.RMA_Reported_Acreage__c = Decimal.ValueOf(source.get('ReportedAcreage'));
			
		rmaObject.RMA_Organic_Practice_Code__c = source.get('OrganicPracticeCode');
		
		if (!String.isBlank(source.get('NativeSodSubsidyAmount')))
			rmaObject.RMA_Native_Sod_Subsidy_Amount__c = Decimal.ValueOf(source.get('NativeSodSubsidyAmount'));
		
		rmaObject.RMA_Intended_Use_Code__c = source.get('IntendedUseCode');
		
		rmaObject.RMA_FSA_Sub_Field_Identifier__c = source.get('FsaSubFieldIdentifier');
		
		if (!String.isBlank(source.get('DeterminedTons')))
			rmaObject.RMA_Determined_Tons__c = Decimal.ValueOf(source.get('DeterminedTons'));
			
		if (!String.isBlank(source.get('DeterminedTons')))	
			rmaObject.RMA_Determined_Pounds__c = Decimal.ValueOf(source.get('DeterminedPounds'));
		
		if (!String.isBlank(source.get('DeterminedColonies')))	
			rmaObject.RMA_Determined_Colonies__c = Decimal.ValueOf(source.get('DeterminedColonies'));
	
		return rmaObject;
    }
    
    private string getTypeCode(string typeCode)
    {
    	if (String.IsBlank(typeCode))
    		return typeCode;
    		
    	return typeCode.leftPad(RMA_TYPE_CODE_MAX_LENGTH, ZERO);
    }
    
}
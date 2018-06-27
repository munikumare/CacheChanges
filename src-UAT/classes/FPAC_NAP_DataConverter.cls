public with sharing class FPAC_NAP_DataConverter { 
    
    private static string NAP_RECORD_TYPE = 'NAP Data';
    
    public List<NAP_RMA_NCT_ACR_Data__c> ToNapRmaNctAcrData (FPAC_NAP_DataResponse napDataResponse)
    {
        List<NAP_RMA_NCT_ACR_Data__c> napDataList = new List<NAP_RMA_NCT_ACR_Data__c>();
        
        Id napRecordTypeId = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c
            								.getRecordTypeInfosByName()
                  							.get(NAP_RECORD_TYPE)
            								.getRecordTypeId();
        
        //boolean isExistsNoticeOfLosses = napDataResponse.NoticeOfLossByProducerResponse != null && napDataResponse.NoticeOfLossByProducerResponse.NoticesOfLosses != null && napDataResponse.NoticeOfLossByProducerResponse.NoticesOfLosses.size() > 0;
        boolean isExistsApplications = napDataResponse.ApplicationByProducerResponse != null && napDataResponse.ApplicationByProducerResponse.Applications != null && napDataResponse.ApplicationByProducerResponse.Applications.size() > 0;
        
        //System.debug('-- isExistsNoticeOfLosses - ' + isExistsNoticeOfLosses);
        //System.debug('-- isExistsApplications - ' + isExistsApplications);
         
        if (napDataResponse != null &&  
            napDataResponse.CoverageByProducerResponse != null && 
            napDataResponse.CoverageByProducerResponse.Coverages != null)
        {
            for(FPAC_NAP_Coverage coverage : napDataResponse.CoverageByProducerResponse.Coverages)
            {
            	decimal programYear;
            	
            	if (!String.IsBlank(coverage.ProgramYear))
            		 programYear = Decimal.ValueOf(coverage.ProgramYear);
            		
            	String coreCustomerId = coverage.CoreCustomerId;
            	String stateCode = coverage.StateFSACode;
            	String countyCode = coverage.CountyFSACode;
                 
                if (coverage.Crops != null)
                { 
                    for(FPAC_NAP_Crop crop : coverage.crops)
                    {
                    	String cropCode = crop.CropCode;
                    	String cropTypeCode = crop.CropTypeCode;
                    	String intendedUseCode = crop.IntendedUseCode;
                    	String plantingPeriodCode = crop.PlantingPeriodCode;
                    	String payCropCode = crop.PayCropCode;
                    	String payCropTypeCode = crop.PayCropTypeCode;
                        
                        Decimal coveragePercentage = String.isNotBlank(crop.CoveragePercentage) ? Decimal.valueOf(crop.CoveragePercentage) : null;
                         
                        if (!isExistsApplications)
                        {
                        	NAP_RMA_NCT_ACR_Data__c napData = new NAP_RMA_NCT_ACR_Data__c();
                        	napData.RecordTypeId = napRecordTypeId;
                        	napData.CCID__c = coreCustomerId;
                        	napData.State_Code__c = stateCode;
                        	napData.County_Code__c = countyCode;
                        	napData.NAP_Program_Year__c = programYear;
                        	napData.NAP_Crop_Code__c = cropCode;
                        	napData.NAP_Crop_Type_Code__c = cropTypeCode;
	                        napData.NAP_Intended_Use_Code__c = intendedUseCode;
	                        napData.NAP_Planting_Period_Code__c = plantingPeriodCode;
	                        napData.NAP_Pay_Crop_Code__c = payCropCode;
	                        napData.NAP_Pay_Crop_Type_Code__c = payCropTypeCode;
                            napData.NAP_Coverage_Percentage__c = coveragePercentage;
                            napDataList.Add(napData);
                            //System.debug ('Added coverage record');
                            continue;
                        }
                        
                        string coverageCropKey = coverage.ProgramYear + coverage.StateFSACode + 
                        							coverage.CountyFSACode + crop.PayCropCode + 
                        							crop.PayCropTypeCode + crop.PlantingPeriodCode;
                          
                        //System.debug('-- CoverageCropKey - ' + coverageCropKey) ;
                          
                       
                        
                        if (isExistsApplications)
                        {
                            for(FPAC_NAP_Application application : napDataResponse.ApplicationByProducerResponse.Applications)
                            {
                                string applicationKey = application.ProgramYear + application.StateFSACode + 
                                						application.CountyFSACode + application.PayCropCode + 
                                						 application.PayCropTypeCode + application.PlantingPeriodCode;
                                						 
                                string unitNumber = application.UnitNumber;
                                							
                                for(FPAC_NAP_Crop applicationCrop : application.Crops)
                                { 
                                			
                                	//System.debug('-- applicationKey - ' + applicationKey);	
                                		
                                    if (applicationKey == coverageCropKey)
                                    {
                                    	
                                        String organicTypeCode = applicationCrop.OrganicTypeCode;
                                        String nativeSodIndicator = applicationCrop.NativeSodIndicator;
                                        String irrigationPracticeCode = applicationCrop.IrrigationPracticeCode;
                                       
                                        decimal reportedPlantedAcreage;
                                        decimal determinedPlantedAcreage;
                                        decimal reportedPreventedAcreage;
                                        decimal determinedPreventedAcreage;
                                        decimal plantedIneligibleAcreage;
                                        decimal preventedIneligibleAcreage;
                                        decimal share;
                                        decimal approvedYield;
                                        decimal yieldAdjustment;
                                        
                                        if (!String.IsBlank(applicationCrop.ReportedPlantedAcreage))
	                                        reportedPlantedAcreage = Decimal.ValueOf(applicationCrop.ReportedPlantedAcreage);
	                                    
	                                    if (!String.IsBlank(applicationCrop.DeterminedPlantedAcreage))
                                            determinedPlantedAcreage = Decimal.ValueOf(applicationCrop.DeterminedPlantedAcreage);
                                        
                                        if (!String.IsBlank(applicationCrop.ReportedPreventedAcreage))
                                        	reportedPreventedAcreage = Decimal.ValueOf(applicationCrop.ReportedPreventedAcreage);
                                         
                                        if (!String.IsBlank(applicationCrop.DeterminedPreventedAcreage))
                                            determinedPreventedAcreage = Decimal.ValueOf(applicationCrop.DeterminedPreventedAcreage); 
                                        
                                        if (!String.IsBlank(applicationCrop.PlantedIneligibleAcreage))
                                            plantedIneligibleAcreage = Decimal.ValueOf(applicationCrop.PlantedIneligibleAcreage);
                                        
                                        if (!String.IsBlank(applicationCrop.PreventedIneligibleAcreage))
                                            preventedIneligibleAcreage = Decimal.ValueOf(applicationCrop.PreventedIneligibleAcreage);
                                        
                                        if (!String.IsBlank(applicationCrop.Share))
                                            share = Decimal.ValueOf(applicationCrop.Share);    
	                                    
                                        if (!String.IsBlank(applicationCrop.ApprovedYield))
                                            approvedYield = Decimal.valueOf(applicationCrop.ApprovedYield);

                                        if (!String.IsBlank(applicationCrop.YieldAdjustment))
                                            yieldAdjustment = Decimal.valueOf(applicationCrop.YieldAdjustment);
	                                    
	                                    if (applicationCrop.YieldBasedLosses == null &&
	                                        applicationCrop.ValueNonGraduatedLosses == null &&
	                                        applicationCrop.ValueMultiGraduatedLosses == null)
	                                    {
	                                    	NAP_RMA_NCT_ACR_Data__c napData = new NAP_RMA_NCT_ACR_Data__c();
											napData.RecordTypeId = napRecordTypeId;
											napData.CCID__c = coreCustomerId;
											napData.State_Code__c = stateCode;
                        					napData.County_Code__c = countyCode;
											napData.NAP_Program_Year__c = programYear;
											napData.NAP_Crop_Code__c = cropCode;
											napData.NAP_Crop_Type_Code__c = cropTypeCode;
											napData.NAP_Intended_Use_Code__c = intendedUseCode;
											napData.NAP_Planting_Period_Code__c = plantingPeriodCode;
											napData.NAP_Pay_Crop_Code__c = payCropCode;
											napData.NAP_Pay_Crop_Type_Code__c = payCropTypeCode;
											napData.NAP_Organic_Type_Code__c = organicTypeCode;
											napData.NAP_Native_Sod_Indicator__c = nativeSodIndicator;
											napData.NAP_Reported_Planted_Acreage__c = reportedPlantedAcreage;
											napData.NAP_Determined_Prevented_Acreage__c = determinedPlantedAcreage;
											napData.NAP_Reported_Prevented_Acreage__c = reportedPreventedAcreage;
											napData.NAP_Determined_Prevented_Acreage__c = determinedPreventedAcreage; 
											napData.NAP_Planted_Ineligible_Acreage__c = plantedIneligibleAcreage;
											napData.NAP_Prevented_Ineligible_Acreage__c = preventedIneligibleAcreage;
											napData.NAP_Share__c = share;
											napData.NAP_Irrigation_Practice_Code__c = irrigationPracticeCode;
                                        	napData.NAP_Unit_Number__c = unitNumber;
                                            napData.NAP_Approved_Yield__c = approvedYield;
                                            napData.NAP_Yield_Adjustment__c = yieldAdjustment;
                                            napData.NAP_Coverage_Percentage__c = coveragePercentage;
                                            napDataList.Add(napData);
		                                    
		                                    //System.debug ('Added coverage application crop for - ' + applicationKey);
	                                    } 
	                                         
	                                    else
	                                    { 
	                                        if(applicationCrop.YieldBasedLosses != null)
	                                        {
	                                        	decimal reportedSalvageAmount;
                                    			decimal determinedSalvageAmount;
	                                        	boolean productionDataAddedToList = false;
	                                        	
	                                        	for (FPAC_NAP_YieldBasedLoss yieldBasedLoss : applicationCrop.YieldBasedLosses)
	                                            {
	                                         
                                    				if (!String.IsBlank(yieldBasedLoss.ReportedSalvageAmount))
	                                                    reportedSalvageAmount = Decimal.ValueOf(yieldBasedLoss.ReportedSalvageAmount);
	                                                
	                                                if (!String.IsBlank(yieldBasedLoss.DeterminedSalvageAmount))
	                                                    determinedSalvageAmount = Decimal.ValueOf(yieldBasedLoss.DeterminedSalvageAmount);
                                    				
	                                                if (yieldBasedLoss.Productions != null)
	                                                {
	                                                    for (FPAC_NAP_Production production : yieldBasedLoss.Productions)
	                                                    {
	                                                    	//System.debug('FinalIntendedUseCode = ' + production.FinalIntendedUseCode);
	                                                    	//System.debug('IntendedUseCode = ' + intendedUseCode);
	                                                    	
	                                                    	if (production.FinalIntendedUseCode == intendedUseCode)
	                                                    	{
		                                                    	NAP_RMA_NCT_ACR_Data__c napData = new NAP_RMA_NCT_ACR_Data__c();
																napData.RecordTypeId = napRecordTypeId;
																napData.CCID__c = coreCustomerId;
																napData.State_Code__c = stateCode;
	                        									napData.County_Code__c = countyCode;
																napData.NAP_Program_Year__c = programYear;
																napData.NAP_Crop_Code__c = cropCode;
																napData.NAP_Crop_Type_Code__c = cropTypeCode;
																napData.NAP_Intended_Use_Code__c = intendedUseCode;
																napData.NAP_Planting_Period_Code__c = plantingPeriodCode;
																napData.NAP_Pay_Crop_Code__c = payCropCode;
																napData.NAP_Pay_Crop_Type_Code__c = payCropTypeCode;
																napData.NAP_Organic_Type_Code__c = organicTypeCode;
																napData.NAP_Native_Sod_Indicator__c = nativeSodIndicator;
																napData.NAP_Reported_Planted_Acreage__c = reportedPlantedAcreage;
																napData.NAP_Determined_Prevented_Acreage__c = determinedPlantedAcreage;
																napData.NAP_Reported_Prevented_Acreage__c = reportedPreventedAcreage;
																napData.NAP_Determined_Prevented_Acreage__c = determinedPreventedAcreage; 
																napData.NAP_Planted_Ineligible_Acreage__c = plantedIneligibleAcreage;
																napData.NAP_Prevented_Ineligible_Acreage__c = preventedIneligibleAcreage;
																napData.NAP_Share__c = share;
																napData.NAP_Irrigation_Practice_Code__c = irrigationPracticeCode;
	                                        					napData.NAP_Unit_Number__c = unitNumber;
																
																napData.NAP_Reported_Salvage_Amount__c = reportedSalvageAmount;
																napData.NAP_Determined_Salvage_Amount__c = determinedSalvageAmount;
		                                                        napData.NAP_Stage_Code__c = production.StageCode;
		                                                        napData.NAP_Unit_Of_Measure_Code__c = production.UnitOfMeasureCode;
		                                                        
		                                                        if (!String.IsBlank(production.Quantity))
                                                                {
		                                                            napData.NAP_Quantity__c = Decimal.ValueOf(production.Quantity);
                                                                    napData.NAP_Production_To_Count__c = Decimal.ValueOf(production.Quantity);
                                                                }
		                                                        
		                                                        if (!String.IsBlank(production.UncountedQuantity))
		                                                            napData.NAP_Uncounted_Quantity__c = Decimal.ValueOf(production.UncountedQuantity);
		                                                        
		                                                        if (!String.IsBlank(production.CorrectionQuantity))
                                                                {
		                                                            napData.NAP_Correction_Quantity__c = Decimal.ValueOf(production.CorrectionQuantity);
                                                                    napData.NAP_Assigned_Or_Adjusted_Production__c = Decimal.ValueOf(production.CorrectionQuantity);
                                                                }
		                                                        
		                                                        napData.NAP_Correction_Type_Code__c = production.CorrectionTypeCode; 
                                                                napData.NAP_Crushing_District__c = production.CrushingDistrict;
                                                                napData.NAP_Approved_Yield__c = approvedYield;
                                                                napData.NAP_Yield_Adjustment__c = yieldAdjustment;
                                                                napData.NAP_Coverage_Percentage__c = coveragePercentage;
                                                                napDataList.Add(napData);
		                                                        
		                                                        productionDataAddedToList = true;
		                                                        
		                                                        //System.debug ('Added production for - ' + applicationKey);
	                                                    	}
	                                                    }
	                                                }
	                                                
	                                            }
	                                            
	                                            if (!productionDataAddedToList)
                                                {
                                                	NAP_RMA_NCT_ACR_Data__c napData = new NAP_RMA_NCT_ACR_Data__c();
													napData.RecordTypeId = napRecordTypeId;
													napData.CCID__c = coreCustomerId;
													napData.State_Code__c = stateCode;
                    								napData.County_Code__c = countyCode;
													napData.NAP_Program_Year__c = programYear;
													napData.NAP_Crop_Code__c = cropCode;
													napData.NAP_Crop_Type_Code__c = cropTypeCode;
													napData.NAP_Intended_Use_Code__c = intendedUseCode;
													napData.NAP_Planting_Period_Code__c = plantingPeriodCode;
													napData.NAP_Pay_Crop_Code__c = payCropCode;
													napData.NAP_Pay_Crop_Type_Code__c = payCropTypeCode;
													napData.NAP_Organic_Type_Code__c = organicTypeCode;
													napData.NAP_Native_Sod_Indicator__c = nativeSodIndicator;
													napData.NAP_Reported_Planted_Acreage__c = reportedPlantedAcreage;
													napData.NAP_Determined_Prevented_Acreage__c = determinedPlantedAcreage;
													napData.NAP_Reported_Prevented_Acreage__c = reportedPreventedAcreage;
													napData.NAP_Determined_Prevented_Acreage__c = determinedPreventedAcreage; 
													napData.NAP_Planted_Ineligible_Acreage__c = plantedIneligibleAcreage;
													napData.NAP_Prevented_Ineligible_Acreage__c = preventedIneligibleAcreage;
													napData.NAP_Share__c = share;
													napData.NAP_Irrigation_Practice_Code__c = irrigationPracticeCode;
                                    				napData.NAP_Unit_Number__c = unitNumber;
													
													napData.NAP_Reported_Salvage_Amount__c = reportedSalvageAmount;
													napData.NAP_Determined_Salvage_Amount__c = determinedSalvageAmount;
                                                    napData.NAP_Approved_Yield__c = approvedYield;
                                                    napData.NAP_Yield_Adjustment__c = yieldAdjustment;
                                                    napData.NAP_Coverage_Percentage__c = coveragePercentage;
                                                    napDataList.Add(napData);
                                                    
                                                    //System.debug ('Added yield based loss for - ' + applicationKey);
                                                }
	                                        }
	                                        
	                                        if(applicationCrop.ValueNonGraduatedLosses != null)
	                                        {
	                                            for (FPAC_NAP_ValueNonGraduatedLoss valueNonGraduatedLoss : applicationCrop.ValueNonGraduatedLosses)
	                                            {
	                                            	NAP_RMA_NCT_ACR_Data__c napData = new NAP_RMA_NCT_ACR_Data__c();
													napData.RecordTypeId = napRecordTypeId;
													napData.CCID__c = coreCustomerId;
													napData.State_Code__c = stateCode;
                        							napData.County_Code__c = countyCode;
													napData.NAP_Program_Year__c = programYear;
													napData.NAP_Crop_Code__c = cropCode;
													napData.NAP_Crop_Type_Code__c = cropTypeCode;
													napData.NAP_Intended_Use_Code__c = intendedUseCode;
													napData.NAP_Planting_Period_Code__c = plantingPeriodCode;
													napData.NAP_Pay_Crop_Code__c = payCropCode;
													napData.NAP_Pay_Crop_Type_Code__c = payCropTypeCode;
													napData.NAP_Organic_Type_Code__c = organicTypeCode;
													napData.NAP_Native_Sod_Indicator__c = nativeSodIndicator;
													napData.NAP_Reported_Planted_Acreage__c = reportedPlantedAcreage;
													napData.NAP_Determined_Prevented_Acreage__c = determinedPlantedAcreage;
													napData.NAP_Reported_Prevented_Acreage__c = reportedPreventedAcreage;
													napData.NAP_Determined_Prevented_Acreage__c = determinedPreventedAcreage; 
													napData.NAP_Planted_Ineligible_Acreage__c = plantedIneligibleAcreage;
													napData.NAP_Prevented_Ineligible_Acreage__c = preventedIneligibleAcreage;
													napData.NAP_Share__c = share;
													napData.NAP_Irrigation_Practice_Code__c = irrigationPracticeCode;
                                        			napData.NAP_Unit_Number__c = unitNumber;
													
	                                                if (!String.IsBlank(valueNonGraduatedLoss.MarketAmount))
	                                                    napData.NAP_Market_Amount__c = Decimal.ValueOf(valueNonGraduatedLoss.MarketAmount);
	                                                
	                                                if (!String.IsBlank(valueNonGraduatedLoss.MortalityFactor))
	                                                    napData.NAP_Mortality_Factor__c = valueNonGraduatedLoss.MortalityFactor;
	                                                
                                                    napData.NAP_Approved_Yield__c = approvedYield;
                                                    napData.NAP_Yield_Adjustment__c = yieldAdjustment;
                                                    napData.NAP_Coverage_Percentage__c = coveragePercentage;
	                                                napDataList.Add(napData);
	                                                
	                                                //System.debug ('Added value non graduated loss for - ' + applicationKey);
	                                            }
	                                        }
	                                          
	                                         
	                                        if(applicationCrop.ValueMultiGraduatedLosses != null)
	                                        {
	                                            for (FPAC_NAP_ValueMultiGraduatedLoss valueMultiGraduatedLoss : applicationCrop.ValueMultiGraduatedLosses)
	                                            {
	                                            	NAP_RMA_NCT_ACR_Data__c napData = new NAP_RMA_NCT_ACR_Data__c();
													napData.RecordTypeId = napRecordTypeId;
													napData.CCID__c = coreCustomerId;
													napData.State_Code__c = stateCode;
                        							napData.County_Code__c = countyCode;
													napData.NAP_Program_Year__c = programYear;
													napData.NAP_Crop_Code__c = cropCode;
													napData.NAP_Crop_Type_Code__c = cropTypeCode;
													napData.NAP_Intended_Use_Code__c = intendedUseCode;
													napData.NAP_Planting_Period_Code__c = plantingPeriodCode;
													napData.NAP_Pay_Crop_Code__c = payCropCode;
													napData.NAP_Pay_Crop_Type_Code__c = payCropTypeCode;
													napData.NAP_Organic_Type_Code__c = organicTypeCode;
													napData.NAP_Native_Sod_Indicator__c = nativeSodIndicator;
													napData.NAP_Reported_Planted_Acreage__c = reportedPlantedAcreage;
													napData.NAP_Determined_Prevented_Acreage__c = determinedPlantedAcreage;
													napData.NAP_Reported_Prevented_Acreage__c = reportedPreventedAcreage;
													napData.NAP_Determined_Prevented_Acreage__c = determinedPreventedAcreage; 
													napData.NAP_Planted_Ineligible_Acreage__c = plantedIneligibleAcreage;
													napData.NAP_Prevented_Ineligible_Acreage__c = preventedIneligibleAcreage;
													napData.NAP_Share__c = share;
													napData.NAP_Irrigation_Practice_Code__c = irrigationPracticeCode;
                                        			napData.NAP_Unit_Number__c = unitNumber;
                                                    napData.NAP_Approved_Yield__c = approvedYield;
                                                    napData.NAP_Yield_Adjustment__c = yieldAdjustment;
                                                    napData.NAP_Coverage_Percentage__c = coveragePercentage;
	                                                napData.NAP_Begin_Inventory_Count__c = valueMultiGraduatedLoss.BeginInventoryCount;
	                                                napDataList.Add(napData);
	                                                
	                                                //System.debug ('Added value multi graduated loss for - ' + applicationKey);
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
        }
        
        //System.debug('-- NAP data - ' + napDataList);
        return napDataList;
    
    }
    
   
}
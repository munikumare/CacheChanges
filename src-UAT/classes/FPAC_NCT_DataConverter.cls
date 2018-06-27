public with sharing class FPAC_NCT_DataConverter {
	private static string NCT_RECORD_TYPE = 'NCT Data';
	
    public List<NAP_RMA_NCT_ACR_Data__c> ToNapRmaNctAcrData (FPAC_NCT_DataResponse nctDataResponse)
    {
        List<NAP_RMA_NCT_ACR_Data__c> nctDataList = new List<NAP_RMA_NCT_ACR_Data__c>();
       
        if (nctDataResponse != null && 
            nctDataResponse.WhipInformationResponse != null && 
            nctDataResponse.WhipInformationResponse.WhipMarketForecasts != null) 
        {
        	
        	Id nctRecordTypeId = Schema.SObjectType.NAP_RMA_NCT_ACR_Data__c
            								.getRecordTypeInfosByName()
                  							.get(NCT_RECORD_TYPE)
            								.getRecordTypeId();
        	
        	
            for(FPAC_NCT_WhipMarketForecast whipMarketForecast : nctDataResponse.WhipInformationResponse.WhipMarketForecasts)
            {
                NAP_RMA_NCT_ACR_Data__c nctData = new NAP_RMA_NCT_ACR_Data__c();
                nctData.RecordTypeId = nctRecordTypeId;
                
                if (!String.IsBlank(whipMarketForecast.CalculatedYield))
                	nctData.NCT_Calculated_Yield_X__c = Decimal.ValueOf(whipMarketForecast.CalculatedYield);
                
				nctData.NCT_Crop_Intended_Use__c = whipMarketForecast.CropIntendedUse;
				nctData.NCT_Crop_Type__c = whipMarketForecast.CropType;
				nctData.NCT_Crushing_District__c = whipMarketForecast.CrushingDistrict;
				
				if (!String.IsBlank(whipMarketForecast.MarketPrice))
					nctData.NCT_Market_Price__c = Decimal.ValueOf(whipMarketForecast.MarketPrice);
				
				if (!String.IsBlank(whipMarketForecast.OrganicCertifiedFactor))
					nctData.NCT_Organic_Certified_Factor__c = Decimal.ValueOf(whipMarketForecast.OrganicCertifiedFactor);
				
				if (!String.IsBlank(whipMarketForecast.OrganicMarketPrice))
					nctData.NCT_Organic_Market_Price__c = Decimal.ValueOf(whipMarketForecast.OrganicMarketPrice);
				
				if (!String.IsBlank(whipMarketForecast.OrganicTransitionalFactor))
					nctData.NCT_Organic_Transitional_Factor__c = Decimal.ValueOf(whipMarketForecast.OrganicTransitionalFactor);
				
				nctData.NCT_Pay_Crop__c = whipMarketForecast.PayCrop;
				nctData.NCT_Pay_Type__c = whipMarketForecast.PayType;
				nctData.NCT_Planting_Period__c = whipMarketForecast.PlantingPeriod;
				nctData.NCT_Practice_Code__c = whipMarketForecast.PracticeCode;
				nctData.NCT_Prevented_Factor__c = whipMarketForecast.PreventedFactor;
				
				if (!String.IsBlank(whipMarketForecast.ProgramYear))
					nctData.NCT_Program_Year__c = Decimal.ValueOf(whipMarketForecast.ProgramYear);
				
				nctData.State_Code__c = whipMarketForecast.StateCode;
				nctData.County_Code__c = whipMarketForecast.CountyCode;
				nctData.NCT_Crop_Code__c = whipMarketForecast.CropCode;
				
				nctData.NCT_Tree_Bush_Vine_Damager_Factor_I__c = whipMarketForecast.TreeBushVineDamagerFactorI;
				nctData.NCT_Tree_Bush_Vine_Damager_Factor_II__c = whipMarketForecast.TreeBushVineDamagerFactorII;
				nctData.NCT_Tree_Bush_Vine_Damager_Factor_III__c = whipMarketForecast.TreeBushVineDamagerFactorIII;
				
				if (!String.IsBlank(whipMarketForecast.TreeBushVinePriceI))
					nctData.NCT_Tree_Bush_Vine_Price_I__c = Decimal.ValueOf(whipMarketForecast.TreeBushVinePriceI);
				
				if (!String.IsBlank(whipMarketForecast.TreeBushVinePriceII))
					nctData.NCT_Tree_Bush_Vine_Price_II__c = Decimal.ValueOf(whipMarketForecast.TreeBushVinePriceII);
				
				if (!String.IsBlank(whipMarketForecast.TreeBushVinePriceIII))
					nctData.NCT_Tree_Bush_Vine_Price_III__c = Decimal.ValueOf(whipMarketForecast.TreeBushVinePriceIII);
				
				
				nctData.NCT_Unharvested_Factor__c = whipMarketForecast.UnharvestedFactor;
				nctData.NCT_Unit_Of_Measure_Code__c = whipMarketForecast.UnitOfMeasureCode;
				nctData.NCT_Whip_Pay_Crop__c = whipMarketForecast.WhipPayCrop;
				nctData.NCT_Whip_Pay_Type__c = whipMarketForecast.WhipPayType;
                nctDataList.Add(nctData);
            }
        }
        return nctDataList;  
    } 
    
}
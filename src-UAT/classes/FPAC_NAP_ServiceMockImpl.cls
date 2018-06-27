public with sharing class FPAC_NAP_ServiceMockImpl  implements HttpCalloutMock{
     public HTTPResponse respond(HTTPRequest req) {
     	
     	string json = '';
    	string endPoint = req.getEndpoint();
    	
		if (endPoint.indexOf('retrieveCoverageByProducer') != -1)
                json = RetrieveCoverageByProducer();
        else {
            	if (endPoint.indexOf('retrieveApplicationByProducer') != -1)
            	 json = RetrieveApplicationByProducer();
         }          			  
                                    
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
    
    private string RetrieveCoverageByProducer()
    {
    	return '{'+
				  '"coverages": ['+
				    '{' +
				      '"id": "83442",' +
				      '"coverageStatus": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"crops": ['+
				        '{' +
				          '"payCropCode": "0054",' +
				          '"payCropTypeCode": "001",' +
				          '"plantingPeriodCode": "01",' +
				          '"cropCode": "0054",' +
				          '"cropTypeCode": "COM",' +
				          '"intendedUseCode": "FH",' +
				          '"coveragePercentage": "50",' +
				          '"organicProductionPriceCoverage": "true",' +
				          '"directMarketPriceCoverage": "true",' +
				          '"historicalMarketingPercentageCoverage": "true",' +
				          '"coverageValueAmount": null'+
				        '},' +
				        '{' +
				          '"payCropCode": "0011",' +
				          '"payCropTypeCode": "002",' +
				          '"plantingPeriodCode": "01",' +
				          '"cropCode": "0011",' +
				          '"cropTypeCode": "HAD",' +
				          '"intendedUseCode": "GZ",' +
				          '"coveragePercentage": null,'+
				          '"organicProductionPriceCoverage": null,'+
				          '"directMarketPriceCoverage": null,'+
				          '"historicalMarketingPercentageCoverage": null,'+
				          '"coverageValueAmount": null'+
				        '},'+
				        '{' +
				          '"payCropCode": "3000",' +
				          '"payCropTypeCode": "001",' +
				          '"plantingPeriodCode": "01",' +
				          '"cropCode": "3000",' +
				          '"cropTypeCode": "JAK",' +
				          '"intendedUseCode": "FH",' +
				          '"coveragePercentage": "55",' +
				          '"organicProductionPriceCoverage": "false",' +
				          '"directMarketPriceCoverage": null,'+
				          '"historicalMarketingPercentageCoverage": null,'+
				          '"coverageValueAmount": "10000"'+
				        '},' +
				        '{' +
				          '"payCropCode": "0102",' +
				          '"payCropTypeCode": "001",' +
				          '"plantingPeriodCode": "01",' +
				          '"cropCode": "0102",' +
				          '"cropTypeCode": "ALK",' +
				          '"intendedUseCode": "FG",' +
				          '"coveragePercentage": null,'+
				          '"organicProductionPriceCoverage": null,'+
				          '"directMarketPriceCoverage": null,'+
				          '"historicalMarketingPercentageCoverage": null,'+
				          '"coverageValueAmount": null'+
				        '},' +
				       '{' +
				          '"payCropCode": "0102",' +
				          '"payCropTypeCode": "003",' +
				          '"plantingPeriodCode": "01",' +
				          '"cropCode": "0102",' +
				          '"cropTypeCode": "ALK",' +
				          '"intendedUseCode": "SO",' +
				          '"coveragePercentage": "55",' +
				          '"organicProductionPriceCoverage": "false",' +
				          '"directMarketPriceCoverage": null,'+
				          '"historicalMarketingPercentageCoverage": null,'+
				          '"coverageValueAmount": "20000"'+
				        '},' +
				        '{' +
				          '"payCropCode": "0403",' +
				          '"payCropTypeCode": "001",' +
				          '"plantingPeriodCode": "01",' +
				          '"cropCode": "0403",' +
				          '"cropTypeCode": "COM",' +
				          '"intendedUseCode": "FH",' +
				          '"coveragePercentage": "60",' +
				          '"organicProductionPriceCoverage": null,'+
				          '"directMarketPriceCoverage": null,'+
				          '"historicalMarketingPercentageCoverage": null,'+
				          '"coverageValueAmount": "30009"'+
				        '}' +
				      '],' +
				      '"collections": [' +
				        '{' +
				          '"transactionAmount": "250.00",' +
				          '"transactionDate": "2018-04-18",' +
				          '"confirmationNumber": "787068"'+
				        '},' +
				       '{' +
				          '"transactionAmount": "250.00",' +
				          '"transactionDate": "2018-04-18",' +
				          '"confirmationNumber": "787137"'+
				        '},' +
				        '{' +
				          '"transactionAmount": "250.00",' +
				          '"transactionDate": "2018-04-23",' +
				          '"confirmationNumber": "789098"'+
				        '}' +
				      ']' +
				    '}' +
				  ']' +
				'}';
                                    			  
    }
    
    
    private string RetrieveApplicationByProducer()
    {
    	return '{' +
				  '"applications": [' +
				    '{' +
				      '"id": "115797",' +
				      '"status": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"unitNumber": "000012",' +
				      '"payCropCode": "3000",' +
				      '"payCropTypeCode": "001",' +
				      '"plantingPeriodCode": "01",' +
				      '"sequence": "1",' +
				      '"additionalAcreage": "false",' +
				      '"cocDeterminationDate": "2018-04-23",' +
				      '"noticeOfLossIds": [' +
				        '"8915"' +
				       '],' +
				      '"crops": [' +
				        '{' +
				          '"lossTypeCode": "V",' +
				          '"cropCode": "3000",' +
				          '"cropTypeCode": "JAK",' +
				          '"intendedUseCode": "FH",' +
				          '"irrigationPracticeCode": null,' +
				          '"finalIntendedUseCode": null,' +
				          '"organicTypeCode": "C",' +
				          '"nativeSodIndicator": "false",' +
				          '"unitOfMeasureCode": "TON",' +
				          '"share": "25.00",' +
				          '"reportedSalvageAmount": "100",' +
				          '"determinedSalvageAmount": null,' +
				          '"plantedIneligibleAcreage": null,' +
				          '"preventedIneligibleAcreage": null,' +
				          '"reportedPlantedAcreage": null,' +
				          '"determinedPreventedAcreage": null,' +
				          '"reportedPreventedAcreage": null,' +
				          '"determinedPlantedAcreage": null,' +
				          '"approvedYield": null,' +
				          '"yieldAdjustment": null,' +
				          '"harvestedIndicator": "true",' +
				          '"coveragePercentage": "55",' +
				          '"organicProductionPriceCoverage": "false",' +
				          '"directMarketPriceCoverage": null,' +
				          '"historicalMarketingPercentageCoverage": null,' +
				          '"coverageValueAmount": "10000",' +
				          '"directAverageMarketingPercentage": null,' +
				          '"indirectAverageMarketingPercentage": null,' +
				          '"yieldBasedLosses": null,' +
				          '"valueNonGraduatedLoss": null,' +
				          '"valueSingleGraduatedLoss": null,' +
				          '"valueMultiGraduatedLosses": [' +
				            '{' +
				              '"cropMaturity": "009",' +
				              '"beginInventoryCount": "2.00",' +
				              '"endInventoryCount": "1.00",' +
				              '"ineligibleLossCount": "0.01",' +
				              '"mortalityFactor": "0.9000"' +
				            '},' +
				            '{' +
				              '"cropMaturity": "012",' +
				              '"beginInventoryCount": "2.00",' +
				              '"endInventoryCount": "1.00",' +
				              '"ineligibleLossCount": null,' +
				              '"mortalityFactor": "0.8000"' +
				            '}' +
				           '],' +
				          '"grazingLosses": null,' +
				          '"marketings": null' +
				        '}' +
				      ']' +
				    '},' +
				    '{' +
				      '"id": "115621",' +
				      '"status": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"unitNumber": "000012",' +
				      '"payCropCode": "0054",' +
				      '"payCropTypeCode": "001",' +
				      '"plantingPeriodCode": "01",' +
				      '"sequence": "1",' +
				      '"additionalAcreage": "false",' +
				      '"cocDeterminationDate": "2018-04-18",' +
				      '"noticeOfLossIds": [' +
				        '"8915"' +
				       '],' +
				      '"crops": [' +
				        '{' +
				          '"lossTypeCode": "Y",' +
				          '"cropCode": "0054",' +
				          '"cropTypeCode": "COM",' +
				          '"intendedUseCode": "FH",' +
				          '"irrigationPracticeCode": "I",' +
				          '"finalIntendedUseCode": "FH",' +
				          '"organicTypeCode": "C",' +
				          '"nativeSodIndicator": "false",' +
				          '"unitOfMeasureCode": "BU",' +
				          '"share": "25.00",' +
				          '"reportedSalvageAmount": "200",' +
				          '"determinedSalvageAmount": "150",' +
				          '"plantedIneligibleAcreage": null,' +
				          '"preventedIneligibleAcreage": null,' +
				          '"reportedPlantedAcreage": null,' +
				          '"determinedPreventedAcreage": null,' +
				          '"reportedPreventedAcreage": null,' +
				          '"determinedPlantedAcreage": "4.1400",' +
				          '"approvedYield": "200",' +
				          '"yieldAdjustment": "100",' +
				          '"harvestedIndicator": null,' +
				          '"coveragePercentage": "50",' +
				          '"organicProductionPriceCoverage": "true",' +
				          '"directMarketPriceCoverage": "true",' +
				          '"historicalMarketingPercentageCoverage": "true",' +
				          '"coverageValueAmount": null,' +
				          '"directAverageMarketingPercentage": "70.00",' +
				          '"indirectAverageMarketingPercentage": "30.00",' +
				          '"yieldBasedLosses": [' +
				            '{' +
				              '"crushingDistrict": null,' +
				              '"reportedSalvageAmount": "200",' +
				              '"determinedSalvageAmount": "150",' +
				              '"yieldAdjustment": "100",' +
				              '"productions": [' +
				                '{' +
				                  '"crushingDistrict": null,' +
				                  '"finalIntendedUseCode": "PR",' +
				                  '"stageCode": "H",' +
				                  '"acreage": "3.0000",' +
				                  '"quantity": "10",' +
				                  '"uncountedQuantity": null,' +
				                  '"correctionTypeCode": null,' +
				                  '"correctionQuantity": null,' +
				                  '"unitOfMeasureCode": "BU"' +
				                '}' +
				              ']' +
				            '},' +
				            '{' +
				              '"crushingDistrict": null,' +
				              '"reportedSalvageAmount": "200",' +
				              '"determinedSalvageAmount": "150",' +
				              '"yieldAdjustment": "100",' +
				              '"productions": [' +
				                '{' +
				                  '"crushingDistrict": null,' +
				                  '"finalIntendedUseCode": "FH",' +
				                  '"stageCode": "H",' +
				                  '"acreage": "3.0000",' +
				                  '"quantity": "100",' +
				                  '"uncountedQuantity": "4",' +
				                  '"correctionTypeCode": "Y",' +
				                  '"correctionQuantity": "120",' +
				                  '"unitOfMeasureCode": "BU"' +
				                '}' +
				              ']' +
				            '},' +
				            '{' +
				              '"crushingDistrict": null,' +
				              '"reportedSalvageAmount": "200",' +
				              '"determinedSalvageAmount": "150",' +
				              '"yieldAdjustment": "100",' +
				              '"productions": [' +
				                '{' +
				                  '"crushingDistrict": null,' +
				                  '"finalIntendedUseCode": "FH",' +
				                  '"stageCode": "U",' +
				                  '"acreage": "1.1400",' +
				                  '"quantity": "5",' +
				                  '"uncountedQuantity": null,' +
				                  '"correctionTypeCode": null,' +
				                  '"correctionQuantity": null,' +
				                  '"unitOfMeasureCode": "BU"' +
				                '}' +
				              ']' +
				            '}' +
				           '],' +
				          '"valueNonGraduatedLosses": [' +
				          		'{' +
				                  '"MarketAmount": null,' +
				                  '"MortalityFactor": null' +
				                '}' +
				          	'],' +
				          '"valueSingleGraduatedLoss": null,' +
				          '"valueMultiGraduatedLosses": null,' +
				          '"grazingLosses": null,' +
				          '"marketings": [' +
				            '{' +
				              '"finalIntendedUseCode": "FH",' +
				              '"highestPercentage": "50.00"' +
				            '},' +
				            '{' +
				              '"finalIntendedUseCode": "PR",' +
				              '"highestPercentage": "50.00"' +
				            '}' +
				          ']' +
				        '}' +
				      ']' +
				    '},' +
				    '{' +
				      '"id": "115798",' +
				      '"status": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"unitNumber": "000012",' +
				      '"payCropCode": "0403",' +
				      '"payCropTypeCode": "001",' +
				      '"plantingPeriodCode": "01",' +
				      '"sequence": "1",' +
				      '"additionalAcreage": "false",' +
				      '"cocDeterminationDate": "2018-04-23",' +
				      '"noticeOfLossIds": [' +
				        '"8915"' +
				       '],' +
				      '"crops": [' +
				        '{' +
				          '"lossTypeCode": "N",' +
				          '"cropCode": "0403",' +
				          '"cropTypeCode": "COM",' +
				          '"intendedUseCode": "FH",' +
				          '"irrigationPracticeCode": null,' +
				          '"finalIntendedUseCode": null,' +
				          '"organicTypeCode": "C",' +
				          '"nativeSodIndicator": "false",' +
				          '"unitOfMeasureCode": null,' +
				          '"share": "25.00",' +
				          '"reportedSalvageAmount": "4500",' +
				          '"determinedSalvageAmount": null,' +
				          '"plantedIneligibleAcreage": null,' +
				          '"preventedIneligibleAcreage": null,' +
				          '"reportedPlantedAcreage": null,' +
				          '"determinedPreventedAcreage": null,' +
				          '"reportedPreventedAcreage": null,' +
				          '"determinedPlantedAcreage": null,' +
				          '"approvedYield": null,' +
				          '"yieldAdjustment": null,' +
				          '"harvestedIndicator": "false",' +
				          '"coveragePercentage": "60",' +
				          '"organicProductionPriceCoverage": null,' +
				          '"directMarketPriceCoverage": null,' +
				          '"historicalMarketingPercentageCoverage": null,' +
				          '"coverageValueAmount": "30009",' +
				          '"directAverageMarketingPercentage": null,' +
				          '"indirectAverageMarketingPercentage": null,' +
				          '"yieldBasedLosses": null,' +
				          '"valueNonGraduatedLoss": {' +
				            '"marketAmount": "345678",' +
				            '"disasterAmount": "5000",' +
				            '"lossAmount": "100",' +
				            '"mortalityFactor": null' +
				          '},' +
				          '"valueSingleGraduatedLoss": null,' +
				          '"valueMultiGraduatedLosses": null,' +
				          '"grazingLosses": null,' +
				          '"marketings": null' +
				        '}' +
				      ']' +
				    '},' +
				    '{' +
				      '"id": "115622",' +
				      '"status": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"unitNumber": "000012",' +
				      '"payCropCode": "0011",' +
				      '"payCropTypeCode": "002",' +
				      '"plantingPeriodCode": "01",' +
				      '"sequence": "1",' +
				      '"additionalAcreage": "false",' +
				      '"cocDeterminationDate": "2018-05-16",' +
				      '"noticeOfLossIds": [' +
				        '"8915"' +
				       '],' +
				      '"crops": [' +
				        '{' +
				          '"lossTypeCode": "G",' +
				          '"cropCode": "0011",' +
				          '"cropTypeCode": "HAD",' +
				          '"intendedUseCode": "GZ",' +
				          '"irrigationPracticeCode": "N",' +
				          '"finalIntendedUseCode": null,' +
				          '"organicTypeCode": "C",' +
				          '"nativeSodIndicator": "false",' +
				          '"unitOfMeasureCode": "AUD",' +
				          '"share": "25.00",' +
				          '"reportedSalvageAmount": null,' +
				          '"determinedSalvageAmount": null,' +
				          '"plantedIneligibleAcreage": null,' +
				          '"preventedIneligibleAcreage": null,' +
				          '"reportedPlantedAcreage": null,' +
				          '"determinedPreventedAcreage": null,' +
				          '"reportedPreventedAcreage": null,' +
				          '"determinedPlantedAcreage": "60.9100",' +
				          '"approvedYield": null,' +
				          '"yieldAdjustment": null,' +
				          '"harvestedIndicator": null,' +
				          '"coveragePercentage": null,' +
				          '"organicProductionPriceCoverage": null,' +
				          '"directMarketPriceCoverage": null,' +
				          '"historicalMarketingPercentageCoverage": null,' +
				          '"coverageValueAmount": null,' +
				          '"directAverageMarketingPercentage": null,' +
				          '"indirectAverageMarketingPercentage": null,' +
				          '"yieldBasedLosses": null,' +
				          '"valueNonGraduatedLoss": null,' +
				          '"valueSingleGraduatedLoss": null,' +
				          '"valueMultiGraduatedLosses": null,' +
				          '"grazingLosses": [' +
				            '{' +
				              '"carryingCapacity": [' +
				                '{' +
				                  '"code": "01",' +
				                  '"acreage": "10.0000",' +
				                  '"period": "30"' +
				                '}' +
				               '],' +
				              '"reportedPlantedAcreage": "60.9100",' +
				              '"reportedPreventedAcreage": null,' +
				              '"inventories": [' +
				                '{' +
				                  '"cropPlantedAcreage": "50.0000",' +
				                  '"cropPreventedAcreage": null,' +
				                  '"adjustmentFactor": "0.90",' +
				                  '"lossFactor": "0.5000",' +
				                  '"plantedAssignedQuantity": "40",' +
				                  '"preventedAssignedQuantity": null,' +
				                  '"ownerships": [' +
				                    '{' +
				                      '"typeCode": "P",' +
				                      '"acreage": "50.0000",' +
				                      '"lessor": "test"' +
				                    '}' +
				                  ']' +
				                '},' +
				                '{' +
				                  '"cropPlantedAcreage": "10.0000",' +
				                  '"cropPreventedAcreage": null,' +
				                  '"adjustmentFactor": null,' +
				                  '"lossFactor": null,' +
				                  '"plantedAssignedQuantity": null,' +
				                  '"preventedAssignedQuantity": null,' +
				                  '"ownerships": [' +
				                    '{' +
				                      '"typeCode": "F",' +
				                      '"acreage": "10.0000",' +
				                      '"lessor": "test"' +
				                    '}' +
				                  ']' +
				                '}' +
				              ']' +
				            '}' +
				           '],' +
				          '"marketings": null' +
				        '}' +
				      ']' +
				    '},' +
				    '{' +
				      '"id": "115799",' +
				      '"status": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"unitNumber": "000012",' +
				      '"payCropCode": "0102",' +
				      '"payCropTypeCode": "003",' +
				      '"plantingPeriodCode": "01",' +
				      '"sequence": "1",' +
				      '"additionalAcreage": "false",' +
				      '"cocDeterminationDate": "2018-04-23",' +
				      '"noticeOfLossIds": [' +
				        '"8915"' +
				       '],' +
				      '"crops": [' +
				        '{' +
				          '"lossTypeCode": "S",' +
				          '"cropCode": "0102",' +
				          '"cropTypeCode": "ALK",' +
				          '"intendedUseCode": "SO",' +
				          '"irrigationPracticeCode": null,' +
				          '"finalIntendedUseCode": null,' +
				          '"organicTypeCode": "C",' +
				          '"nativeSodIndicator": "false",' +
				          '"unitOfMeasureCode": "TON",' +
				          '"share": "25.00",' +
				          '"reportedSalvageAmount": null,' +
				          '"determinedSalvageAmount": null,' +
				          '"plantedIneligibleAcreage": null,' +
				          '"preventedIneligibleAcreage": null,' +
				          '"reportedPlantedAcreage": null,' +
				          '"determinedPreventedAcreage": null,' +
				          '"reportedPreventedAcreage": null,' +
				          '"determinedPlantedAcreage": null,' +
				          '"approvedYield": null,' +
				          '"yieldAdjustment": null,' +
				          '"harvestedIndicator": null,' +
				          '"coveragePercentage": "55",' +
				          '"organicProductionPriceCoverage": "false",' +
				          '"directMarketPriceCoverage": null,' +
				          '"historicalMarketingPercentageCoverage": null,' +
				          '"coverageValueAmount": "20000",' +
				          '"directAverageMarketingPercentage": null,' +
				          '"indirectAverageMarketingPercentage": null,' +
				          '"yieldBasedLosses": null,' +
				          '"valueNonGraduatedLoss": null,' +
				          '"valueSingleGraduatedLoss": {' +
				            '"cropMaturity": null,' +
				            '"beginInventoryCount": "100.00",' +
				            '"endInventoryCount": "99.00",' +
				            '"ineligibleLossCount": null,' +
				            '"mortalityFactor": null' +
				          '},' +
				          '"valueMultiGraduatedLosses": null,' +
				          '"grazingLosses": null,' +
				          '"marketings": null' +
				        '}' +
				      ']' +
				    '},' +
				    '{' +
				      '"id": "115800",' +
				      '"status": "A",' +
				      '"coreCustomerId": "563753",' +
				      '"programYear": "2017",' +
				      '"stateFSACode": "19",' +
				      '"countyFSACode": "015",' +
				      '"unitNumber": "000012",' +
				      '"payCropCode": "0102",' +
				      '"payCropTypeCode": "001",' +
				      '"plantingPeriodCode": "01",' +
				      '"sequence": "1",' +
				      '"additionalAcreage": "false",' +
				      '"cocDeterminationDate": "2018-04-23",' +
				      '"noticeOfLossIds": [' +
				        '"8915"' +
				       '],' +
				      '"crops": [' +
				        '{' +
				          '"lossTypeCode": "F",' +
				          '"cropCode": "0102",' +
				          '"cropTypeCode": "ALK",' +
				          '"intendedUseCode": "FG",' +
				          '"irrigationPracticeCode": "I",' +
				          '"finalIntendedUseCode": "FG",' +
				          '"organicTypeCode": "C",' +
				          '"nativeSodIndicator": "false",' +
				          '"unitOfMeasureCode": "TON",' +
				          '"share": "25.00",' +
				          '"reportedSalvageAmount": null,' +
				          '"determinedSalvageAmount": null,' +
				          '"plantedIneligibleAcreage": null,' +
				          '"preventedIneligibleAcreage": null,' +
				          '"reportedPlantedAcreage": null,' +
				          '"determinedPreventedAcreage": null,' +
				          '"reportedPreventedAcreage": null,' +
				          '"determinedPlantedAcreage": "2.0000",' +
				          '"approvedYield": "18.50",' +
				          '"yieldAdjustment": "100",' +
				          '"harvestedIndicator": null,' +
				          '"coveragePercentage": null,' +
				          '"organicProductionPriceCoverage": null,' +
				          '"directMarketPriceCoverage": null,' +
				          '"historicalMarketingPercentageCoverage": null,' +
				          '"coverageValueAmount": null,' +
				          '"directAverageMarketingPercentage": null,' +
				          '"indirectAverageMarketingPercentage": null,' +
				          '"yieldBasedLosses": [' +
				            '{' +
				              '"crushingDistrict": null,' +
				              '"reportedSalvageAmount": null,' +
				              '"determinedSalvageAmount": null,' +
				              '"yieldAdjustment": "100",' +
				              '"productions": [' +
				                '{' +
				                  '"crushingDistrict": null,' +
				                  '"finalIntendedUseCode": "FG",' +
				                  '"stageCode": "H",' +
				                  '"acreage": "1.0000",' +
				                  '"quantity": "100.00",' +
				                  '"uncountedQuantity": null,' +
				                  '"correctionTypeCode": null,' +
				                  '"correctionQuantity": null,' +
				                  '"unitOfMeasureCode": "TON"' +
				                '}' +
				              ']' +
				            '},' +
				            '{' +
				              '"crushingDistrict": null,' +
				              '"reportedSalvageAmount": null,' +
				              '"determinedSalvageAmount": null,' +
				              '"yieldAdjustment": "100",' +
				              '"productions": [' +
				                '{' +
				                  '"crushingDistrict": null,' +
				                  '"finalIntendedUseCode": "FG",' +
				                  '"stageCode": "U",' +
				                  '"acreage": "0.1000",' +
				                  '"quantity": "10.00",' +
				                  '"uncountedQuantity": null,' +
				                  '"correctionTypeCode": "V",' +
				                  '"correctionQuantity": "10.00",' +
				                  '"unitOfMeasureCode": "TON"' +
				                '}' +
				              ']' +
				            '}' +
				           '],' +
				          '"valueNonGraduatedLoss": null,' +
				          '"valueSingleGraduatedLoss": null,' +
				          '"valueMultiGraduatedLosses": null,' +
				          '"grazingLosses": [' +
				            '{' +
				              '"carryingCapacity": [' +
				                '{' +
				                  '"code": "01",' +
				                  '"acreage": "10.0000",' +
				                  '"period": "30"' +
				                '}' +
				               '],' +
				              '"reportedPlantedAcreage": null,' +
				              '"reportedPreventedAcreage": null,' +
				              '"inventories": [' +
				                '{' +
				                  '"cropPlantedAcreage": "0.9000",' +
				                  '"cropPreventedAcreage": null,' +
				                  '"adjustmentFactor": null,' +
				                  '"lossFactor": null,' +
				                  '"plantedAssignedQuantity": null,' +
				                  '"preventedAssignedQuantity": null,' +
				                  '"ownerships": [' +
				                    '{' +
				                      '"typeCode": "S",' +
				                      '"acreage": "0.9000",' +
				                      '"lessor": "abc"' +
				                    '}' +
				                  ']' +
				                '}' +
				              ']' +
				            '}' +
				           '],' +
				          '"marketings": null' +
				        '}' +
				      ']' +
				    '}' +
				  ']' +
				'}';

                    
    }
}
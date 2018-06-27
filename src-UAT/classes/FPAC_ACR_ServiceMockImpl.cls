public with sharing class FPAC_ACR_ServiceMockImpl implements HttpCalloutMock{
     public HTTPResponse respond(HTTPRequest req) {
     	
     	string json = '';
    	string endPoint = req.getEndpoint();
    	
		if (endPoint.indexOf('retrieveComplianceFarmData') != -1)
                json = RetrieveComplianceFarmData();
                                    
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
    
    private string RetrieveComplianceFarmData()
    {
    	return '{' +
			  '"farms": [' +
			    '{' +
			      '"countyCode": "015",' +
			      '"farmNumber": "0001621",' +
			      '"stateCode": "19",' +
			      '"dataStatusCode": "A",' +
			      '"farmYears": [' +
			        '{' +
			          '"id": "19235226",' +
			          '"tracts": [' +
			            '{' +
			              '"id": "3877662",' +
			              '"agriculturalProductionPlans": [' +
			                '{' +
			                  '"id": "12457851",' +
			                  '"acreageOfficialMeasurementCode": "M",' +
			                  '"carryingCapacity": "",' +
			                  '"certificationDate": "2018-05-22T00:00:00-05:00",' +
			                  '"certifiedIndicator": "Y",' +
			                  '"cropAbbreviation": "CRP",' +
			                  '"cropCode": "0099",' +
			                  '"cropName": "CRP",' +
			                  '"cropTypeCode": "010",' +
			                  '"cropTypeName": "CP10 VEG COVER, GRASS ALREADY EST",' +
			                  '"intendedUseCode": "  ",' +
			                  '"intendedUseName": null,' +
			                  '"irrigationPracticeCode": "I",' +
			                  '"NAPUnitNumber": "000037",' +
			                  '"NAPUnitOverride": "false",' +
			                  '"nativeSodIndicator": "N",' +
			                  '"organicStatusCode": "C ",' +
			                  '"plantingPeriodCode": "01 ",' +
			                  '"producerShares": [' +
			                    '{' +
			                      '"id": "3938086",' +
			                      '"RMAUnitNumber": "",' +
			                      '"share": "35.00",' +
			                      '"coreCustomerId": "337957"' +
			                    '},' +
			                    '{' +
			                      '"id": "3938087",' +
			                      '"RMAUnitNumber": "",' +
			                      '"share": "25.00",' +
			                      '"coreCustomerId": "562728"' +
			                    '},' +
			                    '{' +
			                      '"id": "3938088",' +
			                      '"RMAUnitNumber": "",' +
			                      '"share": "30.00",' +
			                      '"coreCustomerId": "383150"' +
			                    '},' +
			                    '{' +
			                      '"id": "5096942",' +
			                      '"RMAUnitNumber": "",' +
			                      '"share": "10.00",' +
			                      '"coreCustomerId": "563753"' +
			                    '}' +
			                  '],' +
			                  '"concurrentPlantingCode": " ",' +
			                  '"cropPlantedDate": "2016-04-29T00:00:00-05:00",' +
			                  '"cropReportingUnitCode": "A",' +
			                  '"cropRowCount": "0",' +
			                  '"cropRowWidth": "0",' +
			                  '"cropStatusCode": "I",' +
			                  '"cropUseCode": "  ",' +
			                  '"croplandIndicator": "Y",' +
			                  '"derivedFieldNumber": "1",' +
			                  '"derivedSubfieldNumber": "",' +
			                  '"determinedAcresPresent": "true",' +
			                  '"fieldIdentification": "",' +
			                  '"fieldNumber": "1",' +
			                  '"landUseCode": " ",' +
			                  '"perennialCropExpirationYear": "2018",' +
			                  '"plantingPatternTypeCode": "N",' +
			                  '"reportedAcres": "135.8800",' +
			                  '"skipRowCount": "0",' +
			                  '"skipRowWidth": "0",' +
			                  '"supplementalCropStatusCode": " ",' +
			                  '"treeAge": "0",' +
			                  '"treeSeparationLength": "0",' +
			                  '"treeUnitCount": "0"' +
			                '}' +
			              ']' +
			              
			            '}' +
			          '],' +
			          '"fullyCertified": "true",' +
			          '"fullyReportedOverride": "false",' +
			          '"fullyReportedSystem": "false",' +
			          '"programYear": "2017",' +
			          '"reportDate": "2016-12-01T00:00:00-06:00"' +
			        '}' +
			     ']' +
			    '}' +
			  ']' +
			'}' ;		  
			    
	}
     
}
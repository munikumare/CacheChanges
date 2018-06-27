public with sharing class FPAC_NCT_ServiceMockImpl implements HttpCalloutMock{
     public HTTPResponse respond(HTTPRequest req) {
     	
     	string json = '';
    	string endPoint = req.getEndpoint();
    	
		if (endPoint.indexOf('retrieveApprovedWhipInformation') != -1)
                json = RetrieveApprovedWhipInformation();
                                    
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
    
    private string RetrieveApprovedWhipInformation()
    {
    	return '{ "whipmarketForecasts" : [' +
    				'{' +
    					'"StateCode" : "19",' +
					    '"CountyCode" : "058",' +
						'"CropCode" : "0028",' +
					    '"ProgramYear" : "2017",' +
					    '"PayCrop" : "001",' +
					    '"PayType" : "054",' +
					    '"CropType" : "054",' +
					    '"CropIntendedUse" : "FH",' +
					    '"PracticeCode" : "I",' +
					    '"PlantingPeriod" : "07",' +
					    '"CrushingDistrict" : "19",' +
					    '"UnitOfMeasureCode" : "19",' +
					    '"PreventedFactor" : "19",' +
					    '"UnharvestedFactor" : "19",' +
					    '"OrganicCertifiedFactor" : "19",' +
					    '"OrganicTransitionalFactor" : "19",' +
					    '"MarketPrice" : "19",' +
					    '"OrganicMarketPrice" : "19",' +
					    '"CalculatedYield" : "19",' +
					    '"WhipPayCrop" : "19",' +
					    '"WhipPayType" : "19",' +
					    '"TreeBushVineDamagerFactorI" : "19",' +
					    '"TreeBushVineDamagerFactorII" : "19",' +
					    '"TreeBushVineDamagerFactorIII" : "19",' +
					    '"TreeBushVinePriceI" : "19",' +
					    '"TreeBushVinePriceII" : "19",' +
					    '"TreeBushVinePriceIII" : "19"' +
    				'}' +
    	'] }' ;		  
			    
	}
     
}
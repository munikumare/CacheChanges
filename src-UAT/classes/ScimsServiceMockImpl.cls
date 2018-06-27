@isTest
public with sharing class ScimsServiceMockImpl implements HttpCalloutMock{
     
     public HTTPResponse respond(HTTPRequest req) {
     	
     	string json = '';
    	string endPoint = req.getEndpoint();
    	
		if (endPoint.indexOf('getCustomerByCCID') != -1)
                json = GetCustomerData();
        else {
            	if (endPoint.indexOf('getFarmRecords') != -1)
            	 json = GetFarmData();
         }          			  
                                    
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
    
    private string GetFarmData()
    {
    	return '[{' +
					    '"number": "0000855",' +
					    '"id": "",' +
					    '"adminStateCode": "17",' +
					    '"adminCountyCode": "039",' +
					    '"farmYears": [' +
					     '{' +
					        '"crpAcres": "0.0",' +
					        '"inactiveIndicator": "false",' +
					        '"mplAcres": "0.0",' +
					        '"operator": null,' +
					        '"year": "2018",' +
					        '"dcpBaseExceedsCroplandIndicator": "false",' +
					        '"dcpDoubleCropAcres": "0.0",' +
					        '"fsa540Indicator": "",' +
					        '"otherProducers": null,' +
					        '"tracts": null,' +
					        '"crops": null,' +
					        '"elections": null,' +
					        '"hips": null,' +
					        '"priorActiveOperators": null' +
					      '}' +
					    '],' +
					    '"description": "RONALD AND JANICE SAMS",' +
					    '"reconPendingCode": ""' +
					  '}]';
                                    			  
    }
    
    
    private string GetCustomerData()
    {
    	return '[{' +
            	  '"coreCustomerID": "9748672",' +
                  '"lastName": "Smith",' +
                  '"firstName": "John",' +
                  '"middleName": "string",' +
                  '"prefix": "Mr.",' +
                  '"suffix": "",' +
                  '"gender": "Male",' +
                  '"ethnicity": "Not Hispanic",' +
                  '"race": [' +
                   	'"Asian",' +
                    '"American Indian"' +
                  '],' +
                  '"primaryPhone": "333-222-5553",' +
                  '"primaryEmail": "john.smith@example.com",' +
                  '"addresses": [' +
                    '{' +
                      '"id": "1000292",' +
                      '"type": "mailing",' +
                      '"beginDate": "2018-02-26",' +
                      '"endDate": "2020-12-23",' +
                      '"current": true,' +
                      '"zipCode": "44130",' +
                      '"zipCodePlus4": "3389",' +
                      '"supplementalLine1": "Supplemental Line 1",' +
                      '"supplementalLine2": "Supplemental Line 2",' +
                      '"informationLine": "Information Line",' +
                      '"deliveryAddressLine": "Delivery address Line",' +
                      '"carrierRouteCode": "Carrier Route Code",' +
                      '"foreignAddressLine": "Foreign address line",' +
                      '"city": "cleveland",' +
                      '"state": "OH",' +
                      '"country": "US",' +
                      '"deliveryPointBarCode": "bar code",' +
                      '"county": "Cuyahoga",' +
                      '"latitude": "41.402817",' +
                      '"longitude": "-81.663356",' +
                      '"inactiveAddressDate": "2020-02-26",' +
                      '"contactPersonName": "first Last"' +
                    '}' +
                  '],' +
                  '"commonName": "",' +
                  '"status": "active",' +
                  '"citizenCountry": [' +
                   	'"US",' +
                    '"CA"' +
                  '],' +
                  '"type": "Individual",' +
                  '"maritalStatus": "Unknown N/A",' +
                  '"languagePreference": "EN",' +
                  '"veteranStatus": "U"' +
                '}]';
                    
    }
}
@isTest
public class FPAC_SCIMS_FarmProcessorTest {

    static Contact getContact()
    {
        Contact individual = new Contact();
        individual.LastName = 'testLastName';
        individual.FirstName = 'test';
        individual.FSA_BTO_Core_Customer_ID__c = '9748672';
        
        individual.MailingStreet = '1660 Greensboro Dr.';
        individual.MailingCity = 'McLean';
        individual.MailingStateCode = 'VA';
        individual.MailingPostalCode = '22180';
        return individual;
    } 

   
    
    static FPAC_SCIMS_Farm getScimsFarm(Id individualId)
    {
    	string scimsFarmJson = '[{ '+
							   '"ScimsNumber": "0000855",'+
							    '"id": "",'+
							    '"adminStateCode": "17",'+
							    '"adminCountyCode": "039",'+
							    '"farmYears": ['+
							     ' {'+
							        '"crpAcres": "0.0",'+
							        '"inactiveIndicator": "false",'+
							        '"mplAcres": "0.0",'+
							        '"operator": null,'+
							        '"year": "2018",'+
							        '"dcpBaseExceedsCroplandIndicator": "false",'+
							        '"dcpDoubleCropAcres": "0.0",'+
							        '"fsa540Indicator": "",'+
							        '"otherProducers": ['+
							          '{'+
							            '"coreCustomerId": "563753",'+
							            '"inactiveCustomer": "false",'+
							            '"cwExceptionCode": "",'+
							            '"helExceptionCode": "",'+
							            '"pcwExceptionCode": ""'+
							          '},'+
							          '{'+
							            '"coreCustomerId": "8892827",'+
							            '"inactiveCustomer": "false",'+
							            '"cwExceptionCode": "",'+
							            '"helExceptionCode": "",'+
							            '"pcwExceptionCode": ""'+
							          '}'+
							        '],'+
							        '"tracts": ['+
							          '{'+
							            '"croplandAcres": "78.8",'+
							            '"crpAcres": "0.0",'+
							            '"farmlandAcres": "79.0",'+
							            '"helCode": "G",'+
							            '"inactiveIndicator": "false",'+
							            '"owners": ['+
							              '{'+
							                '"coreCustomerId": "8732591",'+
							                '"inactiveCustomer": "false",'+
							                '"cwExceptionCode": "",'+
							                '"helExceptionCode": "",'+
							                '"pcwExceptionCode": ""'+
							              '},'+
							              '{'+
							                '"coreCustomerId": "5148789",'+
							                '"inactiveCustomer": "false",'+
							                '"cwExceptionCode": "",'+
							                '"helExceptionCode": "",'+
							                '"pcwExceptionCode": ""'+
							              '}'+
							            '],'+
							            '"otherProducers": ['+
							              '{'+
							                '"coreCustomerId": "563753",'+
							                '"inactiveCustomer": "false",'+
							                '"cwExceptionCode": "",'+
							                '"helExceptionCode": "",'+
							                '"pcwExceptionCode": ""'+
							              '},'+
							              '{'+
							                '"coreCustomerId": "8892827",'+
							                '"inactiveCustomer": "false",'+
							                '"cwExceptionCode": "",'+
							                '"helExceptionCode": "",'+
							                '"pcwExceptionCode": ""'+
							              '}'+
							            '],'+
							            '"mplAcres": "0.0",'+
							            '"napCropAcres": "0.0",'+
							            '"ScimsNumber": "0001422",'+
							            '"otherConsrvAcres": "0.0",'+
							            '"stateConsrvAcres": "0.0",'+
							            '"sugarcaneAcres": "0.0",'+
							            '"wbpAcres": "0.0",'+
							            '"wetlandCode": "C",'+
							            '"wetlandViolations": null,'+
							            '"wrpAcres": "0.0",'+
							            '"crops": ['+
							              '{'+
							                '"abbr": "SOYBN",'+
							                '"ccYield": "32",'+
							                '"code": "0081",'+
							                '"typeCode": "",'+
							                '"typeName": "",'+
							                '"crpReductionAcres": "0.0",'+
							                '"crpReleasedAcres": "0.0",'+
							                '"crpYield": "0",'+
							                '"dcpBaseAcres": "19.2",'+
							                '"favReductionAcres": "",'+
							                '"directYield": "0",'+
							                '"name": "SOYBEANS"'+
							              '},'+
							              '{'+
							                '"abbr": "CORN ",'+
							                '"ccYield": "114",'+
							                '"code": "0041",'+
							                '"typeCode": "",'+
							                '"typeName": "",'+
							                '"crpReductionAcres": "0.0",'+
							                '"crpReleasedAcres": "0.0",'+
							                '"crpYield": "0",'+
							                '"dcpBaseAcres": "59.0",'+
							                '"favReductionAcres": "",'+
							                '"directYield": "0",'+
							                '"name": "CORN"'+
							              '}'+
							            '],'+
							            '"commonLandUnitYears": ['+
							              '{'+
							                '"alternateId": "1e2f7983-ac8e-438c-9e71-76fdbfb08d88",'+
							                '"inactiveIndicator": "false",'+
							                '"stateCountyFsaCode": "17039",'+
							                '"stateCountyAnsiCode": "17039",'+
							                '"landClassificationId": "A",'+
							                '"congressionalDistrictCode": "15",'+
							                '"fieldNumber": "0000003",'+
							                '"cluAcreage": "0.1",'+
							                '"otherProducers": ['+
							                  '{'+
							                    '"coreCustomerId": "8892827",'+
							                    '"inactiveCustomer": "false",'+
							                    '"cwExceptionCode": "",'+
							                    '"helExceptionCode": "",'+
							                    '"pcwExceptionCode": ""'+
							                  '}'+
							                '],'+
							                '"helStatusIdentifier": "C",'+
							                '"croplandIndicator3cm": "N",'+
							                '"crpContractNumber": "",'+
							                '"crpContractExpirationDate": "",'+
							                '"nativeSodConversionDate": "",'+
							                '"conservationPracticeId": "",'+
							                '"sodConversionCropYears1": "",'+
							                '"sodConversionCropYears2": "",'+
							                '"sodConversionCropYears3": "",'+
							                '"sodConversionCropYears4": ""'+
							              '},'+
							              '{'+
							                '"alternateId": "1e2f7984-ac8e-438c-9e71-76fdbfb08d88",'+
							                '"inactiveIndicator": "false",'+
							                '"stateCountyFsaCode": "17039",'+
							                '"stateCountyAnsiCode": "17039",'+
							                '"landClassificationId": "A",'+
							                '"congressionalDistrictCode": "15",'+
							                '"fieldNumber": "0000004",'+
							                '"cluAcreage": "0.1",'+
							                '"otherProducers": null,'+
							                '"helStatusIdentifier": "C",'+
							                '"croplandIndicator3cm": "N",'+
							                '"crpContractNumber": "",'+
							                '"crpContractExpirationDate": "",'+
							                '"nativeSodConversionDate": "",'+
							                '"conservationPracticeId": "",'+
							                '"sodConversionCropYears1": "",'+
							                '"sodConversionCropYears2": "",'+
							                '"sodConversionCropYears3": "",'+
							                '"sodConversionCropYears4": ""'+
							              '},'+
							              '{'+
							                '"alternateId": "1e2f7981-ac8e-438c-9e71-76fdbfb08d88",'+
							                '"inactiveIndicator": "false",'+
							                '"stateCountyFsaCode": "17039",'+
							                '"stateCountyAnsiCode": "17039",'+
							                '"landClassificationId": "A",'+
							                '"congressionalDistrictCode": "15",'+
							                '"fieldNumber": "0000001",'+
							                '"cluAcreage": "78.8",'+
							                '"otherProducers": ['+
							                  '{'+
							                    '"coreCustomerId": "563753",'+
							                    '"inactiveCustomer": "false",'+
							                    '"cwExceptionCode": "",'+
							                    '"helExceptionCode": "",'+
							                    '"pcwExceptionCode": ""'+
							                  '},'+
							                  '{'+
							                    '"coreCustomerId": "8892827",'+
							                    '"inactiveCustomer": "false",'+
							                    '"cwExceptionCode": "",'+
							                    '"helExceptionCode": "",'+
							                    '"pcwExceptionCode": ""'+
							                  '}'+
							                '],'+
							                '"helStatusIdentifier": "C",'+
							                '"croplandIndicator3cm": "Y",'+
							                '"crpContractNumber": "",'+
							                '"crpContractExpirationDate": "",'+
							                '"nativeSodConversionDate": "",'+
							                '"conservationPracticeId": "",'+
							                '"sodConversionCropYears1": "",'+
							                '"sodConversionCropYears2": "",'+
							                '"sodConversionCropYears3": "",'+
							                '"sodConversionCropYears4": ""'+
							              '},'+
							              '{'+
							                '"alternateId": "1e2f7985-ac8e-438c-9e71-76fdbfb08d88",'+
							                '"inactiveIndicator": "false",'+
							                '"stateCountyFsaCode": "17039",'+
							                '"stateCountyAnsiCode": "17039",'+
							                '"landClassificationId": "A",'+
							                '"congressionalDistrictCode": "15",'+
							                '"fieldNumber": "0000005",'+
							                '"cluAcreage": "0.1",'+
							                '"otherProducers": null,'+
							                '"helStatusIdentifier": "C",'+
							                '"croplandIndicator3cm": "N",'+
							                '"crpContractNumber": "",'+
							                '"crpContractExpirationDate": "",'+
							                '"nativeSodConversionDate": "",'+
							                '"conservationPracticeId": "",'+
							                '"sodConversionCropYears1": "",'+
							                '"sodConversionCropYears2": "",'+
							                '"sodConversionCropYears3": "",'+
							                '"sodConversionCropYears4": ""'+
							              '},'+
							              '{'+
							                '"alternateId": "1e2f7982-ac8e-438c-9e71-76fdbfb08d88",'+
							                '"inactiveIndicator": "false",'+
							                '"stateCountyFsaCode": "17039",'+
							                '"stateCountyAnsiCode": "17039",'+
							                '"landClassificationId": "A",'+
							                '"congressionalDistrictCode": "15",'+
							                '"fieldNumber": "0000002",'+
							                '"cluAcreage": "0.1",'+
							                '"otherProducers": ['+
							                  '{'+
							                    '"coreCustomerId": "8892827",'+
							                    '"inactiveCustomer": "false",'+
							                    '"cwExceptionCode": "",'+
							                    '"helExceptionCode": "",'+
							                    '"pcwExceptionCode": ""'+
							                  '}'+
							                '],'+
							                '"helStatusIdentifier": "C",'+
							                '"croplandIndicator3cm": "N",'+
							                '"crpContractNumber": "",'+
							                '"crpContractExpirationDate": "",'+
							                '"nativeSodConversionDate": "",'+
							                '"conservationPracticeId": "",'+
							                '"sodConversionCropYears1": "",'+
							                '"sodConversionCropYears2": "",'+
							                '"sodConversionCropYears3": "",'+
							                '"sodConversionCropYears4": ""'+
							              '}'+
							            '],'+
							            '"description": "G-1  SEC 18",'+
							            '"stateCountyCode": "17039",'+
							            '"dcpCroplandAcres": "78.8",'+
							            '"dcpDoubleCropAcres": "0.0",'+
							            '"dcpEffectiveCroplandAcres": "78.8",'+
							            '"favWRHistoryIndicator": "false",'+
							            '"grpAcres": "0.0",'+
							            '"sodAcres": "0.0",'+
							            '"numberBIA": "",'+
							            '"wetlandCertCode": "N",'+
							            '"wetlandCertYear": "0"'+
							          '}'+
							        '],'+
							        '"crops": ['+
							          '{'+
							            '"abbr": "SOYBN",'+
							            '"ccYield": "32",'+
							            '"code": "0081",'+
							            '"typeCode": "",'+
							            '"typeName": "",'+
							            '"crpReductionAcres": "0.0",'+
							            '"crpReleasedAcres": "0.0",'+
							            '"crpYield": "0",'+
							            '"dcpBaseAcres": "19.2",'+
							            '"favReductionAcres": "0.0",'+
							            '"directYield": "0",'+
							            '"name": "SOYBEANS"'+
							          '},'+
							          '{'+
							            '"abbr": "CORN ",'+
							            '"ccYield": "114",'+
							            '"code": "0041",'+
							            '"typeCode": "",'+
							            '"typeName": "",'+
							            '"crpReductionAcres": "0.0",'+
							            '"crpReleasedAcres": "0.0",'+
							            '"crpYield": "0",'+
							            '"dcpBaseAcres": "59.0",'+
							            '"favReductionAcres": "0.0",'+
							            '"directYield": "0",'+
							            '"name": "CORN"'+
							          '}'+
							        '],'+
							        '"elections": ['+
							          '{'+
							            '"abbr": "SOYBN",'+
							            '"code": "0081",'+
							            '"typeCode": "",'+
							            '"typeName": "",'+
							            '"name": "SOYBEANS",'+
							            '"electionCode": "A"'+
							          '},'+
							          '{'+
							            '"abbr": "CORN ",'+
							            '"code": "0041",'+
							            '"typeCode": "",'+
							            '"typeName": "",'+
							            '"name": "CORN",'+
							            '"electionCode": "B"'+
							          '}'+
							        '],'+
							        '"hips": null,'+
							        '"priorActiveOperators": null'+
							      '}'+
							    '],'+
							    '"description": "RONALD AND JANICE SAMS",'+
							    '"reconPendingCode": ""'+
							  '}]';
    	
    	
    	List<FPAC_SCIMS_Farm> scimsFarmList = (List<FPAC_SCIMS_Farm>) JSON.deserialize(scimsFarmJson, List<FPAC_SCIMS_Farm>.class);
    	
        FPAC_SCIMS_Farm farm = scimsFarmList[0];
        farm.IndividualId = individualId;
        
        return farm;
    }
    
    @isTest
	public static void ProcessCustomer_givenId_shouldGetFarmDetailsFromScims() {
    	
        Test.setMock(HttpCalloutMock.class, new ScimsServiceMockImpl());
          
        Contact individual = getContact();
        insert individual;
    	  
        Map<Id, string> coreCustomerIds = new Map<Id, string>();
        coreCustomerIds.put(individual.Id, '9748672');
        
        FPAC_SCIMS_FarmProcessor farmProcessor = new FPAC_SCIMS_FarmProcessor();
        
        Test.startTest();
        List<FPAC_SCIMS_Farm> scimsFarms = farmProcessor.GetFarmData(coreCustomerIds);
        Test.stopTest();
        
        List<FPAC_SCIMS_Farm> testScimsFarms = new List<FPAC_SCIMS_Farm>();
        testScimsFarms.add(getScimsFarm(individual.Id));
        
        System.assertEquals(testScimsFarms[0].ScimsNumber, scimsFarms[0].ScimsNumber);
    }
    
     @isTest
	public static void ProcessCustomer_givenDetails_ShouldSaveFarms() {
     	Contact individual = getContact();
        insert individual;
        
        List<FPAC_SCIMS_Farm> testScimsFarms = new List<FPAC_SCIMS_Farm>();
        testScimsFarms.add(getScimsFarm(individual.Id));
        system.debug(testScimsFarms);
        
        FPAC_SCIMS_FarmProcessor farmProcessor = new FPAC_SCIMS_FarmProcessor();

        Test.startTest();
        farmProcessor.SaveFarmData(testScimsFarms);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Land__c WHERE Individual__r.Id = :individual.Id], 'An farm should have been created');
	}
}
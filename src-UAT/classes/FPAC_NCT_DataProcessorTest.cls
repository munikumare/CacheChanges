@isTest
public with sharing class FPAC_NCT_DataProcessorTest {
    static string cropCode = '0028'; 
    static string countyCode = '015';
    static string stateCode = '19';
    static decimal year = 2017;
    
    
    @isTest
	public static void ProcessData_givenInput_shouldCreateNctData() {
    	
    	Test.setMock(HttpCalloutMock.class, new FPAC_NCT_ServiceMockImpl());
        
        FPAC_NCT_DataProcessor nctDataProcessor = new FPAC_NCT_DataProcessor();
        
        Test.startTest();
        nctDataProcessor.ProcessData(year, stateCode, countyCode, cropCode);
        Test.stopTest(); 
        
        System.assert(true); 
    }
}
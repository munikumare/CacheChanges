@isTest
public class FPAC_SCIMS_CustomerProcessorTest {
    
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
    
    static FPAC_SCIMS_Customer getCustomer(string individualId)
    {
        FPAC_SCIMS_Customer customer = new FPAC_SCIMS_Customer();
        customer.CitizenCountry = new List<string> {'US', 'CA'};
        customer.CommonName = '';
        customer.CoreCustomerId='9748672';
        customer.Ethnicity = 'Not Hispanic';
        customer.FirstName = 'John';
        customer.Gender = 'Male';
        customer.IndividualId = individualId;
        customer.LanguagePreference = 'EN';
        customer.LastName = 'Smith';
        customer.MaritalStatus = 'Unknown N/A';
        customer.MiddleName = 'string';
        customer.Prefix = 'Mr.';
        customer.PrimaryEmail = 'john.smith@example.com';
        customer.PrimaryPhone = '333-222-5553';
        customer.Race = new List<string> {'Asian', 'American Indian'};
        customer.Status = 'active';
        customer.Suffix = '';
        customer.Type  = 'Individual';
        customer.VeteranStatus = 'U';
 
        customer.Addresses = new List<FPAC_SCIMS_Address>();
        customer.Addresses.Add(getAddress());
        
        return customer;
    }

    
    static FPAC_SCIMS_Address getAddress()
    {
        FPAC_SCIMS_Address address = new FPAC_SCIMS_Address();
        address.City = 'cleveland';
        address.ContactPersonName = 'first Last';
        address.DeliveryAddressLine = 'Delivery address Line';
        address.State = 'OH';
        address.Type = 'mailing';
        address.ZipCode = '44130';
        address.ZipCodePlus4 = '3389';
        
        //address.Id = '1000292';
        //address.BeginDate = '2018-02-26';
        //address.EndDate = '2020-12-23';
        //address.Current = true;
        //address.SupplementalLine1 = 'Supplemental Line 1';
        //address.SupplementalLine2 = 'Supplemental Line 2';
        //address.InformationLine = 'Information Line';
        //address.CarrierRouteCode = 'Carrier Route Code';
        //address.ForeignAddressLine = 'Foreign address line';
        //address.Country = 'US';
        //address.DeliveryPointBarCode = 'bar code';
        //address.County = 'Cuyahoga';
        //address.Latitude = '41.402817';
        //address.Longitude = '-81.663356';
        //address.InactiveAddressDate = '2020-02-26';
        
        return address;
    }
    
    @isTest
	public static void ProcessCustomer_givenId_shouldGetCoreCustomerIds() {
    	Contact individual = getContact();
        insert individual;
        
        FPAC_SCIMS_CustomerProcessor customerProcessor = new FPAC_SCIMS_CustomerProcessor();
        
        List<string> individualIds = new List<string>();
        individualIds.add(individual.Id);
        
        Test.startTest();
        Map<Id, String> coreCustomerIds = customerProcessor.GetCoreCustomerIds(individualIds);
        Test.stopTest();
        
        System.assertEquals('9748672', coreCustomerIds.get(individual.Id), 'Core Customer Id was retrieved successfully'); 
    }
    
	@isTest
	public static void ProcessCustomer_givenId_shouldGetCustomerDetailsFromScims() {
    	
        Test.setMock(HttpCalloutMock.class, new ScimsServiceMockImpl());
        
        Contact individual = getContact();
        insert individual;
        
        FPAC_SCIMS_CustomerProcessor customerProcessor = new FPAC_SCIMS_CustomerProcessor();
        
        List<string> individualIds = new List<string>();
        individualIds.add(individual.Id);
        
        List<string> coreCustomerIds = new List<string>();
        coreCustomerIds.add('9748672');
        
        Test.startTest();
        List<FPAC_SCIMS_Customer> scimsCustomers = customerProcessor.GetCustomerDetails(coreCustomerIds);
        Test.stopTest();
        
        List<FPAC_SCIMS_Customer> testScimsCustomers = new List<FPAC_SCIMS_Customer>();
        testScimsCustomers.add(getCustomer(individual.Id));
        
        System.assertEquals(testScimsCustomers[0].CoreCustomerId, scimsCustomers[0].CoreCustomerId);
    }
    
    
    @isTest
	public static void ProcessCustomer_givenDetails_ShouldSaveContacts() {
    	
        Contact individual = getContact();
        insert individual;
        
         List<FPAC_SCIMS_Customer> testScimsCustomers = new List<FPAC_SCIMS_Customer>();
        testScimsCustomers.add(getCustomer(individual.Id));
        
        FPAC_SCIMS_CustomerProcessor customerProcessor = new FPAC_SCIMS_CustomerProcessor();

        Test.startTest();
        customerProcessor.SaveContacts(testScimsCustomers);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Contact WHERE FSA_BTO_Core_Customer_ID__c = '9748672' AND LastName != 'testLastName'], 'An individual record with CCID 9748672 should have been updated');
    }
}
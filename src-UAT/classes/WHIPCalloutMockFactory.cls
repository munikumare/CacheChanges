@isTest
public class WHIPCalloutMockFactory {
    public static HttpCalloutMock getCalloutMock() {
        Map<String, HttpCalloutMock> mocksByEndpoint = new Map<String, HttpCalloutMock>();        
        mocksByEndpoint.put('/api/retrieveCoverageByProducer', new FPAC_NAP_ServiceMockImpl());
        mocksByEndpoint.put('/api/retrieveApplicationByProducer', new FPAC_NAP_ServiceMockImpl());
        mocksByEndpoint.put('/retrieveComplianceFarmData', new FPAC_ACR_ServiceMockImpl());
        mocksByEndpoint.put('/producers', new FPAC_RMA_ServiceMockImpl());
        mocksByEndpoint.put('/api/retrieveNoticeOfLossByProducer', new FPAC_NAP_ServiceMockImpl());
        mocksByEndpoint.put('/api/retrieveYieldByProducer', new FPAC_NAP_ServiceMockImpl());
        return new MultiRequestMockImpl(mocksByEndpoint);
    }
}
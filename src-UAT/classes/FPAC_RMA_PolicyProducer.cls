public with sharing class FPAC_RMA_PolicyProducer {
    public string LocationStateCode  {get; set;} 
    public List<FPAC_RMA_InsuranceInForce> InsuranceInForces {get; set;}
    public List<FPAC_RMA_PolicyProducerOtherPerson> PolicyProducerOtherPersons {get; set;}
   
    public void AddFieldsToMap(Map<string, string> rmaFieldValueMap)
    {
    	rmaFieldValueMap.put('LocationStateCode', LocationStateCode); 
    }
}
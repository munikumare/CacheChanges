global class FAQ_Controller {
    
    @auraEnabled
    public static list<FAQWrapper> getFAQList() {
        map<string,List<FPAC_FAQ__c>> FAQMap = new map<string,List<FPAC_FAQ__c>>();
        for(FPAC_FAQ__c faq: [SELECT Answer__c,Category__c,Question__c FROM FPAC_FAQ__c 
                                                                       WHERE Active__c = true
                                                                       Order By Category__c,Question__c ]){
            if(FAQMap.containsKey(faq.Category__c))
                FAQMap.get(faq.Category__c).add(faq);
            else
                FAQMap.put(faq.Category__c,new list<FPAC_FAQ__c>{faq});
        }

        list<FAQWrapper> wrapperToReturn = new list<FAQWrapper>();
        if(!FAQMap.isEmpty()){
            for(String key: FAQMap.keySet()){
                FAQWrapper faqw = new FAQWrapper();
                faqw.Category = key;
                faqw.QAList = FAQMap.get(key);
                faqw.size = faqw.QAList.size();
                wrapperToReturn.add(faqw);
            }
            wrapperToReturn.sort();
        }
        return wrapperToReturn;
    }
}
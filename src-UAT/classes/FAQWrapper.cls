global class FAQWrapper implements Comparable{
    @auraEnabled global String Category;
    @auraEnabled global list<FPAC_FAQ__c> QAList;
    @auraEnabled global integer size;

    public Integer compareTo(Object compareTo) {
        FAQWrapper compareToFAQ = (FAQWrapper)compareTo;
        if (size == compareToFAQ.size) return 0;
        if (size > compareToFAQ.size) return -1;
        return 1;        
    }
}
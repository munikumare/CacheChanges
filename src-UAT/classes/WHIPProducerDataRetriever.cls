public without sharing class WHIPProducerDataRetriever {
    public static final Set<Decimal> defaultYears = new Set<Decimal> {2017, 2018};

    public static void retrieveProducerDataByContactId(Id contactId) {
        retrieveProducerDataByContactId(new Set<Id> {contactId});
    }

    public static void retrieveProducerDataByContactId(Set<Id> contactIds) {
        Map<Id, WHIP_Application__c> applicationMap = new Map<Id, WHIP_Application__c>(
            [SELECT Id FROM WHIP_Application__c WHERE Related_Interaction__r.ContactId IN :contactIds]
        );

        retrieveProducerDataByAppId(applicationMap.keySet());
    }

    public static void retrieveProducerDataByAppId(Id applicationId) {
        retrieveProducerDataByAppId(new Set<Id> {applicationId});
    }

    public static void retrieveProducerDataByAppId(Set<Id> applicationIds) {
        Map<String, WHIPApplicationInfo> appInfoMap = new Map<String, WHIPApplicationInfo>();
        List<NAP_RMA_NCT_ACR_Data__c> dataToInsert = new List<NAP_RMA_NCT_ACR_Data__c>();
        
        Set<String> ccids = new Set<String>();
        Set<String> stateCodes = new Set<String>();
        Set<String> countyCodes = new Set<String>();

        for (wHIP_Application__c app : [SELECT Id, Related_Interaction__r.Contact.FSA_BTO_Core_Customer_ID__c,
                                        AdminCountyCode__c, AdminStateCode__c
                                        FROM WHIP_Application__c WHERE Id IN :applicationIds]) {
            String ccid = app.Related_Interaction__r.Contact.FSA_BTO_Core_Customer_ID__c;
            String stateCode = app.AdminStateCode__c;
            String countyCode = app.AdminCountyCode__c;

            ccids.add(ccid);
            stateCodes.add(stateCode);
            countyCodes.add(countyCode);

            WHIPApplicationInfo appInfo = new WHIPApplicationInfo();
            appInfo.ccid = ccid;
            appInfo.stateCode = stateCode;
            appInfo.countyCode = countyCode;
            
            appInfoMap.put(appInfo.key, appInfo);
        }

        // this will make multiple callouts per appInfo per year
        for (WHIPApplicationInfo appInfo : appInfoMap.values()) {
            for (Decimal year : defaultYears) {
                dataToInsert.addAll(retrieveNapData(appInfo, year));
                dataToInsert.addAll(retrieveAcrData(appInfo, year));
                dataToInsert.addAll(retrieveRmaData(appInfo, year));
                System.debug(appInfo + '- Year: ' + year + '- Callouts: ' + Limits.getCallouts() + '/' + Limits.getLimitCallouts());
            }
        }

        List<NAP_RMA_NCT_ACR_Data__c> dataToDelete = findExistingProducerData(appInfoMap.keySet(), ccids, stateCodes, countyCodes);

        delete dataToDelete;
        insert dataToInsert;
    }

    @future (callout=true)
    public static void retrieveProducerDataByAppId_Future(Id applicationId) {
        retrieveProducerDataByAppId_Future(new Set<Id> {applicationId});
    }
    
    @future (callout=true)
    public static void retrieveProducerDataByAppId_Future(Set<Id> applicationIds) {
        retrieveProducerDataByAppId(applicationIds);
    }

    private static List<NAP_RMA_NCT_ACR_Data__c> retrieveNapData(WHIPApplicationInfo appInfo, Decimal year) {
        FPAC_NAP_DataProcessor napDataProcesser = new FPAC_NAP_DataProcessor();
        FPAC_NAP_DataResponse napDataResponse = napDataProcesser.GetData(appInfo.ccid, year, appInfo.stateCode, appInfo.countyCode);
        return napDataProcesser.ConvertToNapRmaNctAcrData(napDataResponse);
    }

    private static List<NAP_RMA_NCT_ACR_Data__c> retrieveAcrData(WHIPApplicationInfo appInfo, Decimal year) {
        FPAC_ACR_DataProcessor acrDataProcesser = new FPAC_ACR_DataProcessor();
        FPAC_ACR_DataResponse acrDataResponse = acrDataProcesser.GetData(appInfo.ccid, year, appInfo.stateCode, appInfo.countyCode);
        return acrDataProcesser.ConvertToNapRmaNctAcrData(acrDataResponse, appInfo.ccid);
    }

    private static List<NAP_RMA_NCT_ACR_Data__c> retrieveRmaData(WHIPApplicationInfo appInfo, Decimal year) {
        FPAC_RMA_DataProcessor rmaDataProcessor = new FPAC_RMA_DataProcessor();
        FPAC_RMA_DataResponse rmaDataResponse = rmaDataProcessor.GetData(appInfo.ccid, year, appInfo.stateCode, appInfo.countyCode);
        return rmaDataProcessor.ConvertToNapRmaNctAcrData(appInfo.ccid, year, appInfo.stateCode, appInfo.countyCode, rmaDataResponse);
    }

    private static List<NAP_RMA_NCT_ACR_Data__c> findExistingProducerData(Set<String> parameterKeys, Set<String> ccids, 
                                                                          Set<String> stateCodes, Set<String> countyCodes) {
        List<NAP_RMA_NCT_ACR_Data__c> existingProducerData = new List<NAP_RMA_NCT_ACR_Data__c>();
        
        for (NAP_RMA_NCT_ACR_Data__c data : [SELECT Id, CCID__c, State_Code__c, County_Code__c
                                             FROM NAP_RMA_NCT_ACR_Data__c
                                             WHERE CCID__c IN :ccids AND State_Code__c IN :stateCodes
                                             AND County_Code__c IN :countyCodes
                                             AND (ACR_Program_Year__c IN :defaultYears OR NAP_Program_Year__c IN :defaultYears
                                             OR RMA_Program_Year__c IN :defaultYears)]) {
            if (parameterKeys.contains(getKeyFromData(data))) {
                existingProducerData.add(data);
            }
        }

        return existingProducerData;
    }

    private static String getKeyFromData(NAP_RMA_NCT_ACR_Data__c data) {
        return data.CCID__c + '' + data.State_Code__c + '' + data.County_Code__c;
    }

    public class WHIPApplicationInfo {
        public String ccid {get; set;}
        public String stateCode {get; set;}
        public String countyCode {get; set;}
        public String key {
            get {
                return ccid + '' + stateCode + '' + countyCode;
            }
        }
    }
}
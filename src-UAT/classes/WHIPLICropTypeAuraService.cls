public with sharing class WHIPLICropTypeAuraService {
    private static final String ACR_RECORD_TYPE_NAME = 'ACR Data';
    private static final String NAP_RECORD_TYPE_NAME = 'NAP Data';
    private static final String RMA_RECORD_TYPE_NAME = 'RMA Data';

    @auraEnabled
    public static List<DataWrapper> getData(String nolId) {
        
        WHIPNoticeofLoss__c loss = [
            SELECT Id, CropType__c, CoverageType__c, 
                   WHIP_Application__r.Individual__r.FSA_BTO_Core_Customer_ID__c 
            FROM WHIPNoticeofLoss__c 
            WHERE Id = :nolId
        ];

        List<DataWrapper> wrapperList = new List<DataWrapper>();

        List<NAP_RMA_NCT_ACR_Data__c> dataList = [
            SELECT Id, RecordType.Name, ACR_Crop_Type_Code__c, NAP_Crop_Type_Code__c, NAP_Intended_Use_Code__c,
                   ACR_Crop_Intended_Use__c, NAP_Irrigation_Practice_Code__c, NAP_Planting_Period_Code__c,
                   ACR_Planting_Period_Code__c, ACR_Irrigation_Practice_Code__c, RMA_Intended_Use_Code__c,
                   RMA_Practice_Code__c, RMA_Type_Code__c, RMA_Planting_Period_Code__c, CCID__c
            FROM NAP_RMA_NCT_ACR_Data__c
            WHERE (NAP_Crop_Type_Code__c = :loss.CropType__c
                OR ACR_Crop_Type_Code__c = :loss.CropType__c
                OR RMA_Type_Code__c = :loss.CropType__c)
                AND CCID__c = :loss.WHIP_Application__r.Individual__r.FSA_BTO_Core_Customer_ID__c
                AND RecordType.Name = :loss.CoverageType__c
        ];

        for (NAP_RMA_NCT_ACR_Data__c data : dataList) {
            DataWrapper wrapper = new DataWrapper(data);
            wrapperList.add(wrapper);
        }

        return wrapperList;
    }

    public class DataWrapper {
        @auraEnabled
        public String DataId {get; set;}
        @auraEnabled
        public String CropType {get; set;}
        @auraEnabled
        public String IntendedUse {get; set;}
        @auraEnabled
        public String Practice {get; set;}
        @auraEnabled
        public String PlantingPeriod {get; set;}

        public DataWrapper(NAP_RMA_NCT_ACR_Data__c data) {
            this.DataId = data.Id;

            if (data.RecordType.Name == ACR_RECORD_TYPE_NAME) {
                this.CropType = data.ACR_Crop_Type_Code__c;
                this.IntendedUse = data.ACR_Crop_Intended_Use__c;
                this.Practice = data.ACR_Irrigation_Practice_Code__c;
                this.PlantingPeriod = data.ACR_Planting_Period_Code__c;
            } else if (data.RecordType.Name == NAP_RECORD_TYPE_NAME) {
                this.CropType = data.NAP_Crop_Type_Code__c;
                this.IntendedUse = data.NAP_Intended_Use_Code__c;
                this.Practice = data.NAP_Irrigation_Practice_Code__c;
                this.PlantingPeriod = data.NAP_Planting_Period_Code__c;
            } else if (data.RecordType.Name == RMA_RECORD_TYPE_NAME) {
                this.CropType = data.RMA_Type_Code__c;
                this.IntendedUse = data.RMA_Intended_Use_Code__c;
                this.Practice = data.RMA_Practice_Code__c;
                this.PlantingPeriod = data.RMA_Planting_Period_Code__c;
            }
        }
    }
}
global with sharing class FPAC_LandLatLongBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public static String query='Select Id, Dashed_Farm_Number__c, Tract_Number__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Calculate_LatLong__c From Land__c Where Calculate_LatLong__c=true';
    
    global FPAC_LandLatLongBatch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
            Map < Id, Land__c > landFarm = new Map < Id, Land__c > ();
            Set < String > dashedFarmNumbersAndTractNumbers = new Set < String > ();
            List<Land__c> landRecordsToUpdate=(List<Land__c >)scope;
            if(!landRecordsToUpdate.isEmpty()){
            for (Land__c land: landRecordsToUpdate) {
                if (land.Tract_Number__c != null) {
                    dashedFarmNumbersAndTractNumbers.add(land.Id+','+land.Dashed_Farm_Number__c + ',' + land.Tract_Number__c);
                } else {
                    dashedFarmNumbersAndTractNumbers.add(land.Id+','+land.Dashed_Farm_Number__c);
                }
                land.Calculate_LatLong__c=false;
                landFarm.put(land.Id, land);
            }

            if (!dashedFarmNumbersAndTractNumbers.isEmpty()) {
                for (String landInfo: dashedFarmNumbersAndTractNumbers) {
                    String landId = '';
                    String farmNumber = '';
                    String tractNumber = '';
                    if (landInfo.split(',').size()>2) {
                        landId = landInfo.split(',')[0];
                        farmNumber = landInfo.split(',')[1];
                        tractNumber = landInfo.split(',')[2];
                    } else {
                        landId = landInfo.split(',')[0];
                        farmNumber = landInfo.split(',')[1];
                    }
                    String boundaryJSON = FPAC_LandLatLongBatchHelper.getBoundaryInformation(farmNumber, tractNumber);
                    system.debug(boundaryJSON);
                    if (!String.isEmpty(boundaryJSON)) {
                        landFarm=FPAC_LandLatLongBatchHelper.findLatLong(boundaryJSON, landId, landFarm);
                    }else{
                        landFarm=landFarm;
                    }
                }
            }else{
                landFarm=landFarm;
            }
            if(!landFarm.isEmpty()){
                FPAC_LandLatLongBatchHelper.updateLatLong(landFarm);
            }
        }

    }
    
    global void finish(Database.BatchableContext BC) {
        FPAC_Settings__c fpac = FPAC_Settings__c.getOrgDefaults();
        if(fpac.Run_Batch__c){
            FPAC_LandLatLongBatch landBatch= new FPAC_LandLatLongBatch();
            Database.executeBatch(landBatch,1);
        }
    }
    
}
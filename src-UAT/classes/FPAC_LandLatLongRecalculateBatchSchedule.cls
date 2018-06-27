global class FPAC_LandLatLongRecalculateBatchSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		FPAC_Settings__c fpac = FPAC_Settings__c.getOrgDefaults();
        if(fpac.Run_Batch__c){
            FPAC_LandLatLongRecalculateBatch landRecalculateBatch= new FPAC_LandLatLongRecalculateBatch();
            Database.executeBatch(landRecalculateBatch,1);
        }
	}
}
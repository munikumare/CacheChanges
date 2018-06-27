global class LandSharingRecalculation implements Database.Batchable<sObject> {

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
			SELECT Id, Associated_Land__c, Contact__c, Role__c
			FROM Authority__c
		]);
	}

	global void execute(Database.BatchableContext BC, List<Authority__c> scope) {
		// Delete all Land__Share records
		Set<String> landIds = new Set<String>();
		for(Authority__c record : scope) {
			landIds.add(record.Associated_Land__c);
		}
		List<Land__Share> sharingRecordsToDelete = [
			SELECT Id
			FROM Land__Share
			WHERE ParentId IN :landIds
			AND (
				RowCause = :Schema.Land__Share.rowCause.Operator__c
				OR
				RowCause = :Schema.Land__Share.rowCause.Other_Producer__c
				OR
				RowCause = :Schema.Land__Share.rowCause.Other_Tenant__c
				OR
				RowCause = :Schema.Land__Share.rowCause.Owner__c
			)
		];
		delete sharingRecordsToDelete;
		// Create new Land__Share records for each Authority record
		AuthorityTriggerHelper.newSharingRecord(scope);
	}

	global void finish(Database.BatchableContext BC) {
	}
}
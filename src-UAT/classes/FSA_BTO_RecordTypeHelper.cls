public without sharing class FSA_BTO_RecordTypeHelper {
    @future
    static public void updateRecordTypesAccount(Set < Id > accountIds) {
        List < Account > toUpdate = [select Id, RecordType.Name from Account where Id in : accountIds];
        List < RecordType > recordTypes = [Select Name, Id from RecordType where Name IN('USDA Agency Contact', 'Public Partner Individual', 'FPAC Partner Contact', 'FPAC Customer Contact') AND SObjectType = 'Contact'];
        Map < String, Id > recordTypeNameIdMap = new Map < String, Id > ();
        for (RecordType rt: recordTypes) {
            recordTypeNameIdMap.put(rt.Name, rt.Id);
        }
        if (!recordTypeNameIdMap.isEmpty()) {
            if (!toUpdate.isEmpty()) {
                Map < Id, Id > accountIdRecordTypeIdMap = new Map < Id, Id > ();
                for (Account a: toUpdate) {
                    System.Debug('Account Record Type:' + a.RecordType.Name);
                    if (a.RecordType.Name == 'USDA Agency') {
                        accountIdRecordTypeIdMap.put(a.Id, recordTypeNameIdMap.get('USDA Agency Contact'));
                    } else if (a.RecordType.Name == 'Public Partner Organization') {
                        accountIdRecordTypeIdMap.put(a.Id, recordTypeNameIdMap.get('Public Partner Individual'));
                    } else if (a.RecordType.Name == 'FPAC Partner Account') {
                        accountIdRecordTypeIdMap.put(a.Id, recordTypeNameIdMap.get('FPAC Partner Contact'));
                    } else if (a.RecordType.Name == 'FPAC Customer Account') {
                        accountIdRecordTypeIdMap.put(a.Id, recordTypeNameIdMap.get('FPAC Customer Contact'));
                    }
                }
                if (!accountIdRecordTypeIdMap.isEmpty()) {
                    List < Contact > contacts = [Select Id, RecordTypeId, AccountId from Contact where accountId IN: accountIdRecordTypeIdMap.keySet()];
                    if (!contacts.isEmpty()) {
                        for (Contact c: contacts) {
                            c.RecordTypeId = accountIdRecordTypeIdMap.get(c.AccountId);
                        }
                        update contacts;
                    }
                }
            }
        }
    }
}
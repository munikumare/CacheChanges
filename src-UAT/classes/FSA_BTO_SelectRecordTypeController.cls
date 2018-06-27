public class FSA_BTO_SelectRecordTypeController {
    public Id accId {get;set;}
    public String savenewurl;
    private final Contact contact;

    public FSA_BTO_SelectRecordTypeController(ApexPages.StandardController controller) {
        this.contact = (Contact) controller.getRecord();
        accId = System.currentPageReference().getParameters().get('accId');
        savenewurl = System.currentPageReference().getParameters().get('save_new_url');
    }

    public PageReference handleRedirect() {
        if (accId == null & contact.RecordTypeID != null) {
            return new PageReference('/003/e?nooverride=1&RecordType=' + contact.RecordTypeId);
        } else if (accId != null & contact.RecordTypeID != null) {
            List < RecordType > recordTypes = [Select Name, Id from RecordType where Name IN('USDA Agency Contact', 'Public Partner Individual', 'FPAC Partner Contact', 'FPAC Customer Contact') AND SObjectType = 'Contact'];
            Map < String, Id > recordTypeNameIdMap = new Map < String, Id > ();
            for (RecordType rt: recordTypes) {
                recordTypeNameIdMap.put(rt.Name, rt.Id);
            }
            if (!recordTypeNameIdMap.isEmpty()) {
                Account thisAccount = [Select Name, Id, RecordType.Name from Account where id = : accId];
                Id rtId;
                if (thisAccount.RecordType.Name == 'USDA Agency') {
                    rtId = recordTypeNameIdMap.get('USDA Agency Contact');
                } else if (thisAccount.RecordType.Name == 'Public Partner Organization') {
                    rtId = recordTypeNameIdMap.get('Public Partner Individual');
                } else if (thisAccount.RecordType.Name == 'FPAC Partner Account') {
                    rtId = recordTypeNameIdMap.get('FPAC Partner Contact');
                } else if (thisAccount.RecordType.Name == 'FPAC Customer Account') {
                    rtId = recordTypeNameIdMap.get('FPAC Customer Contact');
                }
                if (rtId != null) {
                    contact.RecordTypeId = rtId;
                    return new PageReference('/003/e?retURL=' + accid + '&accid=' + accid + '&RecordType=' + rtId + '&ent=Contact&nooverride=1');
                }
            }
        }
        //return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Contact&save_new_url=%2F003%2Fe');
        return null;
    }
}
public virtual class ARCGISMapOverlayExtension {
    public static final String OPERATOR_ROLE = 'Operator';
    public static final String OPERATOR_OWNER_ROLE = 'Operator-Owner';
    public static final String OWNER_ROLE = 'Owner';
    public static final String OTHER_PRODUCER_ROLE = 'Other Producer';
    public static final String OTHER_TENANT_ROLE = 'Other Tenant';
    public static final String SYSTEM_ADMIN = 'System Administrator';
    public static final String EMPLOYEE_BASE_PROFILE = 'FPAC Employee Base';
    public static final String EMPLOYEE_MANAGER_PROFILE = 'FPAC Manager Base';
    public static Boolean checkUserIsAdminOrEmployee() {
        User user = [SELECT Id, Profile.Name FROM User WHERE Id = : UserInfo.getUserId()];
        if (user.Profile.Name == SYSTEM_ADMIN || user.Profile.Name == EMPLOYEE_BASE_PROFILE || user.Profile.Name == EMPLOYEE_MANAGER_PROFILE) {
            return true;
        } else {
            return false;
        }
    }
    public static Set < Id > getAllTractsIdsByFarmId(Id farmId, Id contactId) {
        Map < Id, Land__c > tractsByIds;
        if (contactId != null) {
            List < Land__c > tractLandRecords = [SELECT Id
                FROM Land__c
                WHERE Parent_ID__c = : farmId
            ];
            system.debug(tractLandRecords);
            List < Authority__c > authorities = [SELECT Id, Associated_Land__c FROM Authority__c WHERE Contact__c = : contactId AND Associated_Land__c IN: tractLandRecords];
            system.debug(authorities);
            Set < Id > landIdsWithAuthorities = new Set < Id > ();
            for (Authority__c a: authorities) {
                landIdsWithAuthorities.add(a.Associated_Land__c);
            }
            tractsByIds = new Map < Id, Land__c > ([
                SELECT Id
                FROM Land__c
                WHERE Id IN: landIdsWithAuthorities
            ]);
            system.debug(tractsByIds);
        } else {
            tractsByIds = new Map < Id, Land__c > ([
                SELECT Id
                FROM Land__c
                WHERE Parent_ID__c = : farmId
            ]);
        }
        return tractsByIds.keySet();
    }
    public static Set < Id > getAllFieldsIdsByFarmId(Id farmId, Id contactId) {
        Map < Id, Land__c > fieldsByIds;
        if (contactId != null) {
            List < Land__c > fieldLandRecords = [SELECT Id
                FROM Land__c
                WHERE Parent_ID__r.Parent_ID__c = : farmId
            ];
            system.debug(fieldLandRecords);
            List < Authority__c > authorities = [SELECT Id, Associated_Land__c FROM Authority__c WHERE Contact__c = : contactId AND Associated_Land__c IN: fieldLandRecords];
            system.debug(authorities);
            Set < Id > landIdsWithAuthorities = new Set < Id > ();
            for (Authority__c a: authorities) {
                landIdsWithAuthorities.add(a.Associated_Land__c);
            }
            fieldsByIds = new Map < Id, Land__c > ([
                SELECT Id
                FROM Land__c
                WHERE Id IN: landIdsWithAuthorities
            ]);
            system.debug(fieldsByIds);
        } else {
            fieldsByIds = new Map < Id, Land__c > ([
                SELECT Id
                FROM Land__c
                WHERE Parent_ID__r.Parent_ID__c = : farmId
            ]);
        }
        return fieldsByIds.keySet();
    }
    public static Set < Id > getAllFieldsIdsByTractId(Id farmId, Id contactId) {
        Map < Id, Land__c > fieldsByIds;
        if (contactId != null) {
            system.debug(farmId);
            system.debug(contactId);
            List < Land__c > tractLandRecords = [SELECT Id
                FROM Land__c
                WHERE Parent_ID__c = : farmId
            ];
            system.debug(tractLandRecords);
            List < Authority__c > authorities = [SELECT Id, Associated_Land__c FROM Authority__c WHERE Contact__c = : contactId AND Associated_Land__c IN: tractLandRecords];
            system.debug(authorities);
            List < Id > landIdsWithAuthorities = new List < Id > ();
            for (Authority__c a: authorities) {
                landIdsWithAuthorities.add(a.Associated_Land__c);
            }
            fieldsByIds = new Map < Id, Land__c > ([
                SELECT Id
                FROM Land__c
                WHERE Id IN: landIdsWithAuthorities
            ]);
        } else {
            fieldsByIds = new Map < Id, Land__c > ([
                SELECT Id
                FROM Land__c
                WHERE Parent_ID__c = : farmId
            ]);
        }
        return fieldsByIds.keySet();
    }
    public static Help_Text__c getHelpText() {
        return [
            SELECT Id, Base_Acres__c, Base_Yield_Base_Acres__c, Base_Yield_CCC_505_CRP_Reduction__c, Base_Yield_CTAP_Yield__c,
            Base_Yield_PLC_Yield__c, CCC_505_CRP_Reduction_Acres__c, CRP__c, CRP_Acres__c, CRP_Contract_Numbers__c, CTAP_Yield__c,
            DCP_Cropland__c, Effective_DCP_Cropland__c, GRP__c, Elections__c, GRP_Acres__c, HIP__c, MPL__c, MPL_Acres__c, PLC_Yield__c, Summary_DCP_Cropland__c, Summary_Effective_DCP_Cropland__c,
            WBP__c, WBP_Acres__c, WRP__c, WRP_Acres__c, X3_CM__c
            FROM Help_Text__c
            LIMIT 1
        ];
    }
    public static Header setHeaderValues(Id landId, String type) {
        //Operator will always be on farm level as admin code.
        Land__c land = [
            SELECT Id, State_County_ANSI_Code__c, Admin_State_Code__c,
            Parent_ID__r.State_County_ANSI_Code__c, Parent_ID__r.Admin_State_Code__c,
            Parent_ID__r.Parent_ID__r.State_County_ANSI_Code__c, Parent_ID__r.Parent_ID__r.Admin_State_Code__c, (SELECT Contact__r.Name FROM Authorities__r WHERE Associated_Land__c = : landId AND(Role__c = : OPERATOR_ROLE OR Role__c = : OPERATOR_OWNER_ROLE) LIMIT 1)
            FROM Land__c
            WHERE Id = : landId
        ];
        String countyCode;
        String stateCode;
        if (type == 'farm') {
            countyCode = land.State_County_ANSI_Code__c;
            stateCode = land.Admin_State_Code__c;
        } else if (type == 'tract') {
            countyCode = land.Parent_ID__r.State_County_ANSI_Code__c;
            stateCode = land.Parent_ID__r.Admin_State_Code__c;
        } else if (type == 'field') {
            countyCode = land.Parent_ID__r.Parent_ID__r.State_County_ANSI_Code__c;
            stateCode = land.Parent_ID__r.Parent_ID__r.Admin_State_Code__c;
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c = : countyCode LIMIT 1];
        List < FIPS_State_Code__mdt > states = [SELECT Label FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c = : stateCode LIMIT 1];
        Header h = new Header();
        h.OperatorName = land.Authorities__r.isEmpty() ? '' : land.Authorities__r[0].Contact__r.Name;
        h.County = counties.isEmpty() ? '' : counties[0].Label;
        h.State = states.isEmpty() ? '' : states[0].Label;
        return h;
    }
    public class Header {
        @auraEnabled
        public String OperatorName;
        @auraEnabled
        public String County;
        @auraEnabled
        public String State;
    }
}
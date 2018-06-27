public without sharing class ARCGISMappingSidebarAuraService {
    @TestVisible
    private static final Integer RECORDS_PER_PAGE = 5;
    private static Integer currentPageNumber;
    private static String contactPrefix = Contact.sObjectType.getDescribe().getKeyPrefix();
    private static String landPrefix = Land__c.sObjectType.getDescribe().getKeyPrefix();
    public static Id contactRecordId;
    private static final String OTHER_PRODUCER_ROLE = 'Other Producer';
    private static final String OTHER_TENANT_TRACT_ROLE = 'Other Tenant - Tract';
    private static final String OTHER_TENANT_FIELD_ROLE = 'Other Tenant - Field';
    @auraEnabled
    public static Integer getNumberOfPages(String recordId) {
        if(recordId==null){
            User u = [select id, contactId, IsPortalEnabled from User where id = : UserInfo.getUserId()];         
            if(u.IsPortalEnabled=true)
            {
                recordId=u.contactId;
            }
        }
        if (recordId.startsWith(contactPrefix)) {
            contactRecordId = recordId;
            Map < Id, Land__c > farmsWithRelatedTracts = getFarmsWithRelatedTracts(recordId);
            Set < Id > landIds = new Set < Id > ();
            for (Land__c land: farmsWithRelatedTracts.values()) {
                landIds.add(land.Id);
            }
            Map < Id, String > landMap = getLandAuthorityRoleByLandId(landIds);
            Integer numRecords = landMap.size();
            system.debug(numRecords);
            Integer numberOfPages = numRecords / RECORDS_PER_PAGE;
            if (math.mod(numRecords, RECORDS_PER_PAGE) != 0) {
                numberOfPages++;
            }
            return numberOfPages;
        } else {
            return 1;
        }
    }
    @auraEnabled
    public static List < Farm > getFarms(Integer pageNumber, String recordId) {
        if(recordId==null){
            User u = [select id, contactId, IsPortalEnabled from User where id = : UserInfo.getUserId()];         
            if(u.IsPortalEnabled=true)
            {
                recordId=u.contactId;
            }
        }
        if (recordId.startsWith(contactPrefix)) {
            contactRecordId = recordId;
            currentPageNumber = pageNumber;
            Map < Id, Land__c > farmsWithRelatedTracts = getFarmsWithRelatedTracts(recordId);
            Map < Id, Land__c > tractsByIdsWithRelatedFields = getTractsByIdsWithRelatedFields(farmsWithRelatedTracts.keySet());
            return bindObjects(farmsWithRelatedTracts, tractsByIdsWithRelatedFields);
        } else if (recordId.startsWith(landPrefix)) {
            currentPageNumber = 1;
            Land__c land = [
                SELECT Id, RecordType.Name
                FROM Land__c
                WHERE Id = : recordId
                LIMIT 1
            ];
            if (land.RecordType.Name == 'Farm') {
                Map < Id, Land__c > farm = getFarmWithRelatedTracts(recordId);
                Map < Id, Land__c > tractsByIdsWithRelatedFields = getTractsByIdsWithRelatedFields(farm.keySet());
                return bindObjects(farm, tractsByIdsWithRelatedFields);
            } else if (land.RecordType.Name == 'TRACT') {
                Land__c farm = getParent(land.Id);
                Map < Id, Land__c > farmMap = getFarmWithRelatedTract(farm.Id, land.Id);
                Map < Id, Land__c > tractMap = getTractByIdWithRelatedFields(land.Id);
                return bindObjects(farmMap, tractMap);
            } else if (land.RecordType.Name == 'Field') {
                Land__c tract = getParent(land.Id);
                Land__c farm = getParent(tract.Id);
                Map < Id, Land__c > farmMap = getFarmWithRelatedTract(farm.Id, tract.Id);
                Map < Id, Land__c > tractMap = getTractByIdWithRelatedField(tract.Id, land.Id);
                return bindObjects(farmMap, tractMap);
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
    @auraEnabled
    public static List < Land__c > getAllFarms(String recordId) {
        if (recordId.startsWith(contactPrefix)) {
            Map < Id, Land__c > farmsWithRelatedTracts = getFarmsWithRelatedTracts(recordId);
            return farmsWithRelatedTracts.values();
        } else {
            return null;
        }
    }
    private static Map < Id, Land__c > getFarmsWithRelatedTracts(Id contactId) {
        List<Authority__c> authorities = [SELECT Id, Associated_Land__c FROM Authority__c WHERE Contact__c = :contactId];
        List<Id> landIdsWithAuthorities = new List<Id>();
        for (Authority__c a : authorities) {
            landIdsWithAuthorities.add(a.Associated_Land__c);
        }
        Map < Id, Land__c > landTracts = new Map < Id, Land__c > ([
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, State_County_ANSI_Code__c, Admin_State_Code__c, Land__c, Display__c, 
            (SELECT Id FROM Lands__r Order By State_County_ANSI_Code__c, Tract_Number__c) //tracts
            FROM Land__c
            WHERE RecordType.Name = 'Farm'
            AND Id IN :landIdsWithAuthorities
            ORDER BY State_County_ANSI_Code__c, Farm_Number__c
            //AND Individual__c =: contactId
        ]);
        Set < Id > landIds = new Set < Id > ();
        Set < Id > tractIds = new Set < Id > ();
        Set < String > stateCodes = new Set < String > ();
        Set < String > countyCodes = new Set < String > ();
        for (Land__c land: landTracts.values()) {
            stateCodes.add(land.Admin_State_Code__c);
            countyCodes.add(land.State_County_ANSI_Code__c);
            landIds.add(land.Id);
            for (Land__c landChild: land.Lands__r) {
                tractIds.add(landChild.Id);
                landChild.Display__c = 'display;';
            }
            land.Display__c = 'display;';
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label, FIPS_County_Code__c FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c IN: countyCodes];
        List < FIPS_State_Code__mdt > states = [SELECT Label, FIPS_State_Code__c FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c IN: stateCodes];
        for (FIPS_County_Code__mdt county: counties) {
            for (Land__c land: landTracts.values()) {
                if (county.FIPS_County_Code__c == land.State_County_ANSI_Code__c) {
                    land.Location_State_County_Code_FSA__c = county.Label;
                }
            }
        }
        for (FIPS_State_Code__mdt state: states) {
            for (Land__c land: landTracts.values()) {
                if (state.FIPS_State_Code__c == land.Admin_State_Code__c) {
                    land.Location_State_County_Code_FSA__c += ', ' + state.Label;
                }
            }
        }
        if (contactRecordId != null) {
            Map < Id, String > landAuthorityByLandId = getLandAuthorityRoleByLandId(landIds);
            system.debug(landAuthorityByLandId);
            if (landAuthorityByLandId != null) {
                for (Land__c land: landTracts.values()) {
                    if (landAuthorityByLandId.get(land.Id) != null) {
                        if (landAuthorityByLandId.get(land.Id).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(land.Id).contains(OTHER_TENANT_TRACT_ROLE)) {
                            land.Display__c = 'none;';
                        }
                    }
                    for (Land__c landChild: land.Lands__r) {
                        if (landAuthorityByLandId.get(landChild.Parent_Id__c) != null) {
                            if (landAuthorityByLandId.get(landChild.Parent_Id__c).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(landChild.Parent_Id__c).contains(OTHER_TENANT_TRACT_ROLE)) {
                                landChild.Display__c = 'none;';
                            }
                        }
                    }
                }
            }
        }
        system.debug(landTracts);
        return landTracts;
    }
    private static Map < Id, Land__c > getFarmWithRelatedTracts(Id farmId) {
        Map < Id, Land__c > landTracts = new Map < Id, Land__c > ([
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, State_County_ANSI_Code__c, Admin_State_Code__c, Land__c, Display__c, 
            (SELECT Id, Display__c, Parent_ID__r.Name FROM Lands__r ORDER BY State_County_ANSI_Code__c, Tract_Number__c) //tracts
            FROM Land__c
            WHERE Id = : farmId
            ORDER BY State_County_ANSI_Code__c, Farm_Number__c
        ]);
        Set < Id > farmIds = new Set < Id > ();
        Set < Id > tractIds = new Set < Id > ();
        Set < String > stateCodes = new Set < String > ();
        Set < String > countyCodes = new Set < String > ();
        for (Land__c land: landTracts.values()) {
            stateCodes.add(land.Admin_State_Code__c);
            countyCodes.add(land.State_County_ANSI_Code__c);
            farmIds.add(land.Id);
            for (Land__c landChild: land.Lands__r) {
                tractIds.add(landChild.Id);
                landChild.Display__c = 'display;';
            }
            land.Display__c = 'display;';
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label, FIPS_County_Code__c FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c IN: countyCodes];
        List < FIPS_State_Code__mdt > states = [SELECT Label, FIPS_State_Code__c FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c IN: stateCodes];
        for (FIPS_County_Code__mdt county: counties) {
            for (Land__c land: landTracts.values()) {
                if (county.FIPS_County_Code__c == land.State_County_ANSI_Code__c) {
                    land.Location_State_County_Code_FSA__c = county.Label;
                }
            }
        }
        for (FIPS_State_Code__mdt state: states) {
            for (Land__c land: landTracts.values()) {
                if (state.FIPS_State_Code__c == land.Admin_State_Code__c) {
                    land.Location_State_County_Code_FSA__c += ', ' + state.Label;
                }
            }
        }
        if (contactRecordId != null) {
            Map < Id, String > landAuthorityByLandId = getLandAuthorityRoleByLandId(farmIds);
            if (landAuthorityByLandId != null) {
                for (Land__c land: landTracts.values()) {
                    if (landAuthorityByLandId.get(land.Id) != null) {
                        if (landAuthorityByLandId.get(land.Id).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(land.Id).contains(OTHER_TENANT_TRACT_ROLE)) {
                            land.Display__c = 'none;';
                        }
                    }
                    for (Land__c landChild: land.Lands__r) {
                        if (landAuthorityByLandId.get(landChild.Parent_ID__c) != null) {
                            if (landAuthorityByLandId.get(landChild.Parent_Id__c).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(landChild.Parent_Id__c).contains(OTHER_TENANT_TRACT_ROLE)) {
                                landChild.Display__c = 'none;';
                            }
                        }
                    }
                }
            }
        }
        system.debug(landTracts);
        return landTracts;
    }
    private static Map < Id, Land__c > getFarmWithRelatedTract(Id farmId, Id tractId) {
        Map < Id, Land__c > landTracts = new Map < Id, Land__c > ([
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, State_County_ANSI_Code__c, Admin_State_Code__c, Land__c, Display__c, 
            (SELECT Id, Display__c, Parent_ID__r.Name FROM Lands__r WHERE Id = : tractId ORDER BY State_County_ANSI_Code__c, Tract_Number__c) //tract
            FROM Land__c
            WHERE Id = : farmId
            ORDER BY State_County_ANSI_Code__c, Farm_Number__c
        ]);
        Set < Id > landIds = new Set < Id > ();
        Set < Id > tractIds = new Set < Id > ();
        Set < String > stateCodes = new Set < String > ();
        Set < String > countyCodes = new Set < String > ();
        for (Land__c land: landTracts.values()) {
            stateCodes.add(land.Admin_State_Code__c);
            countyCodes.add(land.State_County_ANSI_Code__c);
            landIds.add(land.Id);
            for (Land__c landChild: land.Lands__r) {
                tractIds.add(landChild.Id);
                landChild.Display__c = 'display;';
            }
            land.Display__c = 'display;';
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label, FIPS_County_Code__c FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c IN: countyCodes];
        List < FIPS_State_Code__mdt > states = [SELECT Label, FIPS_State_Code__c FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c IN: stateCodes];
        for (FIPS_County_Code__mdt county: counties) {
            for (Land__c land: landTracts.values()) {
                if (county.FIPS_County_Code__c == land.State_County_ANSI_Code__c) {
                    land.Location_State_County_Code_FSA__c = county.Label;
                }
            }
        }
        for (FIPS_State_Code__mdt state: states) {
            for (Land__c land: landTracts.values()) {
                if (state.FIPS_State_Code__c == land.Admin_State_Code__c) {
                    land.Location_State_County_Code_FSA__c += ', ' + state.Label;
                }
            }
        }
        if (contactRecordId != null) {
            Map < Id, String > landAuthorityByLandId = getLandAuthorityRoleByLandId(landIds);
            if (landAuthorityByLandId != null) {
                for (Land__c land: landTracts.values()) {
                    if (landAuthorityByLandId.get(land.Id) != null) {
                        if (landAuthorityByLandId.get(land.Id).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(land.Id).contains(OTHER_TENANT_TRACT_ROLE)) {
                            land.Display__c = 'none;';
                        }
                    }
                    for (Land__c landChild: land.Lands__r) {
                        if (landAuthorityByLandId.get(landChild.Parent_ID__c) != null) {
                            if (landAuthorityByLandId.get(landChild.Parent_Id__c).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(landChild.Parent_Id__c).contains(OTHER_TENANT_TRACT_ROLE)) {
                                landChild.Display__c = 'none;';
                            }
                        }
                    }
                }
            }
        }
        system.debug(landTracts);
        return landTracts;
    }
    private static Map < Id, Land__c > getTractsByIdsWithRelatedFields(Set < Id > farmIds) {
        Map < Id, Land__c > landTracts = new Map < Id, Land__c > ([
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Parent_ID__r.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, State_County_ANSI_Code__c, Admin_State_Code__c, Land__c, Display__c, //tract
            (SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Parent_ID__r.Parent_ID__r.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Field_Number__c FROM Lands__r WHERE RecordType.Name = 'Field' ORDER BY State_County_ANSI_Code__c, Field_Number__c) //fields
            FROM Land__c
            WHERE Parent_ID__c IN: farmIds
            AND RecordType.Name = 'TRACT'
            ORDER BY State_County_ANSI_Code__c, Tract_Number__c
        ]);
        Set < Id > landIds = new Set < Id > ();
        Set < Id > fieldIds = new Set < Id > ();
        Set < String > stateCodes = new Set < String > ();
        Set < String > countyCodes = new Set < String > ();
        for (Land__c land: landTracts.values()) {
            stateCodes.add(land.Admin_State_Code__c);
            countyCodes.add(land.State_County_ANSI_Code__c);
            landIds.add(land.Id);
            for (Land__c landChild: land.Lands__r) {
                fieldIds.add(landChild.Id);
                landChild.Display__c = 'display;';
            }
            land.Display__c = 'display;';
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label, FIPS_County_Code__c FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c IN: countyCodes];
        List < FIPS_State_Code__mdt > states = [SELECT Label, FIPS_State_Code__c FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c IN: stateCodes];
        for (FIPS_County_Code__mdt county: counties) {
            for (Land__c land: landTracts.values()) {
                if (county.FIPS_County_Code__c == land.State_County_ANSI_Code__c) {
                    land.Location_State_County_Code_FSA__c = county.Label;
                }
            }
        }
        for (FIPS_State_Code__mdt state: states) {
            for (Land__c land: landTracts.values()) {
                if (state.FIPS_State_Code__c == land.Admin_State_Code__c) {
                    land.Location_State_County_Code_FSA__c += ', ' + state.Label;
                }
            }
        }
        if (contactRecordId != null) {
            Map < Id, String > landAuthorityByLandId = getLandAuthorityRoleByLandId(landIds);
            Map < Id, String > fieldAuthorityByLandId = getLandAuthorityRoleByLandId(fieldIds);
            system.debug(fieldAuthorityByLandId);
            if (landAuthorityByLandId != null) {
                for (Land__c land: landTracts.values()) {
                    if (landAuthorityByLandId.get(land.Id) != null) {
                        if (landAuthorityByLandId.get(land.Id).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(land.Id).contains(OTHER_TENANT_TRACT_ROLE)) {
                            land.Display__c = 'none;';
                        }
                    }
                    system.debug(land.Lands__r);
                    if (fieldAuthorityByLandId != null) {
                        for (Land__c landChild: land.Lands__r) {
                            if (fieldAuthorityByLandId.get(landChild.Id) != null) {
                                landChild.Display__c = 'display;';
                            } else {
                                landChild.Display__c = 'none;';
                            }
                        }
                    }
                }
            }
        }
        system.debug(landTracts);
        return landTracts;
    }
    private static Map < Id, Land__c > getTractByIdWithRelatedFields(Id tractId) {
        Map < Id, Land__c > landTracts = new Map < Id, Land__c > ([
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Parent_ID__r.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, State_County_ANSI_Code__c, Admin_State_Code__c, Land__c, Display__c, //tract
            (SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Parent_ID__r.Parent_ID__r.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Field_Number__c, Display__c FROM Lands__r WHERE RecordType.Name = 'Field'
                AND Parent_ID__c = : tractId ORDER BY State_County_ANSI_Code__c, Field_Number__c) //fields
            FROM Land__c
            WHERE Id = : tractId
            AND RecordType.Name='TRACT'
            ORDER BY State_County_ANSI_Code__c, Tract_Number__c
        ]);
        Set < Id > landIds = new Set < Id > ();
        Set < Id > fieldIds = new Set < Id > ();
        Set < String > stateCodes = new Set < String > ();
        Set < String > countyCodes = new Set < String > ();
        for (Land__c land: landTracts.values()) {
            stateCodes.add(land.Admin_State_Code__c);
            countyCodes.add(land.State_County_ANSI_Code__c);
            landIds.add(land.Id);
            for (Land__c landChild: land.Lands__r) {
                fieldIds.add(landChild.Id);
                landChild.Display__c = 'display;';
            }
            land.Display__c = 'display;';
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label, FIPS_County_Code__c FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c IN: countyCodes];
        List < FIPS_State_Code__mdt > states = [SELECT Label, FIPS_State_Code__c FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c IN: stateCodes];
        for (FIPS_County_Code__mdt county: counties) {
            for (Land__c land: landTracts.values()) {
                if (county.FIPS_County_Code__c == land.State_County_ANSI_Code__c) {
                    land.Location_State_County_Code_FSA__c = county.Label;
                }
            }
        }
        for (FIPS_State_Code__mdt state: states) {
            for (Land__c land: landTracts.values()) {
                if (state.FIPS_State_Code__c == land.Admin_State_Code__c) {
                    land.Location_State_County_Code_FSA__c += ', ' + state.Label;
                }
            }
        }
        if (contactRecordId != null) {
            Map < Id, String > landAuthorityByLandId = getLandAuthorityRoleByLandId(landIds);
            Map < Id, String > fieldAuthorityByLandId = getLandAuthorityRoleByLandId(fieldIds);
            if (landAuthorityByLandId != null) {
                for (Land__c land: landTracts.values()) {
                    if (landAuthorityByLandId.get(land.Id) != null) {
                        if (landAuthorityByLandId.get(land.Id).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(land.Id).contains(OTHER_TENANT_TRACT_ROLE)) {
                            land.Display__c = 'none;';
                        }
                    }
                    if (fieldAuthorityByLandId != null) {
                        for (Land__c landChild: land.Lands__r) {
                            if (fieldAuthorityByLandId.get(landChild.Id) != null) {
                                landChild.Display__c = 'display;';
                            } else {
                                landChild.Display__c = 'none;';
                            }
                        }
                    }
                }
            }
        }
        system.debug(landTracts);
        return landTracts;
    }
    private static Map < Id, Land__c > getTractByIdWithRelatedField(Id tractId, Id fieldId) {
        Map < Id, Land__c > landTracts = new Map < Id, Land__c > ([
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Parent_ID__r.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, State_County_ANSI_Code__c, Admin_State_Code__c, Land__c, Display__c, //tract
            (SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Parent_ID__r.Parent_ID__r.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Field_Number__c, Display__c FROM Lands__r WHERE Id = : fieldId ORDER BY State_County_ANSI_Code__c, Field_Number__c) //fields
            FROM Land__c
            WHERE Id = : tractId
            AND RecordType.Name='TRACT'
            ORDER BY State_County_ANSI_Code__c, Tract_Number__c
        ]);
        Set < String > stateCodes = new Set < String > ();
        Set < String > countyCodes = new Set < String > ();
        Set < Id > tractIds = new Set < Id > ();
        Set < Id > fieldIds = new Set < Id > ();
        for (Land__c land: landTracts.values()) {
            stateCodes.add(land.Admin_State_Code__c);
            countyCodes.add(land.State_County_ANSI_Code__c);
            tractIds.add(land.Id);
            for (Land__c landChild: land.Lands__r) {
                fieldIds.add(landChild.Id);
            }
            land.Display__c = 'display;';
        }
        List < FIPS_County_Code__mdt > counties = [SELECT Label, FIPS_County_Code__c FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c IN: countyCodes];
        List < FIPS_State_Code__mdt > states = [SELECT Label, FIPS_State_Code__c FROM FIPS_State_Code__mdt WHERE FIPS_State_Code__c IN: stateCodes];
        for (FIPS_County_Code__mdt county: counties) {
            for (Land__c land: landTracts.values()) {
                if (county.FIPS_County_Code__c == land.State_County_ANSI_Code__c) {
                    land.Location_State_County_Code_FSA__c = county.Label;
                }
            }
        }
        for (FIPS_State_Code__mdt state: states) {
            for (Land__c land: landTracts.values()) {
                if (state.FIPS_State_Code__c == land.Admin_State_Code__c) {
                    land.Location_State_County_Code_FSA__c += ', ' + state.Label;
                }
            }
        }
        if (contactRecordId != null) {
            Map < Id, String > landAuthorityByLandId = getLandAuthorityRoleByLandId(tractIds);
            Map < Id, String > fieldAuthorityByLandId = getLandAuthorityRoleByLandId(fieldIds);
            if (landAuthorityByLandId != null) {
                for (Land__c land: landTracts.values()) {
                    if (landAuthorityByLandId.get(land.Id).contains(OTHER_PRODUCER_ROLE) || landAuthorityByLandId.get(land.Id).contains(OTHER_TENANT_TRACT_ROLE)) {
                        land.Display__c = 'none;';
                    } else if (landAuthorityByLandId.get(land.Id) != null) {
                        land.Display__c = 'display;';
                    }
                    if (fieldAuthorityByLandId != null) {
                        for (Land__c landChild: land.Lands__r) {
                            if (fieldAuthorityByLandId.get(landChild.Id) != null) {
                                landChild.Display__c = 'display;';
                            } else {
                                landChild.Display__c = 'none;';
                            }
                        }
                    }
                }
            }
        }
        system.debug(landTracts);
        return landTracts;
    }
    private static Land__c getParent(Id childId) {
        String parentId = [SELECT Parent_ID__c FROM Land__c WHERE Id = : childId LIMIT 1][0].Parent_ID__c;
        return [
            SELECT Id, Name, Owner.Name, Farm_Number__c, Dashed_Farm_Number__c, Tract_Number__c, Location_State_County_Code_FSA__c, Farmland_Acres__c, Cropland_Acres__c, DCP_Cropland_Acres__c, Parent_ID__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Field_Number__c
            FROM Land__c
            WHERE Id = : parentId
            LIMIT 1
        ];
    }
    private static List < Farm > bindObjects(Map < Id, Land__c > farmsByIdsWithTracts, Map < Id, Land__c > tractsByIdsWithFields) {
        List < Farm > farms = new List < Farm > ();
        Integer offset = (RECORDS_PER_PAGE * Integer.valueOf(currentPageNumber)) - RECORDS_PER_PAGE;
        Set < Id > farmIds = new Set < Id > ();
        Set < Id > tractIds = new Set < Id > ();
        Set < Id > fieldIds = new Set < Id > ();
        for (Land__c farm: farmsByIdsWithTracts.values()) {
            farmIds.add(farm.Id);
            for (Land__c tract: farm.Lands__r) {
                tract = tractsByIdsWithFields.get(tract.Id);
                if (tract != null) {
                    tractIds.add(tract.Id);
                    for (Land__c field: tract.Lands__r) {
                        fieldIds.add(field.Id);
                    }
                }
            }
        }
        Map < Id, String > farmOwnerByAuthority = getLandOperatorByLandId(farmIds);
        Map < Id, String > tractOwnerByAuthority = getLandOperatorByLandId(tractIds);
        if (contactRecordId != null) {
            system.debug('bindObjects');
            Map < Id, String > farmAuthorityByLandId = getLandAuthorityRoleByLandId(farmIds);
            system.debug(farmAuthorityByLandId);
            system.debug(farmOwnerByAuthority);
            Map < Id, String > tractAuthorityByLandId = getLandAuthorityRoleByLandId(tractIds);
            system.debug(tractAuthorityByLandId);
            system.debug(fieldIds);
            Map < Id, String > fieldAuthorityByLandId = getLandAuthorityRoleByLandId(fieldIds);
            system.debug(fieldAuthorityByLandId);
            if (farmAuthorityByLandId != null) {
                Integer farmNumber = 1;
                for (Land__c farm: farmsByIdsWithTracts.values()) {
                    if (farmAuthorityByLandId.get(farm.Id) != null) {
                        Farm farmWrapper = new Farm();
                        farmWrapper.record = farm;
                        farmWrapper.operatorName = farmOwnerByAuthority.get(farm.Id);
                        farmWrapper.farmNumber = farmNumber;
                        farmNumber++;
                        if (tractAuthorityByLandId != null) {
                            for (Land__c tract: farm.Lands__r) {
                                if (tractAuthorityByLandId.get(tract.Id) != null) {
                                    tract = tractsByIdsWithFields.get(tract.Id);
                                    if (tract != null) {
                                        Tract tractWrapper = new Tract();
                                        tractWrapper.record = tract;
                                        if (tractOwnerByAuthority != null) {
                                            tractWrapper.operatorName = tractOwnerByAuthority.get(tract.Id);
                                        } else {
                                            tractWrapper.operatorName = tract.FarmOperator__c;
                                        }
                                        if (fieldAuthorityByLandId != null) {
                                            for (Land__c field: tract.Lands__r) {
                                                if (fieldAuthorityByLandId.get(field.Id) != null) {
                                                    Field fieldWrapper = new Field();
                                                    fieldWrapper.record = field;
                                                    tractWrapper.fields.add(fieldWrapper);
                                                }
                                            }
                                        }
                                        farmWrapper.tracts.add(tractWrapper);
                                    }
                                }
                            }
                        }
                        if ((Integer.valueOf(farmWrapper.farmNumber) > Integer.valueOf(offset) && Integer.valueOf(currentPageNumber) > 1) || (Integer.valueOf(farmWrapper.farmNumber) <= RECORDS_PER_PAGE && Integer.valueOf(currentPageNumber) == 1)) {
                            farms.add(farmWrapper);
                        }
                    }
                }
            }
            system.debug(farms);
            return farms;
        } else {
            Integer farmNumber = 1;
            for (Land__c farm: farmsByIdsWithTracts.values()) {
                Farm farmWrapper = new Farm();
                farmWrapper.record = farm;
                if (farmOwnerByAuthority != null) {
                    farmWrapper.operatorName = farmOwnerByAuthority.get(farm.Id);
                } else {
                    farmWrapper.operatorName = farm.FarmOperator__c;
                }
                farmWrapper.farmNumber = farmNumber;
                farmNumber++;
                for (Land__c tract: farm.Lands__r) {
                    tract = tractsByIdsWithFields.get(tract.Id);
                    Tract tractWrapper = new Tract();
                    tractWrapper.record = tract;
                    if (tractOwnerByAuthority != null) {
                        tractWrapper.operatorName = tractOwnerByAuthority.get(tract.Id);
                    } else {
                        tractWrapper.operatorName = tract.FarmOperator__c;
                    }
                    if (tract != null) {
                        for (Land__c field: tract.Lands__r) {
                            Field fieldWrapper = new Field();
                            fieldWrapper.record = field;
                            tractWrapper.fields.add(fieldWrapper);
                        }
                    }
                    farmWrapper.tracts.add(tractWrapper);
                }
                if ((Integer.valueOf(farmWrapper.farmNumber) > Integer.valueOf(offset) && Integer.valueOf(currentPageNumber) > 1) || (Integer.valueOf(farmWrapper.farmNumber) <= RECORDS_PER_PAGE && Integer.valueOf(currentPageNumber) == 1)) {
                    farms.add(farmWrapper);
                }
            }
            return farms;
        }
    }
    private static Map < Id, String > getLandAuthorityRoleByLandId(Set < Id > landIds) {
        Map < Id, String > authorityMap = new Map < Id, String > ();
        List < Authority__c > authorities = [
            SELECT Associated_Land__c, Role__c
            FROM Authority__c
            WHERE(Contact__c = : contactRecordId)
            AND Contact__c != null
            AND Associated_Land__c IN: landIds
        ];
        for (Authority__c auth: authorities) {
            authorityMap.put(auth.Associated_Land__c, auth.Role__c);
        }
        if (authorityMap.isEmpty()) {
            return null;
        } else {
            return authorityMap;
        }
    }
    private static Map < Id, String > getLandOperatorByLandId(Set < Id > landIds) {
        Map < Id, String > authorityMap = new Map < Id, String > ();
        List < Authority__c > authorities = [
            SELECT Associated_Land__c, Contact__r.Name
            FROM Authority__c
            WHERE Associated_Land__c IN: landIds  AND Role__c='Operator'
        ];
        for (Authority__c auth: authorities) {
            authorityMap.put(auth.Associated_Land__c, auth.Contact__r.Name);
        }
        system.debug(authorityMap);
        if (authorityMap.isEmpty()) {
            return null;
        } else {
            return authorityMap;
        }
    }
    public class Farm {
        @auraEnabled
        public Land__c record;
        @auraEnabled
        public Integer farmNumber;
        @auraEnabled
        public String operatorName;
        @auraEnabled
        public List < Tract > tracts = new List < Tract > ();
    }
    public class Tract {
        @auraEnabled
        public Land__c record;
        @auraEnabled
        public String operatorName;
        @auraEnabled
        public List < Field > fields = new List < Field > ();
    }
    public class Field {
        @auraEnabled
        public Land__c record;
    }
}
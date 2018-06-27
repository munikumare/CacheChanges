public class AuthorityTriggerHelper {

  public static void newSharingRecord(List<Authority__c> authorities) {
    List<Land__Share> sharingRecordsToInsert = new List<Land__Share>();

    List<String> contactIds = new List<String>();
    for (Authority__c authority : authorities) {
      contactIds.add(authority.Contact__c);
    }

    List<User> users = [
      SELECT Id, ContactId
      FROM User
      WHERE ContactId IN :contactIds
    ];

    Map<String, String> contactIdToUserId = new Map<String, String>();
    for (User user : users) {
      if (user.ContactId != null) {
        contactIdToUserId.put(user.ContactId, user.Id);
      }
    }

    for (Authority__c authority : authorities) {
      if (contactIdToUserId.containsKey(authority.Contact__c)) {
        Land__Share sharingRecord  = new Land__Share();
        sharingRecord.ParentId = authority.Associated_Land__c;
        sharingRecord.UserOrGroupId = contactIdToUserId.get(authority.Contact__c);
        sharingRecord.AccessLevel = 'Read';
        if (authority.Role__c == 'Owner') {
          sharingRecord.RowCause = Schema.Land__Share.RowCause.Owner__c;
        } else if (authority.Role__c == 'Operator') {
          sharingRecord.RowCause = Schema.Land__Share.RowCause.Operator__c;
        } else if (authority.Role__c == 'Other Producer') {
          sharingRecord.RowCause = Schema.Land__Share.RowCause.Other_Producer__c;
        } else {
          sharingRecord.RowCause = Schema.Land__Share.RowCause.Other_Tenant__c;
        }
        sharingRecordsToInsert.add(sharingRecord);
      }
    }
    if (!sharingRecordsToInsert.isEmpty()) {
      Database.insert(sharingRecordsToInsert,false);
    }
  }

  public static void updateSharingRecord(List<Authority__c> oldAuthorities, Map<Id, Authority__c> newAuthorities) {

    List<Land__Share> sharingRecordsToDelete = new List<Land__Share>();
    List<Authority__c> authorityRecordsWithoutSharingRecords = new List<Authority__c>();

    Set<String> contactIds = new Set<String>();
    for (Authority__c authority : oldAuthorities) {
      contactIds.add(authority.Contact__c);
    }

    List<User> users = [
      SELECT Id, ContactId
      FROM User
      WHERE ContactId IN :contactIds
    ];
    List<String> userIds = new List<String>();
    for (User user : users) {
      userIds.add(user.Id);
    }

    Map<String, String> contactIdToUserId = new Map<String, String>();
    for (User user : users) {
      if (user.ContactId != null) {
        contactIdToUserId.put(user.ContactId, user.Id);
      }
    }

    Set<String> landIds = new Set<String>();
    for (Authority__c authority : oldAuthorities) {
      landIds.add(authority.Associated_Land__c);
    }

    List<Land__Share> sharingRecords = [
      SELECT Id, ParentId, UserOrGroupId
      FROM Land__Share
      WHERE ParentId IN :landIds
      AND UserOrGroupId IN :userIds
      AND (
        RowCause = 'Owner__c'
        OR RowCause = 'Other_Tenant__c'
        OR RowCause = 'Other_Producer__c'
        OR RowCause = 'Operator__c'
      )
    ];

    for (Authority__c oldAuthority : oldAuthorities) {

      Authority__c newAuthority = newAuthorities.get(oldAuthority.Id);

      for (Land__Share sharingRecord : sharingRecords) {
        if (sharingRecord.ParentId == oldAuthority.Associated_Land__c && sharingRecord.UserOrGroupId == contactIdToUserId.get(oldAuthority.Contact__c)) {
          sharingRecordsToDelete.add(sharingRecord);
          break;
        }
      }
    }
    if (!sharingRecordsToDelete.isEmpty()) {
      Database.delete(sharingRecordsToDelete, false);
    }
    newSharingRecord(newAuthorities.values());
  }

  public static void removeSharingRecord(List<Authority__c> authorities) {
    Map<Id, Land__Share> sharingRecordsToRemove = new Map<Id, Land__Share>();

    List<String> contactIds = new List<String>();
    for (Authority__c authority : authorities) {
      contactIds.add(authority.Contact__c);
    }
    List<User> users = [
      SELECT Id, ContactId
      FROM User
      WHERE ContactId IN :contactIds
    ];
    List<String> userIds = new List<String>();
    for (User user : users) {
      userIds.add(user.Id);
    }

    List<String> landIds = new List<String>();
    for (Authority__c authority : authorities) {
      landIds.add(authority.Associated_Land__c);
    }
    List<Land__c> lands = [
      SELECT Id
      FROM Land__c
      WHERE Id IN :landIds
    ];

    if (!users.isEmpty() && !lands.isEmpty()) {

      List<Land__Share> sharingRecords = [
        SELECT Id, ParentId, UserOrGroupId
        FROM Land__Share
        WHERE ParentId IN :landIds
        AND UserOrGroupId IN :userIds
        AND (
          RowCause = 'Owner__c'
          OR RowCause = 'Other_Tenant__c'
          OR RowCause = 'Other_Producer__c'
          OR RowCause = 'Operator__c'
        )
      ];

      Map<String, String> contactIdToUserId = new Map<String, String>();
      for (User user : users) {
        if (user.ContactId != null) {
          contactIdToUserId.put(user.ContactId, user.Id);
        }
      }

      for (Authority__c authority : authorities) {
        if (contactIdToUserId.containsKey(authority.Contact__c)) {
          for (Land__Share sharingRecord : sharingRecords) {
            if (contactIdToUserId.get(authority.Contact__c) == sharingRecord.UserOrGroupId && authority.Associated_Land__c == sharingRecord.ParentId) {
              sharingRecordsToRemove.put(sharingRecord.Id, sharingRecord);
              break;
            }
          }
        }
      }

      if (!sharingRecordsToRemove.isEmpty()) {
        delete sharingRecordsToRemove.values();
      }
    }
  }

}
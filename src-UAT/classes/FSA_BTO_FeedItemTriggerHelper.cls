public class FSA_BTO_FeedItemTriggerHelper {

    public static void shareFeedContent(List < FeedItem > feedItems) {
        Id profileId = UserInfo.getProfileId();
        Profile profile = [SELECT Name FROM Profile WHERE id =: profileId];

        if (!profile.Name.equals('Content Partner Community Login User') && !profile.Name.equals('FSA BTO Super Partner')) {
            Set < Id > contentVersionIds = new Set < Id > ();

            for (FeedItem fi: feedItems) {
                if (fi.Type == 'ContentPost') {
                    contentVersionIds.add(fi.RelatedRecordId);
                }
                System.debug('contentVersionIds: ' + contentVersionIds);
            }

            if (!contentVersionIds.isEmpty()) {
                List < ContentDistribution > cds = [SELECT Id, ContentVersionId FROM ContentDistribution WHERE ContentVersionId IN: contentVersionIds];
                Map < Id, Id > FeedItemRelatedRecordCDMap = new Map < Id, Id > ();
                for (ContentDistribution cd: cds) {
                    FeedItemRelatedRecordCDMap.put(cd.ContentVersionId, cd.Id);
                }
                system.debug(FeedItemRelatedRecordCDMap);
                List < ContentDistribution > insertCDs = new List < ContentDistribution > ();
                for (FeedItem fi: feedItems) {
                    if (fi.Type == 'ContentPost' && !FeedItemRelatedRecordCDMap.containsKey(fi.RelatedRecordId)) {
                        ContentDistribution newCD = new ContentDistribution();
                        newCD.Name = fi.Title;
                        newCD.ContentVersionId = fi.RelatedRecordId;
                        newCD.PreferencesAllowOriginalDownload = true;
                        newCD.PreferencesAllowPDFDownload = true;
                        newCD.PreferencesAllowViewInBrowser = true;
                        newCD.PreferencesLinkLatestVersion = true;
                        newCD.PreferencesNotifyOnVisit = true;
                        insertCDs.add(newCD);
                    }
                }
                if(!insertCDs.isEmpty()){
                	insert insertCDs;
                }
            }
        }
    }

    public static void shareFeedItemOnReferals(List<FeedItem> feedItems){
    	for(FeedItem fi: feedItems) {
	        if(String.valueOf(fi.ParentId).substring(0,3) == Task.SObjectType.getDescribe().getKeyPrefix() ) {
	            fi.Visibility = 'AllUsers';
	        }
	    }
    }
}
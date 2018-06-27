global class FSA_BTO_AssociatedContentController
{
private final Case c;

public List<CaseArticle> caseArticles
{
 get
        {return [SELECT KnowledgeArticleId
                            FROM CaseArticle
                            WHERE CaseId =: c.Id];
        }
set;
}

public List<SObject> caseResources{
get{
List<SObject> attachedResources = new List<SObject>();
List<SObject> toAdd = new List<SObject>();
toAdd = [SELECT FSA_BTO_Contact__c from FSA_BTO_Case_Contact__c where FSA_BTO_Case__c =: c.Id];
attachedResources.addAll(toAdd);
toAdd = [Select Id from FSA_BTO_Case_Content_Distribution__c where Case__c =: c.Id];
attachedResources.addAll(toAdd);
toAdd = [Select Id from FSA_BTO_Case_Event_Info__c where FSA_BTO_Case__c =: c.Id];
attachedResources.addAll(toAdd);
toAdd = [Select Id from FSA_BTO_Case_Link__c where FSA_BTO_Case__c =: c.Id];
attachedResources.addAll(toAdd);
System.debug(toAdd);
return attachedResources;
}

set;
}

 public FSA_BTO_AssociatedContentController(ApexPages.StandardController stdController)
 {
  this.c = (Case)stdController.getRecord();
 }

 @RemoteAction
 global static Boolean CreateNewAssociatedContent(String chosenName, String caseId, String contentVersionId){
        List<ContentDistribution> cd = [SELECT Name, Id, DistributionPublicUrl From ContentDistribution where ContentVersionId = :contentVersionId limit 1];
        FSA_BTO_Case_Content_Distribution__c newRecord = new FSA_BTO_Case_Content_Distribution__c();
        newRecord.Content_Name__c = chosenName;
        newRecord.Content_URL__c = cd[0].DistributionPublicUrl;
        newRecord.Case__c = caseId;
        insert newRecord;
        return true;
 }
 
 
}
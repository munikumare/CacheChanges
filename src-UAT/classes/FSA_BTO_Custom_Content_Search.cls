public with sharing class FSA_BTO_Custom_Content_Search{

    public void newCaseLink(){
        String chosenName = Apexpages.currentPage().getParameters().get('chosenName');
        String chosenUrl = Apexpages.currentPage().getParameters().get('chosenUrl'); 
        FSA_BTO_Case_Content_Distribution__c newRecord = new FSA_BTO_Case_Content_Distribution__c();
        newRecord.Content_Name__c = chosenName;
        newRecord.Content_URL__c = chosenUrl;
        String relatedCase = ApexPages.currentPage().getParameters().get('case');
        newRecord.Case__c = relatedCase;
        insert newRecord;
     }

  public List<ContentDistribution> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  
  public FSA_BTO_Custom_Content_Search() {
    //account = new Account();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }
   
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
  
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);
    for(Integer i = 0; i < results.size(); i++){
    if(String.isBlank(results.get(i).DistributionPublicUrl)){
    results.remove(i);
    }
    }               
  } 
  
  // run the search and return the records found. 
  private List<ContentDistribution> performSearch(string searchString) {

    String soql = 'select id, name, DistributionPublicUrl, ContentVersion.Description from ContentDistribution';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }
        
}
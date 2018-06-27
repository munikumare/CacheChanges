public with sharing class FSA_BTO_ContactSearchController {
    
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of contacts to display
  public List<Contact> contacts {get;set;}

  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }

  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
    set;
  }

  /* // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }*/

  // init the controller and display some sample data when the page loads
  public FSA_BTO_ContactSearchController() {
    soql = 'select name, firstname, lastname, phone, email, account.name, account.id, FSA_BTO_Crops_Planted__c, FSA_BTO_Partner__c from contact where FSA_BTO_Partner__c=false and lastname != null';
    runQuery();
  }

  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }

  // runs the actual query
  public void runQuery() {

    try {
      contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The query failed due to an incorrect parameter. ' +
          '{soql : ' + soql + ', ' + 'sortField : ' + sortField + ', ' + 'sortDir : ' + sortDir + '}'));
    }

  }

  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {

    String searchString = Apexpages.currentPage().getParameters().get('searchString');
    //String lastName = Apexpages.currentPage().getParameters().get('lastname');
    //String accountName = Apexpages.currentPage().getParameters().get('accountName');

    soql = 'select name, firstname, lastname, phone, email, account.name, account.id, FSA_BTO_Crops_Planted__c, RecordType.Name from contact where RecordType.Name=\'FSA BTO Customer\' and lastname != null' +
                ' and (name LIKE \''+String.escapeSingleQuotes(searchString)+'%\'' +
                ' or lastname LIKE \''+String.escapeSingleQuotes(searchString)+'%\'' +
                ' or firstname LIKE \'' + String.escapeSingleQuotes(searchString) + '%\'' +
                ' or phone LIKE \'' + String.escapeSingleQuotes(searchString) + '%\'' +
                ' or FSA_BTO_Crops_Planted__c INCLUDES (\'' + String.escapeSingleQuotes(searchString) + '%\')' +
                ' or account.name LIKE \'' + String.escapeSingleQuotes(searchString) + '%\'' +
                ' or email LIKE \'' + String.escapeSingleQuotes(searchString) + '%\'' + ')';

    // run the query again
    runQuery();

    return null;
  }



}
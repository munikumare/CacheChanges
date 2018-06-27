public class FSA_BTO_CoveoSearchController {

    public String MainPageQuery {
    get{FSA_BTO_Coveo_Secret__c coveoSecret = FSA_BTO_Coveo_Secret__c.getInstance();
        return String.valueOf(coveoSecret.FSA_BTO_Environment_Specific_Query__c);}
    
    set;
    }

    public String UsesOnPremise {
     get{
        FSA_BTO_Coveo_Secret__c coveoSecret = FSA_BTO_Coveo_Secret__c.getInstance();
        return String.valueOf(coveoSecret.FSA_BTO_CoveoOnPremise__c);
     }
    
     set; }

    public FSA_BTO_CoveoSearchController() {

    }
  
  public FSA_BTO_CoveoSearchController(ApexPages.StandardController stdController) {}
  
  class UserId{
    public String name {get; set;}
    public String provider {get; set;}
    public String type {get; set;}
    public UserId(String name, String provider, String type){
        this.name = name;
        this.provider = provider;
        this.type = type;
    }
  }
  
  class TokenResponse {
    public String token;
  }
  
  public String getContext(){
    FSA_BTO_Coveo_Secret__c coveoSecret = FSA_BTO_Coveo_Secret__c.getInstance();
    if(!coveoSecret.FSA_BTO_CoveoOnPremise__c && !Test.isRunningTest()){
    return '';
    }
    HttpRequest req = new HttpRequest();
    System.Debug('Endpoint ' + coveoSecret.FSA_BTO_Coveo_URL__c);
    req.setEndpoint(coveoSecret.FSA_BTO_Coveo_URL__c + '/rest/search/token');
    
    req.setMethod('POST');
    if(!Test.isRunningTest()){
    req.setHeader('Authorization', 'Bearer ' + coveoSecret.Secret_Value__c);
    System.Debug('Bearer ' + coveoSecret.Secret_Value__c);
    }
    req.setHeader('Content-Type', 'application/json');
     
    List<UserId> userIds = new List<UserId>();
    userIds.add(new UserId(UserInfo.getUserEmail(), 'Email Security Provider', 'User'));
     
    Map<String,Object> body = new Map<String, Object>();
    body.put('userIds', userIds);
    req.setBody(JSON.serialize(body));
     
    req.setTimeout(10000);
     
    Http http = new Http();
    HTTPResponse res = new HTTPResponse();

    res = http.send(req);

    String token = ((TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class)).token;

    return token;

  }
}
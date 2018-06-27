/*
res.getBody():
{
    "size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"CustomField","records":[{
        "attributes":{
            "type":"CustomField","url":"/services/data/v34.0/tooling/sobjects/CustomField/00Nr0000000GrveEAC"
        },
        "Id":"00Nr0000000GrveEAC","DeveloperName":"FSA_BTO_Survey"
    }]
}
*/
public class FSA_BTO_RetrieveFieldParser {
    public Integer size;
    public Integer totalSize;
    public boolean done;
    public QueryLocator queryLocator;
    public String entityTypeName;
    public retrieveFieldAttributes[] records;
    
    public class QueryLocator {
    }
    
    public class retrieveFieldAttributes {
        public Attributes attributes;
        public String Id;
        public String DeveloperName;
    }
    
    public class Attributes {
        public String type;
        public String url;
    }
}
public class FSA_BTO_CBSCounty{

    public String officeName { get; set; }
    public String officeCode { get; set; }
    public String phone { get; set; }
    public String pStreet {get; set;}
    public String pCity { get; set; }
    public String pState { get; set; }
    public String pZip { get; set; }
    public String mailingStreet { get; set; }
    public String mailingCity { get; set; }
    //public String mailingState { get; set; }
    public String mailingZip { get; set; }
    public FSA_BTO_County__c countyRecord;
    public List<FSA_BTO_County__c> toReturn { get; set;}

    public FSA_BTO_CBSCounty(DOM.XMLNode countyXmlString){
        toReturn = new List<FSA_BTO_County__c>();   
        for(Dom.XmlNode countyOfficeEntry: countyXmlString.getChildElements()){
            //System.debug(countyOfficeEntry.getName());
            if(countyOfficeEntry.getName()== 'errorMessages'){
                String errors;
                List<Dom.XmlNode> messages = countyOfficeEntry.getChildren();
                for(Dom.XmlNode node: messages){
                    List<Dom.XmlNode> lines = node.getChildren();
                    for(Dom.XmlNode line: lines){
                        errors += line.getText() + ' ';
                    }
                }
                System.debug(errors);
                
            }
            else if(countyOfficeEntry.getName() == 'office'){
                for(Dom.XmlNode countyOfficeChildNode: countyOfficeEntry.getChildElements()) {
                    if(countyOfficeChildNode.getName() == 'Name') {
                        officeName = countyOfficeChildNode.getText().trim();
                        //System.debug(officeName);
                    }
                    else if(countyOfficeChildNode.getName() == 'officeCode') {
                        officeCode = countyOfficeChildNode.getText().trim();
                    //System.debug(officeCode);
                    }
                    if(countyOfficeChildNode.getName() == 'sitePhoneNbr') {
                        phone = countyOfficeChildNode.getText().trim();   
                    }
                    else if(countyOfficeChildNode.getName() == 'locStreetAddr') {
                        pStreet = countyOfficeChildNode.getText().trim();
                    }
                    else if(countyOfficeChildNode.getName() == 'locCityName') {
                        pCity = countyOfficeChildNode.getText().trim();
                    }
                    else if(countyOfficeChildNode.getName() == 'stateAbbrev') {
                        pState = countyOfficeChildNode.getText().trim();
                    }
                    else if(countyOfficeChildNode.getName() == 'zipCode') {
                        pZip = countyOfficeChildNode.getText().trim();
                    }
                    else if(countyOfficeChildNode.getName() == 'mailingAddrLine') {
                        mailingStreet = countyOfficeChildNode.getText().trim();
                    }
                    else if(countyOfficeChildNode.getName() == 'mailingCity') {
                        mailingCity = countyOfficeChildNode.getText().trim();
                    }
                    else if(countyOfficeChildNode.getName() == 'mailingZipCode') {
                        mailingZip = countyOfficeChildNode.getText().trim();
                    }
                }        
            
                List<FSA_BTO_County__c> results = [Select Name, FSA_BTO_FIPS_Code__c, FSA_BTO_StreetAddress__c, FSA_BTO_City__c, FSA_BTO_State__c, FSA_BTO_Zip_Code__c from FSA_BTO_County__c where FSA_BTO_FIPS_Code__c = :officeCode];
                if(results.size()>0){
                    countyRecord = results[0];
                    countyRecord.Name = officeName;
                    countyRecord.FSA_BTO_StreetAddress__c = mailingStreet;
                    countyRecord.FSA_BTO_City__c = mailingCity;
                    countyRecord.FSA_BTO_State__c = pState;
                    countyRecord.FSA_BTO_Zip_Code__c = mailingZip;
                    countyRecord.FSA_BTO_StreetAddress_Physical__c = pStreet;
                    countyRecord.FSA_BTO_City_Physical__c = pCity;
                    countyRecord.FSA_BTO_State_Physical__c = pState;
                    countyRecord.FSA_BTO_Zip_Code_Physical__c = pZip;
                    countyRecord.FSA_BTO_Phone__c = phone;
                    //update countyRecord;
                    toReturn.add(countyRecord);
                } else {
                    countyRecord = new FSA_BTO_County__c();
                    countyRecord.Name = officeName;
                    countyRecord.FSA_BTO_FIPS_Code__c = officeCode;
                    countyRecord.FSA_BTO_StreetAddress__c = mailingStreet;
                    countyRecord.FSA_BTO_City__c = mailingCity;
                    countyRecord.FSA_BTO_State__c = pState;
                    countyRecord.FSA_BTO_Zip_Code__c = mailingZip;
                    countyRecord.FSA_BTO_StreetAddress_Physical__c = pStreet;
                    countyRecord.FSA_BTO_City_Physical__c = pCity;
                    countyRecord.FSA_BTO_State_Physical__c = pState;
                    countyRecord.FSA_BTO_Zip_Code_Physical__c = pZip;
                    countyRecord.FSA_BTO_Phone__c = phone;
                    if(!String.isEmpty(countyRecord.FSA_BTO_FIPS_Code__c)){
                        //insert countyRecord;                      
                    } else {
                        toReturn.add(countyRecord);
                    }
                }
            }
        }
        try {
        upsert toReturn;
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

    }
    
    
}
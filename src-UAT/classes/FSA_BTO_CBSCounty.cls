public class FSA_BTO_CBSCounty {

    public String officeName {get;set;}
    public String officeCode {get;set;}
    public String phone {get;set;}
    public String pStreet {get;set;}
    public String pCity {get;set;}
    public String pState {get;set;}
    public String pZip {get;set;}
    public String mailingStreet {get;set;}
    public String mailingCity {get;set;}
    //public String mailingState { get; set; }
    public String mailingZip {get;set;}
    public FSA_BTO_County__c countyRecord;
    public List < FSA_BTO_County__c > toReturn {get;set;}

    public FSA_BTO_CBSCounty(DOM.XMLNode countyXmlString) {
        Map < String, List < String >> officeCodeOficeAddressMap = new Map < String, List < String >> ();
        toReturn = new List < FSA_BTO_County__c > ();
        for (Dom.XmlNode countyOfficeEntry: countyXmlString.getChildElements()) {
            //System.debug(countyOfficeEntry.getName());
            if (countyOfficeEntry.getName() == 'errorMessages') {
                String errors;
                List < Dom.XmlNode > messages = countyOfficeEntry.getChildren();
                for (Dom.XmlNode node: messages) {
                    List < Dom.XmlNode > lines = node.getChildren();
                    for (Dom.XmlNode line: lines) {
                        errors += line.getText() + ' ';
                    }
                }
                System.debug(errors);

            } else if (countyOfficeEntry.getName() == 'office') {
                for (Dom.XmlNode countyOfficeChildNode: countyOfficeEntry.getChildElements()) {
                    if (countyOfficeChildNode.getName() == 'Name') {
                        officeName = countyOfficeChildNode.getText().trim();
                        //System.debug(officeName);
                    } else if (countyOfficeChildNode.getName() == 'officeCode') {
                        officeCode = countyOfficeChildNode.getText().trim();
                        //System.debug(officeCode);
                    }
                    if (countyOfficeChildNode.getName() == 'sitePhoneNbr') {
                        phone = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'locStreetAddr') {
                        pStreet = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'locCityName') {
                        pCity = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'stateAbbrev') {
                        pState = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'zipCode') {
                        pZip = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'mailingAddrLine') {
                        mailingStreet = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'mailingCity') {
                        mailingCity = countyOfficeChildNode.getText().trim();
                    } else if (countyOfficeChildNode.getName() == 'mailingZipCode') {
                        mailingZip = countyOfficeChildNode.getText().trim();
                    }
                    if(officeCode!=null){
                        List < String > addressFields = new List < String > ();
                        addressFields.add(officeName);
                        addressFields.add(phone);
                        addressFields.add(pStreet);
                        addressFields.add(pCity);
                        addressFields.add(pState);
                        addressFields.add(pZip);
                        addressFields.add(mailingStreet);
                        addressFields.add(mailingCity);
                        addressFields.add(mailingZip);
                        officeCodeOficeAddressMap.put(officeCode, addressFields);
                    }
                }
            }
        }

        List < FSA_BTO_County__c > results = [Select Name, FSA_BTO_FIPS_Code__c, FSA_BTO_StreetAddress__c, FSA_BTO_City__c, FSA_BTO_State__c, FSA_BTO_Zip_Code__c from FSA_BTO_County__c where FSA_BTO_FIPS_Code__c IN: officeCodeOficeAddressMap.keySet()];
        if (!results.isEmpty()) {
            for (FSA_BTO_County__c counties: results) {

                countyRecord = counties;
                countyRecord.Name = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[0];
                countyRecord.FSA_BTO_StreetAddress__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[6];
                countyRecord.FSA_BTO_City__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[7];
                countyRecord.FSA_BTO_State__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[4];
                countyRecord.FSA_BTO_Zip_Code__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[8];
                countyRecord.FSA_BTO_StreetAddress_Physical__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[2];
                countyRecord.FSA_BTO_City_Physical__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[3];
                countyRecord.FSA_BTO_State_Physical__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[4];
                countyRecord.FSA_BTO_Zip_Code_Physical__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[5];
                countyRecord.FSA_BTO_Phone__c = officeCodeOficeAddressMap.get(counties.FSA_BTO_FIPS_Code__c)[1];
                //update countyRecord;
                toReturn.add(countyRecord);
            }
        } else {
            system.debug(officeCodeOficeAddressMap.keySet());
            List<String> officeCodes=new List<String>(officeCodeOficeAddressMap.keySet());
            if(!officeCodes.isEmpty()){
            String officeCode=officeCodes[0];
            countyRecord = new FSA_BTO_County__c();
            countyRecord.Name = officeCodeOficeAddressMap.get(officeCode)[0];
            countyRecord.FSA_BTO_StreetAddress__c = officeCodeOficeAddressMap.get(officeCode)[6];
            countyRecord.FSA_BTO_City__c = officeCodeOficeAddressMap.get(officeCode)[7];
            countyRecord.FSA_BTO_State__c = officeCodeOficeAddressMap.get(officeCode)[4];
            countyRecord.FSA_BTO_Zip_Code__c = officeCodeOficeAddressMap.get(officeCode)[8];
            countyRecord.FSA_BTO_StreetAddress_Physical__c = officeCodeOficeAddressMap.get(officeCode)[2];
            countyRecord.FSA_BTO_City_Physical__c = officeCodeOficeAddressMap.get(officeCode)[3];
            countyRecord.FSA_BTO_State_Physical__c = officeCodeOficeAddressMap.get(officeCode)[4];
            countyRecord.FSA_BTO_Zip_Code_Physical__c = officeCodeOficeAddressMap.get(officeCode)[5];
            countyRecord.FSA_BTO_Phone__c = officeCodeOficeAddressMap.get(officeCode)[1];
            countyRecord.FSA_BTO_FIPS_Code__c = officeCode;
            toReturn.add(countyRecord);
            }
        }
        try {
            upsert toReturn;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }


    }
}
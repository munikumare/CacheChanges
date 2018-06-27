public class FSA_BTO_SCIMSCustomer { 
    public String coreCustomerId { get; set; }
    public String lastName { get; set; }
    public String firstName { get; set; }
    public String middleName { get; set; }
    public String suffixName { get; set; }
    public String prefixName { get; set; }
    public String email { get; set; }
    public String phone { get; set; }
    public String mobile { get; set; }
    public String mailingStreet { get; set; }
    public String mailingCity { get; set; }
    public String mailingState { get; set; }
    public String mailingZip { get; set; }
    //public String address { get; set; }
    public String customerType { get; set; }
    public String commonName { get; set; }
    public String customerStatus { get; set; }
    public String businessType { get; set; }
    public String businessName { get; set; }
    public String gender { get; set; }
    public String maritalStatus { get; set; }
    public String birthDate { get; set; }
    public String citizenCountry { get; set; }
    public String languagePreference { get; set; }
    public String disability { get; set; }
    public String veteranStatus { get; set; }

    public FSA_BTO_SCIMSCustomer(String scimsCustomerXmlString) {       
        DOM.Document doc = new DOM.Document();
        doc.load(scimsCustomerXmlString);
        DOM.XMLNode root = doc.getRootElement(); 
        DOM.XMLNode scimsCustomer = root.getChildElement('SCIMSCustomer', null);
        
        for(Dom.XmlNode scimsCustomerChildNode: scimsCustomer.getChildElements()) {
            if(scimsCustomerChildNode.getName() == 'CustomerData') {
                for(Dom.XmlNode customerDataChildNode: scimsCustomerChildNode.getChildElements()) {
                    if(customerDataChildNode.getName() == 'CustomerID') {
                        coreCustomerId = customerDataChildNode.getText().trim();
                    }
                    if(customerDataChildNode.getName() == 'CustomerType') {
                        customerType = customerDataChildNode.getChildElement('Description', null).getText().trim();
                    }
                    if(customerDataChildNode.getName() == 'CommonName') {
                        commonName = customerDataChildNode.getText().trim();
                    }
                    if(customerDataChildNode.getName() == 'IndividualName') {
                        for(Dom.XmlNode individualNameChildNode: customerDataChildNode.getChildElements()) {
                            if(individualNameChildNode.getName() == 'Last') {
                                String last = individualNameChildNode.getText().trim();
                                // max char 80
                                if(last.length() > 80) {
                                    lastName = last.substring(0,80);
                                } else {
                                    lastName = last;
                                }
                            }
                            if(individualNameChildNode.getName() == 'First') {
                                String first = individualNameChildNode.getText().trim();
                                // max char 40
                                if(first.length() > 40) {
                                    firstName = first.substring(0,40);
                                } else {
                                    firstName = first;
                                }
                            }
                            if(individualNameChildNode.getName() == 'Middle') {
                                String middle = individualNameChildNode.getText().trim();
                                // max char 40
                                if(middle.length() > 40) {
                                    middleName = middle.substring(0,40);
                                } else {
                                    middleName = middle;
                                }
                            }
                            if(individualNameChildNode.getName() == 'Prefix') {
                                String prefix = individualNameChildNode.getText().trim();
                                // pre-defined picklist values
                                if(prefix.equalsIgnoreCase('mr') || prefix.equalsIgnoreCase('mr.')) {
                                    prefixName = 'Mr.';
                                } else if(prefix.equalsIgnoreCase('ms') || prefix.equalsIgnoreCase('ms.')) {
                                    prefixName = 'Ms.';
                                } else if(prefix.equalsIgnoreCase('miss') || prefix.equalsIgnoreCase('miss.')) {
                                    prefixName = 'Miss.';
                                } else if(prefix.equalsIgnoreCase('mrs') || prefix.equalsIgnoreCase('mrs.')) {
                                    prefixName = 'Mrs.';
                                } else if(prefix.equalsIgnoreCase('dr') || prefix.equalsIgnoreCase('dr.')) {
                                    prefixName = 'Dr.';
                                }
                            }
                            if(individualNameChildNode.getName() == 'Suffix') {
                                String suffix = individualNameChildNode.getText().trim();
                                // max length 40
                                if(suffix.length() > 40) {
                                    suffixName = suffix.substring(0,40);
                                } else {
                                    suffixName = suffix;
                                }
                            }
                        }
                    }
                    // only populate businessName local variable if lastName is empty or null
                    if(customerDataChildNode.getName() == 'BusinessName' && String.isEmpty(lastName)) {
                        String business = customerDataChildNode.getText().trim();
                        if(business.length() > 80) {
                            businessName = business.substring(0,80);
                        } else {
                            businessName = business;                        
                        }
                    }
                    if(customerDataChildNode.getName() == 'BusinessType' && !String.isEmpty(businessName)) {
                        for(Dom.XmlNode businessTypeChildNode: customerDataChildNode.getChildElements()) {
                            if(businessTypeChildNode.getName() == 'BusinessTypeCurrentYear') {
                                businessType = businessTypeChildNode.getChildElement('Description', null).getText().trim();
                            }
                        }
                    }
                    if(customerDataChildNode.getName() == 'InactiveCustomer') {
                        customerStatus = customerDataChildNode.getChildElement('Description', null).getText().trim();
                    }
                    if(customerDataChildNode.getName() == 'CustomerAttributes' && String.isEmpty(businessName)) {
                        for(Dom.XmlNode customerAttributesChildNode: customerDataChildNode.getChildElements()) {
                            if(customerAttributesChildNode.getName() == 'Gender') {
                                gender = customerAttributesChildNode.getChildElement('Description', null).getText().trim();
                            }
                            if(customerAttributesChildNode.getName() == 'MaritalStatus') {
                                maritalStatus = customerAttributesChildNode.getChildElement('Description', null).getText().trim();
                            }
                            if(customerAttributesChildNode.getName() == 'BirthDate') {
                                birthDate = customerAttributesChildNode.getText().trim();
                            }
                            if(customerAttributesChildNode.getName() == 'CitizenshipCountry') {
                                citizenCountry = customerAttributesChildNode.getChildElement('Code', null).getText().trim();
                            }
                            if(customerAttributesChildNode.getName() == 'LanguagePreference') {
                                languagePreference = customerAttributesChildNode.getChildElement('Description', null).getText().trim();
                            }
                            if(customerAttributesChildNode.getName() == 'Veteran') {
                                veteranStatus = customerAttributesChildNode.getText().trim();
                            }
                        }
                    }
                }
            }
            if(scimsCustomerChildNode.getName() == 'Address') {
                String currentAddress;
                
                /*
                String mailingCity;
                String mailingState;
                String mailingZip;
                address = '';
                */
                
                for(Dom.XmlNode addressChildNode: scimsCustomerChildNode.getChildElements()) {    
                    if(addressChildNode.getName() == 'CurrentAddress') {
                        currentAddress = addressChildNode.getText().trim();
                    }
                    if(currentAddress == 'Y') {
                        if(addressChildNode.getName() == 'DeliveryAddressLine') {
                            mailingStreet = addressChildNode.getText().trim();
                        }
                        if(addressChildNode.getName() == 'CityName') {
                            mailingCity = addressChildNode.getText().trim();
                        }
                        if(addressChildNode.getName() == 'StateAbbreviation') {
                            mailingState = addressChildNode.getText().trim();
                        }
                        if(addressChildNode.getName() == 'ZipCodeFirst5') {
                            mailingZip = addressChildNode.getText().trim();
                        }
                        /*
                        if(addressChildNode.getName() == 'ZipCodePlus4') {
                            mailingZip += '-' + addressChildNode.getText().trim();
                        }
                        */
                    }
                }
                /*
                if(!String.isEmpty(mailingCity)) address += mailingCity + ', ';
                if(!String.isEmpty(mailingState)) address += mailingState + ' ';
                if(!String.isEmpty(mailingZip)) address += mailingZip;
                */
            }
            if(scimsCustomerChildNode.getName() == 'Phone') {
                String phoneCode;
                String phoneNumber;
                for(Dom.XmlNode phoneChildNode: scimsCustomerChildNode.getChildElements()) {
                    if(phoneChildNode.getName() == 'PhoneType') {
                        phoneCode = phoneChildNode.getChildElement('Code', null).getText().trim();
                    }
                    if(phoneChildNode.getName() == 'PhoneNumber') {
                        phoneNumber = phoneChildNode.getText().trim();
                    }
                    if(!String.isEmpty(phoneCode)) {
                        if(phoneCode.equals('HM')) {
                            phone = phoneNumber;
                        } else if(phoneCode.equals('MO')) {
                            mobile = phoneNumber;
                        }
                    } else {
                        phone = phoneNumber;
                    }
                }
            }
            if(scimsCustomerChildNode.getName() == 'Email') {
                String emailPrimary;
                String emailAddress;
                for(Dom.XmlNode emailChildNode: scimsCustomerChildNode.getChildElements()) {
                    if(emailChildNode.getName() == 'EmailAddress') {
                        emailAddress = emailChildNode.getText().trim();
                    }
                    if(emailChildNode.getName() == 'EmailPrimary') {
                        emailPrimary = emailChildNode.getText().trim();
                    }
                }
                if(emailPrimary == 'Y') {
                    email = emailAddress;
                }
            }
            if(scimsCustomerChildNode.getName() == 'Disability') {
                for(Dom.XmlNode disabilityChildNode: scimsCustomerChildNode.getChildElements()) {
                    if(disabilityChildNode.getName() == 'DisabilityType') {
                        disability = disabilityChildNode.getChildElement('Description', null).getText().trim();
                    }
                }
            }
        }
    }
}
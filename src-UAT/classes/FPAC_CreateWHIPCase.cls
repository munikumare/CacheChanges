/**
* Created by Sabitha on 04/27/2018
* REST API to create a case 
*/

@RestResource(urlMapping='/CreateWHIPCase/*')
global with sharing  class FPAC_CreateWHIPCase{
    
    // method is to create a case with input parameters and defined static values
    // returns case id on successfull case creation or returns error message if validation fails or unknown error
    @HttpPost
    global static String createCase(String name,String email,String phone,String mobile)
    {
        // check if all fields are empty
        if(String.isBlank(name) && String.isBlank(email) && String.isBlank(phone) && String.isBlank(mobile))    
        {
            RestContext.response.statusCode = 400;
            return 'All fields cannot be empty';
        }
        
        //check if valid email
        if (!emailAddressIsValid(email)) {
            RestContext.response.statusCode = 400;
            return 'Not a valid email';
        }
        
        try {
            // create new case
            Case newCase = new Case();
            
            //Get the WHIP Application recordtype and assign it to case
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('WHIP Application').getRecordTypeId();
            newCase.RecordTypeId=recordTypeId;
            
            newCase.Type='FSA Business';
            newCase.Subject='WHIP Application';
            newCase.Status='Initiated';
            newCase.FSA_BTO_Additional_Items_Received__c='Form FSA-XXX - (WHIP) Wildfire & Hurricane Indemnity Program Application';
            newCase.FSA_BTO_Additional_Items_Provided__c='Form FSA-XXX - (WHIP) Wildfire & Hurricane Indemnity Program Application';
            newCase.FSA_BTO_Service_Requested__c='FSA-XXX -(WHIP) Wildfire & Hurricane Indemnity Program';
            
            
            //newCase.FarmersGov_Producer_Name__c=name;
            newCase.Farmers_Email__c=email;
            //newCase.Phone_Number__c=phone;
            newCase.Cell_Number__c=mobile;
            
            //newCase.FarmersGov_Email__c=email;
            newCase.Additional_Contact_Name__c=name;
            //newCase.ContactMobile=mobile;
            newCase.SuppliedPhone=phone;
            
            //Get the system contact and assign it to case
            List<Contact> con=[select Id,Name from Contact where System_Contact__c=true];
            if(con!=null && con.size()>0){
                newCase.ContactId=con[0].Id;
            }
            insert newCase;
            Case newCase1 = [Select Id,CaseNumber from Case where Id = :newCase.Id];
            return newCase1.CaseNumber;
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            System.debug('Error on case creation: '+e);
            return 'Error on case creation: '+e.getMessage();
        }
    }
    
    // method is to validate the email 
    // returns true if input text is valid email format
    public static Boolean emailAddressIsValid(String email) {
        if (String.isEmpty(email)) return true;
        Boolean isValid = true;
            
        // Regex source: http://www.regular-expressions.info/email.html
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
    
        if (!MyMatcher.matches()) 
            isValid = false;
        return isValid; 
    }
    
}
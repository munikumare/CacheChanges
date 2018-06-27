global class ARCGISMappingController  {

    public static String ContactId {get; set;}
    public static String LandId {get; set;}
    public static String viewType {get; set;}

    public ARCGISMappingController() {
        String parameterId = ApexPages.currentPage().getParameters().get('Id');
        if(parameterId==null){
            User u = [select id, contactId, IsPortalEnabled from User where id = : UserInfo.getUserId()];          
           if(u.IsPortalEnabled=true)
           {
                parameterId=u.contactId;
           }
        }
        String viewTypeVar = ApexPages.currentPage().getParameters().get('ViewType');
        String contactPrefix = Contact.sObjectType.getDescribe().getKeyPrefix();
        String landPrefix = Land__c.sObjectType.getDescribe().getKeyPrefix();

        ContactId = '';
        LandId = '';

        if (parameterId.startsWith(contactPrefix)) {
            ContactId = parameterId;
        } else if (parameterId.startsWith(landPrefix)) {
            LandId = parameterId;
        }
        system.debug(Apexpages.currentPage().getUrl());
        system.debug(viewTypeVar);
        if(viewTypeVar!=null){
            viewType=viewTypeVar;
        }
    
    }  
}
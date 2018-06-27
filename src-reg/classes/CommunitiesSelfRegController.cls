/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public with sharing class CommunitiesSelfRegController {
    // modified for higher code coverage
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set; }
    public String confirmPassword {get; set; }
    public String communityNickname {get; set; }
  
    public CommunitiesSelfRegController() {}
  
    private boolean isValidPassword() {
        return password == confirmPassword;
    }

    public PageReference registerUser() {
        if (!isValidPassword() && password != null) {
            System.debug(System.LoggingLevel.DEBUG, '## DEBUG: Password is invalid - returning null');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }  

        //String profileId = ''; // To be filled in by customer.
        //String roleEnum = ''; // To be filled in by customer.
        //String accountId = ''; // To be filled in by customer.

        // Set this to your main Communities Profile API Name
        String profileApiName = 'Standard';
        String profileId = [SELECT Id FROM Profile WHERE UserType = :profileApiName LIMIT 1].Id;
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        String accountId = accounts[0].Id;
        
        String userName = email;

        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
        u.ProfileId = profileId;
        
        String userId = Site.createPortalUser(u, accountId, password);
       
        if (userId != null) { 
            return Site.login(userName, password, null);
        } else {
            return null;
        }
        System.debug(System.LoggingLevel.DEBUG, '## DEBUG: User creation not successful - returning null');
        return null;
    }
}
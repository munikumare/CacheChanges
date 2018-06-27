global class FSA_BTO_CBS_SyncA implements Schedulable {
   public List<String> codes {get; set;}
   
   global void execute(SchedulableContext SC) {
      FSA_BTO_CBSSyncController controller = new FSA_BTO_CBSSyncController(); 
      getCodes();
      for(String c: codes){
          FSA_BTO_CBSSyncController.getCounty(c);
      }
   }
   
   public void getCodes(){
       codes = new List<String>();
       codes.add('25');// Massachusetts
       codes.add('26');// Michigan
       codes.add('27');// Minnesota
       codes.add('28');// Mississippi
       codes.add('29');// Missouri
       codes.add('30');// Montana
       codes.add('31');// Nebraska
       codes.add('32');// Nevada
       codes.add('33');// New Hampshire              
       codes.add('34');// New Jersey
       codes.add('35');// New Mexico
       codes.add('36');// New York
       codes.add('37');// North Carolina
       codes.add('38');// North Dakota
       codes.add('39');// Ohio
       codes.add('40');// Oklahoma
       codes.add('41');// Oregon
       codes.add('42');// Pennsylvania
       codes.add('44');// Rhode Island
       codes.add('45');// South Carolina
       codes.add('46');// South Dakota
       codes.add('47');// Tennessee
       codes.add('48');// Texas
       codes.add('49');// Utah
       codes.add('50');// Vermont
       codes.add('51');// Virginia
       codes.add('53');// Washington
       codes.add('54');// West Virginia
       codes.add('55');// Wisconsin
       codes.add('56');// Wyoming
       codes.add('72');// Puerto Rico
       
    }
}
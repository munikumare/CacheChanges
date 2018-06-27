global class FSA_BTO_CBS_SyncB implements Schedulable {
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
       codes.add('66');// Guam
       codes.add('78');// Virgin Islands
       codes.add('01');// Alabama
       codes.add('02');// Alaska
       codes.add('04');// Arizona
       codes.add('05');// Arkansas
       codes.add('06');// California
       codes.add('08');// Colorado
       codes.add('09');// Connecticut
       codes.add('10');// Delaware
       codes.add('11');// DC
       codes.add('12');// Florida
       codes.add('13');// Georgia
       codes.add('15');// Hawaii
       codes.add('16');// Idaho
       codes.add('17');// Illinois
       codes.add('18');// Indiana
       codes.add('19');// Iowa
       codes.add('20');// Kansas
       codes.add('21');// Kentucky
       codes.add('22');// Louisiana
       codes.add('23');// Maine
       codes.add('24');// Maryland
    }
    
}
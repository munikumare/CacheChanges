public class FSA_BTO_CBSSoapPacketBuilder {
    private String header = '<soapenv:Envelope' +
                            ' xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' +
                            ' xmlns:ser="http://service.cbs.citso.fsa.usda.gov">'+
                            '<soapenv:Header/>'+
                            '<soapenv:Body>'+       
                            '<ser:findFSAOfficesByStateFips>'+
                             '<auditToken><applicationIdentifier>none</applicationIdentifier><processingNode>none</processingNode><requestHost>none</requestHost></auditToken>';
                            
    private String footer = '</ser:findFSAOfficesByStateFips>'+
                            '</soapenv:Body>'+
                            '</soapenv:Envelope>' ;
                            
    
    public Map<String,String> argumentMap{ get; set; }
 
    public FSA_BTO_CBSSoapPacketBuilder(){
        argumentMap = new Map<String,String>();
    }
 
    private String buildPacket(){
        String packet = header;
 
        for(String argument: argumentMap.keySet()){
            packet += '<'+ argumentMap.get(argument) +'>';
            packet += argument;
            packet += '</'+ argumentMap.get(argument) +'>';
        }
 
        packet += footer;
         System.debug(packet);
        return packet;
    }
 
    public String toXmlString(){
        return buildPacket();
    }
}
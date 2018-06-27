public class FSA_BTO_SCIMSWSSoapPacketBuilder {
    private String header = '<soapenv:Envelope' +
                            ' xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' +
                            ' xmlns:mes="http://tempuri.org/message/">'+
                            '<soapenv:Header/>'+
                            '<soapenv:Body>'+       
                            '<mes:GetCustomer>';
                            
    private String footer = '</mes:GetCustomer>'+
                            '</soapenv:Body>'+
                            '</soapenv:Envelope>';
    
    public Map<String,String> argumentMap{ get; set; }
 
    public FSA_BTO_SCIMSWSSoapPacketBuilder(){
        argumentMap = new Map<String,String>();
    }
 
    private String buildPacket(){
        String packet = header;
 
        for(String argument: argumentMap.keySet()){
            packet += '<'+argument+'>';
            packet += argumentMap.get(argument);
            packet += '</'+argument+'>';
        }
 
        packet += footer;
 
        return packet;
    }
 
    public String toXmlString(){
        return buildPacket();
    }
}
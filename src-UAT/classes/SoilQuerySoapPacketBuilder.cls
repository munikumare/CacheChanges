public class SoilQuerySoapPacketBuilder {
    private String header = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sdm="http://SDMDataAccess.nrcs.usda.gov/Tabular/SDMTabularService.asmx"><soapenv:Header/><soapenv:Body>';

    private String footer = '</soapenv:Body></soapenv:Envelope>';


    public String query {get;set;}

    public SoilQuerySoapPacketBuilder() {
        query = '';
    }

    private String buildPacket() {
        String packet = header;

        packet += '<sdm:RunQuery><sdm:Query>';
        packet += query;
        packet += '</sdm:Query></sdm:RunQuery>';

        packet += footer;
        System.debug(packet);
        return packet;
    }

    public String toXmlString() {
        return buildPacket();
    }
}
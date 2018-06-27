public class SoilDataWebServiceCallout {

    public static List < String > makeRequest(String endpoint, String query) {
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'text/xml');
        SoilQuerySoapPacketBuilder packetBuilder = new SoilQuerySoapPacketBuilder();
        packetBuilder.query = query;
        String xmlReq = packetBuilder.toXmlString();
        //System.debug('Request: ' + xmlReq);
        request.setBody(xmlReq);
        Http http = new Http();
        HttpResponse response = http.send(request);
        return parseSoapResponse(response.getBody());
    }

    public static List < String > parseSoapResponse(String soapResponse) {
        List < String > soilInfo = new List < String > ();
        String envNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        DOM.Document doc = new DOM.Document();
        doc.load(soapResponse);
        DOM.XMLNode envRoot = doc.getRootElement();
        system.debug(envRoot);
        //DOM.XMLNode envMsg = envRoot.getChildElement('RunQueryResult',endpoint);
        String unitSymbol, rgbString, mapUnitRatingString;
        //system.debug(envMsg);
        for (Dom.XmlNode mapChildNode: envRoot.getChildElements()) {
            system.debug(mapChildNode);
            if (mapChildNode.getName() == 'Body') {
                for (Dom.XmlNode mapChildNode2: mapChildNode.getChildElements()) {
                    system.debug(mapChildNode2);
                    if (mapChildNode2.getName() == 'RunQueryResponse') {
                        for (Dom.XmlNode mapChildNode3: mapChildNode2.getChildElements()) {
                            system.debug(mapChildNode3);
                            if (mapChildNode3.getName() == 'RunQueryResult') {
                                for (Dom.XmlNode mapChildNode4: mapChildNode3.getChildElements()) {
                                    system.debug(mapChildNode4);
                                    if (mapChildNode4.getName() == 'diffgram') {
                                        for (Dom.XmlNode mapChildNode5: mapChildNode4.getChildElements()) {
                                            system.debug(mapChildNode4.getName());
                                            if (mapChildNode5.getName() == 'NewDataSet') {
                                                for (Dom.XmlNode mapChildNode6: mapChildNode5.getChildElements()) {
                                                    system.debug(mapChildNode6.getName());
                                                    if (mapChildNode6.getName() == 'Table') {
                                                        for (Dom.XmlNode mapUnitChildChildNode: mapChildNode6.getChildElements()) {
                                                            system.debug(mapUnitChildChildNode.getName());
                                                            if (mapUnitChildChildNode.getName() == 'RgbString') {
                                                                rgbString = mapUnitChildChildNode.getText().trim();
                                                            } else if (mapUnitChildChildNode.getName() == 'MapUnitRatingString') {
                                                                mapUnitRatingString = mapUnitChildChildNode.getText().trim();
                                                            }
                                                                    if (!String.isEmpty(rgbString)) {
                                                                        if(!soilInfo.contains(rgbString + '|' + mapUnitRatingString)){
                                                                            soilInfo.add(rgbString + '|' + mapUnitRatingString);
                                                                        }
                                                                        rgbString='';
                                                                    }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        system.debug(soilInfo);
        return soilInfo;
    }

}
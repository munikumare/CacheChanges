public with sharing class FPAC_LandLatLongBatchHelper {
    public static String getBoundaryInformation(String farmNumber, String tractNumber) {
        String endpoint = 'callout:Mulesoft/gis/geometry/union?farmNumber=' + farmNumber;
        if (!String.isEmpty(tractNumber)) {
            endpoint += '&tractNumber=' + tractNumber;
        }
        System.debug('getBoundaryInformationJSON ' + endpoint);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        try {
            HttpResponse res = h.send(req);
            String sResponseText = res.getBody();
            sResponseText = sResponseText.replaceFirst('^\"+', '');
            sResponseText = sResponseText.replaceFirst('\"+$', '');
            sResponseText = sResponseText.replace('\\', '');
            return sResponseText;
        } catch (System.CalloutException e) {
            system.debug(e);
        }

        return '';
    }

    public static Map < Id, Land__c > findLatLong(String boundaryJSON, Id landId, Map < Id, Land__c > landFarm) {
        Map < String, Object > deserializedJSON = (Map < String, Object > ) JSON.deserializeUntyped(boundaryJSON);
        Map < String, Object > geometry = (Map < String, Object > ) deserializedJSON.get('geometry');
        if(geometry!=null){
            if(geometry.get('coordinates')!=null){
                List < Object > co = (List < Object > ) geometry.get('coordinates');
                List < Object > coordinates = (List < Object > ) co.get(0);
                system.debug(coordinates);
                List < Object > coordinatesSet1 = (List < Object > ) coordinates.get(0);
                system.debug(coordinatesSet1);
                List < Object > coordinatesSet2 = (List < Object > ) coordinates.get(1);
                system.debug(coordinatesSet2);
                Double xmin = 0;
                Double xmax = 0;
                Double ymin = 0;
                Double ymax = 0;
                if (Double.valueOf(coordinatesSet1.get(0)) < Double.valueOf(coordinatesSet2.get(0))) {
                    xmin = Double.valueOf(coordinatesSet1.get(0));
                    xmax = Double.valueOf(coordinatesSet2.get(0));
                } else {
                    xmax = Double.valueOf(coordinatesSet1.get(0));
                    xmin = Double.valueOf(coordinatesSet2.get(0));
                }
                if (Double.valueOf(coordinatesSet1.get(1)) < Double.valueOf(coordinatesSet2.get(0))) {
                    ymin = Double.valueOf(coordinatesSet1.get(1));
                    ymax = Double.valueOf(coordinatesSet2.get(0));
                } else {
                    ymax = Double.valueOf(coordinatesSet1.get(1));
                    ymin = Double.valueOf(coordinatesSet2.get(1));
                }
                system.debug(xmin + ',' + xmax);
                system.debug(ymin + ',' + ymax);
                for (integer x = coordinates.size() - 1; x >= 0; x--) {
                    List < Object > geometries = (List < Object > ) coordinates.get(x);
                    system.debug(geometries);
                    if (Double.valueOf(geometries.get(0)) > xmax) {
                        xmax = Double.valueOf(geometries.get(0));
                    }
                    if (Double.valueOf(geometries.get(0)) < xmin) {
                        xmin = Double.valueOf(geometries.get(0));
                    }
                    if (Double.valueOf(geometries.get(1)) > ymax) {
                        ymax = Double.valueOf(geometries.get(1));
                    }
                    if (Double.valueOf(geometries.get(1)) < ymin) {
                        ymin = Double.valueOf(geometries.get(1));
                    }
                }
                Double longitude = (xmin + xmax) / 2;
                Double latitude = (ymin + ymax) / 2;
                system.debug(latitude + ',' + longitude);
                landFarm.get(landId).Latitude_Longitude__latitude__s=latitude;
                landFarm.get(landId).Latitude_Longitude__longitude__s=longitude;
                landFarm.get(landId).Calculate_LatLong__c=false;
            }else{
                landFarm=landFarm;
            }
        }else{
            landFarm=landFarm;
        }
        return landFarm;
    }

    public static void updateLatLong(Map < Id, Land__c > landFarm) {
        try {
            update landFarm.values();
        } catch (System.DMLException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}
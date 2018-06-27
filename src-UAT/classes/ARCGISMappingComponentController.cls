global class ARCGISMappingComponentController {

	global static Mapping_Webservices__c webservices {get{if(webservices==null){return setWebservices();}return null;}set;}
	global static Boolean showToolbar{get;set;}
	global static String toolbarCSSClass{get{if(toolbarCSSClass==null){return setCSSClasses('toolbar');}return null;}set;}
	global static Boolean showLayers{get;set;}
	global static String layersCSSClass{get{if(layersCSSClass==null){return setCSSClasses('layers');}return null;}set;}
	global static List<String> colorMap{get;set;}

	global static String ContactId {get; set;}
	global static Boolean IsContact {get; set;}
	global static String LandId {get; set;}
	global static String viewType {get; set;}
	global static Land__c Land {
		get {
			if (!IsContact) {
				return getLand();
			} else {
				return new Land__c();
			}
		}
		set;
	}
	public static final String SYSTEM_ADMIN = 'System Administrator'; // portfarm-263
	public static final String EMPLOYEE_BASE_PROFILE = 'FPAC Employee Base';
	public static final String EMPLOYEE_MANAGER_PROFILE = 'FPAC Manager Base';
	global static Boolean isAdminOrEmployee {
		get {
			User user = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
			if(user.Profile.Name == SYSTEM_ADMIN || user.Profile.Name == EMPLOYEE_BASE_PROFILE || user.Profile.Name == EMPLOYEE_MANAGER_PROFILE){
				return true;
			} else {
				return false;
			}
		}
		set;
	}

	global ARCGISMappingComponentController() {}

	global static Mapping_Webservices__c setWebservices() {
		Mapping_Webservices__c web = [
			SELECT Congressional_Webservice_Address__c, Cropland_Webservice_Address__c, CRP_Cropland_Webservice_Address__c, Easements_Webservice_Address__c, Field_Labels_Webservice_Address__c, Hydrography_Webservice_Address__c, Non_Cropland_Webservice_Address__c, PLSS_Webservice_Address__c, Roads_Webservice_Address__c, Soil_Webservice_Address__c, Wetland_Webservice_Address__c, Tabular_Post_Rest__c, Short_Form_Data__c, Soil_XML_Webservice_Address__c, NAIP_Webservice_Address__c
			FROM Mapping_Webservices__c
		];
		return web;
	}

	global static String setCSSClasses(String cssClass) {
		if ((cssClass=='toolbar' && showToolbar) || (cssClass=='layers' && showLayers)) {
			return 'show';
		}
		return 'hide';
	}

	global static Land__c getLand() {
		return [
			SELECT Id, RecordType.Name, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Farm_Number__c, Tract_Number__c, Dashed_Farm_Number__c, Name
			FROM Land__c
			WHERE Id = :LandId
		];
	}

	global static String getAOIId(String mapCoords) {

		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setEndpoint(webservices.Tabular_Post_Rest__c);
		req.setMethod('POST');
		req.setBody('service=aoi&request=create&aoicoords='+mapCoords);
		//req.setCompressed(true); // otherwise we hit a limit of 32000

		try {
			res = http.send(req);
			String sResponseText = res.getBody();
			sResponseText=sResponseText.replaceFirst('^\"+', '');
			sResponseText=sResponseText.replaceFirst('\"+$', '');
			sResponseText=sResponseText.replace('\\', '');
			JSON2Apex objJSON2Apex = new JSON2Apex(System.JSON.createParser(sResponseText));
			if(objJSON2Apex.aoiId!=null){
				return objJSON2Apex.aoiId;
			}
		} catch(System.CalloutException e) {
		}

		return '';
	}

	@RemoteAction
	global static String getInterpresultid(String mapCoords) {

		String aoiId=getAOIId(mapCoords);
		String shortFormData=webservices.Short_Form_Data__c.replace('[AOIID]',aoiId);
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
		req.setEndpoint(webservices.Tabular_Post_Rest__c);
		req.setMethod('POST');
		req.setBody('service=interpretation&request=getrating&shortformdata='+shortFormData+'&aoiId='+aoiId);
		//req.setCompressed(true); // otherwise we hit a limit of 32000

		try {
			res = http.send(req);
			String sResponseText = res.getBody();
			sResponseText=sResponseText.replaceFirst('^\"+', '');
			sResponseText=sResponseText.replaceFirst('\"+$', '');
			sResponseText=sResponseText.replace('\\', '');
			JSON2Apex objJSON2Apex = new JSON2Apex(System.JSON.createParser(sResponseText));
			if(objJSON2Apex.interpresultid!=null){
				return objJSON2Apex.interpresultid;
			}
		} catch(System.CalloutException e) {
		}

		return '';
	}

	@RemoteAction
	global static Id getFieldRecordId(string clualtid){
		Id LandId = null;
		List<Land__c> landRecords=[SELECT Id
		FROM Land__c
		WHERE CLU_Alternative_Identifier__c=:clualtid LIMIT 1];

		if (landRecords.isEmpty()) {
			LandId= null;
		}
		else {
			for (Land__c land : landRecords) {
				LandId = land.Id;
			}
		}
		//system.debug(LandId);
		return LandId;
	}
	@RemoteAction
	global static List<String> getColorData(String xmlURL, String interpresultId) {
		colorMap=SoilDataWebServiceCallout.makeRequest(xmlURL, 'select  MapUnitRatingString, RgbString from SDA_Get_AoiSoilThematicMapRating_By_AoiSoilThematicMapId('+interpresultId+');');
		return colorMap;
	}

	@RemoteAction
	public static Object getCLUData(String farmNumber, String tractNumber, String contactId) {

		if (contactId.startsWith(Contact.sObjectType.getDescribe().getKeyPrefix())) {
			if (String.isEmpty(tractNumber)) {
				List<Authority__c> authorities = [
					SELECT Id
					FROM Authority__c
					WHERE Contact__c = :contactId
						AND Associated_Land__r.Dashed_Farm_Number__c = :farmNumber
						AND Associated_Land__r.RecordType.Name = 'Farm'
				];
				if (authorities.isEmpty()) {
					return null;
				}
			} else {
				List<Authority__c> authorities = [
					SELECT Id
					FROM Authority__c
					WHERE Contact__c = :contactId
						AND Associated_Land__r.RecordType.Name = 'TRACT'
						AND (Associated_Land__r.Tract_Number__c = :tractNumber
							OR Associated_Land__r.Dashed_Farm_Number__c = :farmNumber)
				];
				if (authorities.isEmpty()) {
					return null;
				}
			}
		}
		String endpoint = 'callout:Mulesoft/gis/clu/getFeatures?farmNumber=' + farmNumber;
		if (!String.isEmpty(tractNumber)) {
			endpoint += '&tractNumber=' + tractNumber;
		}
		System.debug('getCLUData ' + endpoint);
		Continuation con = new Continuation(60);
		// Set callback method
		con.continuationMethod = 'processResponse';
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');
		// Add callout request to continuation
		con.state = con.addHttpRequest(req);
		return con;
	}

	@RemoteAction
	public static Object getCLUsForUser(String farmNumber, String tractNumber, String contactId) {

		if (contactId.startsWith(Contact.sObjectType.getDescribe().getKeyPrefix())) {
			if (String.isEmpty(tractNumber)) {
				List<Authority__c> authorities = [
					SELECT Id, Associated_Land__r.Admin_State_Code__c, Associated_Land__r.Admin_County_Code__c, Associated_Land__r.Name, Associated_Land__r.Parent_Id__r.Parent_Id__r.Name, Associated_Land__r.Parent_Id__r.Name
					FROM Authority__c
					WHERE Contact__c = :contactId
					AND Associated_Land__r.RecordType.Name = 'Field'
					//AND Associated_Land__r.Parent_Id__r.Parent_Id__r.Dashed_Farm_Number__c = :farmNumber
				];
				return authorities;
			}
		}
		return null;
	}

	@RemoteAction
	global static Object getBoundaryInformation(String farmNumber, String tractNumber) {
		String endpoint = 'callout:Mulesoft/gis/geometry/union?farmNumber=' + farmNumber;
		if (!String.isEmpty(tractNumber)) {
			endpoint += '&tractNumber=' + tractNumber;
		}
		System.debug('getBoundaryInformationJSON ' + endpoint);
		Continuation con = new Continuation(60);
		// Set callback method
		con.continuationMethod = 'processResponse';
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');
		// Add callout request to continuation
		con.state = con.addHttpRequest(req);

		return con;
	}

	@RemoteAction
	global static Object getWetlandsInformation(String farmNumber) {
		System.debug('getWetlandsInformationJSON '+farmNumber);
		String endpoint = 'callout:Mulesoft/gis/wetlands?farmNumber=' + farmNumber;
		System.debug('getWetlandsInformationJSON ' + endpoint);
		Continuation con = new Continuation(60);
		// Set callback method
		con.continuationMethod = 'processResponse';
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');
		// Add callout request to continuation
		con.state = con.addHttpRequest(req);
		return con;
	}

	public static Object processResponse(Object state) {
		HttpResponse response = Continuation.getResponse((String)state);
		return response.getBody();
	}

	@RemoteAction
	global static void setLatLong(String landId, decimal latitude, decimal longitude){
		System.debug(latitude);
		Land__c landRecord=[
			SELECT Id, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s
			FROM Land__c
			WHERE Id = :landId
		];
		landRecord.Latitude_Longitude__latitude__s=latitude;
		landRecord.Latitude_Longitude__longitude__s=longitude;
		try{
			update landRecord;
		}catch(System.DMLException e) {
			System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
	}

	@RemoteAction
	global static List<Land__c> getAllFarms(String recordId) {
		if (recordId.startsWith(Contact.sObjectType.getDescribe().getKeyPrefix())) {
			List<Authority__c> authorities = [
				SELECT Associated_Land__c
				FROM Authority__c
				WHERE Contact__c = :recordId
					AND Associated_Land__r.RecordType.Name = 'Farm'
			];
			Set<Id> landIds = new Set<Id>();
			for (Authority__c authority : authorities) {
				landIds.add(authority.Associated_Land__c);
			}
			return [
				SELECT Id, Name, Farm_Number__c, Cropland_Acres__c, Latitude_Longitude__latitude__s, Latitude_Longitude__longitude__s, Tract_Number__c, Dashed_Farm_Number__c
				FROM Land__c
				WHERE Id IN :landIds
			];
		} else {
			return null;
		}
	}

}
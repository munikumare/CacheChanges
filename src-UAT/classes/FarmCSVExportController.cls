public without sharing class FarmCSVExportController {

	public static final String SYSTEM_ADMIN = 'System Administrator';
	public static final String EMPLOYEE_BASE_PROFILE = 'FPAC Employee Base';
	public static final String EMPLOYEE_MANAGER_PROFILE = 'FPAC Manager Base';

	public String getCsvName() {
		String farmId = ApexPages.currentPage().getParameters().get('id');
		Land__c farm = [
			SELECT Id, Farm_Number__c, Admin_State_Code__c, Admin_County_Code__c
			FROM Land__c
			WHERE Id = :farmId
			LIMIT 1
		];
		return farm.Admin_State_Code__c + '-' + farm.Admin_County_Code__c + '-' + farm.Farm_Number__c + '_' + System.Today().year() + '.csv';
	}

	public String getHeaderFields() {
		return 'farmYear, farmNumber, adminStateName, adminCountyName, operatorName, farmMplAcres, farmDcpDoubleCropAcres, farmSugarCaneAcres, farmland, farmCropland, farmDcpCropland, farmEffectiveDcpCropland, reportDate, farmStatus, reconPendingCode, crpContracts, farmWbpAcres, farmWrpAcres, farmGrpAcres, farmStateConservationAcres, farmOtherConservationAcres, numberOfTracts, tractNumber, tractFarmLandAcres, tractCroplandAcres, tractCrpAcres, tractHelStatus, tractMplAcres, tractNapCropAcres, tractOtherConsrvAcres, tractStateConsrvAcres, tractSugarcaneAcres, tractWbpAcres, tractWrpAcres, tractWetlandStatus, tractDescription, tractLocationStateName, tractLocationCountyName, tractDcpCroplandAcres, tractDcpDoubleCropAcres, tractDcpEffectiveCroplandAcres, tractGrpAcres, wetlandCertYear, biaUnitRangeNumber, wetlandViolations, numberOfFields, fieldNumber, fieldAcreage, fieldLocationStateName, fieldLocationCountyName, fieldCongressionalDistrictCode, fieldCroplandIndicator3cm, fieldConservationPracticeIdentifier, fieldConservationPracticeDescription, fieldCrpContractNumber, fieldCrpContractExpirationDate, fieldNativeSodConversionDate, fieldSodConversionCropYear1, fieldSodConversionCropYear2, fieldSodConversionCropYear3, fieldSodConversionCropYear4';
	}

	public List<String> getLands() {
		String farmId = ApexPages.currentPage().getParameters().get('id');

		Land__c farm = [
			SELECT
				Id,
				RecordType.Name,
				Current_Year__c,
				Farm_Number__c,
				Admin_State_Code__c,
				Admin_County_Code__c,
				FarmOperator__c,
				MPL_Acres__c,
				DCP_Double_Crop_Acres__c,
				Sugarcane_Acres__c,
				Farmland_Acres__c,
				Cropland_Acres__c,
				DCP_Cropland_Acres__c,
				DCP_Effective_Cropland_Acres__c,
				Inactive_Indicator__c,
				Recon_Pending_Code__c,
				CRP_Contract_Number__c,
				WBP_Acres__c,
				WRP_Acres__c,
				Grp_Acres__c,
				State_Conserve_Acres__c,
				Other_Conserve_Acres__c,
				Tract_Number__c,
				CRP_Acres__c,
				Hel_Code__c,
				NAP_Crop_Number__c,
				toLabel(Wetland_Code__c),
				Description__c,
				Location_State_County_Code_FSA__c,
				Wetland_Certification_Year__c,
				BIA_Number__c,
				Wetland_Violation__c,
				Field_Number__c,
				CLU_Acreage__c,
				Congressional_District_Code__c,
				Corpland_Indicator__c,
				Conservation_Practice_Identifier__c,
				Crop_Contract_Expiry_Date__c,
				Native_SOD_Conservation_Date__c,
				SOD_Conservation_Crop_Yr1__c,
				SOD_Conservation_Crop_Yr2__c,
				SOD_Conservation_Crop_Yr3__c,
				SOD_Conservation_Crop_Yr4__c
			FROM
				Land__c
			WHERE
				Id = :farmId
			LIMIT 1
		];
		List<Land__c> tracts = [
			SELECT
				Id,
				Parent_ID__c,
				RecordType.Name,
				Current_Year__c,
				Farm_Number__c,
				Admin_State_Code__c,
				Admin_County_Code__c,
				FarmOperator__c,
				MPL_Acres__c,
				DCP_Double_Crop_Acres__c,
				Sugarcane_Acres__c,
				Farmland_Acres__c,
				Cropland_Acres__c,
				DCP_Cropland_Acres__c,
				DCP_Effective_Cropland_Acres__c,
				Inactive_Indicator__c,
				Recon_Pending_Code__c,
				CRP_Contract_Number__c,
				WBP_Acres__c,
				WRP_Acres__c,
				Grp_Acres__c,
				State_Conserve_Acres__c,
				Other_Conserve_Acres__c,
				Tract_Number__c,
				CRP_Acres__c,
				Hel_Code__c,
				NAP_Crop_Number__c,
				toLabel(Wetland_Code__c),
				Description__c,
				Location_State_County_Code_FSA__c,
				Wetland_Certification_Year__c,
				BIA_Number__c,
				Wetland_Violation__c,
				Field_Number__c,
				CLU_Acreage__c,
				Congressional_District_Code__c,
				Corpland_Indicator__c,
				Conservation_Practice_Identifier__c,
				Crop_Contract_Expiry_Date__c,
				Native_SOD_Conservation_Date__c,
				SOD_Conservation_Crop_Yr1__c,
				SOD_Conservation_Crop_Yr2__c,
				SOD_Conservation_Crop_Yr3__c,
				SOD_Conservation_Crop_Yr4__c
			FROM
				Land__c
			WHERE
				Parent_ID__c = :farmId
		];

		List<String> tractIds = new List<String>();
		for (Land__c tract : tracts) {
			tractIds.add(tract.Id);
		}

		List<Land__c> fields = [
			SELECT
				Id,
				Parent_ID__c,
				RecordType.Name,
				Current_Year__c,
				Farm_Number__c,
				Admin_State_Code__c,
				Admin_County_Code__c,
				FarmOperator__c,
				MPL_Acres__c,
				DCP_Double_Crop_Acres__c,
				Sugarcane_Acres__c,
				Farmland_Acres__c,
				Cropland_Acres__c,
				DCP_Cropland_Acres__c,
				DCP_Effective_Cropland_Acres__c,
				Inactive_Indicator__c,
				Recon_Pending_Code__c,
				CRP_Contract_Number__c,
				WBP_Acres__c,
				WRP_Acres__c,
				Grp_Acres__c,
				State_Conserve_Acres__c,
				Other_Conserve_Acres__c,
				Tract_Number__c,
				CRP_Acres__c,
				Hel_Code__c,
				NAP_Crop_Number__c,
				toLabel(Wetland_Code__c),
				Description__c,
				Location_State_County_Code_FSA__c,
				Wetland_Certification_Year__c,
				BIA_Number__c,
				Wetland_Violation__c,
				Field_Number__c,
				CLU_Acreage__c,
				Congressional_District_Code__c,
				Corpland_Indicator__c,
				Conservation_Practice_Identifier__c,
				Crop_Contract_Expiry_Date__c,
				Native_SOD_Conservation_Date__c,
				SOD_Conservation_Crop_Yr1__c,
				SOD_Conservation_Crop_Yr2__c,
				SOD_Conservation_Crop_Yr3__c,
				SOD_Conservation_Crop_Yr4__c
			FROM
				Land__c
			WHERE
				Parent_ID__c IN :tractIds
		];
		if (!isUserAdminOrEmployee()) {
			// User is not an employee
			String contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].ContactId;
			List<Authority__c> authorities = [
				SELECT Id, Contact__c, Associated_Land__c, Associated_Land__r.Parent_ID__c, Role__c
				FROM Authority__c
				WHERE Contact__c = :contactId
			];
			Set<Id> landIdsWithAuthorities = new Set<Id>();
			for (Authority__c authority : authorities) {
				landIdsWithAuthorities.add(authority.Associated_Land__c);
			}
			Set<Id> allLandIds = new Set<Id>();
			for (Authority__c authority : authorities) {
				allLandIds.add(authority.Associated_Land__c);
				allLandIds.add(authority.Associated_Land__r.Parent_ID__c);
			}
			Boolean userHasAuthorityToFarm = false;
			Boolean userIsOperatorOrOwnerOfFarm = false;
			for (Authority__c authority : authorities) {
				if (authority.Associated_Land__c == farmId) {
					userHasAuthorityToFarm = true;
					if (authority.Role__c.toUpperCase() == 'OWNER' || authority.Role__c.toUpperCase() == 'OPERATOR') {
						userIsOperatorOrOwnerOfFarm = true;
					}
				}
			}
			if (!userIsOperatorOrOwnerOfFarm) {
				farm.MPL_Acres__c = null;
				farm.DCP_Double_Crop_Acres__c = null;
				farm.Sugarcane_Acres__c = null;
				farm.Farmland_Acres__c = null;
				farm.Cropland_Acres__c = null;
				farm.DCP_Cropland_Acres__c = null;
				farm.DCP_Effective_Cropland_Acres__c = null;
				farm.Inactive_Indicator__c = null;
				farm.Recon_Pending_Code__c = null;
				farm.CRP_Contract_Number__c = null;
				farm.WBP_Acres__c = null;
				farm.WRP_Acres__c = null;
				farm.Grp_Acres__c = null;
				farm.State_Conserve_Acres__c = null;
				farm.Other_Conserve_Acres__c = null;
			}

			// Remove tracts that the user doesn't have authority to
			List<Land__c> tractsWithAuthorities = new List<Land__c>();
			for (Land__c tract : tracts) {
				if (landIdsWithAuthorities.contains(tract.Id)) {
					tractsWithAuthorities.add(tract);
				}
			}
			tracts = tractsWithAuthorities;

			for (Land__c tract : tracts) {
				Boolean userIsOperatorOrOwnerOfTract = false;

				for (Authority__c authority : authorities) {
					if (authority.Associated_Land__c == tract.Id && (authority.Role__c.toUpperCase() == 'OWNER' || authority.Role__c.toUpperCase() == 'OPERATOR')) {
						userIsOperatorOrOwnerOfTract = true;
					}
				}

				if (!userIsOperatorOrOwnerOfTract) {
					tract.Tract_Number__c = null;
					tract.Farmland_Acres__c = null;
					tract.Cropland_Acres__c = null;
					tract.CRP_Acres__c = null;
					tract.Hel_Code__c = null;
					tract.MPL_Acres__c = null;
					tract.NAP_Crop_Number__c = null;
					tract.Other_Conserve_Acres__c = null;
					tract.State_Conserve_Acres__c = null;
					tract.Sugarcane_Acres__c = null;
					tract.WBP_Acres__c = null;
					tract.WRP_Acres__c = null;
					tract.Wetland_Code__c = null;
					tract.Description__c = null;
					tract.Location_State_County_Code_FSA__c = null;
					tract.DCP_Cropland_Acres__c = null;
					tract.DCP_Double_Crop_Acres__c = null;
					tract.DCP_Effective_Cropland_Acres__c = null;
					tract.Grp_Acres__c = null;
					tract.Wetland_Certification_Year__c = null;
					tract.BIA_Number__c = null;
					tract.Wetland_Violation__c = 'don\'t show';
				}
			}

			// Remove fields that the user doesn't have authority to
			List<Land__c> fieldsWithAuthorities = new List<Land__c>();
			for (Land__c field : fields) {
				if (landIdsWithAuthorities.contains(field.Id)) {
					fieldsWithAuthorities.add(field);
				}
			}
			fields = fieldsWithAuthorities;

				// handle summation for farm fields
			if (userIsOperatorOrOwnerOfFarm) {
				sumFarmFields(farm, fields);
			}
		} else {
			sumFarmFields(farm, fields);
		}



		List<Land__c> landsToDisplayInRow = new List<Land__c>();
		List<String> rows = new List<String>();

		if (fields.isEmpty()) {
			if (!tracts.isEmpty()) {
				for (Land__c tract : tracts) {
					landsToDisplayInRow.add(tract);
				}
			}
		} else {
			for (Land__c field : fields) {
				landsToDisplayInRow.add(field);
			}
			for (Land__c tract : tracts) {
				Boolean childFieldFound = false;
				for (Land__c field : fields) {
					if (field.Parent_ID__c == tract.Id) {
						childFieldFound = true;
						break;
					}
				}
				if (!childFieldFound) {
					landsToDisplayInRow.add(tract);
				}
			}
		}

		rows.add('');

		for(Land__c currentLand : landsToDisplayInRow) {
			String row = '';
			Integer numberOfChildrenFields = 0;


			// Farm data
			row += clearNull(farm.Current_Year__c) + ',' +
				clearNull(farm.Farm_Number__c) + ',' +
				getStateName(farm.Admin_State_Code__c + farm.Admin_County_Code__c) + ',' +
				getCountyName(farm.Admin_State_Code__c + farm.Admin_County_Code__c) + ',' +
				clearNull(farm.FarmOperator__c) + ',' +
				clearNull(farm.MPL_Acres__c) + ',' +
				clearNull(farm.DCP_Double_Crop_Acres__c) + ',' +
				clearNull(farm.Sugarcane_Acres__c) + ',' +
				clearNull(farm.Farmland_Acres__c) + ',' +
				clearNull(farm.Cropland_Acres__c) + ',' +
				clearNull(farm.DCP_Cropland_Acres__c) + ',' +
				clearNull(farm.DCP_Effective_Cropland_Acres__c) + ',' +
				Datetime.now().format('MM/dd/yyyy') + ',' +
				(farm.Inactive_Indicator__c ? '' : 'Active') + ',' +
				clearNull(farm.Recon_Pending_Code__c) + ',' +
				getContractNumbers(fields) + ',' +
				clearNull(farm.WBP_Acres__c) + ',' +
				clearNull(farm.WRP_Acres__c) + ',' +
				clearNull(farm.Grp_Acres__c) + ',' +
				clearNull(farm.State_Conserve_Acres__c) + ',' +
				clearNull(farm.Other_Conserve_Acres__c) + ',' +
				tracts.size() + ',';

			if (currentLand.RecordType.Name == 'Field') {
				// find parent tract
				Land__c parentTract;
				for (Land__c tract : tracts) {
					if (tract.Id == currentLand.Parent_ID__c) {
						parentTract = tract;
						break;
					}
				}

				for (Land__c field : fields) {
					if (field.Parent_ID__c == parentTract.Id) {
						numberOfChildrenFields++;
					}
				}

				// Parent tract data
				row += clearNull(parentTract.Tract_Number__c) + ',' +
					clearNull(parentTract.Farmland_Acres__c) + ',' +
					clearNull(parentTract.Cropland_Acres__c) + ',' +
					clearNull(parentTract.CRP_Acres__c) + ',' +
					clearNull(parentTract.HEL_Code__c) + ',' +
					clearNull(parentTract.MPL_Acres__c) + ',' +
					clearNull(parentTract.NAP_Crop_Number__c) + ',' +
					clearNull(parentTract.Other_Conserve_Acres__c) + ',' +
					clearNull(parentTract.State_Conserve_Acres__c) + ',' +
					clearNull(parentTract.Sugarcane_Acres__c) + ',' +
					clearNull(parentTract.WBP_Acres__c) + ',' +
					clearNull(parentTract.WRP_Acres__c) + ',' +
					clearNull(parentTract.Wetland_Code__c) + ',' +
					clearNull(parentTract.Description__c) + ',' +
					getStateName(parentTract.Location_State_County_Code_FSA__c) + ',' +
					getCountyName(parentTract.Location_State_County_Code_FSA__c) + ',' +
					clearNull(parentTract.DCP_Cropland_Acres__c) + ',' +
					clearNull(parentTract.DCP_Double_Crop_Acres__c) + ',' +
					clearNull(parentTract.DCP_Effective_Cropland_Acres__c) + ',' +
					clearNull(parentTract.Grp_Acres__c) + ',' +
					clearNull(parentTract.Wetland_Certification_Year__c) + ',' +
					clearNull(parentTract.BIA_Number__c) + ',' +
					(parentTract.Wetland_Violation__c == 'don\'t show' ? '' : (String.isBlank(parentTract.Wetland_Violation__c) ? 'Yes' : 'No' ) ) + ',' +
					numberOfChildrenFields + ',';
				// Field data
				row += clearNull(currentLand.Field_Number__c) + ',' +
					clearNull(currentLand.CLU_Acreage__c) + ',' +
					getStateName(currentLand.Location_State_County_Code_FSA__c) + ',' +
					getCountyName(currentLand.Location_State_County_Code_FSA__c) + ',' +
					clearNull(currentLand.Congressional_District_Code__c) + ',' +
					clearNull(currentLand.Corpland_Indicator__c) + ',' +
					clearNull(currentLand.Conservation_Practice_Identifier__c) + ',' +
					getConservationPracticeDescription(currentLand.Conservation_Practice_Identifier__c) + ',' +
					clearNull(currentLand.CRP_Contract_Number__c) + ',' +
					clearNull(currentLand.Crop_Contract_Expiry_Date__c) + ',' +
					clearNull(currentLand.Native_SOD_Conservation_Date__c) + ',' +
					clearNull(currentLand.SOD_Conservation_Crop_Yr1__c) + ',' +
					clearNull(currentLand.SOD_Conservation_Crop_Yr2__c) + ',' +
					clearNull(currentLand.SOD_Conservation_Crop_Yr3__c) + ',' +
					clearNull(currentLand.SOD_Conservation_Crop_Yr4__c);
			} else {
				// Tract data
				row += clearNull(currentLand.Tract_Number__c) + ',' +
					clearNull(currentLand.Farmland_Acres__c) + ',' +
					clearNull(currentLand.Cropland_Acres__c) + ',' +
					clearNull(currentLand.CRP_Acres__c) + ',' +
					clearNull(currentLand.HEL_Code__c) + ',' +
					clearNull(currentLand.MPL_Acres__c) + ',' +
					clearNull(currentLand.NAP_Crop_Number__c) + ',' +
					clearNull(currentLand.Other_Conserve_Acres__c) + ',' +
					clearNull(currentLand.State_Conserve_Acres__c) + ',' +
					clearNull(currentLand.Sugarcane_Acres__c) + ',' +
					clearNull(currentLand.WBP_Acres__c) + ',' +
					clearNull(currentLand.WRP_Acres__c) + ',' +
					clearNull(currentLand.Wetland_Code__c) + ',' +
					clearNull(currentLand.Description__c) + ',' +
					getStateName(currentLand.Location_State_County_Code_FSA__c) + ',' +
					getCountyName(currentLand.Location_State_County_Code_FSA__c) + ',' +
					clearNull(currentLand.DCP_Cropland_Acres__c) + ',' +
					clearNull(currentLand.DCP_Double_Crop_Acres__c) + ',' +
					clearNull(currentLand.DCP_Effective_Cropland_Acres__c) + ',' +
					clearNull(currentLand.Grp_Acres__c) + ',' +
					clearNull(currentLand.Wetland_Certification_Year__c) + ',' +
					clearNull(currentLand.BIA_Number__c) + ',' +
					(currentLand.Wetland_Violation__c == 'don\'t show' ? '' : (String.isBlank(currentLand.Wetland_Violation__c) ? 'Yes' : 'No' ) ) + ',' +
					numberOfChildrenFields + ',';
				}
			rows.add(row);
		}

		return rows;
	}

	public FarmCSVExportController() {}

	private String clearNull(String input) {
		if(input == null) {
			return '';
		} else {
			return (input.contains(',') ?'"'+input+'"' : input);
		}
	}

	private String clearNull(Decimal input) {
		if(input == null) {
			return '';
		} else {
			return (input.format().contains(',') ? '"'+input.format()+'"' : input.format());
		}
	}

	private String clearNull(Date input) {
		if(input == null) {
			return '';
		} else {
			return (input.format().contains(',') ? '"'+input.format()+'"' : input.format());
		}
	}

	private String clearNull(Boolean input) {
		if(input == null) {
			return '';
		} else {
			return (input ? 'TRUE' : 'FALSE');
		}
	}

	private String getConservationPracticeDescription(String identifier) {
		List<CRP_Practice_Code__mdt> record = [
			SELECT Description__c
			FROM CRP_Practice_Code__mdt
			WHERE Label = :identifier
			LIMIT 1
		];
		return ( record.isEmpty() ? '' : record[0].Description__c );
	}

	private String getContractNumbers(List<Land__c> lands) {
		String contractList = '';
		for (Land__c land : lands) {
			if (!String.isBlank(land.CRP_Contract_Number__c)) {
				if (contractList != '') {
					contractList += ', ';
				}
				contractList += land.CRP_Contract_Number__c;
			}
		}
		return '"' + contractList + '"';
	}

	private String getStateName(String stateCountyCode) {
		if (String.isBlank(stateCountyCode)) {
			return '';
		} else {
			List<FIPS_County_Code__mdt> record = [SELECT FIPS_State_Code__r.DeveloperName FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c = :stateCountyCode LIMIT 1];
			return ( record.isEmpty() ? '' : record[0].FIPS_State_Code__r.DeveloperName );
		}
	}

	private String getCountyName(String stateCountyCode) {
		if (String.isBlank(stateCountyCode)) {
			return '';
		} else {
			List<FIPS_County_Code__mdt> record = [SELECT MasterLabel FROM FIPS_County_Code__mdt WHERE FIPS_County_Code__c = :stateCountyCode LIMIT 1];
			return ( record.isEmpty() ? '' : record[0].MasterLabel );
		}
	}

	private Boolean isUserAdminOrEmployee() {
		User user = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		if(user.Profile.Name == SYSTEM_ADMIN || user.Profile.Name == EMPLOYEE_BASE_PROFILE || user.Profile.Name == EMPLOYEE_MANAGER_PROFILE){
			return true;
		} else {
			return false;
		}
	}

	private void sumFarmFields(Land__c farm, List<Land__c> fields) {
		Decimal mplAcres = 0;
		farm.DCP_Double_Crop_Acres__c = 0;
		farm.Sugarcane_Acres__c = 0;
		farm.Farmland_Acres__c = 0;
		farm.Cropland_Acres__c = 0;
		farm.DCP_Cropland_Acres__c = 0;
		farm.DCP_Effective_Cropland_Acres__c = 0;
		farm.WBP_Acres__c = 0;
		farm.WRP_Acres__c = 0;
		farm.Grp_Acres__c = 0;
		for (Land__c field : fields) {
			if (!String.isBlank(field.MPL_Acres__c)) {
				mplAcres += Decimal.valueOf(field.MPL_Acres__c);
			}
			if (field.DCP_Double_Crop_Acres__c != null) {
				farm.DCP_Double_Crop_Acres__c += field.DCP_Double_Crop_Acres__c;
			}
			if (field.Sugarcane_Acres__c != null) {
				farm.Sugarcane_Acres__c += field.Sugarcane_Acres__c;
			}
			if (field.Farmland_Acres__c != null) {
				farm.Farmland_Acres__c += field.Farmland_Acres__c;
			}
			if (field.Cropland_Acres__c != null) {
				farm.Cropland_Acres__c += field.Cropland_Acres__c;
			}
			if (field.DCP_Cropland_Acres__c != null) {
				farm.DCP_Cropland_Acres__c += field.DCP_Cropland_Acres__c;
			}
			if (field.DCP_Effective_Cropland_Acres__c != null) {
				farm.DCP_Effective_Cropland_Acres__c += field.DCP_Effective_Cropland_Acres__c;
			}
			if (field.WBP_Acres__c != null) {
				farm.WBP_Acres__c += field.WBP_Acres__c;
			}
			if (field.WRP_Acres__c != null) {
				farm.WRP_Acres__c += field.WRP_Acres__c;
			}
			if (field.Grp_Acres__c != null) {
				farm.Grp_Acres__c += field.Grp_Acres__c;
			}
		}
		farm.MPL_Acres__c = mplAcres.format();
	}
}

/*-----------------------------------------------------------------------------\

                                FIELD MAPPING

                CSV FILE                |   RECORD      |   SF OBJECT FIELD
--------------------------------------------------------------------------------
farmYear                                farm            Current_Year__c
farmNumber                              farm            Farm_Number__c
adminStateName                          farm            Admin_State_Code__c
adminCountyName                         farm            Admin_County_Code__c
operatorName                            farm            FarmOperator__c
farmMplAcres                            farm            MPL_Acres__c
farmDcpDoubleCropAcres                  farm            DCP_Double_Crop_Acres__c
farmSugarCaneAcres                      farm            Sugarcane_Acres__c
farmland                                farm            Farmland_Acres__c
farmCropland                            farm            Cropland_Acres__c
farmDcpCropland                         farm            DCP_Cropland_Acres__c
farmEffectiveDcpCropland                farm            DCP_Effective_Cropland_Acres__c
reportDate                              N/A             Datetime.now().format('d/M/yyyy')
farmStatus                              farm            (farm.Inactive_Indicator__c ? '' : 'Active')
reconPendingCode                        farm            Recon_Pending_Code__c
crpContracts                            field           CRP_Contract_Number__c (csv list of these values from a field level)
farmWbpAcres                            farm            WBP_Acres__c
farmWrpAcres                            farm            WRP_Acres__c
farmGrpAcres                            farm            Grp_Acres__c
farmStateConservationAcres              farm            State_Conserve_Acres__c
farmOtherConservationAcres              farm            Other_Conserve_Acres__c
numberOfTracts                          N/A             sum children tracts of farm that user it authorized to see if they aren't an employee
tractNumber                             tract           Tract_Number__c
tractFarmLandAcres                      tract           Farmland_Acres__c
tractCroplandAcres                      tract           Cropland_Acres__c
tractCrpAcres                           tract           CRP_Acres__c
tractHelStatus                          tract           Hel_Code__c
tractMplAcres                           tract           MPL_Acres__c
tractNapCropAcres                       tract           NAP_Crop_Number__c
tractOtherConsrvAcres                   tract           Other_Conserve_Acres__c
tractStateConsrvAcres                   tract           State_Conserve_Acres__c
tractSugarcaneAcres                     tract           Sugarcane_Acres__c
tractWbpAcres                           tract           WBP_Acres__c
tractWrpAcres                           tract           WRP_Acres__c
tractWetlandStatus                      tract           Wetland_Code__c
tractDescription                        tract           Description__c
tractLocationStateName                  tract           Location_State_County_Code_FSA__c
tractLocationCountyName                 tract           Location_State_County_Code_FSA__c
tractDcpCroplandAcres                   tract           DCP_Cropland_Acres__c
tractDcpDoubleCropAcres                 tract           DCP_Double_Crop_Acres__c
tractDcpEffectiveCroplandAcres          tract           DCP_Effective_Cropland_Acres__c
tractGrpAcres                           tract           Grp_Acres__c
wetlandCertYear                         tract           Wetland_Certification_Year__c
biaUnitRangeNumber                      tract           BIA_Number__c
wetlandViolations                       tract           Wetland_Violation__c (yes or no if the field is empty)
numberOfFields                          N/A             sum children fields of tract
fieldNumber                             field           Field_Number__c
fieldAcreage                            field           CLU_Acreage__c
fieldLocationStateName                  field           Location_State_County_Code_FSA__c
fieldLocationCountyName                 field           Location_State_County_Code_FSA__c
fieldCongressionalDistrictCode          field           Congressional_District_Code__c
fieldCroplandIndicator3cm               field           Corpland_Indicator__c
fieldConservationPracticeIdentifier     field           Conservation_Practice_Identifier__c
fieldConservationPracticeDescription    field           lookup Conservation_Practice_Identifier__c in metadata type "CRP Practice Code" to get description
fieldCrpContractNumber                  field           CRP_Contract_Number__c
fieldCrpContractExpirationDate          field           Crop_Contract_Expiry_Date__c
fieldNativeSodConversionDate            field           Native_SOD_Conservation_Date__c
fieldSodConversionCropYear1             field           SOD_Conservation_Crop_Yr1__c
fieldSodConversionCropYear2             field           SOD_Conservation_Crop_Yr2__c
fieldSodConversionCropYear3             field           SOD_Conservation_Crop_Yr3__c
fieldSodConversionCropYear4             field           SOD_Conservation_Crop_Yr4__c

*/
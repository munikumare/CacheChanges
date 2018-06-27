public with sharing class FPAC_RMA_ServiceMockImpl implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest req) {
     	
     	string json = '';
    	string endPoint = req.getEndpoint();
    	
		if (endPoint.indexOf('producers') != -1)
                json = RetrieveProducerPolicies();
                                    
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
    
    private string RetrieveProducerPolicies()
    {
    	return '[' +
		  '{' +
		    '"ReinsuranceYear": 2017,' +
		    '"PolicyProducerId": 0,' +
		    '"PolicyID": 5713225,' +
		    '"AipCode": "WN",' +
		    '"AipPolicyProducerKey": "P10_2506309",' +
		    '"PicCode": "601",' +
		    '"LocationStateCode": "48",' +
		    '"PolicyNumber": "0727959",' +
		    '"TaxIdLastFourDigits": "0440",' +
		    '"TaxIDTypeCode": "1",' +
		    '"EntityTypeCode": "S",' +
		    '"LastName": null,' +
		    '"FirstName": null,' +
		    '"MiddleName": null,' +
		    '"Suffix": null,' +
		    '"Title": null,' +
		    '"BusinessName": "Carl & Kara Hoelscher JV",' +
		    '"RelationshipTypeCode": "N",' +
		    '"BranchOfficeCode": "TX",' +
		    '"UninsurableSbiFlag": "N",' +
		    '"AcreageMeasurementProvidedCode": null,' +
		    '"FsaRmaEntityDifferenceCode": null,' +
		    '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		    '"BatchNumber": 353,' +
		    '"ProgramIndicatorCodeList": null,' +
		    '"AppliedProgramIndicatorCodeList": null,' +
		    '"ComplianceCertificationCode": null,' +
		    '"InsuranceInForces": [' +
		      '{' +
		        '"ReinsuranceYear": 2017,' +
		        '"AipCode": "WN",' +
		        '"AipPolicyProducerKey": "P10_2506309",' +
		        '"AipInsuranceInForceKey": "P14_18579310",' +
		        '"AipInsuranceAgentKey": "P55_2290",' +
		        '"LocationCountyCode": "383",' +
		        '"CommodityYear": 2017,' +
		        '"CommodityCode": "0011",' +
		        '"CommodityTypeCode": null,' +
		        '"InsurancePlanCode": "02",' +
		        '"TypeCode": null,' +
		        '"PracticeCode": null,' +
		        '"ClassCode": null,' +
		        '"SubClassCode": null,' +
		        '"IntendedUseCode": null,' +
		        '"IrrigationPracticeCode": null,' +
		        '"CroppingPracticeCode": null,' +
		        '"OrganicPracticeCode": null,' +
		        '"IntervalCode": null,' +
		        '"WANumber": null,' +
		        '"CoverageTypeCode": "A",' +
		        '"LateReportedReasonCode": "07",' +
		        '"DualCoverageFlag": "N",' +
		        '"InsuredCommoditySignatureDate": "2006-09-12T00:00:00",' +
		        '"AgentCommoditySignatureDate": "2006-09-12T00:00:00",' +
		        '"FeePrepaidFlag": "N",' +
		        '"FSAAdministrationStateCode": null,' +
		        '"FSAAdministrationCountyCode": null,' +
		        '"AdministrativeFeeWaiverCode": null,' +
		        '"CancellationTransferSignedFlag": "N",' +
		        '"CoverageLevelPercent": 0.7,' +
		        '"PriceElectionPercent": 1,' +
		        '"DisputeSettlementCode": null,' +
		        '"DisputeNotificationDate": null,' +
		        '"InsuranceOptionCodeList": "YA,YE",' +
		        '"PriceIndicatorCode": "E",' +
		        '"AddedCountyIndicatorCode": "S",' +
		        '"AddedCountyAipPolicyProducerKey": "P10_2506309",' +
		        '"AddedCountyAipInsuranceInForceKey": "P14_18434456",' +
		        '"LockdownInsurancePlanCode": "2 ",' +
		        '"LockdownPriceElectionPercent": 1,' +
		        '"LockdownCoverageLevelPercent": 0.7,' +
		        '"LrrPercent": 0,' +
		        '"LockdownPriceIndicatorCode": "E",' +
		        '"LrrCode": "00",' +
		        '"LrrTransactionCutoffDate": "2016-11-04T20:00:00",' +
		        '"LrrChangeDate": null,' +
		        '"LrrTransactionCode": "6 ",' +
		        '"LrrRecordAcceptedDate": "2016-12-30T01:01:36.237",' +
		        '"IneligibleSBISharePercent": null,' +
		        '"DuplicatePolicyCode": null,' +
		        '"DuplicateAipCode": null,' +
		        '"DuplicatePicCode": null,' +
		        '"DuplicatePolicyNumber": null,' +
		        '"ContractCarryoverFlag": "N",' +
		        '"EligibilityCode": null,' +
		        '"ProducerHistoryCode": null,' +
		        '"PrimaryFundCode": "A",' +
		        '"FsaRmaEntityDifferenceCode": null,' +
		        '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		        '"BatchNumber": 353,' +
		        '"PercentOfValue": null,' +
		        '"EntityCertificationCode": null,' +
		        '"ApprovedProgramIndicatorCodeList": null,' +
		        '"AssociatedAipPolicyProducerKey": null,' +
		        '"AssociatedAipInsuranceInForceKey": null,' +
		        '"CoverageRange": null,' +
		        '"PolicyCancellationCode": null,' +
		        '"Acreages": [' +
		          '{' +
		            '"ReinsuranceYear": 2017,' +
		            '"AipCode": "WN",' +
		            '"AipPolicyProducerKey": "P10_2506309",' +
		            '"AipInsuranceInForceKey": "P14_18579310",' +
		            '"AipAcreageKey": "P11_10853424",' +
		            '"CommodityTypeCode": "997",' +
		            '"TypeCode": "011",' +
		            '"PracticeCode": "003",' +
		            '"AipInsuranceAgentKey": "P55_2290",' +
		            '"AipYieldKey": "P15_9602595",' +
		            '"BasicUnitNumber": "0001",' +
		            '"OptionalUnitNumber": "0001",' +
		            '"UnitStructureCode": "BU",' +
		            '"ClassCode": "091",' +
		            '"SubClassCode": "997",' +
		            '"IntendedUseCode": "997",' +
		            '"IrrigationPracticeCode": "003",' +
		            '"CroppingPracticeCode": "997",' +
		            '"OrganicPracticeCode": "997",' +
		            '"IntervalCode": "997",' +
		            '"RangeClassCode": null,' +
		            '"NonPremiumAcreageCode": null,' +
		            '"WANumber": null,' +
		            '"WALandId": null,' +
		            '"SubCountyCode": null,' +
		            '"MeasurementServiceCode": null,' +
		            '"InsuranceOptionCodeList": null,' +
		            '"InsuredAcreageSignatureDate": "2016-12-16T00:00:00",' +
		            '"AgentAcreageSignatureDate": "2016-12-16T00:00:00",' +
		            '"ReportedTreeCount": null,' +
		            '"ReportedPounds": null,' +
		            '"AipTotalPremiumAmount": 2359,' +
		            '"AipLiabilityAmount": 5436,' +
		            '"AipSubsidyAmount": 1392,' +
		            '"AdditionalSubsidyFlag": null,' +
		            '"StatePrivateSubsidyFlag": null,' +
		            '"GuaranteeAdjustmentTypeCode": null,' +
		            '"GuaranteeAdjustmentQualifyingCommodityCode": null,' +
		            '"GuaranteeAdjustmentQualifyingBasicUnitNumber": null,' +
		            '"GuaranteeAdjustmentQualifyingOptionalUnitNumber": null,' +
		            '"ApprovedYield": 18,' +
		            '"InsuredSharePercent": 0.5,' +
		            '"ModifiedAcreageCode": "00",' +
		            '"PriceElectionAmount": 4.59,' +
		            '"PriceElectionPercent": 1,' +
		            '"ContractPrice": null,' +
		            '"ExperienceFactor": 1,' +
		            '"ReportedAcreage": 188,' +
		            '"ReportedTons": null,' +
		            '"ReportedColonies": null,' +
		            '"SectionCount": null,' +
		            '"PlantedDate": "2016-12-06T00:00:00",' +
		            '"SkipRowCode": null,' +
		            '"SkipRowWidth": null,' +
		            '"PremiumMultipleCroppingCode": null,' +
		            '"YieldConversionFactor": null,' +
		            '"SurchargeAppliedFlag": "N",' +
		            '"SeedCompanyCode": null,' +
		            '"UnitPremiumAdjustmentFactor": null,' +
		            '"CeoCoverageLevelPercent": null,' +
		            '"SettlementFlag": null,' +
		            '"PrivatePolicyCode": null,' +
		            '"WarehouseCode": null,' +
		            '"CatLossAdjustmentExpenseAmount": 0,' +
		            '"ProrationPercent": null,' +
		            '"GuaranteeAdjustmentFactor": 1,' +
		            '"SeedCycleCode": "F",' +
		            '"ResidualFactor": null,' +
		            '"UnitLiabilityAmount": 5436,' +
		            '"SubsidyAmount": 1392,' +
		            '"LiabilityAmount": 5436,' +
		            '"TotalPremiumAmount": 2359,' +
		            '"ProducerPremiumAmount": 967,' +
		            '"BasePremiumRate": 0.54122044,' +
		            '"PreliminaryBaseRate": null,' +
		            '"AcreLoadedPremiumAmount": null,' +
		            '"AdditionalSubsidyAmount": null,' +
		            '"StatePrivateSubsidyAmount": null,' +
		            '"AOExpenseSubsidyAmount": 436.42,' +
		            '"TotalGuaranteeAmount": 10872.79,' +
		            '"UnitStructureDiscountFactor": 0.733,' +
		            '"DollarAmountOfInsurance": null,' +
		            '"AcreGuaranteeQuantity": 12.6,' +
		            '"CommodityCroppingStatusCode": null,' +
		            '"CommodityPlantingStatusCode": null,' +
		            '"CommodityMultiplePlantingStatusCode": null,' +
		            '"PreventedPlantingCommodityCode": null,' +
		            '"PreventedPlantingProcessingCode": null,' +
		            '"AcreageGroupKey": null,' +
		            '"StandPercent": 1,' +
		            '"InitialAcceptedBatchNumber": 157,' +
		            '"InitialAcceptedDate": "2016-12-30T01:01:36.237",' +
		            '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		            '"BatchNumber": 353,' +
		            '"BFRSubsidyAmount": 0,' +
		            '"ProgramIndicatorCodeList": null,' +
		            '"NativeSodSubsidyAmount": 0,' +
		            '"AssociatedAipAcreageKey": null,' +
		            '"TotalInsuredAcreage": null,' +
		            '"TotalInsuredColonies": null,' +
		            '"PercentOfValue": null,' +
		            '"CoverageRange": null,' +
		            '"ExpectedCommodityValue": null,' +
		            '"CCSubsidyReductionAmount": 0,' +
		            '"BetaValue": null,' +
		            '"AlphaValue": null,' +
		            '"SigmaValue": null,' +
		            '"SimpleAverageAnnualYield": null,' +
		            '"SimpleAverageCountyYield": null,' +
		            '"SumCrossProductValue": null,' +
		            '"SumCountyYieldDeviationValue": null,' +
		            '"UnreportedNSYearList": null' +
		          '}' +
		        '],' +
		        '"InventoryLossDetails": [],' +
		        '"InventoryValues": [],' +
		        '"Lands": [' +
		          '{' +
		            '"ReinsuranceYear": 2017,' +
		            '"AipCode": "WN",' +
		            '"AipPolicyProducerKey": "P10_2506309",' +
		            '"AipInsuranceInForceKey": "P14_18579310",' +
		            '"AipLandKey": "1P27_SA4jk2",' +
		            '"AipAcreageKey": "P11_10853424",' +
		            '"AipInventoryValueKey": null,' +
		            '"HighRiskLandCode": null,' +
		            '"ReportedLandTypeCode": "C",' +
		            '"LandIdentifier": null,' +
		            '"CluID": null,' +
		            '"FsaFarmNumber": "672    ",' +
		            '"FsaTractNumber": "599    ",' +
		            '"FsaFieldNumber": "8      ",' +
		            '"FsaSubFieldIdentifier": null,' +
		            '"FsaIntendedUse": null,' +
		            '"FsaAdministrativeStateCode": "48",' +
		            '"FsaAdministrativeCountyCode": "383",' +
		            '"CluDeterminationCode": "P",' +
		            '"CimsCluReleaseDate": null,' +
		            '"Latitude": null,' +
		            '"Longitude": null,' +
		            '"ReportedAcreage": 43.3,' +
		            '"ActualPlantedDate": "2016-12-06T00:00:00",' +
		            '"FsaRmaCluDifferenceCode": null,' +
		            '"ValidCluId": "966afc32-3a04-4f03-9487-43ed87b80398",' +
		            '"SurveyStatusCode": null,' +
		            '"InitialAcceptedBatchNumber": 157,' +
		            '"InitialAcceptedDate": "2016-12-30T01:01:36.237",' +
		            '"RecordTypeCode": "P27",' +
		            '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		            '"BatchNumber": 353,' +
		            '"RluId": null,' +
		            '"ValidRluId": null' +
		          '}' +
		        '],' +
		        '"WFRPFarmReports": [],' +
		        '"WFRPIndemnities": [],' +
		        '"Yields": [' +
		          '{' +
		            '"ReinsuranceYear": 2017,' +
		            '"YieldId": 8935294,' +
		            '"InsuranceInForceID": 13710344,' +
		            '"AipCode": "WN",' +
		            '"AipPolicyProducerKey": "P10_2506309",' +
		            '"AipInsuranceInforceKey": "P14_18579310",' +
		            '"AipYieldKey": "P15_9602595",' +
		            '"PracticeCode": "003",' +
		            '"TypeCode": "011",' +
		            '"BasicUnitNumber": "0001",' +
		            '"OptionalUnitNumber": "0001",' +
		            '"SubCountyCode": null,' +
		            '"RecordTypeCode": "P15",' +
		            '"AphProceduralExceptionNumber": null,' +
		            '"AphProceduralExceptionCode": null,' +
		            '"CommodityTypeCode": "997",' +
		            '"ClassCode": "091",' +
		            '"SubClassCode": "997",' +
		            '"IntendedUseCode": "997",' +
		            '"IrrigationPracticeCode": "003",' +
		            '"CroppingPracticeCode": "997",' +
		            '"OrganicPracticeCode": "997",' +
		            '"IntervalCode": "997",' +
		            '"WANumber": null,' +
		            '"ActualYieldYearCount": 0,' +
		            '"PerennialSetOutYearMonthNumber": null,' +
		            '"PerennialLeafYearCount": null,' +
		            '"PerennialDensityQuantity": null,' +
		            '"PerennialBlockNumber": null,' +
		            '"PerennialTYieldFactor": null,' +
		            '"PerennialSpecialCaseCode": null,' +
		            '"PerennialOtherCharacteristicsCode": null,' +
		            '"PerennialGraftingYearMonthNumber": null,' +
		            '"YieldLimitationCode": "04",' +
		            '"PreviousYearYieldLimitationCode": null,' +
		            '"PreviousYearApprovedYield": 0,' +
		            '"TransitionalYield": 18,' +
		            '"RateYield": 18,' +
		            '"AverageYield": 18,' +
		            '"ApprovedYield": 18,' +
		            '"YieldIndicatorCode": null,' +
		            '"YieldIndexNumber": null,' +
		            '"InsuranceOptionCodeList": null,' +
		            '"FSAYield": null,' +
		            '"FsaFarmNumber": null,' +
		            '"YieldOptionCodeList": null,' +
		            '"AdjustedYield": null,' +
		            '"InitialAcceptedDate": "2016-12-30T01:01:36.237",' +
		            '"InitialAcceptedBatchNumber": 157,' +
		            '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		            '"BatchNumber": 353,' +
		            '"WALandID": null,' +
		            '"AssociatedInsurancePlanCode": null,' +
		            '"YieldHistories": [' +
		              '{' +
		                '"ReinsuranceYear": 2017,' +
		                '"AipCode": "WN",' +
		                '"AipPolicyProducerKey": "P10_2506309",' +
		                '"AipInsuranceInForceKey": "P14_18579310",' +
		                '"AipYieldKey": "P15_9602595",' +
		                '"Year10AipYieldHistoryKey": "P15A_97067898",' +
		                '"Year10YieldCommodityYear": 2016,' +
		                '"Year10YieldTypeCode": "I ",' +
		                '"Year10AnnualYield": 18,' +
		                '"Year10AnnualProduction": 0,' +
		                '"Year10YieldAcreage": 0,' +
		                '"Year10AverageAcreProduction": null,' +
		                '"Year10SkipRowCode": null,' +
		                '"Year10SkipRowWidth": null,' +
		                '"Year10YAAdjustedYield": 11' +
		              '}' +
		            ']' +
		          '}' +
		        '],' +
		        '"Productions": [],' +
		        '"ProductionLossDetails": [' +
		          '{' +
		            '"ReinsuranceYear": 2017,' +
		            '"AipCode": "WN",' +
		            '"AipPolicyProducerKey": "P10_2506309",' +
		            '"AipInsuranceInForceKey": "P14_18579310",' +
		            '"AIPProductionLossDetailKey": "P21_1920442",' +
		            '"ClaimNumber": "72795901",' +
		            '"AipAcreageKey": "P11_10853424",' +
		            '"AipAdjusterKey": "P56_1413",' +
		            '"InsuredLossSignatureDate": "2017-07-10T00:00:00",' +
		            '"AdjusterSignatureDate": "2017-07-10T00:00:00",' +
		            '"AIPIndemnityAmount": 4600,' +
		            '"LargeClaimCode": null,' +
		            '"SettlementFlag": null,' +
		            '"StageCode": "H ",' +
		            '"DeterminedTons": null,' +
		            '"DeterminedAcreage": 188,' +
		            '"DeterminedColonies": null,' +
		            '"DeterminedTreeCount": null,' +
		            '"DeterminedPounds": null,' +
		            '"FirstDamageCauseCode": "11",' +
		            '"FirstDamageDate": "2017-02-01T00:00:00",' +
		            '"FirstDamagePercent": 1,' +
		            '"SecondDamageCauseCode": null,' +
		            '"SecondDamageDate": null,' +
		            '"SecondDamagePercent": null,' +
		            '"ThirdDamageCauseCode": null,' +
		            '"ThirdDamageDate": null,' +
		            '"ThirdDamagePercent": null,' +
		            '"WANumber": null,' +
		            '"ReplantPaymentFlag": null,' +
		            '"GleanedAcreageCode": null,' +
		            '"HarvestedProductionQuantity": 1673.06,' +
		            '"ProductionToCountQuantity": 364.5,' +
		            '"UnitDeficiencyQuantity": 9199.73,' +
		            '"AcreStageGuaranteeAmount": 57.83,' +
		            '"SugarFactor": null,' +
		            '"MultipleCroppingExceptionFlag": "N",' +
		            '"LossMultipleCroppingCode": "NS",' +
		            '"LiabilityAdjustmentFactor": 1,' +
		            '"ClaimProcessCode": null,' +
		            '"FirstNoticeOfLossDate": "2017-07-06T00:00:00",' +
		            '"LastNoticeOfLossDate": null,' +
		            '"AuditCorrectionFlag": "N",' +
		            '"RevenueConversionProductionToCountQuantity": 1673.06,' +
		            '"LossGuaranteeAmount": 10872.79,' +
		            '"SecondCommodityWaivedIndemnityAmount": null,' +
		            '"PreliminaryIndemnityAmount": 4600,' +
		            '"IndemnityAmount": 4600,' +
		            '"ValidEscrowFlag": "Y",' +
		            '"PriceIndicatorCode": "E",' +
		            '"MisreportedInformationFactor": 1,' +
		            '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		            '"BatchNumber": 353,' +
		            '"TotalProductionAmount": null,' +
		            '"AIPEmployeeKey": null,' +
		            '"StagePercentFactor": 1,' +
		            '"ReportedLiabilityBeforeShareAmount": null,' +
		            '"DeterminedLiabilityBeforeShareAmount": null,' +
		            '"PreQAAppraisedProductionAmount": null,' +
		            '"PostQAAppraisedProductionAmount": null,' +
		            '"UninsuredCauseProductionAmount": null,' +
		            '"PreQAHarvestedProductionAmount": null,' +
		            '"QATypeCodeList": null,' +
		            '"AssociatedAipProductionLossDetailKey": null' +
		          '}' +
		        ']' +
		      '}' +
		    '],' +
		    '"PolicyProducerOtherPersons": [' +
		      '{' +
		        '"ReinsuranceYear": 2017,' +
		        '"AipCode": "WN",' +
		        '"AipPolicyProducerKey": "P10_2506309",' +
		        '"AipPolicyProducerOtherPersonKey": "P10B_730675",' +
		        '"BusinessName": null,' +
		        '"LastName": "Hoelscher",' +
		        '"FirstName": "Kara",' +
		        '"MiddleName": null,' +
		        '"Suffix": null,' +
		        '"Title": null,' +
		        '"Street1Address": "1150 COUNTY ROAD 150",' +
		        '"Street2Address": null,' +
		        '"CityName": "GARDEN CITY",' +
		        '"StateAbbreviation": "TX",' +
		        '"ZipCode": "79739",' +
		        '"ZipExtensionCode": "2627",' +
		        '"PhoneNumberExceptionCode": null,' +
		        '"PhoneNumber": "4323972658",' +
		        '"PhoneExtensionNumber": null,' +
		        '"InternationalAddress": null,' +
		        '"InternationalCountryCode": null,' +
		        '"InternationalPhoneCountryCode": null,' +
		        '"LandlordTenantFlag": "N",' +
		        '"IneligibleSBIFlag": "N",' +
		        '"IneligibleSBISharePercent": null,' +
		        '"EligibilityCode": null,' +
		        '"SsnValidationCode": null,' +
		        '"FSARMAEntityDifferenceCode": null,' +
		        '"BatchReceivedDate": "2017-07-26T05:42:21.537",' +
		        '"BatchNumber": 353,' +
		        '"ComplianceCertificationCode": null,' +
		        '"AppliedProgramIndicatorCodeList": null' +
		      '}' +
		    ']' +
		  '}' +
		']';
                                    			  
    }
    
}
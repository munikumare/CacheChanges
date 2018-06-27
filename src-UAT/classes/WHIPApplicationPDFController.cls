public with sharing class WHIPApplicationPDFController {
	public final String PREVENTED_PLANTING = 'Prevented Planting';
	private Map<Id, WHIPNoticeofLoss__c> noticeOfLossesByIds {get;private set;}
	private Map<Id, List<WHIPLossInformation__c>> lossInformationsByNoticeOfLossIds {get;private set;}
	private Map<Id, List<WHIPLossInformation__c>> lossInformationsByPayGroupIds {get;private set;}
	private Map<Id, WHIPPayGroup__c> payGroupsByIds {get;private set;}
	private Id appId;

	public AppWrapper app {get;private set;}

	public WHIPApplicationPDFController() {
		this.appId = ApexPages.currentPage().getParameters().get('id');
		this.app = new AppWrapper();
		this.noticeOfLossesByIds = getNoticeOfLossesByIds();
		this.lossInformationsByNoticeOfLossIds = getWhipLossInformationsByNoticeOfLossIds();
		this.lossInformationsByPayGroupIds = getWhipLossInformationsByPayGroupIds();
		this.payGroupsByIds = getPayGroupsByIds();
		initWrapperObject();
	}
	private Map<Id, List<WHIPLossInformation__c>> getWhipLossInformationsByNoticeOfLossIds(){
		Map<Id, WHIPLossInformation__c> lossInformationsByIds = getWhipLossInformationsByIds();
		Map<Id, List<WHIPLossInformation__c>> lossInformationsByNoticeOfLossIds = new Map<Id, List<WHIPLossInformation__c>>();
		for(WHIPLossInformation__c lossInformation :lossInformationsByIds.values()){
			if(lossInformationsByNoticeOfLossIds.containsKey(lossInformation.WHIPNoticeofLoss__c)){
				lossInformationsByNoticeOfLossIds.get(lossInformation.WHIPNoticeofLoss__c).add(lossInformation);
			} else {
				lossInformationsByNoticeOfLossIds.put(lossInformation.WHIPNoticeofLoss__c, new List<WHIPLossInformation__c>{lossInformation});
			}
		}
		return lossInformationsByNoticeOfLossIds;
	}
	private Map<Id, List<WHIPLossInformation__c>> getWhipLossInformationsByPayGroupIds(){
		Map<Id, WHIPLossInformation__c> lossInformationsByIds = getWhipLossInformationsByIds();
		Map<Id, List<WHIPLossInformation__c>> lossInformationsByPayGroupIds = new Map<Id, List<WHIPLossInformation__c>>();
		for(WHIPLossInformation__c lossInformation:lossInformationsByIds.values()){
			if(lossInformationsByPayGroupIds.containsKey(lossInformation.WHIP_Pay_Group__c)){
				lossInformationsByPayGroupIds.get(lossInformation.WHIP_Pay_Group__c).add(lossInformation);
			} else {
				lossInformationsByPayGroupIds.put(lossInformation.WHIP_Pay_Group__c, new List<WHIPLossInformation__c>{lossInformation});
			}
		}
		return lossInformationsByPayGroupIds;
	}
	private WHIP_Application__c getWhipApp(){
		return [
			SELECT Id,Approved__c,ProducersName__c,Address__c,AdminStateName__c,AdminStateCode__c,Remarks__c,
					AdminCountyName__c,AdminCountyCode__c,WhatDisasterCausedtheLoss__c,DisasterStartDate__c,DisasterEndDate__c,
			(SELECT Id FROM WHIP_Notice_of_Loss__r),
			(SELECT Id FROM WHIP_Pay_Groups__r)
			FROM WHIP_Application__c
			WHERE Id = :this.appId
		];
	}
	private Map<Id, WHIPPayGroup__c> getPayGroupsByIds(){
		return new Map<Id, WHIPPayGroup__c>([
				SELECT Id, Name,Unit__c,PayCropCode__c,PayTypeCode__c, ApprovalStatus__c,PhysicalStateNameCode__c,PhysicalCountyNameCode__c
				FROM WHIPPayGroup__c
				WHERE WHIPApplicationPayGroup__c = :this.appId
		]);
	}
	private Map<Id, WHIPNoticeofLoss__c> getNoticeOfLossesByIds(){
		return new Map<Id, WHIPNoticeofLoss__c>([
			SELECT Id, CropYear__c,Crop__c,CropType__c,IntendedUse__c,Practice__c,PlantingPeriod__c,CoverageType__c,LossType__c,CultivationPraticesComment__c,
					COCStatus__c,PreventionComment__c,PurchDelivArrangSdChemFert__c,SeedChemicalandFertilizerComment__c,PurchDelivArrangLandPrepMeas__c,LandPreparationMeasuresComment__c,Final_Planting_date__c
			FROM WHIPNoticeofLoss__c
			WHERE WHIP_Application__c = :this.appId
		]);
	}
	private Map<Id, WHIPLossInformation__c> getWhipLossInformationsByIds(){
		return new Map<Id, WHIPLossInformation__c>([
			SELECT Id,RecordType.Name,WHIPNoticeofLoss__c, WHIP_Pay_Group__c, CrushingDistrict__c,OrganicStatus__c, NativeSod__c,Acres__c,Share__c,Stage__c,
					Unit_of_Measure__c,ProductiontoCount__c, YieldFLOnly__c, AssignedAdjustedProduction__c, SecondaryUseorSalvah__c,ShareVL__c,SharePL__c,Secondary_Use_or_Salvage_Value__c,
					DollarValueBeforeDisaster__c, DollarValueAfterDisaster__c, IneligibleDollarValue__c,
					NumberinStageBlock1__c, NumberinStageBlock2__c, NumberinStageBlock3__c,
					NumberDamagedSB1__c,NumberDamagedSB2__c,NumberDamagedSB3__c,
					NumberDestroyedSB1__c,NumberDestroyedSB2__c,NumberDestroyedSB3__c,
					AssignedorAdjustedNumberSB1__c,AssignedorAdjustedNumberSB2__c,AssignedorAdjustedNumberSB3__c,
					AssignedorAdjustedNumberDamagedSB1__c,AssignedorAdjustedNumberDamagedSB2__c,AssignedorAdjustedNumberDamagedSB3__c,
					AssignedorAdjustedNumberDestroyedSB1__c,AssignedorAdjustedNumberDestroyedSB2__c,AssignedorAdjustedNumberDestroyedSB3__c,
					SecondaryUseorSalvageValueSB1__c, SecondaryUseorSalvageValueSB2__c,SecondaryUseorSalvageValueSB3__c
			FROM WHIPLossInformation__c
			WHERE WHIP_Pay_Group__r.WHIPApplicationPayGroup__c = :this.appId OR WHIPNoticeofLoss__r.WHIP_Application__c = :this.appId
		]);
	}
	private void initWrapperObject(){
		this.app = new AppWrapper();
		this.app.record = getWhipApp();

		//set notice of loss
		for(WHIPNoticeofLoss__c nol : this.app.record.WHIP_Notice_of_Loss__r){
			//set child records.
			if(this.noticeOfLossesByIds.containsKey(nol.Id)) {
				NoticeOfLossWrapper nolWrapper = new NoticeOfLossWrapper();
				nolWrapper.record = this.noticeOfLossesByIds.get(nol.Id);
				if(this.lossInformationsByNoticeOfLossIds.containsKey(nol.Id)) {
					nolWrapper.lossInformations.addAll(this.lossInformationsByNoticeOfLossIds.get(nol.Id));
				}
				app.noticeOfLosses.add(nolWrapper);
			}
		}
		//set hasPreventedPlantingCrops
		for(NoticeOfLossWrapper nolWrapper : this.app.noticeOfLosses){
			if(nolWrapper.record.LossType__c != null && nolWrapper.record.LossType__c == PREVENTED_PLANTING){
				this.app.hasPreventedPlantingCrops = true;
			}
		}
		//Pay group -> notice of loss -> loss informations.
		for(WHIPPayGroup__c payGroup : this.app.record.WHIP_Pay_Groups__r){

			PayGroupWrapper payGroupWrapper = new PayGroupWrapper();
			payGroupWrapper.record = this.payGroupsByIds.get(payGroup.Id);

			if(this.lossInformationsByPayGroupIds.containsKey(payGroup.Id)) {
				List<WHIPLossInformation__c> payGroupLossInformations = this.lossInformationsByPayGroupIds.get(payGroup.Id);
				Map<Id, List<WHIPLossInformation__c>> payGroupLossInformationsByNolIds = new Map<Id, List<WHIPLossInformation__c>>();
				for(WHIPLossInformation__c lossInformation: payGroupLossInformations){
					if(lossInformation.WHIPNoticeofLoss__c != null && this.noticeOfLossesByIds.containsKey(lossInformation.WHIPNoticeofLoss__c)){
						WHIPNoticeofLoss__c parentNol = this.noticeOfLossesByIds.get(lossInformation.WHIPNoticeofLoss__c);
						if(payGroupLossInformationsByNolIds.containsKey(parentNol.Id)){
							payGroupLossInformationsByNolIds.get(parentNol.Id).add(lossInformation);
						} else {
							payGroupLossInformationsByNolIds.put(parentNol.Id , new List<WHIPLossInformation__c>{lossInformation});
						}
					}
				}
				for(Id nolId : payGroupLossInformationsByNolIds.keySet()){
					NoticeOfLossWrapper parentNolWrapper = new NoticeOfLossWrapper();
					if(this.noticeOfLossesByIds.containsKey(nolId)){
						parentNolWrapper.record = this.noticeOfLossesByIds.get(nolId);
						if (payGroupLossInformationsByNolIds.containsKey(nolId)) {
							parentNolWrapper.lossInformations.addAll(payGroupLossInformationsByNolIds.get(nolId));
							payGroupWrapper.noticeOfLosses.add(parentNolWrapper);
						}
					}
				}
				app.payGroups.add(payGroupWrapper);
			}
		}
	}
	public class AppWrapper{
		public WHIP_Application__c record {get;private set;}
		public List<PayGroupWrapper> payGroups {get;private set;}
		public List<NoticeOfLossWrapper> noticeOfLosses {get;private set;}
		public Boolean hasPreventedPlantingCrops {get;private set;}
		public AppWrapper(){
			this.payGroups = new List<PayGroupWrapper>();
			this.noticeOfLosses = new List<NoticeOfLossWrapper>();
			this.hasPreventedPlantingCrops = false;
		}
	}
	public class PayGroupWrapper{
		public WHIPPayGroup__c record {get;private set;}
		public List<NoticeOfLossWrapper> noticeOfLosses {get;private set;}
		public PayGroupWrapper(){
			this.noticeOfLosses = new List<NoticeOfLossWrapper>();
		}
	}
	public class NoticeOfLossWrapper{
		public WHIPNoticeofLoss__c record {get;private set;}
		public List<WHIPLossInformation__c> lossInformations {get;private set;}
		public NoticeOfLossWrapper(){
			this.lossInformations = new List<WHIPLossInformation__c>();
		}
	}
}
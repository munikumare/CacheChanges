public with sharing class WHIPLossInformationTriggerFacade {

    public static Boolean shouldUpdatePayGroup;

    private PayGroupDAO payGroupAccessor;

    public WHIPLossInformationTriggerFacade(PayGroupDAO payGroupAccessor) {
        this.payGroupAccessor = payGroupAccessor;       
    }

    public void checkForWHIPLossInformationFieldUpdates(Map<Id, WHIPLossInformation__c> newWHIPLossInformations,  List<WHIPLossInformation__c> oldWHIPLossInformations) {
        List<WHIPLossInformation__c> informationsToUpdate = new List<WHIPLossInformation__c>();

        for (WHIPLossInformation__c oldWHIPLoss : oldWHIPLossInformations) {
            WHIPLossInformation__c newWHIPLoss = newWHIPLossInformations.get(oldWHIPLoss.Id);

            if (newWHIPLoss.Unit__c != oldWHIPLoss.Unit__c ||
                newWHIPLoss.PayCropCode__c != oldWHIPLoss.PayCropCode__c ||
                newWHIPLoss.PayTypeCode__c != oldWHIPLoss.PayTypeCode__c ||
                newWHIPLoss.PlantingPeriod__c != oldWHIPLoss.PlantingPeriod__c) {
                informationsToUpdate.add(newWHIPLoss);
            }
        }

        updatePayGrouping(informationsToUpdate);
    }

    public void updatePayGrouping(List<WHIPLossInformation__c> whipLossInformations) {
        Map<Id, WHIPNoticeofLoss__c> noticeOfLossMap = buildNoticeOfLossMap(whipLossInformations);
        List<String> applications = new List<String>();
        List<String> payCodeKeys = new List<String>();

        for (WHIPLossInformation__c information : whipLossInformations) {
            payCodeKeys.add(information.Pay_Group_Key__c);
        }

        for (WHIPNoticeofLoss__c notice : noticeOfLossMap.values()) {
            applications.add(notice.WHIP_Application__c);
        }

        List<WHIPPayGroup__c> payGroups = payGroupAccessor.getPayGroupsFromKeyAndApplicationId(payCodeKeys, applications);
        Map<WHIPLossInformation__c, WHIPPayGroup__c> payGroupsToCreate = new Map<WHIPLossInformation__c, WHIPPayGroup__c>();

        if (payGroups.size() < 1) {
            payGroupsToCreate = buildPayGroupsToCreate(whipLossInformations, noticeOfLossMap, false);
        } else {
            for (WHIPLossInformation__c information : whipLossInformations) {
                for (WHIPPayGroup__c payGroup : payGroups) {

                    if (payGroup.PayGroupKey__c == information.Pay_Group_Key__c && 
                        payGroup.WHIPApplicationPayGroup__c == noticeOfLossMap.get(information.WHIPNoticeofLoss__c).WHIP_Application__c) {
                        information.WHIP_Pay_Group__c = payGroup.Id;
                    }
                }
            }

            payGroupsToCreate = buildPayGroupsToCreate(whipLossInformations, noticeOfLossMap, true);
        }

        this.payGroupAccessor.savePayGroups(payGroupsToCreate.values());

        for (WHIPLossInformation__c information : whipLossInformations) {
            if (payGroupsToCreate.containsKey(information)) {
                information.WHIP_Pay_Group__c = payGroupsToCreate.get(information).Id;
            }
        }
    } 

    public void updateRollUpsToPayGroup(Map<Id, WHIPLossInformation__c> newWHIPLossInformations,  List<WHIPLossInformation__c> oldWHIPLossInformations, Boolean isInsert) {
        System.debug('TEST : ' + shouldUpdatePayGroup);
        if (shouldUpdatePayGroup != null && shouldUpdatePayGroup == false) {
            return;
        }

        System.debug('TEST TWO');
        Set<Id> payGroupsToUpdate = new Set<Id>();
        Set<Id> payGroupsToUpdateFromDelete = new Set<Id>();

        if (isInsert) {
            for (WHIPLossInformation__c newWHIPLoss : newWHIPLossInformations.values()) {
                payGroupsToUpdate.add(newWHIPLoss.WHIP_Pay_Group__c);
            }
        } else {
            for (WHIPLossInformation__c oldWHIPLoss : oldWHIPLossInformations) {
                if (newWHIPLossInformations == null) {
                    payGroupsToUpdateFromDelete.add(oldWHIPLoss.WHIP_Pay_Group__c);
                } else {
                    WHIPLossInformation__c newWHIPLoss = newWHIPLossInformations.get(oldWHIPLoss.Id);
                    //if (oldWHIPLoss.WHIP_Pay_Group__c != newWHIPLoss.WHIP_Pay_Group__c) {
                        if (oldWHIPLoss.WHIP_Pay_Group__c != null) {
                            payGroupsToUpdate.add(oldWHIPLoss.WHIP_Pay_Group__c);
                        }
                        if (newWHIPLoss.WHIP_Pay_Group__c != null) {
                            payGroupsToUpdate.add(newWHIPLoss.WHIP_Pay_Group__c);
                        }
                    //}
                }
            }
        }


        if (!payGroupsToUpdate.isEmpty()) {
            summerizeRollUpFields(payGroupsToUpdate, false);
        }
        if (!payGroupsToUpdateFromDelete.isEmpty()) {
            summerizeRollUpFields(payGroupsToUpdateFromDelete, true);
        }
    }

    private void summerizeRollUpFields(Set<Id> payGroupIds, Boolean isDelete) {
        List<WHIPLossInformation__c> whipLossInformations = payGroupAccessor.getLossInformationsToRollUp(payGroupIds);
        Set<Id> payGroupsToUpdate = new Set<Id>();
        Set<Id> payGroupsToDelete = new Set<Id>();
        payGroupsToDelete.addAll(payGroupIds);

        for (WHIPLossInformation__c whipLossInformation : whipLossInformations) {
            if (payGroupIds.contains(whipLossInformation.WHIP_Pay_Group__c)) {
                payGroupsToUpdate.add(whipLossInformation.WHIP_Pay_Group__c);
                payGroupsToDelete.remove(whipLossInformation.WHIP_Pay_Group__c);
            }
        }

        delete [SELECT Id FROM WHIPPayGroup__c WHERE Id IN :payGroupsToDelete];

        Map<Id, WHIPPayGroup__c> payGroupMap = payGroupAccessor.getPayGroupsToUpdate(payGroupsToUpdate);


        if (!payGroupMap.isEmpty()) {
            if (isDelete) {
                removeRollUpsForPayGroup(whipLossInformations, payGroupMap);
            } else {
                addRollUpsForPayGroup(whipLossInformations, payGroupMap);
            }

            update payGroupMap.values();
        }
    }

    private void addRollUpsForPayGroup(List<WHIPLossInformation__c> whipLossInformations, Map<Id, WHIPPayGroup__c> payGroupMap) {

        for (WHIPLossInformation__c loss : whipLossInformations) {
            WHIPPayGroup__c payGroup = payGroupMap.get(loss.WHIP_Pay_Group__c);
            payGroup.PL_Total__c = 0;
            payGroup.PayGroup_Production_Loss_Total__c = 0;
            payGroup.TL_Total__c = 0;
            payGroup.Tree_Loss_Neg_Total__c = 0;
            payGroup.PayGroup_Tree_Loss_Total__c = 0;
            payGroup.VL_Total__c = 0;
            payGroup.Value_Loss_Neg_Total__c = 0;
            payGroup.PayGroup_Value_Loss_Total__c = 0;
        }

        for (WHIPLossInformation__c loss : whipLossInformations) {
            WHIPPayGroup__c payGroup = payGroupMap.get(loss.WHIP_Pay_Group__c);

            if (loss.RecordType.DeveloperName == 'Production_Loss') {
                payGroup.PL_Total__c += 1;
                payGroup.PayGroup_Production_Loss_Total__c += loss.PLCalculatedPayment__c;
            } else if (loss.RecordType.DeveloperName == 'Tree_Loss') {
                payGroup.TL_Total__c += 1;
                payGroup.Tree_Loss_Neg_Total__c += loss.TreeLossTotalCalculatedPayment__c;
                payGroup.PayGroup_Tree_Loss_Total__c += loss.TreeLossTotalCalculatedPayment__c;
            } else if (loss.RecordType.DeveloperName == 'Value_Loss') {
                payGroup.VL_Total__c += 1;
                payGroup.Value_Loss_Neg_Total__c += loss.VLCalculatedPayment__c;
                payGroup.PayGroup_Value_Loss_Total__c += loss.VLCalculatedPayment__c;
            }
        }
    }

    private void removeRollUpsForPayGroup(List<WHIPLossInformation__c> whipLossInformations, Map<Id, WHIPPayGroup__c> payGroupMap) {
        for (WHIPLossInformation__c loss : whipLossInformations) {
            WHIPPayGroup__c payGroup = payGroupMap.get(loss.WHIP_Pay_Group__c);

            if (loss.RecordType.DeveloperName == 'Production_Loss') {
                payGroup.PL_Total__c -= 1;
                payGroup.PayGroup_Production_Loss_Total__c -= loss.PLCalculatedPayment__c;
            } else if (loss.RecordType.DeveloperName == 'Tree_Loss') {
                payGroup.TL_Total__c -= 1;
                payGroup.Tree_Loss_Neg_Total__c -= loss.TreeLossTotalCalculatedPayment__c;
                payGroup.PayGroup_Tree_Loss_Total__c -= loss.TreeLossTotalCalculatedPayment__c;
            } else if (loss.RecordType.DeveloperName == 'Value_Loss') {
                payGroup.VL_Total__c -= 1;
                payGroup.Value_Loss_Neg_Total__c -= loss.VLCalculatedPayment__c;
                payGroup.PayGroup_Value_Loss_Total__c -= loss.VLCalculatedPayment__c;
            }
        }
    }

    private Map<WHIPLossInformation__c, WHIPPayGroup__c> buildPayGroupsToCreate(List<WHIPLossInformation__c> whipLossInformations, 
        Map<Id, WHIPNoticeofLoss__c> noticeOfLossMap, Boolean checkForNull) {
        Map<WHIPLossInformation__c, WHIPPayGroup__c> payGroupsToCreate = new Map<WHIPLossInformation__c, WHIPPayGroup__c>();

        for (WHIPLossInformation__c information : whipLossInformations) {
            if (checkForNull) {
                if (information.WHIP_Pay_Group__c == null) {
                    WHIPPayGroup__c payGroup = new WHIPPayGroup__c();
                    payGroup.WHIPApplicationPayGroup__c = noticeOfLossMap.get(information.WHIPNoticeofLoss__c).WHIP_Application__c;
                    payGroup.CoverageType__c = noticeOfLossMap.get(information.WHIPNoticeofLoss__c).CoverageType__c;
                    payGroup.PhysicalStateNameCode__c = information.PhysicalStateNameCode__c;
                    payGroup.PhysicalCountyNameCode__c = information.PhysicalCountyNameCode__c;
                    payGroup.CropYear__c = information.CropYear__c;
                    payGroup.Unit__c = information.Unit__c  ;
                    payGroup.PayCropCode__c = information.PayCropCode__c;
                    payGroup.PayTypeCode__c = information.PayTypeCode__c;
                    payGroup.PlantingPeriod__c = information.PlantingPeriod__c;

                    payGroupsToCreate.put(information, payGroup);
                }
            } else {
                WHIPPayGroup__c payGroup = new WHIPPayGroup__c();
                payGroup.WHIPApplicationPayGroup__c = noticeOfLossMap.get(information.WHIPNoticeofLoss__c).WHIP_Application__c;
                payGroup.CoverageType__c = noticeOfLossMap.get(information.WHIPNoticeofLoss__c).CoverageType__c;
                payGroup.PhysicalStateNameCode__c = information.PhysicalStateNameCode__c;
                payGroup.PhysicalCountyNameCode__c = information.PhysicalCountyNameCode__c;
                payGroup.CropYear__c = information.CropYear__c;
                payGroup.Unit__c = information.Unit__c  ;
                payGroup.PayCropCode__c = information.PayCropCode__c;
                payGroup.PayTypeCode__c = information.PayTypeCode__c;
                payGroup.PlantingPeriod__c = information.PlantingPeriod__c;

                payGroupsToCreate.put(information, payGroup);
            }
        }

        return payGroupsToCreate;
    }

    private Map<Id, WHIPNoticeofLoss__c> buildNoticeOfLossMap(List<WHIPLossInformation__c> whipLossInformations) {
        Set<String> noticeOfLossIds = new Set<String>();

        for (WHIPLossInformation__c information : whipLossInformations) {
            noticeOfLossIds.add(information.WHIPNoticeOfLoss__c);
        }

        return payGroupAccessor.getNoticeOfLossMap(noticeOfLossIds);
    }

    public static WHIPLossInformationTriggerFacade createWHIPLossInformationTriggerFacade() {
        return new WHIPLossInformationTriggerFacade(
            new PayGroupDataAccessor()
            );
    }
}
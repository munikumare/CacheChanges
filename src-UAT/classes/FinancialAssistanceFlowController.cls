public with sharing class FinancialAssistanceFlowController {
	@AuraEnabled
	public static List<FlowInterview> getFlows() {
		// Get the ID of the running user
		String currentUser = UserInfo.getUserId();
		// Find all of that user's paused interviews for the Survey customers flow
		List<FlowInterview> interviews =
		[ SELECT Id FROM FlowInterview
		WHERE CreatedById = :currentUser];

		if (interviews == null || interviews.isEmpty()) {
			return null; // early out
		}
		// Return the ID for the first interview in the list
		return interviews;
	}
}
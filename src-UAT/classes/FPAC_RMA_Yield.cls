public with sharing class FPAC_RMA_Yield {
	
    public string InsurancePlanCode {
    	get; 
    	
    	set {
    		if (YieldHistories != null && YieldHistories.size() > 0)
    		{
    			for(FPAC_RMA_YieldHistory yieldHistory : YieldHistories)
    			{
    				yieldHistory.InsurancePlanCode = value;
    			}
    		}
    	}
    }
    
    
    public List<FPAC_RMA_YieldHistory> YieldHistories {get; set;}
}
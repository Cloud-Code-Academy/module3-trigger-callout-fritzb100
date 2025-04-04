public with sharing class NewsCategoryTriggerHandler extends TriggerHandler {

    private List<News_Category__c> newsCategories;


    public NewsCategoryTriggerHandler() {
        this.newsCategories = (List<News_Category__c>) Trigger.new;
    }
    
    public override void afterInsert() {
        try {
            runQueuableJob();
        } catch (Exception e) {
            ErrorLog.debugException(e);
            ErrorLog.createErrorItem('NewsCategoryTriggerHandler', 'News_Category__c', 'afterInsert', e.getMessage(), UserInfo.getUserId());
        }
    }

    public override void afterUpdate() {
        try {
            runQueuableJob();
        } catch (Exception e) {
            ErrorLog.debugException(e);
            ErrorLog.createErrorItem('NewsCategoryTriggerHandler', 'News_Category__c', 'afterUpdae', e.getMessage(), UserInfo.getUserId());
        }
        runQueuableJob();
    }

    private  void runQueuableJob() {
        List<NewsCategoryQueueable> queueableJobs = new List<NewsCategoryQueueable>();
        //String searchQuery = 'defaultSearchQuery'; // Define and assign a value to searchQuery
        for(News_Category__c newsCategory : this.newsCategories) {
        Integer pageSizeInteger = newsCategory.Page_Size__c.intValue();
            //enqueue the job for processing
        queueableJobs.add(new NewsCategoryQueueable(
            newsCategory.Id,
            newsCategory.Name,
            pageSizeInteger,
            1 // start with first page
            //searchQuery // pass the search parameter
        ));
        }
        for(NewsCategoryQueueable job : queueableJobs) {
            System.enqueueJob(job);
        }
    }
}
public with sharing class NewsCategoryTriggerHandler extends TriggerHandler {

    private List<News_Category__c> newsCategories;


    public NewsCategoryTriggerHandler() {
        this.newsCategories = (List<News_Category__c>) Trigger.new;
    }
    
    public override void afterInsert() {
        runQueuableJob();
    }

    public override void afterUpdate() {
        runQueuableJob();
    }

    private  void runQueuableJob() {
        List<NewsCategoryQueueable> queueableJobs = new List<NewsCategoryQueueable>();
        for(News_Category__c newsCategory : this.newsCategories) {
        Integer pageSizeInteger = newsCategory.Page_Size__c.intValue();
        //enqueue the job for processing
        queueableJobs.add(new NewsCategoryQueueable(
            newsCategory.Id,
            newsCategory.Name,
            pageSizeInteger,
            1 // start with first page
        ));
        }
        for(NewsCategoryQueueable job : queueableJobs) {
            System.enqueueJob(job);
        }
    }
}
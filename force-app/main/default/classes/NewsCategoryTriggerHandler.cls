public with sharing class NewsCategoryTriggerHandler extends TriggerHandler {

    private List<News_Category__c> newsCategories;


    public NewsCategoryTriggerHandler() {
        this.newsCategories = (List<News_Category__c>) Trigger.new;
    }
    
    public override void afterInsert() {
       
        List<NewsCategoryQueueable> queueableJobs = new List<NewsCategoryQueueable>();
        for(News_Category__c newsCategory : this.newsCategories) {
            Integer pageSizeInteger = newsCategory.Page_Size__c.intValue();
            System.debug('newsCategory Id: ' + newsCategory.Id);
            System.debug('newsCategory: ' + newsCategory);
            queueableJobs.add(new NewsCategoryQueueable(
                newsCategory.Id,
                newsCategory.Name,
                pageSizeInteger
            ));
        }
        for (NewsCategoryQueueable job : queueableJobs) {
            System.enqueueJob(job);
        }
    }
}
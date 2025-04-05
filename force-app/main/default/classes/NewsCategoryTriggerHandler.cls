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
    }

    private  void runQueuableJob() {
        List<NewsCategoryQueueable> queueableJobs = new List<NewsCategoryQueueable>();
        List<News_Category__c> categoriesToUpsert = new List<News_Category__c>();
        //String searchQuery = 'defaultSearchQuery'; // Define and assign a value to searchQuery
        for(News_Category__c newsCategory : this.newsCategories) {
        Integer pageSizeInteger = newsCategory.Page_Size__c != null ? newsCategory.Page_Size__c.intValue() : 1;
            
            //enqueue the job for processing if Sync__c is true
            if(newsCategory.Sync__c == true) {
                System.debug('newsCategory.Sync__c: ' +newsCategory.Sync__c);

                queueableJobs.add(new NewsCategoryQueueable(
                    newsCategory.Id,
                    newsCategory.Name,
                    pageSizeInteger,
                    1 // start with first page
                    //searchQuery // pass the search parameter TODO: implement searchQuery
                ));

                // prepare the category for upsert
                News_Category__c newNewsCategory = new News_Category__c(
                    Id = newsCategory.Id,
                    Sync__c = false, //prepare the news category for update
                    Last_Synced__c = System.now()                    
                );
                System.debug('newsCategory.Sync__c: ' +newsCategory.Sync__c);
                System.debug('newsCategory.Last_Synced__c ' +newsCategory.Last_Synced__c);
                categoriesToUpsert.add(newNewsCategory);
            }
        }
            //enqueue the jobs
        for(NewsCategoryQueueable job : queueableJobs) {
            System.enqueueJob(job);

            if(!categoriesToUpsert.isEmpty()) {
                System.debug('categoriesToUpsert::: ' +categoriesToUpsert);
                upsert categoriesToUpsert;
            }
        }
    }
}
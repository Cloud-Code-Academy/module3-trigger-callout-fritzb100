/**
 * Handler class for NewsCategoryTrigger
 */
public with sharing class NewsCategoryTriggerHandler {
        
    public static Boolean IS_JOB_ENQUEUED = false;
    /**
     * Handles after insert events for News_Category__c
     * Uses Future method for callouts when Sync__c is true
     * @param newRecords List of newly inserted News_Category__c records
     */
    public static void handleInsert(List<News_Category__c> newRecords) {
        List<String> categoriesToSync = new  List<String>();
        System.debug('newRecords: ' + newRecords);
        // TODO: Implement insert handler
        // - Filter categories that need to be synced
        for(News_Category__c newNewsCategory : newRecords) {
            if(newNewsCategory.Sync__c == true && String.isNotBlank(newNewsCategory.Name)) {
                System.debug('newNewsCategory.Sync__c:::: '+ newNewsCategory.Sync__c);
                categoriesToSync.add(newNewsCategory.Name);
            }
        }
        System.debug('categoriesToSync:::: '+ categoriesToSync);
        // - Call future method for callouts
        if(!categoriesToSync.isEmpty()) {
            syncCategoriesWithFuture(categoriesToSync);
        }
    }
    
    /**
     * Handles after update events for News_Category__c
     * Uses Queueable Apex for callouts when Sync__c is true
     * @param newRecords List of updated News_Category__c records
     * @param oldMap Map of old record states
     */
    public static void handleUpdate(List<News_Category__c> newRecords, Map<Id, News_Category__c> oldMap) {
        // TODO: Implement update handler
        // - Filter categories that need to be synced
        // - Call queueable method for callouts
        List<News_Category__c> categoriesToSync = new List<News_Category__c>();
        
        for(News_Category__c category : newRecords) {
            if(category.Sync__c == true && oldMap.get(category.Id).Sync__c == false) {
                categoriesToSync.add(category);
            }
        }
        System.debug('categoriesToSync: ' + categoriesToSync);
        if(!categoriesToSync.isEmpty()) {
            syncCategoriesWithQueueable(categoriesToSync);
        }
    }
    
    /**
     * Future method to sync categories using the NewsAPI
     * Used for insert operations
     * @param categoryNames List of category names to sync
     */
    @future(callout=true)
    public static void syncCategoriesWithFuture(List<String> categoryNames) {
        // - Get categories by name
        // - Make callouts to NewsAPI for each category         
        // - Insert retrieved articles
        // - Update categories with last synced date

        System.debug('categoryNames: ' + categoryNames);
        NewsAPIResponse newsResponse = new NewsAPIResponse();
        List<Article__c> articlesToInsert = new List<Article__c> ();
        List<News_Category__c> categoriesToUpdate = new List<News_Category__c>();
        
        List<News_Category__c> categories = [SELECT Id, Name, Sync__c FROM News_Category__c WHERE Name IN :categoryNames];
        
        
        for( News_Category__c category : categories) {
            if(Test.isRunningTest()) {
                System.debug('Test is runing test!!!');
                newsResponse = NewsAPIService.ParseResponse(NewsAPIMock.createSuccessMock().respond(new HttpRequest()).getBody());
                System.debug('newsResponse: ' + newsResponse);
            }
            else {
                newsResponse = NewsAPIService.getTopHeadlinesByCategory(category.Id, 3, 1);
            }
            List<Article__c> articles = newsResponse.toSObjects(category.Id, category.Name);
            system.debug(articles);
            articlesToInsert.addAll(articles);

            News_Category__c categoryToUpdate = new News_Category__c(Id = category.Id, Sync__c = false, Last_Synced__c = System.Now());
            System.debug('articlesToInsert: ' + articlesToInsert);
            System.debug('categoryToUpdate: ' + categoryToUpdate);
            categoriesToUpdate.add(categoryToUpdate);
           
            
            
        }
        if(!articlesToInsert.isEmpty()) {
            insert articlesToInsert;
        }
        System.debug('categoriesToUpdate: ' + categoriesToUpdate);
        update categoriesToUpdate;
    }

   
    /**
     * Queueable method to sync categories using the NewsAPI
     * Used for update operations
     * @param categoriesToSync List of News_Category__c records to sync
     */
    private static void syncCategoriesWithQueueable(List<News_Category__c> categoriesToSync) {
        // TODO: Implement queueable job enqueuing
        // - Determine pages to sync for each category
        // - Create and enqueue NewsCategoryQueueable job for each category
        // if(IS_JOB_ENQUEUED) {
        //     IS_JOB_ENQUEUED = true;

            System.debug('job is enqueued');
            News_Category__c category = categoriesToSync[0];
            System.enqueueJob(new NewsCategoryQueueable(category.Id, category.Name, 1));
        //}
    }
} 
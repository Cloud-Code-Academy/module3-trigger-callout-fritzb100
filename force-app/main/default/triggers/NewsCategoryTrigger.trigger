/**
 * Trigger for News_Category__c object to sync news from API when Sync__c field is true
 */
trigger NewsCategoryTrigger on News_Category__c (after insert, after update) {
    // - Call appropriate handler methods for insert and update contexts
    new NewsCategoryTriggerHandler().run();

    // if( Trigger.isAfter && Trigger.isInsert) {
    // NewsCategoryQueueable job = new NewsCategoryQueueable('a02De000001IAq6IAG', 'technology', 1);
    //     System.enqueueJob(job);
    // }
} 
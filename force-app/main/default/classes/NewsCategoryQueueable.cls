/**
 * Queueable Apex class for processing News Category records with pagination support
 */
public class NewsCategoryQueueable implements Queueable, Database.AllowsCallouts {
    private Id categoryId;
    private String categoryName;
    private Integer pages;
    private Integer currentPage;
    //private String searchQuery;
    private static final Integer MAX_Depth = 5;
    /**
     * Constructor
     * @param categoryId The Id of the News_Category__c record
     * @param categoryName The category name
     * @param pages Total pages to sync
     */
    public NewsCategoryQueueable(Id categoryId, String categoryName, Integer pages) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.pages = pages;
    }
    
    /**
     * Constructor with current page
     * @param categoryId The Id of the News_Category__c record
     * @param categoryName The category name
     * @param pages Total pages to sync
     * @param currentPage Current page being processed
     */
    public NewsCategoryQueueable(Id categoryId, String categoryName, Integer pages, Integer currentPage) { //String searchQuery
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.pages = pages == null ? 1: pages;
        this.currentPage = currentPage;
        //this.searchQuery = searchQuery; 
    }
    



    /**
     * Execute method for the queueable job
     * @param context The QueueableContext
     */
    public void execute(QueueableContext context) {
        // - Call NewsAPI for the current page
        if(maxDepthReached()) { 
            return;
        }
        // News_Category__c newNewsCategory = [SELECT Id FROM News_Category__c WHERE Id =: categoryId];
        // System.debug('newNewsCategory: ' + newNewsCategory);
        try {
            NewsAPIService.getTopHeadlinesByCategory(categoryName, pages, currentPage);  //searchQuery
        } catch (Exception e) {
            ErrorLog.debugException(e);
            ErrorLog.createErrorItem('Exception in NewsCategoryQueueable', 'News_Category__c', 'getTopHeadlinesByCategory', e.getMessage(), UserInfo.getUserId());
            }           
        
        // - Process and save articles Update category if last page Chain to next page if more pages exist
        if(currentPage < pages) {
            System.debug('currentPage:' + currentPage);
            System.debug('pages:' + pages);
        try {
            System.enqueueJob(new NewsCategoryQueueable(
                categoryId, 
                categoryName, 
                pages, 
                currentPage + 1 // Increment the page number
                //searchQuery      // additional parameter
            ));
            System.debug('categoryId:::: ' + categoryId);
        } catch (Exception e) {
            ErrorLog.debugException(e);
            ErrorLog.createErrorItem('Exception in NewsCategoryQueueable', 'News_Category__c', 'System.enqueueJob', e.getMessage(), UserInfo.getUserId());
            }
        }
    }
    public static Boolean maxDepthReached() {
        Integer depth = AsyncInfo.getCurrentQueueableStackDepth();
        return depth == MAX_Depth ? true : false;
    }
} 
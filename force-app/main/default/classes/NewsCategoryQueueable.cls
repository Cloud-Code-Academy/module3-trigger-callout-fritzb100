/**
 * Queueable Apex class for processing News Category records with pagination support
 */
public class NewsCategoryQueueable implements Queueable, Database.AllowsCallouts {
    private Id categoryId;
    private String categoryName;
    private Integer pages;
    private Integer currentPage;
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
        System.debug('Processing NewsCategory with Id: ' + categoryId);
        System.debug('Category Name: ' + categoryName);
        System.debug('Page Size: ' + pages);
    }
    
    /**
     * Constructor with current page
     * @param categoryId The Id of the News_Category__c record
     * @param categoryName The category name
     * @param pages Total pages to sync
     * @param currentPage Current page being processed
     */
    public NewsCategoryQueueable(Id categoryId, String categoryName, Integer pages, Integer currentPage) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.pages = pages;
        this.currentPage = currentPage; 

        System.debug('Processing NewsCategory with Id: ' + categoryId);
        System.debug('Category Name: ' + categoryName);
        System.debug('Page Size: ' + pages);
        System.debug('currentPage: ' + currentPage);

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
        try {
            System.debug('maxDepthHasNOT BeenReached: ' +maxDepthReached());
            NewsAPIService.getTopHeadlinesByCategory(categoryName, pages, currentPage);
        } catch (Exception e) {
            ErrorLog.debugException(e);
            ErrorLog.createErrorItem('Exception in NewsCategoryQueueable', 'News_Category__c', 'getTopHeadlinesByCategory', e.getMessage(), UserInfo.getUserId());
            }           
        
        
        // - Process and save articles
        // - Update category if last page
        // - Chain to next page if more pages exist
        if(currentPage < pages) {
            System.enqueueJob(new NewsCategoryQueueable(
                categoryId, 
                categoryName, 
                pages, 
                currentPage + 1 // Increment the page number
            ));
        }
    }
 // how many pages do I have? run a calculation to get the last page am I on the last page?  do I need to requeu the job, if you're beyond the last page
    public static Boolean maxDepthReached() {
        Integer depth = AsyncInfo.getCurrentQueueableStackDepth();
        return depth == MAX_Depth ? true : false;
    }
} 
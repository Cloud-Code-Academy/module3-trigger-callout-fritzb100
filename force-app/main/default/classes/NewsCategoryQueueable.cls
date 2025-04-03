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
        if(!maxDepthReached()) {
            System.debug('maxDepthHasNOT BeenReached: ' +maxDepthReached());
            NewsAPIService.getTopHeadlinesByCategory(categoryName, pages, currentPage);
        }
        else {
            // call the error method
            System.debug('Max Depth reached for sandbox/scratch org');
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

    public static Boolean maxDepthReached() {
        Integer depth = AsyncInfo.getCurrentQueueableStackDepth();
        // if(depth == MAX_Depth){
        // }
        // return true;
        return depth == MAX_Depth ? true : false;
    }
} 
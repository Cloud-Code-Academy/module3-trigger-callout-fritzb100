/**
 * Queueable Apex class for processing News Category records with pagination support
 */
public class NewsCategoryQueueable implements Queueable, Database.AllowsCallouts {
    private Id categoryId;
    private String categoryName;
    private Integer pages;
    private Integer currentPage;
    
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
    // public NewsCategoryQueueable(Id categoryId, String categoryName, Integer pages, Integer currentPage) {
    //     this.categoryId = categoryId;
    //     this.categoryName = categoryName;
    //     this.pages = pages;
    //     this.currentPage = currentPage; 
    // }
    
    /**
     * Execute method for the queueable job
     * @param context The QueueableContext
     */
    public void execute(QueueableContext context) {
        System.debug('Processing NewsCategory with Id: ' + categoryId);
        System.debug('Category Name: ' + categoryName);
        System.debug('Page Size: ' + pages);

        // - Call NewsAPI for the current page
        NewsAPIService.getTopHeadlinesByCategory(categoryName, pages, 1);
        // - Process and save articles
        // - Update category if last page
        // - Chain to next page if more pages exist
    }
} 
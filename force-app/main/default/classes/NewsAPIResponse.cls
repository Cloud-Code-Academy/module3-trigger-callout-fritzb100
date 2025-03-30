/**
 * Wrapper class for parsing the NewsAPI response
 */
public class NewsAPIResponse {
    // TODO: Define fields to match the NewsAPI response structure
    public String status { get; set; }
    public Integer totalResults { get; set; }
    public List<Article> articles { get; set; }
    
    /**
     * Inner class representing a news article
     */
    public class Article {
        public Source source;
        public String author;
        public String title;
        public String description;
        public String url;
        public String urlToImage;
        public String publishedAt;
        public String content;
        
        /**
         * Converts the API article to a Salesforce Article__c record
         * @return Article__c The Salesforce record
         */
        public Article__c toSObject() {
            // TODO: Implement conversion from API article to Salesforce record
            //System.debug('article'+  Article__c);
            // Consider:
            // - Handling date conversion
            // - Generating a unique record name
            // - Handling field length limits
            
            Article__c articleRecord = new Article__c();
            articleRecord.Name = title != null ? title.substring(0, Math.min(80, title.length())) : 'Untitled';
            articleRecord.Author__c = author;
            articleRecord.Description__c = description;
            articleRecord.Url__c = url;
            //articleRecord.PublishedAt__c = publishedAt != null ? DateTime.valueOf(publishedAt) : null;
            return articleRecord;
        }
    }
    
    /**
     * Inner class representing a news source
     */
    public class Source {
        public String id;
        public String name;
        // TODO: Define source fields
    }
    
    /**
     * Helper method to convert all articles in this response to Salesforce records
     * @return List<Article__c> List of Salesforce records
     */
    public List<Article__c> toSObjects() {
        List<Article__c> articleRecords = new List<Article__c>();
        for(NewsAPIResponse.Article  article : articles) {
            System.debug('article: ' + article);
            Article__c oneArticle = article.toSObject();
            if(oneArticle != null) {
                articleRecords.add(oneArticle);
            }
        }
        return articleRecords;
    }
} 
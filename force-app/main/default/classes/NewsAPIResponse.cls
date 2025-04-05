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
        public Datetime publishedAt;
        public String content;
        
        /**
         * Converts the API article to a Salesforce Article__c record
         * @return Article__c The Salesforce record
         */
        public Article__c toSObject() {
            //System.debug('article'+  Article__c);
            // Consider: Handling date conversion Generating a unique record name Handling field length limits
            Integer uniqueNumber = (Integer)Math.random()+50 *50;
            String uniqueString = uniqueNumber.toString();
            Article__c articleRecord = new Article__c();
            articleRecord.Name = this.source != null ? this.source.id : uniqueString ;   //   UniqueNumber + this.source != null ? this.source.name : null;
            articleRecord.Author__c = this.author;
            articleRecord.Description__c = this.description != null && description.length() > 32700 ? description.substring(0, 32700) : description;
            articleRecord.Content__c = this.content != null && content.length() > 131000 ? content.substring(0, 131000) : content;
            articleRecord.Url__c = this.url;
            articleRecord.urlToImage__c = this.urlToImage != null && urlToImage.length() > 255 ? urlToImage.substring(0, 255) : urlToImage;
            articleRecord.Published_At__c = this.publishedAt != null ? DateTime.valueOf(publishedAt) : null;
            articleRecord.Source__c = this.source != null ? this.source.name : null;
            articleRecord.Title__c = this.title != null ? title.substring(0, Math.min(80, title.length())) : 'Untitled';
            return articleRecord;
        }
    }
    
    /**
     * Inner class representing a news source
     */
    public class Source {
        public String id;
        public String name;
        
        public Source tosObject() {
            Source sourceString = new Source();    
            sourceString.Id = this.id;
            sourceString.name = this.name;
            return sourceString;
        }
    }
    
    /**
     * Helper method to convert all articles in this response to Salesforce records
     * @return List<Article__c> List of Salesforce records
     */
    public List<Article__c> toSObjects() {
        List<Article__c> articleRecords = new List<Article__c>();
        for(NewsAPIResponse.Article  article : articles) {
            Article__c eachArticle = article.toSObject();
            if(eachArticle != null) {
                articleRecords.add(eachArticle);
            }
        }
        return articleRecords;
    }
} 
/**
 * Service class to interact with the NewsAPI for fetching top headlines
 */
public with sharing class NewsAPIService {
    // TODO: Define API endpoint constants
    private static final String API_NAMED_CREDENTIAL = 'callout:NewsAPI'; //https://newsapi.org
    private static final String API_ENDPOINT = '/v2/top-headlines';
    
    // TODO: Define default parameters
    private static final Integer DEFAULT_PAGE_SIZE = 20; 
    
    /**
     * Fetches top headlines for a specified category with pagination support
     * @param category The news category (business, entertainment, general, health, science, sports, technology)
     * @param pageSize Number of results per page (default: 20, max: 100)
     * @param page Page number for pagination
     * @return NewsAPIResponse The wrapper object containing the API response
     */
    
    public static void getTopHeadlinesByCategory(String category, Integer pageSize, Integer page) { // String searchQuery
        String message;
        // - Validate and set defaults for parameters Build the request URL
        String endpoint = API_NAMED_CREDENTIAL + API_ENDPOINT +'?page='+page+'&pageSize='+pageSize+ '&category='+ category; //+ (searchQuery != null && searchQuery != '' ?'&q=' + EncodingUtil.urlEncode(searchQuery, 'UTF-8') : '');

        // - Make the callout
        try {
            HttpResponse res = makeCallout(endpoint);
            // - Parse and return the response
            NewsAPIResponse newsResponse = parseResponse(res.getBody());
            // Convert articles to salesforce records
            List<Article__c> articlesRecords = newsResponse.toSObjects();
            insert articlesRecords;
            System.debug('Successfully inserted Article__c records.');
            //return newsResponse;
        } catch (Exception e) {
            ErrorLog.debugException(e);
            ErrorLog.createErrorItem('Exception in NewsAPIResponse', 'Article__c', 'makeCallout', e.getMessage(), UserInfo.getUserId());
        }

        
    }
    
    /**
     * Helper method to make the HTTP callout
     * @param endpoint The full URL with parameters
     * @return HttpResponse The HTTP response
     */
    //@future(callout=true)
    public static HttpResponse makeCallout(String endpoint) {
        HttpResponse returnedResponse = new HttpResponse();
        String message;
        HttpRequest request = new HttpRequest();
        Http http = new Http();
       

        if(Test.isRunningTest()) {
            System.debug('running in test');
            Test.setMock(HttpCalloutMock.class, NewsAPIMock.createSuccessMock());
        } else {
            System.debug('running in prod');
        }
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        // - Create and configure HTTP request
        
        
        System.debug('request: ' + request);

            HttpResponse response = http.send(request);
            if(response.getStatusCode() >= 200 || response.getStatusCode() <300) {
                returnedResponse = response;
            }
            return returnedResponse;
        }
    
    
    /**
     * Helper method to parse the JSON response
     * @param jsonResponse The JSON response string
     * @return NewsAPIResponse The parsed response object
     */
    private static NewsAPIResponse parseResponse(String jsonResponse) {
        NewsAPIResponse newsAPIResponse = new NewsAPIResponse();
        String message;
        // - Deserialize JSON to NewsAPIResponse
        try {
            NewsAPIResponse NewsResponseParsing = (NewsAPIResponse)System.JSON.deserialize(jsonResponse, NewsAPIResponse.class);
            newsAPIResponse = NewsResponseParsing;
        } catch (NewsAPIException e) {
            message = e.getMessage();         // - Handle exceptions
        }
        return newsAPIResponse;
    }
    
    /**
     * Custom exception class for NewsAPI errors
     */
    public class NewsAPIException extends Exception {}
} 
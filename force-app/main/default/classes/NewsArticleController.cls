public with sharing class NewsArticleController {
    @AuraEnabled
    public static List<Map<String, String>> getNewsArticles() {
        List<Article__c> articles = [SELECT Title__c, Description__c, Url__c FROM Article__c LIMIT 10];
        List<Map<String, String>> result = new List<Map<String, String>>();
        for (Article__c article : articles) {
            result.add(new Map<String, String>{
                'title' => article.Title__c,
                'description' => article.Description__c,
                'url' => article.Url__c
            });
        }
        return result;
    }
}

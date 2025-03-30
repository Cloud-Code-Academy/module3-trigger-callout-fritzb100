
String url = 'https://newsapi.org/v2/top-headlines?page=2&category=business&country=us&apiKey=4197c427830d4ee498c01b48b4caee6c';
String url2 ='https://newsapi.org/v2/top-headlines?page=2&pageSize=1&category=technology&apiKey=4197c427830d4ee498c01b48b4caee6c';
// Http http = new Http();
// HttpRequest request = new HttpRequest();
// request.setMethod('GET');
// request.setEndpoint(url2);
// HttpResponse response = http.send(request);
// System.debug(response.getBody());
//NewsAPIService.makeCallout(url2);
NewsAPIService.getTopHeadlinesByCategory('technology', 2, 5);
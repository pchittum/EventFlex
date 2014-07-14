public with sharing class TwitterPostController {
    public String newTweet{get;set;}
    public String result {get;set;}
    public SimpleTweet.TwitterSearchResponse searchResponse {get;set;}
    public String twitterSearch {get;set;}
    
    public TwitterPostController(){
        searchResponse = SimpleTweet.search('EventAcu', 20);
    }

    public void postTweet(){
  /*      SimpleTwitterPost twitter = new SimpleTwitterPost();
        if (twitter.tweet(newTweet)){
            result = 'Tweeted';
        } */
    }

    public void search(){
        searchResponse = SimpleTweet.search(twitterSearch, 20);
    }
}
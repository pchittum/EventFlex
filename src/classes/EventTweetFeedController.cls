public with sharing class EventTweetFeedController {

    public String newTweet{get;set;}
    public String result {get;set;}
    public SimpleTweet.TwitterSearchResponse searchResponse {get;set;}
    public String twitterSearch {get;set;}
    public Event__c event {get;set;}
    public boolean showTweet{get;set;}
    
    private Id eventId;
    private String twitterUser; 
    
   
  
   public EventTweetFeedController(ApexPages.StandardController controller) {
       loadData(controller);
    
    } 
    
    private void loadData(ApexPages.StandardController controller){
      
      if(eventId==null){
         eventId= (Id)controller.getId();
      }
      if(this.event == null){ 
        this.event = getEventDetail(eventId);
      }
      twitterUser = event.Twitter_User__c  ;
      searchResponse = SimpleTweet.search(twitterUser, 20);
      showTweet = false;
    } 
    
    private Event__c  getEventDetail(Id eventId){
      Event__c   ev = [ SELECT id, name , Twitter_User__c  FROM Event__c where id =:eventId ];
       return ev ;
    }
/*    
    public EventTweetFeedController(){
        searchResponse = SimpleTweet.search('EventAcu', 20);
    }
*/
 /*   public void postTweet(){
       SimpleTwitterPost twitter = new SimpleTwitterPost();
        if (twitter.tweet(newTweet)){
            result = 'Tweeted';
        } 
    }
*/
    public void search(){
         showTweet=true;
         System.debug('***********showTweet*************' + showTweet);
         System.debug('***********twitterUser *************' + twitterUser );
        searchResponse = SimpleTweet.search(event.Twitter_User__c, 20);
        
        System.debug('***********searchResponse *************' + searchResponse);
         System.debug('***********searchResponse.statuses *************' + searchResponse.statuses);
    }
    
    public void createSocialPost(){
      System.debug('***********searchResponse *************' + searchResponse);
      System.debug('***********searchResponse.statuses *************' + searchResponse.statuses);
      List<Social_Post__c > socialPostList = new List<Social_Post__c >();
      for( Tweet tw : searchResponse.statuses){
          String id = tw.id_str ;
          String text = tw.text;
          
          System.debug('***********id*************' + id);
          System.debug('***********text *************' + text );
             Social_Post__c sPost =  New Social_Post__c ();
             sPost.External_ID__c = tw.id_str;
             sPost.Post_text__c= tw.text;
             sPost.Type__c='Twitter';
             sPost.Event__c = eventId;
             sPost.Social_User__c = tw.user.name;
             socialPostList.add(sPost);
      }
     //  insert socialPostList;
      Database.SaveResult[] saveResult = Database.Insert(socialPostList,false);
      
     
    }

}
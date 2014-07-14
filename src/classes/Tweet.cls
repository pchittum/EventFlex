/*
    *   This class is used by the SimpleTweet API for decoding JSON responses
    
    @author Claude Sutterlin    <csutterlin@acumensolutions.com>
*/
public with sharing class Tweet {
    
    public String created_at {get;set;}
    public String id_str {get; set;}
    public String text {get; set;}
    public boolean retweeted {get;set;}
    public TwitterUser user {get;set;}
    public TwitterEntities entities {get;set;}
    public Tweet retweeted_status {get;set;}

    public Tweet(){}

    public class TwitterUser{
        public String name {get;set;}
        public String profile_image_url {get;set;}
        public String profile_image_url_https {get;set;}
        public String id {get;set;}
        public String screen_name {get;set;}

        public TwitterUser(){}
    }

    public class TwitterEntities{
        public List<TwitterMedia> media {get;set;}

        public TwitterEntities(){}
    }

    public class TwitterMedia{
        public String id {get;set;}
        public String media_url {get;set;}
        public String media_url_https {get;set;}
        public String type {get;set;}
        public String expanded_url {get;set;}

        public TwitterMedia(){}
    }
}
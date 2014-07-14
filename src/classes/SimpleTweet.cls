/*
    *   This class will send a tweet to a preconfigured twitter account,
    *   or search for tweets.
    *   Some of the following code was inspired (or taken completely) from: 
    *   https://github.com/metadaddy-sfdc/sfdc-oauth-playground
    *
    *   Setup:
    *   Log into dev.twitter.com
    *   Create a new Application
    *   Copy OAuth settings into the credentials below
    *   Click "Create my access token", copy into the credentials below
    *   Be sure to also grant the appplication write access
    *
    *   Example Usage:
    *   SimpleTweet.tweet('Hello twitter! #newTweet');
    *
    *   TwitterSearchResponse resp = SimpleTweet.search('Salesforce', 20);
    *   List<Tweet> tweets = resp.statuses;
    
    @author Claude Sutterlin    <csutterlin@acumensolutions.com>
*/

public with sharing class SimpleTweet {
    
    // fill out your credentials
    public static final String consumerKey = 'yPWUbzpGZ5BxeIcnlZUIPDWFd'; // API Key
    public static final String consumerSecret = 'aPgh2NrsfM2eLylMBWFNhC144MqvKPkfBXihRJAobWkLEwctZw'; // API Secret
    public static final String callbackUrl = 'None';
    public static final String accessToken = '2547914988-l5rIA7kODvxMt6E4kFFjHUDEpY99MLaLZRX61Pg';
    public static final String accessTokenSecret = 'TEF7Ou7wKLTN4jZIUzgorg8QRCxsuQ1VdgulZ8dblah7f';

    // commands
    public static final String POST_STATUS_COMMAND = 'https://api.twitter.com/1.1/statuses/update.json';
    public static final String SEARCH_COMMAND = 'https://api.twitter.com/1.1/search/tweets.json?';

    // transactions
    public static final String POST_TRANSACTION = 'POST';
    public static final String GET_TRANSACTION = 'GET';

    // enable/disable debugging
    private static final boolean DEBUG_MODE = false;    
    
    
    /**
    *   Convenient static method for sending a tweet in one line
    *
    *   @param  newTweet   The tweet to be sent
    *   @return boolean indicating whether the tweet was sent successfully
    */
    public static boolean tweet(final String newTweet){
        SimpleTweet simpleTweetSender = new SimpleTweet();
        return simpleTweetSender.send(newTweet);
    }
    
    /**
    *   Convenient static method for searching for tweets
    *
    *   @param  searchTerm   The term to search for in tweets
    *   @param  limit        The limit of the number of tweets to return (max 100)
    *   @return TwitterSearchResponse with search results
    */
    public static TwitterSearchResponse search(final String searchTerm, final Integer count){
        SimpleTweet simpleTweet = new SimpleTweet();
        return simpleTweet.searchFor(searchTerm, count);   
    }

    public SimpleTweet(){}
    
    /**
    *   Create the request and sends a tweet
    *
    *   @param  newTweet   The tweet to be sent
    *   @return boolean indicating whether the tweet was sent successfully
    */
    public boolean send(final String newTweet){
        String body = 'status='+EncodingUtil.urlEncode(newTweet,'UTF-8');

        HttpRequest request = buildPostRequest(POST_STATUS_COMMAND, body);
        HTTPResponse res = sendRequest(request);        

        return (res.getStatusCode()==200);
    }

    /**
    *   Method for searching for tweets
    *
    *   @param  searchTerm   The term to search for in tweets
    *   @param  limit        The limit of the number of tweets to return (max 100)
    *   @return TwitterSearchResponse with search results
    */
    public TwitterSearchResponse searchFor(final String searchTerm, Integer count){
        String encodedSearch = EncodingUtil.urlEncode(searchTerm,'UTF-8');

        //q=%SEARCH_TERM%&result_type=mixed&count=%SEARCH_LIMIT%
        PageReference urlBuilder = new PageReference(SEARCH_COMMAND);
        urlBuilder.getParameters().put('q', encodedSearch);
        urlBuilder.getParameters().put('count', String.valueOf(count));
        urlBuilder.getParameters().put('result_type', 'mixed');

        HttpRequest request = buildGetRequest(urlBuilder.getUrl()); 
        HTTPResponse res = sendRequest(request);   

        TwitterSearchResponse searchResponse;

        if (res.getStatusCode()!=200){
            throw new TwitterResponseException('Error: (' + res.getStatusCode() + ') ' + res.getBody() );
        }

        // grab the body and parse it as tweets
        String JSONString = res.getBody();
        searchResponse = (TwitterSearchResponse) JSON.deserialize(JSONString, TwitterSearchResponse.class);

        return searchResponse;
    }
    
    private HttpRequest buildGetRequest(final String requestUrl){
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setEndpoint(requestUrl); 
        request.setMethod(GET_TRANSACTION);
        setAuthorization(request);
        return request;
    }

    private HttpRequest buildPostRequest(final String requestUrl, final String body){
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setEndpoint(requestUrl); 
        request.setMethod(POST_TRANSACTION);
        request.setBody(body);
        setAuthorization(request);
        return request;
    }
    
    private void setAuthorization(HttpRequest request){
        // start building the oauth envelope
        String nonce = String.valueOf(Crypto.getRandomLong());
        String timestamp = String.valueOf(DateTime.now().getTime()/1000);
        
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_consumer_key',consumerKey);
        if(accessToken!=null) {
            parameters.put('oauth_token',accessToken);
        }
        
        parameters.put('oauth_signature_method','HMAC-SHA1');
        parameters.put('oauth_timestamp',timestamp);
        parameters.put('oauth_nonce',nonce);
        parameters.put('oauth_callback',callbackUrl);
        
        String baseString = createBaseString(parameters, request);
        Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(baseString), 
                                       Blob.valueOf(consumerSecret+'&'+
                                                           (accessTokenSecret!=null ? accessTokenSecret : '')));
        String signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');
        
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        header = header + 'oauth_signature="'+signature+'"';
        request.setHeader('Authorization',header);
    }   
    
    private HTTPResponse sendRequest(HttpRequest request){
        Http http = new Http();
        HTTPResponse res = http.send(request);
        
        if (DEBUG_MODE){
            system.debug('Twitter Response(' + res.getStatusCode() + '): ' + res.getBody());
        }
        
        return res;
    }
    
    private static String createBaseString(Map<String,String> oauthParams, HttpRequest request) {
        Map<String,String> parameters = oauthParams.clone();
        if((request.getMethod().equalsIgnoreCase(POST_TRANSACTION)) && 
            (request.getBody()!=null) && 
            (request.getHeader('Content-Type').equals('application/x-www-form-urlencoded'))) {
                   parameters.putAll(getUrlParams(request.getBody()));
        }

        String host = request.getEndpoint();
        Integer numParams = host.indexOf('?');
        if(numParams>-1) {
            parameters.putAll(getUrlParams(host.substring(numParams+1)));
            host = host.substring(0,numParams);
        }

        List<String> keys = new List<String>();
        keys.addAll(parameters.keySet());
        keys.sort();
        String paramString = keys.get(0)+'='+parameters.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
                paramString = paramString + '&' + keys.get(i)+'='+parameters.get(keys.get(i));
        }

        // According to OAuth spec, host string should be lowercased, but Google and LinkedIn
        // both expect that case is preserved.
        return request.getMethod().toUpperCase()+ '&' + 
                EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
                EncodingUtil.urlEncode(paramString, 'UTF-8');
    }
        
    private static Map<String,String> getUrlParams(final String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value.equals('')) {
                return res;
        }
        for(String param : value.split('&')) {
            List<String> keyValue = param.split('=');
            if(keyValue.size()>1) {
              // RFC 5849 section 3.4.1.3.1 and 3.4.1.3.2 specify that parameter names 
              // and values are decoded then encoded before being sorted and concatenated
              // Section 3.6 specifies that space must be encoded as %20 and not +
              String encName = EncodingUtil.urlEncode(EncodingUtil.urlDecode(keyValue[0], 'UTF-8'), 'UTF-8').replace('+','%20');
              String encValue = EncodingUtil.urlEncode(EncodingUtil.urlDecode(keyValue[1], 'UTF-8'), 'UTF-8').replace('+','%20');

              res.put(encName,encValue);
            }
        }
        return res;
    }

    public class TwitterSearchResponse{
        public List<Tweet> statuses {get;set;}
        public TwitterSearchResponse(){

        }
    }

    public class TwitterResponseException extends Exception {}
}
public class TwitterAuthentication{

/* method to generate the bearer */
private String getBearerToken() {
//Encode them
String keyencoded = EncodingUtil.urlEncode('TwitterKey.Consumer_key__c' , 'UTF-8');
String secretkeyencoded = EncodingUtil.urlEncode('TwitterKey.Consumer_secret__c' , 'UTF-8');
 
//Create Final Key String
String sFinal = keyencoded + ':' + secretkeyencoded;
//Convert to Blob
Blob headerValue = Blob.valueOf(sFinal);
 
//Build Request
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.twitter.com/oauth2/token');
req.setMethod('POST');
 
//Add Auth Header
String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
req.setHeader('Authorization', authorizationHeader);
 
//You need to add this to the request - proved easy to miss in instructions...
req.setBody('grant_type=client_credentials');
 
//Make request
Http http = new Http();
HTTPResponse res = http.send(req);
String stoken;
//Parse JSON for Bearer Token
JSONParser parser = JSON.createParser(res.getBody());
while (parser.nextToken() != null) {
if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token'){
parser.nextToken();
stoken = parser.getText();
}
}
//Return Token so it can be used in next call
return stoken;
}

/*  authenticate your request  */

private void submittotwitter () {
HttpRequest req2 = new HttpRequest();
//I actually store the endpoint in the same custom setting and build dynamically, but for purposes of demo:
req2.setEndpoint('https://api.twitter.com/1.1/users/lookup.json?screen_name=EventAcu,salesforce');
req2.setMethod('GET');
 
//Call Bearer token Method
//Note - unless invalidated, I believe you can store this and keep using it indefinitely, but again, to demo concept
String authorizationHeader = 'Bearer ' + getBearerToken();
req2.setHeader('Authorization', authorizationHeader);
 
Http http = new Http();
HTTPResponse res = http.send(req2);
String sBody = res.getBody();
 
//I have a Twitter Results class to de-serialize the results into (See below)
 Map <String, TwitterResults> TwitterResultsMap = new Map<String, TwitterResults>();
 
//You can generate one here: http://json2apex.herokuapp.com/makeApex
//I can then pass the results back as a return, or set the map as s public variable on the class
 
//Use native JSON parser to turn results into a list of TwitterResults

 //Use native JSON parser to turn results into a list of TwitterResults
List<TwitterResults> tresults = TwitterResults.parse(sBody);
//The key is set to be the twitter handle name that I am storing in SFDC
For (TwitterResults t: tresults) {
TwitterResultsMap.put(t.screen_name, t);
}
 
}

}
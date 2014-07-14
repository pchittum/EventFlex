public class TwitterResults{
 
    public Integer id;
    public Integer listed_count;
    public String screen_name;
    public String url;
    public Integer followers_count;
    public Integer friends_count;
    public Integer statuses_count;
 
    public static List<TwitterResults> parse(String json) {
        return (List<TwitterResults>) System.JSON.deserialize(json, List<TwitterResults>.class);
    }
 }
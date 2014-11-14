import com.temboo.core.*;
import com.temboo.Library.Instagram.*;

//JSONObject response;
//PrintWriter output;

JSONObject json;


  String tagmax ="starter";
  int conversion;
  JSONArray comments = new JSONArray();
  JSONArray likes = new JSONArray();
  JSONArray selflike = new JSONArray();
  JSONArray pics = new JSONArray();
  JSONArray filters = new JSONArray();
  JSONArray captions = new JSONArray();
  JSONArray tags = new JSONArray();
  String url ="placeholder";

//ChoreoInputSet.addOutputFilter(result_label, data_path, choreo_output)
// Create a session using your Temboo account application details
TembooSession session = new TembooSession("username temboo", "myFirstApp", "your key");

void setup() {

  json = new JSONObject();
  // Run the RecentlyTaggedMedia Choreo function
  runRecentlyTaggedMediaChoreo();
  saveThePlanet();
}

void runRecentlyTaggedMediaChoreo() {

//there needs to be an overarching forloop
for (int i = 0; i < 5000; i++){
 
  // Create the Choreo object using your Temboo session
  RecentlyTaggedMedia recentlyTaggedMediaChoreo = new RecentlyTaggedMedia(session);

  // Set credential
  recentlyTaggedMediaChoreo.setCredential("InstagramAccount");

  // Set inputs
 recentlyTaggedMediaChoreo.setMaxID(tagmax); //PAGINATION
 recentlyTaggedMediaChoreo.setTagName("blithe");

  //Set outputs 
  recentlyTaggedMediaChoreo.addOutputFilter("max", "/pagination/next_max_tag_id", "Response");
  recentlyTaggedMediaChoreo.addOutputFilter("comments", "/data/comments/count", "Response");
  recentlyTaggedMediaChoreo.addOutputFilter("likes", "/data/likes/count", "Response");
  recentlyTaggedMediaChoreo.addOutputFilter("self-like", "/data/user_has_liked", "Response");
  recentlyTaggedMediaChoreo.addOutputFilter("pics", "/data/images/low_resolution/url", "Response");
  recentlyTaggedMediaChoreo.addOutputFilter("filters", "/data/filter", "Response");
//  recentlyTaggedMediaChoreo.addOutputFilter("captions", "/data/caption/text", "Response");
  for (int m = 1; m < 20; m++) {
     recentlyTaggedMediaChoreo.addOutputFilter("tags" + m, "/data[" + m + "]/tags", "Response");
  }

  // Run the Choreo and store the results
  RecentlyTaggedMediaResultSet recentlyTaggedMediaResults = recentlyTaggedMediaChoreo.run();

  // Results
  tagmax = recentlyTaggedMediaResults.getResultList("max").getString(0);

 for (int k = 1; k < 20; k++) {
    //COMMENTS
    conversion = Integer.parseInt(recentlyTaggedMediaResults.getResultList("comments").getString(k));
    comments.append(conversion);
    
   //LIKES
    conversion = Integer.parseInt(recentlyTaggedMediaResults.getResultList("likes").getString(k));
    likes.append(conversion);
    
    //CAPTIONS
    //captions.append(recentlyTaggedMediaResults.getResultList("captions").getString(k));
    
    //FILTERS
    filters.append(recentlyTaggedMediaResults.getResultList("filters").getString(k));
    
    //PICS
    url =recentlyTaggedMediaResults.getResultList("pics").getString(k).replace("\\",""); 
    pics.append(url);
    
    //TAGS
    for (int j = 0; j < recentlyTaggedMediaResults.getResultList("tags" + k).size(); j++) {
      tags.append(recentlyTaggedMediaResults.getResultList("tags" + k).getString(j));
      println(recentlyTaggedMediaResults.getResultList("tags" + k).getString(j));
    }//end tags for
    
    }//end expansion for
    
 }//end overarching for
 
}//end recentlyTaggedMediaChoreo


void saveThePlanet(){
  json.setJSONArray("comments", comments);
  json.setJSONArray("likes", likes);
  json.setJSONArray("self-like", selflike);
  json.setJSONArray("pics", pics);
  json.setJSONArray("filters", filters);
  json.setJSONArray("captions", captions);
  json.setJSONArray("tags", tags);
  saveJSONObject(json, "data/finalBankBlithe.json");

}


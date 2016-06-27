package com.grabmo.service;


import android.app.Notification;
import android.content.Context;
import android.content.Intent;

import com.parse.ParsePushBroadcastReceiver;

import org.json.JSONException;
import org.json.JSONObject;

public class GrabPushBroadcastReceiver extends ParsePushBroadcastReceiver {

public static final String PARSE_DATA_KEY = "com.parse.Data";

   @Override
   protected Notification getNotification(Context context, Intent intent) {
      // deactivate standard notification
      return null;
   }

   @Override
   protected void onPushOpen(Context context, Intent intent) 
   {
      // Implement       
   }  

   @Override
   protected void onPushReceive(Context context, Intent intent) 
   {

         /*Intent i = new Intent(context, MainActivity.class);
         i.putExtras(intent.getExtras());
        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(i);*/

      JSONObject data = getDataFromIntent(intent);

      int postId;
      String title;

      try
      {

         postId = data.getInt("postId");
         title = data.getString("title");

      } catch (JSONException e)
      {
         e.printStackTrace();
      }

      //ACA HANDLING PUSH

      super.onPushReceive(context, intent);

   }

   private JSONObject getDataFromIntent(Intent intent) {
      JSONObject data = null;
      try {
         data = new JSONObject(intent.getExtras().getString(PARSE_DATA_KEY));
      } catch (JSONException e) {
         // Json was not readable...
      }
      return data;
   }

}
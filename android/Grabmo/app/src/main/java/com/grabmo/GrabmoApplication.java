package com.grabmo;

import android.app.Application;
import android.content.res.Configuration;
import android.util.Log;

import com.parse.Parse;
import com.parse.ParseException;
import com.parse.ParseInstallation;
import com.parse.SaveCallback;

/**
 * Created by jose on 6/27/16.
 */
public class GrabmoApplication extends Application
{


	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
	}

	@Override
	public void onCreate() {
		super.onCreate();

		String appId = "fsLv65faQqwqhliCGF7oGqcT8MxPDFjmcxIuonGw";
		String appKey = "T3PK1u0NQ36eZm91jM0TslCREDj8LBeKzGCsrudE";

		Parse.initialize(this, appId, appKey);

		//Parse.enableLocalDatastore(this);

		Parse.setLogLevel(Log.VERBOSE);

		//ParseAnalytics.trackAppOpenedInBackground();

		ParseInstallation.getCurrentInstallation().saveInBackground(new SaveCallback() {

			@Override
			public void done(ParseException e)
			{

				if (e == null)
				{
					String devicetoken = (String) ParseInstallation.getCurrentInstallation().get("deviceToken");
				}
			}

		});


	}

	@Override
	public void onLowMemory() {
		super.onLowMemory();
	}

	@Override
	public void onTerminate() {
		super.onTerminate();
	}


}

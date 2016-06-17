package com.grabmo.utils;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import cz.msebera.android.httpclient.Header;

/**
 * Created by mariano on 6/1/16.
 **/
public class Utils {

    public static void add(Activity context, String key, int value, String key1, int value1, String timeKey, long time) throws JSONException {
        JSONArray array = new JSONArray(KeySaver.isExist(context, "database") ? KeySaver.getStringSavedShare(context, "database") : "[]");
        JSONObject item = new JSONObject();
        item.put(key, value);
        item.put(key1, value1);
        item.put(timeKey, time);
        array.put(item);
        KeySaver.saveShare(context, "database", array.toString());
    }

    public static int convertDpToPixel(Context ctx, int dp) {
        float density = ctx.getResources().getDisplayMetrics().density;
        return Math.round((float) dp * density);
    }

    public static String setGlideDrawable(String drawable) {
        return "android.resource://com.grabmo/drawable/" + drawable;
    }

    public static String parseTime(long currentTimeInMillis) {
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd,yyyy HH:mm");
        Date resultDate = new Date(currentTimeInMillis);
        return sdf.format(resultDate);
    };

    public static HashMap<String, String> convertHeadersToHashMap(Header[] headers) {
        HashMap<String, String> result = new HashMap<>(headers.length);
        for (Header header : headers) {
            result.put(header.getName(), header.getValue());
        }
        return result;
    }

    public static String decodeUTF8(byte[] bytes) {
        return new String(bytes, Charset.forName("UTF-8"));
    }

    public static class PropertyClient {

        private AsyncHttpClient client = new AsyncHttpClient();

        public void get(String url, RequestParams params, AsyncHttpResponseHandler responseHandler) {
            client.get(getAbsoluteUrl(url), params, responseHandler);
        }

        public void post(String url, RequestParams params, AsyncHttpResponseHandler responseHandler) {
            client.post(getAbsoluteUrl(url), params, responseHandler);
        }

        private String getAbsoluteUrl(String relativeUrl) {
            return relativeUrl;
        }
    }
}

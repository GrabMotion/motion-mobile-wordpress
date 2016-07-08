package com.grabmo.fragment;

import android.app.Fragment;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.grabmo.R;
import com.grabmo.adapter.NotificationAdapter;
import com.grabmo.model.NotificationList;
import com.grabmo.utils.Utils;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.parse.ParseUser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import cz.msebera.android.httpclient.Header;

public class NotificationFragment extends Fragment {

    private List<NotificationList> notificationList = new ArrayList<>();

    private NotificationAdapter nAdapter;

    private ProgressDialog progressDialog;

    private static final String BASE_NOTIFICATIONS_URL = "http://grabmotion.co/wp-json/gm/v1/notifications/";

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_noti, container, false);

        RecyclerView mRecycleView = (RecyclerView) view.findViewById(R.id.noti_list);

        String currentUser = ParseUser.getCurrentUser().getObjectId();

        AsyncConnection(BASE_NOTIFICATIONS_URL + currentUser);

        mRecycleView.setLayoutManager(new LinearLayoutManager(getActivity(), LinearLayoutManager.VERTICAL, false));
        nAdapter = new NotificationAdapter(getActivity(), notificationList);
        mRecycleView.setAdapter(nAdapter);

        nAdapter.setOnItemClickListener(onItemNotificationClickListener);

        return view;
    }

    NotificationAdapter.OnItemClickListener onItemNotificationClickListener = new NotificationAdapter.OnItemClickListener() {

        @Override
        public void onItemClick(View view, int position) {

        }

    };

    private NotificationList setSlider(int instance_id,
                                       String camera_name,
                                       String terminal_name,
                                       String day_label,
                                       String instance_media_url,
                                       int instance_elapsed_time,
                                       String recognition_name,
                                       String location_city) {
        return new NotificationList(instance_id, camera_name, terminal_name, day_label, instance_media_url, instance_elapsed_time, recognition_name, location_city);
    }

    private void AsyncConnection(String urlConnection) {

        new Utils.PropertyClient().get(urlConnection, null, new AsyncHttpResponseHandler() {

            @Override
            public void onStart() {
                super.onStart();

                if (notificationList.size() > 0) {
                    notificationList.clear();
                }

                progressDialog = new ProgressDialog(getActivity());
                progressDialog.setMessage("Loading...");
                progressDialog.setIndeterminate(true);
                progressDialog.setCancelable(false);
                progressDialog.show();

            }

            @Override
            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {

                progressDialog.dismiss();

                Log.e("response", Utils.decodeUTF8(responseBody));

                try {

                    JSONObject device = new JSONObject(Utils.decodeUTF8(responseBody));

                    JSONArray terminals = device.getJSONArray("notifications");

                    for (int i = 0; i < terminals.length(); i++) {

                        JSONObject terminal = terminals.getJSONObject(i);

                        notificationList.add(setSlider(
                                terminal.getInt("instance_id"),
                                terminal.getString("camera_name"),
                                terminal.getString("terminal_name"),
                                terminal.getString("day_label"),
                                terminal.getString("instance_media_url"),
                                terminal.getInt("instance_elapsed_time"),
                                terminal.getString("recognition_name"),
                                terminal.getString("location_city")));
                    }

                    nAdapter.notifyDataSetChanged();

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }


            @Override
            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                Log.e("responseFail", Utils.decodeUTF8(responseBody));
            }
        });
    }

}

package com.grabmo.fragment;

import android.app.Fragment;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.flaviofaria.kenburnsview.KenBurnsView;
import com.grabmo.R;
import com.grabmo.adapter.NotificationAdapter;
import com.grabmo.model.NotificationList;
import com.grabmo.utils.Utils;
import com.joooonho.SelectableRoundedImageView;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.parse.ParseUser;
import com.wang.avi.AVLoadingIndicatorView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import cz.msebera.android.httpclient.Header;

public class NotificationFragment extends Fragment
{

    private RecyclerView nRecycleView;

    private List<NotificationList> notificationList = new ArrayList<>();

    private RecyclerView mRecyclerView;
    private GridLayoutManager mLinearLayoutManager;
    private NotificationAdapter nAdapter;

    private AVLoadingIndicatorView mProgress;

    private boolean loading = true;
    int pastVisibleItems, visibleItemCount, totalItemCount;
    private View coordinatorLayoutView;

    private KenBurnsView mCoverFavorite;

    private SwipeRefreshLayout mSwipe;

    private SelectableRoundedImageView offlineImage;
    private SelectableRoundedImageView profileImage;

    private ProgressDialog progressDialog;

    private static final String BASE_NOTIFICATIONS_URL = "http://grabmotion.co/wp-json/gm/v1/notifications/";

    public NotificationFragment()
    {

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_noti, container, false);

        nRecycleView = (RecyclerView) view.findViewById(R.id.noti_list);

        String currentuser = ParseUser.getCurrentUser().getObjectId();

        AsyncConnection(BASE_NOTIFICATIONS_URL + currentuser);


        nRecycleView.setLayoutManager(new GridLayoutManager(getActivity(), 2, GridLayoutManager.VERTICAL, false));
        nAdapter = new NotificationAdapter(getActivity(), notificationList);
        nRecycleView.setAdapter(nAdapter);

        /*nAdapter = new NotificationAdapter(getActivity(), notificationList);
        mLinearLayoutManager = new GridLayoutManager(getActivity(), 2);
        mLinearLayoutManager.setOrientation(GridLayoutManager.VERTICAL);*/
        //mRecyclerView.setLayoutManager(mLinearLayoutManager);
        //mRecyclerView.setAdapter(nAdapter);

        nAdapter.setOnItemClickListener(onItemNotificationClickListener);

        return view;
    }

    NotificationAdapter.OnItemClickListener onItemNotificationClickListener = new NotificationAdapter.OnItemClickListener() {

        @Override
        public void onItemClick(View view, int position)
        {

        }

    };

    private NotificationList setSlider(int instance_id,
                                       String camera_name,
                                       String terminal_name,
                                       String day_label,
                                       String instance_media_url,
                                       int instance_elapsed_time,
                                       String recognition_name,
                                       String locaton_city)
    {
        return new NotificationList(instance_id, camera_name, terminal_name, day_label, instance_media_url, instance_elapsed_time, recognition_name, locaton_city);
    }

    private void AsyncConnection(String urlConnection)
    {

        new Utils.PropertyClient().get(urlConnection, null, new AsyncHttpResponseHandler()
        {

            @Override
            public void onStart() {
                super.onStart();

                if (notificationList.size() > 0)
                {
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
                                Utils.setGlideDrawable("instance_media_url"),
                                terminal.getInt("instance_elapsed_time"),
                                terminal.getString("recognition_name"),
                                terminal.getString("locaton_city")));

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

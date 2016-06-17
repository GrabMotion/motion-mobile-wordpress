package com.grabmo.fragment;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.grabmo.R;
import com.grabmo.SliderAdapter;
import com.grabmo.adapter.CamerasAdapter;
import com.grabmo.model.CamerasList;
import com.grabmo.model.DevicesList;
import com.grabmo.utils.KeySaver;
import com.grabmo.utils.Utils;
import com.loopj.android.http.AsyncHttpResponseHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import cz.msebera.android.httpclient.Header;

/**
 * Created by mariano on 5/31/16.
 **/
public class DeviceFragment extends Fragment {

    private ViewPager viewPager;
    private List<DevicesList> devicesLists = new ArrayList<>();
    private List<CamerasList> camerasLists = new ArrayList<>();
    private SliderAdapter adapterSlider;

    private static final String BASE_DEVICE_URL = "http://grabmotion.co/wp-json/gm/v1/devices/";
    private static final String BASE_CLIENT_URL = "http://grabmotion.co/wp-json/gm/v1/client/";
    private CamerasAdapter camerasAdapter;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_device, container, false);

        viewPager = (ViewPager) view.findViewById(R.id.devices_list);

        int padding = Utils.convertDpToPixel(getActivity(), 80);

        viewPager.setPadding(padding, 0, padding, 0);
        viewPager.setClipToPadding(false);
        viewPager.setPageMargin(0);

        adapterSlider = new SliderAdapter(getActivity(), devicesLists);
        viewPager.setAdapter(adapterSlider);
        adapterSlider.setOnItemClickListener(onDeviceClickListener);
        adapterSlider.setOnItemClickInfoListener(onInfoClickListener);

        AsyncConnection(BASE_DEVICE_URL + KeySaver.getIntSavedShare(getActivity(), "userId"));

        RecyclerView recyclerCameras = (RecyclerView) view.findViewById(R.id.cameras_list);
        recyclerCameras.setLayoutManager(new GridLayoutManager(getActivity(), 2, GridLayoutManager.VERTICAL, false));
        camerasAdapter = new CamerasAdapter(getActivity(), camerasLists);
        recyclerCameras.setAdapter(camerasAdapter);

        return view;
    }

    SliderAdapter.OnItemClickListener onDeviceClickListener = new SliderAdapter.OnItemClickListener() {
        @Override
        public void onItemClick(View view, int position) {
            Toast.makeText(getActivity(), "Testing " + position, Toast.LENGTH_SHORT).show();
        }
    };

    SliderAdapter.OnItemClickInfoListener onInfoClickListener = new SliderAdapter.OnItemClickInfoListener() {
        @Override
        public void onItemClick(View view, int position) {
            Toast.makeText(getActivity(), "Testing info " + position, Toast.LENGTH_SHORT).show();
        }
    };

    private DevicesList setSlider(String name, String image, String id) {
        return new DevicesList(name, image, id);
    }

    private CamerasList setCameras(String name, String image, String id) {
        return new CamerasList(name, image, id);
    }

    private void AsyncConnection(String urlConnection) {
        new Utils.PropertyClient().get(urlConnection, null, new AsyncHttpResponseHandler() {

            @Override
            public void onStart() {
                super.onStart();
            }

            @Override
            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                Log.e("response", Utils.decodeUTF8(responseBody));
                try {
                    JSONObject device = new JSONObject(Utils.decodeUTF8(responseBody));
                    JSONArray terminals = device.getJSONArray("terminals");
                    for (int i = 0; i < terminals.length(); i++) {
                        JSONObject terminal = terminals.getJSONObject(i);
                        devicesLists.add(setSlider(terminal.getString("terminal_hardare")
                                , Utils.setGlideDrawable("deviceone")
                                , String.valueOf(terminal.getInt("terminal_id"))));

                        JSONArray cameras = terminal.getJSONArray("cameras");
                        for (int c = 0; c < cameras.length(); c++) {
                            JSONObject camera = cameras.getJSONObject(c);
                            String image = "";
                            String name = "";
                            int id = 0;
                            if (camera.has("name")) {
                                name = camera.getString("name");
                            }
                            if (camera.has("id")) {
                                id = camera.getInt("id");
                            }
                            if (camera.has("last_media_url")) {
                                image = camera.getString("last_media_url");
                            } else {
                                image = "error";
                            }
                            camerasLists.add(setCameras(name, image, String.valueOf(id)));
                        }
                    }
                    adapterSlider.notifyDataSetChanged();
                    camerasAdapter.notifyDataSetChanged();
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

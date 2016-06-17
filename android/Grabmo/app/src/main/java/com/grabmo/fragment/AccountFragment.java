package com.grabmo.fragment;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.grabmo.R;
import com.grabmo.utils.KeySaver;
import com.grabmo.utils.Utils;

import jp.wasabeef.glide.transformations.BlurTransformation;

/**
 * Created by mariano on 5/31/16.
 **/
public class AccountFragment extends Fragment {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_user, container, false);

        ImageView userImage = (ImageView) view.findViewById(R.id.user_image);
        TextView userName = (TextView) view.findViewById(R.id.user_name);

        Glide.with(getActivity()).load(KeySaver.getStringSavedShare(getActivity(), "userImage").contentEquals("error") ? Utils.setGlideDrawable("logograb") : KeySaver.getStringSavedShare(getActivity(), "userImage")).into(userImage);
        userName.setText(KeySaver.getStringSavedShare(getActivity(), "userName"));
        Glide.with(getActivity()).load(Utils.setGlideDrawable("mapgoogle")).bitmapTransform(new BlurTransformation(getActivity(), 5)).into((ImageView) view.findViewById(R.id.account_map));

        return view;
    }
}

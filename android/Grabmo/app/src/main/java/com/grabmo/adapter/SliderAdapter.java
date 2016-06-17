package com.grabmo;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.grabmo.model.DevicesList;

import java.util.List;

/**
 * Created by mariano on 2/28/16.
 **/
public class SliderAdapter extends PagerAdapter {

    private Context CONTEXT;
    private List<DevicesList> itemList;

    private OnItemClickListener mItemClickListener;
    private OnItemClickInfoListener mItemClickInfoListener;

    public SliderAdapter(Context context, List<DevicesList> itemList) {
        this.CONTEXT = context;
        this.itemList = itemList;
    }

    @Override
    public int getCount() {
        return itemList.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((RelativeLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, final int position) {
        final View itemViewPager = LayoutInflater.from(CONTEXT).inflate(R.layout.fragment_slider, container, false);

        ImageView backgroundImage = (ImageView) itemViewPager.findViewById(R.id.slider_image);
        TextView title = (TextView) itemViewPager.findViewById(R.id.slider_text);

        ImageView information = (ImageView) itemViewPager.findViewById(R.id.slider_info);

        title.setText(itemList.get(position).getName());

        if (CONTEXT != null) {
            Glide.with(CONTEXT).load(itemList.get(position).getImage()).into(backgroundImage);
        }

        container.addView(itemViewPager);

        backgroundImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mItemClickListener != null) {
                    mItemClickListener.onItemClick(itemViewPager, position);
                }
            }
        });

        information.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mItemClickInfoListener != null) {
                    mItemClickInfoListener.onItemClick(itemViewPager, position);
                }
            }
        });

        return itemViewPager;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((RelativeLayout) object);
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    public void setOnItemClickListener(final OnItemClickListener mItemClickListener) {
        this.mItemClickListener = mItemClickListener;
    }

    public interface OnItemClickInfoListener {
        void onItemClick(View view, int position);
    }

    public void setOnItemClickInfoListener(final OnItemClickInfoListener mItemClickInfoListener) {
        this.mItemClickInfoListener = mItemClickInfoListener;
    }
}

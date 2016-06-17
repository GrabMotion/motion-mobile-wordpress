package com.grabmo.adapter;

import android.content.Context;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.grabmo.R;
import com.grabmo.model.CamerasList;
import com.grabmo.utils.Utils;

import java.util.List;

import jp.wasabeef.glide.transformations.BlurTransformation;

/**
 * Created by mariano on 4/18/16.
 **/
public class CamerasAdapter extends RecyclerView.Adapter<CamerasAdapter.ViewHolder> {

    private Context context;
    private List<CamerasList> itemList;

    private OnItemClickListener mItemClickListener;

    public CamerasAdapter(Context context, List<CamerasList> itemList) {
        this.itemList = itemList;
        this.context = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_camera, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CamerasAdapter.ViewHolder holder, int position) {

        String cover = itemList.get(position).getImage();
        String name = itemList.get(position).getName();

        holder.mNameText.setMaxLines(1);
        holder.mNameText.setText(name);

        if (cover.contentEquals("error")) {
            Glide.with(context).load(Utils.setGlideDrawable("no_image")).into(holder.mCoverImg);
        } else {
            Glide.with(context).load(cover).into(holder.mCoverImg);
        }
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public int getItemCount() {
        return itemList.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        public ImageView mCoverImg;
        public RelativeLayout mMainView;
        public TextView mNameText;

        public ViewHolder(View itemView) {
            super(itemView);
            mMainView = (RelativeLayout) itemView.findViewById(R.id.main_holder);
            mCoverImg = (ImageView) itemView.findViewById(R.id.camera_img);
            mNameText = (TextView) itemView.findViewById(R.id.camera_name);
            mMainView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (mItemClickListener != null) {
                mItemClickListener.onItemClick(itemView, getAdapterPosition());
            }
        }
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    public void setOnItemClickListener(final OnItemClickListener mItemClickListener) {
        this.mItemClickListener = mItemClickListener;
    }
}

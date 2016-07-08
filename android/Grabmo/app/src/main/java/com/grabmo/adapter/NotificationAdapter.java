package com.grabmo.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.grabmo.R;
import com.grabmo.model.NotificationList;

import java.util.List;

public class NotificationAdapter extends RecyclerView.Adapter<NotificationAdapter.ViewHolder> {

    private Context context;
    private List<NotificationList> notificationList;

    private OnItemClickListener mItemClickListener;

    public NotificationAdapter(Context context, List<NotificationList> notificationList) {
        this.notificationList = notificationList;
        this.context = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_notification, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(NotificationAdapter.ViewHolder holder, int position) {

        String image = notificationList.get(position).getInstance_media_url();
        String terminal = notificationList.get(position).getTerminal_name();

        holder.mCameraText.setText(terminal);
        holder.mCameraName.setText("Camera: " + notificationList.get(position).getCamera_name());

        if (context != null) {
            Glide.with(context).load(image).into(holder.mNotificationImg);
        }
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public int getItemCount() {
        return notificationList.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        public LinearLayout mMainView;

        public ImageView mNotificationImg;
        public TextView mCameraText;
        public TextView mCameraName;

        public ViewHolder(View itemView) {
            super(itemView);

            mMainView = (LinearLayout) itemView.findViewById(R.id.main_holder);
            mNotificationImg = (ImageView) itemView.findViewById(R.id.notification_img);
            mCameraName = (TextView) itemView.findViewById(R.id.notification_camera_name);
            mCameraText = (TextView) itemView.findViewById(R.id.noti_camera);

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

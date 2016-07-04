package com.grabmo.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.grabmo.R;
import com.grabmo.model.NotificationList;

import java.util.List;

/**
 * Created by jose on 7/1/16.
 */
public class NotificationAdapter extends RecyclerView.Adapter<NotificationAdapter.ViewHolder> {

        private Context context;
        private List<NotificationList> notificationList;

        private String terminal;
        private String image;
        private String camera;

        private OnItemClickListener mItemClickListener;

        public NotificationAdapter(Context context, List<NotificationList> notificationList) {
            this.notificationList = notificationList;
            this.context = context;
        }

        @Override
        public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType)
        {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_notification, parent, false);
            return new ViewHolder(view);
        }

        @Override
        public void onBindViewHolder(NotificationAdapter.ViewHolder holder, int position) {

            image  = notificationList.get(position).getInstance_media_url();
            terminal = notificationList.get(position).getTerminal_name();
            camera = notificationList.get(position).getCamera_name();

            holder.mCameraText.setText(terminal);
            holder.mTerminalText.setText(camera);

            if (context != null)
            {
                Glide.with(context).load(image).into(holder.mNotiImg);
            }
        }

        @Override
        public long getItemId(int position) {
            return 0;
        }

        @Override
        public int getItemCount()
        {
            return notificationList.size();
        }

        public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener{

            public RelativeLayout mMainView;

            public ImageView mNotiImg;
            public TextView mTerminalText;
            public TextView mCameraText;

            public ViewHolder(View itemView)
            {
                super(itemView);

                mMainView = (RelativeLayout) itemView.findViewById(R.id.main_holder);

                mNotiImg = (ImageView) itemView.findViewById(R.id.noti_img);

                mTerminalText = (TextView) itemView.findViewById(R.id.noti_terminal);

                mCameraText = (TextView) itemView.findViewById(R.id.noti_camera);

                //mMainView.setOnClickListener(this);
            }

            @Override
            public void onClick(View v)
            {
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

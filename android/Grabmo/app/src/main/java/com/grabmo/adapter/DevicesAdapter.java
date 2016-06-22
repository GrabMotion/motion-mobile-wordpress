package com.grabmo.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.ViewGroup;
import android.widget.RelativeLayout;


import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.grabmo.SyncActivity;

import com.grabmo.R;
import com.grabmo.model.Device;

import java.util.List;


public class DevicesAdapter extends RecyclerView.Adapter<DevicesAdapter.MyViewHolder> {

    private List<Device> deviceList;

    public OnItemClickListener mItemClickListener;

    private Context context;

    public class MyViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        public TextView ipnumber, hostname, serial;

        private RelativeLayout rootdevice;

        public MyViewHolder(View view)
        {
            super(view);
            ipnumber = (TextView) view.findViewById(R.id.ipnumber);
            hostname = (TextView) view.findViewById(R.id.hostname);
            serial = (TextView) view.findViewById(R.id.serial);
            rootdevice = (RelativeLayout) view.findViewById(R.id.devicerow);
            rootdevice.setOnClickListener(this);
        }

        @Override
        public void onClick(View v)
        {
            if (mItemClickListener != null)
            {
                mItemClickListener.onItemClick(itemView, getAdapterPosition());
            }
        }
    }

    public DevicesAdapter(SyncActivity context, List<Device> deviceList) {
        this.context = context;
        this.deviceList = deviceList;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.device_row, parent, false);

        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        holder.ipnumber.setText(deviceList.get(position).getIpnumber());
        holder.hostname.setText(deviceList.get(position).getHostname());
        holder.serial.setText(deviceList.get(position).getSerial());
    }

    @Override
    public int getItemCount() {
        return deviceList.size();
    }

    public interface OnItemClickListener
    {
        void onItemClick(View view, int position);
    }

    public void setOnItemClickListener(final OnItemClickListener mItemClickListener)
    {
        this.mItemClickListener = mItemClickListener;
    }
}
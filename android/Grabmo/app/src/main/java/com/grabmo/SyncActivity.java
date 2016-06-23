package com.grabmo;

import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.common.io.BaseEncoding;
import com.grabmo.adapter.DevicesAdapter;
import com.grabmo.model.Camera;
import com.grabmo.model.Device;
import com.grabmo.protobuf.Motion;
import com.grabmo.protobuf.Motion.Message;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.ProtocolException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import android.support.v7.widget.RecyclerView;

import java.text.SimpleDateFormat;

import com.google.protobuf.CodedInputStream;

import android.widget.*;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.view.View.OnClickListener;

import com.grabmo.adapter.DevicesAdapter.OnItemClickListener;

import com.parse.ParseQuery;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.ParseRelation;
import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.SaveCallback;

public class SyncActivity extends AppCompatActivity {

    private int udp_port;
    private int tcp_port;
    //private int timeout = 5000;
    public String url_address;
    //public String rasp_url;

    private DevicesAdapter mAdapter;

    private PopupWindow pw;

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;

    private List<Device> devices = new ArrayList<>();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sync);

        View title = findViewById(R.id.titleSync);

        Button find_button = (Button) findViewById(R.id.button_find_devices);

        RecyclerView mRecyclerView = (RecyclerView) findViewById(R.id.recycle_find_devices);

        url_address = "181.29.152.118"; //"255.255.255.255";
        udp_port = Message.SocketType.UDP_PORT.getNumber();
        tcp_port = Message.SocketType.TCP_ECHO_PORT.getNumber();

        mAdapter = new DevicesAdapter(this, devices);

       /* mAdapter.OnItemClickListener onItemClickListener = new mAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
               showPopup();
            }
        };*/

        mAdapter.setOnItemClickListener(new OnItemClickListener()
        {
            @Override
            public void onItemClick(View view, int position)
            {
                showPopup(position);
            }
        });

        assert mRecyclerView != null;
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());
        mRecyclerView.setAdapter(mAdapter);

        assert find_button != null;
        find_button.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                new FindDevices(new OnTaskCompleted() {

                    @Override
                    public void onTaskCompleted(String msg, String url) {

                        System.out.println("Server msg :" + msg);

                        //Motion.Message m = new Motion.MessageOrBuilder();

                        Calendar c = Calendar.getInstance();


                        Message message = Message.newBuilder()
                                .setType(Message.ActionType.ENGAGE)
                                .setPackagesize(Message.SocketType.SOCKET_BUFFER_MEDIUM_SIZE_VALUE)
                                .setServerip(url)
                                .setTime(c.getTime().toString())
                                .build();

                        new SendProto().execute(message);

                    }

                }).execute();

            }
        });


        protoListener = new OnSocketReceived() {

            @Override
            public void socketReceived(final Message motion) {

                switch (motion.getType()) {

                    case ENGAGE:


                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                getEngage(motion);
                                mAdapter.notifyDataSetChanged();

                            }
                        });
                        break;

                    case SERVER_INFO_OK:
                        //TODO: aca vas a tener que ver como pasar la posición del que queres guardar
                        // lo mejor es consiguiendo la posición desde el item que toques si queres uno
                        // o si queres todos, ponerlo en un loop.

                        break;
                }
            }
        };

        assert title != null;
        title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(SyncActivity.this, MainActivity.class));
            }
        });
        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }

    private void showPopup(int position)
    {

        try
        {

            LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
            getSystemService(LAYOUT_INFLATER_SERVICE);

            View layout = inflater.inflate(R.layout.popup_device, (ViewGroup) findViewById(R.id.popup_device));

            pw = new PopupWindow(layout, 300, 370, true);
            pw.showAtLocation(layout, Gravity.CENTER, 0, 0);

            TextView ptext = (TextView) layout.findViewById(R.id.txtView);

            String msg = "Do you want to pair device?";
            ptext.setText(msg);

            Button accept = (Button) layout.findViewById(R.id.accept);
            accept.setTag(position);
            accept.setOnClickListener(accept_button);

            Button reject = (Button) layout.findViewById(R.id.reject);
            reject.setTag(position);
            reject.setOnClickListener(reject_button);

        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    public OnClickListener reject_button = new OnClickListener() {

        public void onClick(View v)
        {
            pw.dismiss();
        }
    };

    public OnClickListener accept_button = new OnClickListener()
    {

        public void onClick(View v)
        {

            if (ParseUser.getCurrentUser() != null)
            {
                int pos = (int) v.getTag();

                final Device cdevice = devices.get(pos);

                //final ParseUser user = ParseUser.getCurrentUser();

                ParseQuery queryuser = ParseUser.getQuery();

                queryuser.findInBackground(new FindCallback<ParseObject>()
                {
                    public void done(List<ParseObject> objectsuser, ParseException e)
                    {
                        if (e == null)
                        {
                            // The query was successful.
                            if (objectsuser.size() > 0)
                            {

                                final ParseObject pfuser = objectsuser.get(0);

                                ParseRelation<ParseObject> device_relation = pfuser.getRelation("device");
                                ParseQuery deviceQuery = device_relation.getQuery();

                                deviceQuery.findInBackground(new FindCallback<ParseObject>() {

                                    public void done(List<ParseObject> objectsdevice, ParseException e)
                                    {

                                        if (objectsdevice.size() == 0)
                                        {
                                            String uiid = UUID.randomUUID().toString();

                                            final ParseObject pdevice = new ParseObject("Device");

                                            pdevice.put("publicipaddress", cdevice.getIppublic());
                                            pdevice.put("model", cdevice.getModel());
                                            pdevice.put("ipaddress", cdevice.getIpnumber());
                                            pdevice.put("hostname", cdevice.getHostname());
                                            pdevice.put("location", cdevice.getLocation());
                                            pdevice.put("uuid_installation", uiid);

                                            pdevice.saveInBackground(new SaveCallback()
                                            {
                                                @Override
                                                public void done(ParseException e)
                                                {

                                                    ParseRelation<ParseObject> device_relation = pfuser.getRelation("device");
                                                    device_relation.add(pdevice);

                                                    pfuser.saveInBackground(new SaveCallback()
                                                    {
                                                        @Override
                                                        public void done(ParseException e) {
                                                            pairDevice();
                                                        }
                                                    });

                                                }
                                            });

                                        } else if (objectsdevice.size() > 0)
                                        {
                                            pairDevice();
                                        }
                                    }
                                });

                            }
                        }
                    }
                });
            }
        }
    };


    public void getEngage(Message motion)
    {

        Message.MotionDevice pdevice = motion.getMotiondevice(0);
        List<Camera> cam = new ArrayList<>();

        for (int i = 0; i < motion.getMotioncameraCount(); i++) {
            Message.MotionCamera pcamera = motion.getMotioncamera(i);

            cam.add(setCameras(pcamera.getCameranumber(), pcamera.getCameraname(), true, pcamera.getDbIdmat()
                    , pcamera.getMatrows(), pcamera.getMatcols(), pcamera.getMatheight(), pcamera.getMatwidth()));

        }

        devices.add(setDevices(pdevice.getIpnumber(), pdevice.getIppublic(),pdevice.getMacaddress(), pdevice.getHostname(), pdevice.getCity(), pdevice.getCountry()
                , pdevice.getLocation(), pdevice.getNetworkProvider(), pdevice.getUptime(), pdevice.getStarttime()
                , pdevice.getDbLocal(), pdevice.getModel(), pdevice.getHardware(), pdevice.getSerial()
                , pdevice.getRevision(), pdevice.getDisktotal(), pdevice.getDiskused(), pdevice.getDiskavailable()
                , pdevice.getDiskPercentageUsed(), pdevice.getTemperature(), cam));

    }

    private Camera setCameras(int cameranumber, String cameraname, boolean recognizing
            , int idmat, int matrows, int matcols
            , int matheight, int matwidth) {
        return new Camera(cameranumber, cameraname, recognizing, idmat, matrows, matcols, matheight, matwidth);
    }

    private Device setDevices(String ipnumber, String ippublic, String macaddress, String hostname, String city, String country
            , String location, String network_provider, String uptime, String starttime
            , int db_local, String model, String hardware, String serial, String revision
            , int disktotal, int diskused, int diskavailable, int disk_percentage_used
            , int temperature, List<Camera> cameras) {
        return new Device(ipnumber, ippublic, macaddress, hostname, city, country
                , location, network_provider, uptime, starttime, db_local, model, hardware, serial
                , revision, disktotal, diskused, diskavailable, disk_percentage_used, temperature
                , cameras);
    }

    @Override
    public void onStart() {
        super.onStart();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client.connect();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW, // TODO: choose an action type.
                "Sync Page", // TODO: Define a title for the content shown.
                // TODO: If you have web page content that matches this app activity's content,
                // make sure this auto-generated web page URL is correct.
                // Otherwise, set the URL to null.
                Uri.parse("http://host/path"),
                // TODO: Make sure this auto-generated app URL is correct.
                Uri.parse("android-app://com.grabmo/http/host/path")
        );
        AppIndex.AppIndexApi.start(client, viewAction);
    }

    @Override
    public void onStop() {
        super.onStop();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW, // TODO: choose an action type.
                "Sync Page", // TODO: Define a title for the content shown.
                // TODO: If you have web page content that matches this app activity's content,
                // make sure this auto-generated web page URL is correct.
                // Otherwise, set the URL to null.
                Uri.parse("http://host/path"),
                // TODO: Make sure this auto-generated app URL is correct.
                Uri.parse("android-app://com.grabmo/http/host/path")
        );
        AppIndex.AppIndexApi.end(client, viewAction);
        client.disconnect();
    }

    public class FindDevices extends AsyncTask<Void, Void, Void> {

        private OnTaskCompleted listener;

        public FindDevices(OnTaskCompleted listener) {
            this.listener = listener;
        }

        @Override
        protected Void doInBackground(Void... params) {

            byte[] buf = new byte[4096];
            DatagramPacket dgp = new DatagramPacket(buf, buf.length);
            DatagramSocket sk = null;

            try {

                sk = new DatagramSocket(udp_port);

            } catch (Exception e) {
                e.printStackTrace();
            }

            System.out.println("Server started");


            try {
                assert sk != null;
                sk.receive(dgp);

            } catch (IOException e) {
                e.printStackTrace();
            }

            String rcvd = new String(dgp.getData(), 0, dgp.getLength()) + ", from address: "
                    + dgp.getAddress() + ", port: " + dgp.getPort();

            System.out.println(rcvd);

            //BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
            //String outMessage = null;

            //outMessage = stdin.readLine();

            //buf = ("Server say: " + outMessage).getBytes();

            listener.onTaskCompleted(rcvd, dgp.getAddress().toString().replace("/", ""));

            return null;
        }
    }

    public interface OnTaskCompleted {
        void onTaskCompleted(String msg, String url);
    }

    private OnSocketReceived protoListener;

    public interface OnSocketReceived {
        void socketReceived(Message motion);
    }

    public void sendProto(Message motion, String url)
    {
        //set up socket
        SocketChannel serverSocket = null;
        try {
            serverSocket = SocketChannel.open();

            serverSocket.socket().setReuseAddress(true);
            serverSocket.connect(new InetSocketAddress(url, tcp_port));
            serverSocket.configureBlocking(true);


        } catch (IOException e) {
            e.printStackTrace();
        }

        //create BAOS for protobuf
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {

            motion.writeDelimitedTo(baos);

        } catch (IOException e) {
            e.printStackTrace();
        }


        //copy the message to a bytebuffer
        //ByteBuffer socketBuffer = ByteBuffer.wrap(baos.toByteArray());

        String baseProto = BaseEncoding.base64().encode(motion.toByteArray());

        ByteBuffer socketBuffer = ByteBuffer.wrap(baseProto.getBytes());

        //BaseEncoding.base64().encode(motion.toByteArray())

        //keep sending until the buffer is empty
        while (socketBuffer.hasRemaining()) {
            try {
                assert serverSocket != null;
                serverSocket.write(socketBuffer);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        //receive message from the client, where BUFFER_SIZE is large enough to contain your message
        socketBuffer = ByteBuffer.allocate(Message.SocketType.SOCKET_BUFFER_BIG_SIZE.getNumber());

        try
        {
            int bytesRead = serverSocket.read(socketBuffer);
        } catch (IOException e) {
            e.printStackTrace();
        }

        //copy message byte array from socket buffer
        socketBuffer.flip();
        byte[] ackBuf = new byte[socketBuffer.remaining()];
        socketBuffer.get(ackBuf);

        String msj = new String(ackBuf);

        String promsg = splitMessage(msj);

        if (promsg==null)
        {
            System.out.println("Socket empty response");
            return;
        }

        BaseEncoding encoding = BaseEncoding.base64();

        byte[] decodebyte = encoding.decode(promsg);

        int size = decodebyte.length;

        CodedInputStream codedIn;
        codedIn = CodedInputStream.newInstance(decodebyte, 0, size);

        Motion.Message m = null;

        try {
            m = Motion.Message.parseFrom(codedIn);

        } catch (IOException e) {
            e.printStackTrace();
        }

//        String d = m.getCurrday();

//        Motion.Message.MotionCamera mc = m.getMotioncamera();

//        int mc = m.getMotioncameraCount();

        if (protoListener != null) {
            protoListener.socketReceived(m);
        }

        //done!
        socketBuffer.clear();

    }

    public void pairDevice()
    {

        ParseQuery queryuser = ParseUser.getQuery();

        queryuser.findInBackground(new FindCallback<ParseObject>() {

            public void done(List<ParseObject> objectsuser, ParseException e) {

                if (e == null) {

                    // The query was successful.
                    if (objectsuser.size() > 0)
                    {

                        final ParseObject user = objectsuser.get(0);

                        final String email = user.getString("email");
                        final String username = user.getString("username");
                        final String first_name = user.getString("first_name");
                        final String last_name = user.getString("last_name");
                        final String objectId = user.getObjectId();
                        final String pfuser = objectId;

                        ParseRelation<ParseObject> client_relation = user.getRelation("client");
                        ParseQuery clientQuery = client_relation.getQuery();

                        clientQuery.findInBackground(new FindCallback<ParseObject>() {

                            public void done(List<ParseObject> objectsclient, ParseException e) {

                                if (objectsclient.size() > 0)
                                {

                                    ParseObject client = objectsclient.get(0);
                                    final String wpuser = client.getString("wp_user");
                                    final int wpuserid = client.getInt("wp_userid");
                                    final String wppassword = client.getString("wp_password");
                                    final int wppostparent = client.getInt("wp_post_parent");
                                    final int wpclientmediaid = client.getInt("wp_client_media_id");
                                    final String wplink = client.getString("wp_link");
                                    final String wpapilink = client.getString("wp_api_link");
                                    final int wpclientid = client.getInt("wp_client_id");
                                    final String wpslug = client.getString("wp_slug");
                                    final String wpserverurl = client.getString("wp_server_url");
                                    final String wpmodified = client.getString("wp_modified");

                                    ParseRelation<ParseObject> device_relation = user.getRelation("device");
                                    ParseQuery deviceQuery = device_relation.getQuery();

                                    deviceQuery.findInBackground(new FindCallback<ParseObject>() {

                                        public void done(List<ParseObject> objectsdevice, ParseException e) {

                                            if (objectsdevice.size() != 0)
                                            {
                                                ParseObject pdevice = objectsdevice.get(0);
                                                String uuidinstallation = pdevice.getString("uuid_installation");
                                                String ipaddress = pdevice.getString("ipaddress");
                                                String publicipaddress = pdevice.getString("publicipaddress");
                                                String hostname = pdevice.getString("hostname");
                                                String model = pdevice.getString("model");
                                                String location = pdevice.getString("location");

                                                String ParseApplicationId = "fsLv65faQqwqhliCGF7oGqcT8MxPDFjmcxIuonGw";
                                                String RestApiKey = "ZRfqjSe0ju8XejHHmJdsfzsYKYsQYBWsYLU40FDB";

                                                Calendar cal = Calendar.getInstance();
                                                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss.SSS");
                                                String time = sdf.format(cal.getTime());

                                                try {

                                                    Motion.Message message = Motion.Message.newBuilder()
                                                            .setType(Message.ActionType.SERVER_INFO)
                                                            .setPackagesize(Message.SocketType.SOCKET_BUFFER_MEDIUM_SIZE_VALUE)
                                                            .setMotionuser(0,
                                                                    Motion.Message.MotionUser.newBuilder()
                                                                            .setWpuser(wpuser)
                                                                            .setWpuserid(wpuserid)
                                                                            .setWppassword(wppassword)
                                                                            .setWpserverurl(wpserverurl)
                                                                            .setWpclientid(wpclientid)
                                                                            .setEmail(email)
                                                                            .setFirstname(first_name)
                                                                            .setLastname(first_name)
                                                                            .setLocation(location)
                                                                            .setUiidinstallation(uuidinstallation)
                                                                            .setClientnumber(wpclientid)
                                                                            .setPfobjectid(objectId)
                                                                            .setWpslug(wpslug)
                                                                            .setWplink(wplink)
                                                                            .setWpapilink(wpapilink)
                                                                            .setWpmodified(wpmodified)
                                                                            .setWpparent(0)
                                                                            .setPfuser(pfuser)
                                                                            .setPfappid(ParseApplicationId)
                                                                            .setPfrestapikey(RestApiKey))
                                                            .setServerip(ipaddress)
                                                            .setTime(time)
                                                            .build();


                                                    new SendProto().execute(message);


                                                } catch (Exception pe)
                                                {
                                                    System.out.println("Exception: "+pe.toString());

                                                }
                                            }
                                        }
                                    });
                                }
                            }

                        });
                    }

                } else {
                    // results have all the Posts the current user liked.
                    Log.e("else", "true");
                }
            }
        });
    }

    public class SendProto extends AsyncTask<Message, Void, Void>
    {

        @Override
        protected Void doInBackground(Message ... params)
        {
            Message message = params[0];
            String url = message.getServerip();
            sendProto(message, url);
            return null;
        }
    }

    public String splitMessage(String message) {

        if (message.isEmpty())
        {
            return null;
        }
        String del_1 = "PROSTA";
        String del_2 = "PROSTO";

        int total__packages = 0;
        int current_package = 0;
        int current____type = 0;
        int proto_has_files = 0;
        int package____size = 0;

        String logicdata = message.substring(message.indexOf(del_1) + del_1.length(), message.indexOf(del_2));

        String[] separated = logicdata.split("::");

        package____size = Integer.parseInt(separated[0]);
        total__packages = Integer.parseInt(separated[1]);
        current_package = Integer.parseInt(separated[2]);
        current____type = Integer.parseInt(separated[3]);
        proto_has_files = Integer.parseInt(separated[4]);

        String payload = message.substring(message.indexOf(del_2) + del_2.length());

        return payload;
    }
}

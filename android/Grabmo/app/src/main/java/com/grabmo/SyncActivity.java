package com.grabmo;

import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.util.Base64;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.common.io.BaseEncoding;
import com.grabmo.adapter.DevicesAdapter;
import com.grabmo.protobuf.Motion;
import com.grabmo.protobuf.Motion.Message;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.charset.Charset;
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

import static com.grabmo.adapter.DevicesAdapter.*;

public class SyncActivity extends AppCompatActivity {

    private int udp_port;
    private int tcp_port;
    private int timeout;
    public String url_address;
    public String rasp_url;

    private RecyclerView mRecyclerView;
    private DevicesAdapter mAdapter;
    private RecyclerView.LayoutManager mLayoutManager;

    private PopupWindow pw;
    private Button Accept;
    private Button Reject;
    private TextView ptext;

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

        mRecyclerView = (RecyclerView) findViewById(R.id.recycle_find_devices);

        this.url_address = "255.255.255.255";
        this.udp_port = Message.SocketType.UDP_PORT.getNumber();
        this.tcp_port = Message.SocketType.TCP_ECHO_PORT.getNumber();
        this.timeout = 5000;

        mAdapter = new DevicesAdapter(this, devices);

        mAdapter.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position)
            {
                showPopup();
            }
        });

        RecyclerView.LayoutManager mLayoutManager = new LinearLayoutManager(this,LinearLayoutManager.VERTICAL,false);
        mRecyclerView.setLayoutManager(mLayoutManager);
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());
        mRecyclerView.setAdapter(mAdapter);      

        assert find_button != null;
        find_button.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                new FindDevices(new OnTaskCompleted() {

                    @Override
                    public void onTaskCompleted(String msg, String url)
                    {

                        System.out.println("Server msg :" + msg);

                        //Motion.Message m = new Motion.MessageOrBuilder();

                        Calendar c = Calendar.getInstance();


                        Message message = Message.newBuilder()
                                .setType(Message.ActionType.ENGAGE)
                                .setPackagesize(Message.SocketType.SOCKET_BUFFER_MEDIUM_SIZE_VALUE)
                                .setServerip(url)
                                .setTime(c.getTime().toString())
                                .build();


                        sendProto(message, url);

                    }

                }).execute();

            }
        });



        protoListener = new OnSocketReceived()
        {

            @Override
            public void OnSocketReceived(Message motion)
            {

                switch (motion.getType())
                {

                    case ENGAGE:                        
                        Device device_engage = getEngage(motion);
                        devices.add(device_engage);

                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {

                                mAdapter.notifyDataSetChanged();

                            }
                        });

                        break;

                    case REC_START:
                        break;
                    case REC_RUNNING:
                        break;
                    case REC_STOP:
                        break;
                    case UNENGAGE:
                        break;
                    case GET_TIME:
                        break;
                    case SET_TIME:
                        break;
                    case TIME_SET:
                        break;
                    case STRM_START:
                        break;
                    case STRM_STOP:
                        break;
                    case TAKE_PICTURE:
                        break;
                    case DISSCONNECT:
                        break;
                    case REFRESH:
                        break;
                    case GET_XML:
                        break;
                    case GET_IMAGE:
                        break;
                    case GET_VIDEO:
                        break;
                    case SAVE:
                        break;
                    case OPEN:
                        break;
                    case UPDATE:
                        break;
                    case SAVE_OK:
                        break;
                    case UPDATE_OK:
                        break;
                    case GET_MAT:
                        break;
                    case RESPONSE_OK:
                        break;
                    case RESPONSE_NEXT:
                        break;
                    case RESPONSE_END:
                        break;
                    case RESPONSE_FINISH:
                        break;
                    case REC_HAS_CHANGES:
                        break;
                    case REC_HAS_INSTANCE:
                        break;
                    case PROTO_HAS_FILE:
                        break;
                    case PROTO_NO_FILE:
                        break;
                    case SERVER_INFO:
                        break;
                    case SERVER_INFO_OK:
                        Device device_info = (Device) getEngage(motion);
                        storeDeviceToParse(device_info);
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
        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }

    private void showPopup()
    {

        try
        {
            LayoutInflater inflater = (LayoutInflater) getSystemService(this.LAYOUT_INFLATER_SERVICE);
            getSystemService(this.LAYOUT_INFLATER_SERVICE);

            View layout = inflater.inflate(R.layout.popup_device,
                    (ViewGroup) findViewById(R.id.popup_device));

            pw = new PopupWindow(layout, 300, 370, true);
            pw.showAtLocation(layout, Gravity.CENTER, 0, 0);

            ptext = (TextView) layout.findViewById(R.id.txtView);

            String msg = "Do you want to pair device?";
            ptext.setText(msg);

            Accept = (Button) layout.findViewById(R.id.accept);
            Accept.setOnClickListener(accept_button);

            Reject = (Button) layout.findViewById(R.id.reject);
            Reject.setOnClickListener(reject_button);

        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    public OnClickListener reject_button = new OnClickListener()
    {
        public void onClick(View v)
        {
            pw.dismiss();
        }
    };

    public OnClickListener accept_button = new OnClickListener()
    {
        public void onClick(View v)
        {
            pairDevice();
        }
    };

    public void storeDeviceToParse(Device device)
    {

        if (ParseUser.getCurrentUser()!=null)
        {
            String uiid = UUID.randomUUID().toString();

            ParseUser user = ParseUser.getCurrentUser();

            ParseObject pdevice = new ParseObject("Device");
            pdevice.put("publicipaddress", device.ippublic);        
            pdevice.put("model", device.model);        
            pdevice.put("ipaddress", device.ipnumber);        
            pdevice.put("hostname", device.hostname);        
            pdevice.put("location", device.location);
            pdevice.put("uuid_installation", uiid);
            pdevice.saveInBackground();

            ParseRelation<ParseObject> client_relation = user.getRelation("client");
            client_relation.add(pdevice);

            user.put("first_name", user);

            user.saveInBackground();  
        }
    }

    public Device getEngage(Message motion)
    {
        Message.MotionDevice pdevice = motion.getMotiondevice(0);

        device.macaddress = pdevice.getMacaddress();
        device.hostname = pdevice.getHostname();
        device.city = pdevice.getCity();
        device.country = pdevice.getCountry();
        device.location = pdevice.getLocation();
        device.network_provider = pdevice.getNetworkProvider();
        device.uptime = pdevice.getUptime();
        device.starttime = pdevice.getStarttime();
        device.db_local = pdevice.getDbLocal();
        device.model = pdevice.getModel();
        device.hardware = pdevice.getHardware();
        device.serial = pdevice.getSerial();
        device.revision = pdevice.getRevision();
        device.disktotal = pdevice.getDisktotal();
        device.diskused = pdevice.getDiskused();
        device.diskused = pdevice.getDiskused();
        device.diskavailable = pdevice.getDiskavailable();
        device.disk_percentage_used = pdevice.getDiskPercentageUsed();
        device.temperature = pdevice.getTemperature();

        int camerascount = motion.getMotioncameraCount();
        for (int i = 0; i < camerascount; i++) {
            Message.MotionCamera pcamera = motion.getMotioncamera(i);

            Camera camera = new Camera();

            camera.idmat = pcamera.getDbIdmat();
            camera.cameranumber = pcamera.getCameranumber();
            camera.cameraname = pcamera.getCameraname();

            camera.matcols = pcamera.getMatcols();
            camera.matrows = pcamera.getMatrows();
            camera.matheight = pcamera.getMatheight();
            camera.matwidth = pcamera.getMatwidth();

            if (camera.recognizing)
            {
                device.running = true;
            }

            device.cameras.add(camera);

        }

        return device;
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

            while (true) {

                try {
                    sk.receive(dgp);

                } catch (IOException e) {
                    e.printStackTrace();
                }

                String rcvd = new String(dgp.getData(), 0, dgp.getLength()) + ", from address: "
                        + dgp.getAddress() + ", port: " + dgp.getPort();

                System.out.println(rcvd);

                BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
                String outMessage = null;

                try {
                    outMessage = stdin.readLine();

                } catch (IOException e) {
                    e.printStackTrace();
                }

                buf = ("Server say: " + outMessage).getBytes();

                listener.onTaskCompleted(rcvd, dgp.getAddress().toString().replace("/", ""));

            }
        }
    }

    public interface OnTaskCompleted {
        void onTaskCompleted(String msg, String url);
    }

    private OnSocketReceived protoListener;

    public interface OnSocketReceived
    {
        void OnSocketReceived(Message motion);
    }

    public void sendProto(Message motion, String url)
    {
        //set up socket
        SocketChannel serverSocket = null;
        try
        {
            serverSocket = SocketChannel.open();

            serverSocket.socket().setReuseAddress(true);
            serverSocket.connect(new InetSocketAddress(url,tcp_port));
            serverSocket.configureBlocking(true);


        } catch (IOException e)
        {
            e.printStackTrace();
        }

        //create BAOS for protobuf
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try
        {

            motion.writeDelimitedTo(baos);

        } catch (IOException e)
        {
            e.printStackTrace();
        }


        //copy the message to a bytebuffer
        //ByteBuffer socketBuffer = ByteBuffer.wrap(baos.toByteArray());

        String baseProto = BaseEncoding.base64().encode(motion.toByteArray());

        ByteBuffer socketBuffer = ByteBuffer.wrap(baseProto.getBytes());

        //BaseEncoding.base64().encode(motion.toByteArray())

        //keep sending until the buffer is empty
        while(socketBuffer.hasRemaining())
        {
            try
            {
                serverSocket.write(socketBuffer);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        //receive message from the client, where BUFFER_SIZE is large enough to contain your message
        socketBuffer = ByteBuffer.allocate(Motion.Message.SocketType.SOCKET_BUFFER_BIG_SIZE.getNumber());

        try {

            int bytesRead = serverSocket.read(socketBuffer);

        } catch (IOException e)
        {
            e.printStackTrace();
        }

        //copy message byte array from socket buffer
        socketBuffer.flip();
        byte[] ackBuf = new byte[socketBuffer.remaining()];
        socketBuffer.get(ackBuf);

        String msj = new String(ackBuf);

        String promsg = splitMessage(msj);

        BaseEncoding encoding = BaseEncoding.base64();

        byte[] decodebyte = encoding.decode(promsg);

        int size = decodebyte.length;

        CodedInputStream codedIn;
        codedIn = CodedInputStream.newInstance(decodebyte, 0, size);

        Motion.Message m = null;

        try
        {
            m = Motion.Message.parseFrom(codedIn);

        } catch (IOException e) {
            e.printStackTrace();
        }

        String d = m.getCurrday();

        //Motion.Message.MotionCamera mc = m.getMotioncamera();

        int mc = m.getMotioncameraCount();

        if (protoListener!=null)
        {
            protoListener.OnSocketReceived(m);
        }

        //done!
        socketBuffer.clear();

    }

    public void pairDevice()
    {   

        ParseQuery queryuser = ParseUser.getQuery();

        queryuser.findInBackground(new FindCallback<ParseObject>()
        {

            public void done(List<ParseObject> objectsuser, ParseException e) 
            {

              if (e == null)
              {

                // The query was successful.
                if (objectsuser.size() != 0)
                {

                    final ParseObject user = objectsuser.get(0);

                    final String email         = user.getString("email");
                    final String username      = user.getString("username");
                    final String first_name    = user.getString("first_name");
                    final String last_name     = user.getString("last_name");
                    final String objectId      = user.getObjectId();
                    final String pfuser        = objectId;

                    ParseRelation<ParseObject> client_relation = user.getRelation("client");
                    ParseQuery clientQuery = client_relation.getQuery();
                    clientQuery.findInBackground(new FindCallback<ParseObject>()
                    {

                        public void done(List<ParseObject> objectsclient, ParseException e) 
                        {

                            if (objectsclient.size() != 0)
                            {

                                ParseObject client        = objectsclient.get(0);
                                final String wpuser       = client.getString("wp_user");
                                final int wpuserid        = client.getInt("wp_userid");
                                final String wppassword   = client.getString("wp_password");
                                final int wppostparent    = client.getInt("wp_post_parent");
                                final int wpclientmediaid = client.getInt("wp_client_media_id");
                                final String wplink       = client.getString("wp_link");
                                final String wpapilink    = client.getString("wp_api_link");
                                final int wpclientid      = client.getInt("wp_client_id");
                                final String wpslug       = client.getString("wp_slug");
                                final String wpserverurl  = client.getString("wp_server_url");                                
                                final String wpmodified   = client.getString("wp_modified");                                

                                ParseRelation<ParseObject> device_relation = user.getRelation("device");
                                ParseQuery deviceQuery = device_relation.getQuery();
                                deviceQuery.findInBackground(new FindCallback<ParseObject>()
                                {

                                    public void done(List<ParseObject> objectsdevice, ParseException e) {

                                        if (objectsdevice.size() != 0)
                                        {
                                            ParseObject pdevice     = objectsdevice.get(0);
                                            String uuidinstallation = pdevice.getString("uuid_installation");
                                            String ipaddress        = pdevice.getString("ipaddress");
                                            String publicipaddress  = pdevice.getString("publicipaddress");
                                            String hostname         = pdevice.getString("hostname");
                                            String model            = pdevice.getString("model");
                                            String location         = pdevice.getString("location");

                                            String ParseApplicationId  = "fsLv65faQqwqhliCGF7oGqcT8MxPDFjmcxIuonGw";
                                            String RestApiKey          = "ZRfqjSe0ju8XejHHmJdsfzsYKYsQYBWsYLU40FDB";

                                           Message.MotionUser user = Message.MotionUser.newBuilder()
                                                    .setUsername(username)
                                                    .setWpuser(wpuser)
                                                    .setWpuserid(wpuserid)
                                                    .setWppassword(wppassword)
                                                    .setWpserverurl(wpserverurl)
                                                    .setWpclientid(wpclientid)
                                                    .setWpclientmediaid(wpclientmediaid)
                                                    .setEmail(email)
                                                    .setFirstname(first_name)
                                                    .setLastname(last_name)
                                                    .setLocation(location)
                                                    .setUiidinstallation(uuidinstallation)
                                                    .setClientnumber(wpuserid)
                                                    .setPfobjectid(objectId)
                                                    .setWpslug(wpslug)
                                                    .setWplink(wplink)
                                                    .setWpapilink(wpapilink)
                                                    .setWpfeaturedimage("")
                                                    .setWpmodified(wpmodified)
                                                    .setWpparent(0)
                                                    .setPfuser(pfuser)
                                                    .setPfappid(ParseApplicationId)
                                                    .setPfrestapikey(RestApiKey)
                                                    .build();

                                            Calendar cal = Calendar.getInstance();
                                            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss.SSS");
                                            String time = sdf.format(cal.getTime());

                                            Message message = Message.newBuilder()
                                                    .setType(Message.ActionType.SERVER_INFO)
                                                    .setPackagesize(Message.SocketType.SOCKET_BUFFER_MEDIUM_SIZE_VALUE)
                                                    .setMotionuser(0, user)
                                                    .setServerip(ipaddress)
                                                    .setTime(time)
                                                    .build();


                                            sendProto(message, ipaddress);
                                        }
                                    }
                                });
                            }
                        }

                    });                    
                }

              } else
              {
                // results have all the Posts the current user liked.
              }
            }
        });        
    }

    public String splitMessage(String message)
    {

        String del_1  = "PROSTA";
        String del_2  = "PROSTO";

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

        String payload = message.substring(message.indexOf(del_2)+del_2.length());

        return payload;
    }

    public class Device
    {

        User user;

        //String ipnumber, hostname, serial;

        public List<Camera> getCameras()
        {
            return cameras;
        }

        public void setCameras(List<Camera> cameras)
        {
            this.cameras = cameras;
        }

        public List<Camera> cameras = new ArrayList<Camera>();

        public Device()
        {

        }

        public String getSerial() {
            return serial;
        }

        public String getIpnumber() {
            return ipnumber;
        }

        public String getHostname() {
            return hostname;
        }

        public void setHostname(String hostname) {
            this.hostname = hostname;
        }

        public void setIpnumber(String ipnumber) {
            this.ipnumber = ipnumber;
        }

        public void setSerial(String serial) {
            this.serial = serial;
        }

        public Device(String ipnumber, String hostname, String serial) {
            this.ipnumber = ipnumber;
            this.hostname = hostname;
            this.serial = serial;
        }

        boolean joined;
        boolean running;

        String ipnumber;
        String ippublic;
        String macaddress;
        String hostname;
        String city;
        String country;
        String location;
        String network_provider;
        String uptime;
        String starttime;
        int db_local;
        String model;
        String hardware;
        String serial;
        String revision;
        int disktotal;
        int diskused;
        int diskavailable;
        int disk_percentage_used;
        int temperature;
        String uuid_installation;

        boolean collapsed;

    }

    public class Camera {
        int cameranumber;
        String cameraname;
        boolean recognizing;
        int idmat;
        ImageView thumbnail;

        int matrows;
        int matcols;
        int matheight;
        int matwidth;
    }

    class User {

        int clientnumber;
        int wp_userid;
        int wp_client_id;
        String wp_first_name;
        String wp_last_name;
        String location;
    }


}

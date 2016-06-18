package com.grabmo;

import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.util.Base64;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.common.io.BaseEncoding;
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

import com.google.protobuf.CodedInputStream;

public class SyncActivity extends AppCompatActivity {

    private int udp_port;
    private int tcp_port;
    private int timeout;
    public String url_address;
    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sync);

        View title = findViewById(R.id.titleSync);

        Button find_button = (Button) findViewById(R.id.button_find_devices);

        this.url_address = "255.255.255.255";
        this.udp_port = Message.SocketType.UDP_PORT.getNumber();
        this.tcp_port = Message.SocketType.TCP_ECHO_PORT.getNumber();
        this.timeout = 5000;

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
                        Device device = getEngage(motion);
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


    public Device getEngage(Message motion)
    {
        Message.MotionDevice pdevice = motion.getMotiondevice(0);

        Device device = new Device();

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

            if (camera.recognizing) {
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

    /*public void sendProto(Message motion, String url) {
        //set up socket
        SocketChannel serverSocket = null;
        try {
            serverSocket = SocketChannel.open();

            serverSocket.socket().setReuseAddress(true);
            serverSocket.connect(new InetSocketAddress(url, tcp_port));
            serverSocket.configureBlocking(true);


        } catch (IOException e)
        {
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
                serverSocket.write(socketBuffer);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        //receive message from the client, where BUFFER_SIZE is large enough to contain your message
        socketBuffer = ByteBuffer.allocate(Message.SocketType.SOCKET_BUFFER_BIG_SIZE.getNumber());

        try {

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

        //String decoded = null;

        // = new byte[0];

        //try
        //{

            //decoded = new String(Base64.decode(promsg,Base64.DEFAULT), "ASCII");

        //byte[] decodebyte = Base64.decode(promsg,Base64.DEFAULT);


        BaseEncoding encoding = BaseEncoding.base64();

        byte[] decodebyte = encoding.decode(promsg);

        //} catch (UnsupportedEncodingException e)
        //{
        //    e.printStackTrace();
        //}




        //Charset charset = null;

        //CharSequence seq = new String(promsg);

        //byte[] ackBuf_decoded = BaseEncoding.base64().decode(seq);

        //byte[] ackBuf_decoded = Base64.decode(promsg, Base64.DEFAULT);

        //

        //create ByteArrayInputStream from byte[] (this is what protobuf wants)
        //ByteArrayInputStream ackStream = new ByteArrayInputStream(decodebyte);

        try {
            //parse message
            //Message m = Message.parseDelimitedFrom(ackStream);
            //motion = Message.parseFrom(ackStream);
             Motion.Message m = Motion.Message.parseFrom(decodebyte);
            //Message m = Motion.Message.parseFrom(decodebyte);

           if (m.hasType()) {
                String t = m.getCurrday();
                protoListener.OnSocketReceived(m);
            }


        } catch (IOException e) {
            System.out.println("error: " + e.toString());
            e.printStackTrace();
        }

        //done!
        socketBuffer.clear();

    }*/

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

    public class Device {
        User user;
        public List<Camera> cameras = new ArrayList<Camera>();
        int activecam;

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

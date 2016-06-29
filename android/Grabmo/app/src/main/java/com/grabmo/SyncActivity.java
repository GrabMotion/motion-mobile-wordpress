package com.grabmo;

import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.common.io.BaseEncoding;
import com.google.protobuf.CodedInputStream;
import com.grabmo.adapter.DevicesAdapter;
import com.grabmo.adapter.DevicesAdapter.OnItemClickListener;
import com.grabmo.model.Camera;
import com.grabmo.model.Device;
import com.grabmo.protobuf.Motion;
import com.grabmo.protobuf.Motion.Message;
import com.grabmo.utils.KeySaver;
import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseRelation;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

public class SyncActivity extends AppCompatActivity {

    private int udp_port;
    private int tcp_port;
    //private int timeout = 5000;
    public String url_address;
    //public String rasp_url;

    private DevicesAdapter mAdapter;


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

        if (KeySaver.isExist(this, "isPaired")) {
            Intent i = new Intent(SyncActivity.this, MainActivity.class);
            startActivity(i);
            finish();
        }

        View title = findViewById(R.id.titleSync);

        Button find_button = (Button) findViewById(R.id.button_find_devices);

        RecyclerView mRecyclerView = (RecyclerView) findViewById(R.id.recycle_find_devices);

        url_address = "181.29.152.118"; //"255.255.255.255";
        udp_port = Message.SocketType.UDP_PORT.getNumber();
        tcp_port = Message.SocketType.TCP_ECHO_PORT.getNumber();

        mAdapter = new DevicesAdapter(this, devices);

        mAdapter.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                showPairAuthorizationDialog(position, devices.get(position).getHostname());
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
                        KeySaver.saveShare(SyncActivity.this, "isPaired", true);
                        startActivity(new Intent(SyncActivity.this, MainActivity.class));
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


    public void showPairAuthorizationDialog(final int position, String device) {

        AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);

        dialogBuilder.setTitle("Pair device");

        dialogBuilder.setMessage("Do you want to pair device " + device);


        dialogBuilder.setPositiveButton("Okay", new DialogInterface.OnClickListener() {

            public void onClick(DialogInterface dialog, int whichButton) {
                pairDevice(position);
            }

        });

        dialogBuilder.setNegativeButton("No thanks", new DialogInterface.OnClickListener() {

            public void onClick(DialogInterface dialog, int whichButton) {
                //dismiss
            }

        });

        final AlertDialog b = dialogBuilder.create();
        b.show();

    }


    public void pairDevice(int pos) {

        if (ParseUser.getCurrentUser() != null) {


            final Device cdevice = devices.get(pos);

            ParseQuery queryuser = ParseUser.getQuery();

            queryuser.findInBackground(new FindCallback<ParseObject>() {
                public void done(List<ParseObject> objectsuser, ParseException e) {
                    if (e == null) {
                        if (objectsuser.size() > 0) {

                            final ParseObject pfuser = objectsuser.get(0);

                            ParseRelation<ParseObject> device_relation = pfuser.getRelation("device");
                            ParseQuery deviceQuery = device_relation.getQuery();

                            deviceQuery.findInBackground(new FindCallback<ParseObject>() {

                                public void done(List<ParseObject> objectsdevice, ParseException e) {

                                    if (objectsdevice.size() == 0) {
                                        String uiid = UUID.randomUUID().toString();

                                        final ParseObject pdevice = new ParseObject("Device");

                                        pdevice.put("publicipaddress", cdevice.getIppublic());
                                        pdevice.put("model", cdevice.getModel());
                                        pdevice.put("ipaddress", cdevice.getIpnumber());
                                        pdevice.put("hostname", cdevice.getHostname());
                                        pdevice.put("location", cdevice.getLocation());
                                        pdevice.put("uuid_installation", uiid);

                                        pdevice.saveInBackground(new SaveCallback() {
                                            @Override
                                            public void done(ParseException e) {

                                                ParseRelation<ParseObject> device_relation = pfuser.getRelation("device");
                                                device_relation.add(pdevice);

                                                pfuser.saveInBackground(new SaveCallback() {
                                                    @Override
                                                    public void done(ParseException e) {
                                                        sendPairRequest();
                                                    }
                                                });

                                            }
                                        });

                                    } else if (objectsdevice.size() > 0) {
                                        sendPairRequest();
                                    }
                                }
                            });

                        }
                    }
                }
            });
        }
    }


    public void getEngage(Message motion) {

        Message.MotionDevice pdevice = motion.getMotiondevice(0);
        List<Camera> cam = new ArrayList<>();

        for (int i = 0; i < motion.getMotioncameraCount(); i++) {
            Message.MotionCamera pcamera = motion.getMotioncamera(i);

            cam.add(setCameras(pcamera.getCameranumber(), pcamera.getCameraname(), true, pcamera.getDbIdmat()
                    , pcamera.getMatrows(), pcamera.getMatcols(), pcamera.getMatheight(), pcamera.getMatwidth()));

        }

        devices.add(setDevices(pdevice.getIpnumber(), pdevice.getIppublic(), pdevice.getMacaddress(), pdevice.getHostname(), pdevice.getCity(), pdevice.getCountry()
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
        client.connect();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW,
                "Sync Page",
                Uri.parse("http://host/path"),
                Uri.parse("android-app://com.grabmo/http/host/path")
        );
        AppIndex.AppIndexApi.start(client, viewAction);
    }

    @Override
    public void onStop() {
        super.onStop();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW,
                "Sync Page",
                Uri.parse("http://host/path"),
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

            byte[] send_data = new byte[1024];
            byte[] receiveData = new byte[1024];

            Log.e("test", "to true");
            try {
                DatagramSocket client_socket = new DatagramSocket(udp_port);
                InetAddress IPAddress = InetAddress.getByName(url_address);

                //send_data = str.getBytes();

                DatagramPacket send_packet = new DatagramPacket(send_data, send_data.length, IPAddress, udp_port);
                client_socket.send(send_packet);

                DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                client_socket.receive(receivePacket);

                String rcvd = new String(receivePacket.getData(), 0, receivePacket.getLength()) + ", from address: "
                        + receivePacket.getAddress() + ", port: " + receivePacket.getPort();
                listener.onTaskCompleted(rcvd, receivePacket.getAddress().toString().replace("/", ""));
                client_socket.close();

            } catch (IOException e) {
                e.printStackTrace();
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
        }
    }

    public interface OnTaskCompleted {
        void onTaskCompleted(String msg, String url);
    }

    private OnSocketReceived protoListener;

    public interface OnSocketReceived {
        void socketReceived(Message motion);
    }

    public void sendProto(Message motion, String url) {

        SocketChannel serverSocket = null;

        try {
            serverSocket = SocketChannel.open();

            serverSocket.socket().setReuseAddress(true);
            serverSocket.connect(new InetSocketAddress(url, tcp_port));
            serverSocket.configureBlocking(true);


        } catch (IOException e) {
            e.printStackTrace();
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {

            motion.writeDelimitedTo(baos);

        } catch (IOException e) {
            e.printStackTrace();
        }

        String baseProto = BaseEncoding.base64().encode(motion.toByteArray());

        ByteBuffer socketBuffer = ByteBuffer.wrap(baseProto.getBytes());

        while (socketBuffer.hasRemaining()) {
            try {
                assert serverSocket != null;
                serverSocket.write(socketBuffer);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        socketBuffer = ByteBuffer.allocate(Message.SocketType.SOCKET_BUFFER_BIG_SIZE.getNumber());

        try {
            int bytesRead = serverSocket.read(socketBuffer);
        } catch (IOException e) {
            e.printStackTrace();
        }

        socketBuffer.flip();
        byte[] ackBuf = new byte[socketBuffer.remaining()];
        socketBuffer.get(ackBuf);

        String msj = new String(ackBuf);

        String promsg = splitMessage(msj);

        if (promsg == null) {
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

        if (protoListener != null) {
            protoListener.socketReceived(m);
        }

        socketBuffer.clear();

    }

    public void sendPairRequest() {

        ParseQuery queryuser = ParseUser.getQuery();

        queryuser.findInBackground(new FindCallback<ParseObject>() {

            public void done(List<ParseObject> objectsuser, ParseException e) {

                if (e == null) {

                    if (objectsuser.size() > 0) {

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

                                if (objectsclient.size() > 0) {

                                    ParseObject client = objectsclient.get(0);
                                    final String wpuser = client.getString("wp_user");
                                    final int wpuserid = client.getInt("wp_userid");
                                    final String wppassword = client.getString("wp_password");
                                    //final int wppostparent = client.getInt("wp_post_parent");
                                    //final int wpclientmediaid = client.getInt("wp_client_media_id");
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

                                            if (objectsdevice.size() != 0) {
                                                ParseObject pdevice = objectsdevice.get(0);
                                                String uuidinstallation = pdevice.getString("uuid_installation");
                                                String ipaddress = pdevice.getString("ipaddress");
                                                //String publicipaddress = pdevice.getString("publicipaddress");
                                                //String hostname = pdevice.getString("hostname");
                                                //String model = pdevice.getString("model");
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
                                                            .setServerip(ipaddress)
                                                            .setTime(time)
                                                            .setMotionuser(0, Motion.Message.MotionUser.newBuilder()
                                                                    .setWpuser(wpuser)
                                                                    .setWpuserid(wpuserid)
                                                                    .setWppassword(wppassword)
                                                                    .setWpserverurl(wpserverurl)
                                                                    .setWpclientid(wpclientid)
                                                                    .setEmail(email)
                                                                    .setFirstname(first_name)
                                                                    .setLastname(last_name)
                                                                    .setUsername(username)
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
                                                                    .setPfrestapikey(RestApiKey)
                                                                    .setMotionprocess(0, Motion.Message.MotionProcess.newBuilder()
                                                                            .setName("Face detection")
                                                                            .setType(Message.ProcessType.PROCESS_FACE_DETECT))).build();


                                                    new SendProto().execute(message);


                                                } catch (Exception pe) {
                                                    System.out.println("Exception: " + pe.toString());

                                                }
                                            }
                                        }
                                    });
                                }
                            }

                        });
                    }

                } else {
                    Log.e("else", "true");
                }
            }
        });
    }

    public class SendProto extends AsyncTask<Message, Void, Void> {

        @Override
        protected Void doInBackground(Message... params) {
            Message message = params[0];
            String url = message.getServerip();
            sendProto(message, url);
            return null;
        }
    }

    public String splitMessage(String message) {

        if (message.isEmpty()) {
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

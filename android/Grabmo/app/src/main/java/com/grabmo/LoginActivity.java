package com.grabmo;

import android.app.Activity;
import android.content.Intent;
import android.location.Criteria;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import android.text.Editable;
import android.text.TextWatcher;

import com.grabmo.utils.KeySaver;
import com.grabmo.utils.Utils;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.auth.AuthScope;

import java.util.UUID;

import com.parse.LocationCallback;
import com.parse.Parse;
import com.parse.ParseGeoPoint;
import com.parse.ParseInstallation;
import com.parse.ParsePush;
import com.parse.ParseUser;
import com.parse.ParseException;
import com.parse.SaveCallback;
import com.parse.SignUpCallback;
import com.parse.ParseObject;
import com.parse.ParseRelation;


/**
 * Created by mariano on 6/1/16.
 **/
public class LoginActivity extends Activity {

    private static String LOGIN = "http://grabmotion.co/wp-json/wp/v2/user";
    private AsyncHttpClient client;
    private EditText first_name;
    private EditText last_name;
    private EditText user;
    private EditText pass;
    private EditText email;
    private RequestParams params;
    private View loginInclude;
    private View signUpInclude;
    private TextView toggleLogin;
    private EditText userLogin, passLogin;

    String TAG = "LoginActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        String appId = "fsLv65faQqwqhliCGF7oGqcT8MxPDFjmcxIuonGw";
        String appKey = "T3PK1u0NQ36eZm91jM0TslCREDj8LBeKzGCsrudE";

        Parse.initialize(this, appId, appKey);

        ParseInstallation.getCurrentInstallation().saveInBackground();

        if (KeySaver.isExist(this, "isPaired")) 
        {
            Intent m = new Intent(LoginActivity.this, MainActivity.class);
            startActivity(m);
            finish();
        }

        if (KeySaver.isExist(this, "isLogin") || KeySaver.isExist(this, "newUser")) 
        {
            Intent i = new Intent(LoginActivity.this, SyncActivity.class);
            startActivity(i);
            finish();
        }

        loginInclude = findViewById(R.id.login_include);
        signUpInclude = findViewById(R.id.signup_include);

        first_name = (EditText) signUpInclude.findViewById(R.id.edit_first_name);
        last_name = (EditText) signUpInclude.findViewById(R.id.edit_last_name);       

        user = (EditText) signUpInclude.findViewById(R.id.edit_name);
        pass = (EditText) signUpInclude.findViewById(R.id.edit_pass);
        email = (EditText) signUpInclude.findViewById(R.id.edit_email);

        last_name.addTextChangedListener(new TextWatcher() {

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            public void afterTextChanged(Editable s)
            {
                String usern = first_name.getText().toString() + last_name.getText().toString();
                user.setText(usern);
            }
          
       });

        userLogin = (EditText) loginInclude.findViewById(R.id.edit_name);
        passLogin = (EditText) loginInclude.findViewById(R.id.edit_pass);

        Button signUp = (Button) signUpInclude.findViewById(R.id.button_signup);
        Button loginBtn = (Button) loginInclude.findViewById(R.id.button_login);

        signUp.setOnClickListener(onSignUpListener);
        loginBtn.setOnClickListener(onLoginListener);

        toggleLogin = (TextView) findViewById(R.id.toggleLogin);

        toggleLogin.setOnClickListener(onToggleListener);

        client = new AsyncHttpClient();
        params = new RequestParams();


    }

    View.OnClickListener onToggleListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (signUpInclude.getVisibility() == View.VISIBLE) {
                signUpInclude.setVisibility(View.GONE);
                loginInclude.setVisibility(View.VISIBLE);
                toggleLogin.setText("SIGN UP");
            } else {
                signUpInclude.setVisibility(View.VISIBLE);
                loginInclude.setVisibility(View.GONE);
                toggleLogin.setText("LOGIN");
            }
        }
    };

    View.OnClickListener onSignUpListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {


            RequestParams paramsSignUp = new RequestParams();
            paramsSignUp.put("admin_user", "admin");
            paramsSignUp.put("admin_password", "TOZe8xgKtzJc2qLFOM7nUQ");
            paramsSignUp.put("new_username", user.getText().toString());
            paramsSignUp.put("new_password", pass.getText().toString());
            paramsSignUp.put("new_email", email.getText().toString());
            paramsSignUp.put("new_first_name", first_name.getText().toString());
            paramsSignUp.put("new_last_name", last_name.getText().toString());
            paramsSignUp.put("role", "editor");
            paramsSignUp.put("client_post_parent", 0);
            client.addHeader("Content-Type", "application/json");
            client.addHeader("Expect", "");
            client.setBasicAuth("admin", "TOZe8xgKtzJc2qLFOM7nUQ", new AuthScope("grabomotion.co", 80, AuthScope.ANY_REALM));

            final String puser = user.getText().toString();
            final String ppass = pass.getText().toString();
            final String pemail = email.getText().toString();

            final String firstname = first_name.getText().toString();
            final String lastname = last_name.getText().toString();

            client.post("http://grabmotion.co/wp-json/gm/v1/users", paramsSignUp, new AsyncHttpResponseHandler() {

                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    try {
                        final JSONObject newUser = new JSONObject(Utils.decodeUTF8(responseBody));

                        if (newUser.has("wp_userid"))
                        {

                            Thread thread = new Thread()
                            {
                                
                                @Override
                                public void run() 
                                {
                                    //PARSE
                                    final ParseUser newuser = new ParseUser();
                                    newuser.setUsername(puser);
                                    newuser.setPassword(ppass);
                                    newuser.setEmail(pemail);

                                    newuser.signUpInBackground(new SignUpCallback() {

                                        public void done(ParseException e) {

                                            if (e == null)
                                            {

                                                if (ParseUser.getCurrentUser()!=null)
                                                {
                                                    String cannel = "user_" + ParseUser.getCurrentUser().getObjectId();
                                                    ParsePush.subscribeInBackground(cannel);
                                                }

                                                final ParseObject pclient = new ParseObject("Client");
                                                pclient.put("wp_type", "client");

                                                String wplink       = null;
                                                String wpapilink    = null;
                                                int wpuserid        = 0;
                                                int wpclientid      = 0;
                                                String wpslug       = null;
                                                String wpserverurl  = null;
                                                String wpmodified   = null;

                                                try {
                                                    wplink          = newUser.getString("wp_link");
                                                    wplink          = newUser.getString("wp_link");
                                                    wpapilink       = newUser.getString("wp_api_link");
                                                    wpuserid        = newUser.getInt("wp_userid");
                                                    wpclientid      = newUser.getInt("wp_client_id");
                                                    wpslug          = newUser.getString("wp_slug");
                                                    wpserverurl     = newUser.getString("wp_server_url");
                                                    wpmodified      = newUser.getString("wp_modified");
                                                } catch (JSONException e1)
                                                {
                                                    e1.printStackTrace();
                                                }

                                                pclient.put("wp_password", ppass);
                                                pclient.put("wp_post_parent", 0);
                                                pclient.put("wp_client_media_id", 0);
                                                pclient.put("wp_link", wplink);
                                                pclient.put("wp_api_link", wpapilink);
                                                pclient.put("wp_userid", wpuserid);
                                                pclient.put("wp_client_id", wpclientid);
                                                pclient.put("wp_slug", wpslug);
                                                pclient.put("wp_server_url", wpserverurl);
                                                pclient.put("wp_modified", wpmodified);
                                                pclient.put("wp_user", puser);
                                                pclient.saveInBackground(new SaveCallback()
                                                {
                                                    @Override
                                                    public void done(ParseException e)
                                                    {
                                                        ParseRelation<ParseObject> client_relation = newuser.getRelation("client");
                                                        client_relation.add(pclient);

                                                        newuser.put("first_name", firstname);
                                                        newuser.put("last_name", lastname);

                                                        newuser.saveInBackground();

                                                        KeySaver.saveShare(LoginActivity.this, "newUser", true);
                                                        startActivity(new Intent(LoginActivity.this, SyncActivity.class));
                                                        finish();

                                                    }
                                                });
                                            }
                                        }
                                    });

                                }

                            };
                            thread.start();
                            
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                    try {
                        JSONObject failUser = new JSONObject(Utils.decodeUTF8(responseBody));
                        if (failUser.has("error")) {
                            Toast.makeText(LoginActivity.this, failUser.getString("error"), Toast.LENGTH_SHORT).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    };

    View.OnClickListener onLoginListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            client.get("http://grabmotion.co/wp-json/gm/v1/client/me/"+userLogin.getText().toString() + "/" + passLogin.getText().toString(), new AsyncHttpResponseHandler() {

                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    Log.e("response", Utils.decodeUTF8(responseBody));

                    KeySaver.saveShare(LoginActivity.this, "isLogin", true);

                    try {
                        JSONObject response = new JSONObject(Utils.decodeUTF8(responseBody));
                        KeySaver.saveShare(LoginActivity.this, "userId", response.getInt("id"));
                        KeySaver.saveShare(LoginActivity.this, "userName", response.getString("first_name"));
                        KeySaver.saveShare(LoginActivity.this, "userEmail", response.getString("email"));
                        KeySaver.saveShare(LoginActivity.this, "userImage", "error");

                        startActivity(new Intent(LoginActivity.this, SyncActivity.class));
                        finish();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                    Log.e("responseF", Utils.decodeUTF8(responseBody));
                }
            });
        }
    };
}

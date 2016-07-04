package com.grabmo;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.grabmo.utils.KeySaver;
import com.grabmo.utils.Utils;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.parse.LogInCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParsePush;
import com.parse.ParseRelation;
import com.parse.ParseUser;
import com.parse.SaveCallback;
import com.parse.SignUpCallback;

import org.json.JSONException;
import org.json.JSONObject;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.auth.AuthScope;

/**
 * Created by mariano on 6/1/16.
 **/
public class LoginActivity extends Activity {

    private static String LOGIN = "http://grabmotion.co/wp-json/wp/v2/user";
    private AsyncHttpClient client;
    private EditText user;
    private EditText pass;
    private EditText first_name;
    private EditText last_name;
    private EditText email;
    private RequestParams params;
    private View loginInclude;
    private View signUpInclude;
    private TextView toggleLogin;
    private EditText userLogin, passLogin;

    private ProgressDialog progressDialogSignUp;
    private ProgressDialog progressDialogLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        if (KeySaver.isExist(this, "isLogin") || KeySaver.isExist(this, "newUser")) {
            Intent i = new Intent(LoginActivity.this, SyncActivity.class);
            startActivity(i);
            finish();
        }

        loginInclude = findViewById(R.id.login_include);
        signUpInclude = findViewById(R.id.signup_include);

        user = (EditText) signUpInclude.findViewById(R.id.edit_name);
        pass = (EditText) signUpInclude.findViewById(R.id.edit_pass);
        email = (EditText) signUpInclude.findViewById(R.id.edit_email);

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

    View.OnClickListener onSignUpListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {

            progressDialogSignUp = new ProgressDialog(LoginActivity.this);
            progressDialogSignUp.setMessage("Creating account...");
            progressDialogSignUp.setIndeterminate(true);
            progressDialogSignUp.setCancelable(false);
            progressDialogSignUp.show();

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
                        final JSONObject WPnewUser = new JSONObject(Utils.decodeUTF8(responseBody));

                        if (WPnewUser.has("wp_userid")) {

                            Thread thread = new Thread() {

                                @Override
                                public void run() {
                                    //PARSE
                                    final ParseUser newuser = new ParseUser();
                                    newuser.setUsername(puser);
                                    newuser.setPassword(ppass);
                                    newuser.setEmail(pemail);

                                    newuser.signUpInBackground(new SignUpCallback() {

                                        public void done(ParseException e) {

                                            if (e == null) {

                                                if (ParseUser.getCurrentUser() != null) {
                                                    String cannel = "user_" + ParseUser.getCurrentUser().getObjectId();
                                                    ParsePush.subscribeInBackground(cannel);
                                                }

                                                final ParseObject pclient = new ParseObject("Client");
                                                pclient.put("wp_type", "client");

                                                String wplink = "";
                                                String wpapilink = "";
                                                int wpuserid = 0;
                                                int wpclientid = 0;
                                                String wpslug = "";
                                                String wpserverurl = "";
                                                String wpmodified = "";

                                                try {
                                                    if (WPnewUser.has("wp_link"))
                                                        wplink = WPnewUser.getString("wp_link");

                                                    if (WPnewUser.has("wp_api_link"))
                                                        wpapilink = WPnewUser.getString("wp_api_link");

                                                    if (WPnewUser.has("wp_userid"))
                                                        wpuserid = WPnewUser.getInt("wp_userid");

                                                    if (WPnewUser.has("wp_client_id"))
                                                        wpclientid = WPnewUser.getInt("wp_client_id");

                                                    if (WPnewUser.has("wp_slug"))
                                                        wpslug = WPnewUser.getString("wp_slug");

                                                    if (WPnewUser.has("wp_server_url"))
                                                        wpserverurl = WPnewUser.getString("wp_server_url");

                                                    if (WPnewUser.has("wp_modified"))
                                                        wpmodified = WPnewUser.getString("wp_modified");

                                                } catch (JSONException e1) {
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

                                                pclient.saveInBackground(new SaveCallback() {
                                                    @Override
                                                    public void done(ParseException e) {
                                                        ParseRelation<ParseObject> client_relation = newuser.getRelation("client");
                                                        client_relation.add(pclient);

                                                        newuser.put("first_name", firstname);
                                                        newuser.put("last_name", lastname);

                                                        newuser.saveInBackground();

                                                        progressDialogSignUp.dismiss();
                                                        KeySaver.saveShare(LoginActivity.this, "WPnewUser", true);
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

            progressDialogLogin = new ProgressDialog(LoginActivity.this);
            progressDialogLogin.setMessage("Login user...");
            progressDialogLogin.setIndeterminate(true);
            progressDialogLogin.setCancelable(false);
            progressDialogLogin.show();

            client.get("http://grabmotion.co/wp-json/gm/v1/client/me/" + userLogin.getText().toString() + "/" + passLogin.getText().toString(), new AsyncHttpResponseHandler() {

                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    Log.e("response", Utils.decodeUTF8(responseBody));

                    KeySaver.saveShare(LoginActivity.this, "isLogin", true);

                    try
                    {

                        JSONObject response = new JSONObject(Utils.decodeUTF8(responseBody));
                        KeySaver.saveShare(LoginActivity.this, "userId", response.getInt("id"));
                        KeySaver.saveShare(LoginActivity.this, "userName", response.getString("first_name"));
                        KeySaver.saveShare(LoginActivity.this, "userEmail", response.getString("email"));
                        KeySaver.saveShare(LoginActivity.this, "userImage", "error");

                        String puser = userLogin.getText().toString();
                        String ppass = passLogin.getText().toString();

                        ParseUser.logInInBackground(puser, ppass, new LogInCallback()
                        {

                            public void done(ParseUser user, ParseException e)
                            {
                                if (user != null)
                                {
                                    startActivity(new Intent(LoginActivity.this, MainActivity.class));
                                    finish();
                                } else
                                {
                                    // Signup failed. Look at the ParseException to see what happened.
                                }
                            }
                        });

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

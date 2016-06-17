package com.grabmo;

import android.app.Activity;
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

import org.json.JSONArray;
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
    private EditText email;
    private RequestParams params;
    private View loginInclude;
    private View signUpInclude;
    private TextView toggleLogin;
    private EditText userLogin, passLogin;

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
            RequestParams paramsSignUp = new RequestParams();
            paramsSignUp.put("admin_user", "admin");
            paramsSignUp.put("admin_password", "TOZe8xgKtzJc2qLFOM7nUQ");
            paramsSignUp.put("new_username", user.getText().toString());
            paramsSignUp.put("new_password", pass.getText().toString());
            paramsSignUp.put("new_email", email.getText().toString());
            paramsSignUp.put("new_first_name", user.getText().toString());
            paramsSignUp.put("new_last_name", user.getText().toString());
            paramsSignUp.put("role", "editor");
            paramsSignUp.put("client_post_parent", 0);
            client.addHeader("Content-Type", "application/json");
            client.addHeader("Expect", "");
            client.setBasicAuth("admin", "TOZe8xgKtzJc2qLFOM7nUQ", new AuthScope("grabomotion.co", 80, AuthScope.ANY_REALM));
            client.post("http://grabmotion.co/wp-json/gm/v1/users", paramsSignUp, new AsyncHttpResponseHandler() {

                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    try {
                        JSONObject newUser = new JSONObject(Utils.decodeUTF8(responseBody));

                        if (newUser.has("wp_userid")) {
                            KeySaver.saveShare(LoginActivity.this, "newUser", true);
                            startActivity(new Intent(LoginActivity.this, SyncActivity.class));
                            finish();
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

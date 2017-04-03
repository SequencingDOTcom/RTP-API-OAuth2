package com.sequencing.oauthdemo;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.Toast;

import com.google.gson.JsonArray;
import com.sequencing.oauth.config.AuthenticationParameters;
import com.sequencing.oauth.core.DefaultSequencingFileMetadataApi;
import com.sequencing.oauth.core.DefaultSequencingOAuth2Client;
import com.sequencing.oauth.core.SequencingFileMetadataApi;
import com.sequencing.oauth.core.Token;
import com.sequencing.oauth.exception.NonAuthorizedException;
import com.sequencing.oauth.helper.JsonHelper;


public class MainActivity extends AppCompatActivity {
    private Button btnLogin;
    private AuthenticationParameters parameters;
    private DefaultSequencingOAuth2Client oauth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        btnLogin = (Button) findViewById(R.id.btnLogin);

        initAuthentication();
    }

    private void initAuthentication() {
        ISQAuthCallback authCallback = new ISQAuthCallback() {

            @Override
            public void onAuthentication(Token token) {
                Toast.makeText(getApplicationContext(), "You has been authenticated", Toast.LENGTH_SHORT).show();

                runResultActivity();
            }

            @Override
            public void onFailedAuthentication(Exception e) {
                Toast.makeText(getBaseContext(), "Error is happened", Toast.LENGTH_SHORT).show();
            }
        };

        parameters = new AuthenticationParameters.ConfigurationBuilder()
                .withRedirectUri("authapp://Default/Authcallback")
                .withClientId("oAuth2 Demo ObjectiveC")
                .withMobileMode("1")
                .withClientSecret("RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g")
                .build();

        SQUIoAuthHandler ioAuthHandler = new SQUIoAuthHandler(this);
        ioAuthHandler.authenticate(btnLogin, authCallback, parameters);
    }

    private void runResultActivity() {
        String resultJsonResponse = null;
        try {
            resultJsonResponse = getFilesApi().getSampleFiles();
            JsonArray resultArray = JsonHelper.toJsonArray(resultJsonResponse);

            Intent intent = new Intent(this, ResultListActivity.class);
            intent.putExtra("stringArray", JsonHelper.parseJsonArrayToStringArray(resultArray));
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        } catch (NonAuthorizedException e) {
            Log.w("Non authorized user", e);
            e.printStackTrace();
        }
    }

    public SequencingFileMetadataApi getFilesApi() {
        DefaultSequencingFileMetadataApi filesApi = new DefaultSequencingFileMetadataApi(OAuth2Parameters.getInstance().getOauth());
        return filesApi;
    }
}

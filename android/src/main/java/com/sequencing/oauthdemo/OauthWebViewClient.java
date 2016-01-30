package com.sequencing.oauthdemo;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.StrictMode;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.google.gson.JsonArray;
import com.sequencing.oauth.config.AuthenticationParameters;
import com.sequencing.oauth.core.*;
import com.sequencing.oauth.exception.*;
import com.sequencing.oauth.helper.*;

public class OauthWebViewClient extends WebViewClient {
    private SequencingOAuth2Client oauth;
    private SequencingFileMetadataApi filesApi;
    private AuthenticationParameters parameters;

    private final Context context;
    private static final String TAG = "OauthWebViewClient";

    public OauthWebViewClient(Context context){
        this.context = context;
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
    }


    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (url.startsWith("authapp://")) {
            onLoadResource(view, url);
            return true;
        }
        return false;
    }

    @Override
    public void onLoadResource(WebView view, String url) {
        if (url.startsWith("authapp://")) { // if host is "authapp:/"

            // If we don't authorized
            if (!getOauth().isAuthorized()) {
            if (null == Uri.parse(url).getQueryParameter("code")) {
                // We just being the oauth2 authorization loop. So we redirect the client to
                // Sequencing website and ask the user to allow our app to use his data.
                    view.loadUrl(getOauth().getLoginRedirectUrl());
                    System.out.println(getOauth().getLoginRedirectUrl());

            } else {
                // We came back from Sequencing website and if state argument matches with our
                // state, then we proceed and exchange the authorization code that we are
                // given in GET for the access and refresh tokens. The former will be used for
                // authorization, when we make requests to Sequencing API.


                    try {
                        getOauth().authorize(Uri.parse(url).getQueryParameter("code"), Uri.parse(url).getQueryParameter("state"));
                    } catch (BasicAuthenticationFailedException e) {
                        Log.e(TAG, "An unsuccessful attempt to query to the API server");
                        Toast.makeText(context, "An unsuccessful attempt to query to the API server", Toast.LENGTH_SHORT).show();
                        return;
                    }


                    runResultActivity();
                }
            } else {
                // User is authorized
                runResultActivity();
            }
        }
        super.onLoadResource(view, url);
    }

    private void runResultActivity() {
        String resultJsonResponse = null;
        try {
            resultJsonResponse = getFilesApi().getSampleFiles();
        } catch (NonAuthorizedException e) {
            Log.w("Non authorized user", e);
            e.printStackTrace();
                    }

                    JsonArray resultArray = JsonHelper.toJsonArray(resultJsonResponse);

                    Intent intent = new Intent(context, ResultListActivity.class);
                    intent.putExtra("stringArray", JsonHelper.parseJsonArrayToStringArray(resultArray));
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    context.startActivity(intent);
                }

    public AuthenticationParameters getAppConfig() {
        if(parameters == null){
            parameters = new AuthenticationParameters.ConfigurationBuilder()
                    .withRedirectUri("authapp://Default/Authcallback")
                    .withClientId("oAuth2 Demo ObjectiveC")
                    .withClientSecret("RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g")
                    .build();
            }
        return parameters;
        }

    public SequencingOAuth2Client getOauth(){
        if(oauth == null){
            oauth = new DefaultSequencingOAuth2Client(getAppConfig());
    }
        return oauth;
    }

    public SequencingFileMetadataApi getFilesApi(){
        if (filesApi == null){
            filesApi = new DefaultSequencingFileMetadataApi(getOauth());
        }
        return filesApi;
    }

}
package com.sequencing.oauthdemo;

import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.sequencing.oauth.core.Token;
import com.sequencing.oauth.exception.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Implementation of WebViewClient that handler url request to authapp://
 */
public class OauthWebViewClient extends WebViewClient {

    /**
     * Context of app
     */
    private final Context context;

    /**
     * Authentication token
     */
    private Token token;

    private boolean isSuccess = true;

    private static final String TAG = "OauthWebViewClient";


    public OauthWebViewClient(Context context) {
        this.context = context;
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
    }

    @Override
    public void onReceivedError(WebView view, int errorCode,
                                String description, String failingUrl) {
        Log.d(TAG, "Error code:" + errorCode + " description:" + description + " failingUrl:" + failingUrl);
    }

    /**
     * Callback for handling our scheme
     */
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (!url.startsWith(OAuth2Parameters.getInstance().getAppConfig().getRedirectUri())) {
            return false;
        }

        onLoadResource(view, url);
        return true;
    }

    /**
     * Callback for handling our scheme
     */
    @Override
    public void onLoadResource(WebView view, String url) {
        if(isSuccess) {
            int statusCode = getStatusCode(OAuth2Parameters.getInstance().getAppConfig().getRedirectUri(),
                    OAuth2Parameters.getInstance().getAppConfig().getState(), OAuth2Parameters.getInstance().getAppConfig().getScope());

            if ( statusCode != 200 && statusCode != 301 && statusCode != 302 ) {
                SQUIoAuthHandler.getAuthCallback().onFailedAuthentication(new NonAuthorizedException());
                isSuccess = false;
            }
        }

        if (url.startsWith(OAuth2Parameters.getInstance().getAppConfig().getRedirectUri())) { // if we in our url schema
//            LoginSequencingActivity.getOauthWebView().setVisibility(View.GONE);
            // If we don't authorized
            if (!OAuth2Parameters.getInstance().getOauth().isAuthorized()) {
                if (null == Uri.parse(url).getQueryParameter("code")) {
                    // We just being the oauth2 authorization loop. So we redirect the client to
                    // Sequencing website and ask the user to allow our app to use his data.
                    String loginRedirectUrl = OAuth2Parameters.getInstance().getOauth().getLoginRedirectUrl();
                    view.loadUrl(loginRedirectUrl);

                } else {
                    // We came back from Sequencing website and if state argument matches with our
                    // state, then we proceed and exchange the authorization code that we are
                    // given in GET for the access and refresh tokens. The former will be used for
                    // authorization, when we make requests to Sequencing API.

                    try {
                        token = OAuth2Parameters.getInstance().getOauth().authorize(Uri.parse(url).getQueryParameter("code"),
                                Uri.parse(url).getQueryParameter("state"));
                    } catch (BasicAuthenticationFailedException e) {

                        Log.e(TAG, "An unsuccessful attempt to query to the API server", e);
                        Toast.makeText(context, "An unsuccessful attempt to query to the API server", Toast.LENGTH_SHORT).show();
                        SQUIoAuthHandler.getAuthCallback().onFailedAuthentication(e);
                        return;
                    }
                    SQUIoAuthHandler.getAuthCallback().onAuthentication(token);
                }
            }
            else {
                SQUIoAuthHandler.getAuthCallback().onAuthentication(token);
            }
        }
        super.onLoadResource(view, url);
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap facIcon) {
        Log.d(TAG, "Loading page started");
        LoginSequencingActivity.getOauthWebView().setVisibility(View.GONE);
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        Log.d(TAG, "Loading page finished");
        LoginSequencingActivity.getOauthWebView().setVisibility(View.VISIBLE);
    }

    private int getStatusCode(String redirectUri, String state, String scope) {
        String url = "https://sequencing.com/oauth2/authorize?" +
                "redirect_uri=" + redirectUri + "&response_type=code&" +
                "state=" + state + "&client_id=oAuth2%20Demo%20ObjectiveC&scope=" + scope +"&mobileMode=" + OAuth2Parameters.getInstance().getAppConfig().getMobileMode();

        Map<String, String> params = new HashMap<>(4);
        params.put("form_build_id", "form-vzYkPRFb1p46zaT7BZvwEG0UR0gpY_0mKibo9hr3kLI");
        params.put("form_token", "SEwvMR9d8SpGB4u41UCn09R86JQXJ2k5l1sU4kiSdOI");
        params.put("form_id", "oauth2_server_authorize_form");
        params.put("op", "Yes (I authorize access)");

        return HttpHelper.doPost(url, null, params);
    }
}
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
import com.sequencing.oauthdemo.config.ApplicationConfig;
import com.sequencing.oauthdemo.helper.JsonHelper;
import com.sequencing.oauthdemo.helper.NewHttpHelper;

import java.util.HashMap;
import java.util.Map;;

public class OauthWebViewClient extends WebViewClient {
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
            if (null == Uri.parse(url).getQueryParameter("code")) {
                // We just being the oauth2 authorization loop. So we redirect the client to
                // Sequencing website and ask the user to allow our app to use his data.
                redirectToSequencingWebsite(view);

            } else {
                // We came back from Sequencing website and if state argument matches with our
                // state, then we proceed and exchange the authorization code that we are
                // given in GET for the access and refresh tokens. The former will be used for
                // authorization, when we make requests to Sequencing API.

                if(Uri.parse(url).getQueryParameter("state").equals(ApplicationConfig.INSTANCE.getState())){

                    // You are to save these 2 tokens somewhere in a permanent storage, such as
                    // database. When access token expires, you will be able to use refresh
                    // token to fetch a new access token without need of re-authorization by
                    // user.
                    Map <String, String> tokens = getAccessAndRefreshTokens(url);
                    if (tokens == null){
                        Log.e(TAG, "Session does not contain access token");
                        Toast.makeText(context, "Session does not contain access token", Toast.LENGTH_SHORT).show();
                        return;
                    }

                    String resultJsonResponse = getResultJsonResponse(tokens.get("access_token"));
                    if (resultJsonResponse == null) {
                        Log.e(TAG, "An unsuccessful attempt to query to the API server");
                        Toast.makeText(context, "An unsuccessful attempt to query to the API server", Toast.LENGTH_SHORT).show();
                        return;
                    }

                    JsonArray resultArray = JsonHelper.toJsonArray(resultJsonResponse);

                    Intent intent = new Intent(context, ResultListActivity.class);
                    intent.putExtra("stringArray", JsonHelper.parseJsonArrayToStringArray(resultArray));
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    context.startActivity(intent);

                } else {
                    Log.e(TAG, "State argument mismatch.");
                    Toast.makeText(context, "State argument mismatch", Toast.LENGTH_SHORT).show();
                    return;
                }

            }
        }
        super.onLoadResource(view, url);
    }

    private void redirectToSequencingWebsite(WebView view) {
        String getRequestParams = "redirect_uri=" + ApplicationConfig.INSTANCE.getRedirectUri()
                + "&response_type=" + ApplicationConfig.INSTANCE.getResponseType()
                + "&state=" + ApplicationConfig.INSTANCE.getState()
                + "&client_id=" + ApplicationConfig.INSTANCE.getClientId()
                + "&scope=" + ApplicationConfig.INSTANCE.getScope();

        view.loadUrl(ApplicationConfig.INSTANCE.getOAuthAuthorizationUri() + "?" + getRequestParams);
    }

    private Map <String, String> getAccessAndRefreshTokens(String url){
        String code = Uri.parse(url).getQueryParameter("code");

        Map<String, String> params = new HashMap<String, String>();
        params.put("grant_type", ApplicationConfig.INSTANCE.getGrantType());
        params.put("code", code);
        params.put("redirect_uri", ApplicationConfig.INSTANCE.getRedirectUri());

        Map<String, String> headers = NewHttpHelper.getBasicAuthenticationHeader(ApplicationConfig.INSTANCE.getClientId(),
                ApplicationConfig.INSTANCE.getClientSecret());

        String oauth2_token_uri = ApplicationConfig.INSTANCE.getOAuthTokenUri();

        String result = NewHttpHelper.doPost(oauth2_token_uri, headers, params);

        if (result == null) {
            Log.e(TAG, "An unsuccessful attempt to get the token");
            return null;
        }

        String accessToken = JsonHelper.getField(result, "access_token");
        String refreshToken = JsonHelper.getField(result, "refresh_token");

        Map <String, String> tokens = new HashMap<String, String>();
        tokens.put("access_token", accessToken);
        tokens.put("refresh_token", refreshToken);

        return tokens;
    }

    private String getResultJsonResponse(String accessToken){
        String uri = String.format("%s/DataSourceList?sample=true", ApplicationConfig.INSTANCE.getApiUri());

        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Authorization", "Bearer " + accessToken);

        String result = NewHttpHelper.doGet(uri, headers);
        return  result;
    }
}
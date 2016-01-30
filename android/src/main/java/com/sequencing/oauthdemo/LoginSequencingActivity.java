package com.sequencing.oauthdemo;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebView;


public class LoginSequencingActivity extends AppCompatActivity {
    private WebView myWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sequencing_login);

        OauthWebViewClient oauthWebViewClient = new OauthWebViewClient(this.getApplicationContext());

        myWebView = (WebView) findViewById(R.id.webView);
        myWebView.setWebViewClient(oauthWebViewClient);
        myWebView.loadUrl(oauthWebViewClient.getAppConfig().getRedirectUri());
    }
}

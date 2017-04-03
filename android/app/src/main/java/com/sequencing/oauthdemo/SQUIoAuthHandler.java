package com.sequencing.oauthdemo;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.sequencing.oauth.config.AuthenticationParameters;

/**
 * Class determines basic action in relation to Sequencing.com
 */
public class SQUIoAuthHandler {

    /**
     * App context
     */
    private Context context;

    /**
     * User callback of authentication
     */
    private static ISQAuthCallback authCallback;

    public SQUIoAuthHandler(Context context){
        this.context = context;
    }

    /**
     * Authenticate user and execute user callback
     * @param viewLogin authentication listener
     * @param authCallback user callback of authentication
     * @param parameters configuration parameters needed to carry on authentication
     * against sequencing.com backend
     */
    public void authenticate(View viewLogin, final ISQAuthCallback authCallback, AuthenticationParameters parameters){
        if (authCallback == null)
            throw new RuntimeException();
        this.authCallback = authCallback;
        OAuth2Parameters.getInstance().setParameters(parameters);

        viewLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, LoginSequencingActivity.class);
                context.startActivity(intent);
            }
        });
    }

    public void logout() {
        OAuth2Parameters.getInstance().cleanSequencingOAuth2Client();
    }
    public static ISQAuthCallback getAuthCallback(){
        return authCallback;
    }
}

package com.sequencing.oauthdemo;

import com.sequencing.oauth.config.AuthenticationParameters;
import com.sequencing.oauth.core.DefaultSequencingOAuth2Client;
import com.sequencing.oauth.core.SequencingOAuth2Client;

/**
 * Definition parameters for Sequencing oAuth2 authentication
 * and files API
 */
public class OAuth2Parameters {

    /**
     * Sequencing oAuth2 authentication client
     */
    private SequencingOAuth2Client oauth;

    /**
     * Define basic parameters for authentication
     */
    private AuthenticationParameters parameters;

    private static final OAuth2Parameters instance = new OAuth2Parameters();

    private OAuth2Parameters(){}

    public static OAuth2Parameters getInstance(){
        return instance;
    }

    public void setParameters(AuthenticationParameters parameters) {
        OAuth2Parameters.instance.parameters = parameters;
    }

    public AuthenticationParameters getAppConfig() {
        return parameters;
    }

    public SequencingOAuth2Client getOauth(){
        if(oauth == null){
            oauth = new DefaultSequencingOAuth2Client(getAppConfig());
        }
        return oauth;
    }

    public void cleanSequencingOAuth2Client() {
        oauth = null;
    }
}

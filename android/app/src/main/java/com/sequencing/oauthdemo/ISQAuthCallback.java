package com.sequencing.oauthdemo;

import com.sequencing.oauth.core.Token;

public interface ISQAuthCallback {

    /**
     * Callback for handling success authentication
     * @param token token of success authentication
     */
    void onAuthentication(Token token);

    /**
     * Callback of handling failure authentication
     * @param e exception of failure
     */
    void onFailedAuthentication(Exception e);
}

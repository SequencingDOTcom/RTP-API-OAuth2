package com.sequencing.oauthclient.controller;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.sequencing.oauthclient.config.OAuthClientConfig;

public class BaseController {
    
    @Autowired
    private OAuthClientConfig appConfig;
    
    public OAuthClientConfig getAppConfig() {
        return appConfig;
    }
    
    public Logger getLogger() {
        return Logger.getLogger(getClass());
    }
}

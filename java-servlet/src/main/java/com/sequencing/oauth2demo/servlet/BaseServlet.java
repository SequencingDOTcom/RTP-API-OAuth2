package com.sequencing.oauth2demo.servlet;

import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;

import com.sequencing.oauth2demo.config.ApplicationConfig;

public class BaseServlet extends HttpServlet {
    
    private ApplicationConfig appConfig = ApplicationConfig.INSTANCE;
    
    public ApplicationConfig getAppConfig() {
        return appConfig;
    }
    
    public Logger getLogger() {
        return Logger.getLogger(getClass());
    }
}

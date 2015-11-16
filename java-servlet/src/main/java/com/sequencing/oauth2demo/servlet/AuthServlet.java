package com.sequencing.oauth2demo.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthServlet extends BaseServlet {
    
    @Override
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response) throws ServletException, IOException {
             
        response.sendRedirect(
                String.format("%s?redirect_uri=%s&response_type=%s&state=%s&client_id=%s&scope=%s", 
                        getAppConfig().getOAuthAuthorizationUri(),
                        getAppConfig().getRedirectUri(), getAppConfig().getResponseType(),
                        getAppConfig().getState(), getAppConfig().getClientId(), getAppConfig().getScope()));
    }
}

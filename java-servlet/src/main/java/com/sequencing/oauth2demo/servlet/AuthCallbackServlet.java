package com.sequencing.oauth2demo.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sequencing.oauth2demo.helper.HttpHelper;
import com.sequencing.oauth2demo.helper.JsonHelper;

public class AuthCallbackServlet extends BaseServlet {

    public void doGet(HttpServletRequest request, 
                      HttpServletResponse response) throws ServletException, IOException {
        String state = (String) request.getParameter("state");
        String code = (String) request.getParameter("code");     
        
        if (state.equals(getAppConfig().getState())) {
            Map<String, String> params = new HashMap<String, String>();
            params.put("grant_type", getAppConfig().getGrantType());
            params.put("code", code);
            params.put("redirect_uri", getAppConfig().getRedirectUri());
            
            Map<String, String> headers = HttpHelper.getBasicAuthenticationHeader(getAppConfig().getClientId(), 
                                                                                  getAppConfig().getClientSecret());
                      
            String uri = getAppConfig().getOAuthTokenUri();
            
            String result = HttpHelper.doPost(uri, headers, params);
            
            if (result == null) {
                request.setAttribute("error", "An unsuccessful attempt to get the token");
                request.getRequestDispatcher("/error").forward(request, response);
                return;
            }
            
            String accessToken = JsonHelper.getField(result, "access_token");
            request.getSession().setAttribute("access_token", accessToken);
            
            response.sendRedirect("/authorization-approved");
        }
    }
}

package com.sequencing.oauth2demo.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sequencing.oauth2demo.helper.HttpHelper;
import com.sequencing.oauth2demo.helper.JsonHelper;

public class ApiServlet extends BaseServlet {
    
    @Override
    public void doGet(HttpServletRequest request, 
                      HttpServletResponse response) throws ServletException, IOException {
        
        String token = (String) request.getSession().getAttribute("access_token");
        if (token == null) {
            getLogger().warn("Session does not contain access token");
            request.setAttribute("error", "Session does not contain access token");
            request.getRequestDispatcher("/error").forward(request, response);
            return;
        }

        String uri = String.format("%s/DataSourceList?sample=true", getAppConfig().getApiUri()); 
        
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Authorization", "Bearer " + token);
        
        String result = HttpHelper.doGet(uri, headers);
        
        if (result == null) {
            request.setAttribute("error", "An unsuccessful attempt to query to the API server");
            request.getRequestDispatcher("/error").forward(request, response);
            return;
        }       
        
        request.setAttribute("response_json", JsonHelper.toJsonArray(result));
        request.getRequestDispatcher("/apiResponse").forward(request, response);
    }

}

package com.sequencing.oauth2demo.servlet;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.sequencing.oauth.core.SequencingOAuth2Client;

public class AuthCallbackServlet extends HttpServlet
{
	private static final long serialVersionUID = -4498242591685198756L;
	private Logger logger = Logger.getLogger(getClass());
        
	private SequencingOAuth2Client oauthClient;
            
	@Override
	public void init(ServletConfig config) throws ServletException
	{
		oauthClient = (SequencingOAuth2Client) config.getServletContext().getAttribute(
				SequencingServletContextListener.CFG_OAUTH_HANDLER);
	}
                      
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String state = (String) request.getParameter("state");
		String code = (String) request.getParameter("code");
            
		try
		{
			oauthClient.authorize(code, state);
		}
		catch (Exception e)
		{
			logger.warn("Error happened during authentication: " + e.getMessage(), e);
            
                request.setAttribute("error", "An unsuccessful attempt to get the token");
                request.getRequestDispatcher("/error").forward(request, response);
                return;
            }
            
            response.sendRedirect("/authorization-approved");
        }
    }

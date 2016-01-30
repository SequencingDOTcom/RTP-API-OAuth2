package com.sequencing.oauth2demo.servlet;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sequencing.oauth.core.SequencingOAuth2Client;

public class AuthServlet extends HttpServlet
{
	private static final long serialVersionUID = -6577525886694468542L;
	private SequencingOAuth2Client oauthClient;
    
    @Override
	public void init(ServletConfig config) throws ServletException
	{
		oauthClient = (SequencingOAuth2Client) config.getServletContext().getAttribute(
				SequencingServletContextListener.CFG_OAUTH_HANDLER);
	}
             
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		if (oauthClient.isAuthorized()) {
			response.sendRedirect("/authorization-approved");
		} else {
			response.sendRedirect(oauthClient.getLoginRedirectUrl());
		}
    }
}

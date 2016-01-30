package com.sequencing.oauth2demo.servlet;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.sequencing.oauth.config.AuthenticationParameters;
import com.sequencing.oauth.core.DefaultSequencingFileMetadataApi;
import com.sequencing.oauth.core.DefaultSequencingOAuth2Client;
import com.sequencing.oauth.core.SequencingFileMetadataApi;
import com.sequencing.oauth.core.SequencingOAuth2Client;

public class SequencingServletContextListener implements ServletContextListener
{
	public static final String CFG_APPLICATION_CONFIG = "com.sequencing.oauth.config.AuthenticationParameters";
	public static final String CFG_FILE_HANDLER = "com.sequencing.oauth.core.AuthenticationParameters";
	public static final String CFG_OAUTH_HANDLER = "com.sequencing.oauth.core.SequencingOAuth2Client";
	
	public void contextInitialized(ServletContextEvent context)
	{
		AuthenticationParameters appConfig = getAppConfig();
		SequencingOAuth2Client oauthClient = getOauthClient(appConfig);
		SequencingFileMetadataApi fileHandler = getFileApi(oauthClient);
		
		context.getServletContext().setAttribute(CFG_APPLICATION_CONFIG, appConfig);
		context.getServletContext().setAttribute(CFG_OAUTH_HANDLER, oauthClient);
		context.getServletContext().setAttribute(CFG_FILE_HANDLER, fileHandler);
	}

	public void contextDestroyed(ServletContextEvent context)
	{
		context.getServletContext().removeAttribute(CFG_APPLICATION_CONFIG);
		context.getServletContext().removeAttribute(CFG_OAUTH_HANDLER);
		context.getServletContext().removeAttribute(CFG_FILE_HANDLER);
	}

	public AuthenticationParameters getAppConfig()
	{
		return new AuthenticationParameters.ConfigurationBuilder()
				.withRedirectUri("https://java-oauth-demo.sequencing.com/Default/Authcallback")
				.withClientId("oAuth2 Demo Java")
				.withClientSecret("vuwpK04r7ylcbe1oUJCrDXza7dj33ejcUkBY06jrmzYiYw8LEmd1IkUZnKBCmv-fiuIhQkCm_qNWoQ81eCsY7A")
				.build();
	}

	public SequencingFileMetadataApi getFileApi(SequencingOAuth2Client client) {
		return new DefaultSequencingFileMetadataApi(client);
	}

	public SequencingOAuth2Client getOauthClient(AuthenticationParameters config) {
		return new DefaultSequencingOAuth2Client(config);
	}
}

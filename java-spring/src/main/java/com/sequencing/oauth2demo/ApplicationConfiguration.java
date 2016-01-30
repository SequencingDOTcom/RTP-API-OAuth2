package com.sequencing.oauth2demo;

import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationConfiguration
{
	private String redirectUri;
	private String clientId;
	private String clientSecret;
	
	public String getRedirectUri()
	{
		return redirectUri;
	}
	public void setRedirectUri(String redirectUri)
	{
		this.redirectUri = redirectUri;
	}
	public String getClientId()
	{
		return clientId;
	}
	public void setClientId(String clientId)
	{
		this.clientId = clientId;
	}
	public String getClientSecret()
	{
		return clientSecret;
	}
	public void setClientSecret(String clientSecret)
	{
		this.clientSecret = clientSecret;
	}
	
	
}

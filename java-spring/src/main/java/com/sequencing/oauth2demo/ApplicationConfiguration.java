package com.sequencing.oauth2demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationConfiguration
{
	@Value("${redirectMapping}")
	private String redirectMapping;

    @Value("${redirectHost}")
    private String redirectHost;

    @Value("${clientId}")
	private String clientId;

    @Value("${clientSecret}")
	private String clientSecret;

	public String getRedirectMapping()
	{
		return redirectMapping;
	}

    public void setRedirectMapping(String redirectMapping)
	{
		this.redirectMapping = redirectMapping;
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

    public String getRedirectHost() {
        return redirectHost;
    }

    public void setRedirectHost(String redirectHost) {
        this.redirectHost = redirectHost;
    }
}

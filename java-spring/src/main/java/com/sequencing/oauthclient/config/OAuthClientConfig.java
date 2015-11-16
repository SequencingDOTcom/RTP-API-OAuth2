package com.sequencing.oauthclient.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

@Configuration
@Component
public class OAuthClientConfig {
    
    @Value("${oauthserver_uri}")
    private String oAuthServerUri;
    
    @Value("${api_uri}")
    private String apiUri;
    
    @Value("${redirect_uri}")
    private String redirectUri;
    
    @Value("${response_type}")
    private String responseType;
    
    @Value("${state}")
    private String state;
    
    @Value("${client_id}")
    private String clientId;
    
    @Value("${scope}")
    private String scope;
    
    @Value("${grant_type}")
    private String grantType;
    
    @Value("${client_secret}")
    private String clientSecret;
    
    public String getOAuthServerUri() {
        return oAuthServerUri;
    }
    
    public String getApiUri() {
        return apiUri;
    }
    
    public String getRedirectUri() {
        return redirectUri;
    }
    
    public String getResponseType() {
        return responseType;
    }
    
    public String getState() {
        return state;
    }
    
    public String getClientId() {
        return clientId;
    }
    
    public String getScope() {
        return scope;
    }
    
    public String getGrantType() {
        return grantType;
    }
    
    public String getClientSecret() {
        return clientSecret;
    }
}
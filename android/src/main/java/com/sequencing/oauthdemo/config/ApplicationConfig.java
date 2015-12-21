package com.sequencing.oauthdemo.config;

public class ApplicationConfig {
    public static ApplicationConfig INSTANCE = new ApplicationConfig();

    private ApplicationConfig() {}
    
    /**
     * URI of Sequencing oAuth2 where you can request user to authorize your app.
     */
    private String oAuthAuthorizationUri = "https://sequencing.com/oauth2/authorize";
    
    /**
     * URI of Sequencing oAuth2 where you can obtain access token.
     */
    private String oAuthTokenUri = "https://sequencing.com/oauth2/token";
    
    /**
     * Sequencing API endpoint.
     */
    private String apiUri = "https://api.sequencing.com";
    
    /**
     * Redirect URI of your oauth2 app, where it expects Sequencing oAuth2 to
     * redirect browser.
     */
    private String redirectUri = "authapp://Default/Authcallback";
    
    /**
     * Supply here 'code', which means you want to take 
     * the route of authorization code response.
     */
    private String responseType = "code";
    
    /**
     * oAuth2 state.
     * It should be some random generated string. State you sent to authorize URI
     * must match the state you get, when browser is redirected to the redirect URI
     * you provided.
     */
    private String state = "829f464ff4a14882911d8c9782b89e6e";
    
    /**
     * Id of your oauth2 app (oauth2 client).
     * You will be able to get this value from Sequencing website.
     */
    private String clientId = "oAuth2 Demo ObjectiveC";
    
    /**
     * Secret of your oauth2 app (oauth2 client).
     * You will be able to get this value from Sequencing website.
     * Keep this value private.
     */
    private String clientSecret = "RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g";
    
    /**
     * Scopes, access to which you request.
     */
    private String scope = "demo";
    
    /**
     * Supply here 'authorization_code', which means you request to 
     * exchange the authorization code for the aouth2 tokens.
     */
    private String grantType = "authorization_code";
    
    public String getOAuthAuthorizationUri() {
        return oAuthAuthorizationUri;
    }
    
    public String getOAuthTokenUri() {
        return oAuthTokenUri;
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
    
    public String getClientSecret() {
        return clientSecret;
    }
    
    public String getScope() {
        return scope;
    }
    
    public String getGrantType() {
        return grantType;
    }
}

package com.sequencing.oauth2demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import com.sequencing.oauth.config.AuthenticationParameters;
import com.sequencing.oauth.core.DefaultSequencingFileMetadataApi;
import com.sequencing.oauth.core.DefaultSequencingOAuth2Client;
import com.sequencing.oauth.core.SequencingFileMetadataApi;
import com.sequencing.oauth.core.SequencingOAuth2Client;

@Configuration
@EnableWebMvc
@SpringBootApplication
public class OAuth2Demo
{
    public static void main(String[] args) {
        SpringApplication.run(OAuth2Demo.class, args);
    }
    
    @Bean
    @Autowired
    public AuthenticationParameters getParameters(ApplicationConfiguration config)
    {
    	return new AuthenticationParameters.ConfigurationBuilder()
    			.withRedirectUri(config.getRedirectUri())
    			.withClientId(config.getClientId())
    			.withClientSecret(config.getClientSecret())
				.build();
    }
    
    @Bean
    @Autowired
    public SequencingOAuth2Client getOauth(AuthenticationParameters parameters) {
    	return new DefaultSequencingOAuth2Client(parameters);
    }
    
    @Bean
    @Autowired
    public SequencingFileMetadataApi getFileMetadataApi(SequencingOAuth2Client client) {
    	return new DefaultSequencingFileMetadataApi(client);
    }
}

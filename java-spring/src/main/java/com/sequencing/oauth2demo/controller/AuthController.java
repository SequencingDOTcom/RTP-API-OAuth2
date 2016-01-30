package com.sequencing.oauth2demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sequencing.oauth.config.AuthenticationParameters;
import com.sequencing.oauth.core.SequencingOAuth2Client;

/**
 * We just being the oauth2 authorization loop. So we redirect the client to
 * Sequencing website and ask the user to allow our app to use his data.
 */
@Controller
public class AuthController
{
	@Autowired
	private SequencingOAuth2Client oauth;

	@Autowired
	private AuthenticationParameters parameters;

	@RequestMapping("/")
	public String authorize(Model model) {

		if (oauth.isAuthorized()) { // If we have authorized
			return "redirect:/authorization-approved";
		} else {
			model.addAllAttributes(oauth.getHttpParametersForRedirect());
			return "redirect:" + parameters.getOAuthAuthorizationUri();
		}
	}
}

package com.sequencing.oauth2demo.controller;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.sequencing.oauth.core.SequencingOAuth2Client;

/**
 * We came back from Sequencing website and if state argument matches with our
 * state, then we proceed and exchange the authorization code that we are given
 * in GET for the access token. The former will be used for authorization, when
 * we make requests to Sequencing API.
 */
@Controller
public class AuthCallbackController
{
	@Autowired
	private SequencingOAuth2Client oauth;
	
	private Logger logger = Logger.getLogger(getClass());;

	@RequestMapping(value = "/Default/Authcallback", method = RequestMethod.GET, params = { "state", "code" })
	public ModelAndView authCallbackResponse(@RequestParam("state") String state, @RequestParam("code") String code) {
		ModelAndView mav = new ModelAndView();

		try {
			oauth.authorize(code, state);
		} catch (Exception e) {
			logger.warn("An unsuccessful attempt to get the token", e);
			mav.addObject("error", "An unsuccessful attempt to get the token");
            mav.setViewName("error");
            return mav;
		}
		
		mav.setViewName("redirect:/authorization-approved");
		return mav;
	}
}

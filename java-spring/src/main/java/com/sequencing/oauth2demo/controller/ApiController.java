package com.sequencing.oauth2demo.controller;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.sequencing.oauth.core.SequencingFileMetadataApi;
import com.sequencing.oauth.exception.NonAuthorizedException;
import com.sequencing.oauth.helper.JsonHelper;


/**
 * We make API requests after success authorization.
 */
@Controller
public class ApiController {
	
	@Autowired
	private SequencingFileMetadataApi fileApi;
	
	private Logger logger = Logger.getLogger(getClass());;
	
    @RequestMapping("/authorization-approved")
    public ModelAndView getResponse(HttpSession session) {
        ModelAndView mav = new ModelAndView();
		String result = null;
		try {
			result = fileApi.getSampleFiles();
		} catch (NonAuthorizedException e) {
			logger.warn("App does not contain access token", e);
			e.printStackTrace();
		}
        
        if (result == null) {
            mav.addObject("error", "An unsuccessful attempt to query to the API server");
            mav.setViewName("error");
            return mav;
        }
        
        mav.addObject("response_json", JsonHelper.toJsonArray(result));
        mav.setViewName("apiResponse");
        return mav;
    }
}

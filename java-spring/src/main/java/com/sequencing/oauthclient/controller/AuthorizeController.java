package com.sequencing.oauthclient.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AuthorizeController extends BaseController {

    @RequestMapping("/")
    public String authorize(Model model) {
        model.addAttribute("redirect_uri", getAppConfig().getRedirectUri());
        model.addAttribute("response_type", getAppConfig().getResponseType());
        model.addAttribute("state", getAppConfig().getState());
        model.addAttribute("client_id", getAppConfig().getClientId());
        model.addAttribute("scope", getAppConfig().getScope());

        return "redirect:" + getAppConfig().getOAuthServerUri() + "/authorize";
    }
}

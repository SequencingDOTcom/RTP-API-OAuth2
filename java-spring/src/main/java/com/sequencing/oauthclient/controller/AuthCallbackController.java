package com.sequencing.oauthclient.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicHeader;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sequencing.oauthclient.helper.HttpHelper;

@Controller
public class AuthCallbackController extends BaseController {

    @RequestMapping(value = "/Default/Authcallback", params = { "state", "code" })
    public String authCallbackResponse(@RequestParam("state") String state, @RequestParam("code") String code,
            HttpSession session) throws UnsupportedEncodingException {

        String sessionState = getAppConfig().getState();

        if (state.equals(sessionState)) {
            
            String encoded = DatatypeConverter.printBase64Binary(
                    (getAppConfig().getClientId() + ":" + getAppConfig().getClientSecret()).getBytes("UTF-8"));

            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("grant_type", getAppConfig().getGrantType()));
            params.add(new BasicNameValuePair("code", code));
            params.add(new BasicNameValuePair("redirect_uri", getAppConfig().getRedirectUri()));       

            String uri = getAppConfig().getOAuthServerUri() + "/token";
            String result = HttpHelper.doPost(uri, new BasicHeader("Authorization", "Basic " + encoded), params);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode;
            try {
                rootNode = mapper.readTree(result);

                String accessToken = rootNode.get("access_token").asText();

                session.setAttribute("access_token", accessToken);
            } catch (JsonProcessingException e) {
                getLogger().warn("Json proccession error", e);
            } catch (IOException e) {
                getLogger().warn("IO error", e);
            }

            return "redirect:/authorization-approved";
        }
        return null;
    }
}

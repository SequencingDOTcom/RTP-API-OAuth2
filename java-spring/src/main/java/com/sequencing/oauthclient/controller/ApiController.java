package com.sequencing.oauthclient.controller;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.apache.http.message.BasicHeader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sequencing.oauthclient.helper.HttpHelper;

@Controller
public class ApiController extends BaseController {

    @RequestMapping("/authorization-approved")
    public String getResponse(Model model, HttpSession session) {
        String token = (String) session.getAttribute("access_token");
        if (token == null) {
            getLogger().warn("Session does not contain access token");
            return null;
        }

        String uri = getAppConfig().getApiUri() + "/DataSourceList?sample=true";
        String result = HttpHelper.doGet(uri, new BasicHeader("Authorization", "Bearer " + token));

        ObjectMapper mapper = new ObjectMapper();
        JsonNode rootNode;
        try {
            rootNode = mapper.readTree(result);
            model.addAttribute("response_json", rootNode);
        } catch (JsonProcessingException e) {
            getLogger().warn("Json proccession error", e);
        } catch (IOException e) {
            getLogger().warn("IO error", e);
        }

        return "apiResponse";
    }
}

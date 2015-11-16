package com.sequencing.oauth2demo.helper;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.DatatypeConverter;

import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

public class HttpHelper {

    private static final Logger logger = Logger.getLogger(HttpHelper.class);

    private static final HttpClient client = HttpClientBuilder.create().build();
    
    public static String doGet(String uri, Map<String, String> headers) {
        BufferedReader reader = null;
        try {
            HttpGet get = new HttpGet(uri);

            if (headers != null) {
                for (Map.Entry<String, String> h : headers.entrySet())
                    get.addHeader(h.getKey(), h.getValue());
            }
            
            HttpResponse response = client.execute(get);

            if (response.getStatusLine().getStatusCode() != 200) {
                logger.warn("HTTP get request error: " + response.getStatusLine().getStatusCode());
            }

            reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

            StringBuffer result = new StringBuffer();
            String line = null;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }

            return result.toString();
        } catch (Exception e) {
            logger.warn("Http client error", e);
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) { }
        }
        return null;
    }

    public static String doPost(String uri, Map<String, String> headers, Map<String, String> params) {
        BufferedReader reader = null;
        try {
            HttpPost post = new HttpPost(uri);
            
            if (headers != null) {
                for (Map.Entry<String, String> h : headers.entrySet())
                    post.addHeader(h.getKey(), h.getValue());
            }
            
            if (params != null) {
                List<NameValuePair> pairs = new ArrayList<NameValuePair>();
                for (Map.Entry<String, String> p : params.entrySet())
                    pairs.add(new BasicNameValuePair(p.getKey(), p.getValue()));
                    
                post.setEntity(new UrlEncodedFormEntity(pairs));
            }

            HttpResponse response = client.execute(post);

            if (response.getStatusLine().getStatusCode() != 200) {
                logger.warn("HTTP post request error: " + response.getStatusLine().getStatusCode());
            }

            reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

            StringBuffer result = new StringBuffer();
            String line = null;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }

            return result.toString();
        } catch (Exception e) {
            logger.warn("Http client error", e);
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) { }
        }
        return null;
    }
    
    public static Map<String, String> getBasicAuthenticationHeader(String username, String password) {
        try {
            String encoded = DatatypeConverter.printBase64Binary((username + ":" + password).getBytes("UTF-8"));
            Map<String, String> header = new HashMap<String, String>();
            header.put("Authorization", "Basic " + encoded);
            return header;
        } catch (UnsupportedEncodingException e) {
            logger.warn("Unsupported encoding", e);
        }
        return null;
    }
}
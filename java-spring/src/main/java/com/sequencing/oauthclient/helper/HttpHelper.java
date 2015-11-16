package com.sequencing.oauthclient.helper;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import java.util.List;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.log4j.Logger;
import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

public class HttpHelper {

    private static final Logger logger = Logger.getLogger(HttpHelper.class);

    private static final HttpClient client = HttpClientBuilder.create().build();

    public static String doGet(String uri, Header header) {
        try {
            HttpGet get = new HttpGet(uri);

            if (header != null) {
                get.addHeader(header);
            }
            
            HttpResponse response = client.execute(get);

            if (response.getStatusLine().getStatusCode() != 200) {
                logger.warn("HTTP get request error: " + response.getStatusLine().getStatusCode());
            }

            BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

            StringBuffer result = new StringBuffer();
            String line = null;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }

            return result.toString();
        } catch (ClientProtocolException e) {
            logger.warn("Http client protocol error", e);
        } catch (IOException e) {
            logger.warn("IO error", e);
        }
        return null;
    }

    public static String doPost(String uri, Header header, List<NameValuePair> params) {
        try {
            HttpPost post = new HttpPost(uri);
            
            if (header != null) {
                post.addHeader(header);
            }
            
            if (params != null) {
                post.setEntity(new UrlEncodedFormEntity(params));
            }

            HttpResponse response = client.execute(post);

            if (response.getStatusLine().getStatusCode() != 200) {
                logger.warn("HTTP post request error: " + response.getStatusLine().getStatusCode());
            }

            BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

            StringBuffer result = new StringBuffer();
            String line = null;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }

            return result.toString();
        } catch (ClientProtocolException e) {
            logger.warn("Http client protocol error", e);
        } catch (IOException e) {
            logger.warn("IO error", e);
        }
        return null;
    }
}

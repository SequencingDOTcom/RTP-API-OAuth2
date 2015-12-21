package com.sequencing.oauthdemo.helper;

import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.apache.commons.codec.binary.Base64;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

public class HttpHelper {
    private static final String TAG = "HttpHelper";

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
                Log.e(TAG, "HTTP get request error: " + response.getStatusLine().getStatusCode());
            }

            reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

            StringBuffer result = new StringBuffer();
            String line = null;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }

            return result.toString();
        } catch (Exception e) {
            Log.e(TAG, "Http client error " + e.getMessage());
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
                Log.e(TAG, "HTTP post request error: " + response.getStatusLine().getStatusCode());
            }

            reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

            StringBuffer result = new StringBuffer();
            String line = null;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }

            return result.toString();
        } catch (Exception e) {
            Log.e(TAG, "Http client error " + e.getMessage());
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
        byte[] encodedBytes = Base64.encodeBase64((username + ":" + password).getBytes());
        String encoded = new String(encodedBytes);
        Map<String, String> header = new HashMap<String, String>();
        header.put("Authorization", "Basic " + encoded);
        return header;
    }
}